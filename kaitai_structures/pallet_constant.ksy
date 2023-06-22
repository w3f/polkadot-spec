meta:
  id: pallet_constant
  title: PalletConstant
  endian: le
  imports:
  - scale
seq:
  - id: name
    type: scale::string
  - id: type
    type: scale::compact_int
  - id: value
    type: scale::bytes
  - id: docs
    type: scale::string_list
