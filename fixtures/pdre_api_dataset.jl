module PdreApiTestBinaries
	const cli_testers = [
      "test/testers/rust-tester/target/debug/rust_tester",
	  # TODO "build/bin/usr/local/bin/rust_tester"
	  # TODO "build/bin/usr/local/bin/go_tester"
	  # TODO "build/bin/usr/local/bin/cpp_tester"
	]
end

module PdreApiTestBinariesLegacy
	const cli_testers = [
      "test/testers/rust-tester/target/debug/rust_tester_legacy",
	  # TODO "build/bin/usr/local/bin/rust_tester"
	  # TODO "build/bin/usr/local/bin/go_tester"
	  # TODO "build/bin/usr/local/bin/cpp_tester"
	]
end

module PdreApiTestFunctions
	const value = [
		"ext_hashing_keccak_256_version_1",
		"ext_hashing_sha2_256_version_1",
		"ext_hashing_blake2_128_version_1",
		"ext_hashing_blake2_256_version_1",
		"ext_hashing_twox_256_version_1",
		"ext_hashing_twox_128_version_1",
		"ext_hashing_twox_64_version_1",
	]

	const child_child_def_type_key_value = [
		"ext_storage_child_get_version_1",
		"ext_storage_child_clear_version_1",
		"ext_storage_child_exists_version_1"
	]

	const child_child_def_type_prefix_key_value_key_value = [
		"ext_storage_child_clear_prefix_version_1",
	]

	const child_child_def_type_key_value_key_value = [
		"ext_storage_child_root_version_1",
		"ext_storage_child_next_key_version_1",
	]
end

# Module which contains the names of the LEGACY functions that need to be tested.
# Thoses names get passed on to the CLI as`--function <NAME>`.
# The functions are grouped into arrays, depending on the expected input
# corresponding to the arrays in `PdreApiTestData`.
module PdreApiTestFunctionsLegacy
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

	# Input: key, value
	const key_value = [
	  "test_set_get_storage",
	  "test_exists_storage",
	  "test_clear_storage",
	  "test_set_get_local_storage",
	  "test_blake2_256_enumerated_trie_root"
	]

	# Input: key, value, offset
	const key_value_offset = [
		"test_set_get_storage_into"
	]

	# Input: key1, value1, key2, value2
	const key_value_key_value = [
		"test_storage_root"
	]

	# Input: key, old_value, new_value
	const key_key_value = [
		"test_local_storage_compare_and_set"
	]

	# Input: prefix, key1, value1, key2, value2
	const prefix_key_value_key_value = [
	  "test_clear_prefix"
	]

	# Input: child1, child2, key, value
	const child_child_key_value = [
	  "test_set_get_child_storage",
	  "test_exists_child_storage",
	  "test_clear_child_storage",
	  "test_kill_child_storage"
	]

	# Input: prefix, child1, child2, key1, value1, key2, value2
	const prefix_child_child_key_value_key_value = [
	  "test_clear_child_prefix"
	]

	# Input: child1, child2, key, value, offset
	const child_child_key_value_offset = [
	  "test_get_child_storage_into"
	]

	# Input: child1, child2, key1, value1, key2, value2
	const child_child_key_value_key_value = [
	  "test_child_storage_root"
	]

	const fn_network = [
	  "test_http",
	  "test_network_state"
	]
end

module PdreApiTestData
    # Only used by new APIs, not legacy
	const child_def_child_type = [
	  [
		"Ameliorated", # child key definition
		1 # child type
	  ],
	  [
		"radical",
		1
	  ],
	  [
		"forecast",
		1
	  ],
	  [
		"well-modulated",
		1
	  ],
	  [
		"Vision-oriented",
		1
	  ],
	  [
		"needs-based",
		1
	  ],
	  [
		"heuristic",
		1
	  ],
	  [
		"system engine",
		1
	  ],
	  [
		"paradigm",
		1
	  ],
	  [
		"Devolved",
		1
	  ]
	]

    # Only used by new APIs, not legacy
	const prefix_key_value_key_value = [
	  [
	    "stat", # prefix
	    "static", # key1
	    "Inverse", # value1
	    "even-keeled", # key2
	    "Future-proofed" # value2
	  ],
	  [
	    "Face",
	    "function",
	    "Horizontal",
	    "Face to face",
	    "Expanded"
	  ],
	  [
	    "Integrated",
	    "Integrated",
	    "portal",
	    "budgetary management",
	    "pricing structure"
	  ],
	  [
	    "non",
	    "non-based",
	    "Monitored",
	    "non-volatile",
	    "emulation"
	  ],
	  [
	    "sec",
	    "productivity",
	    "secondary",
	    "Total",
	    "Visionary"
	  ],
	  [
	    "conc",
	    "Exclusive",
	    "next generation",
	    "concept",
	    "approach"
	  ],
	  [
	    "disf",
	    "disintermediate",
	    "Grass-roots",
	    "policy",
	    "function"
	  ],
	  [
	    "cont",
	    "contingency",
	    "value-added",
	    "context-sensitive",
	    "Configurable"
	  ],
	  [
	    "Auto",
	    "human-resource",
	    "Reactive",
	    "hardware",
	    "Automated"
	  ],
	  [
	    "secon",
	    "Optional",
	    "secondary",
	    "object-oriented",
	    "toolset"
	  ]
	]

	const key_value_1 = [
	  [
	    "static", # key
	    "Inverse", # value
	  ],
	  [
	    "function",
	    "Horizontal",
	  ],
	  [
	    "Integrated",
	    "portal",
	  ],
	  [
	    "non-based",
	    "Monitored",
	  ],
	  [
	    "productivity",
	    "secondary",
	  ],
	  [
	    "Exclusive",
	    "next generation",
	  ],
	  [
	    "disintermediate",
	    "Grass-roots",
	  ],
	  [
	    "contingency",
	    "value-added",
	  ],
	  [
	    "human-resource",
	    "Reactive",
	  ],
	  [
	    "Optional",
	    "secondary",
	  ]
	]

	const key_value_2 = [
	  [
	    "even-keeled", # key
	    "Future-proofed" # value
	  ],
	  [
	    "Face to face",
	    "Expanded"
	  ],
	  [
	    "budgetary management",
	    "pricing structure"
	  ],
	  [
	    "non-volatile",
	    "emulation"
	  ],
	  [
	    "Total",
	    "Visionary"
	  ],
	  [
	    "concept",
	    "approach"
	  ],
	  [
	    "policy",
	    "function"
	  ],
	  [
	    "context-sensitive",
	    "Configurable"
	  ],
	  [
	    "hardware",
	    "Automated"
	  ],
	  [
	    "object-oriented",
	    "toolset"
	  ]
	]

	const value = [
		[
			"static", # value
		],
		[
			"Inverse", # value...
		],
		[
			"even-keeled",
		],
		[
			"Future-proofed",
		],
		[
			"function",
		],
		[
			"Horizontal",
		],
		[
			"Face to face",
		],
		[
			"Expanded",
		],
		[
			"Integrated",
		],
		[
			"portal",
		]
	]

	const offset = [
	  [
		3 # offset
	  ],
	  [
		5
	  ],
	  [
		0
	  ],
	  [
		20
	  ],
	  [
		1
	  ],
	  [
		8
	  ],
	  [
		6
	  ],
	  [
		30
	  ],
	  [
		2
	  ],
	  [
		9
	  ],
	]

	const child_child = [
	  [
	    ":child_storage:default:moratorium", # child1
	    ":child_storage:default:hardware" # child2
	  ],
	  [
	    ":child_storage:default:implementation",
	    ":child_storage:default:artificial intelligence"
	  ],
	  [
	    ":child_storage:default:Switchable",
	    ":child_storage:default:matrix"
	  ],
	  [
	    ":child_storage:default:strategy",
	    ":child_storage:default:Graphic Interface"
	  ],
	  [
	    ":child_storage:default:Total",
	    ":child_storage:default:24 hour"
	  ],
	  [
	    ":child_storage:default:exuding",
	    ":child_storage:default:Triple-buffered"
	  ],
	  [
	    ":child_storage:default:middleware",
	    ":child_storage:default:Operative"
	  ],
	  [
	    ":child_storage:default:Mandatory",
	    ":child_storage:default:intranet"
	  ],
	  [
	    ":child_storage:default:4th generation",
	    ":child_storage:default:encryption"
	  ],
	  [
	    ":child_storage:default:policy",
	    ":child_storage:default:full-range"
	  ]
	]
end
