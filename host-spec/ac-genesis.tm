<TeXmacs|1.99.16>

<project|host-spec.tm>

<style|<tuple|book|old-lengths>>

<\body>
  <appendix|Genesis State Specification><label|sect-genesis-block>

  The genesis state is a set of key-value pairs representing the intial state of
  the Polkadot state storage. It can be retrieved from
  <cite|paritytech_genesis_state>. While each of those key-value pairs offers
  important identifyable information to the Runtime, to the Polkadot Host they
  are a transparent set of arbitrary chain- and network-dependent keys and 
  values. The only exception to this are the <verbatim|:code> and
  <verbatim|:heappages> keys as described in Section
  <reference|sect-loading-runtime-code> and <reference|sect-memory-management>,
  which are used by the Polkadot Host to initialize the WASM environment and its
  Runtime. The other keys and values are unspecifed and soley depend on the
  chain and respectively its corresponding Runtime. On initialization the data
  should be inserted into the state storage with the <verbatim|set_storage> Host
  API, as defined in Section <reference|sect-storage-set>.

  \;

  As such, Polkadot does not defined a formal genesis block. Nonetheless for
  the compatibility reasons in several algorithms, the Polkadot Host defines
  the <em|genesis header> according to Definition
  <reference|defn-genesis-header>. By the abuse of terminalogy, \P<em|genesis
  block>\Q refers to the hypothetical parent of block number 1 which holds
  genisis header as its header.

  <\definition>
    <label|defn-genesis-header>The Polkadot genesis header is a data
    structure conforming to block header format described in section
    <reference|defn-block-header>. It contains the values depicted in Table
    <reference|tabl-genesis-header>:

    <\big-table|<tabular|<tformat|<cwith|7|7|1|-1|cell-tborder|0ln>|<cwith|4|4|1|-1|cell-bborder|0ln>|<cwith|7|7|1|-1|cell-bborder|1ln>|<cwith|7|7|1|1|cell-lborder|0ln>|<cwith|7|7|2|2|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|1|1|2|2|cell-width|100>|<cwith|1|1|2|2|cell-hmode|max>|<table|<row|<cell|Block
    header field>|<cell|Genesis Header Value>>|<row|<cell|<verbatim|><samp|parent_hash>>|<cell|0>>|<row|<cell|<samp|number>>|<cell|0>>|<row|<cell|<verbatim|state_root>>|<cell|Merkle
    hash of the state storage trie as defined in Definition
    <reference|defn-merkle-value> >>|<row|<cell|>|<cell|after inserting the
    genesis state in it.>>|<row|<cell|<samp|extrinsics_root>>|<cell|0>>|<row|<cell|<samp|digest>>|<cell|0>>>>>>
      <label|tabl-genesis-header>Genesis header values
    </big-table>
  </definition>

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;

</body>
