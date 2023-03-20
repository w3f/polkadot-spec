meta:
  id: metadata_pallet
  title: MetadataPallet
  endian: le
  imports:
  - scale
  - pallet_storage
  - pallet_constant
seq:
  - id: name
    type: scale::string

  - id: has_storage
    type: u1
  - id: storage
    type: pallet_storage
    if: has_storage != 0

  - id: has_calls
    type: u1
  - id: calls
    type: calls
    if: has_calls != 0

  - id: has_events
    type: u1
  - id: events
    type: events
    if: has_events != 0

  - id: num_constants
    type: scale::compact_int
  - id: constants
    type: pallet_constant
    repeat: expr
    repeat-expr: num_constants.value

  - id: has_errors
    type: u1
  - id: errors
    type: errors
    if: has_errors != 0

  - id: index
    type: u1
types:
  calls:
    seq:
      - id: type
        type: scale::compact_int

  events:
    seq:
      - id: type
        type: scale::compact_int

  errors:
    seq:
      - id: type
        type: scale::compact_int