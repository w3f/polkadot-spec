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
		"ext_storage_child_get_version_1"
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
	const child_child_def_type_key_value = [
	  [
	    ":child_storage:default:moratorium", # child1
		":child_storage:default:hardware", # child2
		"Ameliorated", # child key definition
		1, # child type
	    "radical", # key
		"access" # value
	  ],
	  [
	    ":child_storage:default:implementation",
		":child_storage:default:artificial intelligence",
		"radical",
		1,
	    "initiative",
		"Function-based"
	  ],
	  [
	    ":child_storage:default:Switchable",
		":child_storage:default:matrix",
		"forecast",
		1,
	    "Assimilated",
		"system engine"
	  ],
	  [
	    ":child_storage:default:strategy",
		":child_storage:default:Graphic Interface",
		"well-modulated",
		1,
	    "help-desk",
		"knowledge user"
	  ],
	  [
	    ":child_storage:default:Total",
		":child_storage:default:24 hour",
		"Vision-oriented",
		1,
	    "zero administration",
		"Ameliorated"
	  ],
	  [
	    ":child_storage:default:exuding",
		":child_storage:default:Triple-buffered",
		"needs-based",
		1,
	    "optimizing",
		"paradigm"
	  ],
	  [
	    ":child_storage:default:middleware",
		":child_storage:default:Operative",
		"heuristic",
		1,
	    "well-modulated",
		"contingency"
	  ],
	  [
	    ":child_storage:default:Mandatory",
		":child_storage:default:intranet",
		"system engine",
		1,
	    "Devolved",
		"Vision-oriented"
	  ],
	  [
	    ":child_storage:default:4th generation",
		":child_storage:default:encryption",
		"paradigm",
		1,
	    "needs-based",
		"radical"
	  ],
	  [
	    ":child_storage:default:policy",
		":child_storage:default:full-range",
		"Devolved",
		1,
	    "forecast",
		"heuristic"
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

	const key_value = [
	  [
	    "static", # key
		"Inverse" # value
	  ],
	  [
	    "even-keeled",
		"Future-proofed"
	  ],
	  [
	    "function",
		"Horizontal"
	  ],
	  [
	    "Face to face",
		"Expanded"
	  ],
	  [
	    "Integrated",
		"portal"
	  ],
	  [
	    "budgetary management",
		"pricing structure"
	  ],
	  [
	    "Ameliorated",
		"Monitored"
	  ],
	  [
	    "non-volatile",
		"emulation"
	  ],
	  [
	    "productivity",
		"secondary"
	  ],
	  [
	    "Total",
		"Visionary"
	  ],
	]

	const key_value_offset = [
	  [
	    "static", # key
		"Inverse", # value
		3 # offset
	  ],
	  [
	    "even-keeled",
		"Future-proofed",
		5
	  ],
	  [
	    "function",
		"Horizontal",
		0
	  ],
	  [
	    "Face to face",
		"Expanded",
		20
	  ],
	  [
	    "Integrated",
		"portal",
		1
	  ],
	  [
	    "budgetary management",
		"pricing structure",
		8
	  ],
	  [
	    "Ameliorated",
		"Monitored",
		6
	  ],
	  [
	    "non-volatile",
		"emulation",
		30
	  ],
	  [
	    "productivity",
		"secondary",
		2
	  ],
	  [
	    "Total",
		"Visionary",
		9
	  ],
	]

	const key_value_key_value = [
	  [
	    "static", # key1
	    "Inverse", # value1
	    "even-keeled", # key2
	    "Future-proofed" # value2
	  ],
	  [
	    "function",
	    "Horizontal",
	    "Face to face",
	    "Expanded"
	  ],
	  [
	    "Integrated",
	    "portal",
	    "budgetary management",
	    "pricing structure"
	  ],
	  [
	    "non-based",
	    "Monitored",
	    "non-volatile",
	    "emulation"
	  ],
	  [
	    "productivity",
	    "secondary",
	    "Total",
	    "Visionary"
	  ],
	  [
	    "Exclusive",
	    "next generation",
	    "concept",
	    "approach"
	  ],
	  [
	    "disintermediate",
	    "Grass-roots",
	    "policy",
	    "function"
	  ],
	  [
	    "contingency",
	    "value-added",
	    "context-sensitive",
	    "Configurable"
	  ],
	  [
	    "human-resource",
	    "Reactive",
	    "hardware",
	    "Automated"
	  ],
	  [
	    "Optional",
	    "secondary",
	    "object-oriented",
	    "toolset"
	  ]
	]

	const key_key_value = [
	  [
	    "static", # key1
	    "even-keeled", # key2
	    "Future-proofed" # value2
	  ],
	  [
	    "function",
	    "Face to face",
	    "Expanded"
	  ],
	  [
	    "Integrated",
	    "budgetary management",
	    "pricing structure"
	  ],
	  [
	    "non-based",
	    "non-volatile",
	    "emulation"
	  ],
	  [
	    "productivity",
	    "Total",
	    "Visionary"
	  ],
	  [
	    "Exclusive",
	    "concept",
	    "approach"
	  ],
	  [
	    "disintermediate",
	    "policy",
	    "function"
	  ],
	  [
	    "contingency",
	    "context-sensitive",
	    "Configurable"
	  ],
	  [
	    "human-resource",
	    "hardware",
	    "Automated"
	  ],
	  [
	    "Optional",
	    "object-oriented",
	    "toolset"
	  ]
	]

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
	    "Xar",
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

	const child_child_key_value = [
	  [
	    ":child_storage:default:moratorium", # child1
	    ":child_storage:default:hardware", # child2
	    "radical", # key
		"access" # value
	  ],
	  [
	    ":child_storage:default:implementation",
	    ":child_storage:default:artificial intelligence",
	    "initiative",
		"Function-based"
	  ],
	  [
	    ":child_storage:default:Switchable",
	    ":child_storage:default:matrix",
	    "Assimilated",
		"system engine"
	  ],
	  [
	    ":child_storage:default:strategy",
	    ":child_storage:default:Graphic Interface",
	    "help-desk",
		"knowledge user"
	  ],
	  [
	    ":child_storage:default:Total",
	    ":child_storage:default:24 hour",
	    "zero administration",
		"Ameliorated"
	  ],
	  [
	    ":child_storage:default:exuding",
	    ":child_storage:default:Triple-buffered",
	    "optimizing",
		"paradigm"
	  ],
	  [
	    ":child_storage:default:middleware",
	    ":child_storage:default:Operative",
	    "well-modulated",
		"contingency"
	  ],
	  [
	    ":child_storage:default:Mandatory",
	    ":child_storage:default:intranet",
	    "Devolved",
		"Vision-oriented"
	  ],
	  [
	    ":child_storage:default:4th generation",
	    ":child_storage:default:encryption",
	    "needs-based",
		"radical"
	  ],
	  [
	    ":child_storage:default:policy",
	    ":child_storage:default:full-range",
	    "forecast",
		"heuristic"
	  ]
	]

	const child_child_key_value_offset = [
	  [
	    ":child_storage:default:moratorium", # child1
	    ":child_storage:default:hardware", # child2
	    "radical", # key
		"access", # value
		3
	  ],
	  [
	    ":child_storage:default:implementation",
	    ":child_storage:default:artificial intelligence",
	    "initiative",
		"Function-based",
		0
	  ],
	  [
	    ":child_storage:default:Switchable",
	    ":child_storage:default:matrix",
	    "Assimilated",
		"system engine",
		7
	  ],
	  [
	    ":child_storage:default:strategy",
	    ":child_storage:default:Graphic Interface",
	    "help-desk",
		"knowledge user",
		30
	  ],
	  [
	    ":child_storage:default:Total",
	    ":child_storage:default:24 hour",
	    "zero administration",
		"Ameliorated",
		0
	  ],
	  [
	    ":child_storage:default:exuding",
	    ":child_storage:default:Triple-buffered",
	    "optimizing",
		"paradigm",
		8
	  ],
	  [
	    ":child_storage:default:middleware",
	    ":child_storage:default:Operative",
	    "well-modulated",
		"contingency",
		1
	  ],
	  [
	    ":child_storage:default:Mandatory",
	    ":child_storage:default:intranet",
	    "Devolved",
		"Vision-oriented",
		6
	  ],
	  [
	    ":child_storage:default:4th generation",
	    ":child_storage:default:encryption",
	    "needs-based",
		"radical",
		0
	  ],
	  [
	    ":child_storage:default:policy",
	    ":child_storage:default:full-range",
	    "forecast",
		"heuristic",
		40
	  ]
	]

	const prefix_child_child_key_value_key_value = [
	  [
	    "stat", # prefix
	    ":child_storage:default:moratorium", # child1
	    ":child_storage:default:hardware", # child2
	    "static", # key1
	    "Inverse", # value1
	    "even-keeled", # key2
	    "Future-proofed" # value2
	  ],
	  [
	    "Face",
	    ":child_storage:default:implementation",
	    ":child_storage:default:artificial intelligence",
	    "function",
	    "Horizontal",
	    "Face to face",
	    "Expanded"
	  ],
	  [
	    "Xar",
	    ":child_storage:default:Switchable",
	    ":child_storage:default:matrix",
	    "Integrated",
	    "portal",
	    "budgetary management",
	    "pricing structure"
	  ],
	  [
	    "non",
	    ":child_storage:default:strategy",
	    ":child_storage:default:Graphic Interface",
	    "non-based",
	    "Monitored",
	    "non-volatile",
	    "emulation"
	  ],
	  [
	    "sec",
	    ":child_storage:default:Total",
	    ":child_storage:default:24 hour",
	    "productivity",
	    "secondary",
	    "Total",
	    "Visionary"
	  ],
	  [
	    "conc",
	    ":child_storage:default:exuding",
	    ":child_storage:default:Triple-buffered",
	    "Exclusive",
	    "next generation",
	    "concept",
	    "approach"
	  ],
	  [
	    "disf",
	    ":child_storage:default:middleware",
	    ":child_storage:default:Operative",
	    "disintermediate",
	    "Grass-roots",
	    "policy",
	    "function"
	  ],
	  [
	    "cont",
	    ":child_storage:default:Mandatory",
	    ":child_storage:default:intranet",
	    "contingency",
	    "value-added",
	    "context-sensitive",
	    "Configurable"
	  ],
	  [
	    "Auto",
	    ":child_storage:default:4th generation",
	    ":child_storage:default:encryption",
	    "human-resource",
	    "Reactive",
	    "hardware",
	    "Automated"
	  ],
	  [
	    "secon",
	    ":child_storage:default:policy",
	    ":child_storage:default:full-range",
	    "Optional",
	    "secondary",
	    "object-oriented",
	    "toolset"
	  ]
	]

	const child_child_key_value_key_value = [
	  [
	    ":child_storage:default:moratorium", # child1
	    ":child_storage:default:hardware", # child2
	    "static", # key1
	    "Inverse", # value1
	    "even-keeled", # key2
	    "Future-proofed" # value2
	  ],
	  [
	    ":child_storage:default:implementation",
	    ":child_storage:default:artificial intelligence",
	    "function",
	    "Horizontal",
	    "Face to face",
	    "Expanded"
	  ],
	  [
	    ":child_storage:default:Switchable",
	    ":child_storage:default:matrix",
	    "Integrated",
	    "portal",
	    "budgetary management",
	    "pricing structure"
	  ],
	  [
	    ":child_storage:default:strategy",
	    ":child_storage:default:Graphic Interface",
	    "non-based",
	    "Monitored",
	    "non-volatile",
	    "emulation"
	  ],
	  [
	    ":child_storage:default:Total",
	    ":child_storage:default:24 hour",
	    "productivity",
	    "secondary",
	    "Total",
	    "Visionary"
	  ],
	  [
	    ":child_storage:default:exuding",
	    ":child_storage:default:Triple-buffered",
	    "Exclusive",
	    "next generation",
	    "concept",
	    "approach"
	  ],
	  [
	    ":child_storage:default:middleware",
	    ":child_storage:default:Operative",
	    "disintermediate",
	    "Grass-roots",
	    "policy",
	    "function"
	  ],
	  [
	    ":child_storage:default:Mandatory",
	    ":child_storage:default:intranet",
	    "contingency",
	    "value-added",
	    "context-sensitive",
	    "Configurable"
	  ],
	  [
	    ":child_storage:default:4th generation",
	    ":child_storage:default:encryption",
	    "human-resource",
	    "Reactive",
	    "hardware",
	    "Automated"
	  ],
	  [
	    ":child_storage:default:policy",
	    ":child_storage:default:full-range",
	    "Optional",
	    "secondary",
	    "object-oriented",
	    "toolset"
	  ]
	]
end
