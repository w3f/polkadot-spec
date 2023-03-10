---
title: Polkadot Host
---

With the current document, we aim to specify the Polkadot Host part of the Polkadot protocol as a replicated state machine. After defining the different types of hosts in [Chapter 1](chap-overview.html), we proceed to specify the representation of a valid state of the Protocol in [Chapter 2](chap-state.html). We also identify the protocol states, by explaining the Polkadot state transition and discussing the detail based on which the Polkadot Host interacts with the state transition function, i.e. Runtime in the same chapter. Following, we specify the input messages triggering the state transition and the system behavior. In [Chapter 4](chap-networking.html), we specify the communication protocols and network messages required for the Polkadot Host to communicate with other nodes in the network, such as exchanging blocks and consensus messages. In [Chapter 5](sect-block-production.html) and [Chapter 6](sect-finality.html), we specify the consensus protocol, which is responsible for keeping all the replica in the same state. Finally, the initial state of the machine is identified and discussed in [Section A.3](id-cryptography-encoding.html#chapter-genesis). A Polkadot Host implementation which conforms with this part of the specification should successfully be able to sync its states with the Polkadot network.

- [Overview](chap-overview.html)

- [States and Transitions](chap-state.html)

- [Synchronization](chap-sync.html)

- [Networking](chap-networking.html)

- [Block Production](sect-block-production.html)

- [Finality](sect-finality.html)

- [Light Clients](sect-lightclient.html)

- [Availability & Validity](chapter-anv.html)
