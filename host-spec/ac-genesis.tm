<TeXmacs|1.99.12>

<project|host-spec.tm>

<style|book>

<\body>
  <appendix|Genesis State Specification><label|sect-genesis-block>

  The genesis state represents the intial state of Polkadot state storage as
  a set of key-value pairs, which can be retrieved from
  <cite|web3.0_technologies_foundation_polkadot_2020>. While each of those
  key/value pairs offer important identifyable information which can be used
  by the Runtime, from the Polkadot Host points of view, it is a set of
  arbitrary key-value pair data as it is chain and network dependent.
  \ Except for the <verbatim|:code> described in Section
  <reference|sect-loading-runtime-code> which needs to be identified by the
  Polkadot Host to load its content as the Runtime. The other keys and values
  are unspecifed and its usage depends on the chain respectively its
  corresponding Runtime. The data should be inserted into the state storage
  with the <verbatim|set_storage> Host API, as defined in Section
  <reference|sect-set-storage>.

  As such, Polkadot does not defined a formal genesis block. Nonetheless for
  the complatibilty reasons in several algorithms, the Polkadot Host defines
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

<\initial>
  <\collection>
    <associate|page-first|?>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|A|?|c01-background.tm>>
    <associate|auto-2|<tuple|A.1|?|c01-background.tm>>
    <associate|defn-genesis-header|<tuple|A.1|?|c01-background.tm>>
    <associate|sect-genesis-block|<tuple|A|?|c01-background.tm>>
    <associate|tabl-genesis-header|<tuple|A.1|?|c01-background.tm>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      web3.0_technologies_foundation_polkadot_2020
    </associate>
    <\associate|table>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.1>|>
        Genesis header values
      </surround>|<pageref|auto-2>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Genesis State Specification>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>