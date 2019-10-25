module PdreApiTestFixtures
	const cli_testers = [
	  "build/bin/usr/local/bin/rust_tester"
	  # TODO "build/bin/usr/local/bin/go_tester"
	  # TODO "build/bin/usr/local/bin/cpp_tester"
	]

	# Input: data
	const fn_crypto_hashes = [
	  "test_blake2_128",
	  "test_blake2_256",
	  "test_keccak_256",
	  "test_twox_64",
	  "test_twox_128",
	  "test_twox_256"
	]

	# Input: data
	const fn_crypto_keys = [
	  "test_ed25519",
	  "test_sr25519",
	]

	# Input: key, value
	const fn_storage_kv = [
	  "test_set_get_storage",
	  "test_exists_storage",
	  "test_clear_storage"
	]

	# Input: prefix, key1, value1, key2, value2
	const fn_storage_prefix = [
	  "test_clear_prefix"
	]

	# Input: child1, child2, key, value
	const fn_storage_child = [
	  "test_set_get_child_storage",
	  "test_exists_child_storage",
	  "test_clear_child_storage",
	  "test_kill_child_storage"
	]

	# Input: prefix, child1, child2, key1, value1, key2, value2
	const fn_storage_prefix_child = [
	  "test_clear_child_prefix"
	]

	const fn_network = [
	  "test_http",
	  "test_network_state"
	]
end

module PdreApiTestData
	const value_data = [
	  "static", # value
	  "Inverse", # value...
	  "even-keeled",
	  "Future-proofed",
	  "function",
	  "Horizontal",
	  "Face to face",
	  "Expanded",
	  "Integrated",
	  "portal",
	]

	const key_value_data = [
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

	const prefix_key_value_data = [
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

	const child_key_value_data = [
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

	const prefix_child_key_value_data = [
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
end
