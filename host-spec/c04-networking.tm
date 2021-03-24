<TeXmacs|1.99.17>

<project|host-spec.tm>

<style|<tuple|generic|std-latex|old-dots|old-lengths>>

<\body>
  <chapter|Networking><label|sect-networking>

  <with|font-series|bold|Chapter Status:> This chapter in its current form is
  incomplete and considered work in progress. Authors appreciate receiving
  request for clarification or any reports regarding deviation from the
  current Polkadot network protocol. This can be done through filing an issue
  in Polkadot Specification repository <cite|w3f_polkadot-spec>.

  <section|Introduction>

  The Polkadot network is decentralized and does not rely on any central
  authority or entity in order to achieve its fullest potential of provided
  functionality. The networking protocol is based on a family of open
  protocols, including protocol implemented <verbatim|libp2p> e.g. the
  distributed Kademlia hash table which is used for peer discovery.

  This chapter walks through the behavior of the networking implemenation of
  the Polkadot Host and defines the network messages. Implementation details
  of the <verbatim|libp2p> protocols used in Polkadot protocol, are specified
  in external sources as described in Section
  <reference|sect-networking-external-docs>.

  <section|External Documentation><label|sect-networking-external-docs>

  Complete specification of \ the Polkadot networking protocol relies on
  \ the following external protocols:

  <\itemize>
    <item><hlink|libp2p|https://github.com/libp2p/specs> - <verbatim|libp2p>
    is a modular peer-to-<with-bib|bib|<with-bib|bib|>>peer networking stack
    composed of many modules and different parts. Included in
    <verbatim|libp2p> are multiplexing protocols <verbatim|mplex> and
    <verbatim|yamux>.

    <item><hlink|libp2p addressing|https://docs.libp2p.io/concepts/addressing/>
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
    - <verbatim|mplex> is a multiplexing protocol developed by
    <verbatim|libp2p>. The protocol allows to divide a connection to a peer
    into multiple substreams, each substream serving a specific purpose.
    Generally, Polkadot Host implementers are encouraged to prioritize
    implementing <verbatim|yamux>, since it's the de facto standard in
    Polkadot. <verbatim|mplex> is only required in order to communicate with
    <hlink|js-lip2p|https://github.com/libp2p/js-libp2p>.

    <item><hlink|yamux|https://docs.libp2p.io/concepts/stream-multiplexing/#yamux>
    - <verbatim|yamux> is a multiplexing protocol like <verbatim|mplex> and
    developed by HashiCorp. It's the de facto standard for the Polkadot Host.
    This protocol should be prioritzed over <verbatim|mplex>. Section
    <reference|sect-protocols-substreams> described the subprotocol in more
    detail.

    <item><hlink|Protocol Buffers|https://developers.google.com/protocol-buffers/docs/reference/proto3-spec>
    - Protocol Buffers is a language-neutral, platform-neutral mechanism for
    serializing structured data and is developed by Google. The Polkadot Host
    uses Protocol Buffers to serialze specific messages, as clarified in
    Section <reference|sect-network-messages>.
  </itemize>

  <section|Node Identities>

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

  <section|Discovery mechanism><label|sect-discovery-mechanism>

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
    Kademlia requests are performed on a specific substream as described in
    Section <reference|sect-protocols-substreams>.
  </itemize>

  <section|Connection establishment><label|sect-connection-establishment>

  Polkadot nodes connect to peers by establishing a TCP connection. Once
  established, the node initiates a handshake with the remote peer's on the
  encryption layer. An additional layer on top of the encryption layer, known
  as the multiplexing layer, allows a connection to be split into substreams,
  as described by the <hlink|yamux specification|https://docs.libp2p.io/concepts/stream-multiplexing/#yamux>,
  either by the local or remote node.

  The Polkadot node supports two types of substream protocols. Section
  <reference|sect-protocols-substreams> describes the usage of each type in
  more detail:

  <\itemize-dot>
    <item><strong|Request-Response substreams>: After the protocol is
    negotiated by the multiplexing layer, the initiator sends a single
    message containing a request. The responder then sends a response, after
    which the substream is then immediately closed. The requests and
    responses are prefixed with their <hlink|LEB128|https://en.wikipedia.org/wiki/LEB128>
    encoded length.

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

  The addressing system is described in the <hlink|libp2p
  addressing|https://docs.libp2p.io/concepts/addressing/> specification.
  After a base-layer protocol is established, the Polkadot Host will apply
  the Noise protocol to establish the encryption layer as described in
  Section <reference|sect-encryption-layer>.

  <section|Encryption Layer><label|sect-encryption-layer>

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

  <section|Protocols and Substreams><label|sect-protocols-substreams>

  After the node establishes a connection with a peer, the use of
  multiplexing allows the Polkadot Host to open substreams. <verbatim|libp2p>
  uses the <hlink|<verbatim|mplex> protocol|https://docs.libp2p.io/concepts/stream-multiplexing/#mplex>
  or the <hlink|<verbatim|yamux> protocol|https://docs.libp2p.io/concepts/stream-multiplexing/#yamux>
  to manage substream and to allow the negotiation of
  <with|font-shape|italic|application-specific protocols>, where each
  protocol servers a specific utility.

  The Polkadot Host uses multiple substreams, where its usage depends on a
  specific purpose. Each substream is either a <em|Request-Response
  substream> or a <em|Notification substream>, as described in Section
  <reference|sect-connection-establishment>.

  <\itemize>
    <item><verbatim|/ipfs/ping/1.0.0> - Open a standardized <verbatim|libp2p>
    substream to a peer and initialize a ping to verify if a connection is
    till alive. If the peer does not respond, the connection is dropped. This
    is a <em|Request-Response substream>.

    Further specification and reference implementation is available in the
    <hlink|libp2p documentation|https://docs.libp2p.io/concepts/protocols/#ping>.

    <item><verbatim|/ipfs/id/1.0.0> - Open a standardized <verbatim|libp2p>
    substream to a peer to ask information about that peer. This is a
    <em|Request-Response substream>.

    Further specification and reference implementation is available in the
    <hlink|libp2p documentation|https://docs.libp2p.io/concepts/protocols/#ping>.

    <item><verbatim|/dot/kad> - Open a standardized substream for Kademlia
    <verbatim|FIND_NODE> requests. This is a <em|Request-Response substream>,
    as defined by the <verbatim|libp2p> standard.

    Further specification and reference implementation is available on
    <hlink|Wikipedia|https://en.wikipedia.org/wiki/Kademlia> respectively the
    <hlink|golang Github repository|https://github.com/libp2p/go-libp2p-kad-dht>.
  </itemize>

  <\itemize>
    <item><verbatim|/dot/light/2> - a request and response protocol that
    allows a light client to request information about the state. This is a
    <em|Request-Response substream>.

    <todo|light client messages are currently not documented>

    <item><verbatim|/dot/block-announces/1> - a substream/notification
    protocol which sends blocks to connected peers. This is a
    <em|Notification substream>.

    The messages are specified in Section
    <reference|sect-msg-block-announce>.

    <item><verbatim|/dot/sync/2> - a request and response protocol that
    allows the Polkadot Host to perform information about blocks. This is a
    <em|Request-Response substream>.

    The messages are specified in Section <reference|sect-msg-block-request>.

    <item><verbatim|/dot/transactions/1> - a substream/notification protocol
    which sends transactions to connected peers. This is a <em|Notification
    substream>.

    The messages are specified in Section <reference|sect-msg-transactions>.

    <item><verbatim|/paritytech/grandpa/1> - a substream/notification
    protocol which sends GRANDPA votes to connected peers. This is a
    <em|Notification substream>.

    The messages are specified in Section <reference|sect-msg-grandpa-vote>.

    <todo|This substream will change in the future. See <hlink|issue
    #7252|https://github.com/paritytech/substrate/issues/7252>.>
  </itemize>

  <strong|Note>: the <verbatim|/dot/> prefixes on those substreams are known
  as protocol identifiers and are used to segregate communications to
  specific networks. This prevents any interference with other networks.
  <verbatim|/dot/> is used exclusively for Polkadot. Kusama, for example,
  uses the <verbatim|/ksmcc3/> protocol identifier.

  <section|Network Messages><label|sect-network-messages>

  The Polkadot Host must actively communicate with the network in order to
  participate in the validation process or act as a full node.

  <strong|Note>: The Polkadot network originally only used SCALE encoding for
  all message formats. Meanwhile, Protobuf has been adopted for certain
  messages. The encoding of each message is explicitly mentioned in their
  corresponding definition. Encoding and message formats are subject to
  change.

  <subsection|Announcing blocks><label|sect-msg-block-announce>

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
      not part of the best chain>>>|<row|<cell|1>|<cell|<math-it|Is the best
      block according to the node>>>>>>>>>>
    </eqnarray*>
  </definition>

  <subsection|Requesting blocks><label|sect-msg-block-request>

  Block requests can be used to retrieve a range of blocks from peers. Those
  messages are sent over the <verbatim|/dot/sync/2> substream.

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

  <subsection|Transactions><label|sect-msg-transactions>

  Transactions as defined and described in Section
  <reference|sect-extrinsics> are sent directly to peers with which the
  Polkadot Host has an open transaction substream, as defined in Definition
  <reference|defn-transactions-message>. Polkadot Host implementers should
  implement a mechanism which only sends a transaction once to each peer and
  avoids sending duplicates. Sending duplicate transactions might result in
  undefined consequences such as being blocked for bad behavior by peers.

  The mechanism for managing transactions is further described in Section
  <reference|sect-extrinsics>.

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

  <subsection|GRANDPA Messages><label|sect-msg-grandpa>

  <\definition>
    <label|defn-gossip-message><strong|GRANDPA Gossip> is a variant, as
    defined in Definition <reference|defn-varrying-data-type>, which
    identifies the message type that is casted by a voter. This type,
    followed by the sub-component, is sent to other validators.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|2|-1|1|-1|cell-hyphen|n>|<cwith|2|-1|1|-1|cell-tborder|1ln>|<cwith|2|-1|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|-1|cell-lborder|0ln>|<cwith|2|-1|1|-1|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Type>>>|<row|<cell|0>|<cell|GRANDPA
    message (vote)>>|<row|<cell|1>|<cell|GRANDPA
    pre-commit>>|<row|<cell|2>|<cell|GRANDPA neighbor
    packet>>|<row|3|<cell|GRANDPA catch up request
    message>>|<row|<cell|4>|<cell|GRANDPA catch up message>>>>>>
      GRANDPA gossip message types
    </big-table>
  </definition>

  The sub-components are the individual message types described in this
  section.

  <subsubsection|GRANDPA Vote Messages><label|sect-msg-grandpa-vote>

  The exchange of GRANDPA messages is conducted on the
  <verbatim|/paritytech/grandpa/1> substream. The process for the creation of
  such votes is described in Section <reference|sect-finality>.

  Voting is done by means of broadcasting voting messages to the network.
  Validators inform their peers about the block finalized in round <math|r>
  by broadcasting a finalization message (see Algorithm
  <reference|algo-grandpa-round> for more details). These messages are
  specified in this section.

  <\definition>
    <label|defn-sign-round-vote><strong|<math|Sign<rsup|r,stage><rsub|v<rsub|i>>>>
    refers to the signature of a voter for a specific message in a round and
    is formally defined as:

    <\equation*>
      Sign<rsup|r,stage><rsub|v<rsub|i>>:=Sig<rsub|ED25519><around*|(|msg,r,id<rsub|\<bbb-V\>>|)>
    </equation*>

    Where:

    <\big-table|<tabular|<tformat|<cwith|2|3|1|1|cell-halign|r>|<cwith|2|3|1|1|cell-lborder|0ln>|<cwith|2|3|2|2|cell-halign|l>|<cwith|2|3|3|3|cell-halign|l>|<cwith|2|3|3|3|cell-rborder|0ln>|<cwith|2|3|1|3|cell-valign|c>|<table|<row|<cell|msg>|<cell|the
    message to be signed>|<cell|arbitrary>>|<row|<cell|r:>|<cell|round
    number>|<cell|unsigned 64-bit integer>>|<row|<cell|<math|id<rsub|\<bbb-V\>>>>|<cell|authority
    set Id (Definition <reference|defn-authority-set-id>) of
    v>|<cell|unsigned 64-bit integer>>>>>>
      Signature for a message in a round.
    </big-table>

    \;
  </definition>

  <\definition>
    A vote casted by voter <math|v> should be broadcasted as a
    <strong|message <math|M<rsup|r,stage><rsub|v>>> to the network by voter
    <math|v> with the following structure:

    <\eqnarray*>
      <tformat|<table|<row|<cell|M<rsup|r,stage><rsub|v>>|<cell|\<assign\>>|<cell|Enc<rsub|SC><around*|(|r,id<rsub|\<bbb-V\>>,<math-it|SigMsg>|)>>>|<row|<cell|<math-it|SigMsg>>|<cell|\<assign\>>|<cell|<math-it|msg>,Sig<rsup|r,stage><rsub|v<rsub|i>>,v<rsub|id>>>|<row|<cell|<math-it|msg>>|<cell|\<assign\>>|<cell|Enc<rsub|SC><around*|(|stage,V<rsup|r,stage><rsub|v>|)>>>>>
    </eqnarray*>

    Where:

    <\center>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|r:>|<cell|round
      number>|<cell|unsigned 64-bit integer>>|<row|<cell|<math|id<rsub|\<bbb-V\>>>>|<cell|authority
      set Id (Definition <reference|defn-authority-set-id>)>|<cell|unsigned
      64-bit integer>>|<row|<cell|<math|Sig<rsup|r,stage><rsub|v<rsub|i>>>>|<cell|signature
      (Definition <reference|defn-sign-round-vote>)>|<cell|512-bit
      array>>|<row|<cell|<right-aligned|<math|v<rsub|id>>>:>|<cell|Ed25519
      public key of <math|v>>|<cell|256-bit
      array>>|<row|<cell|<right-aligned|><math|stage>:>|<cell|0 if it's a
      pre-vote sub-round>|<cell|8-bit integer>>|<row|<cell|>|<cell|1 if it's
      a pre-commit sub-round>|<cell|8-bit integer>>|<row|<cell|>|<cell|2 if
      it's a primary proposal message>|<cell|8-bit integer>>>>>
    </center>

    \;

    This message is the sub-component of the GRANDPA Gossip as defined in
    Definition <reference|defn-gossip-message> of type Id 0 and 1.

    \;

  </definition>

  <subsubsection|GRANDPA Finalizing Message>

  <\definition>
    <label|defn-grandpa-justification>The <strong|justification for block B
    in round <math|r>> of GRANDPA protocol defined
    <math|J<rsup|r,stage><around*|(|B|)>> is a vector of pairs of the type:

    <\equation*>
      <around*|(|V<around*|(|B<rprime|'>|)>,<around*|(|Sign<rsup|r,stage><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>,v<rsub|id>|)>|)>
    </equation*>

    in which either

    <\equation*>
      B<rprime|'>\<geqslant\>B
    </equation*>

    or <math|V<rsup|r,pc><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>> is an
    equivocatory vote.

    In all cases, <math|Sign<rsup|r,stage><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>>
    as defined in Definition <reference|defn-sign-round-vote> is the
    signature of voter <math|v<rsub|i>\<in\>\<bbb-V\><rsub|B>> broadcasted
    during either the pre-vote (stage = pv) or the pre-commit (stage = pc)
    sub-round of round r. A <strong|valid justification> must only contain
    up-to one valid vote from each voter and must not contain more than two
    equivocatory votes from each voter.
  </definition>

  <\definition>
    <label|defn-finalizing-justification>We say
    <math|J<rsup|r,pc><around*|(|B|)>> <strong|justifies the finalization> of
    <math|B<rprime|'>\<geqslant\>B> <strong|for a non-voter node <math|n>> if
    the number of valid signatures in <math|J<rsup|r,pc><around*|(|B|)>> for
    <math|B<rprime|'>> is greater than <math|<frac|2|3><around|\||\<bbb-V\><rsub|B>|\|>>.
  </definition>

  Note that <math|J<rsup|r,pc><around*|(|B|)>> can only be used by a
  non-voter node to finalize a block. In contrast, a voter node can only be
  assured of the finality of block <math|B> by actively participating in the
  voting process. That is by invoking Algorithm
  <reference|algo-grandpa-round>. See Definition
  <reference|defn-finalized-block> for more details.

  <\definition>
    <strong|<math|GRANDPA> finalizing message for block <math|B> in round
    <math|r>> represented as <strong|<math|M<rsub|v><rsup|r,Fin>>(B)> is a
    message broadcasted by voter <math|v> to the network indicating that
    voter <math|v> has finalized block <math|B> in round <math|r>. It has the
    following structure:

    <\equation*>
      M<rsup|r,Fin><rsub|v><around*|(|B|)>\<assign\>Enc<rsub|SC><around|(|r,V<around*|(|B|)>,J<rsup|r,pc><around*|(|B|)>|)>
    </equation*>

    in which <math|J<rsup|r><around*|(|B|)>> in the justification defined in
    Definition <reference|defn-grandpa-justification>.
  </definition>

  <subsubsection|GRANDPA Catch-up Messages><label|sect-grandpa-catchup-messages>

  Whenever a Polkadot node detects that it is lagging behind the finality
  procedure, it needs to initiate a <em|catch-up> procedure. Neighbor packet
  network message (see Section <reference|sect-msg-grandpa>) reveals the
  round number for the last finalized GRANDPA round which the sending peer
  has observed. This provides a means to identify a discrepancy in the latest
  finalized round number observed among the peers. If such a discrepancy is
  observed, the node needs to initiate the catch-up procedure explained in
  Section <reference|sect-grandpa-catchup>.

  In particular, this procedure involves sending <em|catch-up request> and
  processing <em|catch-up response> messages specified here:

  <\definition>
    <label|defn-grandpa-catchup-request-msg><strong|GRANDPA catch-up request
    message for round r> represented as <strong|<math|M<rsub|i,v><rsup|Cat-q><around*|(|id<rsub|\<bbb-V\>>,r|)>>>
    is a message sent from node <math|i> to its voting peer node <math|v>
    requesting the latest status of a GRANDPA round
    <math|r<rprime|'>\<gtr\>r> of of authority set <math|\<bbb-V\><rsub|id>>
    along with the justification of the status and has the followin
    structure:

    <\equation*>
      M<rsub|i,v><rsup|Cat-q><around*|(|id<rsub|\<bbb-V\>>,r|)>\<assign\>Enc<rsub|SC><around*|(|r,id<rsub|\<bbb-V\>>|)>
    </equation*>

    This message is the sub-component of the GRANDPA Gossip as defined in
    Definition <reference|defn-gossip-message> of type Id 3.
  </definition>

  <\definition>
    <label|defn-grandpa-catchup-response-msg><strong|GRANDPA catch-up
    response message for round r> formally denoted as
    \ <strong|<math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>>>
    is a message sent by a node <math|v> to node i in response of a catch up
    request <math|M<rsub|v,i><rsup|Cat-q><around*|(|id<rsub|\<bbb-V\>>,r<rprime|'>|)>>
    in which <math|r\<geqslant\>r<rprime|'>> is the latest GRNADPA round
    which v has prove of its finalization and has the following structure:

    <\equation*>
      M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>\<assign\>Enc<rsub|SC><around*|(|id<rsub|\<bbb-V\>>,r,J<rsup|r,pv><around*|(|B|)>,J<rsup|r,pc><around*|(|B|)>,H<rsub|h><around*|(|B<rprime|'>|)>,H<rsub|i><around*|(|B<rprime|'>|)>|)>
    </equation*>

    Where B is the highest block which <math|v> believes to be finalized in
    round <math|r>. <math|B<rprime|'>> is the highest anscestor of all blocks
    voted on in <math|J<rsup|r,pc><around*|(|B|)>> with the exception of the
    equivocationary votes. This message is the sub-component of the GRANDPA
    Gossip as defined in Definition <reference|defn-gossip-message> of type
    Id 4.
  </definition>

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>
