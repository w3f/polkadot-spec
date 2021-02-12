<TeXmacs|1.99.17>

<project|host-spec.tm>

<style|<tuple|book|old-lengths>>

<\body>
  <chapter|Bootstrapping><label|chap-bootstrapping>

  This chapter provide an overview of the tasks a node executing Polkadot
  protocol need to performs in order to join the network and start
  participating as Polkadot network node. While this chapter does not include
  any new specification of the protocol, it has been included to help the
  implementors with pointers to where the these steps are defined. In short
  the following steps should be taken by all bootstraping node:

  <\itemize-dot>
    <item>The node needs to populate the state storage with the Genesis state
    which can be obtained from <cite|??>

    <item>Using libp2p bootstraping protocol the node connects to the boot
    nodes to get the address of new peers.

    <item>get connect to more peers.

    <item>The node needs to send block request to receive all blocks and
    execute each blocks.
  </itemize-dot>

  Voter node additionally should takes the following steps.\ 

  <\itemize-dot>
    <item>Generate session keys and post them as a transaction described
    <inactive|<cite|??>>

    <item>Run catch up protocol to make sure that they are participating in
    current round and not a past round.

    <item>Verify that their session key is included in the current Epoch.

    <item>If so they should run the BABE lottery and wait for the slot they
    have been chosen to produce block Babe block production protocol to
    generate block in the slot they are give and gossip the block to their
    peers.

    <item>Run grandpa rounds protocol.
  </itemize-dot>

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
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>Bootstrapping>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>