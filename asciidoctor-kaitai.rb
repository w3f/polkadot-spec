require 'asciidoctor/extensions'
require 'asciidoctor/helpers'
require 'asciidoctor/logging'

require 'json'
require 'yaml'
require 'tempfile'
require 'fileutils'

module Asciidoctor
  # Fixes to block that probably should be upstreamed
  class PatchedBlock < Block

    Base64DataURIRx = %r{data:(?<mimetype>\w[\w-]*/\w[\w+-]*);base64,(?<base64>[\w+/]+=*)}

    # Fixes read_contents to support data uris
    def read_contents(target, opts = {})
      if (uri = Base64DataURIRx.match target)
        # TODO: What to do with uri[:mimetype] ?
        return Base64.strict_decode64(uri[:base64]).force_encoding('UTF-8')
      end

      super target, opts
    end
  end
end

# Simple index that allows blocks to resolve each others definition
module Kaitai
  class Registry

    include Asciidoctor::Logging

    @blocks = {}
    @missing = {}

    class << self

      def register(id, block)
        # Register new block
        @blocks[id] = block
        @missing[id] = block.dependencies.reject { |dep| self.defined? dep }

        if @missing[id].empty?
          # Update missing dependencies ...
          completed = @missing.filter { |_, deps| (deps.delete id) && deps.empty? }.keys

          # ... and process now completed blocks
          completed.each { |other| @blocks[other].generate }

          logger.info "registration of #{id}': completed = #{completed}"
        else
          logger.info "registration of #{id}': missing = #{@missing[id]}"
        end

        @missing[id].empty?
      end

      def defined?(id)
        @missing[id] && @missing[id].empty?
      end

      def subtype(id)
        @blocks[id].as_subtype
      end

      def definition(id)
        @blocks[id].definition true
      end
    end
  end

  # Wrapper around block to allow out of order resolution of includes
  class Block < Asciidoctor::PatchedBlock

    CAPTION_PREFIX = 'Binary Format'

    GRAPHVIZ_NODE_ID = Regexp.new '([a-z_]+) \[label=<<TABLE'

    def initialize(parent, body, attrs)
      @body = body

      # Check id and title
      id = attrs['id']
      title = attrs.key?('title') ? attrs.delete('title') : nil

      raise "Invalid kaitai identifier: #{id}" unless id.match?(/^[a-z][a-z0-9_]*$/)

      attrs['alt'] ||= (attrs['default-alt'] = title || "Kaitai Struct generated graph")

      super parent, :image, { source: nil, attributes: attrs, content_model: :empty }

      if title
        @title = title
        @numeral = @document.increment_and_store_counter 'kaitai-number', self
        @caption = "Binary Format #{@numeral}. "
      end

    end

    def generate
      Dir.mktmpdir('asciidoctor-kaitai-') do |tmpdir|
        export tmpdir, false
        output = compile tmpdir, false
        render tmpdir, output

        logger.info "generated '#{output.dig :graphviz, :main}': imports = #{output.dig :graphviz, :deps}"
      end

      if @attributes.key? 'kaitai-export'
        outdir = attr 'docdir', nil, true
        output = export outdir, true

        logger.info "exported '#{output.dig :kaitai, :main}': imports = #{output.dig :kaitai, :deps}"
      end
    end

    def definition(combined = false)
      (head combined).merge(body combined)
    end

    def as_subtype
      body true
    end

    def dependencies
      attr('kaitai-dependencies', '', true).split(',')
    end

    private

    # Return imports in definition
    def imports(combined = false)
      result = attr('kaitai-imports', '', true).split(',')
      combined || result += dependencies
      result
    end

    # Return head of definition
    def head(combined)
      { 'meta' => {
          'id' => @attributes['id'],
          'title' => @title,
          'endian' => "le",
          'imports' => (imports combined)
      } }
    end

    # Return body of definition
    def body(combined)
      doc = @body
      if combined && dependencies
        doc['types'] ||= {}
        dependencies.each { |inc| doc['types'][inc] = Registry.subtype inc }
      end
      doc
    end

    # Write definitions of block and its dependencies to path
    def export(path, combined)
      # Export main file
      output_name = "#{@attributes['id']}.ksy"
      File.open(File.join(path, output_name), 'w') do |fs|
        fs.write (definition combined).to_yaml
      end

      # Write dependencies if not combined
      if !combined
        dependencies.each do |dep|
          File.open(File.join(path, "#{dep}.ksy"), 'w') do |fs|
            fs.write Registry.definition(dep).to_yaml
          end
        end
      end

      import_names = combined ? [] : dependencies.map { |dep| "#{dep}.ksy" }

      { kaitai: { main: output_name, deps: import_names } }
    end

    # Compile exported definitions at specified path
    def compile(path, combined)
      # Copy any imports (NOT dependencies)
      docdir = attr 'docdir', nil, true
      (imports true).each { |name| FileUtils.cp(File.join(docdir, "#{name}.ksy"), path) }

      id = @attributes['id']
      input_path = File.join(path, "#{id}.ksy")

      # Compile graphviz graph
      result_raw = `ksc --target graphviz --ksc-json-output --outdir #{path} #{input_path}`

      result = JSON.parse(result_raw).dig(input_path)
      raise "Failed to parse ksc json output: #{result_raw}" if result.nil?

      # Raise any errors provided by kaitai
      if (error = result.dig 'errors', 0)
        msg, path, line, col = error.values_at('message', 'path', 'line', 'col')
        where = path.nil? ? " l=#{line} c=#{col}" : "/#{(path || [""]).join('/')}"
        raise "kaitai error at #{id}#{where}: #{msg}"
      end

      # Determine graphviz outputs
      result_graphviz = result.dig('output', 'graphviz')
      raise "Failed to parse graphviz output: #{result}" if result_graphviz.nil?

      output_name = result_graphviz.dig(id, 'files', 0, 'fileName')
      import_names = (imports combined).map { |name| result_graphviz.dig(name, 'files', 0, 'fileName') }

      { graphviz: { main: output_name, deps: import_names } }
    end

    def render(path, output)
      # Extract graphviz nodes from inputs
      excludes = output.dig(:graphviz, :deps).map { |name|
        File.readlines(File.join(path, name))
            .map { |line| line.match(GRAPHVIZ_NODE_ID).to_a[1] }
            .reject &:nil?
      }.flatten

      output_name = output.dig(:graphviz, :main)
      output_path = File.join(path, output_name)

      # Remove all imported graphviz nodes
      if excludes
        backup_path = File.join(path, "#{output_name}.bak")
        FileUtils.cp(output_path, backup_path)

        output = File.new(output_path, 'w')

        File.readlines(backup_path).reject { |line|
          excludes.any? { |ex| line.match? /#{ex}/ }
        }.each { |line| output.puts line }

        output.close
      end

      # Convert and embed graphviz graph as inline svg
      target_base64 = Base64.strict_encode64 `dot -T svg #{output_path}`
      raise 'Failed to run graphviz' if target_base64.empty?

      @attributes['target'] = "data:image/svg+xml;base64,#{target_base64}"
      @attributes['format'] = 'svg'
      set_option 'interactive'
    end
  end

end

Asciidoctor::Extensions.register do
  # A block processor to render kaitai graphs
  block :kaitai do
    contexts :pass
    content_model :raw

    process do |parent, reader, attrs|
      body = YAML.safe_load reader.read
      block = Kaitai::Block.new parent, body, attrs
      block.generate if Kaitai::Registry.register attrs['id'], block
      block
    end
  end
end
