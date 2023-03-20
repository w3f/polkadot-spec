meta:
  id: digest
  title: BlockDigest
  endian: le
  imports:
  - scale
seq:
  - id: type
    type: u1
    enum: type_id
  - id: value
    type:
      switch-on: type
      cases:
        'type_id::pre_runtime': pre_runtime
        'type_id::post_runtime': post_runtime
        'type_id::seal': seal
        'type_id::runtime_updated': empty
enums:
  type_id:
    4: post_runtime
    5: seal
    6: pre_runtime
    8: runtime_updated
types:
  pre_runtime:
    seq:
      - id: engine
        type: str
        encoding: ASCII
        size: 4
      - id: payload
        type: scale::bytes
  post_runtime:
    seq:
      - id: engine
        type: str
        encoding: ASCII
        size: 4
      - id: payload
        type: scale::bytes
  seal:
    seq:
      - id: engine
        type: str
        encoding: ASCII
        size: 4
      - id: payload
        type: scale::bytes
  empty: {}