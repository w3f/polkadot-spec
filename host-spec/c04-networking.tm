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

  <todo|could you add a sentence to say what are we going to do in this
  chapter>

  <subsection|External Documentation>

  The completeness of implementing the Polkadot networking protocol requires
  the usage of external documentation. <todo|List them in the reference
  section and refer to them here>

  <\itemize>
    <item><hlink|libp2p|https://github.com/libp2p/specs>

    <item><hlink|Kademlia|https://en.wikipedia.org/wiki/Kademlia>\ 

    <item><hlink|Noise|https://noiseprotocol.org/>

    <item><hlink|mplex|https://docs.libp2p.io/concepts/stream-multiplexing/#mplex>

    <item><hlink|yamux|https://docs.libp2p.io/concepts/stream-multiplexing/#yamux>

    <item><hlink|Protocol Buffers|https://developers.google.com/protocol-buffers/docs/reference/proto3-spec>
  </itemize>

  <subsection|<todo|libp2p convention perhaps>>

  <\todo>
    libp2p address format
  </todo>

  <todo|libp2p protocol spec format like /dot/block-announces/1>

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
    network. Nodes that might be listening can respond the the broadcast. The
    libp2p mDNS specification defines this process in more detail (<todo|move
    to reference section><slink|><slink|https://github.com/libp2p/specs/blob/master/discovery/mdns.md>).
    This protocol is an optional implementation detail for Polkadot Host
    implementers and is not required in order to participate in the Polkadot
    network.

    <item><strong|Kademlia requests> invoking Kademlia <verbatim|FIND_NODE>
    requests, where nodes respond with their list of available peers.
    Kademlia requests must also contain protocol identifiers as described in
    Section <reference|sect-protocol-identifier>.
  </itemize>

  <subsection|Connection establishment>

  Polkadot nodes connect to peers by establishing a TCP connection. Once
  established, the node initiates a handshake with the remote peer's
  encryption layer <todo|do you initiate a handshake with a layer?>. An
  additional layer <todo|maybe specify if the layer is on the top or the
  bottom of the encrypted link>, known as the multiplexing layer, allows a
  connection to be split into substreams <todo|I would either define
  substream or refer to its definition in libp2p docs>, either by the local
  or remote node.

  The Polkadot node supports two types of substream protocols: <todo|my
  feeling is that (and I might be wrong) that if I'm an implementor, with
  this two paragraph I'm not able to implement the substream so if the detail
  is described somewhere else maybe we should refer to it.>

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

  The Polkadot Host can establish a connection with any peer it knows the
  address of<todo|I have mix feeling about ending sentence with
  \<#2018\>of\<#2019\>. A preposition is a very bad word to end a sentence
  with.>. The Polkadot Host supports multiple base-layer<todo|define perhaps?
  protocols over ip?> protocols:

  <\itemize>
    <item><strong|TCP/IP> with addresses in the form of
    <verbatim|/ip4/1.2.3.4/tcp/> to establish a TCP connection and negotiate
    an encryption and a multiplexing layer.

    <item><strong|Websockets> with addresses in the form of
    <verbatim|/ip4/1.2.3.4/ws/> to establish <todo|subject?>a TCP connection
    and negotiate the Websocket protocol within the connection. Additionally,
    an encryption and multiplexing layer is negotiated within the Websocket
    connection.

    <item><strong|DNS> addresses in form of
    <verbatim|/dns/website.domain/tcp/> and
    <verbatim|/dns/website.domain/ws/>.
  </itemize>

  After a base-layer protocol is established, the Polkadot Host will apply
  the Noise protocol <todo|so Noise is the encryption protocol? it need to be
  made explicit>

  <subsection|Noise Protocol <todo|encryption protocol/layer is a better
  name>>

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
    responder. <todo|shouldn't we be more precise on the type of the key
    pairs here or refer? are they ephemeral? is it a well established noise
    practice which doesn't need further clarification>

    <item>The responder generates its own keypair and sends its public key
    back to the initiator. After that, the responder derives a shared secret
    and uses it to encrypt all further communication. The responder now sends
    its static Noise public key (which is non-persistent <todo|define
    non-persistent and a note on how to trust a non-persistent identity>and
    generated on every node startup), its <verbatim|libp2p> public key and a
    signature of the static Noise public key signed with the
    <verbatim|libp2p> public key.

    <item>The initiator derives a shared secret and uses it to encrypt all
    further communication. It also sends its static Noise public key,
    <verbatim|libp2p> public key and a signature to the responder.
  </enumerate-numeric>

  <todo|if all these steps are done automagically by libp2p, maybe add a node
  so an implementor doesn't despair reading unimplementable explanations>

  After these three steps, both the initiator and responder derive a new
  shared secret using the static and session-defined Noise keys, which are
  used to encrypt all further communication. The Noise specification
  describes this process in detail. <todo|refer>

  <subsection|Protocols and Substreams><label|sect-protocols-substreams>

  After the node establishes a connection with a peer, the use of
  multiplexing allows the Polkadot Host to open substreams. <verbatim|libp2p>
  uses the <hlink|<verbatim|mplex> protocol|https://docs.libp2p.io/concepts/stream-multiplexing/#mplex>
  or the <hlink|<verbatim|yamux> protocol|https://docs.libp2p.io/concepts/stream-multiplexing/#yamux>
  to manage substream and to allow the negotiation of
  <with|font-shape|italic|application-specific protocols>, where each
  protocol servers a specific utility.

  The Polkadot Host adoptes <todo|what does \<#2018\>adopt\<#2019\> mean
  here?> the following substreams:

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

  <subsection|Network Messages>

  The Polkadot Host must actively communicate with the network in order to
  participate in the validation process or act as a full node.

  <todo|I'd add a note on SCALE vs ProtoBuf fiasco here>

  <todo|Here or in the intro libp2p section I'd drop a word on libp2p message
  formats/standards, how you make and send them in libp2p>

  <todo| in the encoding section describe or refer to ProtoBuf Spec then when
  ever you use SCALE or ProtoBuf refer to their definition>

  <subsubsection|Announcing blocks>

  When the node creates or receives a new block, it must be announced to the
  network. Other nodes within the network will track this announcement and
  can request information about this block. The mechanism for tracking
  announcement and requesting the required data is implementation specific.

  Block announcements and requests are conducted on the
  <verbatim|/dot/block-annou nces/1> substream <todo| could you explain more
  \<#2018\>conducted\<#2019\> and refe to def 2>

  <\definition>
    The <verbatim|BlockAnnounceHandshake> initializes a substream to a remote
    peer. Once established, all <verbatim|BlockAnnounce> <todo| you haven't
    defined this message yet so refer to its definition>messages created by
    the node are sent to that substream.<todo| shouldn't you refer to
    /dot/block-annouces/1 here>

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
    The <verbatim|BlockAnnounce> message is sent to the specified substream
    and indicates to remote peers the that node has either created or
    received a new block.

    The <verbatim|BlockAnnounce> message is a SCALE encoded structure of the
    following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|BA>|<cell|=>|<cell|Enc<rsub|SC><around*|(|Head<around*|(|B|)>,ib|)>>>>>
    </eqnarray*>

    where:

    <\eqnarray*>
      <tformat|<table|<row|<cell|Head<around*|(|B|)>>|<cell|=>|<cell|<math-it|Header
      of the announced block>>>|<row|<cell|ib>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0>|<cell|<math-it|Is
      the best block according to the node>>>|<row|<cell|1>|<cell|<math-it|Is
      the best block according to node>>>>>>>>>>
    </eqnarray*>
  </definition>

  <subsubsection|Requesting blocks><verbatim|>

  Block requests can be used to retrieve a range of blocks from peers.

  <\definition>
    The <verbatim|BlockRequest> message is a Protobuf serialized
    structure<todo|what is a protobuf serialized structure> of the following
    format:

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
      data type <todo|refer> of the following format:

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

  Transactions as defined and explained in <todo|refer to transaction
  section> are sent directly in its full form <todo|what is a full form> to
  connected <todo|define connected peers>peers. It is considered good
  behavior <todo|recommended? what is a good behavior, do you get dot? your
  social rank increases?> to implement a mechanism which only sends a
  transaction once to each peer and avoids sending duplicates. Such a
  mechanism is implementation specific and any absence of such a mechanism
  can result in consequences which are undefined <todo|I might be wrong but
  that seems too vague instead maybe the receiving peer may choose to drop
  the offending peer?>. On the othrer hand, the Polkadot host must be able to
  handle duplicate transactions received from its peers and prevents the
  inclusion of duplicate copies of a same transaction in
  <strike-through|multiple blocks><todo|state transition? why multiple block
  is important, why not the same block for that matter?>

  <todo|maybe deserve a definition?>The transactions message is represented
  by <math|M<rsub|T>> and is defined as follows:

  <\equation*>
    M<rsub|T>\<assign\>Enc<rsub|SC><around*|(|C<rsub|1>,\<ldots\>,C<rsub|n>|)>
  </equation*>

  in which:

  <\equation*>
    C<rsub|i>\<assign\>Enc<rsub|SC><around*|(|E<rsub|i>|)>
  </equation*>

  Where each <math|E<rsub|i>> is a byte array and represents a sepearate
  extrinsic. The Polkadot Host<todo|are we capitalizing H?> is
  indifferent<todo|agnostic?> about the content of an extrinsic and treats it
  as a blob of data. <todo|refer to transaction section discussing the same
  fact>

  The exchange of transactions is conducted on the
  <verbatim|/dot/transactions/1> substream.

  <subsubsection|GRANDPA Votes><label|sect-msg-grandpa>

  The exchange of GRANDPA messages is conducted on the
  <verbatim|/paritytech/grandpa/1> substream. The process for the creation of
  such votes is described in Section <reference|sect-finality>.

  <subsection|I'mOnline <todo|perhaps <verbatim|ImOnline>?> Heartbeat>

  <todo| you should as soon as possible make it clear that the Heartbeat is
  an extrinsic because heartbeat is not a defined word and use of undefined
  words makes spec tedious to read.>

  <todo|I'm not sure if this should be in the networking chapter. It doesn't
  have much to do with the networking. As far as it goes with network
  messages, it is just a transaction, perhaps should be moved to the
  consensus chapter as it is one of the duty of the validators>

  The I'm Online heartbeat is a crucial part of the Polkadot validation
  process, as it signals the active participation of the Polkadot validator
  node and confirms its reachability. The Polkadot network punishes
  unreachable validators which have been elected to an authority set by
  slashing <todo|define? reduce?> their bonded funds <todo|define bonded fund
  we haven't talk about it>. This is achieved by requiring validators to
  issue a signed extrinsic known as I'm Online heartbeat, on <todo|at?> the
  start of every Era <todo|have we defined Era? refer>.

  The Polkadot Runtime fully <todo|why fully? does it have a precise
  definition?> manages the creation and the timing of the <verbatim|ImOnline>
  extrinsic, but it's the responsiblity of the Polkadot host to gossip that
  extrinsic to the rest of the network. When the Runtime decides to create
  and propagate the <verbatim|ImOnline >heartbeat extrinsic, it calls the
  <verbatim|ext_offchain_submit_transaction> Host API function as described
  in Section <reference|sect-ext-offchain-submit-transaction>.

  The process of gossiping extrinsics is defined in section
  <reference|sect-extrinsics>.

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
    <associate|auto-10|<tuple|1.8|?>>
    <associate|auto-11|<tuple|1.8.1|?>>
    <associate|auto-12|<tuple|1.8.2|?>>
    <associate|auto-13|<tuple|1|?>>
    <associate|auto-14|<tuple|2|?>>
    <associate|auto-15|<tuple|3|?>>
    <associate|auto-16|<tuple|4|?>>
    <associate|auto-17|<tuple|5|?>>
    <associate|auto-18|<tuple|6|?>>
    <associate|auto-19|<tuple|1.8.3|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-20|<tuple|1.8.4|?>>
    <associate|auto-21|<tuple|1.9|?>>
    <associate|auto-3|<tuple|1.1|?>>
    <associate|auto-4|<tuple|1.2|?>>
    <associate|auto-5|<tuple|1.3|?>>
    <associate|auto-6|<tuple|1.4|?>>
    <associate|auto-7|<tuple|1.5|?>>
    <associate|auto-8|<tuple|1.6|?>>
    <associate|auto-9|<tuple|1.7|?>>
    <associate|defn-peer-id|<tuple|1|?>>
    <associate|sect-discovery-mechanism|<tuple|1.4|?>>
    <associate|sect-msg-grandpa|<tuple|1.8.4|?>>
    <associate|sect-msg-transactions|<tuple|1.8.3|?>>
    <associate|sect-protocols-substreams|<tuple|1.7|?>>
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

      <with|par-left|<quote|1tab>|1.6<space|2spc>Noise Protocol
      <with|color|<quote|dark red>|<datoms|<macro|x|<resize|<tabular|<tformat|<cwith|1|1|1|1|cell-background|pastel
      red>|<cwith|1|1|1|1|cell-lsep|0fn>|<cwith|1|1|1|1|cell-rsep|0fn>|<cwith|1|1|1|1|cell-bsep|0.2fn>|<cwith|1|1|1|1|cell-tsep|0.2fn>|<table|<row|<cell|<arg|x>>>>>>|<plus|1l|0fn>|<plus|1b|0.2fn>|<minus|1r|0fn>|<minus|1t|0.2fn>>>|[encryption
      protocol/layer is a better name]>> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
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

      <with|par-left|<quote|1tab>|1.9<space|2spc>I'mOnline
      <with|color|<quote|dark red>|<datoms|<macro|x|<resize|<tabular|<tformat|<cwith|1|1|1|1|cell-background|pastel
      red>|<cwith|1|1|1|1|cell-lsep|0fn>|<cwith|1|1|1|1|cell-rsep|0fn>|<cwith|1|1|1|1|cell-bsep|0.2fn>|<cwith|1|1|1|1|cell-tsep|0.2fn>|<table|<row|<cell|<arg|x>>>>>>|<plus|1l|0fn>|<plus|1b|0.2fn>|<minus|1r|0fn>|<minus|1t|0.2fn>>>|[perhaps
      <with|font-family|<quote|tt>|language|<quote|verbatim>|ImOnline>?]>>
      Heartbeat <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>
    </associate>
  </collection>
</auxiliary>