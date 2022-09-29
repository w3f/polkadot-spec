require 'asciidoctor/extensions'
require 'asciidoctor/helpers'
require 'asciidoctor/logging'

require 'json'
require 'yaml'
require 'tempfile'
require 'fileutils'

class Hash
  # Deep copy support for nested yaml hashmaps
  def deep_clone
    dup.transform_values do |val|
      case val.class
        when Hash  then val.deep_clone
        when Array then val.map(&:clone)
        else val.clone
      end
    end
  end
end

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

    @blocks = {}
    @missing = {}

    class << self

      # Create and register new block
      def new_block(parent, body, attrs)
        block = Block.new parent, body, attrs
        register(attrs['id'], block)
        block
      end

      # Register new kaitai definiton, will generate any completed definitions
      def register(id, block)
        # Register new block and any missing dependencies
        @blocks[id] = block
        @missing[id] = (block.dependencies :individual).reject { |dep| self.defined? dep }

        # Nothing more to do if new block has missing dependencies ...
        return unless @missing[id].empty?

        # ...otherwise generate the block and update possible dependants
        block.generate if @missing[id].empty?

        # - Update missing dependencies ...
        completed = self.fulfill id

        # - ... recursivly ...
        additional = completed
        until (additional = additional.map { |dep| self.fulfill dep }.flatten).empty?
          completed += additional
        end

        # - ... and process now completed blocks
        completed.each { |other| @blocks[other].generate }
      end

      # Return subtype definition by id from registry
      def subtype(id)
        @blocks[id].as_subtype
      end

      # Return full definition by id from registry
      def definition(id)
        @blocks[id].definition :standalone
      end

      # Determine dependency tree paths for list of ids
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

      # Fulfill dependency and return completed blocks
      def fulfill(id)
        @missing.filter { |_, deps| (deps.delete id) && deps.empty? }.keys
      end
    end
  end

  # Wrapper around block to allow out of order resolution of includes
  class Block < Asciidoctor::PatchedBlock

    VALID_MODES = [ 'individual', 'standalone', 'hierachical' ].freeze

    CAPTION_PREFIX = 'Binary Format'

    GRAPHVIZ_NODE_ID = Regexp.new '([a-z_]+) \[label=<<TABLE'
    GRAPHVIZ_LABEL = /label="(.*)";/

    # Initialize new block, mostly just wraps an image block
    def initialize(parent, body, attrs)
      @body = body

      # Check if id is compatible with kaitai
      id = attrs['id']
      raise "Invalid kaitai identifier: #{id}" unless id.match?(/^[a-z][a-z0-9_]*$/)

      # Asciidoctor integration for title and alt text
      title = attrs.key?('title') ? attrs.delete('title') : nil
      attrs['alt'] ||= (attrs['default-alt'] = title || "Kaitai Struct generated graph")

      # Initialize the block as an image without content (yet)
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

      # More asciidoctor integration
      if title
        # Emulate the way titles are set through high level api
        @title = title
        # - Use a separate counter for kaitai graphs
        @numeral = @document.increment_and_store_counter 'kaitai-number', self
        # - Use a custom caption
        @caption = "Binary Format #{@numeral}. "
      end
    end

    # Generate any outputs included in the document
    def generate
      return if @skip

      logger.info "generating kaitai graph '#{@attributes['id']}': imports = #{@imports} dependencies = #{dependencies @mode}"

      Dir.mktmpdir('asciidoctor-kaitai-') do |tmpdir|
        export tmpdir
        output = compile tmpdir
        render tmpdir, output
      end
    end

    # Return dependencies (part of imports) in definition
    def dependencies(mode)
      case mode
        when :individual  then @dependencies
        when :hierachical then @dependencies.any? ? ['dependencies'] : []
        else []
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

    # Return head of definition
    def head(mode)
      { 'meta' => {
          'id' => @attributes['id'],
          'title' => @title,
          'endian' => "le",
          'imports' => @imports + (dependencies mode)
      } }
    end

    # Return body of definition
    def body(mode)
      doc = @body.deep_clone

      # If standalone, add dependencies as substypes
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

      # Return result for specified target
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

      # Write any dependencies ...
      if @dependencies.any?
        # ...based on mode (and not standalone)
        case @mode
        when :individual
          # Individual means each dependency in a separate file
          @dependencies.each do |dep|
            File.open(File.join(path, "#{dep}.ksy"), 'w') do |fs|
              fs.write Registry.definition(dep).to_yaml
            end
          end
        when :hierachical
          # Hierachical attempts to keep one hierachical namespace
          doc = {
            'meta' => {
              'id' => @attributes['id'],
              'title' => 'Autogenerated dependencies',
              'endian' => "le",
              'imports' => @imports
            },
            'types' => {}
          }

          # Determine hierachical paths and buils type tree from it
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

          # Write all dependency into one file
          File.open(File.join(path, "dependencies.ksy"), 'w') do |fs|
            fs.write doc.to_yaml
          end
        end
      end
    end

    # Compile exported definitions at specified path
    def compile(path)
      # Copy any external imports
      @imports.each { |name| FileUtils.cp(File.join(@import_dir, "#{name}.ksy"), path) }

      id = @attributes['id']

      # HACK: Compile dependecies first to determine graphviz node names
      if @mode == :hierachical and @dependencies.any?
        result = run path, "dependencies.ksy", 'graphviz'

        deps = result.dig(id, 'files', 0, 'fileName')
        raise "Failed to parse graphviz output: #{result}" if deps.nil?

        FileUtils.cp(File.join(path, deps), File.join(path, 'dependencies.dot'))
      end

      # Compile graphviz graph ...
      result = run path, "#{id}.ksy", 'graphviz'

      # HACK: Work around the fact that ksc output file names are based on meta.id
      if @mode == :hierachical and @dependencies.any?
        result['dependencies'] = { 'files' => [{ 'fileName' => 'dependencies.dot' }] }
      end

      # ... and determine output files
      { graphviz: {
          main: result.dig(id, 'files', 0, 'fileName'),
          imports: @imports.map { |import| result.dig(import, 'files', 0, 'fileName') },
          dependencies: (dependencies @mode).map { |dep| result.dig(dep, 'files', 0, 'fileName') },
        }
      }
    end

    # Cleanup, render and embed kaitai graphviz output
    def render(path, output)
      # Extract graphviz node ids from imports to exclude undefined edges
      excludes = output.dig(:graphviz, :imports).map { |name|
        File.readlines(File.join(path, name), encoding: 'UTF-8')
            .map { |line| line.match(GRAPHVIZ_NODE_ID).to_a[1] }
            .reject &:nil?
      }.flatten

      # Extract graphviz metadata for all dependencies
      references = output.dig(:graphviz, :dependencies).map { |name|
        id = name.delete_suffix('.dot')
        latest_label = ""
        File.readlines(File.join(path, name), encoding: 'UTF-8')
            .map { |line|
              # Track last label to determine display name
              label = line.match(GRAPHVIZ_LABEL).to_a[1]
              latest_label = label unless label.nil?

              # If line contains node identifier ...
              node = line.match(GRAPHVIZ_NODE_ID).to_a[1]
              # ... link node id to display name and kaitai id
              node.nil? ? nil : [node, {name: latest_label, href: id }]
            }.reject(&:nil?)
            .to_h
      }.reduce Hash::new, &:merge # FIXME: Merge should be by label path length

      # Determine file to render
      output_name = output.dig(:graphviz, :main)
      output_path = File.join(path, output_name)

      # Cleanup dot edges exported by kaitai
      if excludes.any? or references.any?
        backup_path = File.join(path, "#{output_name}.bak")
        FileUtils.cp(output_path, backup_path)

        File.open(output_path, 'w') do |fs|
          for line in File.readlines(backup_path, encoding: 'UTF-8')
            # Ignore edges to or from nodes on exclude list
            next if excludes.any? { |ex| line.match? (/-> #{ex}/) or line.match? (/#{ex}:.* ->/) }

            # Add node linking to dependency, if edge to dependecy exists
            for id, info in references
              fs.write "#{id} [label=\"#{info[:name]}\" href=\"##{info[:href]}\"];\n" if line.match? (/-> #{id}/)
            end

            # Print line itself
            fs.write line
          end
        end
      end

      # Convert and embed graphviz graph as inline svg
      target_base64 = Base64.strict_encode64 `dot -T svg #{output_path}`
      raise 'Failed to run graphviz' if target_base64.empty?

      @attributes['target'] = "data:image/svg+xml;base64,#{target_base64}"
      @attributes['format'] = 'svg'
      set_option 'inline'
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
      body = nil
      begin
        body = YAML.safe_load reader.read
      rescue Exception => e
        raise "Failed to parse kaitai yaml of '#{attrs['id']}': #{e.message}"
      end
      Kaitai::Registry.new_block parent, body, attrs
    end
  end
end
