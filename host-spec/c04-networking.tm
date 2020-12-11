<TeXmacs|1.99.16>

<project|host-spec.tm>

<style|<tuple|generic|std-latex|old-dots|old-lengths>>

<\body>
  <chapter|Networking>

  <with|font-series|bold|Chapter Status:> This document in its current form
  is incomplete and considered work in progress. Any reports regarding
  falseness or clarifications are appreciated.

  <section|Introduction>

  The Polkadot network is decentralized and does not rely on any central
  authority or entity in order to achieve a its fullest potential of provided
  functionality. Each node with the network can authenticate itself and its
  peers by using cryptographic keys, including establishing fully encrypted
  connections. The networking protocol is based on the open and standardized
  <verbatim|libp2p> protocol, including the usage of the distributed Kademlia
  hash table for peer discovery.

  <subsection|External Documentation>

  The completeness of implementing the Polkadot networking protocol requires
  the usage of external documentation.

  <\itemize>
    <item><hlink|libp2p|https://github.com/libp2p/specs>

    <item><hlink|Kademlia|https://en.wikipedia.org/wiki/Kademlia>

    <item><hlink|Noise|https://noiseprotocol.org/>

    <item><hlink|Protocol Buffers|https://developers.google.com/protocol-buffers/docs/reference/proto3-spec>
  </itemize>

  <subsection|Node Identities>

  Each Polkadot Host node maintains a ED25519 key pair which is used to
  identify the node. The public key is shared with the rest of the network.
  This allows nodes to establish secure communication channels. Nodes are
  discovered as described in the Discovery Mechanism Section
  (<reference|sect-discovery-mechanism>), where each node can be identified
  by their corresponding <verbatim|PeerId> (<reference|defn-peer-id>).

  Each node must have its own unique ED25519 key pair. Using the same pair
  among two or more nodes is interpreted as bad behavior.

  <\definition>
    <label|defn-peer-id>The Polkadot node's <verbatim|PeerId>, formally
    referred to as <math|P<rsub|id>>, is derived from the ED25519 public key
    and is structured as defined in the libp2p specification
    (<slink|https://docs.libp2p.io/concepts/peer-id/>).
  </definition>

  <subsection|Discovery mechanism><label|sect-discovery-mechanism>

  The Polkadot Host uses various mechanisms to find peers within the network,
  to establish and maintain a list of peers and to share that list with other
  peers from the network.

  <\itemize>
    <item>Bootstrap nodes - hard-coded node identities and addresses provided
    by the genesis state specification as described in Appendix
    <reference|sect-genesis-block>.

    <item>mDNS - performs a broadcast to the local network. Nodes that might
    be listing can respond the the broadcast. The libp2p mDNS specification
    defines this process in more detail (<slink|><slink|https://github.com/libp2p/specs/blob/master/discovery/mdns.md>).

    <item>Kademlia requests - Kademlia is a distributed hash table for
    decentralized networks and supports <verbatim|FIND_NODE> requests, where
    nodes respond with their list of available peers.
  </itemize>

  <subsubsection|Protocol Identifier>

  Kademlia nodes only communicate with other nodes using the same protocol
  identifier. The Polkadot network is identified by <verbatim|dot>
  (respectively <verbatim|ksmcc3> for Kusama).

  <subsection|Connection establishment>

  The Polkadot Host can establish a connection with any peer it knows the
  address. <verbatim|libp2p> uses the <verbatim|multistream-select> protocol
  in order to establish an encryption and multiplexing layer. The Polkadot
  Host supports multiple base-layer protocols:

  <\itemize>
    <item>TCP/IP - addresses in the form of <verbatim|/ip4/1.2.3.4/tcp/>
    establish a TCP connection and negotiate a encryption and multiplexing
    layer.

    <item>Websockets - addresses in the form of <verbatim|/ip4/1.2.3.4/ws/>
    establish a TCP connection and negotiate the Websocket protocol within
    the connection. Additionally, a encryption and multiplexing layer is
    negotiated within the Websocket connection.

    <item>DNS - addresses in form of <verbatim|/dns/website.domain/tcp/> and
    <verbatim|/dns/website.domain/ws/>.
  </itemize>

  After a base-layer protocol is established, the Polkadot Host will apply
  the Noise protocol.

  <subsection|Encryption>

  <todo|todo>

  <subsection|Substreams>

  After the node establishes a connection with a peer, the use of
  multiplexing allows the Polkadot Host to open substreams. Substreams allow
  the negotiation of <with|font-shape|italic|application-specific protocols>,
  where each protocol servers a specific utility.

  The Polkadot Host adoptes the following, standardized <verbatim|libp2p>
  application-specific protocols:

  <\itemize>
    <item><verbatim|/ipfs/ping/1.0.0> - Open a substream to a peer and
    initialize a ping to verify if a connection is till alive. If the peer
    does not respond, the connection is dropped.

    <item><verbatim|/ipfs/id/1.0.0> - Open a substream to a peer to ask
    information about that peer.

    <item><verbatim|/dot/kad/> - Open a substream for Kademlia
    <verbatim|FIND_NODE> requests.
  </itemize>

  Additional, non-standardized protocols:

  <\itemize>
    <item><verbatim|/dot/sync/2> - a request and response protocol that
    allows the Polkadot Host to perform information about blocks.

    <item><verbatim|/dot/light/2> - a request and response protocol that
    allows a light client to perform request information about the state.

    <item><verbatim|/dot/transactions/1> - a notification protocol which
    sends transactions to connected peers.

    <item><verbatim|/dot/block-announces/1> - a notification protocol which
    sends blocks to connected peers.
  </itemize>

  <subsection|Network Messages>

  The Polkadot Host must actively communicate with the network in order to
  participate in the validation process. This section describes the expected
  behaviors of the node.

  <subsubsection|Announcing blocks>

  When the node creates a new block, it must be announced to the network.
  Other nodes within the network will track this announcement and can request
  information about this block. This process is described in Section
  <todo|todo>.

  <\definition>
    The <verbatim|BlockAnnounceHandshake> initializes a substream to a remote
    peer. Once established, all <verbatim|BlockAnnounce> messages created by
    the node are sent to that substream.

    The <verbatim|BlockAnnounceHandshake> is a SCALE encoded structure of the
    following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|BA<rsub|h>>|<cell|=>|<cell|<around*|(|R,N<rsub|B>,h<rsub|B>,h<rsub|G>|)>>>>>
    </eqnarray*>

    where:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0
      >|<cell|<math-it|The node is a full node>>>|<row|<cell|1
      >|<cell|<math-it|The node is a light client>>>|<row|<cell|2
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
      <tformat|<table|<row|<cell|BA>|<cell|=>|<cell|<around*|(|Head<around*|(|B|)>,ib|)>>>>>
    </eqnarray*>

    where:

    <\eqnarray*>
      <tformat|<table|<row|<cell|Head<around*|(|B|)>>|<cell|=>|<cell|<math-it|Header
      of the announced block>>>|<row|<cell|ib>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0>|<cell|<math-it|Is
      the best block according to the node>>>|<row|<cell|1>|<cell|<math-it|Is
      the best block according to node>>>>>>>>>>
    </eqnarray*>
  </definition>

  <subsubsection|Requesting blocks>

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
      in the request. It's big endian encoded bitmask which applies all
      desired fields with bitwise OR operations. For example, the
      <math|B<rsub|f>> value to request <verbatim|Header> and
      <verbatim|Justification> is <verbatim|0001 0001> (17).

      <\big-table|<tabular|<tformat|<cwith|2|-1|1|-1|cell-tborder|1ln>|<cwith|2|-1|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|-1|cell-lborder|0ln>|<cwith|2|-1|1|-1|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<table|<row|<cell|<strong|Field>>|<cell|<strong|Value>>>|<row|<cell|Header>|<cell|0000
      0001>>|<row|<cell|Body>|<cell|0000 0010>>|<row|<cell|Receipt>|<cell|0000
      0100>>|<row|<cell|Message Queue>|<cell|0000
      1000>>|<row|<cell|Justification>|<cell|0001 0000>>>>>>
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
      data type of the following format:

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

  <subsection|I'm Online Heartbeat>

  The I'm Online heartbeat is a crucial part of the Polkadot validation
  process, as it signals the active participation of validators and confirms
  their reachability. The Polkadot network punishes unreachable validators
  which have been elected to an authority by slashing their bonded funds.
  This is achieved by requiring validators to issue an I'm Online heartbeat,
  which comes in the form of a signed extrinsic, on the start of every Era.

  The Polkadot Runtime fully manages the creation and the timing of that
  signed extrinsic, but it's the responsiblity of the Host to gossip that
  extrinsic to the rest of the network. When the Runtime decides to create
  the heartbeat, it will call the <verbatim|ext_offchain_submit_transaction>
  Host API as described in Section <todo|todo: define offchain Host APIs>.

  The process of gossiping extrinsics is defined in section
  <reference|sect-extrinsics>.
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
    <associate|auto-10|<tuple|1.7|?>>
    <associate|auto-11|<tuple|1.7.1|?>>
    <associate|auto-12|<tuple|1.7.2|?>>
    <associate|auto-13|<tuple|1|?>>
    <associate|auto-14|<tuple|2|?>>
    <associate|auto-15|<tuple|3|?>>
    <associate|auto-16|<tuple|4|?>>
    <associate|auto-17|<tuple|5|?>>
    <associate|auto-18|<tuple|6|?>>
    <associate|auto-19|<tuple|1.8|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-20|<tuple|1.9|?>>
    <associate|auto-21|<tuple|2|?>>
    <associate|auto-22|<tuple|2.1|?>>
    <associate|auto-23|<tuple|2.1.1|?>>
    <associate|auto-24|<tuple|2.1.2|?>>
    <associate|auto-25|<tuple|2.1.3|?>>
    <associate|auto-26|<tuple|2.1.4|?>>
    <associate|auto-27|<tuple|2.1.5|?>>
    <associate|auto-28|<tuple|2.1.6|?>>
    <associate|auto-29|<tuple|2.1.7|?>>
    <associate|auto-3|<tuple|1.1|?>>
    <associate|auto-30|<tuple|2.1.8|?>>
    <associate|auto-31|<tuple|2.1.9|?>>
    <associate|auto-32|<tuple|2.1.10|?>>
    <associate|auto-33|<tuple|2.1.11|?>>
    <associate|auto-34|<tuple|2.2|?>>
    <associate|auto-35|<tuple|2.2.1|?>>
    <associate|auto-36|<tuple|2.2.2|?>>
    <associate|auto-37|<tuple|2.3.2|?>>
    <associate|auto-38|<tuple|2.3.2|?>>
    <associate|auto-39|<tuple|2.3.2|?>>
    <associate|auto-4|<tuple|1.2|?>>
    <associate|auto-5|<tuple|1.3|?>>
    <associate|auto-6|<tuple|1.3.1|?>>
    <associate|auto-7|<tuple|1.4|?>>
    <associate|auto-8|<tuple|1.5|?>>
    <associate|auto-9|<tuple|1.6|?>>
    <associate|defn-peer-id|<tuple|1|?>>
    <associate|sect-discovery-mechanism|<tuple|1.3|?>>
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
        <with|font-family|<quote|tt>|language|<quote|verbatim>|BlockResponse>
        Protobuf message.
      </surround>|<pageref|auto-16>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|5>|>
        \;
      </surround>|<pageref|auto-17>>
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

      <with|par-left|<quote|1tab>|1.2<space|2spc>Node Identities
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|1.3<space|2spc>Discovery mechanism
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|2tab>|1.3.1<space|2spc>Protocol Identifier
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1tab>|1.4<space|2spc>Connection establishment
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|1tab>|1.5<space|2spc>Encryption
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|1.6<space|2spc>Substreams
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|1.7<space|2spc>Behavior for ougoing
      messages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|2tab>|1.7.1<space|2spc>Announcing blocks
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|2tab>|1.7.2<space|2spc>Requesting blocks
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|1.8<space|2spc>Behavior for incoming
      messages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|1tab>|1.9<space|2spc>I'm Online Heartbeat
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Network
      Messages> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20><vspace|0.5fn>

      <with|par-left|<quote|1tab>|2.1<space|2spc>API Package
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|2tab>|2.1.1<space|2spc>BlockRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|2tab>|2.1.2<space|2spc>BlockResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <with|par-left|<quote|1tab>|2.2<space|2spc>Light Package
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|2tab>|2.2.1<space|2spc>Request
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|2tab>|2.2.2<space|2spc>Response
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|2tab>|2.2.3<space|2spc>RemoteCallRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>

      <with|par-left|<quote|2tab>|2.2.4<space|2spc>RemoteCallResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|2tab>|2.2.5<space|2spc>RemoteReadRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|2tab>|2.2.6<space|2spc>RemoteReadResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <with|par-left|<quote|2tab>|2.2.7<space|2spc>RemoteReadChildRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|2tab>|2.2.8<space|2spc>RemoteHeaderRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32>>

      <with|par-left|<quote|2tab>|2.2.9<space|2spc>RemoteHeaderResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <with|par-left|<quote|2tab>|2.2.10<space|2spc>RemoteChangesRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34>>

      <with|par-left|<quote|2tab>|2.2.11<space|2spc>RemoteChangesResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35>>

      <with|par-left|<quote|1tab>|2.3<space|2spc>Finality Package
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36>>

      <with|par-left|<quote|2tab>|2.3.1<space|2spc>FinalityProofRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37>>

      <with|par-left|<quote|2tab>|2.3.2<space|2spc>FinalityProofResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38>>
    </associate>
  </collection>
</auxiliary>