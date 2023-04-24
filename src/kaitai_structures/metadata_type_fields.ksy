meta:
  id: metadata_type_fields
  title: MetadataTypeFields
  endian: le
  imports:
  - scale
seq:
  - id: num_fields
    type: scale::compact_int
  - id: fields
    type: field
    repeat: expr
    repeat-expr: num_fields.value
types:
  field:
    seq:
      - id: name
        type: scale::maybe_string
      - id: type
        type: scale::compact_int
      - id: typename
        type: scale::maybe_string
      - id: docs
        type: scale::string_list