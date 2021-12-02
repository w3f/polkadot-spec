# Polkadot Host Specification

Official releases of the specification can be found on
[the release page](https://github.com/w3f/polkadot-spec/releases) of this repository.

## Dependencies

The Polkadot Host specification is written in [Asciidoctor](https://asciidoctor.org/).
A handful of dependencies are required to successfully generate a final release,
depending on the desired target.

### Ruby

```bash
sudo apt-get install rubygems
sudo apt-get install ruby-dev
```

### AsciiDoctor

```bash
sudo gem install asciidoctor
# Optional: for PDF generation
sudo gem install asciidoctor-pdf
sudo gem install asciidoctor-mathematical
# Optional: for multi-page HTML generation (recommended)
sudo gem install asciidoctor-multipage
```

## Build

Generate the final HTML page(s) or PDF file.

### HTML

#### Multi-Page (recommended)

```bash
asciidoctor -r asciidoctor-multipage -b multipage_html5 -D out host_spec.adoc
```

Where the resulting HTML pages can then be found in the `out/` directory.

#### Single-Page

```bash
asciidoctor host_spec.adoc
```

### PDF (with math formulas enabled)

```bash
asciidoctor-pdf -r asciidoctor-mathematical -a mathematical-format=svg host_spec.adoc
````
