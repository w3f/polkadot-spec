<TeXmacs|1.99.16>

<project|host-spec.tm>

<style|<tuple|generic|std-latex|old-dots|old-lengths>>

<\body>
  <chapter|Networking>

  <with|font-series|bold|Chapter Status:> This document in its current form
  is incomplete and considered work in progress. Any reports regarding
  deviation from the current Polkadot network protocol or clarifications are
  appreciated.

  <section|Introduction>

  The Polkadot network is decentralized and does not rely on any central
  authority or entity in order to achieve its fullest potential of provided
  functionality. The networking protocol is based on a family of open
  protocols, including the distributed Kademlia hash table which is used for
  peer discovery.

  This chapter walks through the behavior of the networking implemenation of
  the Polkadot Host and defines the network messages. Implementation details
  of the used <verbatim|libp2p> protocols are specified in external sources
  as described in Section <reference|sect-networking-external-docs>.

  <subsection|External Documentation><label|sect-networking-external-docs>

  The completeness of implementing the Polkadot networking protocol requires
  the usage of external documentation.

  <\itemize>
    <item><hlink|libp2p|https://github.com/libp2p/specs> - <verbatim|libp2p>
    is a modular peer-to-peer networking stack composed of many modules and
    different parts. Included in libp2p are multiplexing protocols mplex and
    yamux.

    <item><hlink|libp2p adressing|https://docs.libp2p.io/concepts/addressing/>
    - The Polkadot Host uses the <verbatim|libp2p> addressing system to
    identity and connect to peers.

    <item><hlink|Kademlia|https://en.wikipedia.org/wiki/Kademlia> -
    <verbatim|Kademlia> is a distributed hash table for decentralized
    peer-to-peer networks. The Polkadot Host uses Kademlia for peer
    discovery.

    <item><hlink|Noise|https://noiseprotocol.org/> - The Noise protocol is a
    framework for building cryptographic protocols. The Polkadot Host uses
    Noise to establish the encryption layer to remote peers.

    <item><hlink|mplex|https://docs.libp2p.io/concepts/stream-multiplexing/#mplex>
    - <verbatim|mplex> is a multiplexing protocol developed by libp2p. The
    protocol allows to divide a connection to a peer into multiple
    substreams, each substream serving a specific purpose. Generally,
    Polkadot Host implementers are encouraged to prioritize implementing
    yamux, since it's the de facto standard in Polkadot. <verbatim|mplex> is
    only required in order to communicate with
    <hlink|js-lip2p|https://github.com/libp2p/js-libp2p>.

    <item><hlink|yamux|https://docs.libp2p.io/concepts/stream-multiplexing/#yamux>
    - <verbatim|yamux> is a multiplexing protocol like <verbatim|mplex> and
    the de facto standard for the Polkadot Host. This protocol should be
    prioritzed over <verbatim|mplex>.

    <item><hlink|Protocol Buffers|https://developers.google.com/protocol-buffers/docs/reference/proto3-spec>
    - Protocol Buffers is a language-neutral, platform-neutral mechanism for
    serializing structured data and is developed by Google. The Polkadot Host
    uses Protocol Buffers to serialze specific messages, as clarified in
    Section <reference|sect-network-messages>.
  </itemize>

  <subsection|Node Identities>

  Each Polkadot Host node maintains a ED25519 key pair which is used to
  identify the node. The public key is shared with the rest of the network
  which allows nodes to establish secure communication channels.\ 

  Each node must have its own unique ED25519 key pair. When two or more nodes
  use the same key, the network will interpret those nodes as a single node,
  which will result in undefined behavior and can result in equivocation.
  Furthermore, the node's <verbatim|PeerId> as defined in Definition
  <reference|defn-peer-id> is derived from its public key. <verbatim|PeerId>
  (<reference|defn-peer-id>) is used to identify each node when they are
  discoved in the course of the discovery mechanism described in Section
  <reference|sect-discovery-mechanism>.

  <\definition>
    <label|defn-peer-id>The Polkadot node's <verbatim|PeerId>, formally
    referred to as <math|P<rsub|id>>, is derived from the ED25519 public key
    and is structured as defined in the libp2p specification
    (<slink|https://docs.libp2p.io/concepts/peer-id/>).
  </definition>

  <subsection|Discovery mechanism><label|sect-discovery-mechanism>

  The Polkadot Host uses various mechanisms to find peers within the network,
  to establish and maintain a list of peers and to share that list with other
  peers from the network, as follows:

  <\itemize>
    <item><strong|Bootstrap nodes> are hard-coded node identities and
    addresses provided by the genesis state specification as described in
    Appendix <reference|sect-genesis-block>.

    <item><strong|mDNS> protocol which performs a broadcast to the local
    network. Nodes that might be listening can respond the the broadcast.
    <hlink|The libp2p mDNS specification|https://github.com/libp2p/specs/blob/master/discovery/mdns.md>
    defines this process in more detail. This protocol is an optional
    implementation detail for Polkadot Host implementers and is not required
    in order to participate in the Polkadot network.

    <item><strong|Kademlia requests> invoking Kademlia <verbatim|FIND_NODE>
    requests, where nodes respond with their list of available peers.
    Kademlia requests must also contain protocol identifiers as described in
    Section <reference|sect-protocol-identifier>.
  </itemize>

  <subsection|Connection establishment>

  Polkadot nodes connect to peers by establishing a TCP connection. Once
  established, the node initiates a handshake with the remote peer's on the
  encryption layer. An additional layer on top of the encryption layer, known
  as the multiplexing layer, allows a connection to be split into substreams,
  as described by the <hlink|yamux specification|https://docs.libp2p.io/concepts/stream-multiplexing/#yamux>,
  either by the local or remote node.

  The Polkadot node supports two types of substream protocols:

  <\itemize-dot>
    <item><strong|Request-Response substreams>: After the protocol is
    negotiated, the initiator sends a single message containing a request.
    The responder then sends a response, after which the substream is then
    immediately closed. The requests and responses are prefixed with their
    <hlink|LEB128|https://en.wikipedia.org/wiki/LEB128> encoded length.

    <item><strong|Notification substreams>. After the protocol is negotiated,
    the initiator sends a single handshake message. The responder can then
    either accept the substream by sending its own handshake, or reject it by
    closing the substream. After the substream has been accepted, the
    initiator can send an unbound number of individual messages. The
    responder keeps its sending side of the substream open, despite not
    sending anything anymore, and can later close it in order to signal to
    the initiator that it no longer wishes to communicate.

    Handshakes and messages are prefixed with their
    <hlink|LEB128|https://en.wikipedia.org/wiki/LEB128> encoded lengths. A
    handshake can be empty, in which case the length prefix would be
    <verbatim|0>.
  </itemize-dot>

  Connections are established by using the following protocols:

  <\itemize-dot>
    <item><verbatim|/noise> - a protol that is announced when a connection to
    a peer is established.

    <item><verbatim|/multistream/1.0.0> - a protocol that is announced when
    negotiating an encryption protocol or a substream.

    <item><verbatim|/yamux/1.0.0> - a protocol used during the
    <verbatim|mplex> or <verbatim|yamux> negotiation. See Section
    <reference|sect-protocols-substreams> for more information.
  </itemize-dot>

  The Polkadot Host can establish a connection with any peer of which it
  knows the address. The Polkadot Host supports multiple networking
  protocols:

  <\itemize>
    <item><strong|TCP/IP> with addresses in the form of
    <verbatim|/ip4/1.2.3.4/tcp/> to establish a TCP connection and negotiate
    an encryption and a multiplexing layer.

    <item><strong|Websockets> with addresses in the form of
    <verbatim|/ip4/1.2.3.4/ws/> to establish a TCP connection and negotiate
    the Websocket protocol within the connection. Additionally, an encryption
    and multiplexing layer is negotiated within the Websocket connection.

    <item><strong|DNS> addresses in form of
    <verbatim|/dns/website.domain/tcp/> and
    <verbatim|/dns/website.domain/ws/>.
  </itemize>

  After a base-layer protocol is established, the Polkadot Host will apply
  the Noise protocol to establish the encryption layer as described in
  Section <reference|sect-encryption-layer>.

  <subsection|Encryption Layer><label|sect-encryption-layer>

  Polkadot protocol uses the <samp|<verbatim|libp2p>> Noise framework to
  build an encryption protocol. The Noise protocol is a framework for bulding
  encryption protocols. <verbatim|libp2p> utilizes that protocol for
  establishing encrypted communication channels. Refer to the <hlink|libp2p
  Secure Channel Handshake|https://github.com/libp2p/specs/tree/master/noise>
  specification for a detailed description.

  Polkadot nodes use the <hlink|XX handshake
  pattern|https://noiseexplorer.com/patterns/XX/> to establish a connection
  between peers. Three following steps are required to successfully complete
  the handshake process:

  <\enumerate-numeric>
    <item>The initiator generates a keypair and sends the public key to the
    responder. The <hlink|Noise specification|https://github.com/libp2p/specs/tree/master/noise>
    and the <hlink|libp2p PeerId specification|https://github.com/libp2p/specs/blob/master/peer-ids/peer-ids.md>
    describe keypairs in more detail.

    <item>The responder generates its own keypair and sends its public key
    back to the initiator. After that, the responder derives a shared secret
    and uses it to encrypt all further communication. The responder now sends
    its static Noise public key (which may change anytime and does not need
    to be persisted on disk), its <verbatim|libp2p> public key and a
    signature of the static Noise public key signed with the
    <verbatim|libp2p> public key.

    <item>The initiator derives a shared secret and uses it to encrypt all
    further communication. It also sends its static Noise public key,
    <verbatim|libp2p> public key and a signature to the responder.
  </enumerate-numeric>

  After these three steps, both the initiator and responder derive a new
  shared secret using the static and session-defined Noise keys, which are
  used to encrypt all further communication.

  <subsection|Protocols and Substreams><label|sect-protocols-substreams>

  After the node establishes a connection with a peer, the use of
  multiplexing allows the Polkadot Host to open substreams. <verbatim|libp2p>
  uses the <hlink|<verbatim|mplex> protocol|https://docs.libp2p.io/concepts/stream-multiplexing/#mplex>
  or the <hlink|<verbatim|yamux> protocol|https://docs.libp2p.io/concepts/stream-multiplexing/#yamux>
  to manage substream and to allow the negotiation of
  <with|font-shape|italic|application-specific protocols>, where each
  protocol servers a specific utility.

  The Polkadot Host uses multiple substreams, each having a specific purpose:

  <\itemize>
    <item><verbatim|/ipfs/ping/1.0.0> - Open a substream to a peer and
    initialize a ping to verify if a connection is till alive. If the peer
    does not respond, the connection is dropped.

    <item><verbatim|/ipfs/id/1.0.0> - Open a substream to a peer to ask
    information about that peer.

    <item><verbatim|/dot/kad> - Open a substream for Kademlia
    <verbatim|FIND_NODE> requests.
  </itemize>

  <\itemize>
    <item><verbatim|/dot/sync/2> - a request and response protocol that
    allows the Polkadot Host to perform information about blocks.

    <item><verbatim|/dot/light/2> - a request and response protocol that
    allows a light client to perform request information about the state.

    <item><verbatim|/dot/transactions/1> - a substream/notification protocol
    which sends transactions to connected peers.

    <item><verbatim|/dot/block-announces/1> - a substream/notification
    protocol which sends blocks to connected peers.

    <item><verbatim|/paritytech/grandpa/1> - a substream/notification
    protocol which sends GRANDPA votes to connected peers. <todo|this
    substream will change in the future. See <hlink|issue
    #7252|https://github.com/paritytech/substrate/issues/7252>.>
  </itemize>

  <subsection|Network Messages><label|sect-network-messages>

  The Polkadot Host must actively communicate with the network in order to
  participate in the validation process or act as a full node.

  <strong|Note>: The Polkadot network originally only used SCALE encoding for
  all message formats. Meanwhile, Protobuf has been adopted for certain
  messages. The encoding of each message is explicitly mentioned in their
  corresponding definition. Encoding and message formats are subject to
  change.

  <subsubsection|Announcing blocks>

  When the node creates or receives a new block, it must be announced to the
  network. Other nodes within the network will track this announcement and
  can request information about this block. The mechanism for tracking
  announcement and requesting the required data is implementation specific.

  Block announcements, requests and responses are sent over the
  <verbatim|/dot/block-announces/1> substream as defined in Definition
  <reference|defn-block-announce-handshake>.

  <\definition>
    <label|defn-block-announce-handshake>The
    <verbatim|BlockAnnounceHandshake> initializes a substream to a remote
    peer. Once established, all <verbatim|BlockAnnounce> messages as defined
    in Definition <reference|defn-block-announce> are created by the node are
    sent to the <verbatim|/dot/block-announces/1> substream.

    The <verbatim|BlockAnnounceHandshake> is a SCALE encoded structure of the
    following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|BA<rsub|h>>|<cell|=>|<cell|Enc<rsub|SC><around*|(|R,N<rsub|B>,h<rsub|B>,h<rsub|G>|)>>>>>
    </eqnarray*>

    where:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|1
      >|<cell|<math-it|The node is a full node>>>|<row|<cell|2
      >|<cell|<math-it|The node is a light client>>>|<row|<cell|4
      >|<cell|<math-it|The node is a validator>>>>>>>>|<row|<cell|N<rsub|B>>|<cell|=>|<cell|<math-it|Best
      block number according to the node>>>|<row|<cell|h<rsub|B>>|<cell|=>|<cell|<math-it|Best
      block hash according to the node>>>|<row|<cell|h<rsub|G>>|<cell|=>|<cell|<math-it|Genesis
      block hash according to the node>>>>>
    </eqnarray*>
  </definition>

  <\definition>
    <label|defn-block-announce>The <verbatim|BlockAnnounce> message is sent
    to the specified substream and indicates to remote peers the that node
    has either created or received a new block.

    The <verbatim|BlockAnnounce> message is a SCALE encoded structure of the
    following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|BA>|<cell|=>|<cell|Enc<rsub|SC><around*|(|Head<around*|(|B|)>,b|)>>>>>
    </eqnarray*>

    where:

    <\eqnarray*>
      <tformat|<table|<row|<cell|Head<around*|(|B|)>>|<cell|=>|<cell|<math-it|Header
      of the announced block>>>|<row|<cell|b>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0>|<cell|<math-it|Is
      the best block according to the node>>>|<row|<cell|1>|<cell|<math-it|Is
      the best block according to node>>>>>>>>>>
    </eqnarray*>
  </definition>

  <subsubsection|Requesting blocks><verbatim|>

  Block requests can be used to retrieve a range of blocks from peers.

  <\definition>
    The <verbatim|BlockRequest> message is a Protobuf serialized structure of
    the following format:

    <\big-table|<tabular|<tformat|<cwith|2|-1|1|-1|cell-tborder|1ln>|<cwith|2|-1|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|-1|cell-lborder|0ln>|<cwith|2|-1|1|-1|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<table|<row|<cell|<strong|Type>>|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Value>>>|<row|<cell|uint32>|<cell|1>|<cell|Bits
    of block data to request>|<cell|<math|B<rsub|f>>>>|<row|<cell|oneof>|<cell|>|<cell|Start
    from this block>|<cell|<math|B<rsub|S>>>>|<row|<cell|bytes>|<cell|4>|<cell|End
    at this block (optional)>|<cell|<math|B<rsub|e>>>>|<row|<cell|Direction>|<cell|5>|<cell|Sequence
    direction>|<cell|>>|<row|<cell|uint32>|<cell|6>|<cell|Maximum amount
    (optional)>|<cell|<math|B<rsub|m>>>>>>>>
      <verbatim|BlockRequest> Protobuf message.
    </big-table>

    where

    <\itemize-dot>
      <item><math|B<rsub|f>> indictes all the fields that should be included
      in the request. It's <strong|big endian> encoded bitmask which applies
      all desired fields with bitwise OR operations. For example, the
      <math|B<rsub|f>> value to request <verbatim|Header> and
      <verbatim|Justification> is <verbatim|0001 0001> (17).

      <\big-table|<tabular|<tformat|<cwith|2|-1|1|-1|cell-tborder|1ln>|<cwith|2|-1|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|-1|cell-lborder|0ln>|<cwith|2|-1|1|-1|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<table|<row|<cell|<strong|Field>>|<cell|<strong|Value>>>|<row|<cell|Header>|<cell|0000
      0001>>|<row|<cell|Body>|<cell|0000 0010>>|<row|<cell|Justification>|<cell|0001
      0000>>>>>>
        Bits of block data to be requested.
      </big-table>

      <item><math|B<rsub|s>> is a Protobuf structure indicating a varying
      data type of the following values:

      <\big-table|<tabular|<tformat|<cwith|2|-1|1|-1|cell-tborder|1ln>|<cwith|2|-1|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|-1|cell-lborder|0ln>|<cwith|2|-1|1|-1|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<table|<row|<cell|<strong|Type>>|<cell|<strong|Id>>|<cell|<strong|Decription>>>|<row|<cell|bytes>|<cell|2>|<cell|The
      block hash>>|<row|<cell|bytes>|<cell|3>|<cell|The block number>>>>>>
        Protobuf message indicating the block to start from.
      </big-table>

      <item><math|B<rsub|e>> is either the block hash or block number
      depending on the value of <math|B<rsub|s>>. An implementation defined
      maximum is used when unspecified.

      <item><verbatim|Direction> is a Protobuf structure indicating the
      sequence direction of the requested blocks. The structure is a varying
      data type as defined in Definition <reference|defn-varrying-data-type>
      of the following format:

      <\big-table|<tabular|<tformat|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|3|1|1|cell-lborder|0ln>|<cwith|2|3|2|2|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|4|5|1|1|cell-lborder|0ln>|<cwith|4|5|2|2|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>>|<row|<cell|0>|<cell|Enumerate
      in ascending order>>|<row|<cell|>|<cell|(from child to
      parent)>>|<row|<cell|1>|<cell|Enumerate in descending
      order>>|<row|<cell|>|<cell|(from parent to cannonical child)>>>>>>
        <verbatim|Direction> Protobuf structure.
      </big-table>

      <item><math|B<rsub|m>> is the number of blocks to be returned. An
      implementation defined maximum is used when unspecified.
    </itemize-dot>
  </definition>

  <\definition>
    The <verbatim|BlockResponse> message is received after sending a
    <verbatim|BlockRequest> message to a peer. The message is a Protobuf
    serialized structure of the following format:

    <\big-table|<tabular|<tformat|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|1|cell-lborder|0ln>|<cwith|2|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Type>>|<cell|<strong|Id>>|<cell|<strong|Description>>>|<row|<cell|repeated>|<cell|1>|<cell|Block
    data for the requested sequence>>|<row|<cell|BlockData>|<cell|>|<cell|>>>>>>
      <verbatim|BlockResponse> Protobuf message.
    </big-table>

    where <verbatim|BlockData> is a Protobuf structure containing the
    requested blocks. Do note that the optional values are either present or
    absent depending on the requested fields (bitmask value). The structure
    has the following format:

    <\big-table|<tabular|<tformat|<cwith|6|8|1|-1|cell-tborder|1ln>|<cwith|6|8|1|-1|cell-bborder|1ln>|<cwith|6|8|1|-1|cell-lborder|0ln>|<cwith|6|8|1|-1|cell-rborder|0ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|1|3|1|-1|cell-tborder|1ln>|<cwith|1|3|1|-1|cell-bborder|1ln>|<cwith|1|3|1|-1|cell-lborder|0ln>|<cwith|1|3|1|-1|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|9|9|1|-1|cell-tborder|1ln>|<cwith|8|8|1|-1|cell-bborder|1ln>|<cwith|10|10|1|-1|cell-bborder|1ln>|<cwith|9|10|1|1|cell-lborder|0ln>|<cwith|9|10|4|4|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|4|4|cell-rborder|0ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-bborder|1ln>|<cwith|3|3|1|-1|cell-tborder|1ln>|<cwith|2|2|1|1|cell-lborder|0ln>|<cwith|2|2|4|4|cell-rborder|0ln>|<table|<row|<cell|<strong|Type>>|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Value>>>|<row|<cell|bytes>|<cell|1>|<cell|Block
    header hash>|<cell|Sect. <reference|sect-blake2>>>|<row|<cell|bytes>|<cell|2>|<cell|Block
    header (optional)>|<cell|Def. <reference|block>>>|<row|<cell|repeated>|<cell|3>|<cell|Block
    body (optional)>|<cell|Def. <reference|sect-block-body>>>|<row|<cell|bytes>|<cell|>|<cell|>|<cell|>>|<row|<cell|bytes>|<cell|4>|<cell|Block
    receipt (optional)>|<cell|>>|<row|<cell|bytes>|<cell|5>|<cell|Block
    message queue (optional)>|<cell|>>|<row|<cell|bytes>|<cell|6>|<cell|Justification
    (optional)>|<cell|Def. <reference|defn-grandpa-justification>>>|<row|<cell|bool>|<cell|7>|<cell|Indicates
    whether the justification>|<cell|>>|<row|<cell|>|<cell|>|<cell|is empty
    (i.e. should be ignored).>|<cell|>>>>>>
      <strong|BlockData> Protobuf structure.
    </big-table>
  </definition>

  <subsubsection|Transactions><label|sect-msg-transactions>

  Transactions as defined and described in Section
  <reference|sect-transactions> are sent directly to peers with which the
  Polkadot Host has an open transaction substream, as defined in Definition
  <reference|defn-transactions-message>. Polkadot Host implementers should
  implement a mechanism which only sends a transaction once to each peer and
  avoids sending duplicates. Sending duplicate transactions might result in
  undefined consequences such as being blocked for bad behavior by peers.

  The mechanism for managing transactions is further described in Section
  <reference|sect-extrinsics> respectively Section
  <reference|sect-transaction-submission> and Section
  <reference|sect-transaction-queue>.

  <\definition>
    <label|defn-transactions-message>The <strong|transactions message> is the
    structure of how the transactions are sent over the network. It is
    represented by <math|M<rsub|T>> and is defined as follows:

    <\equation*>
      M<rsub|T>\<assign\>Enc<rsub|SC><around*|(|C<rsub|1>,\<ldots\>,C<rsub|n>|)>
    </equation*>

    in which:

    <\equation*>
      C<rsub|i>\<assign\>Enc<rsub|SC><around*|(|E<rsub|i>|)>
    </equation*>

    Where each <math|E<rsub|i>> is a byte array and represents a sepearate
    extrinsic. The Polkadot Host is agnostic about the content of an
    extrinsic and treats it as a blob of data.

    Transactions are sent over the <verbatim|/dot/transactions/1> substream.
  </definition>

  <subsubsection|GRANDPA Votes><label|sect-msg-grandpa>

  The exchange of GRANDPA messages is conducted on the
  <verbatim|/paritytech/grandpa/1> substream. The process for the creation of
  such votes is described in Section <reference|sect-finality>.

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|3>
    <associate|page-first|33>
    <associate|section-nr|3>
    <associate|subsection-nr|4>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|4|?>>
    <associate|auto-10|<tuple|1.7.1|?>>
    <associate|auto-11|<tuple|1.7.2|?>>
    <associate|auto-12|<tuple|1|?>>
    <associate|auto-13|<tuple|2|?>>
    <associate|auto-14|<tuple|3|?>>
    <associate|auto-15|<tuple|4|?>>
    <associate|auto-16|<tuple|5|?>>
    <associate|auto-17|<tuple|6|?>>
    <associate|auto-18|<tuple|1.7.3|?>>
    <associate|auto-19|<tuple|1.7.4|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-20|<tuple|1.8.4|?>>
    <associate|auto-3|<tuple|1.1|?>>
    <associate|auto-4|<tuple|1.2|?>>
    <associate|auto-5|<tuple|1.3|?>>
    <associate|auto-6|<tuple|1.4|?>>
    <associate|auto-7|<tuple|1.5|?>>
    <associate|auto-8|<tuple|1.6|?>>
    <associate|auto-9|<tuple|1.7|?>>
    <associate|defn-block-announce|<tuple|3|?>>
    <associate|defn-block-announce-handshake|<tuple|2|?>>
    <associate|defn-peer-id|<tuple|1|?>>
    <associate|defn-transactions-message|<tuple|6|?>>
    <associate|sect-discovery-mechanism|<tuple|1.3|?>>
    <associate|sect-encryption-layer|<tuple|1.5|?>>
    <associate|sect-msg-grandpa|<tuple|1.7.4|?>>
    <associate|sect-msg-transactions|<tuple|1.7.3|?>>
    <associate|sect-network-messages|<tuple|1.7|?>>
    <associate|sect-networking-external-docs|<tuple|1.1|?>>
    <associate|sect-protocols-substreams|<tuple|1.6|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|1>|>
        <with|font-family|<quote|tt>|language|<quote|verbatim>|BlockRequest>
        Protobuf message.
      </surround>|<pageref|auto-13>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|2>|>
        Bits of block data to be requested.
      </surround>|<pageref|auto-14>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|3>|>
        Protobuf message indicating the block to start from.
      </surround>|<pageref|auto-15>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|4>|>
        <with|font-family|<quote|tt>|language|<quote|verbatim>|Direction>
        Protobuf structure.
      </surround>|<pageref|auto-16>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|5>|>
        <with|font-family|<quote|tt>|language|<quote|verbatim>|BlockResponse>
        Protobuf message.
      </surround>|<pageref|auto-17>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6>|>
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|BlockData>
        Protobuf structure.
      </surround>|<pageref|auto-18>>
    </associate>
    <\associate|toc>
      <vspace*|2fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-size|<quote|1.19>|4<space|2spc>Networking>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|1fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Introduction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <with|par-left|<quote|1tab>|1.1<space|2spc>External Documentation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1tab>|1.2<space|2spc><with|color|<quote|dark
      red>|<datoms|<macro|x|<resize|<tabular|<tformat|<cwith|1|1|1|1|cell-background|pastel
      red>|<cwith|1|1|1|1|cell-lsep|0fn>|<cwith|1|1|1|1|cell-rsep|0fn>|<cwith|1|1|1|1|cell-bsep|0.2fn>|<cwith|1|1|1|1|cell-tsep|0.2fn>|<table|<row|<cell|<arg|x>>>>>>|<plus|1l|0fn>|<plus|1b|0.2fn>|<minus|1r|0fn>|<minus|1t|0.2fn>>>|[libp2p
      convention perhaps]>> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|1.3<space|2spc>Node Identities
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1tab>|1.4<space|2spc>Discovery mechanism
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1tab>|1.5<space|2spc>Connection establishment
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|1tab>|1.6<space|2spc>Encryption Layer
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|1.7<space|2spc>Protocols and Substreams
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|1.8<space|2spc>Network Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|2tab>|1.8.1<space|2spc>Announcing blocks
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|2tab>|1.8.2<space|2spc>Requesting blocks
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|2tab>|1.8.3<space|2spc>Transactions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|2tab>|1.8.4<space|2spc>GRANDPA Votes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>
    </associate>
  </collection>
</auxiliary>