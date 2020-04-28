using .AdapterTests

const TEST_DIR = String(@__DIR__) * "/"

const TEST_FILES = "'" .* TEST_DIR .* [
  "1c1.yaml",
  "scv.yaml",
  "random_state_80.yaml",
  "pk_branch.yaml",
  "pk_branch2.yaml",
  "hex_limit.yaml"
] .* "'"

const TEST_FILES_HEX = "'" .* TEST_DIR .* [
  "hex_1c1.yaml",
  "hex_limit.yaml",
  "10000_node.yaml"
] .* "'"


tests = AdapterTests.Builder("State Trie", "state-trie")

sub!(tests) do t
  arg!(t, "trie-root --state-file")
  foreach!(t, TEST_FILES)
  commit!(t)
end

sub!(tests) do t
  arg!(t, "insert-and-delete --state-file")
  foreach!(t, TEST_FILES)
  commit!(t)
end

sub!(tests) do t
  arg!(t, "trie-root --keys-in-hex --state-file")
  foreach!(t, TEST_FILES_HEX)
  commit!(t)
end

AdapterTests.prepare!(tests)

AdapterTests.execute(tests)
