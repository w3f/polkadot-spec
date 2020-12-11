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

  <subsection|Behavior for ougoing messages>

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

  Block requests can be used to retrieve a range of blocks from peers. The
  BlockRequest message is a Protobuf serialized structure of the following
  format:

  <\big-table|<tabular|<tformat|<table|<row|<cell|<strong|Type>>|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Value>>>|<row|<cell|uint32>|<cell|1>|<cell|Bits
  of block data to request>|<cell|<math|B<rsub|f>>>>|<row|<cell|oneof>|<cell|>|<cell|Start
  from this block>|<cell|<math|B<rsub|S>>>>|<row|<cell|bytes>|<cell|4>|<cell|End
  at this block (optional)>|<cell|<math|B<rsub|e>>>>|<row|<cell|Direction>|<cell|5>|<cell|Sequence
  direction>|<cell|>>|<row|<cell|uint32>|<cell|6>|<cell|Maximum amount
  (optional)>|<cell|<math|B<rsub|m>>>>>>>>
    <verbatim|BlockRequest> Protobuf message.
  </big-table>

  where

  <\itemize-dot>
    <item><math|B<rsub|f>> indictes all the fields should be included in the
    request. It's big endian encoded bitmask which applies all desired fields
    with bitwise OR operations. For example, the <math|B<rsub|f>> value for
    <verbatim|Header> and <verbatim|Justification> is <verbatim|17>.

    <\big-table|<tabular|<tformat|<table|<row|<cell|<strong|Field>>|<cell|<strong|Value>>>|<row|<cell|Header>|<cell|0000
    0001>>|<row|<cell|Body>|<cell|0000 0010>>|<row|<cell|Receipt>|<cell|0000
    0100>>|<row|<cell|Message Queue>|<cell|0000
    1000>>|<row|<cell|Justification>|<cell|0001 0000>>>>>>
      Bits of block data to be requested.
    </big-table>

    <item><math|B<rsub|s>> is a varying data type of the following values:

    <\big-table|<tabular|<tformat|<table|<row|<cell|<strong|Type>>|<cell|<strong|Id>>|<cell|<strong|Decription>>>|<row|<cell|bytes>|<cell|2>|<cell|The
    block hash>>|<row|<cell|bytes>|<cell|3>|<cell|The block number>>>>>>
      Block hash or number to start from.
    </big-table>

    <item><math|B<rsub|e>> is either the block hash or block number depending
    on the value of <math|B<rsub|s>>. An implementation defined maximum is
    used when unspecified.

    <item><math|B<rsub|m>> is the number of blocks to be returned. An
    implementation defined maximum is used when unspecified.
  </itemize-dot>

  \;

  <subsection|Behavior for incoming messages>

  The Polkadot node can receive a handful of messages from its peers, by
  which the Polkadot node is expected to act accordingly.

  \;

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

  <section|Network Messages>

  <subsection|API Package>

  ProtoBuf details:

  <\itemize>
    <item>syntax: proto3

    <item>package: api.v1
  </itemize>

  <subsubsection|BlockRequest>

  Request block data from a peer.

  <\verbatim>
    \;

    message BlockRequest {

    \ \ \ \ // Bits of block data to request.

    \ \ \ \ uint32 fields = 1;

    \ \ \ \ // Start from this block.

    \ \ \ \ oneof from_block {

    \ \ \ \ \ \ \ \ // Start with given hash.

    \ \ \ \ \ \ \ \ bytes hash = 2;

    \ \ \ \ \ \ \ \ // Start with given block number.

    \ \ \ \ \ \ \ \ bytes number = 3;

    \ \ \ \ }

    \ \ \ \ // End at this block. An implementation defined

    \ \ \ \ // maximum is used when unspecified.

    \ \ \ \ bytes to_block = 4; // optional

    \ \ \ \ // Sequence direction.

    \ \ \ \ Direction direction = 5;

    \ \ \ \ // Maximum number of blocks to return. An implementation

    \ \ \ \ // defined maximum is used when unspecified.

    \ \ \ \ uint32 max_blocks = 6; // optional

    }

    \;

    // Block enumeration direction

    enum Direction {

    \ \ \ \ // Enumerate in ascending order

    \ \ \ \ // (from child to parent).

    \ \ \ \ Ascending = 0;

    \ \ \ \ // Enumerate in descending order

    \ \ \ \ // (from parent to canonical child).

    \ \ \ \ Descending = 1;

    }

    \;
  </verbatim>

  <subsubsection|BlockResponse>

  Response to Block Request.

  <\verbatim>
    \;

    message BlockResponse {

    \ \ \ \ // Block data for the requested sequence.

    \ \ \ \ repeated BlockData blocks = 1;

    }

    \;

    // Block data sent in the response.

    message BlockData {

    \ \ \ \ // Block header hash.

    \ \ \ \ bytes hash = 1;

    \ \ \ \ // Block header if requested.

    \ \ \ \ bytes header = 2; // optional

    \ \ \ \ // Block body if requested.

    \ \ \ \ repeated bytes body = 3; // optional

    \ \ \ \ // Block receipt if requested.

    \ \ \ \ bytes receipt = 4; // optional

    \ \ \ \ // Block message queue if requested.

    \ \ \ \ bytes message_queue = 5; // optional

    \ \ \ \ // Justification if requested.

    \ \ \ \ bytes justification = 6; // optional

    \ \ \ \ // True if justification should be treated as present but

    \ \ \ \ // empty. This hack is unfortunately necessary because

    \ \ \ \ // shortcomings in the protobuf format otherwise doesn't

    \ \ \ \ // make it possible to differentiate between a lack of

    \ \ \ \ // justification and an empty justification.

    \ \ \ \ bool is_empty_justification = 7; // optional, false if absent

    }

    \;
  </verbatim>

  <subsection|Light Package>

  ProtoBuf details:

  <\itemize>
    <item>syntax: proto3

    <item>package: api.v1.light
  </itemize>

  <subsubsection|Request>

  Enumerate all possible light client request messages.

  <\verbatim>
    \;

    message Request {

    \ \ \ \ oneof request {

    \ \ \ \ \ \ \ \ RemoteCallRequest remote_call_request = 1;

    \ \ \ \ \ \ \ \ RemoteReadRequest remote_read_request = 2;

    \ \ \ \ \ \ \ \ RemoteHeaderRequest remote_header_request = 3;

    \ \ \ \ \ \ \ \ RemoteReadChildRequest remote_read_child_request = 4;

    \ \ \ \ \ \ \ \ RemoteChangesRequest remote_changes_request = 5;

    \ \ \ \ }

    }

    \;
  </verbatim>

  <subsubsection|Response>

  Enumerate all possible light client response messages.

  <\verbatim>
    \;

    message Response {

    \ \ \ \ oneof response {

    \ \ \ \ \ \ \ \ RemoteCallResponse remote_call_response = 1;

    \ \ \ \ \ \ \ \ RemoteReadResponse remote_read_response = 2;

    \ \ \ \ \ \ \ \ RemoteHeaderResponse remote_header_response = 3;

    \ \ \ \ \ \ \ \ RemoteChangesResponse remote_changes_response = 4;

    \ \ \ \ }

    }

    \;
  </verbatim>

  <subsubsection|RemoteCallRequest>

  Remote call request.

  <\verbatim>
    \;

    message RemoteCallRequest {

    \ \ \ \ // Block at which to perform call.

    \ \ \ \ bytes block = 2;

    \ \ \ \ // Method name.

    \ \ \ \ string method = 3;

    \ \ \ \ // Call data.

    \ \ \ \ bytes data = 4;

    }

    \;
  </verbatim>

  <subsubsection|RemoteCallResponse>

  Remote call response.

  <\verbatim>
    \;

    message RemoteCallResponse {

    \ \ \ \ // Execution proof.

    \ \ \ \ bytes proof = 2;

    }

    \;
  </verbatim>

  <subsubsection|RemoteReadRequest>

  Remote storage read request.

  <\verbatim>
    \;

    message RemoteReadRequest {

    \ \ \ \ // Block at which to perform call.

    \ \ \ \ bytes block = 2;

    \ \ \ \ // Storage keys.

    \ \ \ \ repeated bytes keys = 3;

    }

    \;
  </verbatim>

  <subsubsection|RemoteReadResponse>

  Remote read response.

  <\verbatim>
    \;

    message RemoteReadResponse {

    \ \ \ \ // Read proof.

    \ \ \ \ bytes proof = 2;

    }

    \;
  </verbatim>

  <subsubsection|RemoteReadChildRequest>

  Remote storage read child request.

  <\verbatim>
    \;

    message RemoteReadChildRequest {

    \ \ \ \ // Block at which to perform call.

    \ \ \ \ bytes block = 2;

    \ \ \ \ // Child Storage key, this is relative

    \ \ \ \ // to the child type storage location.

    \ \ \ \ bytes storage_key = 3;

    \ \ \ \ // Storage keys.

    \ \ \ \ repeated bytes keys = 6;

    }

    \;
  </verbatim>

  <subsubsection|RemoteHeaderRequest>

  Remote header request.

  <\verbatim>
    \;

    message RemoteHeaderRequest {

    \ \ \ \ // Block number to request header for.

    \ \ \ \ bytes block = 2;

    }

    \;
  </verbatim>

  <subsubsection|RemoteHeaderResponse>

  Remote header response.

  <\verbatim>
    \;

    message RemoteHeaderResponse {

    \ \ \ \ // Header. None if proof generation has failed

    \ \ \ \ // (e.g. header is unknown).

    \ \ \ \ bytes header = 2; // optional

    \ \ \ \ // Header proof.

    \ \ \ \ bytes proof = 3;

    }

    \;
  </verbatim>

  <subsubsection|RemoteChangesRequest>

  Remote changes request.

  <\verbatim>
    \;

    message RemoteChangesRequest {

    \ \ \ \ // Hash of the first block of the range (including first)

    \ \ \ \ // where changes are requested.

    \ \ \ \ bytes first = 2;

    \ \ \ \ // Hash of the last block of the range (including last)

    \ \ \ \ // where changes are requested.

    \ \ \ \ bytes last = 3;

    \ \ \ \ // Hash of the first block for which the requester has

    \ \ \ \ // the changes trie root. All other

    \ \ \ \ // affected roots must be proved.

    \ \ \ \ bytes min = 4;

    \ \ \ \ // Hash of the last block that we can use when

    \ \ \ \ // querying changes.

    \ \ \ \ bytes max = 5;

    \ \ \ \ // Storage child node key which changes are requested.

    \ \ \ \ bytes storage_key = 6; // optional

    \ \ \ \ // Storage key which changes are requested.

    \ \ \ \ bytes key = 7;

    }

    \;
  </verbatim>

  <subsubsection|RemoteChangesResponse>

  Remote changes response.

  <\verbatim>
    \;

    message RemoteChangesResponse {

    \ \ \ \ // Proof has been generated using block with this number

    \ \ \ \ // as a max block. Should be less than or equal to the

    \ \ \ \ // RemoteChangesRequest::max block number.

    \ \ \ \ bytes max = 2;

    \ \ \ \ // Changes proof.

    \ \ \ \ repeated bytes proof = 3;

    \ \ \ \ // Changes tries roots missing on the requester' node.

    \ \ \ \ repeated Pair roots = 4;

    \ \ \ \ // Missing changes tries roots proof.

    \ \ \ \ bytes roots_proof = 5;

    }

    \;

    // A pair of arbitrary bytes.

    message Pair {

    \ \ \ \ // The first element of the pair.

    \ \ \ \ bytes fst = 1;

    \ \ \ \ // The second element of the pair.

    \ \ \ \ bytes snd = 2;

    }

    \;
  </verbatim>

  <subsection|Finality Package>

  ProtoBuf details:

  <\itemize>
    <item>syntax: proto3

    <item>package: api.v1.finality
  </itemize>

  <subsubsection|FinalityProofRequest>

  Request a finality proof from a peer.

  <\verbatim>
    \;

    message FinalityProofRequest {

    \ \ \ \ // SCALE-encoded hash of the block to request.

    \ \ \ \ bytes block_hash = 1;

    \ \ \ \ // Opaque chain-specific additional request data.

    \ \ \ \ bytes request = 2;

    }

    \;
  </verbatim>

  <subsubsection|FinalityProofResponse>

  Response to a finality proof request.

  <\verbatim>
    \;

    message FinalityProofResponse {

    \ \ \ \ // Opaque chain-specific finality proof.

    \ \ \ \ // Empty if no such proof exists.

    \ \ \ \ bytes proof = 1; // optional

    }

    \;
  </verbatim>
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
    <associate|auto-16|<tuple|1.8|?>>
    <associate|auto-17|<tuple|1.9|?>>
    <associate|auto-18|<tuple|2|?>>
    <associate|auto-19|<tuple|2.1|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-20|<tuple|2.1.1|?>>
    <associate|auto-21|<tuple|2.1.2|?>>
    <associate|auto-22|<tuple|2.2|?>>
    <associate|auto-23|<tuple|2.2.1|?>>
    <associate|auto-24|<tuple|2.2.2|?>>
    <associate|auto-25|<tuple|2.2.3|?>>
    <associate|auto-26|<tuple|2.2.4|?>>
    <associate|auto-27|<tuple|2.2.5|?>>
    <associate|auto-28|<tuple|2.2.6|?>>
    <associate|auto-29|<tuple|2.2.7|?>>
    <associate|auto-3|<tuple|1.1|?>>
    <associate|auto-30|<tuple|2.2.8|?>>
    <associate|auto-31|<tuple|2.2.9|?>>
    <associate|auto-32|<tuple|2.2.10|?>>
    <associate|auto-33|<tuple|2.2.11|?>>
    <associate|auto-34|<tuple|2.3|?>>
    <associate|auto-35|<tuple|2.3.1|?>>
    <associate|auto-36|<tuple|2.3.2|?>>
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

      <with|par-left|<quote|1tab>|1.8<space|2spc>Behavior for incoming
      messages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|1.9<space|2spc>I'm Online Heartbeat
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Network
      Messages> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14><vspace|0.5fn>

      <with|par-left|<quote|1tab>|2.1<space|2spc>API Package
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|2tab>|2.1.1<space|2spc>BlockRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|2tab>|2.1.2<space|2spc>BlockResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|1tab>|2.2<space|2spc>Light Package
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|2tab>|2.2.1<space|2spc>Request
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|2tab>|2.2.2<space|2spc>Response
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|2tab>|2.2.3<space|2spc>RemoteCallRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|2tab>|2.2.4<space|2spc>RemoteCallResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|2tab>|2.2.5<space|2spc>RemoteReadRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <with|par-left|<quote|2tab>|2.2.6<space|2spc>RemoteReadResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|2tab>|2.2.7<space|2spc>RemoteReadChildRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|2tab>|2.2.8<space|2spc>RemoteHeaderRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|2tab>|2.2.9<space|2spc>RemoteHeaderResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>

      <with|par-left|<quote|2tab>|2.2.10<space|2spc>RemoteChangesRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|2tab>|2.2.11<space|2spc>RemoteChangesResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|1tab>|2.3<space|2spc>Finality Package
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <with|par-left|<quote|2tab>|2.3.1<space|2spc>FinalityProofRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|2tab>|2.3.2<space|2spc>FinalityProofResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32>>
    </associate>
  </collection>
</auxiliary>