<TeXmacs|1.99.17>

<project|host-spec.tm>

<style|<tuple|book|old-lengths>>

<\body>
  <chapter|Bootstrapping><label|chap-bootstrapping>

  This chapter provides an overview over the tasks a Polkadot Host needs to
  performs in order to join and participate in the Polkadot network. While
  this chapter does not go into any new specifications of the protocol, it
  has been included to provide implementors with a pointer to what these
  steps are and where they are defined. In short, the following steps should
  be taken by all bootstrapping nodes:

  <\enumerate>
    <item>The node needs to populate the state storage with the official
    Genesis state which can be obtained from
    <cite|paritytech_genesis_state\<gtr\>>.

    <item>The node should maintains a set of around 50 active peers at any
    time. New peers can be found using the <verbatim|libp2p> discovery
    protocols (Section <reference|sect-discovery-mechanism>)

    <item>The node should open and maintain the various required streams
    (Section <reference|sect-protocols-substreams>) with each of its active
    peers.\ 

    <item>Furhtermore, the node should send block requests (Section
    <reference|sect-requesting-blocks>) to these peers to receive all blocks
    in the chain and execute each of them.

    <item>Exchange neighbor packets (Section <reference|sect-msg-grandpa>)

    \;
  </enumerate>

  Validator nodes should take the following additional steps.\ 

  <\enumerate>
    <item>Verify that the Host's session key is included in the current Epoch's
    authority set (Section <reference|sect-authority-set>)

    <item>Run the BABE lottery (Section <reference|sect-block-production>)
    and wait for the next assigned slot in order to produce a block.\ 

    <item>Gossip any produced blocks to all connected peers (Section
    <reference|sect-announcing-block>)

    <item>Run catch up protocol (Section <reference|sect-grandpa-messages>)
    to make sure that they are participating in the current round and not a past
    round.

    <item>Run the grandpa rounds protocol (Section <reference|sect-finality>)
  </enumerate>

  \;

  \;

  \;
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|4>
    <associate|page-first|41>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
    <associate|section-nr|3<uninit>>
    <associate|subsection-nr|4>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|5|?>>
    <associate|chap-bootstrapping|<tuple|5|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      ??
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>Bootstrapping>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>
