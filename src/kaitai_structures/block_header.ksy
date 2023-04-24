meta:
    id: block_header
    title: BlockHeader
    endian: le
    imports:
    - scale
    - digest
seq:
  - id: parent_hash
    size: 32
  - id: number
    type: scale::compact_int
  - id: state_root
    size: 32
  - id: extrinsic_root
    size: 32
  - id: num_digests
    type: scale::compact_int
  - id: digests
    type: digest
    repeat: expr
    repeat-expr: num_digests.value