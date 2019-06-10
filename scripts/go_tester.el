;;scale
(gdb "gdb -i=mi --cd ../build/bin/usr/local/bin/  --args ./go_tester scale-codec encode --input 1")

;;trie-root
(gdb "gdb -i=mi --cd ../build/bin/usr/local/bin/  --args ./go_tester state-trie state-root --state-file \"../../../../../test/fixtures/random_state_fixture.yaml\"")
