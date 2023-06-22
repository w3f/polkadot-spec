meta:
  id: metadata_type
  title: MetadataType
  endian: le
  imports:
  - scale
  - metadata_type_definition
seq:
  - id: id
    type: scale::compact_int

  - id: path
    type: scale::string_list

  - id: num_params
    type: scale::compact_int
  - id: params
    repeat: expr
    repeat-expr: num_params.value
    type: param

  - id: definition
    type: metadata_type_definition

  - id: docs
    type: scale::string_list
types:
  param:
    seq:
      - id: name
        type: scale::string
      - id: type
        type: scale::maybe_compact_int