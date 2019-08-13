
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR="$DIR"/test/fixtures/
FILE=${2:-unhex_limit_trie.yaml}

KEYS_IN_HEX=${3}

COMMAND=${1:-trie-root}

echo '=============='
echo 'KAGOME'
echo '=============='
./build/bin/usr/local/bin/kagome_tester state-trie "$COMMAND" $KEYS_IN_HEX --state-file "$DIR""$FILE"
echo '=============='
echo 'RUST'
echo '=============='
./build/bin/usr/local/bin/rust_tester state-trie "$COMMAND" $KEYS_IN_HEX --state-file "$DIR""$FILE"
echo '=============='
echo 'GO'
echo '=============='
./build/bin/usr/local/bin/go_tester state-trie "$COMMAND" $KEYS_IN_HEX --state-file "$DIR""$FILE"
