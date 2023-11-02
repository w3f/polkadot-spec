---
title: -chap-num- Networking
---

:::info
This chapter, in its current form, is incomplete and considered work in progress. Authors appreciate receiving requests for clarification or any reports regarding deviation from the current Polkadot network protocol. This can be done by filing an issue in [Polkadot Specification repository](https://github.com/w3f/polkadot-spec).
:::

## -sec-num- Introduction {#id-introduction-2}

The Polkadot network is decentralized and does not rely on any central authority or entity to achieve its fullest potential of provided functionality. The networking protocol is based on a family of open protocols, including protocol implemented *libp2p*, e.g., the distributed Kademlia hash table, which is used for peer discovery.

This chapter walks through the behavior of the networking implementation of the Polkadot Host and defines the network messages. The implementation details of the *libp2p* protocols used are specified in external sources as described in [Section -sec-num-ref-](chap-networking#sect-networking-external-docs)

## -sec-num- External Documentation {#sect-networking-external-docs}

Complete specification of the Polkadot networking protocol relies on the following external protocols:

- [libp2p](https://github.com/libp2p/specs) - *libp2p* is a modular peer-to-peer networking stack composed of many modules and different parts. includes the multiplexing protocols and

- [libp2p addressing](https://docs.libp2p.io/concepts/addressing/) - The Polkadot Host uses the *libp2p* addressing system to identify and connect to peers.

- [Kademlia](https://en.wikipedia.org/wiki/Kademlia) - *Kademlia* is a distributed hash table for decentralized peer-to-peer networks. The Polkadot Host uses Kademlia for peer discovery.

- [Noise](https://noiseprotocol.org/) - The *Noise* protocol is a framework for building cryptographic protocols. The Polkadot Host uses Noise to establish the encryption layer to remote peers.

- [yamux](https://docs.libp2p.io/concepts/stream-multiplexing/#yamux) - *yamux* is a multiplexing protocol developed by HashiCorp. It is the de-facto standard for the Polkadot Host. [Section -sec-num-ref-](chap-networking#sect-protocols-substreams) describes the subprotocol in more detail.

- [Protocol Buffers](https://developers.google.com/protocol-buffers/docs/reference/proto3-spec) - Protocol Buffers is a language-neutral, platform-neutral mechanism for serializing structured data and is developed by Google. The Polkadot Host uses Protocol Buffers to serialize specific messages, as clarified in [Section -sec-num-ref-](chap-networking#sect-network-messages).

## -sec-num- Node Identities {#id-node-identities}

Like any other distributed system, each Polkadot Host node has a unique global identifier. This identifier, called `PeerId`, serves as a singular reference to a particular node within the overall network.
In Polkadot, each node is required to maintain its own pair of ED25519 cryptographic keys from which the `PeerId` [is derived](https://pl-launchpad.io/curriculum/libp2p/connections/#peer-identity).  

The Polkadot node’s `PeerId` is structured based on the [libp2p specification](https://docs.libp2p.io/concepts/peer-id/) but does not fully conform to the specification. In particular, it does not support [CID](https://github.com/multiformats/cid) and the only supported key type is ED25519. The `PeerId` is built by hashing the [encoded public key](https://github.com/libp2p/specs/blob/master/peer-ids/peer-ids.md#keys) with [multihash](https://github.com/multiformats/multihash) and represented as follows:

###### Definition -def-num- PeerId {#defn-peer-id}
:::definition

The byte representation of the PeerId is always of the following bytes in this exact order:

$$
{b}_{{0}}={0}
$$
$$
{b}_{{1}}={36}
$$
$$
{b}_{{2}}={8}
$$
$$
{b}_{{3}}={1}
$$
$$
{b}_{{4}}={18}
$$
$$
{b}_{{5}}={32}
$$
$$
{b}_{{{6}.{.37}}}=\ldots
$$

**where**

- ${b}_{{0}}$ is the [multihash prefix](https://github.com/multiformats/multihash#multihash) of value ${0}$ (implying no hashing is used).

- ${b}_{{1}}$ the length of the PeerId (remaining bytes).

- ${b}_{{2}}$ and ${b}_{{3}}$ are a protobuf encoded field-value pair [indicating the used key type](https://github.com/libp2p/specs/blob/master/peer-ids/peer-ids.md#keys) (field ${1}$ of value ${1}$ implies *ED25519*).

- ${b}_{{4}}$, ${b}_{{5}}$ and ${b}_{{{6}.{.37}}}$ are a protobuf encoded field-value pair where ${b}_{{5}}$ indicates the length of the public key followed by the raw ED25519 public key itself, which varies for each Polkadot Host and is always 32 bytes (field ${2}$ contains the public key, which has a field value length prefix).

:::
## -sec-num- Network bootstrap and discovery {#sect-network-bootstrap}

The Polkadot Host uses various mechanisms to find peers within the network, to establish and maintain a list of peers, and to share that list with other peers from the network as follows:

- **Bootstrap nodes** are hard-coded node identities and addresses provided by the genesis state ([Section -sec-num-ref-](id-cryptography-encoding#section-genesis)).

- **mDNS** is a protocol that performs a broadcast to the local network. Nodes that might be listening can respond to the broadcast. [The libp2p mDNS specification](https://github.com/libp2p/specs/blob/master/discovery/mdns.md) defines this process in more detail. This protocol is an optional implementation detail for Polkadot Host implementers and is not required to participate in the Polkadot network.

- **Kademlia requests** invoking Kademlia requests, where nodes respond with their list of available peers. Kademlia requests are performed on a specific substream as described in [Section -sec-num-ref-](chap-networking#sect-protocols-substreams).

## -sec-num- Connection establishment {#sect-connection-establishment}

Polkadot nodes connect to peers by establishing a TCP connection. Once established, the node initiates a handshake with the remote peers on the encryption layer. An additional layer on top of the encryption layer, known as the multiplexing layer, allows a connection to be split into substreams, as described by the [yamux specification](https://docs.libp2p.io/concepts/stream-multiplexing/#yamux), either by the local or remote node.

The Polkadot node supports two types of substream protocols. [Section -sec-num-ref-](chap-networking#sect-protocols-substreams) describes the usage of each type in more detail:

- **Request-Response substreams**: After the protocol is negotiated by the multiplexing layer, the initiator sends a single message containing a request. The responder then sends a response, after which the substream is then immediately closed. The requests and responses are prefixed with their [LEB128](https://en.wikipedia.org/wiki/LEB128) encoded length.

- **Notification substreams**. After the protocol is negotiated, the initiator sends a single handshake message. The responder can then either accept the substream by sending its own handshake or reject it by closing the substream. After the substream has been accepted, the initiator can send an unbound number of individual messages. The responder keeps its sending side of the substream open, despite not sending anything anymore, and can later close it in order to signal to the initiator that it no longer wishes to communicate.

  Handshakes and messages are prefixed with their [LEB128](https://en.wikipedia.org/wiki/LEB128) encoded lengths. A handshake can be empty, in which case the length prefix would be *0*.

Connections are established by using the following protocols:

- `/noise` - a protocol that is announced when a connection to a peer is established.

- `/multistream/1.0.0` - a protocol that is announced when negotiating an encryption protocol or a substream.

- `/yamux/1.0.0` - a protocol used during *yamux* negotiation. See [Section -sec-num-ref-](chap-networking#sect-protocols-substreams) for more information.

The Polkadot Host can establish a connection with any peer of which it knows the address. The Polkadot Host supports multiple networking protocols:

- **TCP/IP** with addresses in the form of `/ip4/1.2.3.4/tcp/30333` to establish a TCP connection and negotiate encryption and a multiplexing layer.

- **WebSocket** with addresses in the form of `/ip4/1.2.3.4/tcp/30333/ws` to establish a TCP connection and negotiate the WebSocket protocol within the connection. Additionally, the encryption and multiplexing layer are negotiated within the WebSocket connection.

- **DNS** addresses in form of `/dns/example.com/tcp/30333` and `/dns/example.com/tcp/30333/ws`.

The addressing system is described in the [libp2p addressing](https://docs.libp2p.io/concepts/addressing/) specification. After a base-layer protocol is established, the Polkadot Host will apply the Noise protocol to establish the encryption layer as described in [Section -sec-num-ref-](chap-networking#sect-encryption-layer).

## -sec-num- Encryption Layer {#sect-encryption-layer}

Polkadot protocol uses the *libp2p* Noise framework to build an encryption protocol. The Noise protocol is a framework for building encryption protocols. *libp2p* utilizes that protocol for establishing encrypted communication channels. Refer to the [libp2p Secure Channel Handshake](https://github.com/libp2p/specs/tree/master/noise) specification for a detailed description.

Polkadot nodes use the [XX handshake pattern](https://noiseexplorer.com/patterns/XX/) to establish a connection between peers. The three following steps are required to complete the handshake process:

1.  The initiator generates a key pair and sends the public key to the responder. The [Noise specification](https://github.com/libp2p/specs/tree/master/noise) and the [libp2p PeerId specification](https://github.com/libp2p/specs/blob/master/peer-ids/peer-ids.md) describe keypairs in more detail.

2.  The responder generates its own key pair and sends its public key back to the initiator. After that, the responder derives a shared secret and uses it to encrypt all further communication. The responder now sends its static Noise public key (which may change anytime and does not need to be persisted on disk), its *libp2p* public key, and a signature of the static Noise public key signed with the *libp2p* public key.

3.  The initiator derives a shared secret and uses it to encrypt all further communication. It also sends its static Noise public key, *libp2p* public key, and signature to the responder.

After these three steps, both the initiator and responder derive a new shared secret using the static and session-defined Noise keys, which are used to encrypt all further communication.

## -sec-num- Protocols and Substreams {#sect-protocols-substreams}

After the node establishes a connection with a peer, the use of multiplexing allows the Polkadot Host to open substreams. *libp2p* uses the [*yamux protocol*](https://docs.libp2p.io/concepts/stream-multiplexing/#yamux) to manage substreams and to allow the negotiation of *application-specific protocols*, where each protocol serves a specific utility.

The Polkadot Host uses multiple substreams whose usage depends on a specific purpose. Each substream is either a *Request-Response substream* or a *Notification substream*, as described in [Section -sec-num-ref-](chap-networking#sect-connection-establishment).

:::info
The prefixes on those substreams are known as protocol identifiers and are used to segregate communications to specific networks. This prevents any interference with other networks. `dot` is used exclusively for Polkadot. Kusama, for example, uses the protocol identifier `ksmcc3`.
:::

- `/ipfs/ping/1.0.0` - Open a standardized substream *libp2p* to a peer and initialize a ping to verify if a connection is still alive. If the peer does not respond, the connection is dropped. This is a *Request-Response substream*.

  Further specification and reference implementations are available in the [libp2p documentation](https://docs.libp2p.io/concepts/protocols/#ping).

- `/ipfs/id/1.0.0` - Open a standardized *libp2p* substream to a peer to ask for information about that peer. This is a *Request-Response substream*, but the initiator does **not** send any message to the responder and only waits for the response.

  Further specification and reference implementations are available in the [libp2p documentation](https://docs.libp2p.io/concepts/protocols/#identify).

- `/dot/kad` - Open a standardized substream for Kademlia `FIND_NODE` requests. This is a *Request-Response substream*, as defined by the *libp2p* standard.

  Further specification and reference implementation are available on [Wikipedia](https://en.wikipedia.org/wiki/Kademlia) respectively the [golang Github repository](https://github.com/libp2p/go-libp2p-kad-dht).

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/light/2` - a request and response protocol that allows a light client to request information about the state. This is a *Request-Response substream*.

  The messages are specified in [Section -sec-num-ref-](sect-lightclient#sect-light-msg).

:::info
  For backward compatibility reasons, `/dot/light/2` is also a valid substream for those messages.
:::

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/block-announces/1` - a substream/notification protocol which sends blocks to connected peers. This is a *Notification substream*.

  The messages are specified in [Section -sec-num-ref-](chap-networking#sect-msg-block-announce).

:::info
  For backward compatibility reasons, `/dot/block-announces/1` is also a valid substream for those messages.
:::

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/sync/2` - a request and response protocol that allows the Polkadot Host to request information about blocks. This is a *Request-Response substream*.

  The messages are specified in [Section -sec-num-ref-](chap-networking#sect-msg-block-request).

:::info
  For backward compatibility reasons, `/dot/sync/2` is also a valid substream for those messages.
:::

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/sync/warp` - a request and response protocol that allows the Polkadot Host to perform a warp sync request. This is a *Request-Response substream*.

  The messages are specified in [Section -sec-num-ref-](chap-networking#sect-msg-warp-sync).

:::info
  For backward compatibility reasons, `/dot/sync/warp` is also a valid substream for those messages.
:::

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/transactions/1` - a substream/notification protocol which sends transactions to connected peers. This is a *Notification substream*.

  The messages are specified in [Section -sec-num-ref-](chap-networking#sect-msg-transactions).

:::info
  For backward compatibility reasons, `/dot/transactions/1` is also a valid substream for those messages.
:::

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/grandpa/1` - a substream/notification protocol that sends GRANDPA votes to connected peers. This is a *Notification substream*.

  The messages are specified in [Section -sec-num-ref-](chap-networking#sect-msg-grandpa).

:::info
  For backward compatibility reasons, `/paritytech/grandpa/1` is also a valid substream for those messages.
:::

- `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/beefy/1` - a substream/notification protocol which sends signed BEEFY payloads, as described in [Section -sec-num-ref-](sect-finality#sect-grandpa-beefy), to connected peers. This is a *Notification* substream.

  The messages are specified in [Section -sec-num-ref-](chap-networking#sect-msg-grandpa-beefy).

:::info
  For backward compatibility reasons, `/paritytech/beefy/1` is also a valid substream for those messages.
:::

## -sec-num- Network Messages {#sect-network-messages}

The Polkadot Host must actively communicate with the network in order to participate in the validation process or act as a full node.

:::info
  The Polkadot network originally only used SCALE encoding for all message formats. Meanwhile, Protobuf has been adopted for certain messages. The encoding of each listed message is always SCALE encoded unless Protobuf is explicitly mentioned. Encoding and message formats are subject to change.
:::


### -sec-num- Discovering authorities {#sect-authority-discovery}

The discovery mechanism enables Polkadot nodes to both publish their local addresses and learn about other nodes' identifiers and addresses.
The Authority discovery mechanism differs from the bootstrap mechanism, described in [Section -sec-num-ref-](chap-networking#sect-network-bootstrap), in that it restricts the discovery output to nodes currently holding the authority role (e.g., validators).

#### -sec-num- Requesting authority identifier and addresses {#sect-auth-discovery-service-requests}

The following requests are exposed by the discovery authority to Polkadot nodes.

###### Definition -def-num- Authority addresses request {#defn-auth-discovery-address-request}
:::definition

An **authority addresses request** is a request that Polkadot nodes can send to the authority discovery mechanism in order to request the addresses of an authority node. The request has the following format:

$$
\texttt{get\_addresses\_by\_authority\_id}{\left(\texttt{authorityId}\right)}
$$

**where**
- $\texttt{authorityId}$ is the `authorityId` 256-bit identifier representing the public key of the targeted authority node. 

**expected response** 

The response to the previous query includes an enum with one of the following values:

| Value                | Description                                            |
|----------------------|--------------------------------------------------------|
|  None                | A type representing `no value`                           | 
|  HashSet[Multiaddr]  | An unordered collection of unique `Multiaddr` elements | 

**with**
- `Multiaddr` a [Multiaddr](https://github.com/libp2p/specs/blob/master/addressing/README.md#multiaddr-in-libp2p) data structure.
:::

###### Definition -def-num- Authority identifier request {#defn-auth-discovery-auth-identifier-request}
:::definition

An **authority identifier request** is a request that Polkadot nodes can send to the authority discovery mechanism in order to request the `AuthorityId` of an authority node. The request has the following format:

$$
\texttt{get\_authority\_ids\_by\_peer\_id}{\left(\texttt{PeerId}\right)}
$$

**where**
- $\texttt{PeerId}$ is the Polkadot node’s PeerId ([Definition -def-num-ref-](chap-networking#defn-peer-id)). 


**expected response** 
The response to the previous query includes an enum with one of the following values:

| Value                  | Description                                            |
|------------------------|--------------------------------------------------------|
|  None                  | A type representing `no value`                           | 
|  HashSet[authorityId]  | An unordered collection of unique `authorityId` elements | 


**with**
- `authorityId` is the 256-bit identifier representing the public key of the requested `PeerId`. 

:::

#### -sec-num- Publishing and discovering addresses {#sect-auth-discovery-publishing}

<!-- ##### -sec-num- Publishing addresses {#sect-auth-discovery-publishing} -->
The authority discovery mechanism triggers operations to publish a `SignedAuthorityRecord` of the addresses of authorities it knows from its current and next authority sets into the DHT. The `SignedAuthorityRecord` and the publish operation are created as follows:

###### Definition -def-num- Signed Authority Record {#defn-signed-authority-record}
:::definition

The `SignedAuthorityRecord` is a Protobuf serialized structure representing the authority records and signature to send over the wire.
It is defined in the following format:

| Type               | Id  | Description                                           |
|--------------------|-----|-------------------------------------------------------|
| *AuthorityRecord*  | 1   | Serialized authority record                           |
| `bytes`            | 2   | An Schnorrkel/Ristretto x25519 ("sr25519") signature  |
| *PeerSignature*    | 3   | Serialized peer signature                             |

**where**  

**AuthorityRecord** is a serialized Protobuf structure that lists the addresses of authority nodes that are currently part of the authority set. 

| Type             | Id | Description                                                           |
|------------------|----|-----------------------------------------------------------------------|
| `repeated bytes` | 1  | Binary representation of zero or more multiaddresses through which a node is reachable  | 

**PeerSignature** is a Protobuf serialized structure indicating the signature and public key used to sign and verify the `AuthorityRecord`.
This is the protobuf structure used to exchange the signature with other nodes.

| Type    | Id  | Description                                       |
|---------|-----|---------------------------------------------------|
| `bytes` | 1   | An sr25519 signature                              | 
| `bytes` | 2   | A sr25519 public key used to verify the signature | 

:::


###### Definition -def-num- Publishing addresses {#defn-auth-discovery-publish}
:::definition

For each authority node $i$ in the current authority set, the local node invokes a `put_value` operation that triggers the publishing operation into the DHT with the following format:

$$
\texttt{put\_value}{\left(\texttt{KademliaKey}_{i} , \texttt{Sig}_{AR}\right)}
$$

**where**
- $\texttt{KademliaKey}_{i}$ is the $Sha256$ hash of the authorityId of node $i$. 
- $\texttt{Sig}_{AR}$ is the `SignedAuthorityRecord`
 described above([Definition -def-num-ref-](chap-networking#defn-signed-authority-record)). 
:::


<!-- ##### -sec-num- Discovering addresses {#sect-auth-discovery-discovering} -->

The authority discovery mechanism also invokes operations on the DHT to discover the addresses of authority nodes, as follows:

###### Definition -def-num- Discovering addresses {#defn-msg-auth-discovery-lookup}
:::definition

Periodically, the authority discovery performs a number of `get_value` operations in the following format:
$$
\texttt{get\_value}{\left(\texttt{KademliaKey}_{i}\right)}
$$

**where**
- $\texttt{KademliaKey}_{i}$ is the $Sha256$ hash of the `authorityId` of node $i$ selected from the current authority set.
::: 


### -sec-num- Announcing blocks {#sect-msg-block-announce}

When the node creates or receives a new block, it must be announced to the network. Other nodes within the network will track this announcement and can request information about this block. The mechanism for tracking announcements and requesting the required data is implementation-specific.

Block announcements, requests, and responses are sent over the substream as described in [Definition -def-num-ref-](chap-networking#defn-block-announce-handshake).

###### Definition -def-num- Block Announce Handshake {#defn-block-announce-handshake}
:::definition

The `BlockAnnounceHandshake` initializes a substream to a remote peer. Once established, all `BlockAnounce` messages ([Definition -def-num-ref-](chap-networking#defn-block-announce)) created by the node are sent to the `/dot/block-announces/1` substream.

The `BlockAnnounceHandshake` is a structure of the following format:

$$
{B}{A}_{{h}}=\text{Enc}_{{\text{SC}}}{\left({R},{N}_{{B}},{h}_{{B}},{h}_{{G}}\right)}
$$

**where**

$$
{R}={\left\lbrace\begin{matrix}{1}&\text{The node is a full node}\\{2}&\text{The node is a light client}\\{4}&\text{The node is a validator}\end{matrix}\right.}
$$
$$
{N}_{{B}}=\text{Best block number according to the node}
$$
$$
{h}_{{B}}=\text{Best block hash according to the node}
$$
$$
{h}_{{G}}=\text{Genesis block hash according to the node}
$$

:::
###### Definition -def-num- Block Announce {#defn-block-announce}
:::definition

The `BlockAnnounce` message is sent to the specified substream and indicates to remote peers that the node has either created or received a new block.

The message is structured in the following format:

$$
{B}{A}=\text{Enc}_{{\text{SC}}}{\left(\text{Head}{\left({B}\right)},{b}\right)}
$$

**where**

$$
\text{Head}{\left({B}\right)}=\text{Header of the announced block}
$$
$$
{b}={\left\lbrace\begin{matrix}{0}&\text{Is not part of the best chain}\\{1}&\text{Is the best block according to the node}\end{matrix}\right.}
$$

:::
### -sec-num- Requesting Blocks {#sect-msg-block-request}

Block requests can be used to retrieve a range of blocks from peers. Those messages are sent over the `/dot/sync/2` substream.

###### Definition -def-num- Block Request {#defn-msg-block-request}
:::definition

The `BlockRequest` message is a Protobuf serialized structure of the following format:

| Type        | Id  | Description                                                       | Value   |
|-------------|-----|-------------------------------------------------------------------|---------|
| `uint32`    | 1   | Bits of block data to request                                     | ${B}_{{f}}$ |
| `oneof`     |     | Start from this block                                             | ${B}_{{s}}$ |
| *Direction* | 5   | Sequence direction, interpreted as Id *0* (ascending) if missing. |         |
| `uint32`    | 6   | Maximum amount (*optional*)                                       | ${B}_{{m}}$ |

**where**  
- ${B}_{{f}}$ indicates all the fields that should be included in the request. its **big-endian** encoded bitmask that applies to all desired fields with bitwise OR operations. For example, the ${B}_{{f}}$ value to request *Header* and *Justification* is *0001 0001* (17).

  | Field         | Value     |
  |---------------|-----------|
  | Header        | 0000 0001 |
  | Body          | 0000 0010 |
  | Justification | 0001 0000 |

- ${B}_{{s}}$ is a Protobuf structure indicating a varying data type (enum) of the following values:

  | Type    | Id  | Description      |
  |---------|-----|------------------|
  | `bytes` | 2   | The block hash   |
  | `bytes` | 3   | The block number |

- *Direction* is a Protobuf structure indicating the sequence direction of the requested blocks. The structure is a varying data type (enum) of the following format:

  | Id  | Description                                                    |
  |-----|----------------------------------------------------------------|
  | 0   | Enumerate in ascending order (from child to parent)            |
  | 1   | Enumerate in descending order (from parent to canonical child) |

- ${B}_{{m}}$ is the number of blocks to be returned. An implementation-defined maximum is used when unspecified.

:::
###### Definition -def-num- Block Response {#defn-msg-block-response}
:::definition

The `BlockResponse` message is received after sending a `BlockRequest` message to a peer. The message is a Protobuf serialized structure of the following format:

| Type                 | Id  | Description                           |
|----------------------|-----|---------------------------------------|
| Repeated *BlockData* | 1   | Block data for the requested sequence |

where *BlockData* is a Protobuf structure containing the requested blocks. Do note that the optional values are either present or absent depending on the requested fields (bitmask value). The structure has the following format:

| Type             | Id  | Description                                                           | Value                                                          |
|------------------|-----|-----------------------------------------------------------------------|----------------------------------------------------------------|
| `bytes`          | 1   | Block header hash                                                     | [Definition -def-num-ref-](chap-state#defn-block-header-hash)        |
| `bytes`          | 2   | Block header (optional)                                               | [Definition -def-num-ref-](chap-state#defn-block-header)             |
| repeated `bytes` | 3   | Block body (optional)                                                 | [Definition -def-num-ref-](chap-state#defn-block-body)               |
| `bytes`          | 4   | Block receipt (optional)                                              |                                                                |
| `bytes`          | 5   | Block message queue (optional)                                        |                                                                |
| `bytes`          | 6   | Justification (optional)                                              | [Definition -def-num-ref-](sect-finality#defn-grandpa-justification) |
| `bool`           | 7   | Indicates whether the justification is empty (i.e., should be ignored) |                                                                |

:::
### -sec-num- Requesting States {#sect-msg-state-request}

The Polkadot Host can request the state in the form of a key/value list at a specified block.

When receiving state entries from the state response messages ([Definition -def-num-ref-](chap-networking#defn-msg-state-response)), the node can verify the entries with the entry proof (id *1* in *KeyValueStorage*) against the Merkle root in the block header (of the block specified in [Definition -def-num-ref-](chap-networking#defn-msg-state-request)). Once the state response message claims that all entries have been sent (id *3* in *KeyValueStorage*), the node can use all collected entry proofs and validate them against the Merkle root to confirm that claim.

See the synchronization chapter for more information ([Chapter -chap-num-ref-](chap-sync)).

###### Definition -def-num- State Request {#defn-msg-state-request}
:::definition

A **state request** is sent to a peer to request the state at a specified block. The message is a single 32-byte Blake2 hash which indicates the block from which the sync should start.

Depending on what substream is used, the remote peer either sends back a state response ([Definition -def-num-ref-](chap-networking#defn-msg-state-response)) on the `/dot/sync/2` substream or a warp sync proof ([Definition -def-num-ref-](chap-networking#defn-warp-sync-proof)) on the `/dot/sync/warp`.

:::
###### Definition -def-num- State Response {#defn-msg-state-response}
:::definition

The **state response** is sent to the peer that initialized the state request ([Definition -def-num-ref-](chap-networking#defn-msg-state-request)) and contains a list of key/value entries with an associated proof. This response is sent continuously until all key/value pairs have been submitted.

| Type                          | Id  | Description   |
|-------------------------------|-----|---------------|
| `repeated KeyValueStateEntry` | 1   | State entries |
| `bytes`                       | 2   | State proof   |

where *KeyValueStateEntry* is of the following format:

| Type                  | Id  | Description                                       |
|-----------------------|-----|---------------------------------------------------|
| `bytes`               | 1   | Root of the entry, empty if top-level             |
| `repeated StateEntry` | 2   | Collection of key/values                          |
| `bool`                | 3   | Equal 'true' if there are no more keys to return. |

and *StateEntry*:

| Type    | Id  | Description            |
|---------|-----|------------------------|
| `bytes` | 1   | The key of the entry   |
| `bytes` | 2   | The value of the entry |

:::
### -sec-num- Warp Sync {#sect-msg-warp-sync}

The warp sync protocols allow nodes to retrieve blocks from remote peers where authority set changes occurred. This can be used to speed up synchronization to the latest state.

See the synchronization chapter for more information ([Chapter -chap-num-ref-](chap-sync)).

###### Definition -def-num- Warp Sync Proof {#defn-warp-sync-proof}
:::definition

The **warp sync proof** message, ${P}$, is sent to the peer that initialized the state request ([Definition -def-num-ref-](chap-networking#defn-msg-state-request)) on the `/dot/sync/warp` substream and contains accumulated proof of multiple authority set changes ([Section -sec-num-ref-](chap-sync#sect-consensus-message-digest)). It’s a data structure of the following format:

$$
{P}={\left({{f}_{{x}}\ldots}{{f}_{{y}},}{c}\right)}
$$

${{f}_{{x}}\ldots}{{f}_{{y}}}$ is an array consisting of warp sync fragments of the following format:

$$
{{f}_{{x}}=}{\left({B}_{{h}},{J}^{{{r},\text{stage}}}{\left({B}\right)}\right)}
$$

where ${B}_{{h}}$ is the last block header containing a digest item ([Definition -def-num-ref-](chap-state#defn-digest)) signaling an authority set change from which the next authority set change can be fetched from. ${J}^{{{r},\text{stage}}}{\left({B}\right)}$ is the GRANDPA justification ([Definition -def-num-ref-](sect-finality#defn-grandpa-justification)) and ${c}$ is a boolean that indicates whether the warp sync has been completed.

:::
### -sec-num- Transactions {#sect-msg-transactions}

Transactions ([Section -sec-num-ref-](chap-state#sect-extrinsics)) are sent directly to peers with which the Polkadot Host has an open transaction substream ([Definition -def-num-ref-](chap-networking#defn-transactions-message)). Polkadot Host implementers should implement a mechanism that only sends a transaction once to each peer and avoids sending duplicates. Sending duplicate transactions might result in undefined consequences such as being blocked for bad behavior by peers.

The mechanism for managing transactions is further described in Section [Section -sec-num-ref-](chap-state#sect-extrinsics).

###### Definition -def-num- Transaction Message {#defn-transactions-message}
:::definition

The **transactions message** is the structure of how the transactions are sent over the network. It is represented by ${M}_{{T}}$ and is defined as follows:

$$
{M}_{{T}}\:=\text{Enc}_{{\text{SC}}}{\left({C}_{{1}},\ldots,{C}_{{n}}\right)}
$$

**in which**

$$
{C}_{{i}}\:=\text{Enc}_{{\text{SC}}}{\left({E}_{{i}}\right)}$$

Where each ${E}_{{i}}$ is a byte array and represents a separate extrinsic. The Polkadot Host is agnostic about the content of an extrinsic and treats it as a blob of data.

Transactions are sent over the `/dot/transactions/1` substream.

:::
### -sec-num- GRANDPA Messages {#sect-msg-grandpa}

The exchange of GRANDPA messages is conducted on the substream. The process for the creation and distribution of these messages is described in [Chapter -chap-num-ref-](sect-finality). The underlying messages are specified in this section.

###### Definition -def-num- Grandpa Gossip Message {#defn-gossip-message}
:::definition

A **GRANDPA gossip message**, ${M}$, is a varying datatype ([Definition -def-num-ref-](id-cryptography-encoding#defn-varrying-data-type)) which identifies the message type that is cast by a voter followed by the message itself.

$$
{M}={\left\lbrace\begin{matrix}{0}&\text{Vote message}&{V}_{{m}}\\{1}&\text{Commit message}&{C}_{{m}}\\{2}&\text{Neighbor message}&{N}_{{m}}\\{3}&\text{Catch-up request message}&{R}_{{m}}\\{4}&\text{Catch-up message}&{U}_{{m}}\end{matrix}\right.}
$$

**where**  
- ${V}_{{m}}$ is defined in [Definition -def-num-ref-](chap-networking#defn-grandpa-vote-msg).

- ${C}_{{m}}$ is defined in [Definition -def-num-ref-](chap-networking#defn-grandpa-commit-msg).

- ${N}_{{m}}$ is defined in [Definition -def-num-ref-](chap-networking#defn-grandpa-neighbor-msg).

- ${R}_{{m}}$ is defined in [Definition -def-num-ref-](chap-networking#defn-grandpa-catchup-request-msg).

- ${U}_{{M}}$ is defined in [Definition -def-num-ref-](chap-networking#defn-grandpa-catchup-response-msg).

:::
###### Definition -def-num- GRANDPA Vote Messages {#defn-grandpa-vote-msg}
:::definition

A **GRANDPA vote message** by voter ${v}$, ${{M}_{{v}}^{{{r},\text{stage}}}}$, is gossip to the network by voter ${v}$ with the following structure:

$$
{{M}_{{v}}^{{{r},\text{stage}}}}{\left({B}\right)}\:=\text{Enc}_{{\text{SC}}}{\left({r},\text{id}_{{{\mathbb{{V}}}}},\text{SigMsg}\right)}
$$
$$
\text{SigMsg}\:={\left(\text{msg},{\text{Sig}_{{{v}_{{i}}}}^{{{r},\text{stage}}}},{v}_{{\text{id}}}\right)}
$$
$$
\text{msg}\:=\text{Enc}_{{\text{SC}}}{\left(\text{stage},{{V}_{{v}}^{{{r},\text{stage}}}}{\left({B}\right)}\right)}
$$

**where**  
- ${r}$ is an unsigned 64-bit integer indicating the Grandpa round number ([Definition -def-num-ref-](sect-finality#defn-voting-rounds)).

- $\text{id}_{{{\mathbb{{V}}}}}$ is an unsigned 64-bit integer indicating the authority Set Id ([Definition -def-num-ref-](sect-finality#defn-authority-set-id)).

- ${\text{Sig}_{{{v}_{{i}}}}^{{{r},\text{stage}}}}$ is a 512-bit byte array containing the signature of the authority ([Definition -def-num-ref-](sect-finality#defn-sign-round-vote)).

- ${v}_{{{i}{d}}}$ is a 256-bit byte array containing the *ed25519* public key of the authority.

- $\text{stage}$ is a 8-bit integer of value *0* if it’s a pre-vote sub-round, *1* if it’s a pre-commit sub-round or *2* if it’s a primary proposal message.

- ${{V}_{{v}}^{{{r},\text{stage}}}}{\left({B}\right)}$ is the GRANDPA vote for block ${B}$ ([Definition -def-num-ref-](sect-finality#defn-voting-rounds)).

This message is the sub-component of the GRANDPA gossip message ([Definition -def-num-ref-](chap-networking#defn-gossip-message)) of type Id 0.

:::
###### Definition -def-num- GRANDPA Compact Justification Format {#defn-grandpa-justifications-compact}
:::definition

The **GRANDPA compact justification format** is an optimized data structure to store a collection of pre-commits and their signatures to be submitted as part of a commit message. Instead of storing an array of justifications, it uses the following format:

$$
{{J}_{{{v}_{{{0},\ldots{n}}}}}^{{{r},\text{comp}}}}\:={\left({\left\lbrace{{V}_{{{v}_{{0}}}}^{{{r},{p}{c}}}},\ldots{{V}_{{{v}_{{n}}}}^{{{r},{p}{c}}}}\right\rbrace},{\left\lbrace{\left({\text{Sig}_{{{v}_{{0}}}}^{{{r},{p}{c}}}},{v}_{{\text{id}_{{0}}}}\right)},\ldots{\left({\text{Sig}_{{{v}_{{n}}}}^{{{r},{p}{c}}}},{v}_{{\text{id}_{{n}}}}\right)}\right\rbrace}\right)}
$$

**where**  
- ${{V}_{{{v}_{{i}}}}^{{{r},{p}{c}}}}$ is a 256-bit byte array containing the pre-commit vote of authority ${v}_{{i}}$ ([Definition -def-num-ref-](sect-finality#defn-voting-rounds)).

- ${\text{Sig}_{{{v}_{{i}}}}^{{{r},{p}{c}}}}$ is a 512-bit byte array containing the pre-commit signature of authority ${v}_{{i}}$ ([Definition -def-num-ref-](sect-finality#defn-sign-round-vote)).

- ${v}_{{\text{id}_{{n}}}}$ is a 256-bit byte array containing the public key of authority ${v}_{{i}}$.

:::
###### Definition -def-num- GRANDPA Commit Message {#defn-grandpa-commit-msg}
:::definition

A **GRANDPA commit message** for block ${B}$ in round ${r}$, ${{M}_{{v}}^{{{r},\text{Fin}}}}{\left({B}\right)}$, is a message broadcasted by voter ${v}$ to the network indicating that voter ${v}$ has finalized block ${B}$ in round ${r}$. It has the following structure:

$$
{{M}_{{v}}^{{{r},\text{Fin}}}}{\left({B}\right)}\:=\text{Enc}_{{\text{SC}}}{\left({r},\text{id}_{{{\mathbb{{V}}}}},{{V}_{{v}}^{{r}}}{\left({B}\right)},{{J}_{{{v}_{{{0},\ldots{n}}}}}^{{{r},\text{comp}}}}\right)}
$$

**where**  
- ${r}$ is an unsigned 64-bit integer indicating the round number ([Definition -def-num-ref-](sect-finality#defn-voting-rounds)).

- ${id}_{{{\mathbb{{V}}}}}$ is the authority set Id ([Definition -def-num-ref-](sect-finality#defn-authority-set-id)).

- ${{V}_{{v}}^{{r}}}{\left({B}\right)}$ is a 256-bit array containing the GRANDPA vote for block ${B}$ ([Definition -def-num-ref-](sect-finality#defn-vote)).

- ${{J}_{{{v}_{{{0},\ldots{n}}}}}^{{{r},\text{comp}}}}$ is the compacted GRANDPA justification containing observed pre-commit of authorities ${v}_{{0}}$ to ${v}_{{n}}$ ([Definition -def-num-ref-](chap-networking#defn-grandpa-justifications-compact)).

This message is the sub-component of the GRANDPA gossip message ([Definition -def-num-ref-](chap-networking#defn-gossip-message)) of type Id *1*.

:::
#### -sec-num- GRANDPA Neighbor Messages {#sect-grandpa-neighbor-msg}

Neighbor messages are sent to all connected peers but they are not repropagated on reception. A message should be sent whenever the values of the message change and at least every 5 minutes. The sender should take the recipient's state into account and avoid sending messages to peers that are using different voter sets or are in a different round. Messages received from a future voter set or round can be dropped and ignored.

###### Definition -def-num- GRANDPA Neighbor Message {#defn-grandpa-neighbor-msg}
:::definition

A **GRANDPA Neighbor Message** is defined as:

$$
{M}^{{\text{neigh}}}\:=\text{Enc}_{{\text{SC}}}{\left({v},{r},\text{id}_{{{\mathbb{{V}}}}},{H}_{{i}}{\left({B}_{{\text{last}}}\right)}\right)}
$$

**where**  
- ${v}$ is an unsigned 8-bit integer indicating the version of the neighbor message, currently *1*.

- ${r}$ is an unsigned 64-bit integer indicating the round number ([Definition -def-num-ref-](sect-finality#defn-voting-rounds)).

- $\text{id}_{{{\mathbb{{V}}}}}$ is an unsigned 64-bit integer indicating the authority Id ([Definition -def-num-ref-](sect-finality#defn-authority-set-id)).

- ${H}_{{i}}{\left({B}_{{\text{last}}}\right)}$ is an unsigned 32-bit integer indicating the block number of the last finalized block ${B}_{{\text{last}}}$.

This message is the sub-component of the GRANDPA gossip message ([Definition -def-num-ref-](chap-networking#defn-gossip-message)) of type Id *2*.

:::
#### -sec-num- GRANDPA Catch-up Messages {#sect-grandpa-catchup-messages}

Whenever a Polkadot node detects that it is lagging behind the finality procedure, it needs to initiate a *catch-up* procedure. GRANDPA Neighbor messages ([Definition -def-num-ref-](chap-networking#defn-grandpa-neighbor-msg)) reveal the round number for the last finalized GRANDPA round which the node’s peers have observed. This provides the means to identify a discrepancy in the latest finalized round number observed among the peers. If such a discrepancy is observed, the node needs to initiate the catch-up procedure explained in [Section -sec-num-ref-](sect-finality#sect-grandpa-catchup)).

In particular, this procedure involves sending a *catch-up request* and processing *catch-up response* messages.

###### Definition -def-num- Catch-Up Request Message {#defn-grandpa-catchup-request-msg}
:::definition

A **GRANDPA catch-up request message** for round ${r}$, ${{M}_{{{i},{v}}}^{{\text{Cat}-{q}}}}{\left(\text{id}_{{{\mathbb{{V}}}}},{r}\right)}$, is a message sent from node ${i}$ to its voting peer node ${v}$ requesting the latest status of a GRANDPA round ${r}'>{r}$ of the authority set ${\mathbb{{V}}}_{{\text{id}}}$ along with the justification of the status and has the following structure:

$$
{{M}_{{{i},{v}}}^{{{r},\text{Cat}-{q}}}}\:=\text{Enc}_{{\text{SC}}}{\left({r},\text{id}_{{{\mathbb{{V}}}}}\right)}
$$

This message is the sub-component of the GRANDPA Gossip message ([Definition -def-num-ref-](chap-networking#defn-gossip-message)) of type Id *3*.

:::
###### Definition -def-num- Catch-Up Response Message {#defn-grandpa-catchup-response-msg}
:::definition

A **GRANDPA catch-up response message** for round ${r}$, ${{M}_{{{v},{i}}}^{{\text{Cat}-{s}}}}{\left(\text{id}_{{{\mathbb{{V}}}}},{r}\right)}$, is a message sent by a node ${v}$ to node ${i}$ in response of a catch-up request ${{M}_{{{v},{i}}}^{{\text{Cat}-{q}}}}{\left(\text{id}_{{{\mathbb{{V}}}}},{r}'\right)}$ in which ${r}\ge{r}'$ is the latest GRANDPA round which v has prove of its finalization and has the following structure:

$$
{{M}_{{{v},{i}}}^{{\text{Cat}-{s}}}}\:=\text{Enc}_{{\text{SC}}}{\left(\text{id}_{{{\mathbb{{V}}}}},{r},{{J}_{{{0},\ldots{n}}}^{{{r},\text{pv}}}}{\left({B}\right)},{{J}_{{{0},\ldots{m}}}^{{{r},\text{pc}}}}{\left({B}\right)},{H}_{{h}}{\left({B}'\right)},{H}_{{i}}{\left({B}'\right)}\right)}
$$

Where ${B}$ is the highest block which ${v}$ believes to be finalized in round ${r}$ ([Definition -def-num-ref-](sect-finality#defn-voting-rounds)). ${B}'$ is the highest ancestor of all blocks voted on in the arrays of justifications ${{J}_{{{0},\ldots{n}}}^{{{r},\text{pv}}}}{\left({B}\right)}$ and ${{J}_{{{0},\ldots{m}}}^{{{r},\text{pc}}}}{\left({B}\right)}$ ([Definition -def-num-ref-](sect-finality#defn-grandpa-justification)) with the exception of the equivocatory votes.

This message is the sub-component of the GRANDPA Gossip message ([Definition -def-num-ref-](chap-networking#defn-gossip-message)) of type Id *4*.


:::
### -sec-num- GRANDPA BEEFY {#sect-msg-grandpa-beefy}

This section defines the messages required for the BEEFY protocol ([Section -sec-num-ref-](sect-finality#sect-grandpa-beefy)). Those messages are sent over the `/91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3/beefy/1` substream.
###### Definition -def-num- Commitment {#defn-grandpa-beefy-commitment}
:::definition
A **commitment**, ${C}$, contains the information extracted from the finalized block at height ${H}_{{i}}{\left({B}_{{\text{last}}}\right)}$ as specified in the message body and a datastructure of the following format:
$$
{C}={\left({R}_{{h}},{H}_{{i}}{\left({B}_{{\text{last}}}\right)},\text{id}_{{{\mathbb{{V}}}}}\right)}
$$
**where**  
- ${R}_{{h}}$ is the MMR root of all the block header hashes leading up to the latest, finalized block.
- ${H}_{{i}}{\left({B}_{{\text{last}}}\right)}$ is the block number this commitment is for. Namely the latest, finalized block.
- $\text{id}_{{{\mathbb{{V}}}}}$ is the current authority set Id ([Definition -def-num-ref-](sect-finality#defn-authority-set-id)).
:::
###### Definition -def-num- Vote Message {#defn-msg-beefy-gossip}
:::definition
A **vote message**, ${M}_{{v}}$, is direct vote created by the Polkadot Host on every BEEFY round and is gossiped to its peers. The message is a datastructure of the following format:
$$
{M}_{{v}}=\text{Enc}_{{\text{SC}}}{\left({C},{{A}_{{\text{id}}}^{{\text{bfy}}}},{A}_{{\text{sig}}}\right)}
$$
**where**  
- ${C}$ is the BEEFY commitment ([Definition -def-num-ref-](chap-networking#defn-grandpa-beefy-commitment)).
- ${{A}_{{\text{id}}}^{{\text{bfy}}}}$ is the ECDSA public key of the Polkadot Host.
- ${A}_{{\text{sig}}}$ is the signature created with ${{A}_{{\text{id}}}^{{\text{bfy}}}}$ by signing the payload ${R}_{{h}}$ in ${C}$.
:::
###### Definition -def-num- Signed Commitment {#defn-grandpa-beefy-signed-commitment}
:::definition
A **signed commitment**, ${M}_{{\text{sc}}}$, is a datastructure of the following format:
$$
{M}_{{\text{SC}}}=\text{Enc}_{{\text{SC}}}{\left({C},{S}_{{n}}\right)}
$$
$$
{S}_{{n}}={\left({{A}_{{0}}^{{\text{sig}}}},\ldots{{A}_{{n}}^{{\text{sig}}}}\right)}
$$
**where**  
- ${C}$ is the BEEFY commitment ([Definition -def-num-ref-](chap-networking#defn-grandpa-beefy-commitment)).
- ${S}_{{n}}$ is an array where its exact size matches the number of validators in the current authority set as specified by $\text{id}_{{{\mathbb{{V}}}}}$ ([Definition -def-num-ref-](sect-finality#defn-authority-set-id)) in ${C}$. Individual items are of the type *Option* ([Definition -def-num-ref-](id-cryptography-encoding#defn-option-type)), which can contain a signature of a validator which signed the same payload (${R}_{{h}}$ in ${C}$) and is active in the current authority set. It’s critical that the signatures are sorted based on their corresponding public key entry in the authority set.
  For example, the signature of the validator at index 3 in the authority set must be placed at index *3* in ${S}_{{n}}$. If not signature is available for that validator, then the *Option* variant is *None* inserted ([Definition -def-num-ref-](id-cryptography-encoding#defn-option-type)). This sorting allows clients to map public keys to their corresponding signatures.
:::
###### Definition -def-num- Signed Commitment Witness {#defn-grandpa-beefy-signed-commitment-witness}
:::definition
A **signed commitment witness**, ${{M}_{{\text{SC}}}^{{w}}}$, is a light version of the signed BEEFY commitment ([Definition -def-num-ref-](chap-networking#defn-grandpa-beefy-signed-commitment)). Instead of containing the entire list of signatures, it only claims which validator signed the payload.
The message is a datastructure of the following format:
$$
{{M}_{{\text{SC}}}^{{w}}}=\text{Enc}_{{\text{SC}}}{\left({C},{V}_{{{0},\ldots{n}}},{R}_{{\text{sig}}}\right)}
$$
**where**  
- ${C}$ is the BEEFY commitment ([Definition -def-num-ref-](chap-networking#defn-grandpa-beefy-commitment)).
- ${V}_{{{0},\ldots{n}}}$ is an array where its exact size matches the number of validators in the current authority set as specified by $\text{id}_{{{\mathbb{{V}}}}}$ in ${C}$. Individual items are booleans which indicate whether the validator has signed the payload (*true*) or not (*false*). It’s critical that the boolean indicators are sorted based on their corresponding public key entry in the authority set.
  For example, the boolean indicator of the validator at index 3 in the authority set must be placed at index *3* in ${V}_{{n}}$. This sorting allows clients to map public keys to their corresponding boolean indicators.
- ${R}_{{\text{sig}}}$ is the MMR root of the signatures in the original signed BEEFY commitment ([Definition -def-num-ref-](chap-networking#defn-grandpa-beefy-signed-commitment)).
