meta:
  id: scale
  title: Simple Concatenated Aggregate Little-Endian
  endian: le
  bit-endian: be
types:
  compact_int:
    seq:
      - id: data
        type: b6
      - id: mode
        type: b2
      - id: extra
        size: (mode & 0x1) + ((mode & 0x2) / 0x2 * 3) + ((mode & 0x3) / 0x3 * data)
    instances:
      value:
        value: data + (extra[0] << 6) + (extra[1] << 14) + (extra[2] << 22) + (extra[3] << 30) + (extra[4] << 38) + (extra[5] << 46) + (extra[6] << 54) + (extra[7] << 62)

  maybe_compact_int:
    seq:
      - id: has_value
        type: u1
      - id: value
        type: compact_int
        if: has_value != 0

  bytes:
    seq:
      - id: length
        type: compact_int
      - id: value
        size: length.value

  string:
    seq:
      - id: length
        type: compact_int
      - id: value
        type: str
        size: length.value
        encoding: UTF-8

  maybe_string:
    seq:
      - id: has_value
        type: u1
      - id: value
        type: string
        if: has_value != 0

  string_list:
    seq:
      - id: num_values
        type: compact_int
      - id: values
        type: string
        repeat: expr
        repeat-expr: num_values.value
