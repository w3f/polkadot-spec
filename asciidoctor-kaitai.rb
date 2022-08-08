require 'asciidoctor/extensions'
require 'asciidoctor/helpers'

require 'json'
require 'yaml'
require 'tempfile'
require 'fileutils'

# Simple index that allows blocks to resolve each others definition
module Kaitai
  module Registry
    @@blocks = {}
    @@missing = {}

    def self.register(id, block)
      # Update missing dependencies
      completed = @@missing.filter { |_, deps| (deps.delete id) && deps.empty? }.keys

      # Register new block
      @@blocks[id] = block
      @@missing[id] = block.dependencies.reject { |dep| self.defined? dep }

      # Update now completed block
      completed.each { |other| @@blocks[other].generate }

      @@missing[id].empty?
    end

    def self.defined?(id)
      @@missing[id] && @@missing[id].empty?
    end

    def self.subtype(id)
      @@blocks[id].as_subtype
    end

    def self.definition(id)
      @@blocks[id].definition true
    end
  end
end


# Wrapper around block to allow out of order resolution of includes
class KaitaiBlock < Asciidoctor::Block
  CAPTION_PREFIX = 'Binary Format'
  GRAPHVIZ_NODE_ID = Regexp.new '([a-z_]+) \[label=<<TABLE'

  def initialize(parent, body, attrs)
    @body = body

    # Check id and title
    id = attrs['id']
    title = attrs.key?('title') ? attrs.delete('title') : nil

    raise "Invalid kaitai identifier: #{id}" unless id.match?(/^[a-z][a-z0-9_]*$/)

    attrs['alt'] ||= (attrs['default-alt'] = title || "Kaitai Struct generated graph")

    super parent, :image, { source: nil, attributes: attrs }

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
    end

    if attr 'kaitai-export', false
      outdir = attr 'docdir', nil, true
      print "Exporting '#{@attributes['id']}' to #{outdir}"
      export outdir, true
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
    }}
  end

  # Return body of definition
  def body(combined)
    doc = @body
    if combined && dependencies
      doc['types'] ||= {}
      dependencies.each { |inc| doc['types'][inc] = Kaitai::Registry.subtype inc }
    end
    doc
  end

  # Write definitions of block and its dependencies to path
  def export(path, combined)
    # Export main file
    id = @attributes['id']
    write_yaml File.join(path, "#{id}.ksy"), (definition combined)

    # Write dependencies if not combined
    if !combined
      dependencies.each { |dep|
        write_yaml File.join(path, "#{dep}.ksy"), Kaitai::Registry.definition(dep)
      }
    end
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
        .filter { |value| !value.nil? }
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
    @attributes['target'] = "data:image/svg+xml;base64,#{target_base64}"
  end

  # Simple yaml file writer
  def write_yaml(path, data)
    File.open(path, 'w') do |fs|
      fs.write(data.to_yaml)
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
      block = KaitaiBlock.new parent, body, attrs
      block.generate if Kaitai::Registry.register attrs['id'], block
      block
    end
  end
end
