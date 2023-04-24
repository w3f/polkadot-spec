meta:
  id: block
  imports:
    - block_header
    - block_body
seq:
  - id: header
    type: block_header
  - id: body
    type: block_body