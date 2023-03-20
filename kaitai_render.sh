#!/bin/bash

kaitai_dir="src/kaitai_structures"
output_dir="static/img/kaitai_render"

# Loop through all the files with a .ksy extension
for file in "$kaitai_dir"/*.ksy
do
  # Run the Kaitai Struct compiler on each file
  kaitai-struct-compiler "$file" --target graphviz --outdir $output_dir
done

# Loop through all the files with a .dot extension
for file in "$output_dir"/*.dot
do
  # Run the Graphviz compiler on each file
  dot -Tsvg "$file" -o "${file%.*}.svg"
done

rm "$output_dir"/*.dot