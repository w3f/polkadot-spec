import React, { useEffect } from 'react';

export default function Pseudocode({
	content,
	algID,
	options = {
		indentSize: '1.2em',
		commentDelimiter: '//',
		lineNumber: false,
		lineNumberPunc: ':',
		noEnd: false,
		captionCount: undefined,
	},
}) {
	useEffect(() => {
		if (window && document) {
		  // Load KaTeX library dynamically
		  const katexScript = document.createElement('script');
		  katexScript.src = 'https://cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.js';
		  katexScript.addEventListener('load', () => {
			// Load pseudocode rendering library dynamically
			const pseudocodeScript = document.createElement('script');
			pseudocodeScript.src = 'https://cdn.jsdelivr.net/npm/pseudocode@latest/build/pseudocode.min.js';
			pseudocodeScript.addEventListener('load', () => {
			  // Call pseudocode.renderElement() after both KaTeX and pseudocode libraries are loaded
			  // also save the anchor element to scroll to it later, because pseudocode.renderElement() will change the page height
			  var anchorElement = document.getElementById(window.location.hash.substring(1));
			  pseudocode.renderElement(document.getElementById(`_ps_${algID}`), options);
			  if (anchorElement) {
				anchorElement.scrollIntoView();
			  }
			});
			document.body.appendChild(pseudocodeScript);
		  });
		  document.body.appendChild(katexScript);
		}
	  }, []);
	  
	const openingTag = `<pre id="_ps_${algID}" class="pseudocode" style="display: hidden" >`;
	const closingTag = `</pre>`;
	return (
		<div
			dangerouslySetInnerHTML={{ __html: openingTag + content + closingTag }}
		/>
	);
}