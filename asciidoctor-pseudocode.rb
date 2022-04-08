require 'asciidoctor/extensions'
require 'asciidoctor/helpers'

require 'pseudocode'

Asciidoctor::Extensions.register do
  # Docinfo processor to include the css code in html outputs
  if @document.basebackend? 'html'
    docinfo_processor do
      at_location :head
      process do |_|
        pseudocode_css = File.read Pseudocode.pseudocode_css_path
        next %(<style type="text/css">#{pseudocode_css}</style>)
      end
    end
  end

  # A block processor to render pseudocode
  block :pseudocode do

    contexts :pass
    content_model :raw

    process do |parent, reader, attrs|
      # Wrap algorithm in header and footer
      caption = attrs['title'] || ''
      algorithm = %(
        \\begin{algorithm}
        \\caption{#{caption}}
        \\begin{algorithmic}
        #{reader.read}
        \\end{algorithmic}
        \\end{algorithm}
      )

      # Render with pseudocode.js
      rendered, counter = Pseudocode.render algorithm, line_number: true

      # Add id and class to result
      id = attrs['id'] || "algo-#{counter}"
      title = "Algorithm #{counter}"

      # Clean up reference data
      attrs['id'] = id
      attrs['title'] = title

      # Return result embedded in appropiate block
      case parent.document.backend.to_sym
      when :html5
        # Embed html in container with title
        content = %(
          <div id="#{id}" class="stemblock">
            <div class="title">#{title}. <a href="#{'#' + id}">#{caption}</a></div>
            <div class="content">#{rendered}</div>
          </div>
        )

        create_block parent, :pass, content, attrs
      when :pdf
        # Convert html to svg
        header = "<meta charset='UTF-8'/>"
        header += %(<style type="text/css">#{File.read Pseudocode.pseudocode_css_path}</style>)

        (Asciidoctor::Helpers.require_library 'wkhtml', true, :abort) if not defined? WkHtml
        content = WkHtml::Converter.new(header + rendered, "transparent" => true).to_svg

        # Embed SVG as inline image
        attrs['target'] = "data:image/svg+xml;base64,#{Base64.strict_encode64 content}"
        attrs['align'] = 'center'

        # Clean up reference data
        attrs['title'] = caption
        attrs['caption'] = "#{title}. "

        create_image_block parent, attrs
      else
        create_block parent, :pass, algorithm, attrs
      end
    end
  end
end
