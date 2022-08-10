require_relative 'scale.fixed.rb'
require_relative 'metadata.rb'

require 'kaitai/struct/struct'

# Parse metadata file
stream = Kaitai::Struct::Stream.open './test/metadata.bin'
PARSED_METADATA = Metadata.new stream
raise 'Failed to reach end of file' unless stream.eof?
stream.close

# Helper function to resolve included types
def resolve_type(type)
  PARSED_METADATA.lookup.each do |entry|
    return entry if entry.id.value == type.value
  end
  raise "Unknown type id '#{type.value}'"
end

# Check version
raise "Unknown metadata version #{PARSED_METADATA.metadata_version}" unless PARSED_METADATA.metadata_version == 14

# Check nested lookup types
PARSED_METADATA.lookup.each do |entry|
  entry.params.each do |param|
    resolve_type(param.type.value) if param.type.has_value != 0
  end

  case entry.type
  when :type_composite
    entry.details.fields.each { |field| resolve_type(field.type) }
  when :type_bits
    resolve_type(entry.details.type)
  when :type_array
    resolve_type(entry.details.type)
  when :type_sequence
    resolve_type(entry.details.type)
  when :type_compact
    resolve_type(entry.details.type)
  when :type_variant
    entry.details.variants.each do |variant|
      variant.composite.fields.each { |field| resolve_type(field.type) }
    end
  when :type_tuple
    entry.details.types.each { |t| resolve_type(t) }
  end
end

# Check pallet types
PARSED_METADATA.pallets.each do |pallet|
  if pallet.has_storage != 0
    pallet.storage.items.each do |item|
      case item.type
      when :storage_type_plain
        resolve_type(item.details.type)
      when :storage_type_map
        resolve_type(item.details.key)
        resolve_type(item.details.value)
      end
    end
  end

  resolve_type(pallet.calls.type) if pallet.has_calls != 0
  resolve_type(pallet.events.type) if pallet.has_events != 0

  pallet.constants.each do |constant|
    resolve_type(constant.type)
  end

  resolve_type(pallet.errors.type) if pallet.has_errors != 0
end

# Check extrinsic types
resolve_type(PARSED_METADATA.extrinsic_type)

PARSED_METADATA.extrinsics.each do |extrinsic|
  resolve_type(extrinsic.type)
  resolve_type(extrinsic.additional)
end

# Check runtime type
resolve_type(PARSED_METADATA.runtime_type)
