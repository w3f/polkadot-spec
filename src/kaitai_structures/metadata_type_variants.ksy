meta:
  id: metadata_type_variants
  title: MetadataTypeVariants
  endian: le
  imports:
  - scale
  - metadata_type_fields
seq:
  - id: num_variants
    type: scale::compact_int
  - id: variants
    type: variant
    repeat: expr
    repeat-expr: num_variants.value
types:
  variant:
    seq:
      - id: name
        type: scale::string
      - id: composite
        type: metadata_type_fields
      - id: index
        type: u1
      - id: docs
        type: scale::string_list