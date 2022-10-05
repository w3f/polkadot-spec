require_relative 'scale.fixed.rb'
require_relative 'block.rb'

require 'kaitai/struct/struct'

require 'blake2b'


GENESIS_HASH = "91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3"

# Parse binary block export
stream = Kaitai::Struct::Stream.open './test/blocks.bin'

# Exports are prefixed with 64-bit block count (TODO: Documentation)
num_blocks = stream.read_u8le

# Iterate over blocks and track chain
expected_hash = GENESIS_HASH
for expected_num in 1..num_blocks

  # Parse block header in file
  header_from = stream.pos
  header = Block::BlockHeader.new stream
  header_to = stream.pos

  stream.seek(header_from)
  header_raw = stream.read_bytes(header_to - header_from)
  header_hash = Blake2b.bytes(header_raw).pack('c*').unpack1('H*')

  parent_hash = header.parent_hash.unpack1('H*')

  # Check header values
  raise "Parent hash mismatch: '#{parent_hash}' != '#{expected_hash}'" if parent_hash != expected_hash
  raise "Block number mismatch: #{header.number.value} != #{expected_num}" if header.number.value != expected_num

  # TODO: Check other header fields

  # Parse block body
  body = Block::BlockBody.new stream

  # TODO: Check extrinsics root here

  # Parse block justifaction
  justification = stream.read_u1

  # TODO: Define justified block
  raise "Unexpected justification found" if justification != 0

  # Update next expected parent_hash
  expected_hash = header_hash
end
raise 'Failed to reach end of file' unless stream.eof?
stream.close
