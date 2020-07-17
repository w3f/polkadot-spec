<TeXmacs|1.99.11>

<project|host-spec.tm>

<style|<tuple|book|old-dots>>

<\body>
  <appendix|Runtime Entries><label|sect-runtime-entries>

  <section|List of Runtime Entries><label|sect-list-of-runtime-entries>

  The Polkadot Host assumes that at least the following functions are
  implemented in the Runtime Wasm blob and have been exported as shown in
  Snippet <reference|snippet-runtime-enteries>:

  <assign|figure-text|<macro|Snippet>>

  <\small-figure>
    <\cpp-code>
      \ \ (export "Core_version" (func $Core_version))

      \ \ (export "Core_execute_block" (func $Core_execute_block))

      \ \ (export "Core_initialize_block" (func $Core_initialize_block))

      \ \ (export "Metadata_metadata" (func $Metadata_metadata))

      \ \ (export "BlockBuilder_apply_extrinsic" (func
      $BlockBuilder_apply_extrinsic))

      \ \ (export "BlockBuilder_finalize_block" (func
      $BlockBuilder_finalize_block))

      \ \ (export "BlockBuilder_inherent_extrinsics"\ 

      \ \ \ \ \ \ \ \ \ \ (func $BlockBuilder_inherent_extrinsics))

      \ \ (export "BlockBuilder_check_inherents" (func
      $BlockBuilder_check_inherents))

      \ \ (export "BlockBuilder_random_seed" (func
      $BlockBuilder_random_seed))

      \ \ (export "TaggedTransactionQueue_validate_transaction"\ 

      \ \ \ \ \ \ \ \ \ \ (func $TaggedTransactionQueue_validate_transaction))

      \ \ (export "OffchainWorkerApi_offchain_worker"\ 

      \ \ \ \ \ \ \ \ \ \ (func $OffchainWorkerApi_offchain_worker))

      \ \ (export "ParachainHost_validators" (func
      $ParachainHost_validators))

      \ \ (export "ParachainHost_duty_roster" (func
      $ParachainHost_duty_roster))

      \ \ (export "ParachainHost_active_parachains"\ 

      \ \ \ \ \ \ \ \ \ \ (func $ParachainHost_active_parachains))

      \ \ (export "ParachainHost_parachain_status" (func
      $ParachainHost_parachain_status))

      \ \ (export "ParachainHost_parachain_code" (func
      $ParachainHost_parachain_code))

      \ \ (export "ParachainHost_ingress" (func $ParachainHost_ingress))

      \ \ (export "GrandpaApi_grandpa_pending_change"\ 

      \ \ \ \ \ \ \ \ \ \ (func $GrandpaApi_grandpa_pending_change))

      \ \ (export "GrandpaApi_grandpa_forced_change"\ 

      \ \ \ \ \ \ \ \ \ \ (func $GrandpaApi_grandpa_forced_change))

      \ \ (export "GrandpaApi_grandpa_authorities" (func
      $GrandpaApi_grandpa_authorities))

      \ \ (export "BabeApi_configuration" (func $BabeApi_configuration))

      \ \ (export "SessionKeys_generate_session_keys"\ 

      \ \ \ \ \ \ \ \ \ \ (func $SessionKeys_generate_session_keys))

      \;
    </cpp-code>
  </small-figure|<label|snippet-runtime-enteries>Snippet to export entries
  into tho Wasm runtime module.>

  <assign|figure-text|<macro|Figure>>

  The following sections describe the standard based on which the Polkadot
  Host communicates with each runtime entry. Do note that any state changes
  created by calling any of the Runtime functions are not necessarily to be
  persisted after the call is ended. See Section
  <reference|sect-handling-runtime-state-update> for more information.

  <section|Argument Specification>

  As a wasm functions, all runtime entries have the following prototype
  signature:

  \;

  <\verbatim>
    \ \ \ \ (func $generic_runtime_entry

    \ \ \ \ \ \ (param $data i32) (parm $len i32) (result i64))
  </verbatim>

  \;

  where <verbatim|data> points to the SCALE encoded paramaters sent to the
  function and <verbatim|len> is the length of the data. <verbatim|result>
  points to the SCALE encoded data the function returns (See Sections
  <reference|sect-runtime-send-args-to-runtime-enteries> and
  <reference|sect-runtime-return-value>).

  \;

  In this section, we describe the function of each of the entries alongside
  with the details of the arguments and the return values for each one of
  these enteries.

  <subsection|<verbatim|Core_version>><label|defn-rt-core-version>

  This entry receives no argument; it returns the version data encoded in ABI
  format described in Section <reference|sect-runtime-return-value>
  containing the following information:

  <verbatim|>

  <\with|par-mode|center>
    <small-table|<tabular|<tformat|<cwith|1|8|1|1|cell-halign|l>|<cwith|1|8|1|1|cell-lborder|0ln>|<cwith|1|8|2|2|cell-halign|l>|<cwith|1|8|3|3|cell-halign|l>|<cwith|1|8|3|3|cell-rborder|0ln>|<cwith|1|8|1|3|cell-valign|c>|<cwith|1|1|1|3|cell-tborder|1ln>|<cwith|1|1|1|3|cell-bborder|1ln>|<cwith|8|8|1|3|cell-bborder|1ln>|<cwith|2|-1|1|1|font-base-size|8>|<cwith|2|-1|2|-1|font-base-size|8>|<table|<row|<cell|Name>|<cell|Type>|<cell|Description>>|<row|<cell|<verbatim|spec_name>>|<cell|String>|<cell|Runtime
    identifier>>|<row|<cell|<verbatim|impl_name>>|<cell|String>|<cell|the
    name of the implementation (e.g. C++)>>|<row|<cell|<verbatim|authoring_version>>|<cell|UINT32>|<cell|the
    version of the authorship interface>>|<row|<cell|<verbatim|spec_version>>|<cell|UINT32>|<cell|the
    version of the Runtime specification>>|<row|<cell|<verbatim|impl_version>>|<cell|UINT32>|<cell|the
    v<verbatim|>ersion of the Runtime implementation>>|<row|<cell|<verbatim|apis>>|<cell|ApisVec
    (<reference|defn-rt-apisvec>)>|<cell|List of supported APIs along with
    their version>>|<row|<cell|<verbatim|transaction_version>>|<cell|UINT32>|<cell|the
    version of the transaction format>>>>>|Detail of the version data type
    returns from runtime <verbatim|version> function.>
  </with>

  <\definition>
    <label|defn-rt-apisvec><strong|ApisVec> is a specialised type for the
    <verbatim|Core_version> (<reference|defn-rt-core-version>) function
    entry. It represents an array of tuples, where the first value of the
    tuple is an array of 8-bytes indicating the API name. The second value of
    the tuple is the version number of the corresponding API.

    <\eqnarray*>
      <tformat|<table|<row|<cell|ApiVec>|<cell|\<assign\>>|<cell|<around*|(|T<rsub|0>,\<ldots\>,T<rsub|n>|)>>>|<row|<cell|T>|<cell|\<assign\>>|<cell|<around*|(|<around*|(|b<rsub|0>,\<ldots\>,b<rsub|7>|)>,UINT32|)>>>>>
    </eqnarray*>
  </definition>

  <subsection|<verbatim|Core_execute_block>><label|sect-rte-core-execute-block>

  Executes a full block by executing all exctrinsics included in it and
  update the state accordingly. Additionally, some integrity checks are
  executed such as validating if the parent hash is correct and that the
  transaction root represents the transactions. Internally, this function
  performs an operation similar to the process described in Algorithm
  <reference|algo-build-block>, by calling <verbatim|Core_initialize_block>,
  <verbatim|BlockBuilder_apply_extrinsics> and
  <verbatim|BlockBuilder_finalize_block>.

  \;

  This function should be called when a fully complete block is available
  that is not actively being built on, such as blocks received from other
  peers. State changes resulted from calling this function are usually meant
  to persist when the block is imported successfully.\ 

  \;

  Additionally, the seal digest in the block header as described in section
  <reference|defn-digest> must be removed by the Polkadot host before
  submitting the block.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>The entry accepts a block, represented as a tuple consisting of a
    block header as described in section <reference|defn-block-header> and
    the block body as described in section <reference|defn-block-body>.
  </itemize>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  <subsection|<verbatim|Core_initialize_block>>

  Sets up the environment required for building a new block as described in
  Algorithm <reference|algo-build-block>.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>The block header of the new block as defined in
    <reference|defn-block-header>. The values <math|H<rsub|r>,H<rsub|e> and
    H<rsub|d>> are left empty.
  </itemize>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  <subsection|<verbatim|hash_and_length>><label|sect-rte-hash-and-length>

  An auxilarry function which returns hash and encoding length of an
  extrinsics.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>A blob of an extrinsic.
  </itemize>

  <verbatim|>

  <strong|Return>:

  <\itemize-dot>
    <item>Pair of Blake2Hash of the blob as element of
    <math|\<bbb-B\><rsub|32>> and its length as 64 bit integer.
  </itemize-dot>

  <subsection|<verbatim|BabeApi_configuration>><label|sect-rte-babeapi-epoch>

  This entry is called to obtain the current configuration of BABE consensus
  protocol.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>None
  </itemize>

  \;

  <strong|Return>:

  A tuple containing configuration data used by the Babe consensus engine.

  <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|18|18|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|1|cell-lborder|0ln>|<cwith|2|-1|3|3|cell-rborder|0ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|4|1|1|cell-lborder|0ln>|<cwith|2|4|3|3|cell-rborder|0ln>|<cwith|5|5|1|-1|cell-tborder|1ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|5|6|1|1|cell-lborder|0ln>|<cwith|5|6|3|3|cell-rborder|0ln>|<cwith|7|7|1|-1|cell-tborder|1ln>|<cwith|6|6|1|-1|cell-bborder|1ln>|<cwith|7|10|1|1|cell-lborder|0ln>|<cwith|7|10|3|3|cell-rborder|0ln>|<cwith|11|11|1|-1|cell-tborder|1ln>|<cwith|10|10|1|-1|cell-bborder|1ln>|<cwith|11|15|1|1|cell-lborder|0ln>|<cwith|11|15|3|3|cell-rborder|0ln>|<cwith|16|16|1|-1|cell-tborder|1ln>|<cwith|15|15|1|-1|cell-bborder|1ln>|<cwith|16|16|1|-1|cell-bborder|1ln>|<cwith|17|17|1|-1|cell-tborder|1ln>|<cwith|16|16|1|1|cell-lborder|0ln>|<cwith|16|16|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Name>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|SlotDuration>|<cell|The
  slot duration in milliseconds. Currently, only the value
  provided>|<cell|Unsigned 64bit>>|<row|<cell|>|<cell|by this type at genesis
  will be used. Dynamic slot duration may
  be>|<cell|integer>>|<row|<cell|>|<cell|supported in the
  future.>|<cell|>>|<row|<cell|EpochLength>|<cell|The duration of epochs in
  slots.>|<cell|Unsigned 64bit>>|<row|<cell|>|<cell|>|<cell|integer>>|<row|<cell|Constant>|<cell|A
  constant value that is used in the threshold calculation
  formula>|<cell|Tuple containing>>|<row|<cell|>|<cell|as defined in
  definition <reference|defn-babe-constant>.>|<cell|two
  unsigned>>|<row|<cell|>|<cell|>|<cell|64bit
  integers>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|Genesis>|<cell|The
  authority list for the genesis epoch as defined in Definition
  <reference|defn-authority-list>. >|<cell|Array of
  tuples>>|<row|<cell|Authorities>|<cell|>|<cell|containing a
  256-bit>>|<row|<cell|>|<cell|>|<cell|byte array and
  a>>|<row|<cell|>|<cell|>|<cell|unsigned
  64bit>>|<row|<cell|>|<cell|>|<cell|integer>>|<row|<cell|Randomness>|<cell|The
  randomness for the genesis epoch>|<cell|32-byte
  array>>|<row|<cell|SecondarySlot>|<cell|Whether this chain should run with
  secondary slots and wether>|<cell|8bit enum>>|<row|<cell|>|<cell|they are
  assigned in a round-robin manner or via a second VRF.>|<cell|>>>>>>
    The tuple provided by <strong|BabeApi_configuration>.
  </big-table>

  <subsection|<verbatim|GrandpaApi_grandpa_authorities>><label|sect-rte-grandpa-auth>

  This entry fetches the list of GRANDPA authorities according to the genesis
  block and is used to initialize authority list defined in Definition
  <reference|defn-authority-list>, at genisis. Any future authority changes
  get tracked via Runtiem-to-consensus engine messages as described in
  Section <reference|sect-consensus-message-digest>.

  <subsection|<verbatim|TaggedTransactionQueue_validate_transaction>><label|sect-rte-validate-transaction>

  This entry is invoked against extrinsics submitted through the transaction
  network message <reference|sect-msg-transactions> and indicates if the
  submitted blob represents a valid extrinsics applied to the specified
  block. This function gets called internally when executing blocks with the
  <verbatim|Core_execute_block> runtime function as described in section
  <reference|sect-rte-core-execute-block>.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>UTX: A byte array that contains the transaction.
  </itemize>

  \;

  <strong|Return>:

  This function returns a <verbatim|Result> as defined in Definition
  <reference|defn-result-type> which contains the type <em|ValidTransaction>
  as defined in Definition <reference|defn-valid-transaction> on success and
  the type <em|TransactionValidityError> as defined in Definition
  <reference|defn-transaction-validity-error> on failure.

  <\definition>
    <label|defn-valid-transaction><strong|ValidTransaction> is a tuple which
    contains information concerning a valid transaction.

    \;

    <\small-table|<tabular|<tformat|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-bborder|0ln>|<cwith|5|5|1|-1|cell-tborder|0ln>|<cwith|6|6|1|-1|cell-tborder|1ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|6|6|1|-1|cell-bborder|0ln>|<cwith|7|7|1|-1|cell-tborder|0ln>|<cwith|9|9|1|-1|cell-tborder|1ln>|<cwith|8|8|1|-1|cell-bborder|1ln>|<cwith|9|9|1|-1|cell-bborder|0ln>|<cwith|10|10|1|-1|cell-tborder|0ln>|<cwith|11|11|1|-1|cell-tborder|1ln>|<cwith|10|10|1|-1|cell-bborder|1ln>|<cwith|11|11|1|-1|cell-bborder|0ln>|<cwith|12|12|1|-1|cell-tborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<cwith|1|-1|2|2|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-rborder|0ln>|<twith|table-rborder|1ln>|<twith|table-lborder|0ln>|<twith|table-tborder|0ln>|<cwith|1|1|2|2|cell-lborder|0ln>|<cwith|1|1|1|1|cell-rborder|0ln>|<cwith|1|1|3|3|cell-lborder|0ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|12|12|1|1|cell-tborder|0ln>|<cwith|11|11|1|1|cell-bborder|0ln>|<cwith|12|12|2|2|cell-tborder|0ln>|<cwith|11|11|2|2|cell-bborder|0ln>|<cwith|12|12|2|2|cell-lborder|0ln>|<cwith|12|12|1|1|cell-rborder|0ln>|<cwith|12|12|3|3|cell-tborder|0ln>|<cwith|11|11|3|3|cell-bborder|0ln>|<cwith|2|-1|3|3|cell-lborder|0ln>|<cwith|2|-1|2|2|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|12|12|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Name>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|Priority>|<cell|Determines
    the ordering of two transactions that have>|<cell|Unsigned
    64bit>>|<row|<cell|>|<cell|all their dependencies (required tags)
    satisfied.>|<cell|integer>>|<row|<cell|Requires>|<cell|List of tags
    specifying extrinsics which should be applied >|<cell|Array
    containing>>|<row|<cell|>|<cell|before the current exrinsics can be
    applied.>|<cell|inner arrays>>|<row|<cell|Provides>|<cell|Informs Runtime
    of the extrinsics depending on the tags in>|<cell|Array
    containing>>|<row|<cell|>|<cell|the list that can be applied after
    current extrinsics are being applied.>|<cell|inner
    arrays>>|<row|<cell|>|<cell|Describes the minimum number of blocks for
    the validity to be correct>|<cell|>>|<row|<cell|Longevity>|<cell|After
    this period, the transaction should be removed from the >|<cell|Unsigned
    64bit>>|<row|<cell|>|<cell|pool or revalidated.>|<cell|integer>>|<row|<cell|Propagate>|<cell|A
    flag indicating if the transaction should be propagated to
    >|<cell|Boolean>>|<row|<cell|>|<cell|other peers.>|<cell|>>>>>>
      The tuple provided by <verbatim|TaggedTransactionQueue_transaction_validity>

      in the case the transaction is judged to be valid.
    </small-table>
  </definition>

  Note that if <em|Propagate> is set to <verbatim|false> the transaction will
  still be considered for including in blocks that are authored on the
  current node, but will never be sent to other peers.

  <\definition>
    <label|defn-transaction-validity-error><strong|TransactionValidityError>
    is a varying data type as defined in Definition
    <reference|defn-varrying-data-type>, where following values are possible:

    \;

    <small-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|1|1|3|3|cell-bborder|1ln>|<cwith|2|2|3|3|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|<strong|>Id>>|<cell|<strong|Descri<strong|>ption>>|<cell|<strong|Appended>>>|<row|<cell|0>|<cell|The
    transaction is invalid.>|<cell|InvalidTransaction
    (<reference|defn-invalid-transaction>)>>|<row|<cell|1>|<cell|The
    transaction validity can't be determined.>|<cell|UnknownTransaction
    (<reference|defn-unknown-transaction>)>>>>>|Type variation for the return
    value of <verbatim|TaggedTransactionQueue_transaction_validity>.>

    <\definition>
      <label|defn-invalid-transaction><strong|InvalidTransaction> is a
      varying data type as defined in Definition
      <reference|defn-varrying-data-type> which can get appended to
      TransactionValidityError and describes the invalid transaction in more
      precise detail. The following values are possible:

      <\big-table|<tabular|<tformat|<cwith|1|1|2|2|cell-lborder|0ln>|<cwith|1|1|1|1|cell-rborder|0ln>|<cwith|1|1|3|3|cell-lborder|0ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|9|9|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|1|cell-lborder|0ln>|<cwith|2|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Appended>>>|<row|<cell|0>|<cell|Call:
      The call of the transaction is not expected>|<cell|>>|<row|<cell|1>|<cell|Payment:
      Inability to pay some fees (e.g. balance too
      low)>|<cell|>>|<row|<cell|2>|<cell|Future: Transaction not yet valid
      (e.g. nonce too high)>|<cell|>>|<row|<cell|3>|<cell|Stale: Transaction
      is outdated (e.g. nonce too low)>|<cell|>>|<row|<cell|4>|<cell|BadProof:
      Bad transaction proof (e.g. bad signature)>|<cell|>>|<row|<cell|5>|<cell|AncientBirthBlock:
      Transaction birth block is ancient.>|<cell|>>|<row|<cell|6>|<cell|ExhaustsResources:
      Transaction would exhaus the resources of the current
      block>|<cell|>>|<row|<cell|7>|<cell|Custom: Any other custom message
      not covered by this type. >|<cell|one byte>>>>>>
        Type variant whichs gets appended to Id 0 of
        <strong|TransactionValidityError>.
      </big-table>
    </definition>

    <\definition>
      <label|defn-unknown-transaction><strong|UnknownTransacion> is a varying
      data type as defined in Definition <reference|defn-varrying-data-type>
      which can get appended to TransactionValidityError and describes the
      unknown transaction validity in more precise detail. The following
      values are possible:

      <\big-table|<tabular|<tformat|<cwith|1|1|3|3|cell-bborder|1ln>|<cwith|2|2|3|3|cell-tborder|1ln>|<cwith|1|1|2|2|cell-bborder|1ln>|<cwith|2|2|2|2|cell-tborder|1ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|1|1|3|3|cell-lborder|0ln>|<cwith|1|1|1|1|cell-bborder|1ln>|<cwith|2|2|1|1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-rborder|0ln>|<cwith|1|1|2|2|cell-lborder|0ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Appended>>>|<row|<cell|0>|<cell|CannotLookup:
      Could not lookup some info that is required for the
      transaction>|<cell|>>|<row|<cell|1>|<cell|NoUnsignedValidator: No
      validator found for the given unsigned
      transaction.>|<cell|>>|<row|<cell|2>|<cell|Custom: Any other custom
      message not covered by this type>|<cell|one byte>>>>>>
        Type variant whichs gets appended to Id 1 of
        <strong|TransactionValidityError>.
      </big-table>
    </definition>

    \;
  </definition>

  Note that when this function gets called by the Polkadot host in order to
  validate a transaction received from peers, Polkadot host usually
  disregards and rewinds state changes resulting for such a call.

  \;

  <subsection|<verbatim|BlockBuilder_apply_extrinsic>>
  <label|sect-rte-apply-extrinsic>

  Apply the extrinsic outside of the block execution function. This does not
  attempt to validate anything regarding the block, but it builds a list of
  transaction hashes.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>An extrinisic.
  </itemize>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>Returns the varying datatype <strong|<em|ApplyExtrinsicResult>> as
    defined in Definition <reference|defn-rte-apply-extrinsic-result>.

    \;
  </itemize-dot>

  <\definition>
    <label|defn-rte-apply-extrinsic-result><strong|ApplyExtrinsicResult> is
    the varying data type <strong|Result> as defined in Definition
    <reference|defn-result-type>. This structure can contain multiple nested
    structures, indicating either module dispatch outcomes or transaction
    invalidity errors.

    <\big-table|<tabular|<tformat|<cwith|2|2|1|-1|cell-bborder|1ln>|<cwith|3|3|1|-1|cell-tborder|1ln>|<cwith|2|2|1|1|cell-lborder|0ln>|<cwith|2|2|3|3|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-tborder|0ln>|<cwith|3|3|1|-1|cell-bborder|0ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|4|4|1|1|cell-lborder|0ln>|<cwith|4|4|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|0>|<cell|Outcome
    of dispatching the extrinsic.>|<cell|DispatchOutcome
    (<reference|defn-rte-dispatch-outcome>)>>|<row|<cell|1>|<cell|Possible
    errors while checking the>|<cell|TransactionValidityError
    (<reference|defn-rte-transaction-validity-error>)>>|<row|<cell|>|<cell|validity
    of a transaction.>|<cell|>>>>>>
      Possible values of varying data type <strong|ApplyExtrinsicResult>.
    </big-table>
  </definition>

  <\definition>
    <label|defn-rte-dispatch-outcome><strong|DispatchOutcome> is the varying
    data type <strong|Result> as defined in Definition
    <reference|defn-result-type>.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|2|2|1|-1|cell-bborder|0ln>|<cwith|3|3|1|-1|cell-tborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|3|3|1|1|cell-lborder|0ln>|<cwith|3|3|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|0>|<cell|Extrinsic
    is valid and was submitted successfully.>|<cell|None>>|<row|<cell|1>|<cell|Possible
    errors while dispatching the extrinsic.>|<cell|DispatchError
    (<reference|defn-rte-dispatch-error>)>>>>>>
      Possible values of varying data type <strong|DispatchOutcome>.
    </big-table>
  </definition>

  <\definition>
    <label|defn-rte-dispatch-error><strong|DispatchError> is a varying data
    type as defined in Definition <reference|defn-varrying-data-type>.
    Indicates various reasons why a dispatch call failed.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|3|3|1|-1|cell-tborder|0ln>|<cwith|2|2|1|-1|cell-bborder|0ln>|<cwith|3|3|1|1|cell-lborder|0ln>|<cwith|3|3|3|3|cell-rborder|0ln>|<cwith|6|6|1|-1|cell-bborder|1ln>|<cwith|6|6|1|1|cell-lborder|0ln>|<cwith|6|6|3|3|cell-rborder|0ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|6|6|1|-1|cell-tborder|1ln>|<cwith|5|5|1|1|cell-lborder|0ln>|<cwith|5|5|3|3|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|5|5|1|-1|cell-tborder|1ln>|<cwith|4|4|1|1|cell-lborder|0ln>|<cwith|4|4|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|0>|<cell|Some
    unknown error occured.>|<cell|SCALE encoded byte array
    contain->>|<row|<cell|>|<cell|>|<cell|ing a valid UTF-8
    sequence.>>|<row|<cell|1>|<cell|Failed to lookup some
    data.>|<cell|None>>|<row|<cell|2>|<cell|A bad
    origin.>|<cell|None>>|<row|<cell|3>|<cell|A custom error in a
    module.>|<cell|CustomModuleError (<reference|defn-rte-custom-module-error>)>>>>>>
      Possible values of varying data type <strong|DispatchError>.
    </big-table>
  </definition>

  <\definition>
    <label|defn-rte-custom-module-error><strong|CustomModuleError> is a tuple
    appended after a possible error in <strong|DispatchError> as defined in
    Defintion <reference|defn-rte-dispatch-error>.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|3|3|1|-1|cell-tborder|0ln>|<cwith|2|2|1|-1|cell-bborder|0ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|3|3|1|1|cell-lborder|0ln>|<cwith|3|3|3|3|cell-rborder|0ln>|<cwith|5|5|1|-1|cell-tborder|0ln>|<cwith|4|4|1|-1|cell-bborder|0ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|6|6|1|-1|cell-tborder|1ln>|<cwith|5|5|1|1|cell-lborder|0ln>|<cwith|5|5|3|3|cell-rborder|0ln>|<cwith|9|9|1|-1|cell-tborder|0ln>|<cwith|8|8|1|-1|cell-bborder|0ln>|<cwith|9|9|1|-1|cell-bborder|1ln>|<cwith|9|9|1|1|cell-lborder|0ln>|<cwith|9|9|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Name>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|Index>|<cell|Module
    index matching the>|<cell|Unsigned 8-bit
    integer.>>|<row|<cell|>|<cell|metadata module
    index.>|<cell|>>|<row|<cell|Error>|<cell|Module specific error
    value.>|<cell|Unsigned 8-bit integer>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|Message>|<cell|Optional
    error message.>|<cell|Varying data type <strong|Option>
    (<reference|defn-option-type>).>>|<row|<cell|>|<cell|>|<cell|The optional
    value is a SCALE>>|<row|<cell|>|<cell|>|<cell|encoded byte array
    containing a>>|<row|<cell|>|<cell|>|<cell|valid UTF-8 sequence.>>>>>>
      Possible values of varying data type <strong|CustomModuleError>.
    </big-table>
  </definition>

  <\definition>
    <label|defn-rte-transaction-validity-error><strong|TransactionValidityError>
    is a varying data type as defined in Definition
    <reference|defn-varrying-data-type>. It indicates possible errors that
    can occur while checking the validity of a transaction.

    <\big-table|<tabular|<tformat|<cwith|1|-1|1|-1|cell-tborder|1ln>|<cwith|1|-1|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|-1|cell-lborder|0ln>|<cwith|1|-1|1|-1|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|0>|<cell|Transaction
    is invalid.>|<cell|InvalidTransaction
    (<reference|defn-rte-invalid-transaction>)>>|<row|<cell|1>|<cell|Transaction
    validity can't be determined.>|<cell|UnknownTransaction
    (<reference|defn-rte-unknown-transaction>)>>>>>>
      Possible values of varying data type <strong|TransactionValidityError>.
    </big-table>
  </definition>

  <\definition>
    <label|defn-rte-invalid-transaction><strong|InvalidTransaction> is a
    varying data type as defined in Definition
    <reference|defn-varrying-data-type>. Specifies the invalidity of the
    transaction in more detail.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-bborder|1ln>|<cwith|3|3|1|-1|cell-tborder|1ln>|<cwith|2|2|1|1|cell-lborder|0ln>|<cwith|2|2|3|3|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-tborder|0ln>|<cwith|3|3|1|-1|cell-bborder|0ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|5|5|1|-1|cell-tborder|1ln>|<cwith|4|4|1|1|cell-lborder|0ln>|<cwith|4|4|3|3|cell-rborder|0ln>|<cwith|6|6|1|-1|cell-tborder|0ln>|<cwith|5|5|1|-1|cell-bborder|0ln>|<cwith|6|6|1|-1|cell-bborder|1ln>|<cwith|7|7|1|-1|cell-tborder|1ln>|<cwith|6|6|1|1|cell-lborder|0ln>|<cwith|6|6|3|3|cell-rborder|0ln>|<cwith|8|8|1|-1|cell-tborder|0ln>|<cwith|7|7|1|-1|cell-bborder|0ln>|<cwith|8|8|1|-1|cell-bborder|1ln>|<cwith|9|9|1|-1|cell-tborder|1ln>|<cwith|8|8|1|1|cell-lborder|0ln>|<cwith|8|8|3|3|cell-rborder|0ln>|<cwith|11|11|1|-1|cell-bborder|1ln>|<cwith|12|12|1|-1|cell-tborder|1ln>|<cwith|11|11|1|1|cell-lborder|0ln>|<cwith|11|11|3|3|cell-rborder|0ln>|<cwith|13|13|1|-1|cell-tborder|0ln>|<cwith|12|12|1|-1|cell-bborder|0ln>|<cwith|13|13|1|-1|cell-bborder|1ln>|<cwith|14|14|1|-1|cell-tborder|1ln>|<cwith|13|13|1|1|cell-lborder|0ln>|<cwith|13|13|3|3|cell-rborder|0ln>|<cwith|15|15|1|-1|cell-tborder|0ln>|<cwith|14|14|1|-1|cell-bborder|0ln>|<cwith|15|15|1|-1|cell-bborder|1ln>|<cwith|16|16|1|-1|cell-tborder|1ln>|<cwith|15|15|1|1|cell-lborder|0ln>|<cwith|15|15|3|3|cell-rborder|0ln>|<cwith|10|10|1|-1|cell-tborder|0ln>|<cwith|9|9|1|-1|cell-bborder|0ln>|<cwith|10|10|1|-1|cell-bborder|1ln>|<cwith|11|11|1|-1|cell-tborder|1ln>|<cwith|10|10|1|1|cell-lborder|0ln>|<cwith|10|10|3|3|cell-rborder|0ln>|<cwith|17|17|1|-1|cell-tborder|0ln>|<cwith|16|16|1|-1|cell-bborder|0ln>|<cwith|17|17|1|1|cell-lborder|0ln>|<cwith|17|17|3|3|cell-rborder|0ln>|<cwith|19|19|1|-1|cell-bborder|1ln>|<cwith|18|19|1|1|cell-lborder|0ln>|<cwith|18|19|3|3|cell-rborder|0ln>|<cwith|18|18|1|-1|cell-tborder|1ln>|<cwith|17|17|1|-1|cell-bborder|1ln>|<cwith|18|18|1|-1|cell-bborder|0ln>|<cwith|19|19|1|-1|cell-tborder|0ln>|<cwith|18|18|1|1|cell-lborder|0ln>|<cwith|18|18|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|0>|<cell|Call
    of the transaction is not expected.>|<cell|None>>|<row|<cell|1>|<cell|General
    error to do with the inability to pay>|<cell|None>>|<row|<cell|>|<cell|some
    fees (e.g. account balance too low).>|<cell|>>|<row|<cell|2>|<cell|General
    error to do with the transaction>|<cell|None>>|<row|<cell|>|<cell|not
    being valid (e.g. nonce too high).>|<cell|>>|<row|<cell|3>|<cell|General
    error to do with the transaction being>|<cell|None>>|<row|<cell|>|<cell|outdated
    (e.g. nonce too low).>|<cell|>>|<row|<cell|4>|<cell|General error to do
    with the transactions's>|<cell|None>>|<row|<cell|>|<cell|proof (e.g.
    signature)>|<cell|>>|<row|<cell|5>|<cell|The transaction birth block is
    ancient.>|<cell|None>>|<row|<cell|6>|<cell|The transaction would exhaust
    the resources>|<cell|None>>|<row|<cell|>|<cell|of the current
    block.>|<cell|>>|<row|<cell|7>|<cell|Some unknown error
    occured.>|<cell|Unsigned>>|<row|<cell|>|<cell|>|<cell|8-bit
    integer>>|<row|<cell|8>|<cell|An extrinsic with mandatory dispatch
    resulted>|<cell|None>>|<row|<cell|>|<cell|in an
    error.>|<cell|>>|<row|<cell|9>|<cell|A transaction with a mandatory
    dispatch (only in->|<cell|None>>|<row|<cell|>|<cell|herents are allowed
    to have mandatory dispatch).>|<cell|>>>>>>
      Possible values of varying data type <strong|InvalidTransaction>.
    </big-table>
  </definition>

  <\definition>
    <label|defn-rte-unknown-transaction><strong|UnknownTransaction> is a
    varying data type as defined in Definition
    <reference|defn-varrying-data-type>. Specifies the unknown invalidity of
    the transaction in more detail.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|5|5|1|-1|cell-tborder|1ln>|<cwith|4|4|1|1|cell-lborder|0ln>|<cwith|4|4|3|3|cell-rborder|0ln>|<cwith|6|6|1|-1|cell-tborder|0ln>|<cwith|5|5|1|-1|cell-bborder|0ln>|<cwith|6|6|1|-1|cell-bborder|1ln>|<cwith|6|6|1|1|cell-lborder|0ln>|<cwith|6|6|3|3|cell-rborder|0ln>|<cwith|3|3|1|-1|cell-tborder|0ln>|<cwith|2|2|1|-1|cell-bborder|0ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|3|3|1|1|cell-lborder|0ln>|<cwith|3|3|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|0>|<cell|Could
    not lookup some information that is required
    to>|<cell|None>>|<row|<cell|>|<cell|validate the
    transaction.>|<cell|>>|<row|<cell|1>|<cell|No validator found for the
    given unsigned transaction.>|<cell|None>>|<row|<cell|2>|<cell|Any other
    custom unknown validity that is not covered>|<cell|Unsigned>>|<row|<cell|>|<cell|by
    this enum.>|<cell|8-bit integer>>>>>>
      Possible values of varying data type <strong|UnknownTransaction>.
    </big-table>
  </definition>

  \;

  <subsection|<verbatim|BlockBuilder_inherent_extrinsics>>

  Generates the inherent extrinsics, which are explained in more detail in
  section <reference|sect-inherents>. This function takes a SCALE encoded
  hashtable as defined in section <reference|defn-scale-list> and returns an
  array of extrinsics. The Polkadot Host must submit each of those to
  <verbatim|BlockBuilder_apply_extrinsic>, described in section
  <reference|sect-rte-apply-extrinsic>. This procedure is outlined in
  algorithm <reference|algo-build-block>.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>A <name|Inherents-Data> structure as defined in
    <reference|defn-inherent-data>.
  </itemize>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>An array of extrinisic where each extrinsic is a variable byte
    array.
  </itemize-dot>

  <subsection|<verbatim|BlockBuilder_finalize_block>><label|defn-rt-blockbuilder-finalize-block>

  Finalize the block - it is up to the caller to ensure that all header
  fields are valid except for the state root. State changes resulting from
  calling this function are usually meant to persist upon successful
  execution of the function and appending of the block to the chain

  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|6>
    <associate|page-first|113>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|A|107>>
    <associate|auto-10|<tuple|A.2.5|109>>
    <associate|auto-11|<tuple|A.2|109>>
    <associate|auto-12|<tuple|A.2.6|109>>
    <associate|auto-13|<tuple|A.2.7|109>>
    <associate|auto-14|<tuple|A.3|110>>
    <associate|auto-15|<tuple|A.4|110>>
    <associate|auto-16|<tuple|A.5|110>>
    <associate|auto-17|<tuple|A.6|111>>
    <associate|auto-18|<tuple|A.2.8|111>>
    <associate|auto-19|<tuple|A.7|111>>
    <associate|auto-2|<tuple|A.1|107>>
    <associate|auto-20|<tuple|A.8|111>>
    <associate|auto-21|<tuple|A.9|112>>
    <associate|auto-22|<tuple|A.10|112>>
    <associate|auto-23|<tuple|A.11|?>>
    <associate|auto-24|<tuple|A.12|?>>
    <associate|auto-25|<tuple|A.13|?>>
    <associate|auto-26|<tuple|A.2.9|?>>
    <associate|auto-27|<tuple|A.2.10|?>>
    <associate|auto-3|<tuple|A.1|107>>
    <associate|auto-4|<tuple|A.2|107>>
    <associate|auto-5|<tuple|A.2.1|108>>
    <associate|auto-6|<tuple|A.1|108>>
    <associate|auto-7|<tuple|A.2.2|108>>
    <associate|auto-8|<tuple|A.2.3|108>>
    <associate|auto-9|<tuple|A.2.4|109>>
    <associate|defn-invalid-transaction|<tuple|A.4|110>>
    <associate|defn-rt-apisvec|<tuple|A.1|?>>
    <associate|defn-rt-blockbuilder-finalize-block|<tuple|A.2.10|112>>
    <associate|defn-rt-core-version|<tuple|A.2.1|108>>
    <associate|defn-rte-apply-extrinsic-result|<tuple|A.6|?>>
    <associate|defn-rte-custom-module-error|<tuple|A.9|?>>
    <associate|defn-rte-dispatch-error|<tuple|A.8|?>>
    <associate|defn-rte-dispatch-outcome|<tuple|A.7|?>>
    <associate|defn-rte-invalid-transaction|<tuple|A.11|?>>
    <associate|defn-rte-transaction-validity-error|<tuple|A.10|?>>
    <associate|defn-rte-unknown-transaction|<tuple|A.12|?>>
    <associate|defn-transaction-validity-error|<tuple|A.3|110>>
    <associate|defn-unknown-transaction|<tuple|A.5|110>>
    <associate|defn-valid-transaction|<tuple|A.2|110>>
    <associate|sect-list-of-runtime-entries|<tuple|A.1|107>>
    <associate|sect-rte-babeapi-epoch|<tuple|A.2.5|109>>
    <associate|sect-rte-core-execute-block|<tuple|A.2.2|?>>
    <associate|sect-rte-grandpa-auth|<tuple|A.2.6|109>>
    <associate|sect-rte-hash-and-length|<tuple|A.2.4|109>>
    <associate|sect-rte-validate-transaction|<tuple|A.2.7|109>>
    <associate|sect-runtime-entries|<tuple|A|107>>
    <associate|snippet-runtime-enteries|<tuple|A.1|107>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|figure>
      <tuple|normal|<surround|<hidden-binding|<tuple>|A.1>||Snippet to export
      entries into tho Wasm runtime module.>|<pageref|auto-3>>
    </associate>
    <\associate|table>
      <tuple|normal|<surround|<hidden-binding|<tuple>|A.1>||Detail of the
      version data type returns from runtime
      <with|font-family|<quote|tt>|language|<quote|verbatim>|version>
      function.>|<pageref|auto-6>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.2>|>
        The tuple provided by <with|font-series|<quote|bold>|math-font-series|<quote|bold>|BabeApi_configuration>.
      </surround>|<pageref|auto-11>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.3>|>
        The tuple provided by <with|font-family|<quote|tt>|language|<quote|verbatim>|TaggedTransactionQueue_transaction_validity>

        in the case the transaction is judged to be valid.
      </surround>|<pageref|auto-14>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|A.4>||Type variation
      for the return value of <with|font-family|<quote|tt>|language|<quote|verbatim>|TaggedTransactionQueue_transaction_validity>.>|<pageref|auto-15>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.5>|>
        Type variant whichs gets appended to Id 0 of
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|TransactionValidityError>.
      </surround>|<pageref|auto-16>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.6>|>
        Type variant whichs gets appended to Id 1 of
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|TransactionValidityError>.
      </surround>|<pageref|auto-17>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.7>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|ApplyExtrinsicResult>.
      </surround>|<pageref|auto-19>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.8>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|DispatchOutcome>.
      </surround>|<pageref|auto-20>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.9>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|DispatchError>.
      </surround>|<pageref|auto-21>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.10>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|CustomModuleError>.
      </surround>|<pageref|auto-22>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.11>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|TransactionValidityError>.
      </surround>|<pageref|auto-23>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.12>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|InvalidTransaction>.
      </surround>|<pageref|auto-24>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.13>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|UnknownTransaction>.
      </surround>|<pageref|auto-25>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Runtime Entries> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      A.1<space|2spc>List of Runtime Entries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      A.2<space|2spc>Argument Specification
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>

      <with|par-left|<quote|1tab>|A.2.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_version>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1tab>|A.2.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_execute_block>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|1tab>|A.2.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_initialize_block>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|A.2.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|hash_and_length>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|A.2.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|BabeApi_configuration>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|1tab>|A.2.6<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|GrandpaApi_grandpa_authorities>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|A.2.7<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|TaggedTransactionQueue_validate_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|1tab>|A.2.8<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|BlockBuilder_apply_extrinsic>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|1tab>|A.2.9<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|BlockBuilder_inherent_extrinsics>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|1tab>|A.2.10<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|BlockBuilder_finalize_block>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>
    </associate>
  </collection>
</auxiliary>