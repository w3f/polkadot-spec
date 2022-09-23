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

    Base64DataUriRx = %r{data:(?<mimetype>\w[\w-]*/\w[\w+-]*);base64,(?<base64>[\w+/]+=*)}

    # Fixes read_contents to support data uris
    def read_contents(target, opts = {})
      if (uri = Base64DataUriRx.match target)
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
          completed = self.fullfill id

          # ... recursivly ...
          additional = completed
          until (additional = additional.map { |dep| self.fullfill dep }.flatten).empty?
            completed += additional
          end

          logger.info "registration of '#{id}': completed = #{completed}"

          # ... and process now completed blocks
          completed.each { |other| @blocks[other].generate }
        else
          logger.info "registration of '#{id}': missing = #{@missing[id]}"
        end

        @missing[id].empty?
      end

      def subtype(id)
        @blocks[id].as_subtype
      end

      def definition(id)
        @blocks[id].definition :standalone
      end

      def paths(ids)
        result = {}
        remaining = [ [[], ids] ]
        while ((path, children) = remaining.pop)
          for child in children
            if !result.include? child
              result[child] = path + [ child ]
              remaining.push [result[child], @blocks[child].dependencies]
            end
          end
        end
        result
      end

      private

      # Determine if all depency of block are defined
      def defined?(id)
        @missing[id] && @missing[id].empty?
      end

      # Fullfill dependency and return completed blocks
      def fullfill(id)
        @missing.filter { |_, deps| (deps.delete id) && deps.empty? }.keys
      end
    end
  end

  # Wrapper around block to allow out of order resolution of includes
  class Block < Asciidoctor::PatchedBlock

    VALID_MODES = [ 'individual', 'standalone', 'hierachical' ].freeze

    CAPTION_PREFIX = 'Binary Format'

    GRAPHVIZ_NODE_ID = Regexp.new '([a-z_]+) \[label=<<TABLE'

    attr_reader :dependencies

    def initialize(parent, body, attrs)
      @body = body

      # Check id and title
      id = attrs['id']
      title = attrs.key?('title') ? attrs.delete('title') : nil

      raise "Invalid kaitai identifier: #{id}" unless id.match?(/^[a-z][a-z0-9_]*$/)

      attrs['alt'] ||= (attrs['default-alt'] = title || "Kaitai Struct generated graph")

      super parent, :image, { source: nil, attributes: attrs, content_model: :empty }

      # Cache document tree based attributes
      @dependencies = attr('kaitai-dependencies', '', true).split(',')
      @imports = attr('kaitai-imports', '', true).split(',')

      mode = attr 'kaitai-mode', 'individual', true
      raise "Unknown mode '#{mode}', expected on of #{VALID_MODES}" unless VALID_MODES.include? mode
      @mode = mode.to_sym

      @import_dir = attr 'docdir', nil, true

      # Skip render step if we are just exporting
      @skip = parent.document.backend == 'kaitai'

      if title
        @title = title
        @numeral = @document.increment_and_store_counter 'kaitai-number', self
        @caption = "Binary Format #{@numeral}. "
      end
    end

    # Generate any outputs included in the document
    def generate
      return if @skip

      Dir.mktmpdir('asciidoctor-kaitai-') do |tmpdir|
        export tmpdir
        output = compile tmpdir
        render tmpdir, output

        logger.info "generated '#{output.dig :graphviz, :main}': imports = #{output.dig :graphviz, :deps}"
      end
    end

    # Return full definition, header and body
    def definition(mode)
      (head mode).merge(body mode)
    end

    # Return only body, to be used as subtype
    def as_subtype
      body :standalone
    end

    private

    # Return imports in definition
    def imports(mode)
      case mode
      when :individual
        @imports + @dependencies
      when :standalone
        @imports
      when :hierachical
        @imports + (@dependencies.any? ? ['dependencies'] : [])
      end
    end

    # Return head of definition
    def head(mode)
      { 'meta' => {
          'id' => @attributes['id'],
          'title' => @title,
          'endian' => "le",
          'imports' => (imports mode)
      } }
    end

    # Return body of definition
    def body(mode)
      doc = @body
      if mode == :standalone and @dependencies.any?
        doc['types'] ||= {}
        @dependencies.each { |inc| doc['types'][inc] = Registry.subtype inc }
      end
      doc
    end

    # Run kaitai struct compiler and parse result
    def run(path, file, target)
      # Compile graphviz graph
      input = File.join(path, file)
      result_raw = `ksc --target #{target} --ksc-json-output --outdir #{path} #{input}`

      result = JSON.parse(result_raw).dig(input)
      raise "Failed to parse ksc json output: #{result_raw}" if result.nil?

      # Raise any errors provided by kaitai
      if (error = result.dig 'errors', 0)
        msg, path, line, col = error.values_at('message', 'path', 'line', 'col')
        where = path.nil? ? " l=#{line} c=#{col}" : "/#{(path || [""]).join('/')}"
        raise "kaitai error at #{id}#{where}: #{msg}"
      end

      result_target = result.dig('output', target)
      raise "Failed to parse graphviz output: #{result}" if result_target.nil?
      result_target
    end

    # Write definitions of block and its dependencies to path
    def export(path)
      # Export main file
      output_name = "#{@attributes['id']}.ksy"
      File.open(File.join(path, output_name), 'w') do |fs|
        fs.write (definition @mode).to_yaml
      end

      # Write dependencies if not standalone
      import_names = []

      case @mode
      when :individual
        @dependencies.each do |dep|
          File.open(File.join(path, "#{dep}.ksy"), 'w') do |fs|
            fs.write Registry.definition(dep).to_yaml
          end
        end

        import_names = @dependencies.map { |dep| "#{dep}.ksy" }
      when :hierachical
        doc = {
          'meta' => {
            'id' => @attributes['id'],
            'title' => 'Autogenerated dependencies',
            'endian' => "le",
            'imports' => @imports
          },
          'types' => {}
        }

        Registry.paths(@dependencies).each do |dep, path|
          final = path.delete_at(-1)
          current = doc['types']

          for p in path
            if !current.include? p
              current[p] = { 'types' => {} }
            end

            current = current[p]['types']
          end

          current[final] = Registry.subtype(dep)
        end

        if @dependencies.any?
          File.open(File.join(path, "dependencies.ksy"), 'w') do |fs|
            fs.write doc.to_yaml
          end

          import_names = [ "dependencies.ksy" ]
        end
      end

      { kaitai: { main: output_name, deps: import_names } }
    end

    # Compile exported definitions at specified path
    def compile(path)
      # Copy any imports (NOT dependencies)
      @imports.each { |name| FileUtils.cp(File.join(@import_dir, "#{name}.ksy"), path) }

      id = @attributes['id']

      # Compile dependecies first to determine graphviz node names
      if @mode == :hierachical and @dependencies.any?
        result = run path, "dependencies.ksy", 'graphviz'

        deps = result.dig(id, 'files', 0, 'fileName')
        raise "Failed to parse graphviz output: #{result}" if deps.nil?

        FileUtils.cp(File.join(path, deps), File.join(path, 'dependencies.dot'))
      end

      # Compile graphviz graph and determine output files
      result = run path, "#{id}.ksy", 'graphviz'

      if @mode == :hierachical and @dependencies.any?
        # Ugly head to work around the fact that outputs are based on meta.id
        result['dependencies'] = { 'files' => [{ 'fileName' => 'dependencies.dot' }] }
      end

      output_name = result.dig(id, 'files', 0, 'fileName')
      import_names = (imports @mode).map { |name| result.dig(name, 'files', 0, 'fileName') }

      { graphviz: { main: output_name, deps: import_names } }
    end

    def render(path, output)
      # Extract graphviz nodes from inputs
      excludes = output.dig(:graphviz, :deps).map { |name|
        File.readlines(File.join(path, name), encoding: 'UTF-8')
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

        File.readlines(backup_path, encoding: 'UTF-8').reject { |line|
          excludes.any? { |ex| line.match? (/-> #{ex}/) or line.match? (/#{ex}:.* ->/) }
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

  # Simple converter that extract kaitai definition based on file name of output
  class Converter < Asciidoctor::Converter::Base
    register_for 'kaitai'

    # Use basename of output file to determine target definition
    def initialize(_, opts = {})
      @target = Asciidoctor::Helpers.basename opts[:document].options[:to_file], true
    end

    # Find target kaitai block in document and return its definition
    def convert(document, transform = nil, _ = nil)
      if transform == 'document'
        document.find_by(context: :image).each do |node|
          return node.definition(:standalone).to_yaml if node.class == Block && node.attr('id') == @target
        end
        raise "Failed to locate katai definition for '#{@target}'"
      end
      ''
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
