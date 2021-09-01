<TeXmacs|1.99.16>

<project|host-spec.tm>

<style|<tuple|tmbook|algorithmacs-style>>

<\body>
  <assign|blobB|<macro|<math|<wide|B|\<bar\>>>>><assign|PoVB|<macro|<math|PoV<rsub|B>>>><assign|paraValidSet|<macro|<math|\<cal-V\><rsub|\<rho\>>>>>

  <chapter|Availability & Validity>

  <section|Introduction>

  Validators are responsible for guaranteeing the validity and availability
  of PoV blocks. There are two phases of validation that takes place in the
  AnV protocol. The primary validation check is carried out by collators who
  are assigned to the parachain which has produced the PoV block as described
  in Section <reference|sect-primary-validation>. Once collators have
  validated a parachain's PoV block successfully, they have to announce that
  according to the procedure described in Section
  <reference|sect-primary-validaty-announcement> where they generate a
  statement that includes the parachain header with the new state root and
  the XCMP message root. This candidate receipt and attestations, which carry
  signatures from other collators, is put on the relay chain. As soon as the
  proposal of a PoV block is on-chain, the relay chain validators break the
  PoV block into erasure-coded chunks as described in Section
  <reference|defn-erasure-coded-chunks> and distribute them among all
  validators. See Section <reference|sect-distribute-chunks> for details on
  how this distribution takes place.

  \;

  Once the relay chain validators have received erasure-coded chunks for
  several PoV blocks for the current relay chain block (that might have been
  proposed a couple of blocks earlier on the relay chain), they announce that
  they have received the erasure coded chunks on the relay chain by voting on
  the received chunks, see Section <reference|sect-voting-on-availability>
  for more details As soon as <math|\<gtr\>2/3> of validators have made this
  announcement for any parachain block, the relay chain validators <em|act
  on> the parachain block. Acting on parachain blocks means the relay chain
  validators update the relay chain state based on the candidate receipt and
  considered the parachain block to have happened on this relay chain fork.

  \;

  After a certain time, if the relay chain validators did not collect enough
  signatures approving the availability of the parachain data associated with
  a certain candidate receipt, the validators then decide that this parachain
  block is unavailable and allow alternative blocks to be built on its parent
  parachain block, see Section <reference|sect-processing-availability>. The
  secondary check described in Section <reference|sect-approval-checking>, is
  done by one or more randomly assigned validators to make sure colluding
  collators may not get away with validating a PoV block that is invalid and
  not keeping it available to avoid the possibility of being punished for the
  attack.

  \;

  During any of the phases, if any validator announces that a parachain block
  is invalid then all validators obtain the parachain block and check its
  validity, see Section <reference|sect-escalation> for more details. All
  validity and invalidity attestations go onto the relay chain, see Section
  <reference|sect-publishing-attestations> for details. If a parachain block
  has been checked at least by certain number of validators, the rest of the
  validators continue with voting on that relay chain block in the GRANDPA
  protocol. Note that the block might be challenged later.

  <section|Preliminaries>

  <\definition>
    <label|defn-parablock>A <strong|parachain block>, <math|B<rsub|p>>, is a
    datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|B<rsub|b>>|<cell|=>|<cell|<around*|(|H<around*|(|B|)>,E,H<rsub|r>|)>>>|<row|<cell|E>|<cell|=>|<cell|<around*|(|e<rsub|0>,\<ldots\>e<rsub|n>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|H<around*|(|B|)>> is the header of the block as described
      in Definition <reference|defn-block-header>.

      <item><math|E> is an array of zero or more extrinsics,
      <math|e<rsub|n>>, which are SCALE encoded byte arrays and its structure
      is opaque to the Polkadot Host.

      <item><math|H<rsub|r>> is the Merkle root of the parachain state at
      this block.
    </itemize-dot>
  </definition>

  <\definition>
    In the remainder of this chapter we assume that <math|<text|\<rho\>>> is
    a Polkadot Parachain and <math|B> is a block which has been produced by
    <math|\<rho\>> and is supposed to be approved to be <math|\<rho\>>'s next
    block. By <math|R<rsub|\<rho\>>> we refer to the
    <with|font-series|bold|validation code> of parachain <math|\<rho\>> as a
    WASM blob, which is responsible for validating the corresponding
    Parachain's blocks.
  </definition>

  <\definition>
    <label|defn-witness-proof>The <with|font-series|bold|witness proof> of
    block <math|B>, denoted by <with|font-series|bold|mode|math|\<pi\><rsub|B>>,
    is the set of all the external data which has gathered while the
    <math|\<rho\>> runtime executes block <math|B>. The data suffices to
    re-execute <math|R<rsub|\<rho\>>> against <math|B> and achieve the final
    state indicated in the <math|H<around|(|B|)>>.
  </definition>

  This witness proof consists of light client proofs of state data that are
  generally Merkle proofs for the parachain state trie. This is required
  because validators do not have access to the parachain state, but only have
  the state root of it.

  <\definition>
    <label|defn-pov-block>Accordingly we define the
    <with|font-series|bold|proof of validity block> or
    <with|font-series|bold|PoV> block in short to be the tuple:

    <\equation*>
      <around|(|B,\<pi\><rsub|B>|)>
    </equation*>

    A PoV block is an extracted Merkle subtree, attached to the block.
    <todo|@fabio: clarif this>
  </definition>

  <subsection|Extra Validation Data>

  Validators must submit extra validation data to Runtime
  <math|R<rsub|\<rho\>>> in order to build candidates, to fully validate
  those and to vote on their availability. Depending on the context,
  different types of information must be used.

  \;

  Parachain validators get this extra validation data from the current relay
  chain state. Note that a PoV block can be paired with different extra
  validation data depending on when and which relay chain fork it is included
  in. Future validators would need this extra validation data because since
  the candidate receipt as defined in Definition
  <reference|defn-candidate-receipt> was included on the relay chain the
  needed relay chain state may have changed.

  <\definition>
    <label|defn-para-id>The <strong|Parachain Id> is an unsigned 32-bit
    integer which serves as an identifier of a parachain. <todo|How are those
    indexes assigned?>
  </definition>

  <\definition>
    The <strong|parachain inherent data>, <math|I<rsub|p>>, is passed by the
    collator to the parachain runtime <todo|when is it passed?>. It's a
    datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|I<rsub|p>>|<cell|=>|<cell|<around*|(|D<rsub|pv>,H<rsub|r>,M<rsub|d>,M<rsub|h>|)>>>|<row|<cell|M<rsub|d>>|<cell|=>|<cell|<around*|(|M<rsub|0>,\<ldots\>M<rsub|n>|)>>>|<row|<cell|M<rsub|h>>|<cell|=>|<cell|<around*|{|<rsub|><around*|(|P<rsub|id>,<around*|(|M<rsub|0>,\<ldots\>M<rsub|n>|)>|)>|}>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|D<rsub|pv>> is the persisted validation data as defined in
      Definition <reference|defn-persisted-validation-data>.

      <item><math|H<rsub|r>> the relay chain storage proof of a predefined
      set of keys from the relay chain as defined in Definition
      <reference|defn-relay-chain-proof>.

      <item><math|M<rsub|d>> are inbound downward messages as defined in
      Definition <reference|defn-inbound-messages> in the order they were
      sent.

      <item><math|M<rsub|h>> are the horizontal messages grouped by the
      parachain Id (<reference|defn-para-id>) inside a map <todo|@fabio>. The
      messages in the inner sequence must be in the order they were sent.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-inbound-downward-msg>An <strong|inbound downward message> is
    a message that is sent from the Polkadot relay chain down to a parachain.
    Both message types share the same datastructure of the following type:

    <\eqnarray*>
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<around*|(|H<rsub|i>,<around*|(|b<rsub|0>,\<ldots\>b<rsub|n>|)>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|H<rsub|i>> is the relay chain block number at which the
      message was put into the downward queue <todo|clarify>.

      <item><math|<around*|(|b<rsub|0>,\<ldots\>b<rsub|n>|)>> is the byte
      array containing the message itself.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-inbound-hrmp-msg>An <strong|inbound HRMP message> is a
    message that is sent from a remote parachain to the local parachain, from
    the perspective of the recipient. The message, <math|M>, is a
    datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<around*|(|H<rsub|i>,<around*|(|b<rsub|0>,\<ldots\>b<rsub|n>|)>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|H<rsub|i>> is the relay chain block number at which the
      message was sent. Specifically, at which the candidate that sent this
      message was enacted.

      <item><math|<around*|(|b<rsub|0>,\<ldots\>b<rsub|n>|)>> is the byte
      array containing the message itself.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-outbound-hrmp-msg>An <strong|outbound HRMP message> is a
    message sent to a remote parachain, from the perspective of a sender. The
    message, <math|M>, is a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<around*|(|P<rsub|id>,<around*|(|b<rsub|0>,\<ldots\>b<rsub|n>|)>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|P<rsub|id>> is the parachain Id as defined in Definition
      <reference|defn-para-id> this message should be delivered to.

      <item><math|<around*|(|b<rsub|0>,\<ldots\>b<rsub|n>|)>> is the byte
      array containing the message itself.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-upgrade-indicator><math|R<rsup|up><rsub|\<rho\>>> is an
    varying data type (Definition <reference|defn-scale-codec>) which implies
    whether the parachain is allowed to upgrade its validation code. \ 

    <\equation*>
      R<rsup|up><rsub|\<rho\>>\<assign\>Option<around|(|H<rsub|i><around|(|B<rsup|relay><rsub|chain>|)>+n|)>
    </equation*>

    <todo|@fabio: adjust formula?>

    If this is <math|Some>, it contains the number of the minimum relay chain
    height at which the upgrade will be applied, assuming an upgrade is
    currently signaled <todo|@fabio: where is this signaled?>. A parachain
    should enact its side of the upgrade at the end of the first parachain
    block executing in the context of a relay-chain block with at least this
    height. This may be equal to the current perceived relay-chain block
    height, in which case the code upgrade should be applied at the end of
    the signaling block.
  </definition>

  <\definition>
    <label|defn-persisted-validation-data>The <strong|persisted validation
    data> provides information about how to create the inputs for the
    validation of a candidate by calling the Runtime. This information is
    derived from the parachain state and will vary from parachain to
    parachain, although some of the fields may be the same for every
    parachain. This validation data acts as a way to authorize the additional
    data (such as messages) the collator needs to pass to the validation
    function.

    \;

    The persisted validation data, <math|D<rsub|pv>>, is a datastructure of
    the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|D<rsub|pv>>|<cell|=>|<cell|<around*|(|P<rsub|h>,H<rsub|i>,H<rsub|r>,m<rsub|b>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|P<rsub|h>> is the parent head data as defined in Definition
      <reference|defn-para-head-data>.

      <item><math|H<rsub|i>> is the relay chain block number this is in the
      context of.

      <item><math|H<rsub|r>> is the relay chain storage root this is in the
      context of.

      <item><math|m<rsub|b>> is the maximum legal size of the PoV block, in
      bytes.
    </itemize-dot>

    \;
  </definition>

  <\definition>
    <label|defn-relay-chain-proof>The <strong|relay chain proof> contains
    witness data for the host configuration, relay queue sizes, list of
    inbound/outbound HRMP channels and the metadata for the HRMP channels.
    Specifically, the proof is the merkle root of the following information.

    <\itemize-dot>
      <item>The merkle proof of the current Host configuration. The
      configuration is fetched from storage by calling the following key:

      <verbatim|06de3d8a54d27e44a9d5ce189618f22db4b49d95320d9021994c850f25b8e385>

      <item>The MQC head <todo|spec MQC> for the downward message queue of
      the given parachain. This is fetched from storage by calling the
      following key:

      <\equation*>
        <around*|(|p,h<around*|(|P<rsub|id>|)>,P<rsub|id>|)>
      </equation*>

      where

      <\itemize-dot>
        <item><math|p> is the following prefix:

        \ <verbatim|63f78c98723ddc9073523ef3beefda0c4d7fefc408aac59dbfe80a72ac8e3ce5>

        <item><math|h<around*|(|P<rsub|id>|)>> is the 64-bit <verbatim|twox>
        hash of <math|P<rsub|id>>.

        <item><math|P<rsub|id>> is the parachain Id as defined in Definition
        <reference|defn-para-id>.
      </itemize-dot>

      \ <item>The merklel proof of the upward message queue for the given
      parachain Id. The queue is fetched from storage by looking up the
      following key:

      <\equation*>
        <around*|(|p,h<around*|(|P<rsub|id>|)>P<rsub|id>|)>
      </equation*>

      where

      <\itemize-dot>
        <item><math|p> is the following prefix:

        \ <verbatim|f5207f03cfdce586301014700e2c2593fad157e461d71fd4c1f936839a5f1f3e>

        <item><math|h<around*|(|P<rsub|id>|)>> is the 64-bit <verbatim|twox>
        hash of <math|P<rsub|id>>.

        <item><math|P<rsub|id>> is the parachain Id as defined in Definition
        <reference|defn-para-id>.
      </itemize-dot>

      <item>The merkle proof of inbound channels of the parachain Id. The
      channels are fetched from storage by looking up the following key:

      <\equation*>
        <around*|(|p,h<around*|(|P<rsub|id>|)>P<rsub|id>|)>
      </equation*>

      where

      <\itemize-dot>
        <item><math|p> is the following prefix:

        \ <verbatim|6a0da05ca59913bc38a8630590f2627c1d3719f5b0b12c7105c073c507445948>

        <item><math|h<around*|(|P<rsub|id>|)>> is the 64-bit <verbatim|twox>
        hash of <math|P<rsub|id>>.

        <item><math|P<rsub|id>> is the parachain Id as defined in Definition
        <reference|defn-para-id>.
      </itemize-dot>

      <item>The merkle proof of outbound channels of the parachain Id. The
      channels are fetched from storage by looking up the following key:

      <\equation*>
        <around*|(|p,h<around*|(|P<rsub|id>|)>P<rsub|id>|)>
      </equation*>

      where

      <\itemize-dot>
        <item><math|p> is the following prefix:

        \ <verbatim|6a0da05ca59913bc38a8630590f2627cf12b746dcf32e843354583c9702cc020>

        <item><math|h<around*|(|P<rsub|id>|)>> is the 64-bit <verbatim|twox>
        hash of <math|P<rsub|id>>.

        <item><math|P<rsub|id>> is the parachain Id as defined in Definition
        <reference|defn-para-id>.
      </itemize-dot>

      <item>The merkle proof of the inbound HRMP channels of the parachain
      Id. The channels are fetched from storage by looking up the following
      key:

      <\equation*>
        <around*|(|p,h<around*|(|C<rsub|id>|)>C<rsub|id>|)>
      </equation*>

      where

      <\itemize-dot>
        <item><math|p> is the following prefix:

        \ <verbatim|6a0da05ca59913bc38a8630590f2627cb6604cff828a6e3f579ca6c59ace013d>

        <item><math|h<around*|(|C<rsub|id>|)>> is the 64-bit <verbatim|twox>
        hash of <math|C<rsub|id>>. Note that the <strong|recipient> must be
        the corresponding parachain Id.

        <item><math|C<rsub|id>> is the parachain Id as defined in Definition
        <todo|todo>. Note that the <strong|recipient> must be the
        corresponding parachain Id.
      </itemize-dot>

      <item>The merkle proof of the outbound HRMP channels of the parachain
      Id. The channeles are fetched from storage by looking up the following
      key:

      <\equation*>
        <around*|(|p,h<around*|(|C<rsub|id>|)>C<rsub|id>|)>
      </equation*>

      where

      <\itemize-dot>
        <item><math|p> is the following prefix:

        \ <verbatim|6a0da05ca59913bc38a8630590f2627cb6604cff828a6e3f579ca6c59ace013d>

        <item><math|h<around*|(|C<rsub|id>|)>> is the 64-bit <verbatim|twox>
        hash of <math|C<rsub|id>>. Note that the <strong|sender> must be the
        corresponding parachain Id.

        <item><math|C<rsub|id>> is the parachain Id as defined in Definition
        <todo|todo>. Note that the <strong|sender> must be the corresponding
        parachain Id.
      </itemize-dot>

      \;
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-abridged-hrmp-channel><todo|@fabio: still relevant?>The
    <strong|abridged HRMP channel> datastructure contains metadata about a
    specific HRMP channel. The datastructure consists of the following
    format:

    <\equation*>
      <around*|(|M<rsub|cp>,M<rsub|ts>,M<rsub|ms>,M<rsub|ct>,T<rsub|s>,M<rsub|h>|)>
    </equation*>

    where

    <\itemize-dot>
      <item><math|M<rsub|cp>> is the maximum number of messages that can be
      pending int he channel at once.

      <item><math|M<rsub|ts>> is the maximum total size in bytes of the
      messages that can be pending in the channel at once.

      <item><math|M<rsub|ms>> is the maximum message size that could be put
      into the channel.

      <item><math|M<rsub|ct>> is the current number of messages pending in
      the channel. It must be less or equal to <math|M<rsub|cp>>.

      <item><math|T<rsub|s>> is the total size in bytes of all message
      payloads in the channel. It must be less or equal to <math|M<rsub|ts>>.

      <item><math|M<rsub|h>> is the head of the MQC as defined in Definition
      <todo|@fabio>.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-extra-validation-data><todo|@fabio: still relevant?>The
    <with|font-series|bold|validation parameters>, <math|v<rsup|VP><rsub|B>>,
    is an extra input to the validation function, i.e. additional data from
    the relay chain state that is needed. It's a tuple of the following
    format:

    <\equation*>
      vp<rsub|B>\<assign\><around|(|B<rsub|p>,h<rsub|p>,v<rsup|GVS><rsub|B>,R<rsup|up><rsub|\<rho\>>|)>
    </equation*>

    where each value represents:

    <\itemize>
      <item><math|B<rsub|p>>: the parachain block itself.

      <item><math|h<rsub|p>>: the parent block header as defined in
      Definition <reference|defn-block-header>.

      <item><math|v<rsub|p>>: the global validation parameters as defined in
      Definition <reference|defn-global-validation-parameters>.

      <item><math|R<rsup|up><rsub|\<rho\>>>: implies whether the parachain is
      allowed to upgrade its validation code (Definition
      <reference|defn-upgrade-indicator>).
    </itemize>
  </definition>

  <\definition>
    <label|defn-global-validation-parameters><todo|@fabio: still relevant?>
    The <with|font-series|bold|global validation parameters>,
    <math|v<rsup|GVP><rsub|B>>, defines global data that apply to all
    candidates in a block.

    <\equation*>
      v<rsup|GVS><rsub|B>\<assign\><around|(|Max<rsup|R><rsub|size>,Max<rsup|head><rsub|size>,H<rsub|i><around|(|B<rsup|relay><rsub|chain>|)>|)>
    </equation*>

    where each value represents:

    <\itemize>
      <item><math|Max<rsup|R><rsub|size>>: the maximum amount of bytes of the
      parachain Wasm code permitted.

      <item><math|Max<rsup|head><rsub|size>>: the maximum amount of bytes of
      the head data (Definition <reference|defn-head-data>) permitted.

      <item><math|H<rsub|i><around|(|B<rsup|relay><rsub|chain>|)>>: the relay
      chain block number this is in the context of.
    </itemize>
  </definition>

  <\definition>
    <label|defn-local-validation-parameters><todo|@fabio: still relevant?>
    The <with|font-series|bold|local validation parameters>,
    <math|v<rsup|LVP><rsub|B>>, defines parachain-specific data required to
    fully validate a block. It is a tuple of the following format:

    <\equation*>
      v<rsup|LVP><rsub|B>\<assign\><around|(|head<around|(|B<rsub|p>|)>,UINT128,Blake2b<around|(|R<rsub|\<rho\>>|)>,R<rsup|up><rsub|\<rho\>>|)>
    </equation*>

    where each value represents:

    <\itemize>
      <item><math|head<around|(|B<rsub|p>|)>>: the parent head data
      (Definition <reference|defn-head-data>) of block <math|B>.

      <item><math|UINT128>: the balance of the parachain at the moment of
      validation.

      <item><math|Blake2b<around|(|R<rsub|\<rho\>>|)>>: the Blake2b hash of
      the validation code used to execute the candidate.

      <item><math|R<rsup|up><rsub|\<rho\>>>: implies whether the parachain is
      allowed to upgrade its validation code (Definition
      <reference|defn-upgrade-indicator>).
    </itemize>
  </definition>

  <\definition>
    <todo|@fabio: still relevant>The <with|font-series|bold|validation
    result>, <math|r<rsub|B>>, is returned by the validation code
    <math|R<rsub|\<rho\>>> if the provided candidate is is valid. It is a
    tuple of the following format:

    <alignat*|2|<tformat|<table|<row|<cell|r<rsub|B>>|<cell|\<assign\><around|(|head<around|(|B|)>,Option<around|(|P<rsup|B><rsub|\<rho\>>|)>,<around|(|Msg<rsub|0>,...,Msg<rsub|n>|)>,UINT32|)>>>|<row|<cell|Msg>|<cell|\<assign\><around|(|\<bbb-O\>,Enc<rsub|SC><around|(|b<rsub|0>,..
    b<rsub|n>|)>|)>>>>>>

    where each value represents:

    <\itemize>
      <item><math|head<around|(|B|)>>: the new head data (Definition
      <reference|defn-head-data>) of block <math|B>.

      <item><math|Option<around|(|P<rsup|B><rsub|\<rho\>>|)>>: a varying data
      (Definition <reference|defn-scale-codec>) containing an update to the
      validation code that should be scheduled in the relay chain.

      <item><math|Msg>: parachain \Pupward messages\Q to the relay chain.
      <math|\<bbb-O\>> identifies the origin of the messages and is a varying
      data type (Definition <reference|defn-scale-codec>) and can be one of
      the following values:

      <\equation*>
        \<bbb-O\>=<choice|<tformat|<table|<row|<cell|0,>|<cell|<text|Signed>>>|<row|<cell|1,>|<cell|<text|Parachain>>>|<row|<cell|2,>|<cell|<text|Root>>>>>>
      </equation*>

      <todo|@fabio: define the concept of \Porigin\Q>

      \;

      The following SCALE encoded array, <math|Enc<rsub|SC><around|(|b<rsub|0>,..b<rsub|n>|)>>,
      contains the raw bytes of the message which varies in size.

      <item><math|UINT32>: number of downward messages that were processed by
      the Parachain. It is expected that the Parachain processes them from
      first to last.
    </itemize>
  </definition>

  <\definition>
    <label|defn-blob>Accordingly we define the
    <with|font-series|bold|Available PoV Blob> or the
    <with|font-series|bold|Blob> in short,
    <with|font-series|bold|mode|math|<wide|B|\<bar\>>>, to be the tuple:

    <\equation*>
      <around|(|B,\<pi\><rsub|B>,v<rsup|GVP><rsub|B>,v<rsup|LVP><rsub|B>|)>
    </equation*>

    where each value represents:

    <\itemize>
      <item><math|B>: the parachain block.

      <item><math|\<pi\><rsub|B>>: the witness data.

      <item><math|v<rsup|GVP><rsub|B>>: the global validation parameters
      (Definition <reference|defn-global-validation-parameters>).

      <item><math|v<rsup|LVP><rsub|B>>: the local validation parameters
      (Definition <reference|defn-local-validation-parameters>).
    </itemize>
  </definition>

  Note that in the code the blob is referred to as \PAvailableData\Q.

  <section|Protocol Types>

  <\definition>
    <label|net-msg-bitfield-dist-msg>The <strong|bitfield distribution
    message>, <math|M>, is a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\><around*|(|B<rsub|h>,P|)>>>>>>>>|<row|<cell|P>|<cell|=>|<cell|<around*|(|d,A<rsub|i>,A<rsub|s>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|B<rsub|h>> is the hash of the relay chain parent,
      indicating the state this message is for.

      <item><math|d> is the bitfield as described in Definition <todo|todo>.

      <item><math|A<rsub|i>> is the validator index in the authority set that
      signed this message.

      <item><math|A<rsub|s>> is the signature of the validator.
    </itemize-dot>
  </definition>

  <\definition>
    <label|net-msg-full-statement>A <strong|full statement>, <math|S>, is a
    datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|S>|<cell|=>|<cell|<around*|(|d,A<rsub|i>,A<rsub|s>|)>>>|<row|<cell|d>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|1\<rightarrow\>C<rsub|r>>>|<row|<cell|2\<rightarrow\>C<rsub|h>>>>>>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|d> is a varying datatype where <math|1> indicates that the
      validator seconds a candidate, followed by the committed candidate
      receipt, <math|C<rsub|r>>, as defined in Definition <todo|todo>.
      <math|2> indicates that the validator has deemed the candidate valid,
      followed by the candidate hash.

      <item><math|C<rsub|h>> is the candidate hash.

      <item><math|A<rsub|i>> is the validator index in the authority set that
      signed this statement.

      <item><math|A<rsub|s>> is the signature of the validator.
    </itemize-dot>
  </definition>

  <\definition>
    <label|net-msg-statement-distribution>The <strong|statement distribution
    message>, <math|M>, is a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\><around*|(|B<rsub|h>,S|)>>>|<row|<cell|1\<rightarrow\>S<rsub|m>>>>>>>>|<row|<cell|S<rsub|m>>|<cell|=>|<cell|<around*|(|B<rsub|h>,C<rsub|h>,A<rsub|i>,A<rsub|s>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|M> is a vayring datatype where <math|0 >indicates a signed
      statement and <math|1> contains metadata about a seconded statement
      with a larger payload, such as a runtime upgrade. The candidate itself
      can be fetched via the request/response message as defined in
      Definition <reference|net-msg-statement-fetching-request>.

      <item><math|B<rsub|h>> is the hash of the relay chain parent,
      indicating the state this message is for.

      <item><math|S> is a full statement as defined in Definition
      <reference|net-msg-full-statement>.

      <item><math|A<rsub|i>> is the validator index in the authority set that
      signed this message.

      <item><math|A<rsub|s>> is the signature of the validator.\ 
    </itemize-dot>
  </definition>

  <\definition>
    <label|net-msg-approval-distribution>The <strong|approval distribution
    message>, <math|M>, is a varying datatype of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\><around*|(|<around*|(|C<rsub|>,I<rsub|>|)><rsub|0>\<ldots\><around*|(|C,I|)><rsub|n>|)>>>|<row|<cell|1\<rightarrow\><around*|(|V<rsub|0>,\<ldots\>V<rsub|n>|)>>>>>>>>|<row|<cell|C>|<cell|=>|<cell|<around*|(|B<rsub|h>,A<rsub|i>,c<rsub|a>|)>>>|<row|<cell|c<rsub|a>>|<cell|=>|<cell|<around*|(|c<rsub|k>,P<rsub|o>,P<rsub|p>|)>>>|<row|<cell|c<rsub|k>>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>s>>|<row|<cell|1\<rightarrow\>i>>>>>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|M> is a varying datatype where <math|0> indicates
      assignments for candidates in recent, unfinalized blocks and <math|1>
      indicates approvals for candidates in some recent, unfinalized block.

      <item><math|C> is an assignment criterion which refers to the candidate
      under which the assignment is relevant by the block hash.

      <item><math|B<rsub|h>> is the block hash where the candidate appears.
      <todo|para- or relay block?>

      <item><math|A<rsub|i>> is the validator index in the authority set that
      created this message. <todo|refer authority set>

      <item><math|c<rsub|a>> is the certification of the assignment.

      <item><math|c<rsub|k>> is a varying datatype where <math|0> indicates
      an assignment story based on the VRF that authorized the relay chain
      block where the candidate was included, followed by a sample number,
      <math|s.> <math|1> indicates an assignment story based on the VRF that
      authorized the relay chain block where the candidate was included
      combined with the index of a particular core. <todo|clarify all of
      this>.

      <item><math|P<rsub|o>> is a VRF output and <math|P<rsub|p>> its
      corresponding proof. <todo|refer>
    </itemize-dot>
  </definition>

  <\definition>
    <label|net-msg-collator-protocol>The <strong|collator protocol message>,
    <math|M>, is a varying datatype of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\><around*|(|C<rsub|i>,P<rsub|i>,C<rsub|s>|)>>>|<row|<cell|1\<rightarrow\>H>>|<row|<cell|4\<rightarrow\><around*|(|B<rsub|h>,S|)>>>>>>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|M> is a varying datatype where <math|0> indicates the
      intent to advertise a collation and <math|1> indicates the advertisment
      of a collation to a validator. <math|4> indicates that a collation sent
      to a validator was seconded. <todo|clarify all of this.>

      <item><math|C<rsub|i>> is the public key of the collator.

      <item><math|P<rsub|i>> is the parachain Id as defined in Definition
      <reference|defn-para-id>.

      <item><math|C<rsub|s>> is the signature of the collator using the
      <verbatim|PeerId> of the collators node. <todo|why?>

      <item><math|H> is the hash of the collation <todo|clarify>.

      <item><math|S> is a full statement as defined in Definition
      <reference|net-msg-full-statement>.
    </itemize-dot>
  </definition>

  <\definition>
    The <strong|validator protocol message>, <math|M>, is a varying datatype
    of the following format: <todo|when is this used?>

    <\eqnarray*>
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|1\<rightarrow\>M<rsub|f>>>|<row|<cell|3\<rightarrow\>M<rsub|s>>>|<row|<cell|4\<rightarrow\>M<rsub|a>>>>>>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|M<rsub|f>> is a bitfield distribution message as defined in
      Definition <reference|net-msg-bitfield-dist-msg>.

      <item><math|M<rsub|s>> is a statement distribution message as defined
      in Definition <reference|net-msg-statement-distribution>.

      <item><math|M<rsub|a>> is a approval distribution message as defined in
      Definition <reference|net-msg-approval-distribution>.
    </itemize-dot>
  </definition>

  <\definition>
    The <strong|collator protocol message>, <math|M>, is a varying datatype
    of the following format: <todo|when is this used?>

    <\eqnarray*>
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>M<rsub|c>>>>>>>>>>
    </eqnarray*>

    where <math|M<rsub|c>> is the collator protocol message as defined in
    Definition <reference|net-msg-collator-protocol>.
  </definition>

  <section|Request & Response Network Messages>

  <subsection|PoV Blocks>

  <\definition>
    <label|net-msg-pov-fetching-request>The <strong|PoV fetching request> is
    sent by clients who want to retrieve a PoV block from a node. The request
    is a datastructure of the following format:

    <\equation*>
      <around*|(|C<rsub|h>|)>
    </equation*>

    where <math|C<rsub|h>> is the 256-bit hash of the PoV block. The reponse
    message is defined in Definition <reference|net-msg-pov-fetching-response>.

    \;
  </definition>

  <\definition>
    <label|net-msg-pov-fetching-response>The <strong|PoV fetching response>
    is sent by nodes to the clients who issued a PoV fetching request as
    defined in Definition <reference|net-msg-pov-fetching-request>. The
    response, <math|R>, is a varying datatype of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|=|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>B>>|<row|<cell|1\<rightarrow\>\<b-phi\>>>>>>>>>>
    </eqnarray*>

    where <math|0> is followed by the PoV block and <math|1> indicates that
    the PoV block was not found.
  </definition>

  <subsection|Chunks>

  <\definition>
    <label|net-msg-chunk-fetching-request>The <strong|chunk fetching request>
    is sent by clients who want to retrieve chunks of a parachain candidate.
    The request is a datastructure of the following format:

    <\equation*>
      <around*|(|C<rsub|h>,i|)>
    </equation*>

    where <math|C<rsub|h>> is the 256-bit hash of the parachain candiate and
    <math|i> is a 32-bit unsigned integer indicating the index of the chunk
    to fetch <todo|clarify>. The response message is defined in Definition
    <reference|net-msg-chunk-fetching-response>.
  </definition>

  <\definition>
    <label|net-msg-chunk-fetching-response>The <strong|chunk fetching
    response> is sent by nodes to the clients who issued a chunk fetching
    request as defined in Definition <reference|net-msg-chunk-fetching-request>.
    The reponse, <math|R>, is a varying datatype of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>C<rsub|r>>>|<row|<cell|1\<rightarrow\>\<b-phi\>>>>>>>>|<row|<cell|C<rsub|r>>|<cell|=>|<cell|<around*|(|c,c<rsub|p>|)>>>>>
    </eqnarray*>

    where 0 is followed by the chunk response, <math|C<rsub|r>> and 1
    indicates that the requested chunk was not found. <math|C<rsub|r>>
    contains the erasure-encoded chunk of data belonging to the candidate
    block, <math|c>, and <math|c<rsub|i>> is that chunks proof in the Merkle
    tree. Both <math|c> and <math|c<rsub|i>> are byte arrays for type
    <math|*<around*|(|b<rsub|0>\<ldots\>b<rsub|n>|)>>.
  </definition>

  <\definition>
    <label|net-msg-available-data-request>The <strong|available data request>
    is sent by clients who want to retrieve the PoV block of a parachain
    candidate. The request is a datastructure of the following format:

    <\equation*>
      <around*|(|C<rsub|h>|)>
    </equation*>

    where <math|C<rsub|h>> is the 256-bit candidate hash to get the available
    data for. The reponse message is defined in Definition
    <reference|net-msg-available-data-reponse>.
  </definition>

  <\definition>
    <label|net-msg-available-data-reponse>The <strong|available data
    response> is sent by nodes to the clients who issued a available data
    request as defined in Definition <reference|net-msg-available-data-request>.
    The reponse, <math|R>, is a varying datatype of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>A>>|<row|<cell|1\<rightarrow\>\<b-phi\>>>>>>>>|<row|<cell|A>|<cell|=>|<cell|<around*|(|P<rsub|ov>,D<rsub|pv>|)>>>>>
    </eqnarray*>

    where <math|0> is followed by the available data, <math|A>, and <math|1>
    indicates the the requested candidate hash was not found.
    <math|P<rsub|ov>> is the PoV block as defined in Definition
    <reference|defn-pov-block> and <math|D<rsub|pv>> is the persisted
    validation data as defined in Definition
    <reference|defn-persisted-validation-data>.
  </definition>

  <subsection|Advertised Collation>

  <\definition>
    <label|net-msg-collation-fetching-request>The <strong|collation fetching
    request> is sent by clients who want to retrieve the advertised collation
    at the specified relay chain block. The request is a datastructure of the
    following format:

    <\equation*>
      <around*|(|B<rsup|><rsub|h>,P<rsub|id>|)>
    </equation*>

    where <math|B<rsup|><rsub|h>> is the hash of the relay chain block and
    <math|P<rsub|id>> is the parachain Id as defined in Definition
    <reference|defn-para-id>. The response message is defined in Definition
    <reference|net-msg-collation-fetching-response>.
  </definition>

  <\definition>
    <label|net-msg-collation-fetching-response>The <strong|collation fetching
    response> is sent by nodes to the clients who issued a collation fetching
    request as defined in Definition <reference|net-msg-collation-fetching-request>.
    The response, <math|R>, is a varying datatype of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\><around*|(|C<rsub|r>,B|)>>>>>>>>>>
    </eqnarray*>

    where <math|0> is followed by the candidate receipt, <math|C<rsub|r>>, as
    defined in Definition <reference|defn-candidate-receipt> and the PoV
    block, <math|B>. This type does not notify the client about a statement
    that was not found.
  </definition>

  <subsection|Statements>

  <\definition>
    <label|net-msg-statement-fetching-request>The <strong|statement fetching
    request> is sent by clients who want to retrieve statements about a given
    candidate. The request is a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|>|<cell|<around*|(|B<rsub|h>,C<rsub|h>|)>>|<cell|>>>>
    </eqnarray*>

    where <math|B<rsub|h>> is the hash of the relay chain parent and
    <math|C<rsub|h>> is the candidate hash that was used to create the
    committed candidate recept as defined in Definition <todo|todo>. The
    response message is defined in Definition
    <reference|net-msg-statement-fetching-response>.
  </definition>

  <\definition>
    <label|net-msg-statement-fetching-response>The <strong|statement fetching
    response> is sent by nodes to the clients who issued a collation fetching
    request as defined in Definition <reference|net-msg-statement-fetching-request>.
    The reponse, <math|R>, is a varying datatype of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>C<rsub|r>>>>>>>>>>
    </eqnarray*>

    where <math|C<rsub|r>> is the committed candidate receipt as defined in
    Definition <todo|todo>. This type does not notify the client about a
    statement that was not found.
  </definition>

  <subsection|Disputes>

  <\definition>
    <label|net-msg-dispute-request>The <strong|dispute request> is sent by
    clients who want to issue a dispute about a candidate. The request,
    <math|D<rsub|r>>, is a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|D<rsub|r>>|<cell|=>|<cell|<around*|(|C<rsub|r>,S<rsub|i>,I<rsub|v>,V<rsub|v>|)>>>|<row|<cell|I<rsub|v>>|<cell|=>|<cell|<around*|(|A<rsub|i>,A<rsub|s>,k<rsub|i>|)>>>|<row|<cell|V<rsub|v>>|<cell|=>|<cell|<around*|(|A<rsub|i>,A<rsub|s>,k<rsub|v>|)>>>|<row|<cell|k<rsub|i>>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>\<b-phi\>>>>>>>>|<row|<cell|k<rsub|v>>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>\<b-phi\>>>|<row|<cell|1\<rightarrow\>C<rsub|h>>>|<row|<cell|2\<rightarrow\>C<rsub|h>>>|<row|<cell|3\<rightarrow\>\<b-phi\>>>>>>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|C<rsub|r>> is the candidate that is being disputed. The
      structure is a candidate receipt as defined in Definition
      <reference|defn-candidate-receipt>.

      <item><math|S<rsub|i>> is an unsigned 32-bit integer indicating the
      session index the candidate appears in. <todo|clarify>

      <item><math|I<rsub|v>> is the invalid vote that makes up the request.\ 

      <item><math|V<rsub|v>> is the valid vote that makes this disput request
      valid.

      <item><math|A<rsub|i>> is an unsigned 32-bit integer indicating the
      validator index in the authority set as defined in Definition
      <todo|todo>.

      <item><math|A<rsub|s>> is the signature of the validator.

      <item><math|k<rsub|i>> is a varying datatype and implies the dispute
      statement. <math|0> indicates an explicit statemet.

      <item><math|k<rsub|v>> is a varying datatype and implies the dispute
      statement.

      <\itemize-dot>
        <item><math|0> indicates an explicit statement.

        <item><math|1> indicates a seconded statement on a candidate,
        <math|C<rsub|h>>, from the backing phase. <math|C<rsub|h>> is the
        hash of the candidate.

        <item><math|2> indicates a valid statement on a candidate,
        <math|C<rsub|h>>, from the backing phase. <math|C<rsub|h>> is the
        hash of the candidate.

        <item><math|3> indicates an approval vote from the approval checking
        phase.
      </itemize-dot>
    </itemize-dot>

    The response message is defined in Definition
    <reference|net-msg-dispute-response>.
  </definition>

  <\definition>
    <label|net-msg-dispute-response>The <strong|dispute response> is sent by
    nodes to the clients who who issued a dispute request as defined in
    Definition <reference|net-msg-dispute-request>. The response, <math|R>,
    is a varying type of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>\<b-phi\>>>>>>>>>>
    </eqnarray*>

    where <math|0> indicates that the dispute was successfully processed.
  </definition>

  <section|Candidate Validation>

  <subsection|Exhaustive Check>

  This step is initialized by the approval voting process.

  - Check whether the candidate does not exceed the max size as specified in
  the persisted validation data.

  - Check collator signature.

  - Eventually decompress parachain Runtime.

  - Validate the candidate by executing the parachain Runtime.

  - Based ont he resulting value, check whether the parent head is valid.

  - Create candidate commitments.

  - =\<gtr\> Notify approval voting process.

  <subsection|Non-exhaustive Check>

  This step is initialized by the backing process.

  - Check whether the candidate does not exceed the max size as specified in
  the persisted validation data.

  - Check collator signature.

  - Fetch the persisted validation data from the relay chain by calling the
  Runtime API.

  - Fetch the parachain Runtime from the relay chain by calling the Runtime
  API.

  - Eventually decompress parachain Runtime.

  - Validate the candidate by executing the parachain Runtime.

  - Based ont he resulting value, check whether the parent head is valid.

  - Create candidate commitments.

  - Check validation outputs by calling the Runtime API.

  - =\<gtr\> Notify the backing process.

  <section|Approval Voting & Distribution>

  The approval voting process ensures that only valid parachain blocks are
  finalized on the relay chain. Validators verify submitted parachain
  candidates received from collators and issue approvals for valid
  candidates, respectively disputes for invalid blocks.

  \;

  Since it cannot be expected that each validators verifies every single
  parachain candidate, this mechanism ensures that enough honest validators
  are selected to verify parachain candidates and to prevent the finalization
  of invalid blocks. If an honest validator detects a invalid block which was
  approved by one or more validators, the honest validator must issue a
  dispute which wil cause an escalation, resulting in consequences for all
  malicious parties, i.e. slashing. This mechanism is described more in
  Section <todo|todo>.

  \;

  The assignment function selects the validators responsible for verifying
  submitted parachain candidates, as defined in <todo|todo>. Assigned
  validators broadcast their assignment to indicate their intent to check a
  candidate. After verifying a parachain candidate, assigned validators issue
  their approval vote to their peers. If no following approval vote is sent,
  then that behavior is declared as \Pno-show', meaning that the
  corresponding validator failed to recover or verify the PoV block. This
  results in more validators having to verify the PoV block. That behavior is
  described more closely in Section <todo|todo>.

  \;

  <\todo>
    When we trigger our own assignment, we broadcast it via Approval
    Distribution, begin\ 

    fetching the data from Availability Recovery, and then pass it through to
    the\ 

    Candidate Validation.
  </todo>

  <subsection|Assignments>

  Assigned validators broadcast their assignment by issuing an approval
  distribution message as defined in Definition
  <reference|net-msg-approval-distribution>. Other assigned validators that
  receive that network message must keep track of if, expecting an approval
  vote following shortly after.

  \;

  Verifying candidate <todo|todo>

  Issuing approvals <todo|todo>

  <subsection|\PNo-show\Q Occurence>

  The Polkadot validator observes a \Pno-show\Q occurence when another
  assigned validator broadcasted an assignment, indicating the intent to
  verify a parachain candidate, but did not follow up with an approval vote
  within a certain duration.

  \;

  <todo|todo>

  <subsection|Check and import assignment>

  Check if the assignment is valid and can be accepted.

  =\<gtr\> initiated by the approval distribution

  \;

  Load block entry from storage

  Get the session info

  Get the claimed core index

  Load the candidate entry from storage

  Get the approval entry

  Check the assignment cert

  Determine tranche

  Check for duplicates

  Trigger action

  Write the candidate entry to storage

  \;

  <subsection|Check and import approval>

  Check if the pproval vote is valid and can be accepted.

  \;

  Load block entry from storage

  Get the session info

  Transform the approval vote into the wrapper used to import statements into
  disputes.

  Verify signature

  Load candidate entry

  Don't accept approvals until assignment.

  Inform the dispute coordinator about disputes if appropriate

  Import approval vote and update block entry and candidate entry

  Trigger actions

  <subsection|Approved Ancestor>

  <todo|todo>

  <section|Availability Distribution>

  The Polkadot validators must receive and distribute availability data to
  peers. It's primarily responsible for responding to requests and requesting
  availability data to and from other validators. The required processes are
  defined in the following subsections.

  <subsection|PoV Requests>

  When a peer requests a PoV block from the Polkadot validator, it should
  first check it's local database and send the PoV block back to the
  requester. If the PoV block is not available in the local database, the
  Polkadot validator issues requests to other validators in order to retrieve
  the PoV block. The validator determines whether the received PoV bock is
  valid by checking the hash, but will not do any further validation. If the
  received PoV block is valid, the validator will send it back to the
  original requester.

  <subsection|Chunk Requests>

  Once a parachain candidate has been backed as described in Definition
  <todo|todo>, this process must request the necessary chunks to keep the
  candidate available, ensuring that <math|2/3> of all the validators can
  deliver the candidate to peers that issue requests. This process keep track
  of backed candidates for each parachain by checking occupied cores as
  defined in Definiton <todo|todo>.

  <section|Availability Recovery>

  The availability distribution of the Polkadot validator must be able to
  send availability data to peers that issue requests. Therefore, the
  Polkadot validator must recover enough availability chunks from other peers
  in order to send an response to those requests.

  \;

  <todo|todo>

  <section|Candidate Selection><label|sect-primary-validation>

  Collators produce candidates (Definition <reference|defn-candidate>) and
  send those to validators. Validators verify the validity of the received
  candidates (Algo. <reference|algo-primary-validation>) by executing the
  validation code, <math|R<rsub|\<rho\>>>, and issue statements (Definition
  <reference|defn-gossip-statement>) about the candidates to connected peers.
  The validator ensures the that every candidate considered for inclusion has
  at least one other validator backing it. Candidates without backing are
  discarded.

  \;

  The validator must keep track of which candidates were submitted by
  collators, including which validators back those candidates in order to
  penalize bad behavior. This is described in more detail in section
  <reference|sect-primary-validaty-announcement>.

  <subsection|Parachain Block Production><label|sect-parachain-block-production>

  Collators produce a candidate for their corresponding parachains and submit
  those to the parachain validators which are part of the Polkadot relay
  chain.

  <subsubsection|Building a parachain block>

  <\algorithm|<label|algo-build-parablock>Producing a parachain candidate>
    <\algorithmic>
      <\state>
        <math|r<rsub|p>> \<leftarrow\> <name|RelayParent>
      </state>

      <\state>
        <math|v<rsub|d>> \<leftarrow\> <name|ValidationData>
      </state>

      <\state>
        <math|h<rsub|d>> \<leftarrow\> <name|ParentHead(<math|v<rsub|d>>)>
      </state>

      <\state>
        <math|D<rsub|p>\<leftarrow\>><name|ProduceCandidate(<math|><math|r<rsub|p>>,<math|v<rsub|d>>,<math|h<rsub|d>>)>
      </state>

      <\state>
        <math|B<rsub|p>> \<leftarrow\> <name|CreateParaBlocK(<math|D<rsub|p>>)>
      </state>

      <\state>
        <math|C<rsub|p>> \<leftarrow\> <name|BuildCollation>(<math|B<rsub|p>>)
      </state>

      <\state>
        <name|Announce>(<math|C<rsub|p>>)
      </state>
    </algorithmic>
  </algorithm>

  <\itemize-dot>
    <item><name|RelayParent> - Fetches the parent block hash of the relay
    chain as described in Section <reference|sect-collator-consensus>.

    <item><name|ValidationData> - Fetches the persistent validation data as
    defined in Definition <reference|defn-persisted-validation-data>.

    <item><name|ParentHead> - Derives the parachain parent header from
    validation data <math|v<rsub|d>>.

    <item><name|ProduceCandidate> - Produces a candidate as defined in
    Definition <reference|defn-candidate> from the values <math|r<rsub|p>>,
    <math|v<rsub|d>> and <math|h<rsub|d>>.

    <item><name|CreateParaBlock> - Creates a parachain block as defined in
    Definition <reference|defn-parablock> from the produced candidate
    <math|D<rsub|p>>.

    <item><name|BuildCollation> - Builds the final collation as defined in
    Definition <reference|defn-collation> from the created parachain block
    <math|B<rsub|p>>.

    <item><name|Announce> - Sends the collation to relay chain validators.
  </itemize-dot>

  <\definition>
    <label|defn-candidate>A <strong|candidate> is a datastructure of the
    following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|>|<cell|<around*|(|B<rsub|p>,H<rsub|r>|)>>|<cell|>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|B<rsub|p>> is the parachain block as defined in Definition
      <reference|defn-parablock>.

      <item><math|H<rsub|r>> is the storage merkle root <todo|why is this
      required if the root is already in <math|B<rsub|p>?>>.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-collation>A <strong|collation> is the output of a collator
    and differs from a candidate commitment (<todo|todo>) as it does not
    contain the erasure root (<todo|todo>), which is computed at the Polkadot
    relay chain level, and contains the PoV block. A collation, <math|C>, is
    a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|C>|<cell|=>|<cell|<around*|(|M<rsub|u>,M<rsub|h>,R<rsub|p>,h<rsub|d>,B<rsub|p>,N<rsub|q>,N<rsub|m>|)>>>|<row|<cell|M<rsub|u>>|<cell|=>|<cell|<around*|(|u<rsub|0>,\<ldots\>u<rsub|n>|)>>>|<row|<cell|M<rsub|h>>|<cell|=>|<cell|<around*|(|o<rsub|0>,\<ldots\>o<rsub|n>|)>>>>>
    </eqnarray*>

    The necessary information to construct a collation can be fetched by the
    collator by calling the <verbatim|collect_collation_info> Runtime
    function as described in Section <reference|sect-runtime-collect-collation-info>.
    <math|h<rsub|d>> and <math|B<rsub|p>> are selected and provided by the
    collator individually as described in Algorithm
    <reference|algo-build-parablock>:

    <\itemize-dot>
      <item><math|M<rsub|u>> is a sequence of upward messages, represented as
      byte arrays, to be interpreted by the Polkadot relay chain itself.

      <item><math|M<rsub|h>> is a sequence of outbound HRMP messages as
      defined in Definition <todo|todo> sent by the parachain.

      <item><math|R<rsub|p>> is the varying type <verbatim|Option> as defined
      in Definition <reference|defn-option-type> which can contain a new
      Runtime for the parachain, represented as a byte array.

      <item><math|h<rsub|d>> is the parachain block header as defined in
      Definition <reference|defn-block-header>.

      <item><math|B<rsub|p>> is the parachain block as defined in Definition
      <reference|defn-parablock>.

      <item><math|N<rsub|q>> is the number of messages processed from the DMQ
      <todo|todo>.

      <item><math|N<rsub|m>> is the watermark indicated as a block number up
      to which all i nbound HRMP messages are processed.
    </itemize-dot>
  </definition>

  <section|Consensus><label|sect-collator-consensus>

  Collators follow the relay chain to act as consensus for the parachain. The
  collator must follow the best head (latest block) of the relay chain. This
  can be achieved in two ways:

  <\itemize-dot>
    <item>Fetch the best head currently known by the collator.

    <item>Listen to incoming block announcements from peers as defined in
    Definition <reference|defn-block-announcement>. If it contains a newer
    relay chain block, the collator must keep track of it.
  </itemize-dot>

  The relay chain head is used for parachain block production as described in
  Section <reference|sect-parachain-block-production>.

  \;

  <todo|spec networking>

  <section|Candidate Backing><label|sect-primary-validaty-announcement>

  <subsection|Block Announcement>

  Since collators rely on the relay chain provided consensus and the
  parachain itself does not have any authorities to limit block producers, a
  mechanism must be provided in order to limit the import of blocks submitted
  by collators, which could be in the millions. To solve this, collators send
  their candidates to relay chain validators and wait for a
  <verbatim|Seconded> statement as described in Section
  <reference|defn-candidate-statement>. Receiving this message implies that
  the proposed candidate is likely to be inlcuded in the relay chain, making
  the candidate suitable to be announced to peers as described in Definition
  <reference|defn-block-announcement>. If no <verbatim|Seconded> statement is
  received, no such announcement takes place <todo|how is bad behavior
  prevented here?>.

  <\definition>
    <label|defn-block-announcement>A <strong|block announcement> message is a
    datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|>|<cell|<around*|(|C<rsub|r>,C<rsub|s>,C<rsub|h>,V<rsub|id>,S|)>>|<cell|>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|C<rsub|r>> is the candidate receipt as defined in
      Definition <reference|defn-candidate-receipt>.

      <item><math|C<rsub|s>> is the statement given by a relay chain
      validator about the candidate as defined in Definition
      <reference|defn-candidate-statement>.

      <item><math|C<rsub|h>> is the hash of the candidate as defined in
      Definition <reference|defn-candidate>.

      <item><math|V<rsub|id>> is the index of the validator in the authority
      set as described in Section <reference|sect-authority-set>.

      <item><math|S> is the signature of the valdator <math|V<rsub|id>> who
      signed statement <math|C<rsub|s>>.
    </itemize-dot>

    Collators that receive this announcement should check whether the
    candidate statement <math|C<rsub|s>> is <verbatim|Seconded> and whether
    the signature of the validator is valid <todo|how do collators know about
    the current authority set?>.
  </definition>

  <\definition>
    <label|defn-candidate-receipt>A <strong|candidate receipt> is included in
    block announcements. It's a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|>|<around*|(|P<rsub|id>,H<rsub|h>,C<rsub|id>,V<rsub|h>,B<rsub|h>,E<rsub|r>,S,h<rsub|h>,R<rsub|h>,C<rsub|h>|)>|<cell|>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|P<rsub|id>> is the ID of the parachain this candidate is
      for <todo|define>.

      <item><math|H<rsub|h>> is the hash of the realy chain block this is
      announcement is in the context of.

      <item><math|C<rsub|id>> is the collators sr25519 public key.

      <item><math|V<rsub|h>> is the hash of the persisted validation data
      <todo| define>.

      <item><math|B<rsub|h>> is the hash of the parachain block this
      announcement is for.

      <item><math|E<rsub|r>> is the root of the blocks erasure endoding
      Merkle tree <todo|define>.

      <item><math|S> is the signature of the concatenated components
      <math|P<rsub|id>>, <math|H<rsub|h>>, <math|V<rsub|h>> and
      <math|B<rsub|h>>.

      <item><math|H<rsub|r><around|(|B|)>>: the root of a block's erasure
      encoding Merkle tree <todo|@fabio: use different symbol for
      this?>.<verbatim|>

      <item><math|R<rsub|h>> is the hash of the parachain Runtime.

      <item><math|C<rsub|h>> is the hash of the encoded commitments made as a
      result of candidate execution <todo|clarify>.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-candidate-statement>A <strong|candidate statement> is a
    message created by the relay chain validator on whether a produced
    candidate which was submitted by a collator is valid or is likely to be
    included in a relay chain block. It's a varying datatype of the following
    format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|>|<cell|<choice|<tformat|<table|<row|<cell|0<space|1em><rprime|''>Seconded<rprime|''>
      - proposal for inclusion>>|<row|<cell|1<space|1em><rprime|''>Valid<rprime|''>
      - the parachain candidate is valid>>>>>>|<cell|>>>>
    </eqnarray*>

    Which variant is constructed depends on the current stage of the
    validation process. This is described further in Section <todo|todo>.
  </definition>

  <\definition>
    <label|defn-candidate-commitments><with|font-series|bold|Candidate
    commitments>, <math|C<rsub|c>>, are results of the execution and
    validation of parachain (or parathread) candidates whose produced values
    must be committed to the relay chain. A candidate commitments is
    represented as a tuple of the following format:

    <alignat*|2|<tformat|<table|<row|<cell|C<rsub|c>>|<cell|\<assign\><around*|(|M<rsub|u>,M<rsub|h>,R<rsub|v>,P<rsub|h>|)>>>>>>

    where each value represents:

    <\itemize>
      <item><math|>
    </itemize>
  </definition>

  <\definition>
    <label|defn-gossip-pov-block>A <with|font-series|bold|Gossip PoV block>
    is a tuple of the following format:

    <\equation*>
      <around|(|h<rsub|b><around|(|B<rsub|<rsup|relay><rsub|parent>>|)>,h<rsub|b><around|(|C<rsub|coll><around|(|PoV<rsub|B>|)>|)>,PoV<rsub|B>|)>
    </equation*>

    where <math|h<rsub|b><around|(|B<rsub|<rsup|relay><rsub|parent>>|)>> is
    the block hash of the relay chain being referred to and
    <math|h<rsub|b><around|(|C<rsub|coll><around|(|PoV<rsub|B>|)>|)>> is the
    hash of some candidate localized to the same Relay chain block.
  </definition>

  <\algorithm|<label|algo-primary-validation-announcement><name|PrimaryValidationAnnouncement>(<math|PoV<rsub|B>>)>
    <\algorithmic>
      <state|<with|font-series|bold|Init> <math|Stmt>;>

      <\algo-if-else-if|<with|font-shape|small-caps|ValidateBlock>(<math|PoV<rsub|B>>)
      is <with|font-series|bold|valid>>
        <state|<math|Stmt\<leftarrow\>><with|font-shape|small-caps|SetValid>(<math|PoV<rsub|B>>)>
      <|algo-if-else-if>
        <state|<math|Stmt\<leftarrow\>><with|font-shape|small-caps|SetInvalid>(<math|PoV<rsub|B>>)>

        <state|<with|font-shape|small-caps|BlacklistCollatorOf>(<math|PoV<rsub|B>>)>
      </algo-if-else-if>

      <state|<with|font-shape|small-caps|Propagate>(<math|Stmt>)>
    </algorithmic>
  </algorithm>

  <\itemize>
    <item><with|font-shape|small-caps|ValidateBlock>: Validates
    <math|PoV<rsub|B>> as defined in Algorithm
    <reference|algo-validate-block>.

    <item><with|font-shape|small-caps|SetValid>: Creates a valid statement as
    defined in Definition <reference|defn-gossip-statement>.

    <item><with|font-shape|small-caps|SetInvalid>: Creates an invalid
    statement as defined in Definition <reference|defn-gossip-statement>.

    <item><with|font-shape|small-caps|BlacklistCollatorOf>: blacklists the
    collator which sent the invalid PoV block, preventing any new PoV blocks
    from being received. The amount of time for blacklisting is unspecified.

    <item><with|font-shape|small-caps|Propagate>: sends the statement to the
    connected peers.
  </itemize>

  <\algorithm|<label|algo-endorse-candidate-receipt><name|ConfirmCandidateReceipt>(<math|Stmt<rsub|peer>>)>
    <\algorithmic>
      <state|<with|font-series|bold|Init> <math|Stmt>;>

      <state|<math|PoV<rsub|B>\<leftarrow\>>
      <with|font-shape|small-caps|Retrieve>(<math|Stmt<rsub|peer>>)>

      <\algo-if-else-if|<with|font-shape|small-caps|ValidateBlock>(<math|PoV<rsub|B>>)
      is <with|font-series|bold|valid>>
        <\algo-if-else-if|<with|font-shape|small-caps|AlreadySeconded>(<math|B<rsup|relay><rsub|chain>>)>
          <state|<math|Stmt\<leftarrow\>><with|font-shape|small-caps|SetValid>(<math|PoV<rsub|B>>)>
        <|algo-if-else-if|>
          <state|<math|Stmt\<leftarrow\>><with|font-shape|small-caps|SetSeconded>(<math|PoV<rsub|B>>)>
        </algo-if-else-if>
      <|algo-if-else-if>
        <state|<math|Stmt\<leftarrow\>><with|font-shape|small-caps|SetInvalid>(<math|PoV<rsub|B>>)>

        <state|<with|font-shape|small-caps|AnnounceMisbehaviorOf>(<math|PoV<rsub|B>>)>
      </algo-if-else-if>

      <state|<with|font-shape|small-caps|Propagate>(<math|Stmt>)>
    </algorithmic>
  </algorithm>

  <\itemize>
    <item><math|Stmt<rsub|peer>>: a statement received from another
    validator.

    <item><with|font-shape|small-caps|Retrieve>: Retrieves the PoV block from
    the statement (<reference|defn-gossip-statement>).

    <item><with|font-shape|small-caps|ValidateBlock>: Validates
    <math|PoV<rsub|B>> as defined in Algorithm
    <reference|algo-validate-block>.

    <item><with|font-shape|small-caps|AlreadySeconded>: Verifies if a
    parachain block has already been seconded for the given Relay Chain
    block. Validators that second more than one (1) block per Relay chain
    block are subject to slashing. More information is available in
    Definition <reference|defn-gossip-statement>.

    <item><with|font-shape|small-caps|SetValid>: Creates a valid statement as
    defined in Definition <reference|defn-gossip-statement>.

    <item><with|font-shape|small-caps|SetSeconded>: Creates a seconded
    statement as defined in Definition <reference|defn-gossip-statement>.
    Seconding a block should ensure that the next call to
    <with|font-shape|small-caps|AlreadySeconded> reliably affirms this
    action.

    <item><with|font-shape|small-caps|SetInvalid>: Creates an invalid
    statement as defined in Definition <reference|defn-gossip-statement>.

    <item><with|font-shape|small-caps|BlacklistCollatorOf>: blacklists the
    collator which sent the invalid PoV block, preventing any new PoV blocks
    from being received. The amount of time for blacklisting is unspecified.

    <item><with|font-shape|small-caps|AnnounceMisbehaviorOf>: announces the
    misbehavior of the validator who claimed a valid statement of invalid PoV
    block as described in algorithm <todo|@fabio>.

    <item><with|font-shape|small-caps|Propagate>: sends the statement to the
    connected peers.
  </itemize>

  <section|PoV Recovery>

  <todo|todo>

  <section|Availability>

  In order for the Polkadot protocol to ensure the security of validatod
  parachain blocks, it must be able to reproduce those blocks in case of
  future dispute. To this aim, \ backed candidates must be available for the
  entire, elected validators set. However it is impractical to require each
  of those validator to maintain a full copy of all PoV blocks. A practical
  solution to this problem is to employ erasure codes: PoV blocks are broken
  into chunks and the chunks are encoded using Reed-Solomon erasure codes.
  Erasure-encoded chunks are arranged into a Merkle tree to ensure their
  integrity. Subsequently, the encoded chunks are distributed among the
  validators each along side its Merkle proof of integrity. Each validator
  keeps track of how those chunks are distributed among the validator set.
  When a validator has to verify a PoV block, it can request the relevant
  chunks from its peers, verify its integrity and reconstruct the originally
  validated PoV block.

  This Section specifies the interaction of a validator node with the erasure
  code library to obtain the encoded chunk and to reconstructing the original
  PoV when enough encode chunks are available. However, the specification of
  the Reed-Solomon encoding/decoding Algorithm is beyond the scope of this
  section.<verbatim|>

  <\definition>
    For validator set of size <math|n>, The <strong|encoding parameters> for
    Polkadot Reed-Solomon code is set as follow:

    <\itemize>
      <item><strong|<math|k>, the number of message symbols> is set to be
      <math|<around*|\<lfloor\>|<frac|n-1|3>|\<rfloor\>>+1>.

      <item><math|><strong|n, the number of code symbols> is set to be
      <math|n>.
    </itemize>
  </definition>

  <\definition>
    <label|defn-erasure-encoder-decoder>The <with|font-series|bold|erasure
    encoder>, <with|font-series|bold|<math|encode<rsub|k,n>> >is defined to
    be the Reed-Solomon encoder of a message of length k symbols which
    encodes it into <math|n> symbles as follows:

    <\equation*>
      encode<rsub|k,n>:<around*|{|<tabular*|<tformat|<table|<row|<cell|\<bbb-B\><rsub|m>>|<cell|\<rightarrow\>>|<cell|\<bbb-S\><rsub|n>>>|<row|<cell|<around*|(|b<rsub|1>,\<ldots\>,b<rsub|m>|)>>|<cell|\<rightarrow\>>|<cell|<around*|(|S<rsub|1>,S<rsub|2>,\<ldots\>,S<rsub|n>|)>>>>>>|\<nobracket\>>
    </equation*>

    \ where <math|<around*|[|b<rsub|1>,\<ldots\>,b<rsub|m>|]>> is a byte
    array of arbitrary size <math|m> and <math|<around*|(|S<rsub|1>,S<rsub|2>,\<ldots\>,S<rsub|n>|)>><math|>
    is a sequence of shards defined in <reference|defn-erasure-shard>.
  </definition>

  <\definition>
    <label|defn-erasure-shard>For a validator node <math|i>, and byte array
    blob <math|B=<around*|(|b<rsub|1>,\<ldots\>,b<rsub|m>|)>\<in\>\<bbb-B\><rsub|M>>
    we define <strong|<math|S<rsub|i>>> as the <strong|<math|i>'th erasure
    coded Shard> \ which is a byte array of length
    <math|<around*|\<lceil\>|m/2k|\<rceil\>>>. It is indexed as <math|i>
    because it is out to be handed over to and kept by validator <math|i>
    <todo|define how bytes are distributed before encoding? First k Shards
    are containing pure data?>
  </definition>

  <\definition>
    The <math|><with|font-series|bold|erasure decoder
    <math|decoder<rsub|k,n>>> is defined to be the Reed-Solomon decoder of a
    code word of n symboles into a message of k symbols as follows:

    <\equation*>
      decode<rsub|k,n>:<around*|{|<tabular*|<tformat|<table|<row|<cell|O
      S<rsub|n>>|<cell|\<rightarrow\>>|<cell|\<bbb-B\><rsub|m>>>|<row|<cell|<around*|(|O
      S<rsub|1>,O S<rsub|2>,\<ldots\>,O S<rsub|n>|)>>|<cell|\<rightarrow\>>|<cell|<around*|(|b<rsub|1>,\<ldots\>,b<rsub|m>|)>>>|<row|<cell|>|<cell|>|<cell|>>>>>|\<nobracket\>>
    </equation*>

    Where <math|OS<rsub|n>> is the set of sequence of length n of optional
    shards as defined in Definition <reference|defn-erasure-optional-shard>
    and <math|\<bbb-B\><rsub|m>> is the set of byte arrays of length m
    representing the decoded blob of data.
  </definition>

  <\definition>
    <label|defn-erasure-optional-shard>For a validator node <math|i>, we
    define <strong|O<math|S<rsub|i>>> as the <strong|<math|i>'th Optional
    Shard> which is a of varying type:

    <\equation*>
      <tabular|<tformat|<table|<row|<cell|idx>|<cell|>|<cell|>>|<row|<cell|0>|<cell|None>|<cell|When
      S<rsub|i> \ is not received by the constructing node
      >>|<row|<cell|1>|<cell|S<rsub|i>>|<cell|When S<rsub|i> shard is
      received.>>>>>
    </equation*>
  </definition>

  <\algorithm>
    <label|algo-erasure-encode><name|Erasure-Encode>(<math|<wide|B|\<bar\>>>:
    the available PoV blob defined in Definition <reference|defn-blob>,\ 

    <math|v<rsub|B>>: number of validator in the active set)
  <|algorithm>
    <\algorithmic>
      <state|<with|font-series|bold|><math|Shards\<leftarrow\>>
      <with|font-shape|small-caps|Make-Shards>(<math|<paraValidSet>,v<rsub|B>>)>

      <\state>
        Trie <math|\<leftarrow\>><name|Generate-Availability-Merkle-Tree>(Shards)
      </state>

      <state|<math|Er<rsub|B >\<leftarrow\>\<phi\>>>

      <state|<with|font-series|bold|Init> <math|index=0>>

      <\state>
        <FOR-IN|shard\<in\>Shards|>
      </state>

      <\state>
        <math|nodes\<leftarrow\>> <with|font-shape|small-caps|Get-Nodes>(<math|Trie,index>)
      </state>

      <\state>
        <with|font-shape|small-caps|Add>(<math|Er<rsub|B>,<around|(|shard,index,nodes|)>>)
      </state>

      <\state>
        <math|index\<leftarrow\>index+1><END>
      </state>

      <\state>
        <algo-return|<math|Er<rsub|B>>>
      </state>
    </algorithmic>
  </algorithm>

  <\itemize>
    <item><with|font-shape|small-caps|Make-Shards(..)>: return shards for
    each validator as described in Algorithm <reference|algo-make-shards>.
    Return value is defined as <math|<around|(|\<bbb-S\><rsub|0>,...,\<bbb-S\><rsub|n>|)>>
    where <math|\<bbb-S\>\<assign\><around|(|b<rsub|0>,...,b<rsub|n>|)>>

    <item><name|Generate-Availability-Merkle-Tree> is described in Algorithm
    <reference|algo-gen-availblity-tree>.

    <item><with|font-shape|small-caps|Insert(<math|trie,key,val>)>: insert
    the given <math|key> and <math|value> into the <math|trie>.

    <item><with|font-shape|small-caps|Get-Nodes(<math|trie,key>)>: based on
    the <math|key>, return all required <math|trie> nodes in order to verify
    the corresponding value for a (unspecified) Merkle root. Return value is
    defined as <math|<around|(|\<bbb-N\><rsub|0>,...,\<bbb-N\><rsub|n>|)>>
    where <math|\<bbb-N\>\<assign\><around|(|b<rsub|0>,...,b<rsub|n>|)>>.

    <item><with|font-shape|small-caps|Add(<math|sequence,item>)>: add the
    given <math|item> to the <math|sequence>.

    <item><math|ER<rsub|B>> is the collection of erasure coded chunk as
    defined in Definition <reference|defn-erasure-coded-chunks>.
  </itemize>

  <\algorithm>
    <label|algo-make-shards><name|Make-Shards>(<math|D>: The data to be
    erasure coded and sharded,

    <math|v<rsub|B>>: Number of required resulting shards (equal to the
    number of validators))
  <|algorithm>
    <\algorithmic>
      <state|<math|k\<leftarrow\><rsub|>2<rsup|<around*|\<lfloor\>|log<rsub|2><around*|(|<frac|<around|(|<around|\||<paraValidSet>|\|>-1|)>|3>+1|)>|\<rfloor\>>>>>

      <state|<math|l\<leftarrow\>2<rsup|<around*|\<lceil\>|log<rsub|2><around*|(|v<rsub|B>|)>|\<rceil\>>>>>

      <\state>
        <math|C\<leftarrow\><around*|(|l,k,n|)>>
      </state>

      <\state>
        <math|encode<rsub|k,n>\<leftarrow\>><name|Make-Encoder(C)>
      </state>

      <\state>
        <math|<around*|(|S<rsub|1>,\<ldots\>,S<rsub|n>|)>\<leftarrow\>><math|encode<rsub|k,n><around*|(|Enc<rsub|SC><around*|(|D|)>|)>>
      </state>

      <\state>
        <\RETURN>
          <math|<around*|(|S<rsub|1>,\<ldots\>,S<rsub|n>|)>>
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  <\itemize>
    <item><name|Make-Encoder(C)> is the API function provided by
    <cite|w3f_rs-ec-perf_2021>.
  </itemize>

  Algorithm <reference|algo-gen-availblity-tree> creates a Merkle tree from
  the shards produced by Algorithm <reference|algo-make-shards>. The Merkle
  tree is to produce the Merkle proofs to verify each chunk.\ 

  <\algorithm>
    <label|algo-gen-availblity-tree><name|Generate-Availability-Merkle-Tree>(S:
    Sequence of Shards generated

    by Algorithm <reference|algo-make-shards> )
  <|algorithm>
    <\algorithmic>
      <state|<with|font-series|bold|><math|Trie\<leftarrow\>>> Empty Merkle
      Tree

      <state|<with|font-series|bold|><math|index\<leftarrow\>0>>

      <\state>
        <FOR-IN|shard|>S
      </state>

      <state|<with|font-shape|small-caps|Insert>(<math|Trie,index>,
      <with|font-shape|small-caps|Blake2>(<math|shard>))>

      <\state>
        <math|index=index+1><END>
      </state>

      <\state>
        <\RETURN>
          Trie
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  <\todo>
    \ Either we should spec the trie completly as we did with Storage Trie or
    we should\ 

    refer to Storage trie spec.
  </todo>

  <\definition>
    <label|defn-erasure-coded-chunks>The <with|font-series|bold|collection of
    erasure-encoded chunks> of <math|<wide|B|\<bar\>>>, denoted by:

    <\equation*>
      Er<rsub|B>\<assign\><around|(|e<rsub|1>,...,e<rsub|n>|)>
    </equation*>

    is defined to be the output of the Algorithm
    <reference|algo-erasure-encode>. Each chunk is a tuple of the following
    format:

    <alignat*|2|<tformat|<table|<row|<cell|e>|<cell|\<assign\><around|(|\<bbb-S\>,I,<around|(|\<bbb-N\><rsub|0>,...,\<bbb-N\><rsub|n>|)>|)>>>|<row|<cell|\<bbb-S\>>|<cell|\<assign\><around|(|b<rsub|0>,...,b<rsub|n>|)>>>|<row|<cell|\<bbb-N\>>|<cell|\<assign\><around|(|b<rsub|0>,...,b<rsub|n>|)>>>>>>

    where each value represents:

    <\itemize>
      <item><math|\<bbb-S\>>: a byte array containing the erasure-encoded
      shard of data.

      <item><math|I>: the unsigned 32-bit integer representing the index of
      this erasure-encoded chunk of data.

      <item><math|<around|(|\<bbb-N\><rsub|0>,...,\<bbb-N\><rsub|n>|)>>: an
      array of inner byte arrays, each containing the nodes of the Trie in
      order to verify the chunk based on the Merkle root.
    </itemize>
  </definition>

  <section|Distribution of Chunks><label|sect-distribute-chunks>

  Following the computation of <math|Er<rsub|B>>, <math|v> must construct the
  <math|<wide|B|\<bar\>>> Availability message defined in Definition
  <reference|defn-pov-erasure-chunk-message>. And distribute them to target
  validators designated by the Availability Networking Specification
  <cite|??>.

  <\definition>
    <label|defn-pov-erasure-chunk-message><with|font-series|bold|PoV erasure
    chunk message> <math|M<rsub|PoV<rsub|<wide|B|\<bar\>>>><around|(|i|)>> is
    TBS
  </definition>

  <section|Announcing Availability><label|sect-voting-on-availability>

  When validator <math|v> receives its designated chunk for
  <math|<wide|B|\<bar\>>> it needs to broadcast Availability vote message as
  defined in Definition<reference|defn-availability-vote-message>

  <\definition>
    <label|defn-availability-vote-message><with|font-series|bold|Availability
    vote message> <math|M<rsub|PoV><rsup|Avail,v<rsub|i>>> TBS
  </definition>

  Some parachains have blocks that we need to vote on the availability of,
  that is decided by <math|\<gtr\>2/3> of validators voting for availability.
  <syed|For 100 parachain and 1000 validators this will involve putting 100k
  items of data and processing them on-chain for every relay chain block,
  hence we want to use bit operations that will be very efficient. We
  describe next what operations the relay chain runtime uses to process these
  availability votes.|this is not really relevant to the spec>

  <\definition>
    <label|defn-availability-bitfield>An <with|font-series|bold|availability
    bitfield> is signed by a particular validator about the availability of
    pending candidates. It's a tuple of the following format:

    <\equation*>
      <around|(|u32,...|)>
    </equation*>

    <todo|@fabio>
  </definition>

  For each parachain, the relay chain stores the following data:

  <with|font-series|bold|1) availability status, 2) candidate receipt, 3)
  candidate relay chain block number>

  where availability status is one of {no candidate, to be determined,
  unavailable, available} .

  For each block, each validator <math|v> signs a message

  Sign(bitfield <math|b<rsub|v>>, block hash <math|h<rsub|b>>)

  where the <math|i>th bit of <math|b<rsub|v>> is <math|1> if and only if

  <\enumerate>
    <item>the availability status of the candidate receipt is \Pto be
    determined\Q on the relay chain at block hash <math|h<rsub|b>>
    <with|font-series|bold|and>

    <item><math|v> has the erasure coded chunk of the corresponding parachain
    block to this candidate receipt.
  </enumerate>

  These signatures go into a relay chain block.

  <subsection|Processing on-chain availability
  data><label|sect-processing-availability>

  This section explains how the availability attestations stored on the relay
  chain, as described in Section ??, are processed as follows:

  <\enumerate-numeric>
    <item>The relay chain stores the last vote from each validator on chain.
    For each new signature, the relay chain checks if it is for a block in
    this chain later than the last vote stored from this validator. If it is
    the relay chain updates the stored vote and updates the bitfield
    <math|b<rsub|v>> and block number of the vote.

    <item>For each block within the last <math|t> blocks where <math|t> is
    some timeout period, the relay chain computes a bitmask <math|bm<rsub|n>>
    (<math|n> is block number). This bitmask is a bitfield that represents
    whether the candidate considered in that block is still relevant. That is
    the <math|i>th bit of <math|bm<rsub|n>> is <math|1> if and only if for
    the <math|i>th parachain, (a) the availability status is to be determined
    and (b) candidate block number <math|\<leq\>n>

    <item>The relay chain initialises a vector of counts with one entry for
    each parachain to zero. After executing the following algorithm it ends
    up with a vector of counts of the number of validators who think the
    latest candidates is available.

    <\enumerate>
      <item>The relay chain computes <math|b<rsub|v>> and <math|bm<rsub|n>>
      where <math|n> is the block number of the validator's last vote

      <item>For each bit in <math|b<rsub|v>> and <math|bm<rsub|n>> add the
      <math|i>th bit to the <math|i>th count.
    </enumerate>

    <item>For each count that is <math|\<gtr\>2/3> of the number of
    validators, the relay chain sets the candidates status to \Pavailable\Q.
    Otherwise, if the candidate is at least <math|t> blocks old, then it sets
    its status to \Punavailable\Q.

    <item>The relay chain acts on available candidates and discards
    unavailable ones, and then clears the record, setting the availability
    status to \Pno candidate\Q. Then the relay chain accepts new candidate
    receipts for parachains that have \Pno candidate\Q status and once any
    such new candidate receipts is included on the relay chain it sets their
    availability status as \Pto be determined\Q.
  </enumerate-numeric>

  <\algorithm|<label|algo-signature-processing>Relay chain's signature
  processing>
    <\algorithmic>
      <state|TBD (from text above)>
    </algorithmic>
  </algorithm>

  Based on the result of Algorithm<nbsp><reference|algo-signature-processing>
  the validator node should mark a parachain block as either available or
  eventually unavailable according to definitions
  <reference|defn-available-parablock-proposal> and
  <reference|defn-unavailable-parablock-proposal>

  <\definition>
    <label|defn-available-parablock-proposal>Parachain blocks for which the
    corresponding blob is noted on the relay chain to be
    <with|font-series|bold|available>, meaning that the candidate receipt has
    been voted to be available by 2/3 validators.
  </definition>

  After a certain time-out in blocks since we first put the candidate receipt
  on the relay chain if there is not enough votes of availability the relay
  chain logic decides that a parachain block is unavailable, see
  <reference|algo-signature-processing>.

  <\definition>
    <label|defn-unavailable-parablock-proposal>An
    <with|font-series|bold|unavailabile> parachain block is TBS
  </definition>

  /syedSo to be clear we are not announcing unavailability we just keep it
  for grand pa vote

  <section|Publishing Attestations><label|sect-publishing-attestations>

  <syed||this is out of place. We can mentioned that we have two type of
  (validity) attestations in the intro but we just need to spec each
  attestation in its relevant section (which we did with the candidate
  receipt). <todo|move this to intro>> We have two type of attestations,
  primary and secondary. Primary attestations are signed by the parachain
  validators and secondary attestations are signed by secondary checkers and
  include the VRF that assigned them as a secondary checker into the
  attestation. Both types of attestations are included in the relay chain
  block as a transaction. For each parachain block candidate the relay chain
  keeps track of which validators have attested to its validity or
  invalidity.

  <section|Secondary Approval checking><label|sect-approval-checking>

  Once a parachain block is acted on we carry the secondary
  validity/availability checks as follows. A scheme assigns every validator
  to one or more PoV blocks to check its validity, see Section
  <reference|sect-shot-assignment> for details. An assigned validator
  acquires the PoV block (see Section <reference|sect-retrieval>) and checks
  its validity by comparing it to the candidate receipt. If validators
  notices that an equivocation has happened an additional
  validity/availability assignments will be made that is described in
  Section<reference|sect-equivocation-case>.

  <subsection|Approval Checker Assignment>

  Validators assign themselves to parachain block proposals as defined in
  Definition <reference|defn-para-proposal>. The assignment needs to be
  random. Validators use their own VRF to sign the VRF output from the
  current relay chain block as described in Section
  <reference|sect-vrf-comp>. Each validator uses the output of the VRF to
  decide the block(s) they are revalidating as a secondary checker. See
  Section <reference|sect-shot-assignment> for the detail.

  In addition to this assignment some extra validators are assigned to every
  PoV block which is descirbed in Section <reference|sect-extra-validation>.

  <subsection|VRF computation><label|sect-vrf-comp>

  Every validator needs to run Algorithm <reference|algo-checker-vrf> for
  every Parachain <math|\<rho\>> to determines assignments. <todo|Fix this.
  It is incorrect so far.>

  <\algorithm|<label|algo-checker-vrf><name|VRF-for-Approval>(<math|B>,<math|z>,
  <math|s<rsub|k>>)>
    <\algorithmic>
      <algo-require|<math|B>: the block to be approved>
      <algo-require|<math|z>: randomness for approval assignment>
      <algo-require|<math|s<rsub|k>>: session secret key of validator
      planning to participate in approval>

      <state|<math|<around|(|\<pi\>,d|)>\<leftarrow\>VRF<around|(|H<rsub|h><around|(|B|)>,sk<around|(|z|)>|)>>>

      <algo-return|<math|<around|(|\<pi\>,d|)>>>
    </algorithmic>
  </algorithm>

  Where <with|font-shape|small-caps|VRF> function is defined in
  <cite|polkadot-crypto-spec>.

  <subsection|One-Shot Approval Checker Assignment><label|sect-shot-assignment>

  Every validator <math|v> takes the output of this VRF computed by
  <reference|algo-checker-vrf> mod the number of parachain blocks that we
  were decided to be available in this relay chain block according to
  Definition <reference|defn-available-parablock-proposal> and executed. This
  will give them the index of the PoV block they are assigned to and need to
  check. The procedure is formalised in <reference|algo-one-shot-assignment>.

  <\algorithm|<label|algo-one-shot-assignment><name|OneShotAssignment>>
    <\algorithmic>
      <state|TBS>
    </algorithmic>
  </algorithm>

  <subsection|Extra Approval Checker Assigment><label|sect-extra-validation>

  Now for each parachain block, let us assume we want <math|#VCheck>
  validators to check every PoV block during the secondary checking. Note
  that <math|#VCheck> is not a fixed number but depends on reports from
  collators or fishermen. Lets us <math|#VDefault> be the minimum number of
  validator we want to check the block, which should be the number of
  parachain validators plus some constant like <math|2>. We set

  <\equation*>
    #VCheck=#VDefault+c<rsub|f>\<ast\><math-up|total fishermen stake>
  </equation*>

  where <math|c<rsub|f>> is some factor we use to weight fishermen reports.
  Reports from fishermen about this

  Now each validator computes for each PoV block a VRF with the input being
  the relay chain block VRF concatenated with the parachain index.

  For every PoV bock, every validator compares <math|#VCheck-#VDefault> to
  the output of this VRF and if the VRF output is small enough than the
  validator checks this PoV blocks immediately otherwise depending on their
  difference waits for some time and only perform a check if it has not seen
  <math|#VCheck> checks from validators who either 1) parachain validators of
  this PoV block 2) or assigned during the assignment procedure or 3) had a
  smaller VRF output than us during this time.

  More fisherman reports can increase <math|#VCheck> and require new checks.
  We should carry on doing secondary checks for the entire fishing period if
  more are required. A validator need to keep track of which blocks have
  <math|#VCheck> smaller than the number of higher priority checks performed.
  A new report can make us check straight away, no matter the number of
  current checks, or mean that we need to put this block back into this set.
  If we later decide to prune some of this data, such as who has checked the
  block, then we'll need a new approach here.

  <\algorithm|<label|algo-extra-assignment><name|OneShotAssignment>>
    <\algorithmic>
      <state|TBS>
    </algorithmic>
  </algorithm>

  <syed||<todo|so assignees are not announcing their assignment just the
  result of the approval check I assume>>

  <subsection|Additional Checking in Case of
  Equivocation><label|sect-equivocation-case>

  In the case of a relay chain equivocation, i.e. a validator produces two
  blocks with the same VRF, we do not want the secondary checkers for the
  second block to be predictable. To this end we use the block hash as well
  as the VRF as input for secondary checkers VRF. So each secondary checker
  is going to produce twice as many VRFs for each relay chain block that was
  equivocated. If either of these VRFs is small enough then the validator is
  assigned to perform a secondary check on the PoV block. The process is
  formalized in Algorithm <reference|algo-equivocation-assigment>

  <\algorithm|<label|algo-equivocation-assigment><name|EquivocatedAssignment>>
    <\algorithmic>
      <state|TBS>
    </algorithmic>
  </algorithm>

  <section|The Approval Check>

  Once a validator has a VRF which tells them to check a block, they announce
  this VRF and attempt to obtain the block. It is unclear yet whether this is
  best done by requesting the PoV block from parachain validators or by
  announcing that they want erasure-encoded chunks.

  <subsubsection|Retrieval><label|sect-retrieval>

  There are two fundamental ways to retrieve a parachain block for checking
  validity. One is to request the whole block from any validator who has
  attested to its validity or invalidity. Assigned appoval checker <math|v>
  sends RequestWholeBlock message specified in Definition
  <reference|defn-msg-request-whole-block> to <syed||any/all> parachain
  validator in order to receive the specific parachain block. Any parachain
  validator receiving must reply with PoVBlockRespose message defined in
  Definition <reference|defn-pov-block-response>

  <\definition>
    <label|defn-msg-request-whole-block> Request Whole Block Message TBS
  </definition>

  <\definition>
    <label|defn-pov-block-response><with|font-series|bold|PoV Block Respose
    Message> TBS
  </definition>

  The second method is to retrieve enough erasure-encoded chunks to
  reconstruct the block from them. In the latter cases an announcement of the
  form specified in Definition has to be gossiped to all validators
  indicating that one needs the erasure-encoded chunks.

  <\definition>
    <label|defn-erasure-coded-chunks-request><with|font-series|bold|Erasuree-coded
    chunks request message> TBS
  </definition>

  On their part, when a validator receive a erasuree-coded chunks request
  message it response with the message specified in Definition
  <reference|defn-erasure-coded-chunks-response>.

  <\definition>
    <label|defn-erasure-coded-chunks-response><with|font-series|bold|Erasuree-coded
    chunks response message> TBS
  </definition>

  Assigned appoval checker <math|v> must retrieve enough erasure-encoded
  chunks of the block they are verifying to be able to reconstruct the block
  and the erasure chunks tree.

  <subsubsection|Reconstruction><label|>

  After receiving <math|2*f+1> of erasure chunks every assigned approval
  checker <math|v> needs to recreate the entirety of the erasure code, hence
  every <math|v> will run Algorithm <reference|algo-reconstruct-pov> to make
  sure that the code is complete and the subsequently recover the original
  <math|<wide|B|\<bar\>>>.

  <\algorithm|<label|algo-reconstruct-pov><name|Reconstruct-PoV-Erasure>(<math|S<rsub|Er<rsub|B>>>)>
    <\algorithmic>
      <algo-require|<math|S<rsub|Er<rsub|B>>\<assign\><around|(|e<rsub|j<rsub|1>>,m<rsub|j<rsub|1>>|)>,\<cdot\>,<around|(|e<rsub|j<rsub|k>>,m<rsub|j<rsub|k>>|)>)>
      such that <math|k\<gtr\>2*f>>

      <state|<math|<wide|B|\<bar\>>\<rightarrow\>>
      <with|font-shape|small-caps|Erasure-Decoder>(<math|e<rsub|j<rsub|1>>,\<cdots\>,e<rsub|j<rsub|k>>>)>

      <\algo-if-else-if|<with|font-shape|small-caps|Erasure-Decoder>
      <with|font-series|bold|failed>>
        <state|<with|font-shape|small-caps|Announce-Failure>>

        <algo-return|>
      </algo-if-else-if>

      <state|<math|Er<rsub|B>\<rightarrow\>>
      <with|font-shape|small-caps|Erasure-Encoder>(<math|<wide|B|\<bar\>>>)>

      <\algo-if-else-if|<with|font-shape|small-caps|Verify-Merkle-Proof>(<math|S<rsub|Er<rsub|B>>>,<math|Er<rsub|B>>)
      <with|font-series|bold|failed>>
        <state|<with|font-shape|small-caps|Announce-Failure>>

        <algo-return|>
      </algo-if-else-if>

      <algo-return|<math|<wide|B|\<bar\>>>>
    </algorithmic>
  </algorithm>

  <subsection|Verification>

  Once the parachain bock has been obtained or reconstructed the secondary
  checker needs to execute the PoV block. We declare a the candidate receipt
  as invalid if one one the following three conditions hold: 1) While
  reconstructing if the erasure code does not have the claimed Merkle root,
  2) the validation function says that the PoV block is invalid, or 3) the
  result of executing the block is inconsistent with the candidate receipt on
  the relay chain.

  The procedure is formalized in Algorithm

  <\algorithm|<label|algo-revalidating-reconstructed-pov><name|RevalidatingReconstructedPoV>>
    <\algorithmic>
      <state|TBS>
    </algorithmic>
  </algorithm>

  If everything checks out correctly, we declare the block is valid. This
  means gossiping an attestation, including a reference that identifies
  candidate receipt and our VRF as specified in Definition
  <reference|defn-secondary-appoval-attestation>.

  <\definition>
    <label|defn-secondary-appoval-attestation><with|font-series|bold|Secondary
    approval attetstion message> TBS
  </definition>

  <subsection|Process validity and invalidity messages>

  When a Black produced receive a Secondary approval attetstion message, it
  execute Algorithm <reference|algo-verify-approval-attestation> to verify
  the VRF and may need to judge when enough time has passed.

  <\algorithm|<label|algo-verify-approval-attestation><name|VerifyApprovalAttestation>>
    <\algorithmic>
      <state|TBS>
    </algorithmic>
  </algorithm>

  These attestations are included in the relay chain as a transaction
  specified in

  <\definition>
    <label|defn-approval-attestation-transaction><with|font-series|bold|Approval
    Attestation Transaction> TBS
  </definition>

  Collators reports of unavailability and invalidty specified in Definition
  <todo|Define these messages> also go onto the relay chain as well in the
  format specified in Definition

  <\definition>
    <label|defn-collator-invalidity-transaction><with|font-series|bold|Collator
    Invalidity Transaction> TBS
  </definition>

  <\definition>
    <label|defn-collator-unavailability-transaction><with|font-series|bold|Collator
    unavailability Transaction> TBS
  </definition>

  <subsection|Invalidity Escalation><label|sect-escalation>

  When for any candidate receipt, there are attestations for both its
  validity and invalidity, then all validators acquire and validate the blob,
  irrespective of the assignments from section by executing Algorithm
  <reference|algo-reconstruct-pov> and <reference|algo-revalidating-reconstructed-pov>.

  We do not vote in GRANDPA for a chain were the candidate receipt is
  executed until its vote is resolved. If we have <math|n> validators, we
  wait for <math|\<gtr\>2*n/3> of them to attest to the blob and then the
  outcome of this vote is one of the following:

  If <math|\<gtr\>n/3> validators attest to the validity of the blob and
  <math|\<leq\>n/3> attest to its invalidity, then we can vote on the chain
  in GRANDPA again and slash validators who attested to its invalidity.

  If <math|\<gtr\>n/3> validators attest to the invalidity of the blob and
  <math|\<leq\>n/3> attest to its validity, then we consider the blob as
  invalid. If the rely chain block where the corresponding candidate receipt
  was executed was not finalised, then we never vote on it or build on it. We
  slash the validators who attested to its validity.

  If <math|\<gtr\>n/3> validators attest to the validity of the blob and
  <math|\<gtr\>n/3> attest to its invalidity then we consider the blob to be
  invalid as above but we do not slash validators who attest either way. We
  want to leave a reasonable length of time in the first two cases to slash
  anyone to see if this happens.

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  <section|Parachain Runtime Entries>

  The parachain Runtime exposes a couple of functions to the parachain Host
  implementation. It should be noted that the API can change through
  parachain Runtime updates. Therefore, a host should check the API versions
  of each module returned in the <verbatim|api> field by
  <verbatim|Core_version> (Section <reference|sect-runtime-core-module>)
  after every Runtime upgrade and warn if an updated API is encountered and
  that this might require an update of the host. The Runtime call convention
  is the same as for the relay chain Runtime, as defined in Defintion
  <reference|defn-runtime-api-convention>.

  <subsection|Core Module><label|sect-runtime-core-module>

  The Core module of the parachain Runtime is identical to the Core module of
  the Polkadot relay chain as described in Section
  <reference|sect-runtime-core-module>.

  <subsection|Metadata Module>

  The Metadata module of the parachain Runtime is identical to the Metadata
  module of the Polkadot relay chain as described in Section
  <reference|sect-runtime-metadata-module>.

  <subsection|BlockBuilder Module>

  The BlockBuilder module of the parachain Runtime is identical to the
  BlockBuilder module of the Polkadot relay chain as described in Section
  <reference|sect-runtime-blockbuilder-module>.

  <subsection|TaggedTransactionQueue Module>

  The TaggedTransactionQueue module of the parachain Runtime is identical to
  the TaggedTransactionQueue module of the Polkadot relay chain as described
  in Section <reference|sect-runtime-txqueue-module>.

  <subsection|OffchainWorkerApi Module>

  The OffchainWorkerApi module of the parachain Runtime is identical to the
  OffchainWorkerApi module of the Polkadot relay chain as described in
  Section <reference|sect-runtime-offchainapi-module>.

  <subsection|SessionKeys Module>

  The SessionKeys module of the parachain Runtime is identical to the
  SessionKeys module of the Polkadot relay chain as described in Section
  <reference|sect-runtime-sessionkeys-module>.

  <subsection|AuraApi Module>

  <todo|is this required?>

  <subsection|CollectCollationInfo Module>

  <subsubsection|CollectCollationInfo_collect_collation_info><label|sect-runtime-collect-collation-info>

  Returns the collation info, which is required for creating new collations
  as described in Section <reference|sect-parachain-block-production>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>Returns the collation info, which is a datastructure of the
    following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|>|<cell|<around*|\<nobracket\>|<around*|(|M<rsub|u>,M<rsub|h>,R<rsub|p>,N<rsub|q>,N<rsub|m>|\<nobracket\>>|)>>|<cell|>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|M<rsub|u>> is a sequence of upward messages, represented as
      byte arrays, to be interpreted by the Polkadot relay chain itself.

      <item><math|M<rsub|h>> is a sequence of outbound HRMP messages as
      defined in Definition <todo|todo> sent by the parachain.

      <item><math|R<rsub|p>> is the varying type <verbatim|Option> as defined
      in Definition <reference|defn-option-type> which can contain a new
      Runtime for the parachain, represented as a byte array.

      <item><math|N<rsub|q>> is the number of messages processed from the DMQ
      <todo|todo>.

      <item><math|N<rsub|m>> is the watermark indicated as a block number up
      to which all i nbound HRMP messages are processed.
    </itemize-dot>
  </itemize-dot>
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|6>
    <associate|save-aux|false>
  </collection>
</initial>