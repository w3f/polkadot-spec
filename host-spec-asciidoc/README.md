## Dependencies

### Ruby

```bash
sudo apt-get install rubygems
sudo apt-get install ruby-dev
```

### AsciiDoctor

```bash
sudo gem install asciidoctor
sudo gem install asciidoctor-pdf
sudo gem install asciidoctor-mathematical
```

## Build

### HTML

#### Multi-Page (recommended)

```bash
asciidoctor -r asciidoctor-multipage -b multipage_html5 -D out host-spec.adoc
```

Where the resulting HTML pages can then be found in the `out/` directory.

#### Single-Page

```bash
asciidoctor host-spec.adoc
```

### PDF (with math formulas enabled)

```bash
asciidoctor-pdf -r asciidoctor-mathematical -a mathematical-format=svg host-spec.adoc
````
