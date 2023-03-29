---
title: Polkadot Host
---

With the current document, we aim to specify the Polkadot Host part of the Polkadot protocol as a replicated state machine. After defining the different types of hosts in [Chapter -chap-num-ref-](chap-overview), we proceed to specify the representation of a valid state of the Protocol in [Chapter -chap-num-ref-](chap-state). We also identify the protocol states, by explaining the Polkadot state transition and discussing the detail based on which the Polkadot Host interacts with the state transition function, i.e. Runtime in the same chapter. Following, we specify the input messages triggering the state transition and the system behavior. In [Chapter -chap-num-ref-](chap-networking), we specify the communication protocols and network messages required for the Polkadot Host to communicate with other nodes in the network, such as exchanging blocks and consensus messages. In [Chapter -chap-num-ref-](sect-block-production) and [Chapter -chap-num-ref-](sect-finality), we specify the consensus protocol, which is responsible for keeping all the replica in the same state. Finally, the initial state of the machine is identified and discussed in [Section -sec-num-ref-](id-cryptography-encoding#chapter-genesis). A Polkadot Host implementation which conforms with this part of the specification should successfully be able to sync its states with the Polkadot network.

- [Overview](chap-overview)

- [States and Transitions](chap-state)

- [Synchronization](chap-sync)

- [Networking](chap-networking)

- [Block Production](sect-block-production)

- [Finality](sect-finality)

- [Light Clients](sect-lightclient)

- [Availability & Validity](chapter-anv)
