# Module which contains the names of the LEGACY functions that need to be tested.
# Thoses names get passed on to the CLI as`--function <NAME>`.
# The functions are grouped into arrays based on the expected (same) input data.
module HostApiLegacyFunctions
	# Input: data
	const value = [
	  "test_blake2_128",
	  "test_blake2_256",
	  "test_keccak_256",
	  "test_twox_64",
	  "test_twox_128",
	  "test_twox_256"
	]

	const value_no_output = [
	  "test_ed25519",
	  "test_sr25519"
	]

	const key_value = [
	  "test_set_get_storage",
	  "test_exists_storage",
	  "test_clear_storage",
	  "test_set_get_local_storage",
	  "test_blake2_256_enumerated_trie_root"
	]

	const key_value_offset = [
		"test_set_get_storage_into"
	]

	const key_value_key_value = [
		"test_storage_root"
	]

	const key_key_value = [
		"test_local_storage_compare_and_set"
	]

	const prefix_key_value_key_value = [
	  "test_clear_prefix"
	]

	const child_child_key_value = [
	  "test_set_get_child_storage",
	  "test_exists_child_storage",
	  "test_clear_child_storage",
	  "test_kill_child_storage"
	]

	const prefix_child_child_key_value_key_value = [
	  "test_clear_child_prefix"
	]

	const child_child_key_value_offset = [
	  "test_get_child_storage_into"
	]

	const child_child_key_value_key_value = [
	  "test_child_storage_root"
	]

	const fn_network = [
	  "test_http",
	  "test_network_state"
	]

end
