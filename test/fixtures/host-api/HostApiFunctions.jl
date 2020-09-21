# Module which contains the names of the functions that need to be tested.
# Thoses names get passed on to the CLI as`--function <NAME>`.
# The functions are grouped into arrays based on the expected (same) input data.
module HostApiFunctions
	const none = [
		"test_storage_init"
	]
	
	const value = [
		"ext_hashing_keccak_256_version_1",
		"ext_hashing_sha2_256_version_1",
		"ext_hashing_blake2_128_version_1",
		"ext_hashing_blake2_256_version_1",
		"ext_hashing_twox_256_version_1",
		"ext_hashing_twox_128_version_1",
		"ext_hashing_twox_64_version_1",
		"ext_allocator_malloc_version_1",
		"ext_allocator_free_version_1"
	]

	const key_value = [
		"ext_storage_set_version_1",
		"ext_storage_get_version_1",
		"ext_storage_clear_version_1",
		"ext_storage_exists_version_1"
	]

	const child_key_value = [
		"ext_default_child_storage_set_version_1",
		"ext_default_child_storage_get_version_1",
		"ext_default_child_storage_clear_version_1",
		"ext_default_child_storage_exists_version_1"
	]

	const child_prefix_key_value_key_value = [
		"ext_default_child_storage_clear_prefix_version_1"
	]

	const child_key_value_key_value = [
		"ext_default_child_storage_storage_kill_version_1",
		"ext_default_child_storage_root_version_1",
		"ext_default_child_storage_next_key_version_1"
	]

	const child_key_value_offset_buffer_size = [
		"ext_default_child_storage_read_version_1"
	]
	
	const key_value_offset_buffer_size = [
		"ext_storage_read_version_1"
	]

	const prefix_key_value_key_value = [
		"ext_storage_clear_prefix_version_1"
	]

	const key_value_key_value = [
		"ext_storage_root_version_1",
		"ext_storage_next_key_version_1"
	]

	const seed = [
		"ext_crypto_ed25519_generate_version_1",
		"ext_crypto_sr25519_generate_version_1"
	]

	# TODO: Expand seed data
	const seed_seed = [
		"ext_crypto_ed25519_public_keys_version_1",
		"ext_crypto_sr25519_public_keys_version_1"
	]

	# TODO: Expand seed data
	const seed_msg = [
		"ext_crypto_ed25519_sign_version_1",
		"ext_crypto_ed25519_verify_version_1",
		"ext_crypto_sr25519_sign_version_1",
		"ext_crypto_sr25519_verify_version_1"
	]

	const key_value_key_value_key_value = [
		"ext_trie_blake2_256_root_version_1"
	]

	const value_value_value = [
		"ext_trie_blake2_256_ordered_root_version_1"
	]	
end
