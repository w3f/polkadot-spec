meta:
  id: metadata
  title: Metadata
  endian: le
  imports:
  - scale
  - metadata_type
  - metadata_pallet
  - metadata_extrinsic
seq:
  - id: magic
    contents: meta
  - id: metadata_version
    type: u1

  - id: num_types
    type: scale::compact_int
  - id: types
    type: metadata_type
    repeat: expr
    repeat-expr: num_types.value

  - id: num_pallets
    type: scale::compact_int
  - id: pallets
    type: metadata_pallet
    repeat: expr
    repeat-expr: num_pallets.value

  - id: extrinsic_type
    type: scale::compact_int
  - id: extrinsic_version
    type: u1
  - id: num_extrinsics
    type: scale::compact_int
  - id: extrinsics
    type: metadata_extrinsic
    repeat: expr
    repeat-expr: num_extrinsics.value

  - id: runtime_type
    type: scale::compact_int