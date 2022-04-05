require 'asciidoctor/extensions'

require 'pseudocode'

Asciidoctor::Extensions.register do
  if @document.basebackend? 'html'
    # Docinfo processor to include the css code
    docinfo_processor do
      at_location :head
      process do |_|
        pseudocode_css = File.read Pseudocode.pseudocode_css_path
        next %(<style type="text/css">#{pseudocode_css}</style>)
      end
    end
  end

  # A block processor to asciimath
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

      content = %(
        <div id="#{id}" class="stemblock">
          <div class="title">#{title}. <a href="#{'#' + id}">#{caption}</a></div>
          <div class="content">#{rendered}</div>
        </div>
      )

      # Clean up reference data
      attrs['title'] = title
      attrs['id'] = id

      # Return result embedded in pass block
      create_block parent, :pass, content, attrs
    end
  end
end
