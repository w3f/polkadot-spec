meta:
  id: block_body
  title: BlockBody
  endian: le
  imports:
  - scale
seq:
- id: num_transactions
  type: scale::compact_int
- id: transactions
  type: transaction
  repeat: expr
  repeat-expr: num_transactions.value
types:
  transaction:
    seq:
    - id: len_data
      type: scale::compact_int
    - id: data
      size: len_data.value