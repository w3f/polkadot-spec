<TeXmacs|1.99.12>

<project|host-spec.tm>

<style|book>

<\body>
  <appendix|Network Messages><label|sect-network-messages>

  In this section, we will specify various types of messages which the
  Polkadot Host receives from the network. Furthermore, we also explain the
  appropriate responses to those messages.

  <\definition>
    A <strong|network message> is a byte array, <strong|<math|M>> of length
    <math|<around*|\<\|\|\>|M|\<\|\|\>>> such that:

    \;

    <\equation*>
      <tabular*|<tformat|<table|<row|<cell|M<rsub|1>>|<cell|Message Type
      Indicator>>|<row|<cell|M<rsub|2>\<ldots\>M<rsub|<around*|\<\|\|\>|M|\<\|\|\>>>>|<cell|Enc<rsub|SC><around*|(|MessageBody|)>>>>>>
    </equation*>

    \;
  </definition>

  The body of each message consists of different components based on its
  type. The different possible message types are listed below in Table
  <reference|tabl-message-types>. We describe the sub-components of each
  message type individually in Section <reference|sect-message-detail>.

  <big-table|<tabular*|<tformat|<cwith|2|-1|2|2|cell-halign|l>|<cwith|1|-1|1|-1|cell-tborder|0ln>|<cwith|1|-1|1|-1|cell-bborder|0ln>|<cwith|1|-1|1|-1|cell-lborder|1ln>|<cwith|1|-1|1|-1|cell-rborder|1ln>|<cwith|18|18|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-lborder|1ln>|<cwith|1|-1|3|3|cell-rborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-lborder|1ln>|<cwith|1|1|1|-1|cell-rborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<table|<row|<cell|<math|M<rsub|1>>>|<cell|Message
  Type>|<cell|Description>>|<row|<cell|0>|<cell|Status>|<cell|<reference|sect-msg-status>>>|<row|<cell|1>|<cell|Block
  Request>|<cell|<reference|sect-msg-block-request>>>|<row|<cell|2>|<cell|Block
  Response>|<cell|<reference|sect-msg-block-response>>>|<row|<cell|3>|<cell|Block
  Announce>|<cell|<reference|sect-msg-block-announce>>>|<row|<cell|4>|<cell|Transactions>|<reference|sect-msg-transactions>>|<row|<cell|5>|<cell|Consensus>|<cell|<reference|sect-msg-consensus>>>|<row|<cell|6>|<cell|Remote
  Call Request>|<cell|>>|<row|<cell|7>|<cell|Remote Call
  Response>|<cell|>>|<row|<cell|8>|<cell|Remote Read
  Request>|<cell|>>|<row|<cell|9>|<cell|Remote Read
  Response>|<cell|>>|<row|<cell|10>|<cell|Remote Header
  Request>|<cell|>>|<row|<cell|11>|<cell|Remote Header
  Response>|<cell|>>|<row|<cell|12>|<cell|Remote Changes
  Request>|<cell|>>|<row|<cell|13>|<cell|Remote Changes
  Response>|<cell|>>|<row|<cell|14>|<cell|FinalityProofRequest>|<cell|>>|<row|<cell|15>|<cell|FinalityProofResponse>|<cell|>>|<row|<cell|255>|<cell|Chain
  Specific>|<cell|>>>>>|<label|tabl-message-types>List of possible network
  message types.>

  <section|Detailed Message Structure><label|sect-message-detail>

  This section disucsses the detailed structure of each network message.

  <subsection|Status Message><label|sect-msg-status>

  A <em|Status> Message represented by <math|M<rsub|S>> is sent after a
  connection with a neighbouring node is established and has the following
  structure:

  <\equation*>
    M<rsup|><rsub|S>\<assign\>Enc<rsub|SC><around*|(|v,r,N<rsub|B>,Hash<rsub|B>,Hash<rsub|G>,C<rsub|S>|)>
  </equation*>

  Where:

  <\center>
    <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|<math|v>:>|<cell|Protocol
    version>|<cell|32 bit integer>>|<row|<cell|<math|v<rsub|min>:>>|<cell|Minimum
    supported version>|<cell|32 bit integer>>|<row|<cell|<math|r>:>|<cell|Roles>|<cell|1
    byte>>|<row|<cell|<math|N<rsub|B>>:>|<cell|Best Block Number>|<cell|64
    bit integer>>|<row|<cell|<math|Hash<rsub|B>>>|<cell|Best block
    Hash>|<cell|<math|\<bbb-B\><rsub|32>>>>|<row|<cell|<math|Hash<rsub|G>>>|<cell|Genesis
    Hash>|<cell|<math|\<bbb-B\><rsub|32>>>>|<row|<cell|<math|C<rsub|S>>>|<cell|Chain
    Status>|<cell|Byte array >>>>>
  </center>

  \;

  In which, Role is a bitmap value whose bits represent different roles for
  the sender node as specified in Table <reference|tabl-node-role>:

  \;

  <\with|par-mode|center>
    <\small-table>
      \;

      <\center>
        <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|1|-1|cell-valign|c>|<cwith|1|-1|1|-1|cell-tborder|0ln>|<cwith|1|-1|1|-1|cell-bborder|0ln>|<cwith|1|-1|1|-1|cell-lborder|1ln>|<cwith|1|-1|1|-1|cell-rborder|1ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-lborder|1ln>|<cwith|1|-1|3|3|cell-rborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|1ln>|<cwith|1|1|3|3|cell-rborder|1ln>|<table|<row|<cell|Value>|<cell|Binary
        representation>|<cell|Role>>|<row|<cell|<math|0>>|<cell|00000000>|<cell|No
        network>>|<row|<cell|1>|<cell|00000001>|<cell|Full node, does not
        participate in consensus>>|<row|<cell|2>|<cell|00000010>|<cell|Light
        client node>>|<row|<cell|4>|<cell|00000100>|<cell|Act as an authority
        >>>>>
      </center>

      \;
    </small-table|<label|tabl-node-role>Node role representation in the
    status message.>
  </with>

  <subsection|Block Request Message><label|sect-msg-block-request>

  A Block request message, represented by <math|M<rsub|BR>>, is sent to
  request block data for a range of blocks from a peer and has the following
  structure:

  <\equation*>
    M<rsup|><rsub|BR>\<assign\>Enc<rsub|SC><around*|(|id,A<rsub|B>,S<rsub|B>,Hash<rsub|E>,d,Max|)>
  </equation*>

  where:

  <\center>
    <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|<math|id>:>|<cell|Unique
    request id>|<cell|32 bit integer>>|<row|<cell|<math|A<rsub|B>>:>|<cell|Requested
    data>|<cell|1 byte>>|<row|<cell|<math|S<rsub|B>>:>|<cell|Starting
    Block>|<cell|Varying {<math|\<bbb-B\><rsub|32>,64bit
    integer>}>>|<row|<cell|<math|Hash<rsub|E>>>|<cell|End block
    Hash>|<cell|<math|\<bbb-B\><rsub|32>> optional
    type>>|<row|<cell|<math|d>>|<cell|Block sequence direction>|<cell|1
    byte>>|<row|<cell|<math|Max>>|<cell|Maximum number of blocks to
    return>|<cell|32 bit integer optional type>>>>>
  </center>

  \;

  \;

  in which\ 

  <\itemize-minus>
    <item><math|A<rsub|B>>, the requested data, is a bitmap value, whose bits
    represent the part of the block data requested, as explained in Table
    <reference|tabl-block-attributes>:
  </itemize-minus>

  <\with|par-mode|center>
    <\small-table>
      \;

      <\center>
        <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|1|-1|cell-valign|c>|<cwith|1|-1|1|-1|cell-tborder|0ln>|<cwith|1|-1|1|-1|cell-bborder|0ln>|<cwith|1|-1|1|-1|cell-lborder|1ln>|<cwith|1|-1|1|-1|cell-rborder|1ln>|<cwith|6|6|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-lborder|1ln>|<cwith|1|-1|3|3|cell-rborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|1ln>|<cwith|1|1|3|3|cell-rborder|1ln>|<table|<row|<cell|Value>|<cell|Binary
        representation>|<cell|Requested Attribute>>|<row|<cell|<math|1>>|<cell|00000001>|<cell|Block
        header>>|<row|<cell|2>|<cell|00000010>|<cell|Block
        Body>>|<row|<cell|4>|<cell|00000100>|<cell|Receipt>>|<row|<cell|8>|<cell|00001000>|<cell|Message
        queue>>|<row|<cell|16>|<cell|00010000>|<cell|Justification >>>>>
      </center>

      \;
    </small-table|<label|tabl-block-attributes>Bit values for block attribute
    <math|A<rsub|B>>, to indicate the requested parts of the data.>
  </with>

  <\itemize-minus>
    <item><math|S<rsub|B>> is SCALE encoded varying data type (see Definition
    <reference|defn-scale-variable-type>) of either <math|\<bbb-B\><rsub|32>>
    representing the block hash, <math|H<rsub|B>>, or <math|64bit> integer
    representing the block number of the starting block of the requested
    range of blocks.

    <item><math|Hash<rsub|E>> is optionally the block hash of the last block
    in the range.

    <item><math|d> is a flag; it defines the direction on the block chain
    where the block range should be considered (starting with the starting
    block), as follows

    <\equation*>
      d=<around*|{|<tabular*|<tformat|<table|<row|<cell|0>|<cell|child to
      parent direction>>|<row|<cell|1>|<cell|parent to child
      direction>>>>>|\<nobracket\>>
    </equation*>
  </itemize-minus>

  Optional data type is defined in Definition
  <reference|defn-varrying-data-type>.

  <subsection|Block Response Message><label|sect-msg-block-response>

  A <em|block response message> represented by <math|M<rsub|BS>> is sent in a
  response to a requested block message (see Section
  <reference|sect-msg-block-request>). It has the following structure:

  <\equation*>
    M<rsup|><rsub|BS>\<assign\>Enc<rsub|SC><around*|(|id,D|)>
  </equation*>

  where:

  <\center>
    <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|<math|id>:>|<cell|Unique
    id of the requested response was made for>|<cell|32 bit
    integer>>|<row|<cell|<math|D>:>|<cell|Block data for the requested
    sequence of Block>|<cell|Array of block data>>>>>
  </center>

  \;

  \;

  In which block data is defined in Definition <reference|defn-block-data>.

  <\definition>
    <label|defn-block-data><strong|Block Data> is defined as the follownig
    tuple:<todo|Block Data definition should go to block format section>
  </definition>

  <\equation*>
    <around*|(|H<rsub|B>,Header<rsub|B>,Body,Receipt,MessageQueue,Justification|)>
  </equation*>

  Whose elements, with the exception of <math|H<rsub|B>>, are all of the
  following <em|optional type> (see Definition
  <reference|defn-varrying-data-type>) and are defined as follows:

  <\center>
    <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|<math|H<rsub|B>>:>|<cell|Block
    header hash>|<cell|<math|\<bbb-B\><rsub|32>>>>|<row|<cell|<math|Header<rsub|B>>:>|<cell|Block
    header>|<cell|5-tuple (Definition <reference|defn-block-header>)>>|<row|<cell|Body>|<cell|Array
    of extrinsics>|<cell|Array of Byte arrays (Section
    <reference|sect-extrinsics>)>>|<row|<cell|Receipt>|<cell|Block
    Receipt>|<cell|Byte array>>|<row|<cell|Message Queue>|<cell|Block message
    queue>|<cell|Byte array>>|<row|<cell|Justification>|<cell|Block
    Justification>|<cell|Byte array>>>>>
  </center>

  \;

  <subsection|Block Announce Message><label|sect-msg-block-announce>

  A <em|block announce message> represented by <math|M<rsub|BA>> is sent when
  a node becomes aware of a new complete block on the network and has the
  following structure:

  <\equation*>
    M<rsub|BA>\<assign\>Enc<rsub|SC><around*|(|Header<rsub|B>|)>
  </equation*>

  Wh<verbatim|>ere:

  <\center>
    <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|<math|Header<rsub|B>>:>|<cell|Header
    of new block B>|<cell|5-tuple header (Definition
    <reference|defn-block-header>)>>>>>
  </center>

  <subsection|Transactions><label|sect-msg-transactions>

  \ \ \ \ The transactions Message is represented by <math|M<rsub|T>> and is
  defined as follows:

  <\equation*>
    M<rsub|T>\<assign\>Enc<rsub|SC><around*|(|C<rsub|1>,\<ldots\>,C<rsub|n>|)>
  </equation*>

  in which:

  <\equation*>
    C<rsub|i>\<assign\>Enc<rsub|SC><around*|(|E<rsub|i>|)>
  </equation*>

  Where each <math|E<rsub|i>> is a byte array and represents a sepearate
  extrinsic. The Polkadot Host is indifferent about the content of an
  extrinsic and treats it as a blob of data.

  <subsection|Consensus Message><label|sect-msg-consensus>

  A <em|consensus message> represented by <math|M<rsub|C>> is sent to
  communicate messages related to consensus process:

  <\equation*>
    M<rsub|C>\<assign\>Enc<rsub|SC><around*|(|E<rsub|id>,D|)>
  </equation*>

  Wh<verbatim|>ere:

  <\center>
    <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|<math|E<rsub|id>>:>|<cell|The
    consensus engine unique identifier>|<cell|<math|\<bbb-B\><rsub|4>>>>|<row|<cell|<math|D>>|<cell|Consensus
    message payload>|<cell|<math|\<bbb-B\>>>>>>>
  </center>

  \;

  in which

  <\equation*>
    E<rsub|id>\<assign\><around*|{|<tabular*|<tformat|<table|<row|<cell|<rprime|''>BABE<rprime|''>>|<cell|>|<cell|For
    messages related to BABE protocol refered to as
    E<rsub|id><around*|(|BABE|)>>>|<row|<cell|<rprime|''>FRNK<rprime|''>>|<cell|>|<cell|For
    messages related to GRANDPA protocol referred to as
    E<rsub|id><around*|(|FRNK|)>>>>>>|\<nobracket\>>
  </equation*>

  \;

  The network agent should hand over <math|D> to approperiate consensus
  engine which identified by <math|E<rsub|id>>.

  <subsection|Neighbor Packet><label|sect-msg-neighbor-packet>

  <todo|Place holder for speccing Neighbor Packet message>

\;
  
  <\with|par-mode|right>
    <qed>
  </with>

  \;

</body>

<\initial>
  <\collection>
    <associate|page-first|?>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|A|?>>
    <associate|auto-10|<tuple|A.1.5|?>>
    <associate|auto-11|<tuple|A.1.6|?>>
    <associate|auto-12|<tuple|A.1.7|?>>
    <associate|auto-2|<tuple|A.1|?>>
    <associate|auto-3|<tuple|A.1|?>>
    <associate|auto-4|<tuple|A.1.1|?>>
    <associate|auto-5|<tuple|A.2|?>>
    <associate|auto-6|<tuple|A.1.2|?>>
    <associate|auto-7|<tuple|A.3|?>>
    <associate|auto-8|<tuple|A.1.3|?>>
    <associate|auto-9|<tuple|A.1.4|?>>
    <associate|defn-block-data|<tuple|A.2|?>>
    <associate|sect-message-detail|<tuple|A.1|?>>
    <associate|sect-msg-block-announce|<tuple|A.1.4|?>>
    <associate|sect-msg-block-request|<tuple|A.1.2|?>>
    <associate|sect-msg-block-response|<tuple|A.1.3|?>>
    <associate|sect-msg-consensus|<tuple|A.1.6|?>>
    <associate|sect-msg-neighbor-packet|<tuple|A.1.7|?>>
    <associate|sect-msg-status|<tuple|A.1.1|?>>
    <associate|sect-msg-transactions|<tuple|A.1.5|?>>
    <associate|sect-network-messages|<tuple|A|?>>
    <associate|tabl-block-attributes|<tuple|A.3|?>>
    <associate|tabl-message-types|<tuple|A.1|?>>
    <associate|tabl-node-role|<tuple|A.2|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal|<surround|<hidden-binding|<tuple>|A.1>||List of possible
      network message types.>|<pageref|auto-2>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|A.2>||Node role
      representation in the status message.>|<pageref|auto-5>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|A.3>||Bit values for
      block attribute <with|mode|<quote|math>|A<rsub|B>>, to indicate the
      requested parts of the data.>|<pageref|auto-7>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Network Messages> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      A.1<space|2spc>Detailed Message Structure
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      <with|par-left|<quote|1tab>|A.1.1<space|2spc>Status Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|A.1.2<space|2spc>Block Request Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1tab>|A.1.3<space|2spc>Block Response Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|A.1.4<space|2spc>Block Announce Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|A.1.5<space|2spc>Transactions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|1tab>|A.1.6<space|2spc>Consensus Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>
    </associate>
  </collection>
</auxiliary>