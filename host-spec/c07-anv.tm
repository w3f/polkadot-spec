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
      <tformat|<table|<row|<cell|B<rsub|b>>|<cell|=>|<cell|<around*|(|H<around*|(|B|)>,B,H<rsub|r>|)>>>|<row|<cell|B>|<cell|=>|<cell|<around*|(|e<rsub|n>,\<ldots\>e<rsub|m>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|H<around*|(|B|)>> is the header of the block as described
      in Definition <reference|defn-block-header>.

      <item><math|B> is the body of the block, expressed as an array of zero
      or more extrinsics, <math|e<rsub|n>>, which are SCALE encoded byte
      arrays and its structure is opaque to the Polkadot Host.

      <item><math|H<rsub|r>> is the Merkle root of the parachain state at
      this block as described in Section <reference|sect-merkl-proof>
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-pov-block>A <with|font-series|bold|proof of validity block>
    or <with|font-series|bold|PoV> block contains witness data to\ 

    <\equation*>
      <around|(|B,w|)>
    </equation*>

    A PoV block is an extracted Merkle subtree, attached to the block.
    <todo|@fabio: clarif this>
  </definition>

  <\definition>
    <label|defn-para-id>The <strong|Parachain Id> is an unsigned 32-bit
    integer which serves as an identifier of a parachain, assigned by the
    Runtime.
  </definition>

  <\definition>
    <strong|<label|defn-availability-cores>Availability cores> are a Runtime
    concept used to process parachains.\<#2018\>a Each parachain gets
    assigned to a availability core and validators can fetch information
    about the cores, such as parachain block candidates, by calling the
    appropriate Runtime API as described in Section
    <reference|sect-rt-api-availability-cores>. Validators are not concerned
    with the internal workings from the Runtimes perspective.
  </definition>

  <\definition>
    <strong|<label|defn-validator-groups>Validator groups> are a Runtime
    concept for how validators are assigned to certain parachains. Those
    assigned validators are responsible for backing parachain block
    candidates as explained further in Section
    <reference|sect-candidate-backing>. Collators can use this information
    for submitting blocks. Validators can fetch their assignments by calling
    the appropriate Runtime API as described in Section
    <reference|sect-rt-api-validator-groups> and are not concerned how the
    underlying assignment mechanism works. The assigned validators within a
    group are usually referred to by their authority Id as defined in
    Definition <reference|defn-authority-list>.
  </definition>

  <section|Protocol Types>

  <\todo>
    mention SCALE encoding
  </todo>

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

      <item><math|d> is the bitfield array as described in Definition
      <reference|defn-bitfield-array>.

      <item><math|A<rsub|i>> is the validator index in the authority set as
      defined in Definition <reference|defn-authority-list> that signed this
      message.

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
      <tformat|<table|<row|<cell|M>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\><around*|(|<around*|(|C<rsub|>,I<rsub|>|)><rsub|0>\<ldots\><around*|(|C,I|)><rsub|n>|)>>>|<row|<cell|1\<rightarrow\><around*|(|V<rsub|0>,\<ldots\>V<rsub|n>|)>>>>>>>>|<row|<cell|C>|<cell|=>|<cell|<around*|(|B<rsub|h>,A<rsub|i>,c<rsub|a>|)>>>|<row|<cell|c<rsub|a>>|<cell|=>|<cell|<around*|(|c<rsub|k>,P<rsub|o>,P<rsub|p>|)>>>|<row|<cell|c<rsub|k>>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>s>>|<row|<cell|1\<rightarrow\>i>>>>>>>|<row|<cell|V>|<cell|=>|<cell|<around*|(|B<rsub|h>,I,A<rsub|i>,A<rsub|s>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|M> is a varying datatype where <math|0> indicates
      assignments for candidates in recent, unfinalized blocks and <math|1>
      indicates approvals for candidates in some recent, unfinalized block.

      <item><math|C> is an assignment criterion which refers to the candidate
      under which the assignment is relevant by the block hash.

      <item><math|I> is an unsigned 32-bit integer indicating the index of
      the candidate, corresponding the the order of the availability cores as
      described in Section <reference|sect-rt-api-availability-cores>.

      <item><math|B<rsub|h>> is the relay chain block hash \ where the
      candidate appears.

      <item><math|A<rsub|i>> is the authority set Id of the validator as
      defined in Definition <reference|defn-authority-list> that created this
      message.

      <item><math|A<rsub|s>> is the signature of the validator issuing this
      message.

      <item><math|c<rsub|a>> is the certification of the assignment.

      <item><math|c<rsub|k>> is a varying datatype where <math|0> indicates
      an assignment based on the VRF that authorized the relay chain block
      where the candidate was included, followed by a sample number,
      <math|s.> <math|1> indicates an assignment story based on the VRF that
      authorized the relay chain block where the candidate was included
      combined with the index of a particular core. This is described further
      in Section <reference|sect-approval-voting>.

      <item><math|P<rsub|o>> is a VRF output and <math|P<rsub|p>> its
      corresponding proof.
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
      to a validator was seconded.

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
    of the following format:

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
    of the following format:

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
    to fetch. The response message is defined in Definition
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
    block, <math|c>, and <math|c<rsub|p>> is that chunks proof in the Merkle
    tree. Both <math|c> and <math|c<rsub|p>> are byte arrays of type
    <math|*<around*|(|b<rsub|n>\<ldots\>b<rsub|m>|)>>.
  </definition>

  <\definition>
    <label|net-msg-available-data-request>The <strong|available data request>
    is sent by clients who want to retrieve the PoV block of a parachain
    candidate. The request is a datastructure of the following format:

    <\equation*>
      C<rsub|h>
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
    <math|C<rsub|h>> is the candidate hash that was used to create a
    committed candidate recept as defined in Definition
    <reference|defn-committed-candidate-receipt>. The response message is
    defined in Definition <reference|net-msg-statement-fetching-response>.
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
    Definition <reference|defn-committed-candidate-receipt>. No response is
    returned if no statement is found.
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
      session index the candidate appears in.

      <item><math|I<rsub|v>> is the invalid vote that makes up the request.\ 

      <item><math|V<rsub|v>> is the valid vote that makes this disput request
      valid.

      <item><math|A<rsub|i>> is an unsigned 32-bit integer indicating the
      validator index in the authority set as defined in Definition
      <reference|defn-authority-list>.

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

  <section|Collations>

  <todo|todo>

  <section|Candidate Backing><label|sect-candidate-backing>

  The Polkadot validator receives an arbitrary number of parachain candidates
  with associated proofs from untrusted collators. The validator must verify
  and select a specific quantity of the proposed candidates and issue those
  as <em|backable> candidates to its peers. A candidate is considered
  <em|backable> when at least <math|2/3> of all assigned validators have
  issued a <verbatim|Valid> statement about that candidate, as described in
  Section <reference|sect-candidate-backing-statements>. Validators can
  retrieve information about assignments via the Runtime APIs
  <reference|sect-rt-api-validator-groups> respectively
  <reference|sect-rt-api-availability-cores>.

  <subsection|Statements><label|sect-candidate-backing-statements>

  The assigned validator checks the validity of the proposed parachains
  blocks as described in Section <reference|sect-candidate-validation> and
  issues <verbatim|Valid> statements as defined in Definition
  <reference|net-msg-full-statement> to its peers if the verification
  succeeded <todo|what if it failed?>. Broadcasting failed verification as
  <verbatim|Valid> statements is a slashable offense. The validator must only
  issue one <verbatim|Seconded> statement, based on an arbitrary metric,
  which implies an explicit vote for a candidate to be included in the relay
  chain. The statements are gossiped to its peers with the statement
  distribution protocol message as defined in Definition
  <reference|defn-committed-candidate-receipt>.

  \;

  <todo|how are collators that broadcast invalid candidates punished?>

  \;

  This protocol attempts to produce as many backable candidates as possible,
  but does not attempt to determine a final candidate for inclusion. Once a
  parachain candidate has been seconded by at least one other validator and
  enough <verbatim|Valid> statements have been issued about that candidate to
  meet the <math|2/3> quorum, the candidate is ready to be inlcuded in the
  relay chain as described in Section <reference|sect-candidate-inclusion>.

  <\definition>
    <label|net-msg-full-statement>A <strong|statement>, <math|S>, is a
    datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|S>|<cell|=>|<cell|<around*|(|d,A<rsub|i>,A<rsub|s>|)>>>|<row|<cell|d>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|1\<rightarrow\>C<rsub|r>>>|<row|<cell|2\<rightarrow\>C<rsub|h>>>>>>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|d> is a varying datatype where <math|1> indicates that the
      validator \Pseconds\Q a candidate, meaning that the candidate should be
      included in the relay chain, followed by the committed candidate
      receipt, <math|C<rsub|r>>, as defined in Definition
      <reference|defn-committed-candidate-receipt>. <math|2> indicates that
      the validator has deemed the candidate valid, followed by the candidate
      hash.

      <item><math|C<rsub|h>> is the candidate hash.

      <item><math|A<rsub|i>> is the validator index in the authority set that
      signed this statement.

      <item><math|A<rsub|s>> is the signature of the validator.
    </itemize-dot>
  </definition>

  <subsection|Inclusion><label|sect-candidate-inclusion>

  The Polkadot validator includes the backed candidates as inherent data as
  defined in Definition <reference|defn-parachain-inherent-data> into a block
  as described in Section <reference|sect-inherents>. The relay chain block
  author decides on whatever metric which candidate should be selected for
  inclusion, as long as that candidate is valid and meets the validity quorum
  of <math|2/3+> as described in Section <reference|sect-candidate-backing-statements>.
  The candidate approval process as described in Section
  <reference|sect-approval-voting> ensures that only relay chain blocks are
  finalized where each candidate for each availability core meets the
  requirement of 2/3+ availability votes.

  <\definition>
    <label|defn-parachain-inherent-data>The <strong|parachain inherent data>
    contains backed candidates and is included when authoring a relay chain
    block. The datastructure, <math|I>, is of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|I>|<cell|=>|<cell|<around*|(|A,T,D,P<rsub|h>|)>>>|<row|<cell|T>|<cell|=>|<cell|<around*|(|C<rsub|0>,\<ldots\>C<rsub|n>|)>>>|<row|<cell|D>|<cell|=>|<cell|<around*|(|*d<rsub|n>,\<ldots\>d<rsub|m>|)>>>|<row|<cell|C>|<cell|=>|<cell|<around*|(|R,V,i|)>>>|<row|<cell|V>|<cell|=>|<cell|<around*|(|a<rsub|n>,\<ldots\>a<rsub|m>|)>>>|<row|<cell|a>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|1\<rightarrow\>s>>|<row|<cell|2\<rightarrow\>s>>>>>>>|<row|<cell|A>|<cell|=>|<cell|<around*|(|*L<rsub|n>,\<ldots\>L<rsub|m>|)>>>|<row|<cell|L>|<cell|=>|<cell|<around*|(|b,v<rsub|i>,s|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|A> is an array of signed bitfields by validators claiming
      the candidate is available (or not). The array must be sorted by
      validator index corresponding to the authority set as described in
      Section <reference|defn-authority-list>.

      <item><math|T> is an array of backed candidates for inclusing in the
      current block.

      <item><math|D> is an array of disputes.

      <item><math|P<rsub|h>> is the parent block header of the parachain.

      <item><math|d> is a dispute statement as described in Section
      <todo|todo>.

      <item><math|R> is a committed candidate receipt as defined in
      Definition <reference|defn-committed-candidate-receipt>.

      <item><math|V> is an array of validity votes themselves, expressed as
      signatures.

      <item><math|i> is a bitfield of indices of the validators within the
      validator group. <todo|clarify>

      <item><math|a> is either an implicit or explicit attestation of the
      validity of a parachain candidate, where <math|1> implies an implicit
      vote (in correspondence of a <verbatim|Seconded> statement) and
      <math|2> implies an explicit attestation (in correspondence of a
      <verbatim|Valid> statement). Both variants are followed by the
      signature of the validator.

      <item><math|s> is the signature of the validator.

      <item><math|b> the availability bitfield as described in Section
      <reference|sect-availability-votes>.

      <item><math|v<rsub|i>> is the validator index of the authority set as
      defined in Definition <reference|defn-authority-list>.
    </itemize-dot>

    <todo|clarify how this is constructed>
  </definition>

  <\definition>
    <label|defn-candidate-receipt>A <strong|candidate receipt>, R, contains
    information about the candidate and a proof of the results of its
    execution. It's a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|<cell|=>|<cell|<around*|(|D,C<rsub|h>|)>>>>>
    </eqnarray*>

    where <math|D> is the candidate descriptor as defined in Definition
    <reference|defn-candidate-descriptor> and <math|C<rsub|h>> is the hash of
    candidate commitments as defined in Definition
    <reference|defn-candidate-commitments>.
  </definition>

  <\definition>
    <label|defn-committed-candidate-receipt>The <strong|committed candidate
    receipt>, <math|R>, contains information about the candidate and the the
    result of its execution that is included in the relay chain. This type is
    similiar to the candidate receipt as defined in Definition
    <reference|defn-candidate-receipt>, but actually contains the execution
    results rather than just a hash of it. It's a datastructure of the
    following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|R>|<cell|=>|<cell|<around*|(|D,C|)>>>>>
    </eqnarray*>

    where <math|D> is the candidate descriptor as defined in Definition
    <reference|defn-candidate-descriptor> and C is the candidate commitments
    as defined in Definition <reference|defn-candidate-commitments>.
  </definition>

  <\definition>
    <label|defn-candidate-descriptor>The <strong|candidate descriptor>,
    <math|D>, is a unique descriptor of a candidate receipt. It's a
    datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|D>|<cell|=>|<cell|<around*|(|p,H,C<rsub|i>,V,B,r,s,p<rsub|h>,R<rsub|h>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|p> is the parachain Id as defined in Definition
      <reference|defn-para-id>.

      <item><math|H> is the hash of the relay chain block the candidate is
      executed in the context of.

      <item><math|C<rsub|i>> is the collators public key.

      <item><math|V> is the hash of the persisted validation data as defined
      in Definition <reference|defn-persisted-validation-data>.

      <item><math|B> is the hash of the PoV block.

      <item><math|r> is the root of the block's erasure encoding Merkle tree.
      <todo|clarify>

      <item><math|s> the collator signature of the concatenated components
      <math|p>, <math|H>, <math|R<rsub|h>> and <math|B>.

      <item><math|p<rsub|h>> is the hash of the parachain header of this
      candidate.

      <item><math|R<rsub|h>> is the hash of the parachain Runtime.
    </itemize-dot>
  </definition>

  <\definition>
    The <label|defn-candidate-commitments><with|font-series|bold|candidate
    commitments>, <math|C>, is the result of the execution and validation of
    a parachain (or parathread) candidate whose produced values must be
    committed to the relay chain. Those values are retrieved from the
    validation result as defined in Definition
    <reference|defn-validation-result>. A candidate commitment is a
    datastructure of the following format:

    <alignat*|2|<tformat|<table|<row|<cell|C>|<cell|=<around*|(|M<rsub|u>,M<rsub|h>,R,h,p,w|)>>>>>>

    where:

    <\itemize>
      <item><math|M<rsub|u>> is an array of upward messages sent by the
      parachain. Each individual message, <math|m>, is an array of bytes.

      <item><math|M<rsub|h>> is an array of outbound horizontal messages sent
      by the parachain. Each individual messages, <math|t>, is a
      datastructure as defined in Definition <todo|messaging-chapter>.

      <item><math|R> is an <verbatim|Option> value as described in Section
      <reference|defn-option-type> that can contain a new parachain Runtime
      in case of an update.

      <item><math|h> is the parachain block header as described in Definition
      <reference|defn-parablock>.

      <item><math|p> is a unsigned 32-bit intiger indicating the number of
      downward messages that were processed by the parachain. It is expected
      that the parachain processes the messages from frist to last.

      <item><math|w> is a unsigned 32-bit integer indicating the watermark
      which specifies the relay chain block number up to which all inbound
      horizontal messages have been processed.
    </itemize>
  </definition>

  <section|Candidate Validation><label|sect-candidate-validation>

  Received candidates submitted by collators and must have its validity
  verified by the assigned Polkadot validators. For each candidate to be
  valid, the validator must successfully verify the following condidations in
  the following order:

  <\enumerate-numeric>
    <item>The candidate does not exceed any parameters in the persisted
    validation data as defined in Definition
    <reference|defn-persisted-validation-data>.

    <item>The signature of the collator is valid.

    <item>Validate the candidate by executing the parachain Runtime as
    defined in Definition <reference|sect-parachain-runtime>.
  </enumerate-numeric>

  If all steps are valid, the Polkadot validator must create the necessary
  candidate commitments as defined in Definition
  <reference|defn-candidate-commitments> and submit the appropriate statement
  for each candidate as described in Section
  <reference|sect-candidate-backing-statements>.

  <subsection|Parachain Runtime><label|sect-parachain-runtime>

  Parachain Runtimes are stored in the relay chain state, and can either be
  fetched by the parachain Id or the Runtime hash via the relay chain Runtime
  API as described in Section <reference|sect-rt-api-validation-code> and
  <reference|sect-rt-api-validation-code-by-hash> respectively. The retrieved
  parachain Runtime might need to be decompressed based on the magic
  identifier as described in Section <reference|sect-runtime-compression>.

  \;

  In order to validate a parachain block, the Polkadot validator must prepare
  the validation parameters as defined in Definition
  <reference|defn-validation-parameters>, then use its local Wasm execution
  environment as described in Section <reference|sect-code-executor> to
  execute the <verbatim|validate_block> parachain Runtime API by passing on
  the validation parameters as an argument. The parachain Runtime function
  returns the validation result as defined in Definition
  <reference|defn-validation-result>.

  <\definition>
    <label|defn-validation-parameters>The <strong|validation parameters>
    structure, <math|P>, is required to validate a candidate against a
    parachain Runtime. It's a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|P>|<cell|=>|<cell|<around*|(|h,b,B<rsub|i>,S<rsub|r>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|h> is the parachain block header as defined in Definition
      <reference|defn-parablock>.

      <item><math|b> is the block body as defined in Definition
      <reference|defn-parablock>.

      <item><math|B<rsub|i>> is the latest relay chain block number.

      <item><math|S<rsub|r>> is the relay chain block storage root as defined
      in Definition <reference|sect-merkl-proof>.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-validation-result>The <strong|validation result> is returned
    by the <verbatim|validate_block> parachain Runtime API after attempting
    to validate a parachain block. Those results are then used in candidate
    commitments as defined in Definition <reference|sect-merkl-proof>., which
    then will be inserted into the relay chain via the parachain inherent
    data as described in Definition <reference|defn-parachain-inherent-data>.
    The validation result, V, is a datastructure of the following format:

    <\eqnarray*>
      <tformat|<table|<row|V|<cell|=>|<cell|<around*|(|h,R,M<rsub|u>,M<rsub|h>,p<rsub|>,w|)>>>|<row|<cell|M<rsub|u>>|<cell|=>|<cell|<around*|(|m<rsub|0>,\<ldots\>m<rsub|n>|)>>>|<row|<cell|M<rsub|h>>|<cell|=>|<cell|<around*|(|t<rsub|0>,\<ldots\>t<rsub|n>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|h> is the parachain block header as defined in Definition
      <reference|defn-parablock>.

      <item><math|R> is an <verbatim|Option> value as described in Section
      <reference|defn-option-type> that can contain a new parachain Runtime
      in case of an update.

      <item><math|M<rsub|u>> is an array of upward messages sent by the
      parachain. Each individual message, <math|m>, is an array of bytes.

      <item><math|M<rsub|h>> is an array of outbound horizontal messages sent
      by the parachain. Each individual message, <math|t>, is a datastructure
      as defined in Definition <todo|messaging-chapter>.

      <item><math|p> is a unsigned 32-bit integer indicating the number of
      downward messages that were processed by the parachain. It is expected
      that the parachain processes the messages from first to last.

      <item><math|w> is a unsigned 32-bit integer indicating the watermark
      which specifies the relay chain block number up to which all inbound
      horizontal messages have been processed.
    </itemize-dot>
  </definition>

  <todo|reference message passing types>

  <subsection|Runtime Compression><label|sect-runtime-compression>

  <todo|todo>

  <section|Approval Voting><label|sect-approval-voting>

  The approval voting process ensures that only valid parachain blocks are
  finalized on the relay chain. Validators verify submitted parachain
  candidates received from collators and issue approvals for valid
  candidates, respectively disputes for invalid blocks. Since it cannot be
  expected that each validators verifies every single parachain candidate,
  this mechanism ensures that enough honest validators are selected to verify
  parachain candidates and to prevent the finalization of invalid blocks. If
  an honest validator detects an invalid block which was approved by one or
  more validators, the honest validator must issue a disputes which wil cause
  escalations, resulting in consequences for all malicious parties, i.e.
  slashing. This mechanism is described more in Section
  <reference|sect-availability-assingment-criteria>.

  \;

  A VRF mechanism assigns the validators responsible for approving submitted
  parachain candidates, unlike the assignment mechanism during the backing
  phase, where assignments are all public and retrievable via the Runtime
  API, as described in Section <reference|sect-candidate-backing>. When
  ready, an assigned validator broadcasts their assignment to indicate their
  intent to check a candidate. After verifying a parachain candidate, the
  validator issues their approval vote to connected peers. If no following
  approval vote is sent, then that behavior is implied as \Pno-show', meaning
  that more validators need to be assigned to verify the candidate. No-show
  occurrences are explained further in Section
  <reference|sect-rt-api-validator-groups>.

  <subsection|Assignment Criteria><label|sect-availability-assingment-criteria>

  Validators determine their assignment based on a VRF mechanism, similiar to
  BABE, as described in Section An assigned validator never broadcasts their
  assignment until relevant. Once the assigned validator is ready to check a
  candidate, the validator broadcasts their assignment by issuing an approval
  distribution message as defined in Definition
  <reference|net-msg-approval-distribution>, where <math|M> is of variant
  <math|0>. Other assigned validators that receive that network message must
  keep track of if, expecting an approval vote following shortly after.

  \;

  \ After issuing an assignment, the validator must retrieve the candidate by
  using the availability recovery as described in Section
  <reference|sect-availability-recovery> and then validate the candidate as
  described in Section <reference|sect-candidate-validation>. If the
  candidate is valid, the validator must send their approval to the network
  as defined in Definition <reference|net-msg-approval-distribution>, where
  <math|M> is of variant <math|1>.

  <subsection|\PNo-show\Q Occurence><label|sect-no-show-occurence>

  The Polkadot validator observes a \Pno-show\Q occurence when another
  assigned validator broadcasted an assignment, indicating the intent to
  verify a parachain candidate, but did not follow up with an approval vote
  within a certain duration.

  \;

  <todo|todo>

  \;

  <subsection|Availability Votes><label|sect-availability-votes>

  The Polkadot validator must issue a bitfield as defined in Definition
  <reference|defn-bitfield-array> which indicates votes for the availabilty
  of candidates. Issued bitfields can be used by the validator and other
  peers to determine which backed candidates meet the <math|2/3+>
  availability quorum.

  \;

  Candidates are inserted into the relay chain in form of inherent data by a
  block author, as described in Section <reference|sect-candidate-inclusion>.
  A validator can retrieve that data by calling the appropriate Runtime API
  entry as described in Section <reference|sect-rt-api-availability-cores>,
  then create a bitfield indicating for which candidate the validator has
  availability data stored and broadcast it to the network as defined in
  Definition <reference|net-msg-bitfield-dist-msg>. When sending the bitfield
  distrubtion message, the validator must ensure <math|B<rsub|h>> is set
  approriately, therefore clarifying to which state the bitfield is referring
  to, given that candidates can vary based on the chain fork.

  \;

  Missing availability data of candidates must be recovered by the validator
  as described in Section <reference|sect-availability-recovery>. If
  previously issued bitfields are no longer accurate, i.e. the availability
  data has been recovered or the candidate of an availablity core has
  changed, the validator must create a new bitfield and boradcast it to the
  network.

  <\definition>
    <label|defn-bitfield-array>A <strong|bitfield array> contains single-bit
    values which indidate whether a candidate is available. The number of
    items is equal of to the number of availability cores as defined in
    Definition <reference|defn-availability-cores> and each bit represents a
    vote on the corresponding core in the given order. Respectively, if the
    single bit equals <verbatim|1>, then the Polkadot validator claims that
    the availability core is occupied, there exists a committed candidate
    receipt as defined in Definition <reference|defn-committed-candidate-receipt>
    and that the validator has a stored chunk of the parachain block as
    defined in Definition <reference|sect-availability-recovery>.
  </definition>

  <subsection|Candidate Recovery><label|sect-availability-recovery>

  The availability distribution of the Polkadot validator must be able to
  recover parachain candidates that the validator is assigned to, in order to
  determine whether the candidate should be backed as described in Section
  <reference|sect-candidate-backing> repsectively whether the candidate
  should be approved as described in Section
  <reference|sect-approval-voting>. Additionally, peers can send availability
  requests as defined in Definition <reference|net-msg-chunk-fetching-request>
  and Definition <reference|net-msg-available-data-request> to the validator,
  which the validator should be able to respond to.

  <section|Runtime Api>

  <subsection|validators>

  Returns the validator set at the current state. The specified validators
  are responsible for backing parachains for the current state.

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>An array of public keys representing the validators.
  </itemize-dot>

  <subsection|validator_groups><label|sect-rt-api-validator-groups>

  Returns the validator groups as defined in Definition
  <reference|defn-validator-groups> used during the current session. The
  validators in the groups are referred to by the validator set Id as defined
  in Definition <reference|defn-authority-list>.

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>None
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>An array of tuples, <math|T>, of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|T>|<cell|=>|<cell|<around*|(|I,G|)>>>|<row|<cell|I>|<cell|=>|<cell|<around*|(|v<rsub|n>,\<ldots\>v<rsub|m>|)>>>|<row|<cell|G>|<cell|=>|<cell|<around*|(|B<rsub|s>,f,B<rsub|c>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|I> is an array the validator set Ids as defined in
      Definition <reference|defn-authority-list>.

      <item><math|B<rsub|s>> indicates the block number where the session
      started.

      <item><math|f> indicates how often groups rotate. <math|0> means never.

      <item><math|B<rsub|c>> indicates the current block number.\ 
    </itemize-dot>
  </itemize-dot>

  <subsection|availability_cores><label|sect-rt-api-availability-cores>

  Returns information on all availability cores. <todo|clarify>

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>None
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>An array of core states, <math|S>, of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|S>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>C<rsub|o>>>|<row|<cell|1\<rightarrow\>C<rsub|s>>>|<row|<cell|2\<rightarrow\>\<b-phi\>>>>>>>>|<row|<cell|C<rsub|o>>|<cell|=>|<cell|<around*|(|n<rsub|u>,B<rsub|o>,B<rsub|t>,n<rsub|t>,b,G<rsub|i>,C<rsub|h>,C<rsub|d>|)>>>|<row|<cell|C<rsub|s>>|<cell|=>|<cell|<around*|(|P<rsub|id>,C<rsub|i>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|S> specifies the core state. <math|0> indicates that the
      core is occupied, <math|1> implies it's currently free but scheduled
      and given the opportunity to occupy and <math|2> implies it's free and
      there's nothing scheduled.

      <item><math|n<rsub|u>> is an <verbatim|Option> as described in
      Definition <reference|defn-option-type> which can contain a
      <math|C<rsub|s>> value if the core is freed by availabiltiy
      <todo|clarify> and indicates the assignment that is next scheduled on
      this core. An empty value indicates there is nothing scheduled.

      <item><math|B<rsub|o>> indicates the relay chain block number at which
      the core got occupied.

      <item><math|B<rsub|t>> indicates the relay chain block number the core
      will time-out at, if any.

      <item><math|n<rsub|t>> is an <verbatim|Option> as described in
      Definition <reference|defn-option-type> which can contain a
      <math|C<rsub|s>> value if the core is freed by a time-out and indicates
      the assignment that is next scheduled on this core. An empty value
      indicates there is nothing scheduled.

      <item><math|b> is a bitfield array as defined in Definition
      <reference|defn-bitfield-array>. A <math|\<gtr\>2/3> majority of
      assigned validators voting with <math|1> values means that the core is
      available.

      <item><math|G<rsub|i>> indicates the assigned validator group index as
      defined in Definition <todo|todo> is to distribute availability pieces
      of this candidate.

      <item><math|C<rsub|h>> indicates the hash of the candidate occypying
      the core.

      <item><math|C<rsub|d>> is the candidate descriptor as defined in
      Definition <reference|defn-candidate-descriptor>.

      <item><math|C<rsub|i>> is an <verbatim|Option> as described in
      Definition <reference|defn-option-type> which can contain the collators
      public key indicating who should author the block. <todo|clarify>
    </itemize-dot>
  </itemize-dot>

  <subsection|persisted_validation_data><label|sect-rt-api-persisted-validation-data>

  Returns the persistend validation data for the given parachain Id and a
  given occupied core assumption.

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>The parachain Id as defined in Definition <reference|defn-para-id>.

    <item>An occupied core assumption as defined in Definition
    <reference|defn-occupied-core-assumption>.
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>An <verbatim|Option> as described in Definition <todo|todo> which
    can contain the persisted validation data as defined in Definition
    <reference|defn-persisted-validation-data>. The value is empty if the
    parachain Id is not registered or the core assumption is of index
    <math|2>, meaning that the core was freed.
  </itemize-dot>

  <\definition>
    <label|defn-occupied-core-assumption>A <strong|occupied core assumption>
    is used for fetching certain pieces of information about a parachain by
    using the relay chain API. The assumption indicates how the Runtime API
    should compute the result. <todo|how does the node make assumptions?> The
    assumptions, <math|A>, is a varying datatype of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|A>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>\<b-phi\>>>|<row|<cell|1\<rightarrow\>\<b-phi\>>>|<row|<cell|2\<rightarrow\>\<b-phi\>>>>>>>>>>
    </eqnarray*>

    where <math|0> indicates that the candidate occupying the core was made
    available and included to free the core, <math|1> indicates that it
    timed-out and freed the core without advancing the parachain and <math|2>
    indicates that the core was not occuped to begin with.
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

    The persisted validation data is fetched via the Runtime API as described
    in Section <reference|sect-rt-api-persisted-validation-data>.

    \;
  </definition>

  <subsection|session_index_for_child>

  Returns the session index that is expected at the child of a block.
  <todo|clarify session index>

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>None
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>A unsigned 32-bit integer representing the session index.
  </itemize-dot>

  <subsection|validation_code><label|sect-rt-api-validation-code>

  Fetches the validation code (Runtime) of a parachain by parachain Id.

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>The parachain Id as defined in Definition <reference|defn-para-id>.

    <item>The occupied core assumption as defined in Definition
    <reference|defn-occupied-core-assumption>.
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>An <verbatim|Option> value as defined in Definition <todo|todo>
    containing the full validation code in an byte array. This value is empty
    if the parachain Id cannot be found or the assumption is wrong.
  </itemize-dot>

  <subsection|validation_code_by_hash><label|sect-rt-api-validation-code-by-hash>

  Returns the validation code (Runtime) of a parachain by its hash.

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>The hash value of the validation code.
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>An <verbatim|Option> value as defined in Definition
    <inactive|<hybrid|>> containing the full validation code in an byte
    array. This value is empty if the parachain Id cannot be found or the
    assumption is wrong.
  </itemize-dot>

  <subsection|candidate_pending_availability>

  Returns the receipt of a candidate pending availability for any parachain
  assigned to an occupied availabilty core.

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>The parachain Id as defined in Definition <reference|defn-para-id>.
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>An <verbatim|Option> value as defined in Definition
    <reference|defn-option-type> containing the committed candidate receipt
    as defined in Definition <reference|defn-candidate-receipt>. This value
    is empty if the given parachain Id is not assigned to an occupied
    availability cores.
  </itemize-dot>

  <subsection|candidate_events>

  Returns an array of candidate events that occured within the lastest state.

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>None
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>An array of single candidate events, <math|E>, of the following
    format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|E>|<cell|=>|<cell|<choice|<tformat|<table|<row|<cell|0\<rightarrow\>d>>|<row|<cell|1\<rightarrow\>d>>|<row|<cell|2\<rightarrow\><around*|(|C<rsub|r>,h,I<rsub|c>|)>>>>>>>>|<row|<cell|d>|<cell|=>|<cell|<around*|(|C<rsub|r>,h,I<rsub|c>,G<rsub|i>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|E> specifies the the event type of the candidate. <math|0>
      indicates that the candidate receipt was backed in the latest relay
      chain block, <math|1> indicates that it was included and became a
      parachain block at the latest relay chain block and <math|2> indicates
      that the candidate receipt was not made available and timed-out.

      <item><math|C<rsub|r>> is the candidate receipt as defined in
      Definition <reference|defn-candidate-receipt>.

      <item><math|h> is the parachain block header as defined in Definition
      <reference|defn-parablock>.

      <item><math|I<rsub|c>> is the index of the availabilty core as can be
      retrieved in Section <reference|sect-rt-api-availability-cores> that
      the candidate is occupying. If <math|E> is of variant <math|2>, then
      this indicates the core index the candidate <em|was> occupying.

      <item><math|G<rsub|i>> is the group index as defined in Definition
      <reference|defn-validator-groups> that is responsible of backing the
      candidate.
    </itemize-dot>
  </itemize-dot>

  <subsection|disputes_info>

  Returns information about all disputes known by the Runtime, including
  which validators the Runtime will accept disputes from.

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>None
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>A dispute information structure, <math|I>, of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|I>|<cell|=>|<cell|<around*|(|<around*|(|D<rsub|0>,\<ldots\>D<rsub|n>|)>,T|)>>>|<row|<cell|D>|<cell|=>|<cell|<around*|(|i,C<rsub|h>,S,l|)>>>|<row|<cell|T>|<cell|=>|<cell|<around*|(|m,<around*|(|p<rsub|0>,\<ldots\>p<rsub|n>|)>|)>>>|<row|<cell|p>|<cell|=>|<cell|<around*|(|i,<around*|(|s<rsub|0>,\<ldots\>s<rsub|n>|)>|)>>>>>
    </eqnarray*>

    where

    <\itemize-dot>
      <item><math|D> represents a dispute.

      <item><math|T> represents information about spam slots <todo|clarify>

      <item><math|i> is the session index as defined in Definition
      <todo|todo>.

      <item><math|C<rsub|h>> is the candidate hash <todo|receipt?>.

      <item><math|S> is the dispute state as defined in Definition
      <todo|todo>.

      <item><math|l> is a boolean indacting <text-dots> <todo|?>.

      <item><math|m> is a unsigned 32-bit integer indicating the maximum spam
      slots <todo|clarify>.

      <item><math|s> is a unsigned 32-bit integer indicating the spam slot.
    </itemize-dot>
  </itemize-dot>

  <subsection|candidates_included>

  Checks which candidates have been included within the local chain.

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item>An array for pairs, <math|p>, of the following format:

    <\eqnarray*>
      <tformat|<table|<row|<cell|p>|<cell|=>|<cell|<around*|(|i,C<rsub|h>|)>>>>>
    </eqnarray*>

    where <math|i> is the session index as defined in Definition <todo|todo>
    and <math|C<rsub|h>> is the candidate hash.
  </itemize-dot>

  \;

  <strong|Return>

  <\itemize-dot>
    <item>An array of booleans which indicate whether the a candidate is
    included (<em|true>) or not (<em|false>). The order of booleans
    corresponds to the order of the passed on pairs <math|p>.
  </itemize-dot>

  <section|<todo|todo - Outdated section>><label|sect-primary-validation>

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

  <section|Erasure encoding <todo|todo>>

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
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|6>
    <associate|save-aux|false>
  </collection>
</initial>