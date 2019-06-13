;;scale
(gdb "gdb -i=mi --cd ../build/bin/usr/local/bin/  --args ./go_tester scale-codec encode --input 1")

;;trie-root
(gdb "gdb -i=mi --cd ../build/bin/usr/local/bin/  --args ./go_tester state-trie trie-root --state-file \"../../../../../test/fixtures/random_state_trie_80.yaml\"")

(gdb "gdb -i=mi --cd ../build/bin/usr/local/bin/  --args ./go_tester state-trie trie-root --state-file \"../../../../../test/fixtures/1c1_trie.yaml\"")

