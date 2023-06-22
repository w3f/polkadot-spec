meta:
  id: storage_definition
  title: StorageDefinition
  endian: le
  imports:
  - scale
seq:
  - id: type
    type: u1
    enum: storage_type
  - id: details
    type:
      switch-on: type
      cases:
        'storage_type::plain': plain
        'storage_type::map': map
enums:
  storage_type:
    0: plain
    1: map
types:
  plain:
    seq:
      - id: type
        type: scale::compact_int
  map:
    seq:
      - id: num_hasher
        type: scale::compact_int
      - id: hasher
        type: u1
        enum: hasher_type
        repeat: expr
        repeat-expr: num_hasher.value

      - id: key
        type: scale::compact_int
      - id: value
        type: scale::compact_int
    enums:
      hasher_type:
        0: blake2_128
        1: blake2_256
        2: blake2_128_128
        3: xxhash_128
        4: xxhash_256
        5: xxhahs_64_64
        6: idhash