# Based on https://github.com/tani/asciidoctor-mathjax3
require 'asciidoctor/extensions'

MATHJAX_CONFIGURATION = %q(
  <script>
    MathJax = {
      loader: {
        load: ['input/asciimath', 'input/tex', 'output/chtml', 'a11y/assistive-mml']
      },
      asciimath: {
        delimiters: [['\\\\\\\\$','\\\\\\\\$']]
      },
      options: {
        ignoreHtmlClass: 'nostem|nolatexmath|noasciimath',
      },
      tex: {
        inlineMath: [[ '\\\\\\\\(', '\\\\\\\\)' ]],
        displayMath: [[ '\\\\\\\\[', '\\\\\\\\]' ]],
        processEscapes: false,
        processEnvironments: false,
        processRefs: false,   
      },
    };
  </script>
).freeze

Asciidoctor::Extensions.register do
  if (@document.basebackend? 'html')
    postprocessor do
      process do |document, output|
        cfg = %r{<script type="text/x-mathjax-config">.*?</script>}m
        m2 = %r{<script src=".*?TeX-MML-AM_HTMLorMML"></script>}
        m3 = %(<script type="text/javascript" id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/startup.js"></script>)
        output.sub(cfg, MATHJAX_CONFIGURATION).sub(m2, m3)
      end
    end
  end
end
