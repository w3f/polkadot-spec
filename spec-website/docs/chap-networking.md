---
title: Networking
---

|     |                                                                                                                                                                                                                                                                                                                                              |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This chapter in its current form is incomplete and considered work in progress. Authors appreciate receiving request for clarification or any reports regarding deviation from the current Polkadot network protocol. This can be done through filing an issue in [Polkadot Specification repository](https://github.com/w3f/polkadot-spec). |

## [](#id-introduction-2)[4.1. Introduction](#id-introduction-2)

The Polkadot network is decentralized and does not rely on any central authority or entity for achieving its fullest potential of provided functionality. The networking protocol is based on a family of open protocols, including protocol implemented *libp2p* e.g. the distributed Kademlia hash table which is used for peer discovery.

This chapter walks through the behavior of the networking implementation of the Polkadot Host and defines the network messages. The implementation details of the *libp2p* protocols used are specified in external sources as described in [Section 4.2](chap-networking.html#sect-networking-external-docs)

## [](#sect-networking-external-docs)[4.2. External Documentation](#sect-networking-external-docs)

Complete specification of the Polkadot networking protocol relies on the following external protocols:

- [libp2p](https://github.com/libp2p/specs) - *libp2p* is a modular peer-to-peer networking stack composed of many modules and different parts. includes the multiplexing protocols and .

- [libp2p addressing](https://docs.libp2p.io/concepts/addressing/) - The Polkadot Host uses the *libp2p* addressing system to identify and connect to peers.

- [Kademlia](https://en.wikipedia.org/wiki/Kademlia) - *Kademlia* is a distributed hash table for decentralized peer-to-peer networks. The Polkadot Host uses Kademlia for peer discovery.

- [Noise](https://noiseprotocol.org/) - The *Noise* protocol is a framework for building cryptographic protocols. The Polkadot Host uses Noise to establish the encryption layer to remote peers.

- [yamux](https://docs.libp2p.io/concepts/stream-multiplexing/#yamux) - *yamux* is a multiplexing protocol developed by HashiCorp. It is the de-facto standard for the Polkadot Host. [Section 4.7](chap-networking.html#sect-protocols-substreams) describes the subprotocol in more detail.

- [Protocol Buffers](https://developers.google.com/protocol-buffers/docs/reference/proto3-spec) - Protocol Buffers is a language-neutral, platform-neutral mechanism for serializing structured data and is developed by Google. The Polkadot Host uses Protocol Buffers to serialize specific messages, as clarified in [Section 4.8](chap-networking.html#sect-network-messages).

## [](#id-node-identities)[4.3. Node Identities](#id-node-identities)

Each Polkadot Host node maintains an ED25519 key pair which is used to identify the node. The public key is shared with the rest of the network allowing the nodes to establish secure communication channels.

Each node must have its own unique ED25519 key pair. If two or more nodes use the same key, the network will interpret those nodes as a single node, which will result in unspecified behavior. Furthermore, the node’s *PeerId* as defined in [Definition 34](chap-networking.html#defn-peer-id) is derived from its public key. *PeerId* is used to identify each node when they are discovered in the course of the discovery mechanism described in [Section 4.4](chap-networking.html#sect-discovery-mechanism).

Definition 34. [PeerId](chap-networking.html#defn-peer-id)

The Polkadot node’s PeerId, formally referred to as $P\_(id)$, is derived from the ED25519 public key and is structured based on the [libp2p specification](https://docs.libp2p.io/concepts/peer-id/), but does not fully conform to the specification. Specifically, it does not support [CID](https://github.com/multiformats/cid) and the only supported key type is ED25519.

The byte representation of the PeerId is always of the following bytes in this exact order:

$b_0 = 0$ $b_1 = 36$ $b_2 = 8$ $b_3 = 1$ $b_4 = 18$ $b_5 = 32$ $b\_(6..37) = ...$

where

- $b_0$ is the [multihash prefix](https://github.com/multiformats/multihash#multihash) of value $0$ (implying no hashing is used).

- $b_1$ the length of the PeerId (remaining bytes).

- $b_2$ and $b_3$ are a protobuf encoded field-value pair [indicating the used key type](https://github.com/libp2p/specs/blob/master/peer-ids/peer-ids.md#keys) (field $1$ of value $1$ implies *ED25519*).

- $b_4$, $b_5$ and $b\_(6..37)$ are a protobuf encoded field-value pair where $b_5$ indicates the length of the public key followed by the the raw ED25519 public key itself, which varies for each Polkadot Host and is always 32 bytes (field $2$ contains the public key, which has a field value length prefix).

## [](#sect-discovery-mechanism)[4.4. Discovery mechanism](#sect-discovery-mechanism)

The Polkadot Host uses various mechanisms to find peers within the network, to establish and maintain a list of peers and to share that list with other peers from the network as follows:

- **Bootstrap nodes** are hard-coded node identities and addresses provided by the genesis state ([Section A.3](id-cryptography-encoding.html#chapter-genesis)).

- **mDNS** is a protocol that performs a broadcast to the local network. Nodes that might be listening can respond to the broadcast. [The libp2p mDNS specification](https://github.com/libp2p/specs/blob/master/discovery/mdns.md) defines this process in more detail. This protocol is an optional implementation detail for Polkadot Host implementers and is not required to participate in the Polkadot network.

- **Kademlia requests** invoking Kademlia requests, where nodes respond with their list of available peers. Kademlia requests are performed on a specific substream as described in [Section 4.7](chap-networking.html#sect-protocols-substreams).

## [](#sect-connection-establishment)[4.5. Connection establishment](#sect-connection-establishment)

Polkadot nodes connect to peers by establishing a TCP connection. Once established, the node initiates a handshake with the remote peers on the encryption layer. An additional layer on top of the encryption layer, known as the multiplexing layer, allows a connection to be split into substreams, as described by the [yamux specification](https://docs.libp2p.io/concepts/stream-multiplexing/#yamux), either by the local or remote node.

The Polkadot node supports two types of substream protocols. [Section 4.7](chap-networking.html#sect-protocols-substreams) describes the usage of each type in more detail:

- **Request-Response substreams**: After the protocol is negotiated by the multiplexing layer, the initiator sends a single message containing a request. The responder then sends a response, after which the substream is then immediately closed. The requests and responses are prefixed with their [LEB128](https://en.wikipedia.org/wiki/LEB128) encoded length.

- **Notification substreams**. After the protocol is negotiated, the initiator sends a single handshake message. The responder can then either accept the substream by sending its own handshake or reject it by closing the substream. After the substream has been accepted, the initiator can send an unbound number of individual messages. The responder keeps its sending side of the substream open, despite not sending anything anymore, and can later close it in order to signal to the initiator that it no longer wishes to communicate.

  Handshakes and messages are prefixed with their [LEB128](https://en.wikipedia.org/wiki/LEB128) encoded lengths. A handshake can be empty, in which case the length prefix would be *0*.

Connections are established by using the following protocols:

- `/noise` - a protocol that is announced when a connection to a peer is established.

- `/multistream/1.0.0` - a protocol that is announced when negotiating an encryption protocol or a substream.

- `/yamux/1.0.0` - a protocol used during *yamux* negotiation. See [Section 4.7](chap-networking.html#sect-protocols-substreams) for more information.

The Polkadot Host can establish a connection with any peer of which it knows the address. The Polkadot Host supports multiple networking protocols:

- **TCP/IP** with addresses in the form of `/ip4/1.2.3.4/tcp/30333` to establish a TCP connection and negotiate encryption and a multiplexing layer.

- **WebSocket** with addresses in the form of `/ip4/1.2.3.4/tcp/30333/ws` to establish a TCP connection and negotiate the WebSocket protocol within the connection. Additionally, encryption and multiplexing layer is negotiated within the WebSocket connection.

- **DNS** addresses in form of `/dns/example.com/tcp/30333` and `/dns/example.com/tcp/30333/ws`.

The addressing system is described in the [libp2p addressing](https://docs.libp2p.io/concepts/addressing/) specification. After a base-layer protocol is established, the Polkadot Host will apply the Noise protocol to establish the encryption layer as described in [Section 4.6](chap-networking.html#sect-encryption-layer).

## [](#sect-encryption-layer)[4.6. Encryption Layer](#sect-encryption-layer)

Polkadot protocol uses the *libp2p* Noise framework to build an encryption protocol. The Noise protocol is a framework for building encryption protocols. *libp2p* utilizes that protocol for establishing encrypted communication channels. Refer to the [libp2p Secure Channel Handshake](https://github.com/libp2p/specs/tree/master/noise) specification for a detailed description.

Polkadot nodes use the [XX handshake pattern](https://noiseexplorer.com/patterns/XX/) to establish a connection between peers. The three following steps are required to complete the handshake process:

1.  The initiator generates a keypair and sends the public key to the responder. The [Noise specification](https://github.com/libp2p/specs/tree/master/noise) and the [libp2p PeerId specification](https://github.com/libp2p/specs/blob/master/peer-ids/peer-ids.md) describe keypairs in more detail.

2.  The responder generates its own key pair and sends its public key back to the initiator. After that, the responder derives a shared secret and uses it to encrypt all further communication. The responder now sends its static Noise public key (which may change anytime and does not need to be persisted on disk), its *libp2p* public key and a signature of the static Noise public key signed with the *libp2p* public key.

3.  The initiator derives a shared secret and uses it to encrypt all further communication. It also sends its static Noise public key, *libp2p* public key and signature to the responder.

After these three steps, both the initiator and responder derive a new shared secret using the static and session-defined Noise keys, which are used to encrypt all further communication.

## [](#sect-protocols-substreams)[4.7. Protocols and Substreams](#sect-protocols-substreams)

After the node establishes a connection with a peer, the use of multiplexing allows the Polkadot Host to open substreams. *libp2p* uses the [*yamux protocol*](https://docs.libp2p.io/concepts/stream-multiplexing/#yamux) to manage substreams and to allow the negotiation of *application-specific protocols*, where each protocol serves a specific utility.

The Polkadot Host uses multiple substreams whose usage depends on a specific purpose. Each substream is either a *Request-Response substream* or a *Notification substream*, as described in [Section 4.5](chap-networking.html#sect-connection-establishment).

|     |                                                                                                                                                                                                                                                                                           |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | The prefixes on those substreams are known as protocol identifiers and are used to segregate communications to specific networks. This prevents any interference with other networks. `dot` is used exclusively for Polkadot. Kusama, for example, uses the protocol identifier `ksmcc3`. |

- `/ipfs/ping/1.0.0` - Open a standardized substream *libp2p* to a peer and initialize a ping to verify if a connection is still alive. If the peer does not respond, the connection is dropped. This is a *Request-Response substream*.

  Further specification and reference implementation are available in the [libp2p documentation](https://docs.libp2p.io/concepts/protocols/#ping).

- `/ipfs/id/1.0.0` - Open a standardized *libp2p* substream to a peer to ask for information about that peer. This is a *Request-Response substream*, but the initiator does **not** send any message to the responder and only waits for the response.

  Further specification and reference implementation are available in the [libp2p documentation](https://docs.libp2p.io/concepts/protocols/#identify).

- `/dot/kad` - Open a standardized substream for Kademlia `FIND_NODE` requests. This is a *Request-Response substream*, as defined by the *libp2p* standard.

  Further specification and reference implementation are available on [Wikipedia](https://en.wikipedia.org/wiki/Kademlia) respectively the [golang Github repository](https://github.com/libp2p/go-libp2p-kad-dht).

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/light/2` - a request and response protocol that allows a light client to request information about the state. This is a *Request-Response substream*.

  The messages are specified in [Section 7.4](sect-lightclient.html#sect-light-msg).

  |     |                                                                                                   |
  |-----|---------------------------------------------------------------------------------------------------|
  |     | For backwards compatibility reasons, `/dot/light/2` is also a valid substream for those messages. |

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/block-announces/1` - a substream/notification protocol which sends blocks to connected peers. This is a *Notification substream*.

  The messages are specified in [Section 4.8.1](chap-networking.html#sect-msg-block-announce).

  |     |                                                                                                             |
  |-----|-------------------------------------------------------------------------------------------------------------|
  |     | For backwards compatibility reasons, `/dot/block-announces/1` is also a valid substream for those messages. |

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/sync/2` - a request and response protocol that allows the Polkadot Host to request information about blocks. This is a *Request-Response substream*.

  The messages are specified in [Section 4.8.2](chap-networking.html#sect-msg-block-request).

  |     |                                                                                                  |
  |-----|--------------------------------------------------------------------------------------------------|
  |     | For backwards compatibility reasons, `/dot/sync/2` is also a valid substream for those messages. |

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/sync/warp` - a request and response protocol that allows the Polkadot Host to perform a warp sync request. This is a *Request-Response substream*.

  The messages are specified in [Section 4.8.4](chap-networking.html#sect-msg-warp-sync).

  |     |                                                                                                     |
  |-----|-----------------------------------------------------------------------------------------------------|
  |     | For backwards compatibility reasons, `/dot/sync/warp` is also a valid substream for those messages. |

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/transactions/1` - a substream/notification protocol which sends transactions to connected peers. This is a *Notification substream*.

  The messages are specified in [Section 4.8.5](chap-networking.html#sect-msg-transactions).

  |     |                                                                                                          |
  |-----|----------------------------------------------------------------------------------------------------------|
  |     | For backwards compatibility reasons, `/dot/transactions/1` is also a valid substream for those messages. |

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/grandpa/1` - a substream/notification protocol that sends GRANDPA votes to connected peers. This is a *Notification substream*.

  The messages are specified in [Section 4.8.6](chap-networking.html#sect-msg-grandpa).

  |     |                                                                                                            |
  |-----|------------------------------------------------------------------------------------------------------------|
  |     | For backwards compatibility reasons, `/paritytech/grandpa/1` is also a valid substream for those messages. |

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/beefy/1` - a substream/notification protocol which sends signed BEEFY statements, as described in [Section 6.7](sect-finality.html#sect-grandpa-beefy), to connected peers. This is a *Notification* substream.

  The messages are specified in [Section 4.8.7](chap-networking.html#sect-msg-grandpa-beefy).

  |     |                                                                                                          |
  |-----|----------------------------------------------------------------------------------------------------------|
  |     | For backwards compatibility reasons, `/paritytech/beefy/1` is also a valid substream for those messages. |

## [](#sect-network-messages)[4.8. Network Messages](#sect-network-messages)

The Polkadot Host must actively communicate with the network in order to participate in the validation process or act as a full node.

|     |                                                                                                                                                                                                                                                                                                       |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | The Polkadot network originally only used SCALE encoding for all message formats. Meanwhile, Protobuf has been adopted for certain messages. The encoding of each listed message is always SCALE encoded unless Protobuf is explicitly mentioned. Encoding and message formats are subject to change. |

### [](#sect-msg-block-announce)[4.8.1. Announcing blocks](#sect-msg-block-announce)

When the node creates or receives a new block, it must be announced to the network. Other nodes within the network will track this announcement and can request information about this block. The mechanism for tracking announcements and requesting the required data is implementation-specific.

Block announcements, requests and responses are sent over the substream as described in [Definition 35](chap-networking.html#defn-block-announce-handshake).

Definition 35. [Block Announce Handshake](chap-networking.html#defn-block-announce-handshake)

The `BlockAnnounceHandshake` initializes a substream to a remote peer. Once established, all `BlockAnounce` messages ([Definition 36](chap-networking.html#defn-block-announce)) created by the node are sent to the `/dot/block-announces/1` substream.

The `BlockAnnounceHandshake` is a structure of the following format:

$BA_h = "Enc"\_("SC")(R, N_B, h_B, h_G)$

where:

$R = {(1,"The node is a full node"),(2,"The node is a light client"),(4,"The node is a validator"):}$ $N_B = "Best block number according to the node"$ $h_B = "Best block hash according to the node"$ $h_G = "Genesis block hash according to the node"$

Definition 36. [Block Announce](chap-networking.html#defn-block-announce)

The `BlockAnnounce` message is sent to the specified substream and indicates to remote peers that the node has either created or received a new block.

The message is a structure of the following format:

$BA = "Enc"\_("SC")("Head"(B),b)$

where:

$"Head"(B) = "Header of the announced block"$ $b = {(0,"Is not part of the best chain"),(1,"Is the best block according to the node"):}$

### [](#sect-msg-block-request)[4.8.2. Requesting Blocks](#sect-msg-block-request)

Block requests can be used to retrieve a range of blocks from peers. Those messages are sent over the `/dot/sync/2` substream.

Definition 37. [Block Request](chap-networking.html#defn-msg-block-request)

The `BlockRequest` message is a Protobuf serialized structure of the following format:

| Type        | Id  | Description                                                       | Value   |
|-------------|-----|-------------------------------------------------------------------|---------|
| `uint32`    | 1   | Bits of block data to request                                     | $B_f$ |
| `oneof`     |     | Start from this block                                             | $B_s$ |
| *Direction* | 5   | Sequence direction, interpreted as Id *0* (ascending) if missing. |         |
| `uint32`    | 6   | Maximum amount (*optional*)                                       | $B_m$ |

where  
- $B_f$ indicates all the fields that should be included in the request. its **big-endian** encoded bitmask that applies to all desired fields with bitwise OR operations. For example, the $B_f$ value to request *Header* and *Justification* is *0001 0001* (17).

  | Field         | Value     |
  |---------------|-----------|
  | Header        | 0000 0001 |
  | Body          | 0000 0010 |
  | Justification | 0001 0000 |

- $B_s$ is a Protobuf structure indicating a varying data type (enum) of the following values:

  | Type    | Id  | Description      |
  |---------|-----|------------------|
  | `bytes` | 2   | The block hash   |
  | `bytes` | 3   | The block number |

- *Direction* is a Protobuf structure indicating the sequence direction of the requested blocks. The structure is a varying data type (enum) of the following format:

  | Id  | Description                                                    |
  |-----|----------------------------------------------------------------|
  | 0   | Enumerate in ascending order (from child to parent)            |
  | 1   | Enumerate in descending order (from parent to canonical child) |

- $B_m$ is the number of blocks to be returned. An implementation defined maximum is used when unspecified.

Definition 38. [Block Response](chap-networking.html#defn-msg-block-response)

The `BlockResponse` message is received after sending a `BlockRequest` message to a peer. The message is a Protobuf serialized structure of the following format:

| Type                 | Id  | Description                           |
|----------------------|-----|---------------------------------------|
| Repeated *BlockData* | 1   | Block data for the requested sequence |

where *BlockData* is a Protobuf structure containing the requested blocks. Do note that the optional values are either present or absent depending on the requested fields (bitmask value). The structure has the following format:

| Type             | Id  | Description                                                           | Value                                                          |
|------------------|-----|-----------------------------------------------------------------------|----------------------------------------------------------------|
| `bytes`          | 1   | Block header hash                                                     | [Definition 12](chap-state.html#defn-block-header-hash)        |
| `bytes`          | 2   | Block header (optional)                                               | [Definition 10](chap-state.html#defn-block-header)             |
| repeated `bytes` | 3   | Block body (optional)                                                 | [Definition 13](chap-state.html#defn-block-body)               |
| `bytes`          | 4   | Block receipt (optional)                                              |                                                                |
| `bytes`          | 5   | Block message queue (optional)                                        |                                                                |
| `bytes`          | 6   | Justification (optional)                                              | [Definition 78](sect-finality.html#defn-grandpa-justification) |
| `bool`           | 7   | Indicates whether the justification is empty (i.e. should be ignored) |                                                                |

### [](#sect-msg-state-request)[4.8.3. Requesting States](#sect-msg-state-request)

The Polkadot Host can request the state in form of a key/value list at a specified block.

When receiving state entries from the state response messages ([Definition 40](chap-networking.html#defn-msg-state-response)), the node can verify the entries with the entry proof (id *1* in *KeyValueStorage*) against the merkle root in the block header (of the block specified in [Definition 39](chap-networking.html#defn-msg-state-request)). Once the state response message claims that all entries have been sent (id *3* in *KeyValueStorage*), the node can use all collected entry proofs and validate it against the merkle root to confirm that claim.

See the the synchronization chapter for more information ([Chapter 3](chap-sync.html)).

Definition 39. [State Request](chap-networking.html#defn-msg-state-request)

A **state request** is sent to a peer to request the state at a specified block. The message is a single 32-byte Blake2 hash which indicates the block from which the sync should start.

Depending on what substream is used, he remote peer either sends back a state response ([Definition 40](chap-networking.html#defn-msg-state-response)) on the `/dot/sync/2` substream or a warp sync proof ([Definition 41](chap-networking.html#defn-warp-sync-proof)) on the `/dot/sync/warp`.

Definition 40. [State Response](chap-networking.html#defn-msg-state-response)

The **state response** is sent to the peer that initialized the state request ([Definition 39](chap-networking.html#defn-msg-state-request)) and contains a list of key/value entries with an associated proof. This response is sent continuously until all key/value pairs have been submitted.

| Type                          | Id  | Description   |
|-------------------------------|-----|---------------|
| `repeated KeyValueStateEntry` | 1   | State entries |
| `bytes`                       | 2   | State proof   |

where *KeyValueStateEntry* is of the following format:

| Type                  | Id  | Description                                       |
|-----------------------|-----|---------------------------------------------------|
| `bytes`               | 1   | Root of the entry, empty if top level             |
| `repeated StateEntry` | 2   | Collection of key/values                          |
| `bool`                | 3   | Equal 'true' if there are no more keys to return. |

and *StateEntry*:

| Type    | Id  | Description            |
|---------|-----|------------------------|
| `bytes` | 1   | The key of the entry   |
| `bytes` | 2   | The value of the entry |

### [](#sect-msg-warp-sync)[4.8.4. Warp Sync](#sect-msg-warp-sync)

The warp sync protocols allows nodes to retrieve blocks from remote peers where authority set changes occurred. This can be used to speed up synchronization to the latest state.

See the the synchronization chapter for more information ([Chapter 3](chap-sync.html)).

Definition 41. [Warp Sync Proof](chap-networking.html#defn-warp-sync-proof)

The **warp sync proof** message, $P$, is sent to the peer that initialized the state request ([Definition 39](chap-networking.html#defn-msg-state-request)) on the `/dot/sync/warp` substream and contains accumulated proof of multiple authority set changes ([Section 3.3.2](chap-sync.html#sect-consensus-message-digest)). It’s a datastructure of the following format:

$P = (f_x...f_y, c)$

$f_x...f_y$ is an array consisting of warp sync fragments of the following format:

$f_x = (B_h, J^(r,"stage")(B))$

where $B_h$ is the last block header containing a digest item ([Definition 11](chap-state.html#defn-digest)) signaling an authority set change from which the next authority set change can be fetched from. $J^(r,"stage")(B)$ is the GRANDPA justification ([Definition 78](sect-finality.html#defn-grandpa-justification)) and $c$ is a boolean that indicates whether the warp sync has been completed.

### [](#sect-msg-transactions)[4.8.5. Transactions](#sect-msg-transactions)

Transactions ([Section 2.3](chap-state.html#sect-extrinsics)) are sent directly to peers with which the Polkadot Host has an open transaction substream ([Definition 42](chap-networking.html#defn-transactions-message)). Polkadot Host implementers should implement a mechanism that only sends a transaction once to each peer and avoids sending duplicates. Sending duplicate transactions might result in undefined consequences such as being blocked for bad behavior by peers.

The mechanism for managing transactions is further described in Section [Section 2.3](chap-state.html#sect-extrinsics).

Definition 42. [Transaction Message](chap-networking.html#defn-transactions-message)

The **transactions message** is the structure of how the transactions are sent over the network. It is represented by $M_T$ and is defined as follows:

$M_T := "Enc"\_("SC")(C_1,...,C_n)$

in which:

$C_i := "Enc"\_("SC")(E_i)$

Where each $E_i$ is a byte array and represents a separate extrinsic. The Polkadot Host is agnostic about the content of an extrinsic and treats it as a blob of data.

Transactions are sent over the `/dot/transactions/1` substream.

### [](#sect-msg-grandpa)[4.8.6. GRANDPA Messages](#sect-msg-grandpa)

The exchange of GRANDPA messages is conducted on the substream. The process for the creation and distributing these messages is described in [Chapter 6](sect-finality.html). The underlying messages are specified in this section.

Definition 43. [Grandpa Gossip Message](chap-networking.html#defn-gossip-message)

A **GRANDPA gossip message**, $M$, is a varying datatype ([Definition 188](id-cryptography-encoding.html#defn-varrying-data-type)) which identifies the message type that is cast by a voter followed by the message itself.

$M = {(0,"Vote message", V_m),(1,"Commit message", C_m),(2,"Neighbor message", N_m),(3,"Catch-up request message",R_m),(4,"Catch-up message",U_m):}$

where  
- $V_m$ is defined in [Definition 44](chap-networking.html#defn-grandpa-vote-msg).

- $C_m$ is defined in [Definition 46](chap-networking.html#defn-grandpa-commit-msg).

- $N_m$ is defined in [Definition 47](chap-networking.html#defn-grandpa-neighbor-msg).

- $R_m$ is defined in [Definition 48](chap-networking.html#defn-grandpa-catchup-request-msg).

- $U_M$ is defined in [Definition 49](chap-networking.html#defn-grandpa-catchup-response-msg).

Definition 44. [GRANDPA Vote Messages](chap-networking.html#defn-grandpa-vote-msg)

A **GRANDPA vote message** by voter $v$, $M_v^(r,"stage")$, is gossip to the network by voter $v$ with the following structure:

$M_v^(r,"stage")(B) := "Enc"\_("SC")(r,"id"\_(\mathbb V),"SigMsg")$ $"SigMsg" := ("msg","Sig"\_(v_i)^(r,"stage"),v\_("id"))$ $"msg" := "Enc"\_("SC")("stage",V_v^(r,"stage")(B))$

where  
- $r$ is an unsigned 64-bit integer indicating the Grandpa round number ([Definition 76](sect-finality.html#defn-voting-rounds)).

- $"id"\_(\mathbb V)$ is an unsigned 64-bit integer indicating the authority Set Id ([Definition 33](chap-sync.html#defn-authority-list)).

- $"Sig"\_(v_i)^(r,"stage")$ is a 512-bit byte array containing the signature of the authority ([Definition 77](sect-finality.html#defn-sign-round-vote)).

- $v\_(id)$ is a 256-bit byte array containing the *ed25519* public key of the authority.

- $"stage"$ is a 8-bit integer of value *0* if it’s a pre-vote sub-round, *1* if it’s a pre-commit sub-round or *2* if it’s a primary proposal message.

- $V_v^(r,"stage")(B)$ is the GRANDPA vote for block $B$ ([Definition 76](sect-finality.html#defn-voting-rounds)).

This message is the sub-component of the GRANDPA gossip message ([Definition 43](chap-networking.html#defn-gossip-message)) of type Id 0.

Definition 45. [GRANDPA Compact Justification Format](chap-networking.html#defn-grandpa-justifications-compact)

The **GRANDPA compact justification format** is an optimized data structure to store a collection of pre-commits and their signatures to be submitted as part of a commit message. Instead of storing an array of justifications, it uses the following format:

$J\_(v\_(0,...n))^(r,"comp") := ({V\_(v_0)^(r,pc),... V\_(v_n)^(r,pc)},{("Sig"\_(v_0)^(r,pc),v\_("id"\_0)), ... ("Sig"\_(v_n)^(r,pc),v\_("id"\_n))})$

where  
- $V\_(v_i)^(r,pc)$ is a 256-bit byte array containing the pre-commit vote of authority $v_i$ ([Definition 76](sect-finality.html#defn-voting-rounds)).

- $"Sig"\_(v_i)^(r,pc)$ is a 512-bit byte array containing the pre-commit signature of authority $v_i$ ([Definition 77](sect-finality.html#defn-sign-round-vote)).

- $v\_("id"\_n)$ is a 256-bit byte array containing the public key of authority $v_i$.

Definition 46. [GRANDPA Commit Message](chap-networking.html#defn-grandpa-commit-msg)

A **GRANDPA commit message** for block $B$ in round $r$, $M_v^(r,"Fin")(B)$, is a message broadcasted by voter $v$ to the network indicating that voter $v$ has finalized block $B$ in round $r$. It has the following structure:

$M_v^(r,"Fin")(B) := "Enc"\_("SC")(r,"id"\_(\mathbb V),V_v^r(B),J\_(v\_(0,...n))^(r,"comp"))$

where  
- $r$ is an unsigned 64-bit integer indicating the round number ([Definition 76](sect-finality.html#defn-voting-rounds)).

- $id\_(\mathbb V)$ is the authority set Id ([Definition 33](chap-sync.html#defn-authority-list)).

- $V_v^r(B)$ is a 256-bit array containing the GRANDPA vote for block $B$ ([Definition 75](sect-finality.html#defn-vote)).

- $J\_(v\_(0,...n))^(r,"comp")$ is the compacted GRANDPA justification containing observed pre-commit of authorities $v_0$ to $v_n$ ([Definition 45](chap-networking.html#defn-grandpa-justifications-compact)).

This message is the sub-component of the GRANDPA gossip message ([Definition 43](chap-networking.html#defn-gossip-message)) of type Id *1*.

#### [](#sect-grandpa-neighbor-msg)[4.8.6.1. GRANDPA Neighbor Messages](#sect-grandpa-neighbor-msg)

Neighbor messages are sent to all connected peers but they are not repropagated on reception. A message should be send whenever the messages values change and at least every 5 minutes. The sender should take the recipients state into account and avoid sending messages to peers that are using a different voter sets or are in a different round. Messages received from a future voter set or round can be dropped and ignored.

Definition 47. [GRANDPA Neighbor Message](chap-networking.html#defn-grandpa-neighbor-msg)

A **GRANDPA Neighbor Message** is defined as:

$M^("neigh") := "Enc"\_("SC")(v,r,"id"\_(\mathbb V),H_i(B\_("last")))$

where  
- $v$ is an unsigned 8-bit integer indicating the version of the neighbor message, currently *1*.

- $r$ is an unsigned 64-bit integer indicating the round number ([Definition 76](sect-finality.html#defn-voting-rounds)).

- $"id"\_(\mathbb V)$ is an unsigned 64-bit integer indicating the authority Id ([Definition 33](chap-sync.html#defn-authority-list)).

- $H_i(B\_("last"))$ is an unsigned 32-bit integer indicating the block number of the last finalized block $B\_("last")$.

This message is the sub-component of the GRANDPA gossip message ([Definition 43](chap-networking.html#defn-gossip-message)) of type Id *2*.

#### [](#sect-grandpa-catchup-messages)[4.8.6.2. GRANDPA Catch-up Messages](#sect-grandpa-catchup-messages)

Whenever a Polkadot node detects that it is lagging behind the finality procedure, it needs to initiate a *catch-up* procedure. GRANDPA Neighbor messages ([Definition 47](chap-networking.html#defn-grandpa-neighbor-msg)) reveal the round number for the last finalized GRANDPA round which the node’s peers have observed. This provides the means to identify a discrepancy in the latest finalized round number observed among the peers. If such a discrepancy is observed, the node needs to initiate the catch-up procedure explained in [Section 6.6.1](sect-finality.html#sect-grandpa-catchup)).

In particular, this procedure involves sending a *catch-up request* and processing *catch-up response* messages.

Definition 48. [Catch-Up Request Message](chap-networking.html#defn-grandpa-catchup-request-msg)

A **GRANDPA catch-up request message** for round $r$, $M\_(i,v)^("Cat"-q)("id"\_(\mathbb V),r)$, is a message sent from node $i$ to its voting peer node $v$ requesting the latest status of a GRANDPA round $r' \>r$ of the authority set $\mathbb V\_("id")$ along with the justification of the status and has the following structure:

$M\_(i,v)^(r,"Cat"-q) := "Enc"\_("SC")(r,"id"\_(\mathbb V))$

This message is the sub-component of the GRANDPA Gossip message ([Definition 43](chap-networking.html#defn-gossip-message)) of type Id *3*.

Definition 49. [Catch-Up Response Message](chap-networking.html#defn-grandpa-catchup-response-msg)

A **GRANDPA catch-up response message** for round $r$, $M\_(v,i)^("Cat"-s)("id"\_(\mathbb V),r)$, is a message sent by a node $v$ to node $i$ in response of a catch-up request $M\_(v,i)^("Cat"-q)("id"\_(\mathbb V),r')$ in which $r \>= r'$ is the latest GRANDPA round which v has prove of its finalization and has the following structure:

$M\_(v,i)^("Cat"-s) := "Enc"\_("SC")("id"\_(\mathbb V), r, J\_(0,...n)^(r,"pv")(B), J\_(0,...m)^(r,"pc")(B),H_h(B'),H_i(B'))$

Where $B$ is the highest block which $v$ believes to be finalized in round $r$ ([Definition 76](sect-finality.html#defn-voting-rounds)). $B'$ is the highest ancestor of all blocks voted on in the arrays of justifications $J\_(0,...n)^(r,"pv")(B)$ and $J\_(0,...m)^(r,"pc")(B)$ ([Definition 78](sect-finality.html#defn-grandpa-justification)) with the exception of the equivocatory votes.

This message is the sub-component of the GRANDPA Gossip message ([Definition 43](chap-networking.html#defn-gossip-message)) of type Id *4*.

### [](#sect-msg-grandpa-beefy)[4.8.7. GRANDPA BEEFY](#sect-msg-grandpa-beefy)

|     |                                                                             |
|-----|-----------------------------------------------------------------------------|
|     | The BEEFY protocol is currently in early development and subject to change. |

This section defines the messages required for the GRANDPA BEEFY protocol ([Section 6.7](sect-finality.html#sect-grandpa-beefy)). Those messages are sent over the `/paritytech/beefy/1` substream.

Definition 50. [Commitment](chap-networking.html#defn-grandpa-beefy-commitment)

A **commitment**, $C$, contains the information extracted from the finalized block at height $H_i(B\_("last"))$ as specified in the message body and a datastructure of the following format:

$C = (R_h,H_i(B\_("last")),"id"\_(\mathbb V))$

where  
- $R_h$ is the MMR root of all the block header hashes leading up to the latest, finalized block.

- $H_i(B\_("last"))$ is the block number this commitment is for. Namely the latest, finalized block.

- $"id"\_(\mathbb V)$ is the current authority set Id ([Definition 73](sect-finality.html#defn-authority-set-id)).

Definition 51. [Vote Message](chap-networking.html#defn-msg-beefy-gossip)

A **vote message**, $M_v$, is direct vote created by the Polkadot Host on every BEEFY round and is gossiped to its peers. The message is a datastructure of the following format:

$M_v = "Enc"\_("SC")(C,A\_("id")^("bfy"),A\_("sig"))$

where  
- $C$ is the BEEFY commitment ([Definition 50](chap-networking.html#defn-grandpa-beefy-commitment)).

- $A\_("id")^("bfy")$ is the ECDSA public key of the Polkadot Host.

- $A\_("sig")$ is the signature created with $A\_("id")^("bfy")$ by signing the statement $R_h$ in $C$.

Definition 52. [Signed Commitment](chap-networking.html#defn-grandpa-beefy-signed-commitment)

A **signed commitment**, $M\_("sc")$, is a datastructure of the following format:

$M\_("SC") = "Enc"\_("SC")(C,S_n)$ $S_n = (A_0^("sig"),... A_n^("sig"))$

where  
- $C$ is the BEEFY commitment ([Definition 50](chap-networking.html#defn-grandpa-beefy-commitment)).

- $S_n$ is an array where its exact size matches the number of validators in the current authority set as specified by $"id"\_(\mathbb V)$ ([Definition 73](sect-finality.html#defn-authority-set-id)) in $C$. Individual items are of the type *Option* ([Definition 190](id-cryptography-encoding.html#defn-option-type)) which can contain a signature of a validator which signed the same statement ($R_h$ in $C$) and is active in the current authority set. It’s critical that the signatures are sorted based on their corresponding public key entry in the authority set.

  For example, the signature of the validator at index 3 in the authority set must be placed at index *3* in $S_n$. If not signature is available for that validator, then the *Option* variant is *None* inserted ([Definition 190](id-cryptography-encoding.html#defn-option-type)). This sorting allows clients to map public keys to their corresponding signatures.

Definition 53. [Signed Commitment Witness](chap-networking.html#defn-grandpa-beefy-signed-commitment-witness)

A **signed commitment witness**, $M\_("SC")^w$, is a light version of the signed BEEFY commitment ([Definition 52](chap-networking.html#defn-grandpa-beefy-signed-commitment)). Instead of containing the entire list of signatures, it only claims which validator signed the statement.

The message is a datastructure of the following format:

$M\_("SC")^w = "Enc"\_("SC")(C,V\_(0,... n), R\_("sig"))$

where  
- $C$ is the BEEFY commitment ([Definition 50](chap-networking.html#defn-grandpa-beefy-commitment)).

- $V\_(0,... n)$ is an array where its exact size matches the number of validators in the current authority set as specified by $"id"\_(\mathbb V)$ in $C$. Individual items are booleans which indicate whether the validator has signed the statement (*true*) or not (*false*). It’s critical that the boolean indicators are sorted based on their corresponding public key entry in the authority set.

  For example, the boolean indicator of the validator at index 3 in the authority set must be placed at index *3* in $V_n$. This sorting allows clients to map public keys to their corresponding boolean indicators.

- $R\_("sig")$ is the MMR root of the signatures in the original signed BEEFY commitment ([Definition 52](chap-networking.html#defn-grandpa-beefy-signed-commitment)).
