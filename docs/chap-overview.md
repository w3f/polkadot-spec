---
title: -chap-num- Overview
---

The Polkadot Protocol differentiates between different classes of Polkadot Hosts. Each class differs in their trust roots and how active or passively they interact with the network.

## -sec-num- Light Client {#sect-client-light}

The light client is a mostly passive participant in the protocol. Light clients are designed to work in resource constrained environments like browsers, mobile devices or even on-chain. Its main objective is to follow the chain, make queries to the full node on specific information on recent state of the blockchain, and to add extrinsics (transactions). It does not maintain the full state, rather queries the full node on the latest finalized state and verifies the authenticity of the responses trustlessly. Details of specifications focused for Light Clients can be found in [Chapter -chap-num-ref-](sect-lightclient).

## -sec-num- Full Node {#sect-node-full}

While the full node is still a mostly passive participant of the protocol, they follow the chain by receiving and verifying every block in the chain. It maintains full state of the blockchain by executing the extrinsics in blocks. Their role in consesus mechanism is limited to following the chain and not producing the blocks.

- **Functional Requirements:**

  1.  The node must populate the state storage with the official genesis state, elaborated further in [Section -sec-num-ref-](id-cryptography-encoding#section-genesis).

  2.  The node should maintain a set of around 50 active peers at any time. New peers can be found using the discovery protocols ([Section -sec-num-ref-](chap-networking#sect-discovery-mechanism))

  3.  The node should open and maintain the various required streams ([Section -sec-num-ref-](chap-networking#sect-protocols-substreams)) with each of its active peers.

  4.  Furthermore, the node should send block requests ([Section -sec-num-ref-](chap-networking#sect-msg-block-request)) to these peers to receive all blocks in the chain and execute each of them.

  5.  The node should exchange neighbor packets ([Section -sec-num-ref-](chap-networking#sect-grandpa-neighbor-msg)).

## -sec-num- Authoring Node {#sect-node-authoring}

The authoring node covers all the features of the full node but instead of just passivly following the protocol, it is an active participant, producing blocks and voting in Grandpa.

- **Functional Requirements:**

  1.  Verify that the Host’s session key is included in the current Epoch’s authority set ([Section -sec-num-ref-](chap-sync#sect-authority-set)).

  2.  Run the BABE lottery ([Chapter -chap-num-ref-](sect-block-production)) and wait for the next assigned slot in order to produce a block.

  3.  Gossip any produced blocks to all connected peers ([Section -sec-num-ref-](chap-networking#sect-msg-block-announce)).

  4.  Run the catch-up protocol ([Section -sec-num-ref-](sect-finality#sect-grandpa-catchup)) to make sure that the node is participating in the current round and not a past round.

  5.  Run the GRANDPA rounds protocol ([Chapter -chap-num-ref-](sect-finality)).

## -sec-num- Relaying Node {#sect-node-relaying}

The relaying node covers all the features of the authoring node, but also participants in the availability and validity process to process new parachain blocks as described in [Chapter -chap-num-ref-](chapter-anv).
