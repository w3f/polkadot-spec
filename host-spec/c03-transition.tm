<TeXmacs|1.99.17>

<project|host-spec.tm>

<style|<tuple|book|algorithmacs-style|old-dots|old-lengths>>

<\body>
  <chapter|State Transition><label|chap-state-transit>

  Like any transaction-based transition system, Polkadot's state is changed
  by executing an ordered set of instructions. These instructions are known
  as <em|extrinsics>. In Polkadot, the execution logic of the
  state-transition function is encapsulated in a Runtime as defined in
  Definition <reference|defn-state-machine>. For easy upgradability this
  Runtime is presented as a Wasm blob. Nonetheless, the Polkadot Host needs
  to be in constant interaction with the Runtime. The detail of such
  interaction is further described in Section
  <reference|sect-entries-into-runtime>.

  In Section <reference|sect-extrinsics>, we specify the procedure of the
  process where the extrinsics are submitted, pre-processed and validated by
  Runtime and queued to be applied to the current state.

  \ To make state replication feasible, Polkadot journals and batches series
  of its extrinsics together into a structure known as a <em|block>, before
  propagating them to other nodes, similar to most other prominent
  distributed ledger systems. The specification of the Polkadot block as well
  as the process of verifying its validity are both explained in Section
  <reference|sect-state-replication>.

  <section|Interacting with the Runtime><label|sect-entries-into-runtime>

  The Runtime as defined in Definition <reference|defn-runtime> is the code
  implementing the logic of the chain. This code is decoupled from the
  Polkadot Host to make the the logic of the chain easily upgradable without
  the need to upgrade the Polkadot Host itself. The general procedure to
  interact with the Runtime is described in Algorithm
  <reference|algo-runtime-interaction>.

  <\algorithm>
    <label|algo-runtime-interaction><name|Interact-With-Runtime>(<math|F>:
    runtime entry to call,\ 

    <math|H<rsub|b><around*|(|B|)>>: Block hash indicating the state at the
    end of <math|B>,\ 

    <math|A<rsub|1>,A<rsub|2>,\<ldots\>,A<rsub|n>>: arguments to be passed to
    the runtime entry)
  <|algorithm>
    <\algorithmic>
      <\state>
        <name|<math|\<cal-S\><rsub|B>\<leftarrow\>>Set-State-At(<math|H<rsub|b><around*|(|B|)>>)>
      </state>

      <\state>
        <math|A\<leftarrow\>Enc<rsub|SC><around*|(|<around*|(|A<rsub|1>,\<ldots\>,A<rsub|n>|)>|)>>
      </state>

      <\state>
        <math|<text|<name|Call-Runtime-Entry>><around*|(|R<rsub|B>,\<cal-R\>\<cal-E\><rsub|B>,F,A,A<rsub|len>|)>>
      </state>
    </algorithmic>
  </algorithm>

  In this section, we describe the details upon which the Polkadot Host is
  interacting with the Runtime. In particular, <name|Set-State-At> and
  <name|Call-Runtime-Entry> procedures called in Algorithm
  <reference|algo-runtime-interaction> are explained in Notation
  <reference|nota-call-into-runtime> and Definition
  <reference|defn-set-state-at> respectively. <math|R<rsub|B>> is the Runtime
  code loaded from <math|\<cal-S\><rsub|B>>, as described in Notation
  <reference|nota-runtime-code-at-state>, and
  <math|\<cal-R\>\<cal-E\><rsub|B>> is the Polkadot Host API, as described in
  Notation <reference|nota-host-api-at-state>.

  <subsection|Loading the Runtime Code><label|sect-loading-runtime-code>

  The Polkadot Host expects to receive the code for the Runtime of the chain
  as a compiled WebAssembly (Wasm) Blob. The current runtime is stored in the
  state database under the key represented as a byte array:

  <\equation*>
    b\<assign\><text|3A,63,6F,64,65>
  </equation*>

  which is the ASCII byte representation of the string \P<verbatim|:code>\Q
  (see Section <reference|sect-genesis-block>). As a result of storing the
  Runtime as part of the state, the Runtime code itself becomes state
  sensitive and calls to Runtime can change the Runtime code itself.
  Therefore the Polkadot Host needs to always make sure to provide the
  Runtime corresponding to the state in which the entry has been called.
  Accordingly, we introduce the following notation to refer to the Runtime
  code at a specific state:

  <\notation>
    <label|nota-runtime-code-at-state>By <math|R<rsub|B>>, we refer to the
    Runtime code stored in the state storage at the end of the execution of
    block <math|B>.
  </notation>

  The initial runtime code of the chain is provided as part of the genesis
  state (see Section <reference|sect-genesis-block>) and subsequent calls to
  the Runtime have the ability to, in turn, call the storage API (see Section
  <reference|sect-host-api>) to insert new Wasm blobs into runtime storage to
  upgrade the Runtime.

  <subsection|Code Executor><label|sect-code-executor>

  The Polkadot Host executes the calls of Runtime entries inside a Wasm
  Virtual Machine (VM), which in turn provides the Runtime with access to the
  Polkadot Host API. This part of the Polkadot Host is referred to as the
  <em|<strong|Executor>.>

  Definition <reference|nota-call-into-runtime> introduces the notation for
  calling the runtime entry which is used whenever an algorithm of the
  Polkadot Host needs to access the runtime.

  <\notation>
    <label|nota-call-into-runtime> By

    <\equation*>
      <text|<name|Call-Runtime-Entry>><around*|(|R,\<cal-R\>\<cal-E\>,<text|<verbatim|Runtime-Entry>>,A,A<rsub|len>|)>
    </equation*>

    we refer to the task using the executor to invoke the
    <verbatim|Runtime-Entry> while passing an
    <math|A<rsub|1>,\<ldots\>,A<rsub|n>> argument to it and using the
    encoding described in Section <reference|sect-runtime-send-args-to-runtime-enteries>.
  </notation>

  It is acceptable behavior that the Runtime panics during execution of a
  function in order to indicate an error. The Polkadot Host must be able to
  catch that panic and recover from it.

  \;

  In this section, we specify the general setup for an Executor that calls
  into the Runtime. In Section <reference|sect-runtime-entries> we specify
  the parameters and return values for each Runtime entry separately.

  <subsubsection|Memory Management><label|sect-memory-management>

  The Polkadot Host is responsible for managing the WASM heap memory starting
  at the exported symbol <verbatim|__heap_base> as a part of implementing the
  allocator Host API (see Section <reference|sect-ext-allocator>) and the
  same allocator should be used for any other heap allocation to be used by
  the Polkadot Runtime.

  The size of the provided WASM memory should be based on the value of the
  <verbatim|:heappages> storage key (an unsigned 64-bit integer), where each
  page has the size of 64KB. This memory shoule be made available to the
  Polkadot runtime for import under the symbol name <verbatim|memory>.

  <subsubsection|Sending Data to a Runtime Entry
  ><label|sect-runtime-send-args-to-runtime-enteries>

  In general, all data exchanged between the Polkadot Host and the Runtime is
  encoded using SCALE codec described in Section
  <reference|sect-scale-codec>. Therefore all runtime entries have the
  following identical Wasm function signatures:

  \;

  <cpp|<verbatim|>(func $runtime_entry (param $data i32) (param $len i32)
  (result i64))>

  \;

  In each invocation of a Runtime entry, the argument(s) which are supposed
  to be sent to the entry, need to be SCALE encoded into a byte array
  <math|B> (see Definition <reference|sect-scale-codec>) and copied into a
  section of Wasm shared memory managed by the shared allocator described in
  Section <reference|sect-memory-management>.\ 

  When the Wasm method <verbatim|runtime_entry>, corresponding to the entry,
  is invoked, two <verbatim|i32> integers are passed as arguments. The first
  argument <verbatim|data> is set to the memory adress of the byte array
  <math|B> in Wasm memory. The second argument <verbatim|len> sets the length
  of the encoded data stored in <math|B>.

  <subsubsection|Receiving Data from a Runtime
  Entry><label|sect-runtime-return-value>

  The value which is returned from the invocation is an <verbatim|i64>
  integer, representing two consecutive <verbatim|i32> integers in which the
  least significant one indicates the pointer to the offset of the result
  returned by the entry encoded in SCALE codec in the memory buffer. The most
  significant one provides the size of the blob.

  <subsubsection|Handling Runtimes update to the
  State><label|sect-handling-runtime-state-update>

  In order for the Runtime to carry on various tasks, it manipulates the
  current state by means of executing calls to various Polkadot Host APIs
  (see Appendix <reference|sect-host-api>). It is the duty of Host APIs to
  determine the context in which these changes should persist. For example,
  if Polkdot Host needs to validate a transaction using
  <verbatim|TaggedTransactionQueue_validate_transaction> entry (see Section
  <reference|sect-rte-validate-transaction>), it needs to sandbox the changes
  to the state just for that Runtime call and prevent the global state of the
  system from being influence by the call to such a Runtime entry. This
  includes reverting the state of function calls which return errors or
  panic.

  \ 

  As a rule of thumb, any state changes resulting from Runtime enteries are
  not persistant with the exception of state changes resulting from calling
  <verbatim|Core_execute_block> (see Section
  <reference|sect-rte-core-execute-block>) while Polkadot Host is importing a
  block (see Section <reference|sect-block-validation>).

  \;

  For more information on managing multiple variant of state see Section
  <reference|sect-managing-multiple-states>.

  <section|Extrinsics><label|sect-extrinsics>

  The block body consists of an array of extrinsics. In a broad sense,
  extrinsics are data from outside of the state which can trigger state
  transitions. This section describes extrinsics and their inclusion into
  blocks.

  <subsection|Preliminaries>

  The extrinsics are divided into two main categories defined as follows:

  <\definition>
    <strong|Transaction extrinsics> are extrinsics which are signed using
    either of the key types described in section
    <reference|sect-cryptographic-keys> and broadcasted between the nodes.
    <strong|Inherent extrinsics> are unsigned extrinsics which are generated
    by Polkadot Host and only included in the blocks produced by the node
    itself. They are broadcasted as part of the produced blocks rather than
    being gossiped as individual extrinsics.
  </definition>

  The Polkadot Host does not specify or limit the internals of each
  extrinsics and those are defined and dealt with by the Runtime (defined in
  Definition <reference|defn-runtime>). From the Polkadot Host point of view,
  each extrinsics is simply a SCALE-encoded blob as defined in Section
  <reference|sect-scale-codec>.

  <subsection|Transactions>

  Transaction are submitted and exchanged through <em|Transactions> network
  messages (see Section <reference|sect-msg-transactions>). Upon receiving a
  Transactions message, the Polkadot Host decodes the SCALE-encoded blob and
  splits it into individually SCALE-encoded transactions.

  Alternative transaction can be submitted to the host by offchain worker
  through the <verbatim|ext_offchain_submit_transaction> Host API, defined in
  Section <reference|sect-ext-offchain-submit-transaction>.\ 

  Any new transaction should be submitted to the
  <verbatim|validate_transaction> Runtime function, defined in Section
  <reference|sect-rte-validate-transaction>. This will allow the Polkadot
  Host to check the validity of the received transaction against the current
  state as well as determine how the transaction depends on other extrinsics
  and if it should be gossiped to other peers. If
  <verbatim|validate_transaction> considers the submitted transaction as
  valid, the Polkadot Host should store it for inclusion in future blocks.
  The whole process of handeling new transactions is described in more detail
  by Algorithm <reference|algo-validate-transactions>.

  Additionally valid transactions that are supposed to be gossiped are
  propagated to connected peers of the Polkadot Host. While doing so the
  Polkadot Host should keep track of peers already aware of each transaction.
  This includes peers which have already gossiped the transaction to the node
  as well as those to whom the transaction has already been sent. This
  behavior is mandated to avoid resending duplicates and unnecessarily
  overloading the network. To that aim, the Polkadot Host should keep a
  <em|transaction pool<index|transaction pool>> and a <em|transaction
  queue><index|transaction queue> defined as follows:

  <\definition>
    <label|defn-transaction-queue>The <strong|Transaction Queue> of a block
    producer node, formally referred to as <math|TQ> is a data structure
    which stores the transactions ready to be included in a block sorted
    according to their priorities (Definition
    <reference|sect-msg-transactions>). The <strong|Transaction Pool>,
    formally referred to as <math|TP>, is a hash table in which the Polkadot
    Host keeps the list of all valid transactions not in the transaction
    queue.
  </definition>

  Algorithm <reference|algo-validate-transactions> updates the transaction
  pool and the transaction queue according to the received message:

  <\algorithm|<label|algo-validate-transactions><name|Validate-Transactions-and-Store>(<math|M<rsub|T>:>Transaction
  Message)>
    <\algorithmic>
      <\state>
        <math|L\<leftarrow\>Dec<rsub|SC><around*|(|M<rsub|T>|)>><todo|not all
        tx are received via <math|M<rsub|T>>>
      </state>

      <\state>
        <FOR-IN|<math|T>|<math|L >><strong|such that> <math|E\<nin\>TQ>
        <strong|and> <math|E\<nin\>TP>:
      </state>

      <\state>
        <math|B<rsub|d>\<leftarrow\>><name|Head(Longest-Chain((<math|BT>))>
      </state>

      <\state>
        <math|N\<leftarrow\>H<rsub|n><around*|(|B<rsub|d>|)>>
      </state>

      <\state>
        <math|R\<leftarrow\>><name|Call-Runtime-Entry>(

        <space|1em><math|<text|<verbatim|TaggedTransactionQueue_validate_transaction>>,N,T>

        )
      </state>

      <\state>
        <\IF>
          <math|R> indicates <math|E> is <math|Valid:>
        </IF>
      </state>

      <\state>
        <\IF>
          <math|Requires>(R)\<subset\>
        </IF>

        <space|1em><math|<big|cup><rsub|\<forall\>T\<in\><around*|(|TQ|)>>><name|Provided-Tags>(T)
        \<cup\> <math|<big|cup><rsub|i\<less\>d,\<forall\>T,T\<in\>B<rsub|i>>><name|Provided-Tags(T)>:
      </state>

      <\state>
        <name|Insert-At(><math|TQ,T,Requires(R),Priority(R)>)<END>
      </state>

      <\state>
        <\ELSE>
          \;
        </ELSE>
      </state>

      <\state>
        <name|Add-To(TP,<math|T>)><END>
      </state>

      <\state>
        <name|Maintain-Transaction-Pool>
      </state>

      <\state>
        <\IF>
          <name|ShouldPropagate(R)>:
        </IF>
      </state>

      <\state>
        <name|Propagate(><math|T>)<END><END><END>
      </state>
    </algorithmic>
  </algorithm>

  In which

  <\itemize-minus>
    <item><math|<text|<name|Dec<rsub|Sc>>>> decodes the SCALE encoded
    message.

    <item><name|Longest-Chain> is defined in Definition
    <reference|defn-longest-chain>.

    <item><verbatim|TaggedTransactionQueue_validate_transaction> is a Runtime
    entry specified in Section <reference|sect-rte-validate-transaction> and
    Requires(R), Priority(R) and Propagate(R) refer to the corresponding
    fields in the tuple returned by the entry when it deems that <math|T> is
    valid.

    <item><name|Provided-Tags>(T) is the list of tags that transaction
    <math|T> provides. The Polkadot Host needs to keep track of tags that
    transaction <math|T> provides as well as requires after validating it.

    <item><name|Insert-At(><math|TQ,T,Requires(R),Priority(R)>) places
    <math|T> into <math|TQ> approperietly such that the transactions
    providing the tags which <math|T> requires or have higher priority than
    <math|T> are ahead of <math|T>.

    <item><name|Maintain-Transaction-Pool> is described in Algorithm
    <reference|algo-maintain-transaction-pool>.

    <item><name|ShouldPropagate> indictes whether the transaction should be
    propagated based on the <verbatim|Propagate> field in the
    <verbatim|ValidTransaction> type as defined in Definition
    <reference|defn-valid-transaction>, which is returned by
    <verbatim|TaggedTransactionQueue_validate_transaction>.

    <item><name|Propagate(><math|T>) sends <math|T> to all connected peers of
    the Polkadot Host who are not already aware of <math|T>.
  </itemize-minus>

  <\algorithm|<label|algo-maintain-transaction-pool><name|Maintain-Transaction-Pool>>
    <\algorithmic>
      <todo|This is scaning the pool for ready transactions and moving them
      to the TQ and dropping transactions which are not valid>
    </algorithmic>
  </algorithm>

  <subsection|Inherents><label|sect-inherents>

  Inherents are unsigned extrinsic inserted into a block by the block author
  and as a result are not stored in the transaction pool or gossiped across
  the network. Instead they are generated by the Polkadot Host by passing the
  required inherent data, as listed in Table <reference|tabl-inherent-data>,
  to the Runtime method <samp|<verbatim|BlockBuilder_inherent_extrinsics>>
  (Section <reference|defn-rt-builder-inherent-extrinsics>). The then
  returned extrinsics should be included in the current block as explained in
  Algorithm <reference|algo-build-block>. <todo|define uncles>

  <\big-table|<tabular|<tformat|<cwith|1|-1|1|-1|cell-tborder|0ln>|<cwith|1|-1|1|-1|cell-bborder|0ln>|<cwith|1|-1|1|-1|cell-lborder|0ln>|<cwith|1|-1|1|-1|cell-rborder|0ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<table|<row|<cell|Identifier>|<cell|Value
  type >|<cell|Description>>|<row|<cell|timstap0>|<cell|u64>|<cell|Unix epoch
  time in number of milliseconds>>|<row|<cell|uncles00>|<cell|array of block
  headers<math|<rsup|>>>|<cell|Provides a list of potential uncle block
  headers<math|<rsup|<reference|defn-block-header>>> for a given block>>>>>>
    <label|tabl-inherent-data>List of inherent data
  </big-table>

  <\definition>
    <label|defn-inherent-data><name|Inherent-Data >is a hashtable (Definition
    <reference|defn-scale-list>), an array of key-value pairs consisting of
    the inherent 8-byte identifier and its value, representing the totality
    of inherent extrinsics included in each block. The entries of this hash
    table which are listed in Table <reference|tabl-inherent-data> are
    collected or generated by the Polkadot Host and then handed to the
    Runtime for inclusion as dercribed in Algorithm
    <reference|algo-build-block>.
  </definition>

  <section|State Replication><label|sect-state-replication>

  Polkadot nodes replicate each other's state by syncing the history of the
  extrinsics. This, however, is only practical if a large set of transactions
  are batched and synced at the time. The structure in which the transactions
  are journaled and propagated is known as a block (of extrinsics) which is
  specified in Section <reference|sect-block-format>. Like any other
  replicated state machines, state inconsistency can occure between Polkadot
  replicas. Section <reference|sect-managing-multiple-states> is giving an
  overview of how a Polkadot Host node manages multiple variants of the
  state.

  <subsection|Block Format><label|sect-block-format>

  A Polkadot block consists a <with|font-shape|italic|block header> (Section
  <reference|sect-block-header>) and a <with|font-shape|italic|block body>
  (Section <reference|sect-block-body>). The <with|font-shape|italic|block
  body> in turn is made up out of a <with|font-shape|right|list of
  <with|font-shape|italic|extrinsics>>, which represent the generalization of
  the concept of <em|transactions>. <with|font-shape|italic|Extrinsics> can
  contain any set of external data the underlying chain wishes to validate
  and track.

  <subsubsection|Block Header><label|sect-block-header>

  The block header is designed to be minimalistic in order to allow
  efficienct handeling by light clients. It is defined formally as follows:

  <\definition>
    <label|defn-block-header>The <strong|header of block B>,
    <strong|<math|Head<around|(|B|)>>> is a 5-tuple containing the following
    elements:

    <\itemize>
      <item><with|font-series|bold|<samp|parent_hash:>> formally indicated as
      <math|<strong|<text|H<rsub|p>>>>, is the 32-byte Blake2b hash (Section
      <reference|sect-blake2>) of the SCALE encoded parent block header as
      defined in Definition <reference|defn-block-header-hash>.

      <item><strong|<samp|number:>> formally indicated as
      <strong|<math|H<rsub|i>>>, is an integer, which represents the index of
      the current block in the chain. It is equal to the number of the
      ancestor blocks. The genesis state has number 0.

      <item><strong|<samp|state_root:>> formally indicated as
      <strong|<math|H<rsub|r>>>, is the root of the Merkle trie, whose leaves
      implement the storage for the system.

      <item><strong|<samp|extrinsics_root:>> is the field which is reserved
      for the Runtime to validate the integrity of the extrinsics composing
      the block body. For example, it can hold the root hash of the Merkle
      trie which stores an ordered list of the extrinsics being validated in
      this block. The <samp|extrinsics_root> is set by the runtime and its
      value is opaque to the Polkadot Host. This element is formally referred
      to as <strong|<math|H<rsub|e>>>.

      <item><strong|<samp|digest:>> this field is used to store any
      chain-specific auxiliary data, which could help the light clients
      interact with the block without the need of accessing the full storage
      as well as consensus-related data including the block signature. This
      field is indicated as <strong|<math|H<rsub|d>>> and its detailed format
      is defined in Definition <reference|defn-digest>
    </itemize>
  </definition>

  <\definition>
    <label|defn-digest>The header <strong|digest> of block <math|B> formally
    referred to by <strong|<math|H<rsub|d><around*|(|B|)>>> is an array of
    <strong|digest items> <math|H<rsup|i><rsub|d>>'s , known as digest items
    of varying data type (see Definition <reference|defn-varrying-data-type>)
    such that

    <\equation*>
      H<rsub|d><around*|(|B|)>:=H<rsup|1><rsub|d>,\<ldots\>,H<rsup|n><rsub|d>
    </equation*>

    where each digest item can hold one of the type described in Table
    <reference|tabl-digest-items>:

    <\with|par-mode|center>
      <\small-table>
        \;

        <\center>
          <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|1|-1|cell-valign|c>|<cwith|1|-1|1|-1|cell-tborder|0ln>|<cwith|1|-1|1|-1|cell-bborder|0ln>|<cwith|1|-1|1|-1|cell-lborder|1ln>|<cwith|1|-1|1|-1|cell-rborder|1ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-lborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|1ln>|<cwith|1|1|1|3|cell-halign|l>|<cwith|1|5|2|2|cell-halign|l>|<cwith|1|5|2|2|cell-valign|c>|<cwith|1|5|2|2|cell-tborder|0ln>|<cwith|1|5|2|2|cell-bborder|0ln>|<cwith|1|5|2|2|cell-lborder|1ln>|<cwith|1|5|2|2|cell-rborder|1ln>|<cwith|5|5|2|2|cell-bborder|1ln>|<cwith|1|5|2|2|cell-rborder|1ln>|<cwith|1|1|2|2|cell-tborder|1ln>|<cwith|1|1|2|2|cell-bborder|1ln>|<cwith|2|2|2|2|cell-tborder|1ln>|<cwith|1|1|2|2|cell-rborder|1ln>|<table|<row|<cell|Type
          Id>|<cell|Type name>|<cell|sub-components
          >>|<row|<cell|<math|2>>|<cell|Changes trie
          root>|<cell|<math|\<bbb-B\><rsub|32>>>>|<row|<cell|6>|<cell|Pre-Runtime>|<cell|<math|E<rsub|id>,\<bbb-B\>>>>|<row|<cell|4>|<cell|Consensus
          Message>|<cell|<math|E<rsub|id>,\<bbb-B\>>>>|<row|<cell|5>|<cell|Seal
          >|<cell|<math|E<rsub|id>,\<bbb-B\>>>>>>>
        </center>

        \;
      </small-table|<label|tabl-digest-items>The detail of the varying type
      that a digest item can hold.>
    </with>

    \;

    Where <math|E<rsub|id>> is the unique consensus engine identifier defined
    in Section <reference|defn-consensus-message-digest> and

    <\itemize-dot>
      <item><strong|Changes trie root> contains the root of the Changes Trie
      at block <math|B>, as described in Section
      <reference|sect-changes-trie><math|>. Note that this is future-reserved
      and currently <strong|not> used in Polkadot.

      <item><strong|Pre-runtime> digest items represent messages from a
      consensus engine to the Runtime (e.g. see Definition
      <reference|defn-babe-header>).

      <item><strong|Consensus> <with|font-series|bold|Message> digest items
      represent messages from the Runtime to the consensus engine (see
      Section <reference|sect-consensus-message-digest>).

      <item><strong|Seal> is the data produced by the consensus engine and
      proving the authorship of the block producer. In particular, the Seal
      digest item must be the last item in the digest array and must be
      stripped off by the Polkadot Host before the block is submitted to any
      Runtime function including for validation. The Seal must be added back
      to the digest afterward. The detail of the Seal digest item is laid out
      in Definition <reference|defn-babe-seal>.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-block-header-hash>The <strong|block header hash of block
    <math|B>>, <strong|<math|H<rsub|h><around|(|B|)>>>, is the hash of the
    header of block <math|B> encoded by simple codec:

    <\equation*>
      H<rsub|h><around|(|B|)>\<assign\>Blake2b<around|(|Enc<rsub|SC><around|(|Head<around|(|B|)>|)>|)>
    </equation*>
  </definition>

  <subsubsection|Justified Block Header><label|sect-justified-block-header>

  The Justified Block Header is provided by the consensus engine and
  presented to the Polkadot Host, for the block to be appended to the
  blockchain. It contains the following parts:

  <\itemize>
    <item><strong|<samp|<strong|block_header>>> the complete block header as
    defined in Section <reference|block> and denoted by
    <math|Head<around|(|B|)>>.

    <item><strong|<samp|justification>>: as defined by the consensus
    specification indicated by <math|Just<around|(|B|)>> as defined in
    Definition <reference|defn-grandpa-justification>.

    <item><strong|<samp|authority Ids>>: This is the list of the Ids of
    authorities, which have voted for the block to be stored and<verbatim|>
    is formally referred to as <math|A<around|(|B|)>>. An authority Id is
    256-bit.
  </itemize>

  <subsubsection|Block Body><label|sect-block-body>

  The Block Body consists of an sequence of extrinsics, each encoded as a
  byte array. The content of an extrinsic is completely opaque to the
  Polkadot Host. As such, from the point of the Polkadot Host, and is simply
  a SCALE encoded array of byte arrays. Formally:

  <\definition>
    <label|defn-block-body>The <strong|body of Block> <math|B> represented as
    <strong|<math|Body<around*|(|B|)>>> is defined to be

    <\equation*>
      Body<around*|(|B|)>\<assign\>Enc<rsub|SC><around*|(|E<rsub|1>,\<ldots\>,E<rsub|n>|)>
    </equation*>

    Where each <math|E<rsub|i>\<in\>\<bbb-B\>> is a SCALE encoded extrinsic.
  </definition>

  <subsection|Importing and Validating Block><label|sect-block-validation><label|sect-block-submission>

  Block validation is the process by which a node asserts that a block is fit
  to be added to the blockchain. This means that the block is consistent with
  the world state and transitions from the current state of the system to a
  new valid state.

  \;

  New blocks can be received by the Polkadot Host via other peers (see
  Section <reference|sect-msg-block-request>) or from the Host's own
  consensus engine (see Section <reference|sect-block-production>). Both the
  Runtime and the Polkadot Host then need to work together to assure block
  validity. A block is deemed valid if the block author had authorship rights
  for the slot in which the block was produce as well as if the transactions
  in the block constitute a valid transition of states. The former criterion
  is validated by the Polkadot Host according to the block production
  consensus protocol. The latter can be verified by the Polkadot Host
  invoking <verbatim|Core_execute_block> entry into the Runtime as defined in
  section <reference|sect-rte-core-execute-block> as a part of the validation
  process. Any state changes created by this function on successful execution
  are persisted.

  \;

  The Polkadot Host implements the following procedure to assure the validity
  of the block:

  <\algorithm|<label|algo-import-and-validate-block><name|Import-and-Validate-Block(<math|B,Just<around|(|B|)>>)>>
    <\algorithmic>
      <\state>
        <name|Set-Storage-State-At(<math|P<around*|(|B|)>>)>
      </state>

      <\state>
        <\IF>
          <math|Just<around|(|B|)>\<neq\>\<emptyset\>>
        </IF>
      </state>

      <\state>
        <name|Verify-Block-Justification><math|<around|(|B,Just<around|(|B|)>|)>>
      </state>

      <\state>
        <\IF>
          <math|B> <strong|is> Finalized <strong|and> <math|P<around*|(|B|)>>
          <strong|is not> Finalized
        </IF>
      </state>

      <\state>
        <name|Mark-as-Final><math|<around*|(|P<around*|(|B|)>|)>><END><END>
      </state>

      <\state>
        <\IF>
          <math|H<rsub|p><around|(|B|)>\<nin\>PBT>
        </IF>
      </state>

      <\state>
        <\RETURN>
          <END>
        </RETURN>
      </state>

      <\state>
        <name|Verify-Authorship-Right>(<math|Head<around*|(|B|)>>)
      </state>

      <\state>
        <em|B> \<leftarrow\> <name|Remove-Seal>(<em|B>)
      </state>

      <\state>
        <math|R\<leftarrow\>> <name|Call-Runtime-Entry><math|<around*|(|<text|<verbatim|Core_execute_block>>,B|)>>
      </state>

      <\state>
        <em|B> \<leftarrow\> <name|Add-Seal>(<em|B>)
      </state>

      <\state>
        if <em|R> = <name|True>
      </state>

      <\state>
        <name|<space|2em>Persist-State>
      </state>
    </algorithmic>
  </algorithm>

  In which

  <\itemize-minus>
    <item><name|Remove-Seal> removes the Seal digest from the block as
    described in Definition <reference|defn-digest> before submitting it to
    the Runtime.

    <item><name|Add-Seal> adds the Seal digest back to the block as described
    in Definition <reference|defn-digest> for later propagation.

    <item><name|Persist-State> implies the persistence of any state changes
    created by <verbatim|Core_execute_block> on successful execution.

    <item><math|>PBT is the pruned block tree defined in Definition
    <reference|defn-block-tree>.

    <item><name|Verify-Authorship-Right> is part of the block production
    consensus protocol and is described in Algorithm
    <reference|algo-verify-authorship-right>.

    <item><with|font-shape|italic|Finalized block> and
    <with|font-shape|italic|finality> is defined in Section
    <reference|sect-finality>.
  </itemize-minus>

  <subsection|Managaing Multiple Variants of
  State><label|sect-managing-multiple-states>

  Unless a node is committed to only update its state according to the
  finalized block (See Definition <reference|defn-finalized-block>), it is
  inevitable for the node to store multiple variants of the state (one for
  each block). This is, for example, necessary for nodes participating in the
  block production and finalization.

  While the state trie structure described in Section
  <reference|sect-state-storage-trie-structure> facilitates and optimizes
  storing and switching between multiple variants of the state storage, the
  Polkadot Host does not specify how a node is required to accomplish this
  task. Instead, the Polkadot Host is required to implement
  <name|Set<verbatim|>-State-At> operation which behaves as defined in
  Definition <reference|defn-set-state-at>:

  <\definition>
    <label|defn-set-state-at>The function

    <\equation*>
      <text|<name|<strong|Set-State-At(<math|\<b-B\>>)>>>
    </equation*>

    \ in which <math|B> is a block in the block tree (See Definition
    <reference|defn-block-tree>), sets the content of state storage equal to
    the resulting state of executing all extrinsics contained in the branch
    of the block tree from genesis till block B including those recorded in
    Block B.
  </definition>

  For the definition of the state storage see Section
  <reference|sect-state-storage>.

  <subsection|Changes Trie><label|sect-changes-trie>

  <todo|NOTE: Changes Tries are still work-in-progress and are currently
  <strong|not> used in Polkadot. Additionally, the implementation of Changes
  Tries might change considerably.>

  \;

  Polkadot focuses on light client friendliness and therefore implements
  functionalities that allows identifying changes in the state of the
  blockchain without the requirement to search through the entire chain. The
  <strong|Changes Trie> is a radix-16 tree data structure as defined in
  Definition <reference|defn-radix-tree> and maintained by the Polkadot Host.
  It stores different types of storage changes made by each individual block
  separately.

  \;

  The primary method for generating the Changes Trie is provided to the
  Runtime with the <verbatim|ext_storage_changes_root> Host API as described
  in Section <reference|sect-ext-storage-changes-root>. The Runtime calls
  that function shortly before finalizing the block, the Polkadot Host must
  then generate the Changes Trie based on the storage changes which occured
  during block production or execution. In order to provide this API
  function, it is imperative that the Polkadot Host implements a mechanism to
  keep track of the changes created by individual blocks, as mentioned in
  Sections <reference|sect-state-storage> and
  <reference|sect-managing-multiple-states>.

  The Changes Trie stores three different types of changes.\ 

  <\definition>
    The <strong|inserted key-value pair stored in the nodes of Changes Trie>
    is formally defined as:
  </definition>

  <\equation*>
    <around*|(|K<rsub|C>,V<rsub|C>|)>
  </equation*>

  Where <math|K<rsub|C>> is a SCALE-encoded Tuple

  <\equation*>
    Enc<rsub|sc><around*|(|<around*|(|Type<rsub|V<rsub|C>><rsub|><rsub|>,H<rsub|i><around*|(|B<rsub|i>|)>,K|)>|)>
  </equation*>

  and

  <\equation*>
    V<rsub|C>=Enc<rsub|SC><around*|(|C<rsub|value>|)>
  </equation*>

  is a SCALE encoded byte array.

  Furthermore <math|K> represents the changed storage key,
  <math|H<rsub|i><around*|(|B<rsub|i>|)>> refers to the block number at which
  this key is inserted into the Changes Trie (See Definition
  <reference|defn-block-header>) and <math|Type<rsub|V<rsub|C>>> is an index
  defining the type \ <math|C<rsub|Value>> according to Table
  <reference|table-changes-trie-key-types>.<htab|5mm>

  <\big-table>
    <tabular|<tformat|<cwith|2|2|1|-1|cell-bborder|0ln>|<cwith|4|4|1|-1|cell-tborder|1ln>|<cwith|4|4|1|-1|cell-bborder|0ln>|<cwith|5|5|1|-1|cell-tborder|1ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|5|5|1|1|cell-lborder|0ln>|<cwith|5|5|3|3|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<table|<row|<cell|<strong|Type>>|<cell|<strong|Description>>|<cell|<strong|<math|C<rsub|Value>>>>>|<row|<cell|1>|<cell|list
    of extrinsics indices (section <reference|sect-changes-trie-extrinsics-pairs>)>|<cell|<math|<around*|{|e<rsub|i>,\<ldots\>,e<rsub|k>|}>>>>|<row|<cell|>|<cell|where
    <math|e<rsub|i>> refers to the index of the extrinsic within the
    block>|<cell|>>|<row|<cell|2>|<cell|list of block numbers (section
    <reference|sect-changes-trie-block-pairs>)>|<cell|<math|<around*|{|H<rsub|i><around*|(|B<rsub|k>|)>,\<ldots\>,H<rsub|i><around*|(|B<rsub|m>|)>|}>>>>|<row|<cell|3>|<cell|Child
    Changes Trie (section <reference|sect-changes-trie-child-trie-pair>)>|<cell|<math|H<rsub|r><around*|(|<text|<name|Child-Changes-Trie>>|)>>>>>>>

    \;
  <|big-table>
    <label|table-changes-trie-key-types>Possible types of keys of mappings in
    the Changes Trie
  </big-table>

  The Changes Trie itself is not part of the block, but a separately
  maintained database by the Polkadot Host. The Merkle proof of the Changes
  Trie must be included in the block digest as described in Definition
  <reference|defn-digest> and gets calculated as described in section
  <reference|sect-merkl-proof>. The root calculation only considers pairs
  which were generated on the individual block and does not consider pairs
  which were generated at previous blocks.

  \;

  <todo|This seperately maintained database by the Polkadot Host is intended
  to be used by \Pproof servers\Q, where its implementation and behavior has
  not been fully defined yet. This is considered future-reserved>

  \;

  As clarified in the individual sections of each type, not all of those
  types get generated on every block. But if conditions apply, all those
  different types of pairs get inserted into the same Changes Trie, therefore
  only one Changes Trie Root gets generated for each block.

  <subsubsection|Key to extrinsics pairs><label|sect-changes-trie-extrinsics-pairs>

  This key-value pair stores changes which occure in an individual block. Its
  value is a SCALE encoded array containing the indices of the extrinsics
  that caused any changes to the specified key. The key-value pair is defined
  as (clarified in section <reference|sect-changes-trie>):

  <\equation*>
    <around*|(|1,H<rsub|i><around*|(|B<rsub|i>|)>,K|)>\<rightarrow\><around*|{|e<rsub|i>,\<ldots\>,e<rsub|k>|}>
  </equation*>

  The indices are unsigned 32-bit integers and their values are based on the
  order in which each extrinsics appears in the block (indexing starts at 0).
  The Polkadot Host generates those pairs for every changed key on each and
  every block. Child storages have their own Changes Trie, as described in
  section <reference|sect-changes-trie-child-trie-pair>.

  \;

  <todo|clarify special key value of 0xffffffff>

  <subsubsection|Key to block pairs><label|sect-changes-trie-block-pairs>

  This key-value pair stores changes which occured in a certain range of
  blocks. Its value is a SCALE encoded array containing block numbers in
  which extrinsics caused any changes to the specified key. The key-value
  pair is defined as (clarified in section <reference|sect-changes-trie>):

  <\equation*>
    <around*|(|2,H<rsub|i><around*|(|B<rsub|i>|)>,K|)>\<rightarrow\><around*|{|H<rsub|i><around*|(|B<rsub|k>|)>,\<ldots\>,H<rsub|i><around*|(|B<rsub|m>|)>|}>
  </equation*>

  The block numbers are represented as unsigned 32-bit integers. There are
  multiple \Plevels\Q of those pairs, and the Polkadot Host does <strong|not>
  generate those pairs on every block. The genesis state contains the key
  <verbatim|:changes_trie> where its unsigned 64-bit value is a tuple of two
  32-bit integers:

  <\itemize-dot>
    <item><verbatim|interval> - The interval (in blocks) at which those pairs
    should be created. If this value is less or equal to 1 it means that
    those pairs are not created at all.

    <item><verbatim|levels> - The maximum number of \Plevels\Q in the
    hierarchy. If this value is 0 it means that those pairs are not created
    at all.
  </itemize-dot>

  For each level from 1 to <verbatim|levels>, the Polkadot Host creates those
  pairs on every <verbatim|<math|<text|interval<rsup|level><verbatim|>>>>-nth
  block, formally applied as:

  <\algorithm|<name|Key-To-Block-Pairs>(<math|B<rsub|i>>, <math|I>: interval,
  <math|L:>levels>
    <strong|for each> <math|l\<in\><around*|{|1,\<ldots\>,L|}>>

    3.<space|1em>if <math|H<rsub|i><around*|(|B<rsub|i>|)>=I<rsup|l>><verbatim|>

    4.<space|2em><name|Insert-Blocks>(<math|H<rsub|i><around*|(|B<rsub|i>|)>>,
    <math|I<rsup|l>>)
  </algorithm>

  <\itemize-dot>
    <item><math|B<rsub|i>> implies the block at which those pairs gets
    inserted into the Changes Trie.

    <item><name|Insert-Blocks> - Inserts every block number within the range
    <math|H<rsub|i><around*|(|B<rsub|i>|)>-I<rsup|l>+1> to
    <math|H<rsub|i><around*|(|B<rsub|i>|)>> in which any extrinsic changed
    the specified key.
  </itemize-dot>

  \;

  For example, let's say <verbatim|interval> is set at <verbatim|4> and
  <verbatim|levels> is set at <verbatim|3>. This means there are now three
  levels which get generated at three different occurences:

  <\enumerate-numeric>
    <item><strong|Level 1> - Those pairs are generated at every
    <math|<text|<strong|4<rsup|1>>>>-nth block, where the pair value contains
    the block numbers of every block that changed the specified storage key.
    This level only considers block numbers of the last four
    (<math|=4<rsup|1>>) blocks.

    <\itemize-dot>
      <item>Example: this level occurs at block 4, 8, 12, 16, 32, etc.
    </itemize-dot>

    <item><strong|Level 2> - Those pairs are generated at every
    <math|<text|<strong|4<rsup|2>>>>-nth block, where the pair value contains
    the block numbers of every block that changed the specified storage key.
    This level only considers block numbers of the last 16
    (<math|=4<rsup|2>>) blocks.

    <\itemize-dot>
      <item>Example: this level occurs at block 16, 32, 64, 128, 256, etc.
    </itemize-dot>

    <item><strong|Level 3> - Those pairs are generated at every
    <text|<math|<text|<strong|4<rsup|3>>>>>-nth block, where the pair value
    contains the block numbers of every block that changed the specified
    storage key. this level only considers block number of the last 64
    (<math|=4<rsup|3>>) blocks.

    <\itemize-dot>
      <item>Example: this level occurs at block 64, 128, 196, 256, 320, etc.
    </itemize-dot>
  </enumerate-numeric>

  <subsubsection|Key to Child Changes Trie
  pairs><label|sect-changes-trie-child-trie-pair>

  The Polkadot Host generates a separate Changes Trie for each child storage,
  using the same behavior and implementation as describe in section
  <reference|sect-changes-trie-extrinsics-pairs>. Additionally, the changed
  child storage key gets inserted into the primary, non-Child Changes Trie
  where its value is a SCALE encoded byte array containing the Merkle root of
  the Child Changes Trie. The key-value pair is defined as:

  <\equation*>
    <around*|(|3,H<rsub|i><around*|(|B<rsub|i>|)>,K|)>\<rightarrow\>H<rsub|r><around*|(|<text|<name|Child-Changes-Trie>>|)>
  </equation*>

  The Polkadot Host creates those pairs for every changes child key for each
  and every block.

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;

</body>
