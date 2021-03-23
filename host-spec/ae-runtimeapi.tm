<TeXmacs|1.99.18>

<project|host-spec.tm>

<style|<tuple|book|old-dots|old-lengths>>

<\body>
  <appendix|Polkadot Runtime API><label|sect-runtime-entries>

  <section|General Information>

  The Polkadot Host assumes that at least the constants and functions
  described in this chapter are implemented in the Runtime Wasm blob.\ 

  It should be noted that the API can change through runtime updates.
  Therefore a host should check the API versions of each module returned in
  the <verbatim|api> field by <verbatim|Core_version> (Section
  <reference|defn-rt-core-version>) after every runtime upgrade and warn if
  an updated API is encountered and that this might require an update of the
  host.

  <subsection|JSON-RPC API for external services><label|sect-json-rpc-api>

  Polkadot Host implementers are encouraged to implement an API in order for
  external, third-party services to interact with the node. The
  <hlink|JSON-RPC Interface for Polkadot Nodes|https://github.com/w3f/PSPs/blob/master/PSPs/drafts/psp-6.md>
  (PSP Number 006) is a Polkadot Standard Proposal for such an API and makes
  it easier to integrate the node with exisiting tools available in the
  Polkadot ecosystem, such as <hlink|polkadot.js.org|https://polkadot.js.org/>.
  The Runtime API has a few modules designed specifically for use in the
  official RPC API.

  <section|Runtime Constants>

  <subsection|<verbatim|__heap_base>>

  This constant indicates the beginning of the heap in memory. The space
  below is reserved for the stack and data section. For more details please
  refer to Section <reference|sect-ext-allocator>.

  <section|Runtime Functions>

  In this section, we describe all Runtime API functions alongside their
  arguments and the return values. The functions are organzied into modules
  with each being versioned independently.

  <\definition>
    The <with|font-series|bold|Runtime API Call Convention> describes that
    all functions receive and return SCALE encoded data and as a result have
    the following prototype signature

    \;

    <\verbatim>
      (func $generic_runtime_entry

      \ \ (param $ptr i32) (parm $len i32) (result i64))
    </verbatim>

    \;

    where <verbatim|ptr> points to the SCALE encoded tuple of the paramaters
    passed to the function and <verbatim|len> is the length of this data,
    while <verbatim|result> is a pointer-size (Definition
    <reference|defn-runtime-pointer-size>) to the SCALE encoded return data.
  </definition>

  See Section <reference|sect-code-executor> for more information about the
  behavior of the Wasm Runtime. Do note that any state changes created by
  calling any of the Runtime functions are not necessarily to be persisted
  after the call is ended. See Section <reference|sect-handling-runtime-state-update>
  for more information.

  <subsection|Core Module (Version 3)>

  <subsubsection|<verbatim|Core_version>><label|defn-rt-core-version>

  Returns the version identifiers of the Runtime. This function can be used
  by the Polkadot Host implementation when it seems appropriate, such as for
  the JSON-RPC API as described in Section <reference|sect-json-rpc-api>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A datastructure of the following format:

    \;

    <big-table|<tabular|<tformat|<cwith|1|8|1|1|cell-halign|l>|<cwith|1|8|1|1|cell-lborder|0ln>|<cwith|1|8|2|2|cell-halign|l>|<cwith|1|8|3|3|cell-halign|l>|<cwith|1|8|3|3|cell-rborder|0ln>|<cwith|1|8|1|3|cell-valign|c>|<cwith|1|1|1|3|cell-tborder|1ln>|<cwith|1|1|1|3|cell-bborder|1ln>|<cwith|8|8|1|3|cell-bborder|1ln>|<cwith|2|-1|1|1|font-base-size|8>|<cwith|2|-1|2|-1|font-base-size|8>|<table|<row|<cell|Name>|<cell|Type>|<cell|Description>>|<row|<cell|<verbatim|spec_name>>|<cell|String>|<cell|Runtime
    identifier>>|<row|<cell|<verbatim|impl_name>>|<cell|String>|<cell|the
    name of the implementation (e.g. C++)>>|<row|<cell|<verbatim|authoring_version>>|<cell|UINT32>|<cell|the
    version of the authorship interface>>|<row|<cell|<verbatim|spec_version>>|<cell|UINT32>|<cell|the
    version of the Runtime specification>>|<row|<cell|<verbatim|impl_version>>|<cell|UINT32>|<cell|the
    v<verbatim|>ersion of the Runtime implementation>>|<row|<cell|<verbatim|apis>>|<cell|ApisVec
    (<reference|defn-rt-apisvec>)>|<cell|List of supported APIs along with
    their version>>|<row|<cell|<verbatim|transaction_version>>|<cell|UINT32>|<cell|the
    version of the transaction format>>>>>|Detail of the version data type
    returns from runtime <verbatim|version> function.>

    <\definition>
      <label|defn-rt-apisvec><strong|ApisVec> is a specialised type for the
      <verbatim|Core_version> (<reference|defn-rt-core-version>) function
      entry. It represents an array of tuples, where the first value of the
      tuple is an array of 8-bytes containing the Blake2b hash of the API
      name. The second value of the tuple is the version number of the
      corresponding API.

      <\eqnarray*>
        <tformat|<table|<row|<cell|ApiVec>|<cell|\<assign\>>|<cell|<around*|(|T<rsub|0>,\<ldots\>,T<rsub|n>|)>>>|<row|<cell|T>|<cell|\<assign\>>|<cell|<around*|(|<around*|(|b<rsub|0>,\<ldots\>,b<rsub|7>|)>,UINT32|)>>>>>
      </eqnarray*>
    </definition>
  </itemize-dot>

  Requires <verbatim|Core_intialize_block> to be called beforehand.

  <subsubsection|<verbatim|Core_execute_block>><label|sect-rte-core-execute-block>

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
    <item>A block represented as a tuple consisting of a block header as
    described in section <reference|defn-block-header> and the block body as
    described in section <reference|defn-block-body>.
  </itemize>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  <subsubsection|<verbatim|Core_initialize_block>><label|sect-rte-core-initialize-block>

  Sets up the environment required for building a new block as described in
  Algorithm <reference|algo-build-block>.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>The header of the new block as defined in
    <reference|defn-block-header>. The values <math|H<rsub|r>,H<rsub|e> and
    H<rsub|d>> are left empty.
  </itemize>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  <subsection|Metadata Module (Version 1)>

  All calls in this module require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called first.

  <subsubsection|<verbatim|Metadata_metadata>>

  Returns native Runtime metadata in an opaque form. This function can be
  used by the Polkadot Host implementation when it seems appropriate, such as
  for the JSON-RPC API as described in Section <reference|sect-json-rpc-api>.
  and returns all the information necessary to build valid transactions.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A byte array of varying size containing the metadata in an opaque
    form.
  </itemize-dot>

  <subsection|BlockBuilder Module (Version 4)>

  All calls in this module require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called beforehand.

  <subsubsection|<verbatim|BlockBuilder_apply_extrinsic>>
  <label|sect-rte-apply-extrinsic>

  Apply the extrinsic outside of the block execution function. This does not
  attempt to validate anything regarding the block, but it builds a list of
  transaction hashes.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>A byte array of varying size containing the extrinsic.
  </itemize>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>Returns the varying datatype <verbatim|ApplyExtrinsicResult> as
    defined in Definition <reference|defn-rte-apply-extrinsic-result>. This
    structure let's the block builder know whether an extrinsic should be
    included into the block or rejected.

    \;
  </itemize-dot>

  <\definition>
    <label|defn-rte-apply-extrinsic-result><verbatim|ApplyExtrinsicResult> is
    the varying data type <verbatim|Result> as defined in Definition
    <reference|defn-result-type>. This structure can contain multiple nested
    structures, indicating either module dispatch outcomes or transaction
    invalidity errors.

    \;

    <strong|NOTE>: When applying an extrinsic returns a
    <verbatim|DispatchOutcome> (<reference|defn-rte-dispatch-outcome>), the
    extrinsic is always included into the block, even if the outcome is a
    dispatch error. Dispatch errors do not invalidate the block and all state
    changes are persisted. When applying an extrinsics returns
    <verbatim|TransactionValidityError> (<reference|defn-rte-transaction-validity-error>),
    certain error types indicate whether an extrinsic should be outright
    rejected or requeued for a later block. This behavior is clarified
    further in Definition <reference|defn-rte-invalid-transaction>
    respectively Definition <reference|defn-rte-unknown-transaction>.

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
    data type <verbatim|Result> as defined in Definition
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
    appended after a possible error in <verbatim|DispatchError> as defined in
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
    <reference|defn-varrying-data-type> and specifies the invalidity of the
    transaction in more detail.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-bborder|1ln>|<cwith|3|3|1|-1|cell-tborder|1ln>|<cwith|2|2|1|1|cell-lborder|0ln>|<cwith|2|2|3|3|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-tborder|0ln>|<cwith|3|3|1|-1|cell-bborder|0ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|5|5|1|-1|cell-tborder|1ln>|<cwith|4|4|1|1|cell-lborder|0ln>|<cwith|4|4|3|3|cell-rborder|0ln>|<cwith|6|6|1|-1|cell-tborder|0ln>|<cwith|5|5|1|-1|cell-bborder|0ln>|<cwith|6|6|1|-1|cell-bborder|1ln>|<cwith|7|7|1|-1|cell-tborder|1ln>|<cwith|6|6|1|1|cell-lborder|0ln>|<cwith|6|6|3|3|cell-rborder|0ln>|<cwith|8|8|1|-1|cell-tborder|0ln>|<cwith|7|7|1|-1|cell-bborder|0ln>|<cwith|8|8|1|-1|cell-bborder|1ln>|<cwith|9|9|1|-1|cell-tborder|1ln>|<cwith|8|8|1|1|cell-lborder|0ln>|<cwith|8|8|3|3|cell-rborder|0ln>|<cwith|11|11|1|-1|cell-bborder|1ln>|<cwith|12|12|1|-1|cell-tborder|1ln>|<cwith|11|11|1|1|cell-lborder|0ln>|<cwith|11|11|3|3|cell-rborder|0ln>|<cwith|13|13|1|-1|cell-tborder|0ln>|<cwith|12|12|1|-1|cell-bborder|0ln>|<cwith|13|13|1|-1|cell-bborder|1ln>|<cwith|14|14|1|-1|cell-tborder|1ln>|<cwith|13|13|1|1|cell-lborder|0ln>|<cwith|13|13|3|3|cell-rborder|0ln>|<cwith|15|15|1|-1|cell-tborder|0ln>|<cwith|14|14|1|-1|cell-bborder|0ln>|<cwith|15|15|1|-1|cell-bborder|1ln>|<cwith|16|16|1|-1|cell-tborder|1ln>|<cwith|15|15|1|1|cell-lborder|0ln>|<cwith|15|15|3|3|cell-rborder|0ln>|<cwith|10|10|1|-1|cell-tborder|0ln>|<cwith|9|9|1|-1|cell-bborder|0ln>|<cwith|10|10|1|-1|cell-bborder|1ln>|<cwith|11|11|1|-1|cell-tborder|1ln>|<cwith|10|10|1|1|cell-lborder|0ln>|<cwith|10|10|3|3|cell-rborder|0ln>|<cwith|17|17|1|-1|cell-tborder|0ln>|<cwith|16|16|1|-1|cell-bborder|0ln>|<cwith|17|17|1|1|cell-lborder|0ln>|<cwith|17|17|3|3|cell-rborder|0ln>|<cwith|19|19|1|-1|cell-bborder|1ln>|<cwith|18|19|1|1|cell-lborder|0ln>|<cwith|18|19|3|3|cell-rborder|0ln>|<cwith|18|18|1|-1|cell-tborder|1ln>|<cwith|17|17|1|-1|cell-bborder|1ln>|<cwith|18|18|1|-1|cell-bborder|0ln>|<cwith|19|19|1|-1|cell-tborder|0ln>|<cwith|18|18|1|1|cell-lborder|0ln>|<cwith|18|18|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Type>>|<cell|<strong|Reject>>>|<row|<cell|0>|<cell|Call
    of the transaction is not expected.>|<cell|None>|<cell|Yes>>|<row|<cell|1>|<cell|General
    error to do with the inability to pay>|<cell|None>|<cell|Yes>>|<row|<cell|>|<cell|some
    fees (e.g. account balance too low).>|<cell|>|<cell|>>|<row|<cell|2>|<cell|General
    error to do with the transaction>|<cell|None>|<cell|No>>|<row|<cell|>|<cell|not
    yet being valid (e.g. nonce too high).>|<cell|>|<cell|>>|<row|<cell|3>|<cell|General
    error to do with the transaction being>|<cell|None>|<cell|Yes>>|<row|<cell|>|<cell|outdated
    (e.g. nonce too low).>|<cell|>|<cell|>>|<row|<cell|4>|<cell|General error
    to do with the transactions's>|<cell|None>|<cell|Yes>>|<row|<cell|>|<cell|proof
    (e.g. signature)>|<cell|>|<cell|>>|<row|<cell|5>|<cell|The transaction
    birth block is ancient.>|<cell|None>|<cell|Yes>>|<row|<cell|6>|<cell|The
    transaction would exhaust the resources>|<cell|None>|<cell|No>>|<row|<cell|>|<cell|of
    the current block.>|<cell|>|<cell|>>|<row|<cell|7>|<cell|Some unknown
    error occured.>|<cell|Unsigned>|<cell|Yes>>|<row|<cell|>|<cell|>|<cell|8-bit
    integer>|<cell|>>|<row|<cell|8>|<cell|An extrinsic with mandatory
    dispatch resulted>|<cell|None>|<cell|Yes>>|<row|<cell|>|<cell|in an
    error.>|<cell|>|<cell|>>|<row|<cell|9>|<cell|A transaction with a
    mandatory dispatch (only in->|<cell|None>|<cell|Yes>>|<row|<cell|>|<cell|herents
    are allowed to have mandatory dispatch).>|<cell|>|<cell|>>>>>>
      Possible values of varying data type <strong|InvalidTransaction>.
    </big-table>
  </definition>

  <\definition>
    <label|defn-rte-unknown-transaction><strong|UnknownTransaction> is a
    varying data type as defined in Definition
    <reference|defn-varrying-data-type> and specifies the unknown invalidity
    of the transaction in more detail.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|5|5|1|-1|cell-tborder|1ln>|<cwith|4|4|1|1|cell-lborder|0ln>|<cwith|4|4|3|3|cell-rborder|0ln>|<cwith|6|6|1|-1|cell-tborder|0ln>|<cwith|5|5|1|-1|cell-bborder|0ln>|<cwith|6|6|1|-1|cell-bborder|1ln>|<cwith|6|6|1|1|cell-lborder|0ln>|<cwith|6|6|3|3|cell-rborder|0ln>|<cwith|3|3|1|-1|cell-tborder|0ln>|<cwith|2|2|1|-1|cell-bborder|0ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|3|3|1|1|cell-lborder|0ln>|<cwith|3|3|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>|<cell|<strong|Type>>|<cell|<strong|Reject>>>|<row|<cell|0>|<cell|Could
    not lookup some information that is required
    to>|<cell|None>|<cell|Yes>>|<row|<cell|>|<cell|validate the
    transaction.>|<cell|>|<cell|>>|<row|<cell|1>|<cell|No validator found for
    the given unsigned transaction.>|<cell|None>|<cell|Yes>>|<row|<cell|2>|<cell|Any
    other custom unknown validity that is not
    covered>|<cell|Unsigned>|<cell|Yes>>|<row|<cell|>|<cell|by this
    type.>|<cell|8-bit integer>|<cell|>>>>>>
      Possible values of varying data type <strong|UnknownTransaction>.
    </big-table>
  </definition>

  <subsubsection|<verbatim|BlockBuilder_finalize_block>><label|defn-rt-blockbuilder-finalize-block>

  Finalize the block - it is up to the caller to ensure that all header
  fields are valid except for the state root. State changes resulting from
  calling this function are usually meant to persist upon successful
  execution of the function and appending of the block to the chain.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>The header of the new block as defined in
    <reference|defn-block-header>.
  </itemize-dot>

  <subsubsection|<verbatim|BlockBuilder_inherent_extrinsics>><label|defn-rt-builder-inherent-extrinsics>

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
    <item>A byte array of varying size containing extrinisics. Each extrinsic
    is a byte array of varying size.
  </itemize-dot>

  <subsubsection|<verbatim|BlockBuilder_check_inherents>>

  Checks whether the provided inherent is valid. This function can be used by
  the Polkadot Host implementation when verifying the validaity of an
  inherent seems appropriate, such as during a block building process.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>A block represented as a tuple consisting of a block header as
    described in section <reference|defn-block-header> and the block body as
    described in section <reference|defn-block-body>.

    <item>A <name|Inherents-Data> structure as defined in
    <reference|defn-inherent-data>.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A datastructure of the following format:

    <\equation*>
      <around*|(|o,f<rsub|e>,e|)>
    </equation*>

    where

    <\itemize-dot>
      <item><math|o> is a boolean indicating whether the check was
      successful.

      <item><math|f<rsub|e>> is a boolean indicating whether a fatal error
      was encountered.

      <item><math|e> is a <name|Inherents-Data> structure as defined in
      <reference|defn-inherent-data> containing any errors created by this
      Runtime function.
    </itemize-dot>
  </itemize-dot>

  <subsubsection|<verbatim|BlockBuilder_random_seed>>

  Generates a random seed. <todo|there is currently no requirement for having
  to call this function.>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A 32-byte array containing the random seed.
  </itemize-dot>

  <subsection|TaggedTransactionQueue (Version 2)>

  All calls in this module require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called beforehand.

  <subsubsection|<verbatim|TaggedTransactionQueue_validate_transaction>><label|sect-rte-validate-transaction>

  This entry is invoked against extrinsics submitted through the transaction
  network message <reference|sect-msg-transactions> and indicates if the
  submitted blob represents a valid extrinsics applied to the specified
  block. This function gets called internally when executing blocks with the
  <verbatim|Core_execute_block> runtime function as described in section
  <reference|sect-rte-core-execute-block>.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>The source of the transaction as defined in Definition
    <reference|defn-transaction-source>.

    <item>A byte array that contains the transaction.

    \;
  </itemize>

  <\definition>
    <label|defn-transaction-source><with|font-series|bold|TransactionSource>
    is a enum describing the source of a transaciton and can have one of the
    following values:

    <\big-table>
      <tabular|<tformat|<cwith|1|1|1|-1|font-series|bold>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|1|cell-lborder|0ln>|<cwith|2|-1|3|3|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|4|4|3|3|cell-bborder|0ln>|<cwith|4|4|3|3|cell-rborder|0ln>|<cwith|4|4|1|2|cell-bborder|0ln>|<cwith|4|4|1|1|cell-lborder|0ln>|<cwith|4|4|2|2|cell-rborder|0ln>|<cwith|4|4|3|3|cell-lborder|0ln>|<cwith|3|3|1|-1|cell-tborder|1ln>|<cwith|2|2|1|-1|cell-bborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|3|3|1|1|cell-lborder|0ln>|<cwith|3|3|3|3|cell-rborder|0ln>|<table|<row|<cell|Id>|<cell|Name>|<cell|Description>>|<row|<cell|0>|<cell|<with|font-shape|italic|<with|font-shape|italic|<with|font-shape|italic|InBlock>>>>|<cell|Transaction
      is already included in block.>>|<row|<cell|1>|<cell|<with|font-shape|italic|Loc<with|font-shape|right|>al>>|<cell|Transaction
      is coming from a local source, e.g. off-chain
      worker.>>|<row|<cell|2>|<cell|<with|font-shape|italic|<with|font-shape|italic|External<underline|>>>>|<cell|Transaction
      has been received externally, e.g over the network,>>>>>
    <|big-table>
      The <verbatim|TransactionSource> enum\ 
    </big-table>
  </definition>

  <strong|Return>:This function returns a <verbatim|Result> as defined in
  Definition <reference|defn-result-type> which contains the type
  <em|<verbatim|ValidTransaction>> as defined in Definition
  <reference|defn-valid-transaction> on success and the type
  <em|<verbatim|TransactionValidityError>> as defined in Definition
  <reference|defn-rte-transaction-validity-error> on failure.

  <\definition>
    <label|defn-valid-transaction><strong|ValidTransaction> is a tuple which
    contains information concerning a valid transaction.

    \;

    <\big-table|<tabular|<tformat|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-bborder|0ln>|<cwith|5|5|1|-1|cell-tborder|0ln>|<cwith|6|6|1|-1|cell-tborder|1ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|6|6|1|-1|cell-bborder|0ln>|<cwith|7|7|1|-1|cell-tborder|0ln>|<cwith|9|9|1|-1|cell-tborder|1ln>|<cwith|8|8|1|-1|cell-bborder|1ln>|<cwith|9|9|1|-1|cell-bborder|0ln>|<cwith|10|10|1|-1|cell-tborder|0ln>|<cwith|11|11|1|-1|cell-tborder|1ln>|<cwith|10|10|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<cwith|1|-1|2|2|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-rborder|>|<cwith|1|1|2|2|cell-lborder|0ln>|<cwith|1|1|1|1|cell-rborder|0ln>|<cwith|1|1|3|3|cell-lborder|0ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|12|12|1|1|cell-tborder|0ln>|<cwith|11|11|1|1|cell-bborder|0ln>|<cwith|12|12|2|2|cell-tborder|0ln>|<cwith|11|11|2|2|cell-bborder|0ln>|<cwith|12|12|2|2|cell-lborder|0ln>|<cwith|12|12|1|1|cell-rborder|0ln>|<cwith|2|-1|3|3|cell-lborder|0ln>|<cwith|2|-1|2|2|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|12|12|3|3|cell-tborder|0ln>|<cwith|11|11|3|3|cell-bborder|0ln>|<cwith|12|12|3|3|cell-lborder|0ln>|<cwith|12|12|2|2|cell-rborder|0ln>|<cwith|12|12|1|-1|cell-bborder|0ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Name>>|<cell|<strong|Description>>|<cell|<strong|Type>>>|<row|<cell|Priority>|<cell|Determines
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
    </big-table>
  </definition>

  <strong|Note>: If <em|Propagate> is set to <verbatim|false> the transaction
  will still be considered for including in blocks that are authored on the
  current node, but will never be sent to other peers.

  \;

  <strong|Note>: If this function gets called by the Polkadot Host in order
  to validate a transaction received from peers, the Polkadot Host disregards
  and rewinds state changes resulting for such a call.

  <subsection|OffchainWorkerApi Module (Version 2)>

  Does not require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called beforehand.

  <subsubsection|<verbatim|OffchainWorkerApi_offchain_worker>>

  Starts an offchain worker and generates extrinsics. <todo|when is this
  called?>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>The block header as defined in <reference|defn-block-header>.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  <subsection|ParachainHost Module (Version 1)>

  <subsubsection|<verbatim|ParachainHost_validators>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_validator_groups>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_availability_cores>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_persisted_validation_data>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_check_validation_outputs>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_session_index_for_child>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_session_info>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_validation_code>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_historical_validation_code>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_candidate_pending_availability>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_candidate_events>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_dmq_contents>>

  <todo|future-reserved>

  <subsubsection|<verbatim|ParachainHost_inbound_hrmp_channel_contents>>

  <todo|future-reserved>

  <subsection|GrandpaApi Module (Version 2)>

  All calls in this module require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called beforehand.

  <subsubsection|<verbatim|GrandpaApi_grandpa_authorities>><label|sect-rte-grandpa-auth>

  This entry fetches the list of GRANDPA authorities according to the genesis
  block and is used to initialize authority list defined in Definition
  <reference|defn-authority-list>, at genisis. Any future authority changes
  get tracked via Runtiem-to-consensus engine messages as described in
  Section <reference|sect-consensus-message-digest>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>An array of variying size containg tuple pairs of the following
    format:

    <\equation*>
      <around*|(|A<rsub|id>,w|)>
    </equation*>

    where <math|A<rsub|id>> is the 256-bit public key of an authority and
    <math|w> is a unsigned 64-bit integer representing the weight of an
    authority. <todo|what does this weight indicate?>
  </itemize-dot>

  <subsubsection|<verbatim|GrandpaApi_submit_report_equivocation_unsigned_extrinsic>><label|sect-grandpaapi_submit_report_equivocation_unsigned_extrinsic>

  Submits a report about an observed equivocation as defined in Definition
  <reference|defn-equivocation>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>The equivocation proof. <todo|reference that type>

    <item>An proof of the key owner in an opaque form as described in Section
    <reference|sect-grandpaapi_generate_key_ownership_proof>.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A SCALE encoded <verbatim|Option> as defined in Definition
    <reference|defn-option-type> containing an empty value on success.
  </itemize-dot>

  <subsubsection|<verbatim|GrandpaApi_generate_key_ownership_proof>><label|sect-grandpaapi_generate_key_ownership_proof>

  Generates a proof of the membership of a key owner in the specified block
  state. The returned value is used to report equivocations as described in
  Section <reference|sect-grandpaapi_submit_report_equivocation_unsigned_extrinsic>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>The authority set Id as defined in Definition
    <reference|defn-authority-set-id>.

    <item>The 256-bit public key of the authority.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A SCALE encoded <verbatim|Option> as defined in Definition
    <reference|defn-option-type> containing the proof in an opaque form.
  </itemize-dot>

  <subsection|BabeApi Module (Version 2)>

  All calls in this module require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called beforehand.

  <subsubsection|<verbatim|BabeApi_configuration>><label|sect-rte-babeapi-epoch>

  This entry is called to obtain the current configuration of BABE consensus
  protocol.

  \;

  <strong|Arguments>:

  <\itemize>
    <item>None.
  </itemize>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A tuple containing configuration data used by the Babe consensus
    engine.
  </itemize-dot>

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

  <subsubsection|<verbatim|BabeApi_current_epoch_start>>

  Finds the start slot of the current epoch.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A unsigned 64-bit integer indicating the slot number.
  </itemize-dot>

  <subsubsection|<verbatim|BabeApi_current_epoch>><label|sect-babeapi_current_epoch>

  Produces information about the current epoch.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A datastructure of the following format:

    <\equation*>
      <around*|(|e<rsub|i>,s<rsub|s>,d,A,r|)>
    </equation*>

    where:

    <\itemize-dot>
      <item><math|e<rsub|i>> is a unsigned 64-bit integer representing the
      epoch index.

      <item><math|s<rsub|s>> is a unsigned 64-bit integer representing the
      starting slot of the epoch.

      <item><math|d> is a unsigned 64-bit integer representing the duration
      of the epoch.

      <item><math|A> is an array of varying size containing tuple pairs of
      the following format:

      <\equation*>
        <around*|(|A<rsub|id>,w|)>
      </equation*>

      where <math|A<rsub|id>> is the 256-bit public key of an authority and
      <math|w> is a unsigned 64-bit integer representing the weight of an
      authority. <todo|what does this weight indicate?>

      <item><math|r> is an 256-bit array containing the randomness for the
      epoch as defined in Definition <reference|defn-epoch-randomness>.
    </itemize-dot>
  </itemize-dot>

  <subsubsection|<verbatim|BabeApi_next_epoch>>

  Produces information about the next epoch.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>Returns the same datastructure as described in Section
    <reference|sect-babeapi_current_epoch>.
  </itemize-dot>

  <subsubsection|<verbatim|BabeApi_generate_key_ownership_proof>><label|sect-babeapi_generate_key_ownership_proof>

  Generates a proof of the membership of a key owner in the specified block
  state. The returned value is used to report equivocations as described in
  <todo|spec Babe equivocation>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>The unsigned 64-bit integer indicating the slot number.

    <item>The 256-bit public key of the authority.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A SCALE encoded <verbatim|Option> as defined in Definition
    <reference|defn-option-type> containing the proof in an opaque form.
  </itemize-dot>

  <subsubsection|<verbatim|BabeApi_submit_report_equivocation_unsigned_extrinsic>>

  Submits a report about an observed equivocation as defined in <todo|spec
  Babe equivocations>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>The equivocation proof. <todo|reference that type>

    <item>An proof of the key owner in an opaque form as described in Section
    <reference|sect-babeapi_generate_key_ownership_proof>.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A SCALE encoded <verbatim|Option> as defined in Definition
    <reference|defn-option-type> containing an empty value on success.
  </itemize-dot>

  <subsection|AuthorityDiscoveryApi Module (Version 1)>

  All calls in this module require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called beforehand.

  <subsubsection|<verbatim|AuthorityDiscoveryApi_authorities>>

  A function which helps to discover authorities.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A byte array of varying size containing 256-bit pulic keys of the
    authorities.
  </itemize-dot>

  <subsection|SessionKeys Module (Version 1)>

  All calls in this module require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called beforehand.

  <subsubsection|<verbatim|SessionKeys_generate_session_keys>>

  Generates a set of session keys with an optional seed. The keys should be
  stored within the keystore exposed by the Host Api. The seed needs to be
  valid UTF8 encoded.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>A SCALE encoded <verbatim|Option> as defined in Definition
    <reference|defn-option-type> containing an array of varying size
    indicating the seed.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A byte array of varying size containg the encoded session keys.
  </itemize-dot>

  <subsubsection|<verbatim|SessionKeys_decode_session_keys>>

  Decodes the given public session keys. Returns a list of raw public keys
  including key type.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>An array of varying size containing the encoded public session
    keys.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>An array of varying size containing tuple pairs of the following
    format:

    <\equation*>
      <around*|(|k,k<rsub|id>|)>
    </equation*>

    where <math|k> is an array of varying size containg the raw public key
    and <math|k<rsub|id>> is a 4-byte array indicating the key type.
  </itemize-dot>

  <subsection|AccountNonceApi Module (Version 1)>

  All calls in this module require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called beforehand.

  <subsubsection|<verbatim|AccountNonceApi_account_nonce>><label|sect-accountnonceapi-account-nonce>

  Get the current nonce of an account. This function can be used by the
  Polkadot Host implementation when it seems appropriate, such as for the
  JSON-RPC API as described in Section <reference|sect-json-rpc-api>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>The 256-bit public key of the account.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A 32-bit unsigned integer indicating the nonce of the account.
  </itemize-dot>

  <subsection|TransactionPaymentApi Module (Version 1)>

  All calls in this module require <verbatim|Core_intialize_block> (Section
  <reference|sect-rte-core-initialize-block>) to be called beforehand.

  <subsubsection|<verbatim|TransactionPaymentApi_query_info>>

  Returns information of a given extrinsic. This function is not aware of the
  internals of an extrinsic, but only interprets the extrinsic as some
  encoded value and accounts for its weight and length, the runtime's
  extrinsic base weight and the current fee multiplier.

  \;

  This function can be used by the Polkadot Host implementation when it seems
  appropriate, such as for the JSON-RPC API as described in Section
  <reference|sect-json-rpc-api>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>A byte array of varying size containing the extrinsic.

    <item>The length of the extrinsic. <todo|why is this needed?>
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A datastructure of the following format:

    <\equation*>
      <around*|(|w,c,f|)>
    </equation*>

    where:

    <\itemize-dot>
      <item><math|w> is the weight of the extrinsic.

      <item><math|c> is the \Pclass\Q of the extrinsic, where class is a
      varying datatype defined as:

      <\equation*>
        c=<choice|<tformat|<table|<row|<cell|0<space|1em>Normal
        extrinsic>>|<row|<cell|1<space|1em>Operational
        extrinsic>>|<row|<cell|2<space|1em>Mandatory extrinsic,which is
        always included>>>>>
      </equation*>

      <item><math|f> is the inclusion fee of the extrinsic. This does not
      include a tip or anything else that depends on the signature.
    </itemize-dot>
  </itemize-dot>

  <subsubsection|<verbatim|TransactionPaymentApi_query_fee_details>>

  Query the detailed fee of a given extrinsic. This function can be used by
  the Polkadot Host implementation when it seems appropriate, such as for the
  JSON-RPC API as described in Section <reference|sect-json-rpc-api>.

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>A byte array of varying size containing the extrinsic.

    <item>The length of the extrinsic.
  </itemize-dot>

  \;

  <strong|Return>:

  <\itemize-dot>
    <item>A datastructure of the following format:

    <\equation*>
      <around*|(|f,t|)>
    </equation*>

    where

    <\itemize-dot>
      <item><math|f> is a SCALE encoded <verbatim|Option> as defined in
      Definition <reference|defn-option-type> containing the following
      datastructure:

      <\equation*>
        <around*|(|f<rsub|b>,f<rsub|l>,f<rsub|a>|)>
      </equation*>

      where

      <\itemize-dot>
        <item><math|f<rsub|b>> is the minimum required fee for an extrinsic.

        <item><math|f<rsub|l>> is the length fee, the amount paid for the
        encoded length (in bytes) of the extrinsic.

        <item><math|f<rsub|a>> is the \Padjusted weight fee\Q, which is a
        multiplication of the fee multiplier and the weight fee. The fee
        multiplier varies depending on the usage of the network.
      </itemize-dot>

      <item><math|t> is the tip for the block author.
    </itemize-dot>
  </itemize-dot>

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;

</body>

