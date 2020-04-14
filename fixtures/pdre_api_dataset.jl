module PdreApiTestBinaries
	const cli_testers = [
    "rust-tester",
	]
end

module PdreApiTestBinariesLegacy
	const cli_testers = [
    "rust-tester-legacy",
    "cpp-tester"
  ]
end

# Module which contains the names of the functions that need to be tested.
# Thoses names get passed on to the CLI as`--function <NAME>`.
# The functions are grouped into arrays based on the expected (same) input data.
module PdreApiTestFunctions
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

	const child_child_def_type_key_value = [
		"ext_storage_child_set_version_1",
		"ext_storage_child_get_version_1",
		"ext_storage_child_clear_version_1",
		"ext_storage_child_exists_version_1"
	]

	const child_child_def_type_prefix_key_value_key_value = [
		"ext_storage_child_clear_prefix_version_1"
	]

	const child_child_def_type_key_value_key_value = [
		"ext_storage_child_storage_kill_version_1",
		"ext_storage_child_root_version_1",
		"ext_storage_child_next_key_version_1"
	]

	const child_def_type_key_value_offset_buffer_size = [
		"ext_storage_child_read_version_1"
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

# Module which contains the names of the LEGACY functions that need to be tested.
# Thoses names get passed on to the CLI as`--function <NAME>`.
# The functions are grouped into arrays based on the expected (same) input data.
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

	# Contains (mostly valid) prefixes of the corresponding keys
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

    const key_value_3 = [
      [
        "static", # value1
        "even-keeled", # value2
      ],
      [
        "function",
        "Face to face",
      ],
      [
        "Integrated",
        "budgetary management",
      ],
      [
        "non-based",
        "non-volatile",
      ],
      [
        "productivity",
        "Total",
      ],
      [
        "Exclusive",
        "concept",
      ],
      [
        "disintermediate",
        "policy",
      ],
      [
        "contingency",
        "context-sensitive",
      ],
      [
        "human-resource",
        "hardware",
      ],
      [
        "Optional",
        "object-oriented",
      ]
    ]

	const value_1 = [
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

    const value_2 = [
      [
        "even-keeled", # value
      ],
      [
        "Face to face",
      ],
      [
        "budgetary management",
      ],
      [
        "non-volatile",
      ],
      [
        "Total",
      ],
      [
        "concept",
      ],
      [
        "policy",
      ],
      [
        "context-sensitive",
      ],
      [
        "hardware",
      ],
      [
        "object-oriented",
      ]
    ]

    const value_3 = [
      [
        "Future-proofed" # value
      ],
      [
        "Expanded"
      ],
      [
        "pricing structure"
      ],
      [
        "emulation"
      ],
      [
        "Visionary"
      ],
      [
        "approach"
      ],
      [
        "function"
      ],
      [
        "Configurable"
      ],
      [
        "Automated"
      ],
      [
        "toolset"
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

	const buffer_size = [
	  [
		3 # buffer size
	  ],
	  [
		6
	  ],
	  [
		0
	  ],
	  [
		20
	  ],
	  [
		10
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
		11
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

	const seed_1 = [
		[
			"twist sausage october vivid neglect swear crumble hawk beauty fabric egg fragile"
		],
		[
			"ethics love economy wage plunge boring stove escape enrich fork language material"
		],
		[
			"anxiety story donor noodle north stadium together glare reunion method lazy ring grass laundry world excess green civil utility injury roof dolphin math derive"
		],
		[
			"depth sustain ostrich song solve bright abuse unlock gossip judge apology polar absorb blood abandon skin cheese shrimp lunch equal swarm juice detail right"
		],
		[
			"soda make bunker relax ladder civil desk text marine attract zoo electric punch fantasy claw"
		],
		[
			"kind gate rocket bright march lottery large ritual ignore glory nut pipe left hand roast"
		],
	]

	const seed_2 = [
		[
			"poet exile company mimic pony timber general toilet catalog cheese siren much"
		],
		[
			"gate believe knock boring ethics misery coast stumble grace angle sword gather"
		],
		[
			"limb arrive alert depth poet able disease coach hill orchard edge flight enable anchor awkward cute hunt club"
		],
		[
			"comic behind stomach super never book behind keep alien length cloth potato estate chair puppy match rookie prize"
		],
		[
			"bundle exchange anger dumb market waste maple attract sibling cargo weird phrase soon surge admit okay follow insane number among label"
		],
		[
			"scorpion six useless front start crawl axis win auto bird genuine sort fee convince entire minute cost village miracle hotel country"
		],
	]
end
