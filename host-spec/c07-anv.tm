<TeXmacs|1.99.11>

<project|host-spec.tm>

<style|<tuple|generic|std-latex>>

<\body>
  <assign|blobB|<macro|<math|<wide|B|\<bar\>>>>><assign|PoVB|<macro|<math|PoV<rsub|B>>>><assign|paraValidSet|<macro|<math|\<cal-V\><rsub|\<rho\>>>>>

  <chapter|Availability & Validity>

  <section|Introduction>

  Validators are responsible for guaranteeing the validity and availability
  of PoV blocks. There are two phases of validation that takes place in the
  AnV protocol.

  The primary validation check is carried out by parachain validators who are
  assigned to the parachain which has produced the PoV block as described in
  Section <reference|sect-primary-validation>. Once parachain validators have
  validated a parachain's PoV block successfully, they have to announce that
  according to the procedure described in Section
  <reference|sect-primary-validaty-announcement> where they generate a
  statement that includes the parachain header with the new state root and
  the XCMP message root. This candidate receipt and attestations, which
  carries signatures from other parachain validators is put on the relay
  chain.

  As soon as the proposal of a PoV block is on-chain, the parachain
  validators break the PoV block into erasure-coded chunks as described in
  Section <reference|defn-erasure-coded-chunks> and distribute them among all
  validators. See Section <reference|sect-distribute-chunks> for details on
  how this distribution takes place.

  Once validators have received erasure-coded chunks for several PoV blocks
  for the current relay chain block (that might have been proposed a couple
  of blocks earlier on the relay chain), they announce that they have
  received the erasure coded chunks on the relay chain by voting on the
  received chunks, see Section <reference|sect-voting-on-availability> for
  more details.

  As soon as <math|\<gtr\>2/3> of validators have made this announcement for
  any parachain block we <em|act on> the parachain block. Acting on parachain
  blocks means we update the relay chain state based on the candidate receipt
  and considered the parachain block to have happened on this relay chain
  fork.

  After a certain time, if we did not collect enough signatures approving the
  availability of the parachain data associated with a certain candidate
  receipt we decide this parachain block is unavailable and allow alternative
  blocks to be built on its parent parachain block, see
  <reference|sect-processing-availability>.

  The secondary check described in Section
  <reference|sect-approval-checking>, is done by one or more randomly
  assigned validators to make sure colluding parachain validators may not get
  away with validating a PoV block that is invalid and not keeping it
  available to avoid the possibility of being punished for the attack.

  During any of the phases, if any validator announces that a parachain block
  is invalid then all validators obtain the parachain block and check its
  validity, see Section <reference|sect-escalation> for more details.

  All validity and invalidity attestations go onto the relay chain, see
  Section <reference|sect-publishing-attestations> for details. If a
  parachain block has been checked at least by certain number of validators,
  the rest of the validators continue with voting on that relay chain block
  in the GRANDPA protocol. Note that the block might be challenged later.

  <section|Preliminaries>

  <\definition>
    <label|defn-scale-codec>The Polkadot project uses the
    <with|font-series|bold|SCALE codec> to encode common data types such as
    integers, byte arrays, varying data types as well as other data
    structure. The SCALE codec is defined in a separate document known as
    "The Polkadot Host - Protocol Specification". <todo|@fabio: link to
    document>
  </definition>

  <\definition>
    In the remainder of this chapter we assume that <math|\<rho\>> is a
    Polkadot Parachain and <math|B> is a block which has been produced by
    <math|\<rho\>> and is supposed to be approved to be <math|\<rho\>>'s next
    block. By <math|R<rsub|\<rho\>>> we refer to the
    <with|font-series|bold|validation code> of parachain <math|\<rho\>> as a
    WASM blob, which is responsible for validating the corresponding
    Parachain's blocks.
  </definition>

  <\definition>
    <label|defn-witness-proof>The <with|font-series|bold|witness proof> of block <math|B>,
    denoted by <with|font-series|bold|mode|math|\<pi\><rsub|B>>, is the set
    of all the external data which has gathered while the <math|\<rho\>>
    runtime executes block <math|B>. The data suffices to re-execute
    <math|R<rsub|\<rho\>>> against <math|B> and achieve the final state
    indicated in the <math|H<around|(|B|)>>.
  </definition>

  This witness proof consists of light client proofs of state data that are
  generally Merkle proofs for the parachain state trie. We need this because
  validators do not have access to the parachain state, but only have the
  state root of it.

  <\definition>
    <label|defn-pov-block>Accordingly we define the
    <with|font-series|bold|proof of validity block> or
    <with|font-series|bold|PoV> block in short,
    <with|font-series|bold|mode|math|<PoVB>>, to be the tuple:

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

  Parachain validators get this extra validation data from the current relay
  chain state. Note that a PoV block can be paired with different extra
  validation data depending on when and which relay chain fork it is included
  in. Future validators would need this extra validation data because since
  the candidate receipt as defined in Definition
  <reference|defn-candidate-receipt> was included on the relay chain the
  needed relay chain state may have changed.

  <\definition>
    <label|defn-upgrade-indicator><math|R<rsup|up><rsub|\<rho\>>> is an
    varying data type (Definition <reference|defn-scale-codec>) which implies
    whether the parachain is allowed to upgrade its validation code.

    <\equation*>
      R<rsup|up><rsub|\<rho\>>\<assign\>Option<around|(|H<rsub|i><around|(|B<rsup|relay><rsub|chain>|)>+n|)>
    </equation*>

    <todo|@fabio: adjust formula?>

    If this is <math|Some>, it contains the number of the minimum relay
    chain height at which the upgrade will be applied, assuming an upgrade is
    currently signaled <todo|@fabio: where is this signaled?>. A parachain
    should enact its side of the upgrade at the end of the first parachain
    block executing in the context of a relay-chain block with at least this
    height. This may be equal to the current perceived relay-chain block
    height, in which case the code upgrade should be applied at the end of
    the signaling block.
  </definition>

  <\definition>
    <label|defn-extra-validation-data>The <with|font-series|bold|validation
    parameters>, <math|v<rsup|VP><rsub|B>>, is an extra input to the
    validation function, i.e. additional data from the relay chain state that
    is needed. It's a tuple of the following format:

    <\equation*>
      vp<rsub|B>\<assign\><around|(|B,head<around|(|B<rsub|p>|)>,v<rsup|GVS><rsub|B>,R<rsup|up><rsub|\<rho\>>|)>
    </equation*>

    where each value represents:

    <\itemize>
      <item><math|B>: the parachain block itself.

      <item><math|head<around|(|B<rsub|p>|)>>: the parent head data (Definition
      <reference|defn-head-data>) of block <math|B>.

      <item><math|v<rsup|GVP><rsub|B>>: the global validation parameters
      (<reference|defn-global-validation-parameters>).

      <item><math|R<rsup|up><rsub|\<rho\>>>: implies whether the parachain
      is allowed to upgrade its validation code (Definition
      <reference|defn-upgrade-indicator>).
    </itemize>
  </definition>

  <\definition>
    <label|defn-global-validation-parameters>The
    <with|font-series|bold|global validation parameters>,
    <math|v<rsup|GVP><rsub|B>>, defines global data that apply to all
    candidates in a block.

    <\equation*>
      v<rsup|GVS><rsub|B>\<assign\><around|(|Max<rsup|R><rsub|size>,Max<rsup|head><rsub|size>,H<rsub|i><around|(|B<rsup|relay><rsub|chain>|)>|)>
    </equation*>

    where each value represents:

    <\itemize>
      <item><math|Max<rsup|R><rsub|size>>: the maximum amount of bytes
      of the parachain Wasm code permitted.

      <item><math|Max<rsup|head><rsub|size>>: the maximum amount of
      bytes of the head data (Definition <reference|defn-head-data>) permitted.

      <item><math|H<rsub|i><around|(|B<rsup|relay><rsub|chain>|)>>:
      the relay chain block number this is in the context of.
    </itemize>
  </definition>

  <\definition>
    <label|defn-local-validation-parameters>The <with|font-series|bold|local
    validation parameters>, <math|v<rsup|LVP><rsub|B>>, defines
    parachain-specific data required to fully validate a block. It is a tuple
    of the following format:

    <\equation*>
      v<rsup|LVP><rsub|B>\<assign\><around|(|head<around|(|B<rsub|p>|)>,UINT128,Blake2b<around|(|R<rsub|\<rho\>>|)>,R<rsup|up><rsub|\<rho\>>|)>
    </equation*>

    where each value represents:

    <\itemize>
      <item><math|head<around|(|B<rsub|p>|)>>: the parent head data (Definition
      <reference|defn-head-data>) of block <math|B>.

      <item><math|UINT128>: the balance of the parachain at the moment of
      validation.

      <item><math|Blake2b<around|(|R<rsub|\<rho\>>|)>>: the Blake2b
      hash of the validation code used to execute the candidate.

      <item><math|R<rsup|up><rsub|\<rho\>>>: implies whether the parachain
      is allowed to upgrade its validation code (Definition
      <reference|defn-upgrade-indicator>).
    </itemize>
  </definition>

  <\definition>
    The <with|font-series|bold|validation result>, <math|r<rsub|B>>, is
    returned by the validation code <math|R<rsub|\<rho\>>> if the provided
    candidate is is valid. It is a tuple of the following format:

    <alignat*|2|<tformat|<table|<row|<cell|r<rsub|B>>|<cell|\<assign\><around|(|head<around|(|B|)>,Option<around|(|P<rsup|B><rsub|\<rho\>>|)>,<around|(|Msg<rsub|0>,...,Msg<rsub|n>|)>,UINT32|)>>>|<row|<cell|Msg>|<cell|\<assign\><around|(|\<bbb-O\>,Enc<rsub|SC><around|(|b<rsub|0>,..
    b<rsub|n>|)>|)>>>>>>

    where each value represents:

    <\itemize>
      <item><math|head<around|(|B|)>>: the new head data (Definition
      <reference|defn-head-data>) of block <math|B>.

      <item><math|Option<around|(|P<rsup|B><rsub|\<rho\>>|)>>: a varying
      data (Definition <reference|defn-scale-codec>) containing an update to the
      validation code that should be scheduled in the relay chain.

      <item><math|Msg>: parachain "upward messages" to the relay chain.
      <math|\<bbb-O\>> identifies the origin of the messages and is a varying
      data type (Definition <reference|defn-scale-codec>) and can be one of the
      following values:

      <\equation*>
        \<bbb-O\>=<choice|<tformat|<table|<row|<cell|0,>|<cell|<text|Signed>>>|<row|<cell|1,>|<cell|<text|Parachain>>>|<row|<cell|2,>|<cell|<text|Root>>>>>>
      </equation*>

      <todo|@fabio: define the concept of "origin">

      The following SCALE encoded array, <math|Enc<rsub|SC><around|(|b<rsub|0>,..b<rsub|n>|)>>,
      contains the raw bytes of the message which varies in size.

      <item><math|UINT32>: number of downward messages that were
      processed by the Parachain. It is expected that the Parachain processes
      them from first to last.
    </itemize>
  </definition>

  <\definition>
    <label|defn-blob>Accordingly we define the
    <with|font-series|bold|erasure-encoded blob> or
    <with|font-series|bold|blob> in short,
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

  Note that in the code the blob is referred to as "AvailableData".

  <section|Overal process>

  The Figure <reference|diag-anv-overall> demonstrates the overall process of
  assuring availability and validity in Polkadot <todo|complete the Diagram>.

  <big-figure|<with|par-mode|center|<label|diag-anv-overall><image|figures/c07-overview.eps|1par|1pag||>
  >|Overall process to acheive availability and validity in Polkadot>

  <section|Candidate Selection><label|sect-primary-validation>

  Collators produce candidates (Definition <reference|defn-candidate>) and send
  those to validators. Validators verify the validity of the received
  candidates (Algo. <reference|algo-primary-validation>) by executing the
  validation code, <math|R<rsub|\<rho\>>>, and issue statements (Definition
  <reference|defn-gossip-statement>) about the candidates to connected peers.
  The validator ensures the that every candidate considered for inclusion has
  at least one other validator backing it. Candidates without backing are
  discarded.

  The validator must keep track of which candidates were submitted by
  collators, including which validators back those candidates in order to
  penalize bad behavior. This is described in more detail in section
  <reference|sect-primary-validaty-announcement>

  <\definition>
    <label|defn-candidate>A <with|font-series|bold|candidate>,
    <math|C<rsub|coll><around|(|PoV<rsub|B>|)>>, is issues by collators
    and contains the PoV block and enough data in order for any validator to
    verify its validity. A candidate is a tuple of the following format:

    <\equation*>
      C<rsub|coll><around|(|PoV<rsub|B>|)>\<assign\><around|(|id<rsub|p>,h<rsub|b><around|(|B<rsub|<rsup|relay><rsub|parent>>|)>,id<rsub|C>,Sig<rsup|Collator><rsub|SR25519>,head<around|(|B|)>,h<rsub|b><around|(|PoV<rsub|B>|)>|)>
    </equation*>

    where each value represents:

    <\itemize>
      <item><math|id<rsub|p>>: the Parachain Id this candidate is for.

      <item><math|h<rsub|b><around|(|B<rsub|<rsup|relay><rsub|parent>>|)>>:
      the hash of the relay chain block that this candidate should be
      executed in the context of.

      <item><math|id<rsub|C>>: the Collator relay-chain account ID as
      defined in Definition <todo|@fabio>.

      <item><math|Sig<rsup|Collator><rsub|SR25519>>: the signature
      on the 256-bit Blake2 hash of the block data by the collator.

      <item><math|head<around|(|B|)>>: the head data (Definition
      <reference|defn-head-data>) of block <math|B>.

      <item><math|h<rsub|b><around|(|PoV<rsub|B>|)>>: the 32-byte Blake2
      hash of the PoV block.
    </itemize>
  </definition>

  <\definition>
    <label|defn-head-data>The <with|font-series|bold|head data>,
    <math|head<around|(|B|)>>, of a parachain block is a tuple of the
    following format:

    <\equation*>
      head<around|(|B|)>\<assign\><around|(|H<rsub|i><around|(|B|)>,H<rsub|p><around|(|B|)>,H<rsub|r><around|(|B|)>|)>
    </equation*>

    Where <math|H<rsub|i><around|(|B|)>> is the block number of parachain
    block <math|B>, <math|H<rsub|p><around|(|B|)>> is the 32-byte Blake2 hash
    of the parent block header and <math|H<rsub|r><around|(|B|)>> represents
    the root of the post-execution state. <todo|@fabio: clarify if
    <math|H<rsub|p>> is the hash of the header or full block> <todo|@fabio:
    maybe define those symbols at the start (already defined in the Host
    spec)?>
  </definition>

  <\algorithm|<label|algo-primary-validation><name|PrimaryValidation>(<math|B>, <math|\<pi\><rsub|B>>, relay chain parent block <math|B<rsup|relay><rsub|parent>>)>
    <\algorithmic>
      <\state>
        Retrieve <math|v<rsub|B>> from the relay chain state at <math|B<rsup|relay><rsub|parent>>
      </state>

      <\state>
        Run Algorithm <reference|algo-validate-block> using <math|B,\<pi\><rsub|B>,v<rsub|B>>
      </state>
    </algorithmic>
  </algorithm>

  <\algorithm|<label|algo-validate-block><name|ValidateBlock>(<math|B,\<pi\><rsub|B>,v<rsub|B>>)>
    <\algorithmic>
      <state|retrieve the runtime code <math|R<rsub|\<rho\>>> that is specified by <math|v<rsub|B>> from the relay chain state.>

      <state|check that the initial state root in <math|\<pi\><rsub|B>> is the one claimed in <math|v<rsub|B>>>

      <state|Execute <math|R<rsub|\<rho\>>> on <math|B> using <math|\<pi\><rsub|B>> to simulate the state.>

      <state|If the execution fails, return fail.>

      <state|Else return success, the new header data <math|h<rsub|B>> and
      the outgoing messages <math|M>.>

      <todo|@fabio: same as head data?>
    </algorithmic>
  </algorithm>

  <section|Candidate Backing><label|sect-primary-validaty-announcement>

  Validators back the validity respectively the invalidity of candidates by
  extending those into candidate receipts as defined in Definition
  <reference|defn-candidate-receipt> and communicate those receipts by
  issuing statements as defined in Definition
  <reference|defn-gossip-statement>. Validator <math|v> needs to perform
  Algorithm <reference|algo-primary-validation-announcement> to announce the
  statement of primary validation to the Polkadot network. If the validator
  receives a statement from another validator, the candidate is confirmed
  based on algorithm <reference|algo-endorse-candidate-receipt>.

  As algorithm <reference|algo-primary-validation-announcement> and
  <reference|algo-endorse-candidate-receipt> clarifies, the validator should
  blacklist collators which send invalid candidates and announce this
  misbehavior. If another validator claims that an invalid candidates is
  actually valid, that misbehavior must be announced, too. <todo|@fabio>

  The validator tries to back as many candidates as it can, but does not
  attempt to prioritize specific candidates. Each validator decides on its
  own - on whatever metric - which candidate will ultimately get included in
  the block.

  <\definition>
    <label|defn-candidate-receipt>A <with|font-series|bold|candidate
    receipt>, <math|C<rsub|receipt><around|(|PoV<rsub|B>|)>>, is an
    extension of a candidate as defined in Definition
    <reference|defn-candidate> which includes additional information about
    the validator which verified the PoV block. The candidate receipt is
    communicated to other validators by issuing a statement as defined in
    Definition <reference|defn-gossip-statement>.

    This type is a tuple of the following format:

    <\equation*>
      C<rsub|receipt><around|(|PoV<rsub|B>|)>\<assign\><around|(|id<rsub|p>,h<rsub|b><around|(|B<rsub|<rsup|relay><rsub|parent>>|)>,head<around|(|B|)>,id<rsub|C>,Sig<rsup|Collator><rsub|SR25519>,h<rsub|b><around|(|PoV<rsub|B>|)>,Blake2b<around|(|CC<around|(|PoV<rsub|B>|)>|)>|)>
    </equation*>

    where each value represents:

    <\itemize>
      <item><math|id<rsub|p>>: the Parachain Id this candidate is for.

      <item><math|h<rsub|b><around|(|B<rsub|<rsup|relay><rsub|parent>>|)>>:
      the hash of the relay chain block that this candidate should be
      executed in the context of.

      <item><math|head<around|(|B|)>>: the head data (Definition
      <reference|defn-head-data>) of block <math|B>. <todo|@fabio (collator
      module relevant?)>.

      <item><math|id<rsub|C>>: the collator relay-chain account ID as
      defined in Definition <todo|@fabio>.

      <item><math|Sig<rsup|Collator><rsub|SR25519>>: the signature
      on the 256-bit Blake2 hash of the block data by the collator.

      <item><math|h<rsub|b><around|(|PoV<rsub|B>|)>>: the hash of the PoV
      block.

      <item><math|Blake2b<around|(|CC<around|(|PoV<rsub|B>|)>|)>>:
      The hash of the commitments made as a result of validation, as defined
      in Definition <reference|defn-candidate-commitments>.
    </itemize>
  </definition>

  <\definition>
    <label|defn-candidate-commitments><with|font-series|bold|Candidate
    commitments>, <math|CC<around|(|PoV<rsub|B>|)>>, are results of the
    execution and validation of parachain (or parathread) candidates whose
    produced values must be committed to the relay chain. A candidate
    commitments is represented as a tuple of the following format:

    <alignat*|2|<tformat|<table|<row|<cell|CC<around|(|PoV<rsub|B>|)>>|<cell|\<assign\><around|(|\<bbb-F\>,Enc<rsub|SC><around|(|Msg<rsub|0>,..,Msg<rsub|n>|)>,H<rsub|r><around|(|B|)>,Option<around|(|R<rsub|\<rho\>>|)>|)>>>|<row|<cell|Msg>|<cell|\<assign\><around|(|\<bbb-O\>,Enc<rsub|SC><around|(|b<rsub|0>,..
    b<rsub|n>|)>|)>>>>>>

    where each value represents:

    <\itemize>
      <item><math|\<bbb-F\>>: fees paid from the chain to the relay chain
      validators.

      <item><math|Msg>: parachain messages to the relay chain.
      <math|\<bbb-O\>> identifies the origin of the messages and is a varying
      data type (Definition <reference|defn-scale-codec>) and can be one of the
      following values:

      <\equation*>
        \<bbb-O\>=<choice|<tformat|<table|<row|<cell|0,>|<cell|<text|Signed>>>|<row|<cell|1,>|<cell|<text|Parachain>>>|<row|<cell|2,>|<cell|<text|Root>>>>>>
      </equation*>

      <todo|@fabio: define the concept of "origin">

      The following SCALE encoded array, <math|Enc<rsub|SC><around|(|b<rsub|0>,..b<rsub|n>|)>>,
      contains the raw bytes of the message which varies in size.

      <item><math|H<rsub|r><around|(|B|)>>: the root of a block's erasure
      encoding Merkle tree <todo|@fabio: use different symbol for this?>.

      <item><math|Option<around|(|R<rsub|\<rho\>>|)>>: A varying
      datatype (Definition <reference|defn-scale-codec>) containing the new runtime
      code for the parachain. <todo|@fabio: clarify further>
    </itemize>
  </definition>

  <\definition>
    <label|defn-gossip-pov-block>A <with|font-series|bold|Gossip PoV block> is a
    tuple of the following format:

    <\equation*>
      <around|(|h<rsub|b><around|(|B<rsub|<rsup|relay><rsub|parent>>|)>,h<rsub|b><around|(|C<rsub|coll><around|(|PoV<rsub|B>|)>|)>,PoV<rsub|B>|)>
    </equation*>

    where <math|h<rsub|b><around|(|B<rsub|<rsup|relay><rsub|parent>>|)>>
    is the block hash of the relay chain being referred to and
    <math|h<rsub|b><around|(|C<rsub|coll><around|(|PoV<rsub|B>|)>|)>>
    is the hash of some candidate localized to the same Relay chain block.
  </definition>

  <\definition>
    <label|defn-gossip-statement>A <with|font-series|bold|statement> notifies
    other validators about the validity of a PoV block. This type is a tuple
    of the following format:

    <\equation*>
      <around|(|Stmt,id<rsub|\<bbb-V\>>,Sig<rsup|Valdator><rsub|SR25519>|)>
    </equation*>

    where <math|Sig<rsup|Validator><rsub|SR25519>> is the
    signature of the validator and <math|id<rsub|\<bbb-V\>>> refers to the
    index of validator according to the authority set. <todo|@fabio: define
    authority set (specified in the Host spec)>. <math|Stmt> refers to a
    statement the validator wants to make about a certain candidate.
    <math|Stmt> is a varying data type (Definition <reference|defn-scale-codec>)
    and can be one of the following values:

    <\equation*>
      Stmt=<choice|<tformat|<table|<row|<cell|0,>|<cell|<text|Seconded,
      followed by: >C<rsub|receipt><around|(|PoV<rsub|B>|)>>>|<row|<cell|1,>|<cell|<text|Validity,
      followed by: >Blake2<around|(|C<rsub|coll><around|(|PoV<rsub|B>|)>|)>>>|<row|<cell|2,>|<cell|<text|Invalidity,
      followed by: >Blake2<around|(|C<rsub|coll><around|(|PoV<rsub|B>|)>|)>>>>>>
    </equation*>

    The main semantic difference between `Seconded` and `Valid` comes from
    the fact that every validator may second only one candidate per relay
    chain block; this places an upper bound on the total number of candidates
    whose validity needs to be checked. A validator who seconds more than one
    parachain candidate per relay chain block is subject to slashing.

    Validation does not directly create a seconded statement, but is rather
    upgraded by the validator when it choses to back a valid candidate as
    described in Algorithm <reference|algo-primary-validation-announcement>.
  </definition>

  <\algorithm|<label|algo-primary-validation-announcement><name|PrimaryValidationAnnouncement>(<math|PoV<rsub|B>>)>
    <\algorithmic>
      <state|<with|font-series|bold|Init> <math|Stmt>;>

      <\algo-if-else-if|<with|font-shape|small-caps|ValidateBlock>(<math|PoV<rsub|B>>) is <with|font-series|bold|valid>>

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

      <state|<math|PoV<rsub|B>\<leftarrow\>> <with|font-shape|small-caps|Retrieve>(<math|Stmt<rsub|peer>>)>

      <\algo-if-else-if|<with|font-shape|small-caps|ValidateBlock>(<math|PoV<rsub|B>>) is <with|font-series|bold|valid>>

        <\algo-if-else-if|<with|font-shape|small-caps|AlreadySeconded>(<math|B<rsup|relay><rsub|chain>>)>

          <state|<math|Stmt\<leftarrow\>><with|font-shape|small-caps|SetValid>(<math|PoV<rsub|B>>)>|

        <|algo-if-else-if>

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

  <subsection|Inclusion of candidate receipt on the relay
  chain><label|sect-inclusion-of-candidate-receipt>

  <todo|@fabio: should this be a subsection?>

  <\definition>
    <label|defn-para-proposal><with|font-series|bold|Parachain Block Proposal>, noted by
    <math|P<rsup|B><rsub|\<rho\>>>is a candidate receipt for a parachain
    block <math|B> for a parachain <math|\<rho\>> along with signatures for
    at least 2/3 of <math|\<cal-V\><rsub|\<rho\>>>.
  </definition>

  A block producer which observe a Parachain Block Proposal as defined in
  definition <reference|defn-para-proposal> <syed|may/should|?> include the
  proposal in the block they are producing according to Algorithm
  <reference|algo-include-parachain-proposal> during block production
  procedure.

  <\algorithm|<label|algo-include-parachain-proposal><name|IncludeParachainProposal>(<math|P<rsup|B><rsub|\<rho\>>>)>
    <\algorithmic>
      <state|TBS>
    </algorithmic>
  </algorithm>

  <section|PoV Distribution>

  <todo|@fabio>

  <subsection|Primary Validation Disagreement><label|sect-primary-validation-disagreemnt>

  <syed|Parachain|verify> validators need to keep track of candidate receipts
  (see Definition <reference|defn-candidate-receipt>) and validation failure
  messages of their peers. In case, there is a disagreement among the
  parachain validators about <math|<wide|B|\<bar\>>>, all parachain
  validators must invoke Algorithm <reference|algo-primary-validation-disagreemnt>

  <\algorithm|<label|algo-primary-validation-disagreemnt><name|PrimaryValidationDisagreement>>
    <\algorithmic>
      <state|TBS>
    </algorithmic>
  </algorithm>

  <section|Availability>

  Backed candidates must be widely available for the entire, elected
  validators set without requiring each of those to maintain a full copy. PoV
  blocks get broken up into erasure-encoded chunks and each validators keep
  track of how those chunks are distributed among the validator set. When a
  validator has to verify a PoV block, it can request the chunk for one of
  its peers.

  <\definition>
    <label|defn-erasure-encoder-decoder>The <with|font-series|bold|erasure
    encoder/decoder> <with|font-series|bold|<math|encode<rsub|k,n>/decoder<rsub|k,n>>
    >is defined to be the Reed-Solomon encoder defined in <cite|??>.
  </definition>

  <\algorithm|<label|algo-erasure-encode><name|Erasure-Encode>(<math|<wide|B|\<bar\>>>: blob defined in Definition <reference|defn-blob>)>
    <\algorithmic>

      <state|TBS>

      <state|<with|font-series|bold|Init> <math|Shards\<leftarrow\>> <with|font-shape|small-caps|Make-Shards>(<math|<paraValidSet>,v<rsub|B>>)>

      <statex|// Create a trie from the shards in order generate the trie nodes>

      <statex|// which are required to verify each chunk with a Merkle root>

      <state|<with|font-series|bold|Init> <math|Trie>>

      <state|<with|font-series|bold|Init> <math|index=0>>

      <\algo-for|<math|shard\<in\>Shards>>

        <state|<with|font-shape|small-caps|Insert>(<math|Trie,index>, <with|font-shape|small-caps|Blake2>(<math|shard>))>

        <state|<math|index=index+1>>

      </algo-for>

      <statex|// Insert individual chunks into collection (Definition <reference|defn-erasure-coded-chunks>).>

      <state|<with|font-series|bold|Init> <math|Er<rsub|B>>>

      <state|<with|font-series|bold|Init> <math|index=0>>

      <\algo-for|<math|shard\<in\>Shards>>

        <state|<with|font-series|bold|Init> <math|nodes\<leftarrow\>> <with|font-shape|small-caps|Get-Nodes>(<math|Trie,index>)>

        <state|<with|font-shape|small-caps|Add>(<math|Er<rsub|B>,<around|(|shard,index,nodes|)>>)>

        <state|<math|index=index+1>>
      </algo-for>

      <algo-return|<math|Er<rsub|B>>>

    </algorithmic>
  </algorithm>

  <\itemize>
    <item><with|font-shape|small-caps|Make-Shards(..)>: return shards for
    each validator as described in algorithm <reference|algo-make-shards>.
    Return value is defined as <math|<around|(|\<bbb-S\><rsub|0>,...,\<bbb-S\><rsub|n>|)>>
    where <math|\<bbb-S\>\<assign\><around|(|b<rsub|0>,...,b<rsub|n>|)>>

    <item><with|font-shape|small-caps|Insert(<math|trie,key,val>)>:
    insert the given <math|key> and <math|value> into the
    <math|trie>.

    <item><with|font-shape|small-caps|Get-Nodes(<math|trie,key>)>: based
    on the <math|key>, return all required <math|trie> nodes in order to
    verify the corresponding value for a (unspecified) Merkle root. Return
    value is defined as <math|<around|(|\<bbb-N\><rsub|0>,...,\<bbb-N\><rsub|n>|)>>
    where <math|\<bbb-N\>\<assign\><around|(|b<rsub|0>,...,b<rsub|n>|)>>.

    <item><with|font-shape|small-caps|Add(<math|sequence,item>)>:
    add the given <math|item> to the <math|sequence>.
  </itemize>

  <\algorithm|<label|algo-make-shards><name|Make-Shards>(<math|<paraValidSet>,v<rsub|B>>)>
    <\algorithmic>

      <statex| // Calculate the required values for Reed-Solomon.>

      <statex| // Calculate the required lengths.>

      <state|<with|font-series|bold|Init> <math|Shard<rsub|data>=<frac|<around|(|<around|\||<paraValidSet>|\|>-1|)>|3>+1>>

      <state|<with|font-series|bold|Init> <math|Shard<rsub|parity>=<around|\||<paraValidSet>|\|>-<frac|<around|(|<around|\||<paraValidSet>|\|>-1|)>|3>-1>>

      <\state>
        <\math>
          <with|font-series|bold|Init>base<rsub|len> = <choice|<tformat|<table|<row|<cell|0>|<cell|if<around|\||<paraValidSet>|\|><bmod>Shard<rsub|data>=0>>|<row|<cell|1>|<cell|if<around|\||<paraValidSet>|\|><bmod>Shard<rsub|data>\<neq\>0>>>>>
        </math>
      </state>

      <state|<with|font-series|bold|Init> <math|Shard<rsub|len> = base<rsub|len> + <around|(|base<rsub|len><bmod>2|)>>>

      <statex|// Prepare shards, each padded with zeroes.>

      <statex|// <math|Shards\<assign\><around|(|\<bbb-S\><rsub|0>,...,\<bbb-S\><rsub|n>|)>> where <math|\<bbb-S\>\<assign\><around|(|b<rsub|0>,...,b<rsub|n>|)>>>

      <state|<with|font-series|bold|Init> <math|Shards>>

      <\algo-for|<math|n\<in\><around|(|Shard<rsub|data>+Shard<rsub|partiy>|)>>>

        <state|<with|font-shape|small-caps|Add>(<math|Shards,<around|(|0<rsub|0>,.. 0<rsub|Shard<rsub|len>>|)>>)>

      </algo-for>

      <statex|// Copy shards of <math|v<rsub|b>> into each shard.>

      <\algo-for|<math|<around|(|chunk, shard|)>\<in\>>(<with|font-shape|small-caps|Take><math|<around|(|Enc<rsub|SC><around|(|v<rsub|B>|)>,Shard<rsub|len>|)>,Shards>)>

        <state|<with|font-series|bold|Init> <math|len\<leftarrow\>><with|font-shape|small-caps|Min>(<math|Shard<rsub|len>,<around|\||chunk|\|>>)>

        <state|<math|shard\<leftarrow\>> <with|font-shape|small-caps|Copy-From>(<math|chunk,len>)>

      </algo-for>

      <statex|// <math|Shards> contains split shards of <math|v<rsub|B>>.>

      <algo-return|<math|Shards>>
    </algorithmic>
  </algorithm>

  <\itemize>
    <item><with|font-shape|small-caps|Add(<math|sequence,item>)>:
    add the given <math|item> to the <math|sequence>.

    <item><with|font-shape|small-caps|Take(<math|sequence,len>)>:
    iterate over <math|len> amount of bytes from <math|sequence> on
    each iteration. If the <math|sequence> does not provide
    <math|len> number of bytes, then it simply uses what's available.

    <item><with|font-shape|small-caps|Min(<math|num1,num2>)>: return
    the minimum value of <math|num1> or <math|num2>.

    <item><with|font-shape|small-caps|Copy-From(<math|source,len>)>:
    return <math|len> amount of bytes from <math|source>.
  </itemize>

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

  Following the computation of <math|Er<rsub|B>>, <math|v> must construct
  the <math|<wide|B|\<bar\>>> Availability message defined in Definition
  <reference|defn-pov-erasure-chunk-message>. And distribute them to target
  validators designated by the Availability Networking Specification
  <cite|??>.

  <\definition>
    <label|defn-pov-erasure-chunk-message><with|font-series|bold|PoV erasure chunk message>
    <math|M<rsub|PoV<rsub|<wide|B|\<bar\>>>><around|(|i|)>> is TBS
  </definition>

  <section|Announcing Availability><label|sect-voting-on-availability>

  When validator <math|v> receives its designated chunk for
  <math|<wide|B|\<bar\>>> it needs to broadcast Availability vote message as
  defined in Definition<reference|defn-availability-vote-message>

  <\definition>
    <label|defn-availability-vote-message><with|font-series|bold|Availability vote message>
    <math|M<rsub|PoV><rsup|Avail,v<rsub|i>>> TBS
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
    <item>the availability status of the candidate receipt is "to be
    determined" on the relay chain at block hash <math|h<rsub|b>>
    <with|font-series|bold|and>

    <item><math|v> has the erasure coded chunk of the corresponding parachain
    block to this candidate receipt.
  </enumerate>

  These signatures go into a relay chain block.

  <subsection|Processing on-chain availability data><label|sect-processing-availability>

  This section explains how the availability attestations stored on the relay
  chain, as described in Section ??, are processed as follows:

  <\enumerate-numeric>
    <item>The relay chain stores the last vote from each validator on
      chain. For each new signature, the relay chain checks if it is for a
      block in this chain later than the last vote stored from this
      validator. If it is the relay chain updates the stored vote and updates
      the bitfield <math|b<rsub|v>> and block number of the vote.

    <item>For each block within the last <math|t> blocks where <math|t> is
      some timeout period, the relay chain computes a bitmask
      <math|bm<rsub|n>> (<math|n> is block number). This bitmask is a
      bitfield that represents whether the candidate considered in that block
      is still relevant. That is the <math|i>th bit of <math|bm<rsub|n>> is
      <math|1> if and only if for the <math|i>th parachain, (a) the
      availability status is to be determined and (b) candidate block number
      <math|\<leq\>n>

    <item>The relay chain initialises a vector of counts with one entry for
      each parachain to zero. After executing the following algorithm it
      ends up with a vector of counts of the number of validators who think
      the latest candidates is available.

      <\enumerate>
        <item>The relay chain computes <math|b<rsub|v>> and
        <math|bm<rsub|n>> where <math|n> is the block number of the
        validator's last vote

        <item>For each bit in <math|b<rsub|v>> and <math|bm<rsub|n>> 
        add the <math|i>th bit to the <math|i>th count.
      </enumerate>

    <item>For each count that is <math|\<gtr\>2/3> of the number of
      validators, the relay chain sets the candidates status to
      \\"available\\". Otherwise, if the candidate is at least <math|t>
      blocks old, then it sets its status to \\"unavailable\\".

    <item>The relay chain acts on available candidates and discards
      unavailable ones, and then clears the record, setting the availability
      status to \\"no candidate\\". Then the relay chain accepts new
      candidate receipts for parachains that have \\"no candidate: status and
      once any such new candidate receipts is included on the relay chain it
      sets their availability status as \\"to be determined\\".

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
    corresponding blob is noted on the relay chain to be <with|font-series|bold|available>,
    meaning that the candidate receipt has been voted to be available by 2/3
    validators.
  </definition>

  After a certain time-out in blocks since we first put the candidate receipt
  on the relay chain if there is not enough votes of availability the relay
  chain logic decides that a parachain block is unavailable, see
  <reference|algo-signature-processing>.

  <\definition>
    <label|defn-unavailable-parablock-proposal>An <with|font-series|bold|unavailabile> parachain
    block is TBS
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
  acquires the PoV block (see Section <reference|sect-retrieval>) and
  checks its validity by comparing it to the candidate receipt. If validators
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

  <\algorithm|<label|algo-checker-vrf><name|VRF-for-Approval>(<math|B>,<math|z>, <math|s<rsub|k>>)>
    <\algorithmic>

      <algo-require|<math|B>: the block to be approved>
      <algo-require|<math|z>: randomness for approval assignment>
      <algo-require|<math|s<rsub|k>>: session secret key of validator planning to participate in approval>

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
  collators or fishermen. Lets us <math|#VDefault> be the minimum
  number of validator we want to check the block, which should be the number
  of parachain validators plus some constant like <math|2>. We set

  <\equation*>
    #VCheck=#VDefault+c<rsub|f>\<ast\><math-up|total fishermen
    stake>
  </equation*>

  where <math|c<rsub|f>> is some factor we use to weight fishermen reports.
  Reports from fishermen about this

  Now each validator computes for each PoV block a VRF with the input being
  the relay chain block VRF concatenated with the parachain index.

  For every PoV bock, every validator compares
  <math|#VCheck-#VDefault> to the output of this VRF and if the
  VRF output is small enough than the validator checks this PoV blocks
  immediately otherwise depending on their difference waits for some time and
  only perform a check if it has not seen <math|#VCheck> checks from
  validators who either 1) parachain validators of this PoV block 2) or
  assigned during the assignment procedure or 3) had a smaller VRF output
  than us during this time.

  More fisherman reports can increase <math|#VCheck> and require new
  checks. We should carry on doing secondary checks for the entire fishing
  period if more are required. A validator need to keep track of which blocks
  have <math|#VCheck> smaller than the number of higher priority checks
  performed. A new report can make us check straight away, no matter the
  number of current checks, or mean that we need to put this block back into
  this set. If we later decide to prune some of this data, such as who has
  checked the block, then we'll need a new approach here.

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
    <label|defn-pov-block-response><with|font-series|bold|PoV Block Respose Message> TBS
  </definition>

  The second method is to retrieve enough erasure-encoded chunks to
  reconstruct the block from them. In the latter cases an announcement of the
  form specified in Definition has to be gossiped to all validators
  indicating that one needs the erasure-encoded chunks.

  <\definition>
    <label|defn-erasure-coded-chunks-request><with|font-series|bold|Erasuree-coded chunks
    request message> TBS
  </definition>

  On their part, when a validator receive a erasuree-coded chunks request
  message it response with the message specified in Definition
  <reference|defn-erasure-coded-chunks-response>.

  <\definition>
    <label|defn-erasure-coded-chunks-response><with|font-series|bold|Erasuree-coded chunks
    response message> TBS
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

    <state|<math|<wide|B|\<bar\>>\<rightarrow\>> <with|font-shape|small-caps|Erasure-Decoder>(<math|e<rsub|j<rsub|1>>,\<cdots\>,e<rsub|j<rsub|k>>>)>

    <\algo-if-else-if|<with|font-shape|small-caps|Erasure-Decoder> <with|font-series|bold|failed>>

      <state|<with|font-shape|small-caps|Announce-Failure>>

      <algo-return|>

    </algo-if-else-if>

    <state|<math|Er<rsub|B>\<rightarrow\>> <with|font-shape|small-caps|Erasure-Encoder>(<math|<wide|B|\<bar\>>>)>

    <\algo-if-else-if|<with|font-shape|small-caps|Verify-Merkle-Proof>(<math|S<rsub|Er<rsub|B>>>,<math|Er<rsub|B>>) <with|font-series|bold|failed>>

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
    <label|defn-secondary-appoval-attestation><with|font-series|bold|Secondary approval
    attetstion message> TBS
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
    <label|defn-approval-attestation-transaction><with|font-series|bold|Approval Attestation
    Transaction> TBS
  </definition>

  Collators reports of unavailability and invalidty specified in Definition
  <todo|Define these messages> also go onto the relay chain as well in the
  format specified in Definition

  <\definition>
    <label|defn-collator-invalidity-transaction><with|font-series|bold|Collator Invalidity
    Transaction> TBS
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
</body>
