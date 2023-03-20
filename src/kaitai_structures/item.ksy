meta:
  id: item
  title:
  endian: le
  imports:
  - scale
  - storage_definition
seq:
  - id: name
    type: scale::string

  - id: modifier
    type: u1
    enum: storage_modifier

  - id: definition
    type: storage_definition

  - id: fallback
    type: scale::bytes

  - id: docs
    type: scale::string_list
enums:
    storage_modifier:
        0: optional
        1: default