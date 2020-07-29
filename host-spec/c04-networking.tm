<TeXmacs|1.99.12>

<project|host-spec.tm>

<style|book>

<\body>
  <chapter|Network Protocol<label|sect-network-interactions>><label|network-protocol>

  <\warning>
    Polkadot network protocol is work-in-progress. The API specification and
    usage may change in future.
  </warning>

  This chapter offers a high-level description of the network protocol based
  on <cite|parity_technologies_substrate_2019>. Polkadot network protocol
  relies on <em|libp2p>. Specifically, the following libp2p modules are being
  used in the Polkadot Networking protocol:

  <\itemize>
    <item><samp|mplex.>

    <item><samp|yamux>

    <item><samp|secio>

    <item><samp|noise>

    <item><samp|kad> (kademlia)

    <item><samp|identity>

    <item><samp|ping>
  </itemize>

  For more detailed specification of these modules and the Peer-to-Peer layer
  see libp2p specification document <cite|protocol_labs_libp2p_2019>.

  <section|Node Identities and Addresses>

  Similar to other decentralized networks, each Polkadot Host node possesses
  a network private key and a network public key representing an ED25519 key
  pair <cite|liusvaara_edwards-curve_2017>.

  <todo|SPEC: local node's keypair must be passed as part of the network
  configuration.>

  <\definition>
    <strong|Peer Identity>, formally noted by <math|P<rsub|id>> is derived
    from the node's public key as follows:

    <todo|SPEC: How to derive <math|P<rsub|id>>> \ and uniquely identifies a
    node on the network.
  </definition>

  Because the <math|P<rsub|id>> is derived from the node's public key,
  running two or more instances of Polkadot network using the same network
  key is contrary to the Polkadot protocol.

  All network communications between nodes on the network use encryption
  derived from both sides' keys.

  <todo|SPEC: p2p key derivation>

  <section|Discovery Mechanisms>

  \ In order for a Polkadot node to join a peer-to-peer network, it has to
  know a list of Polkadot nodes that already take part in the network. This
  process of building such a list is referred to as <em|Discovery>. Each
  element of this list is a pair consisting of the peer's node identities and
  their addresses.\ 

  <todo|SPEC: Node address>

  \ Polkadot discovery is done through the following mechanisms:

  <\itemize>
    <item><em|Bootstrap nodes>: These are hard-coded node identities and
    addresses passed alongside with the network configuration.

    <item><em|mDNS>, performing a UDP broadcast on the local network. Nodes
    that listen may respond with their identity as described in the mDNS
    section of <cite|protocol_labs_libp2p_2019>. (Note: mDNS can be disabled
    in the network configuration.)

    <item><em|Kademlia random walk>. Once connected to a peer node, a
    Polkadot node can perform a random Kademlia `FIND_NODE` requests for the
    nodes <todo|which nodes?> to respond by propagating their view of the
    network.
  </itemize>

  <section|Transport Protocol><label|sect_transport_protocol>

  A Polkadot node can establish a connection with nodes in its peer list. All
  the connections must always use encryption and multiplexing. While some
  nodes' addresses (eg. addresses using `/quic`) already imply the encryption
  and/or multiplexing to use, for others the \Pmultistream-select\Q protocol
  is used in order to negotiate an encryption layer and/or a multiplexing
  layer.

  The following transport protocol is supported by a Polkadot node:

  <\itemize>
    <item><em|TCP/IP> for addresses of the form `/ip4/1.2.3.4/tcp/5`. Once
    the TCP connection is open, an encryption and a multiplexing layers are
    negotiated on top.

    <item><em|WebSockets> for addresses of the form `/ip4/1.2.3.4/tcp/5/ws`.
    A TC/IP connection is open and the WebSockets protocol is negotiated on
    top. Communications then happen inside WebSockets data frames. Encryption
    and multiplexing are additionally negotiated again inside this channel.

    \ <item>DNS for addresses of the form `/dns4/example.com/tcp/5` or
    `/dns4/example.com/tcp/5/ws`. A node's address can contain a domain name.
  </itemize>

  <subsection|Encryption>

  \ The following encryption protocols from libp2p are supported by Polkadot
  protocol:

  <item><strong|Secio>: A TLS-1.2-like protocol but without certificates
  <cite|protocol_labs_libp2p_2019>. Support for secio will likely to be
  deprecated in the future.

  <item><strong|Noise>: Noise is a framework for crypto protocols based on
  the Diffie-Hellman key agreement <cite|perrin_noise_2018>. Support for
  noise is experimental and details may change in the future.

  <subsection|Multiplexing>\ 

  The following multiplexing protocols are supported:

  <\itemize>
    <item><strong|Mplex>: Support for mplex will be deprecated in the future.

    <item><strong|Yamux>.
  </itemize>

  <section|Substreams>

  Once a connection has been established between two nodes and is able to use
  multiplexing, substreams can be opened. When a substream is open, the
  <em|multistream-select> protocol is used to negotiate which protocol to use
  on that given substream.\ 

  <subsection|Periodic Ephemeral Substreams>

  A Polkadot Host node should open several substreams. In particular, it
  should periodically open ephemeral substreams in order to:

  <\itemize>
    <item>ping the remote peer and check whether the connection is still
    alive. Failure for the remote peer to reply leads to a disconnection.
    This uses the libp2p <em|ping> protocol specified in
    <cite|protocol_labs_libp2p_2019>.

    <item>ask information from the remote. This is the <em|identity> protocol
    specified in <cite|protocol_labs_libp2p_2019>.

    <item>send Kademlia random walk queries. Each Kademlia query is done in a
    new separate substreams. This uses the libp2p <em|Kademlia> protocol
    specified in <cite|protocol_labs_libp2p_2019>.
  </itemize>

  <subsection|Polkadot Communication Substream><label|sect_polkadot_communication_substream>

  For the purposes of communicating Polkadot messages, the dailer of the
  connection opens a unique substream. Optionally, the node can keep a unique
  substream alive for this purpose. The name of the protocol negotiated is
  based on the <em|protocol ID> passed as part of the network configuration.
  This protocol ID should be unique for each chain and prevents nodes from
  different chains to connect to each other.

  The structure of SCALE encoded messages sent over the unique Polkadot
  communication substream is described in Appendix
  <reference|sect-network-messages>.

  Once the substream is open, the first step is an exchange of a <em|status>
  message from both sides described in Section <reference|sect-msg-status>.

  Communications within this substream include:

  <\itemize>
    <item>Syncing. Blocks are announced and requested from other nodes.

    <item>Gossiping. Used by various subprotocols such as GRANDPA.

    <item>Polkadot Network Specialization: <todo|spec this protocol for
    polkadot>.
  </itemize>

  \;
  
  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?|c01-background.tm>>
    <associate|auto-2|<tuple|1.1|?|c01-background.tm>>
    <associate|auto-3|<tuple|1.2|?|c01-background.tm>>
    <associate|auto-4|<tuple|1.3|?|c01-background.tm>>
    <associate|auto-5|<tuple|1.3.1|?|c01-background.tm>>
    <associate|auto-6|<tuple|1.3.2|?|c01-background.tm>>
    <associate|auto-7|<tuple|1.4|?|c01-background.tm>>
    <associate|auto-8|<tuple|1.4.1|?|c01-background.tm>>
    <associate|auto-9|<tuple|1.4.2|?|c01-background.tm>>
    <associate|network-protocol|<tuple|1|?|c01-background.tm>>
    <associate|sect-network-interactions|<tuple|1|?|c01-background.tm>>
    <associate|sect_polkadot_communication_substream|<tuple|1.4.2|?|c01-background.tm>>
    <associate|sect_transport_protocol|<tuple|1.3|?|c01-background.tm>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      parity_technologies_substrate_2019

      protocol_labs_libp2p_2019

      liusvaara_edwards-curve_2017

      protocol_labs_libp2p_2019

      protocol_labs_libp2p_2019

      perrin_noise_2018

      protocol_labs_libp2p_2019

      protocol_labs_libp2p_2019

      protocol_labs_libp2p_2019
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Network
      Protocol> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      1.1<space|2spc>Node Identities and Addresses
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      1.2<space|2spc>Discovery Mechanisms
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      1.3<space|2spc>Transport Protocol <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>

      <with|par-left|<quote|1tab>|1.3.1<space|2spc>Encryption
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1tab>|1.3.2<space|2spc>Multiplexing
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      1.4<space|2spc>Substreams <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>

      <with|par-left|<quote|1tab>|1.4.1<space|2spc>Periodic Ephemeral
      Substreams <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|1.4.2<space|2spc>Polkadot Communication
      Substream <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>
    </associate>
  </collection>
</auxiliary>