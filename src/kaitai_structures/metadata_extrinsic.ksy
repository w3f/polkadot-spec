meta:
  id: metadata_extrinsic
  title: MetadataExtrinsic
  endian: le
  imports:
  - scale
seq:
  - id: name
    type: scale::string
  - id: type
    type: scale::compact_int
  - id: additional
    type: scale::compact_int