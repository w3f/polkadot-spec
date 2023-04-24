meta:
  id: pallet_constant
  title: PalletConstant
  endian: le
  imports:
  - scale
  - item
seq:
  - id: prefix
    type: scale::string
  - id: num_items
    type: scale::compact_int
  - id: items
    type: item
    repeat: expr
    repeat-expr: num_items.value