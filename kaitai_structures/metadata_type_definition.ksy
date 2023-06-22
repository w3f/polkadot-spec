meta:
  id: metadata_type_definition
  title: MetadataTypeDefinition
  endian: le
  imports:
  - scale
  - metadata_type_variants
  - metadata_type_fields
seq:
  - id: type
    type: u1
    enum: type
  - id: details
    type:
      switch-on: type
      cases:
        "type::composite": metadata_type_fields
        "type::variant": metadata_type_variants
        "type::sequence": sequence
        "type::array": array
        "type::tuple": tuple
        "type::primitive": primitive
        "type::compact": compact
        "type::bits": bits
enums:
  type:
    0: composite
    1: variant
    2: sequence
    3: array
    4: tuple
    5: primitive
    6: compact
    7: bits
types:
  sequence:
    seq:
      - id: type
        type: scale::compact_int

  array:
    seq:
      - id: length
        type: u4
      - id: type
        type: scale::compact_int

  tuple:
    seq:
      - id: num_types
        type: scale::compact_int
      - id: types
        type: scale::compact_int
        repeat: expr
        repeat-expr: num_types.value

  primitive:
    seq:
      - id: id
        type: u1
        enum: pid
    enums:
      pid:
        0: bool
        1: char
        2: str
        3: uint8
        4: uint16
        5: uint32
        6: uint64
        7: uint128
        8: uint256
        9: int8
        10: int16
        11: int32
        12: int64
        13: int128
        14: int256

  compact:
    seq:
      - id: type
        type: scale::compact_int

  bits:
    seq:
      - id: type
        type: scale::compact_int
      - id: order
        type: scale::compact_int