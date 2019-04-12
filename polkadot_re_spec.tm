<TeXmacs|1.99.8>

<style|<tuple|article|std-latex|/home/klaymen/doc/code/algorithmacs/algorithmacs-style.ts>>

<\body>
  <\hide-preamble>
    <assign|cdummy|<macro|\<cdot\>>>

    <assign|nobracket|<macro|>>

    <assign|nosymbol|<macro|>>

    <assign|tmem|<macro|1|<with|font-shape|italic|<arg|1>>>>

    <assign|tmname|<macro|1|<with|font-shape|small-caps|<arg|1>>>>

    <assign|tmop|<macro|1|<math|<with|math-font-family|rm|<arg|1>>>>>

    <assign|tmrsub|<macro|1|<rsub|<math|<with|math-font-family|rm|<arg|1>>>>>>

    <assign|tmsamp|<macro|1|<with|font-family|ss|<arg|1>>>>

    <assign|tmstrong|<macro|1|<with|font-series|bold|<arg|1>>>>

    <assign|tmtextbf|<macro|1|<with|font-series|bold|<arg|1>>>>

    <assign|tmtextit|<macro|1|<with|font-shape|italic|<arg|1>>>>

    <assign|tmverbatim|<macro|1|<with|font-family|tt|<arg|1>>>>

    <new-theorem|definition|Definition>

    <new-theorem|notation|Notation>
  </hide-preamble>

  <doc-data|<doc-title|Polkadot Runtime Environment<next-line><with|font-size|1.41|Protocol
  Specification>>|<doc-date|<date|>>>

  <section|Conventions and Definitions>

  <\definition>
    <strong|Runtime> is the state transition function of the decentralized
    ledger protocol.<verbatim|>
  </definition>

  <\definition>
    <label|def-path-graph>A <strong|path graph> or a <strong|path> of
    <math|n> nodes formally referred to as <strong|<math|P<rsub|n>>>, is a
    tree with two nodes of vertex degree 1 and the other n-2 nodes of vertex
    degree 2. Therefore, <math|P<rsub|n>> can be represented by sequences of
    <math|<around|(|v<rsub|1>,\<ldots\>,v<rsub|n>|)>> where
    <math|e<rsub|i>=<around|(|v<rsub|i>,v<rsub|i+1>|)>> for
    <math|1\<leqslant\>i\<leqslant\>n-1> is the edge which connect
    <math|v<rsub|i>> and <math|v<rsub|i+1>>.
  </definition>

  <\definition>
    <label|def-radix-tree><strong|radix r tree> is a variant of \ a trie in
    which:

    <\itemize>
      <item>Every node has at most <math|r> children where <math|r=2<rsup|x>>
      for some <math|x>;

      <item>Each node that is the only child of a parent, which does not
      represent a valid key is merged with its parent.
    </itemize>
  </definition>

  As a result, in a radix tree, any path whose interior vertices all have
  only one child and does not represent a valid key in the data set, is
  compressed into a single edge. This improves space efficiency when the key
  space is sparse.

  <\definition>
    By a <strong|sequences of bytes> or a <strong|byte array>, <math|b>, of
    length <math|n>, we refer to

    <\equation*>
      b\<assign\><around|(|b<rsub|0>,b<rsub|1>,...,b<rsub|n-1>|)>*<text|such
      that >0\<leqslant\>b<rsub|i>\<leqslant\>255
    </equation*>

    We define <math|\<bbb-B\><rsub|n>> to be the <strong|set of all byte
    arrays of length <math|n>>. Furthermore, we define:

    <\equation*>
      \<bbb-B\>\<assign\><big|cup><rsup|\<infty\>><rsub|i=0>\<bbb-B\><rsub|i>
    </equation*>
  </definition>

  <\notation>
    We represent the concatenation of byte arrays
    <math|a\<assign\><around|(|a<rsub|0>,\<ldots\>,a<rsub|n>|)>> and
    <math|b\<assign\><around|(|b<rsub|0>,\<ldots\>,b<rsub|m>|)>> by:

    <\equation*>
      a<around|\|||\|>*b\<assign\><around|(|a<rsub|0>,\<ldots\>,a<rsub|n>,b<rsub|0>,\<ldots\>,b<rsub|m>|)>
    </equation*>
  </notation>

  <\definition>
    <label|defn-bit-rep>For a given byte <math|b> the <strong|bitwise
    representation> of <math|b> is defined as

    <\equation*>
      b\<assign\>b<rsup|7>*\<ldots\>*b<rsup|0>
    </equation*>

    where

    <\equation*>
      b=2<rsup|0>*b<rsup|0>+2<rsup|1>*b<rsup|1>+\<cdots\>+2<rsup|7>*b<rsup|7>
    </equation*>
  </definition>

  <\definition>
    <label|defn-little-endian>By <verbatim|>the <strong|little-endian>
    representation of a non-negative integer, I, represented as

    <\equation*>
      I=<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>
    </equation*>

    in base 256, we refer to a byte array
    <math|B=<around*|(|b<rsub|0>,b<rsub|1>,\<ldots\>,b<rsub|n>|)>> such that

    <\equation*>
      b<rsub|i>\<assign\>B<rsub|i>
    </equation*>

    Accordingly, define the function <math|Enc<rsub|LE>>:

    <\equation*>
      <tabular|<tformat|<table|<row|<cell|Enc<rsub|LE>:>|<cell|\<bbb-Z\><rsup|+>>|<cell|\<rightarrow\>>|<cell|\<bbb-B\>>>|<row|<cell|>|<cell|<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>|<cell|\<mapsto\>>|<cell|<around*|(|B<rsub|0,>B<rsub|1>,\<ldots\><rsub|>,B<rsub|n>|)>>>>>>
    </equation*>

    \;
  </definition>

  <\definition>
    By <name|<strong|<verbatim|UINT32>>> we refer to a non-negative integer
    stored in a byte array of length 4 using little-endian encoding format.
  </definition>

  <\definition>
    A <strong|blockchain> <math|C> is a directed path graph. Each node of the
    graph is called <strong|Block> and indicated by <strong|<math|B>>. The
    unique sink of <math|C> is called <strong|Genesis Block>, and the source
    is called the <strong|Head> of C. For any vertex
    <math|<around*|(|B<rsub|1>,B<rsub|2>|)>> where
    <math|B<rsub|1>\<rightarrow\>B<rsub|2>> we say <math|B<rsub|2>> is the
    <strong|parent> of <math|B<rsub|1>> and we indicate it by\ 

    <\equation*>
      B<rsub|2>\<assign\>P<around*|(|B<rsub|1>|)>
    </equation*>
  </definition>

  <section|Block>

  In Polkadot RE, a block is made of two main parts, namely the
  <with|font-shape|italic|block header> and the <with|font-shape|italic|list
  of extrinsics>. <em|The Extrinsics> represent the generalization of the
  concept of <em|transaction>, containing any set of data that is external to
  the system, and which the underlying chain wishes to validate and keep
  track of.

  <subsection|Block Header><label|block>

  The block header is designed to be minimalistic in order to boost the
  efficiency of the light clients. It is defined formally as follows:

  <\definition>
    <label|def-block-header>The <strong|header of block B>,
    <strong|<math|Head<around|(|B|)>>> is a 5-tuple containing the following
    elements:

    <\itemize>
      <item><with|font-series|bold|<samp|parent_hash:>> is the 32-byte
      Blake2s hash of the header of the parent of the block indicated
      henceforth by <with|font-series|bold|mode|math|H<rsub|p>>.

      <item><strong|<samp|number:>> formally indicated as
      <strong|<math|H<rsub|i>>> is an integer, which represents the index of
      the current block in the chain. It is equal to the number of the
      ancestor blocks. The genesis block has number 0.

      <item><strong|<samp|state_root:>> formally indicated as
      <strong|<math|H<rsub|r>>> is the root of the Merkle trie, whose leaves
      implement the storage for the system.

      <item><strong|<samp|extrinsics_root:>> is the field which is reserved
      for the runtime to validate the integrity of the extrinsics composing
      the block body. For example, it can hold the root hash of the Merkle
      trie which stores an ordered list of the extrinsics being validated in
      this block. This element is formally referred to as
      <strong|<math|H<rsub|e>>>.

      <item><strong|<samp|digest:>> this field is used to store any
      chain-specific auxiliary data, which could help the light clients
      interact with the block without the need of accessing the full storage.
      Polkadot RE does not impose any limitation or specification for this
      field. Essentially, it can be a byte array of any length. This field is
      indicated as <strong|<math|H<rsub|d>>>
    </itemize>
  </definition>

  <\definition>
    <label|def-block-header-hash>The <strong|Block Header Hash of Block
    <math|B>>, <strong|<math|H<rsub|h><around|(|b|)>>>, is the hash of the
    header of block <math|B> encoded by simple codec:

    <\equation*>
      H<rsub|b><around|(|b|)>\<assign\>Blake2*s<around|(|Enc<rsub|SC><around|(|Head<around|(|B|)>|)>|)>
    </equation*>
  </definition>

  <subsection|Justified Block Header>

  The Justified Block Header is provided by the consensus engine and
  presented to the Polkadot RE, for the block to be appended to the
  blockchain. It contains the following parts:

  <\itemize>
    <item><strong|<samp|<strong|block_header>>> the complete block header as
    defined in Section <reference|block> and denoted by
    <math|Head<around|(|B|)>>.

    <item><strong|<samp|justification>>: as defined by the consensus
    specification indicated by <math|Just<around|(|B|)>> <todo|link this to
    its definition from consensus>.

    <item><strong|<samp|authority Ids>>: This is the list of the Ids of
    authorities, which have voted for the block to be stored and is formally
    referred to as <math|A<around|(|B|)>>. An authority Id is 32bit.
  </itemize>

  <subsection|Extrinsics>

  Each block contains as well a list of extrinsics. Polkadot RE does not
  specify or limit the internal of each extrinsics beside the fact that each
  extrinsics is a byte array encoded using SCALE codec
  [<reference|def-scale-codec>].\ 

  The <samp|extrinsics_root> is set by the runtime, and its value is opaque
  to Polkadot RE.

  The extrinsics in a block are ordered using pairing each extrinsics by a
  UINT32 integer sequential number starting at 0 which is encoded using SCALE
  codec.

  <subsection|Block Format>

  <section|Interactions with the Runtime><label|sect-entries-into-runtime>

  Runtime is the code implementing the logic of the chain. This code is
  decoupled from the Polkadot RE to make the Runtime easily upgradable
  without the need to upgrade the Polkadot RE itself. In this section, we
  describe the details upon which the Polkadot RE is interacting with the
  Runtime.

  <subsection|Loading the Runtime code \ \ >

  Polkadot RE expects to receive the code for the runtime of the chain as a
  compiled WebAssembly (Wasm) Blob. The current runtime is stored in the
  state database under the key represented as a byte array:

  <\equation*>
    b\<assign\><text|3A,63,6F,64,65>
  </equation*>

  which is the byte array of ASCII representation of string \P:code\Q (see
  Section <reference|sect-predef-storage-keys>). For any call to the runtime,
  Polkadot RE makes sure that it has the most updated Runtime as calls to
  runtime have potentially the ability to change the runtime code.

  The initial runtime code of the chain is embedded as an extrinsics into the
  chain initialization JSON file and is submitted to Polkadot RE (see Section
  <reference|sect-genisis-block>).

  Subsequent calls to the runtime have the ability to call the storage API
  (see Section <reference|sect-runtime-api>) to insert a new Wasm blob into
  runtime storage slot to upgrade the runtime.

  <subsection|Code Executor>

  Polkadot RE provides a Wasm Virtual Machine (VM) to run the Runtime. The
  Wasm VM exposes the Polkadot RE API to the Runtime, which, on its turn,
  executes a call to the Runtime entries stored in the Wasm module. This part
  of the Runtime environment is referred to as the <em|<strong|Executor>.>

  In this section, we specify the general setup for an Executor call into the
  Runtime. In Section <reference|sect-runtime-entries> we specify the
  parameters and the return values of each Runtime entry separately.

  <subsubsection|ABI Encoding between Runtime and the Runtime
  Environment><label|sect-abi-encoding>

  All data exchanged between Polkadot RE and the Runtime is encoded using
  SCALE codec described in Section <reference|sect-scale-codec>.

  <subsubsection|Access to Runtime API>

  When Polkadot RE calls a Runtime entry it should make sure Runtime has
  access to the all Polkadot Runtime API functions described in Appendix
  <reference|sect-runtime-api>. This can be done for example by loading
  another Wasm module alongside the runtime which imports these functions
  from Polkadot RE as host functions.

  <subsubsection|Sending Arguments to Runtime \ >

  In each invocation of a Runtime entry, the arguments which are supposed to
  be sent to the entry need to be encoded using SCALE codec into a byte array
  <math|B>. The Executor then needs to retrieve the memory buffer of the
  Runtime Wasm module and extend it to fit the size of the byte array. Then
  it needs to copy the byte array value in the correct offset of the extended
  buffer. Finally, when the Wasm method corresponding to the entry is called,
  two UINT32 integers are sent to the method as arguments. The first one is
  the offset of the byte array <math|B> in the extended shared memory buffer,
  and the second one is the size of <math|B>.

  <subsubsection|The Return Value from a Runtime Entry>

  The value which is returned from the invocation represents two consecutive
  UINT32 integers in which the first one indicates the pointer to the offset
  of the result returned by the entry encoded in SCALE codec in the memory
  buffer. The second one provides the size of the blob.

  <subsection|Entries into Runtime><label|sect-runtime-entries>

  Polkadot RE assumes that at least the following functions are implemented
  in the Runtime Wasm blob and has been exported as shown in Snippet
  <reference|snippet-runtime-enteries>:

  <assign|figure-text|<macro|Snippet>>

  <\small-figure>
    <\cpp-code>
      \ \ (export "Core_version" (func $Core_version))

      \ \ (export "Core_authorities" (func $Core_authorities))

      \ \ (export "Core_execute_block" (func $Core_execute_block))

      \ \ (export "Core_initialise_block" (func $Core_initialise_block))

      \ \ (export "Metadata_metadata" (func $Metadata_metadata))

      \ \ (export "BlockBuilder_apply_extrinsic" (func
      $BlockBuilder_apply_extrinsic))

      \ \ (export "BlockBuilder_finalise_block" (func
      $BlockBuilder_finalise_block))

      \ \ (export "BlockBuilder_inherent_extrinsics" (func
      $BlockBuilder_inherent_extrinsics))

      \ \ (export "BlockBuilder_check_inherents" (func
      $BlockBuilder_check_inherents))

      \ \ (export "BlockBuilder_random_seed" (func
      $BlockBuilder_random_seed))

      \ \ (export "TaggedTransactionQueue_validate_transaction" (func
      $TaggedTransactionQueue_validate_transaction))

      \ \ (export "OffchainWorkerApi_offchain_worker" (func
      $OffchainWorkerApi_offchain_worker))

      \ \ (export "ParachainHost_duty_roster" (func
      $ParachainHost_duty_roster))

      \ \ (export "ParachainHost_active_parachains" (func
      $ParachainHost_active_parachains))

      \ \ (export "ParachainHost_parachain_head" (func
      $ParachainHost_parachain_head))

      \ \ (export "ParachainHost_parachain_code" (func
      $ParachainHost_parachain_code))

      \ \ (export "GrandpaApi_grandpa_pending_change" (func
      $GrandpaApi_grandpa_pending_change))

      \ \ (export "GrandpaApi_grandpa_forced_change" (func
      $GrandpaApi_grandpa_forced_change))

      \ \ (export "GrandpaApi_grandpa_authorities" (func
      $GrandpaApi_grandpa_authorities))

      \ \ (export "ParachainHost_validators" (func $Core_authorities))
    </cpp-code>
  </small-figure|<label|snippet-runtime-enteries>Snippet to export entries
  into tho Wasm runtime module>

  <assign|figure-text|<macro|Figure>>

  The following sections describe the standard based on which Polkadot RE
  communicates with each runtime entry.

  <subsubsection|<verbatim|Core_version>>

  This entry receives no argument; it returns the version data encoded in ABI
  format described in Section <reference|sect-abi-encoding> containing the
  following data:

  \;

  <\with|par-mode|center>
    <small-table|<tabular|<tformat|<cwith|1|7|1|1|cell-halign|l>|<cwith|1|7|1|1|cell-lborder|0ln>|<cwith|1|7|2|2|cell-halign|l>|<cwith|1|7|3|3|cell-halign|l>|<cwith|1|7|3|3|cell-rborder|0ln>|<cwith|1|7|1|3|cell-valign|c>|<cwith|1|1|1|3|cell-tborder|1ln>|<cwith|1|1|1|3|cell-bborder|1ln>|<cwith|7|7|1|3|cell-bborder|1ln>|<cwith|2|-1|1|1|font-base-size|8>|<cwith|2|-1|2|-1|font-base-size|8>|<table|<row|<cell|Name>|<cell|Type>|<cell|Description>>|<row|<cell|<verbatim|spec_name>>|<cell|String>|<cell|runtime
    identifier>>|<row|<cell|<verbatim|impl_name>>|<cell|String>|<cell|the
    name of the implementation (e.g. C++)>>|<row|<cell|<verbatim|authoring_version>>|<cell|UINT32>|<cell|the
    version of the authorship interface>>|<row|<cell|<verbatim|spec_version>>|<cell|UINT32>|<cell|the
    version of the runtime specification>>|<row|<cell|<verbatim|impl_version>>|<cell|UINT32>|<cell|the
    version of the runtime implementation>>|<row|<cell|<verbatim|apis>>|<cell|ApisVec>|<cell|List
    of supported AP>>>>>|Detail of the version data type returns from runtime
    <verbatim|version> function>
  </with>

  <subsubsection|<verbatim|Core_authorities>><label|sect-runtime-api-auth>

  This entry is to report the set of authorities at a given block. It
  receives <verbatim|block_id> as an argument; it returns an array of
  <verbatim|authority_id>'s.

  <subsubsection|<verbatim|Core_execute_block>>

  This entry is responsible for executing all extrinsics in the block and
  reporting back the changes into the state storage. It receives the block
  header and the block body as its arguments, and it returns a triplet:

  <\with|par-mode|center>
    \;

    <small-table|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|-1|font-base-size|8>|<table|<row|<cell|Name>|<cell|Type>|<cell|Description>>|<row|<cell|<verbatim|results>>|<cell|Boolean>|<cell|Indicating
    if the execution was su>>|<row|<cell|<verbatim|storage_changes>>|<cell|<todo|???>>|<cell|Contains
    all changes to the state storage>>|<row|<cell|<verbatim|change_updat>>|<cell|<todo|???>>|<cell|>>>>>|Detail
    of the data execute_block returns after execution>
  </with>

  <subsubsection|<verbatim|Core_initialise_block>>

  <subsubsection|<verbatim|TaggedTransactionQueue_validate_transaction>><label|sect-validate-transaction>

  <todo|Explain function>

  <section|Network Interactions>

  <subsection|Extrinsics Submission>

  Extrinsic submission is made by sending an extrinsic network message. The
  structure of this message is specified in Definition
  <reference|def-extrinsic-network-message>.

  Upon receiving an extrinsics message, Polkadot RE decodes the transaction
  and calls <verbatim|validate_trasaction> runtime function defined in
  Section <reference|sect-validate-transaction>, to check the validity of the
  extrinsic. If <verbatim|validate_transaction> considers the submitted
  extrinsics as a valid one, Polkadot RE makes the extrinsics available for
  the consensus engine for inclusion in future blocks.

  <subsection|Network Messages>

  <\definition>
    <label|def-extrinsic-network-message><strong|Extrinsic submission network
    message: ><todo|<label|def-extrinsic-network-message><strong|Extrinsic
    submission network message definition>>
  </definition>

  <subsection|Block Submission and Validation>

  Block validation is the process, by which the client asserts that a block
  is fit to be added to the blockchain. This means that the block is
  consistent with the world state and transitions from the state of the
  system to a new valid state.

  Blocks can be handed to the Polkadot RE both from the network stack and
  from the consensus engine.

  Both the Runtime and the Polkadot RE need to work together to assure block
  validity. This can be accomplished by Polkadot RE invoking
  <verbatim|execute_block> entry into the runtime as a part of the validation
  process.

  Polkadot RE implements the following procedure to assure the validity of
  the block:

  <\algorithm|<name|Import-and-Validate-Block(<math|B,Just<around|(|B|)>>)>>
    <\algorithmic>
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
        <name|Mark-as-Final><math|<around*|(|P<around*|(|B|)>|)>><END>
      </state>

      <\state>
        Verify <math|H<rsub|p<around|(|B|)>>\<in\>Blockchain>
      </state>

      <\state>
        State-Changes = Runtime<name|<math|<around|(|B|)>>>
      </state>

      <\state>
        <name|Update-World-State>(State-Changes)
      </state>
    </algorithmic>
  </algorithm>

  For the definition of the finality and the finalized block see Section
  <reference|sect-finality>.

  <section|State Storage and the Storage Trie>

  For storing the state of the system, Polkadot RE implements a hash table
  storage where the keys are used to access each data entry state. There is
  no limitation either on the size of the key nor the size of the data stored
  under them, besides the fact that they are byte arrays.

  <subsection|Accessing The System Storage >

  Polkadot RE implements various functions to facilitate access to the system
  storage for the runtime. Section <reference|sect-runtime-api> lists all of
  those functions. Here we define the essential ones which are also used by
  the Polkadot RE.

  <\definition>
    <label|def-state-read-write>The <strong|StateRead> and
    <strong|StateWrite> functions provide basic access to the State Storage:

    <\equation*>
      v=StateRead<around|(|k|)>
    </equation*>

    <\equation*>
      StateWrite<around|(|k,v|)>
    </equation*>

    where v and k are byte arrays.
  </definition>

  To authenticate the state of the system, the stored data needs to be
  re-arranged and hashed in a <em|modified Merkle Patricia Tree>, which
  hereafter we refer to as the <em|<strong|Trie>,> in order to compute the
  hash of the whole state storage consistently and efficiently at any given
  time.

  As well, a modification has been made in the storing of the nodes' hash in
  the Merkle Tree structure to save space on entries storing small entries.

  Because the Trie is used to compute the <em|state root>, <math|H<rsub|r>>,
  (see Definition <reference|def-block-header>), which is used to
  authenticate the validity of the state database, Polkadot RE follows a
  rigorous encoding algorithm to compute the values stored in the trie nodes
  to ensure that the computed Merkle hash, <math|H<rsub|r>>, matches across
  clients.

  <subsection|The General Tree Structure>

  Each key value identifies a unique node in the tree. However, a node in a
  tree might or might not be associated with a key in the storage. Similar to
  a radix trie, when traversing the Trie, subsequences of the key, are stored
  in the nodes on the path to the node associated with the key.

  To identify the node corresponding to a key value, <math|k>, first we need
  to encode <math|k> in a way consistent with the Trie structure. Because
  each node in the trie has at most 16 children, we represent the key as a
  sequence of 4-bit nibbles:

  <\definition>
    For the purpose of labeling the branches of the Trie, the key <math|k> is
    encoded to <math|k<rsub|enc>> using KeyEncode functions:

    <\equation>
      k<rsub|enc>\<assign\><around|(|k<rsub|enc<rsub|1>>,\<ldots\>,k<rsub|enc<rsub|2*n>>|)>\<assign\>KeyEncode<around|(|k|)><label|key-encode-in-trie>
    </equation>

    such that:

    <\equation*>
      KeyEncode<around|(|k|)>:<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|\<bbb-B\><rsup|\<nosymbol\>>>|<cell|\<rightarrow\>>|<cell|Nibbles<rsub|4>>>|<row|<cell|k\<assign\><around|(|b<rsub|1>,\<ldots\>,b<rsub|n>|)>\<assign\>>|<cell|\<mapsto\>>|<cell|<around|(|b<rsup|1><rsub|1>,b<rsup|2><rsub|1>,b<rsub|2><rsup|1>,b<rsup|2><rsub|2>,\<ldots\>,b<rsup|1><rsub|n>,b<rsup|2><rsub|n>|)>>>|<row|<cell|>|<cell|>|<cell|\<assign\><around|(|k<rsub|enc<rsub|1>>,\<ldots\>,k<rsub|enc<rsub|2*n>>|)>>>>>>|\<nobracket\>>
    </equation*>

    where <math|Nibble<rsub|4>> is the set of all nibbles of 4-bit arrays and
    <math|b<rsup|1><rsub|i>> and <math|b<rsup|2><rsub|i>> are 4-bit nibbles,
    which are the little endian representations of <math|b<rsub|i>>:

    <\equation*>
      <around|(|b<rsup|1><rsub|i>,b<rsup|2><rsub|i>|)>\<assign\><around|(|b<rsub|i>mod
      16,b<rsub|i>/16|)>
    </equation*>

    , where mod is the remainder and / is the integer division operators.
  </definition>

  By looking at <math|k<rsub|enc>> as a sequence of nibbles, one can walk the
  radix tree to reach the node identifying the storage value of <math|k>.

  <subsection|Different node types>

  In this subsection, we specify the structure of the nodes in the Trie:

  <\notation>
    We refer to the <strong|set of the nodes of Polkadot state trie> by
    <math|\<cal-N\>.>
  </notation>

  The Trie consists of 3 three types of nodes based on how they store the
  subsequence of shared prefix nibbles:

  <\itemize>
    <item><strong|Leaf:> It is a childless node that stores the remaining
    subsequence of <math|KeyEncode<around|(|k|)>> not accounted for in the
    path to the node, as well as the value associated with that key.\ 

    <item><strong|Extension:> It stores the subsequence of
    KeyEncode(<math|k>) of a size larger than 1 (i.e. 4 bits), which is at
    least shared with two or more keys in the Trie. It always has one child.
    It does not store a value.

    <item><strong|Branch:> It has up to 16 children. It stores no key. It
    accounts for one nibble of the key corresponding to the path passing
    through each of its children. It optionally stores a value of the key
    corresponding to the path traversed to the node.
  </itemize>

  Accordingly, we define:

  <\definition>
    <label|defn-nodetype>We define <strong|<math|NodeType>> function to be

    <\equation*>
      <tabular|<tformat|<table|<row|<cell|NodeType>|<cell|:>|<cell|\<cal-N\>>|<cell|\<rightarrow\>>|<cell|<around*|{|Leaf,Extension,Branch|}>>>|<row|<cell|>|<cell|>|<cell|N>|<cell|\<mapsto\>>|<cell|The
      type of node N>>>>>
    </equation*>
  </definition>

  <\definition>
    The <strong|partial key> of node N of length <math|j\<leqslant\>380> to
    be\ 

    <\equation*>
      pk<rsub|N>\<assign\><around|(|k<rsub|enc<rsub|i>>,\<ldots\>,k<rsub|enc<rsub|i+j>>|)>
    </equation*>

    a subsequence of a key <math|k>

    <\equation*>
      KeyEncode<around|(|k|)>=<around|(|k<rsub|enc<rsub|1>>,\<ldots\>,k<rsub|enc<rsub|i-1>>,k<rsub|enc<rsub|i>>,\<ldots\>,k<rsub|enc<rsub|2*n>>|)>
    </equation*>

    corresponding to a key-value paired <math|<around*|(|k,v|)>> in the State
    storage such that <math|pk<rsub|N>> is stored in <math|N>.
  </definition>

  Consequently, for an extension node <math|j\<geqslant\>2> and for a branch
  node <math|j=0>.\ 

  <subsection|The Merkle proof><label|sect-merkl-proof>

  To prove the consistency of the state storage across the network and its
  modifications efficiently, the Merkle hash of the storage trie needs to be
  computed rigorously.

  The Merkle hash of the trie is computed recursively. As such, the hash
  value of each node depends on the hash value of all its children and also
  on its value. Therefore, it suffices to define how to compute the hash
  value of a typical node as a function of the hash value of its children and
  its own value.

  \;

  <\definition>
    <label|def-node-prefix>For a trie node N, <strong|Node Prefix >function
    is a value specifying the node type as follows:

    <\equation*>
      NodePrefix<around|(|N|)>\<assign\><around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|1>|<cell|>|<cell|N
      <text| is a leaf node>>>|<row|<cell|128>|<cell|>|<cell|N <text| is an
      extension node>>>|<row|<cell|254>|<cell|>|<cell|N<text| is a branch
      node without value>>>|<row|<cell|255>|<cell|>|<cell|N<text| is a branch
      node with value>>>>>>|\<nobracket\>>
    </equation*>
  </definition>

  <\definition>
    For a given node <math|N>, with partial key of <math|pk<rsub|N>> and
    Value <math|v>, the <strong|encoded representation> of <math|N>, formally
    referred to as <math|Enc<rsub|Node><around|(|N|)>> is determined as
    follows, in case which:

    <\itemize>
      <item><math|N> is a leaf node:

      <\equation*>
        Enc<rsub|Node><around|(|N|)>\<assign\>Enc<rsub|len><around|(|N|)><around|\|||\|>*Enc<rsub|HE><around|(|pk<rsub|N>|)><around|\|||\|>*Enc<rsub|SC><around|(|v|)>
      </equation*>

      <item>N is an extension node:

      <\equation*>
        Enc<rsub|Node><around*|(|N|)>:=Enc<rsub|len><around*|(|<around*|\<nobracket\>|N|)>|\<\|\|\>>Enc<rsub|HE><around|(|pk<rsub|N>|)><around*|\|||\|>Enc<rsub|SC><around*|(|H<around*|(|C|)>|)>
      </equation*>

      <item>N is a branch node:

      <\equation*>
        <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<table|<row|<cell|<text|Enc<rsub|Node>(N)>\<assign\>>>|<row|<cell|\<nobracket\>NodePrefix<around|(|N|)><around|\|||\|>Enc<rsub|LE><around*|(|*ChildrenBitmap<around|(|N|)>|)>\<\|\|\>Enc<rsub|SC><around|(|v|)><around|\|||\|>*>>|<row|<cell|Enc<rsub|SC><around*|(|H<around|(|N<rsub|C<rsub|1>>|)>|)>*\<ldots\>*Enc<rsub|SC><around*|(|H<around|(|N<rsub|C<rsub|n>>|)>|)>>>>>>
      </equation*>
    </itemize>
  </definition>

  Where

  \;

  <\itemize>
    <item><math|Enc<rsub|len>,Enc<rsub|HE>> and <math|Enc<rsub|SC>> are
    encdoings defined in Section <reference|sect-encoding>.

    <item><math|Enc<rsub|LE>> is the little-endian encoding defined in
    Definition <reference|defn-little-endian>.

    <item><math|C> is the unique child of the extension node <math|N>.

    <item><math|ChildrenBitmap(N)\<assign\><around*|(|b<rsub|15>b<rsub|14>\<ldots\>,b<rsub|1>,b<rsub|0>|)><rsub|2>>
    where bit <math|b<rsub|i>=1> if <math|N> has a child with partial key
    <math|i>.

    <item><math|N<rsub|C<rsub|1>>*\<ldots\>*N<rsub|C<rsub|n>>> with
    <math|n\<leqslant\>16> are the children nodes of the branch node
    <math|N>.
  </itemize>

  <\definition>
    For a given node <math|N>, the <strong|Merkle value> of <math|N>, denoted
    by <math|H<around|(|N|)>> is defined as follows:

    <\equation*>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|>|<cell|H:\<bbb-B\>\<rightarrow\><big|cup><rsub|i=0<rsup|\<nosymbol\>>><rsup|32>\<bbb-B\><rsub|i>>|<cell|>>|<row|<cell|>|<cell|H<around|(|N|)>:<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|Enc<rsub|Node><around|(|N|)>>|<cell|<around|\<\|\|\>|Enc<rsub|Node><around|(|N|)>|\<\|\|\>>\<less\>32>|<cell|>>|<row|<cell|Hash<around|(|Enc<rsub|Node><around|(|N|)>|)>>|<cell|<around|\<\|\|\>|Enc<rsub|Node><around|(|N|)>|\<\|\|\>>\<geqslant\>32>|<cell|>>>>>|\<nobracket\>>>|<cell|>>>>>
    </equation*>
  </definition>

  <section|Transactions>

  <subsection|preliminaries>

  <\definition>
    <label|defn-account-key><strong|Account key
    <math|<around*|(|sk<rsup|a>,pk<rsup|a>|)>>> is a pair of <math|>ristretto
    SR25519 used to sign transactions among other accounts and blance-related
    functions.
  </definition>

  <section|Consensus Engine>

  Consensus in Polkadot RE is achieved during the execution of two different
  procedures. The first procedure is block production and the second is
  finality. Polkadot RE must run these procedures, if and only if it is
  running on a validator node.

  <subsection|Block Tree>

  In the course of formation of a (distributed) blockchain, it is possible
  that the chain forks into multiple subchains in various block positions. We
  refer to this structure as a <em|block tree:>

  <\definition>
    <label|defn-block-tree>The <strong|Block Tree> of a blockchain is the
    union of all different versions of the blockchain observed by all the
    nodes in the system such as every such block is a node in the graph and
    <math|B<rsub|1>> is connected to <math|B<rsub|2>> if <math|B<rsub|1>> is
    a parent of <math|B<rsub|2>>.
  </definition>

  Because every block in the blockchain contains a reference to its parent,
  it is easy to see that the block tree is actually a tree.

  A block tree naturally imposes partial order relationships on the blocks as
  follows:

  <\definition>
    We say <strong|B is descendant of <math|B<rprime|'>>>, formally noted as
    <strong|<math|B\<gtr\>B<rprime|'>>> if <math|B> is a descendant of
    <math|B<rprime|'>> in the block tree.
  </definition>

  <subsection|Block Production>

  Polkadot RE uses BABE protocol <cite|w3f_research_group_blind_2019> for
  block production designed based on Ouroboros praos
  <cite|david_ouroboros_2018>. BABE execution happens in sequential
  non-overlapping phases known as an <strong|<em|epoch>>. Each epoch on its
  turn is divided into a predefined number of slots. All slots in each epoch
  are sequentially indexed starting from 0. At the beginning of each epoch,
  the BABE node needs to run Algorithm <reference|algo-babe-slot-selection>
  to find out in which slots it should produce a block and gossip to the
  other block producers. In turn, the block producer node should keep a copy
  of the block tree and grow it as it receives valid blocks from other block
  producers. A block producer prunes the tree in parallel using Algorithm
  <reference|algo-block-tree-prunning>.

  <subsubsection|Preliminaries>

  <\definition>
    A <strong|Block Producer>, noted by <math|\<cal-P\><rsub|j>> is a node
    running Polkadot RE which is authorized to keep a transaction queue and
    which gets a turn in producing blocks.
  </definition>

  <\definition>
    <strong|Block signing key pair <math|<around*|(|sk<rsup|s><rsub|j>,pk<rsup|s><rsub|j>|)>>>
    is an ED25519 key pair which the block producer <math|\<cal-P\><rsub|j>>
    signs by their account key (see Definition <reference|defn-account-key>)
    and is used to sign the produced block. Similarly <strong|block lottery
    key pair>, noted by <strong|<math|<around*|(|sk<rsub|j><rsup|v>,pk<rsup|s><rsub|j>|)>>>,
    is a ED25519 key pair which is used by <math|\<cal-P\><rsub|j>> to
    compute its lottery values.\ 
  </definition>

  <\definition>
    A block production <strong|epoch>, formally refered to as
    <math|\<cal-E\>> is a period with pre-known starting time and fixed
    length during which the set of block producers stays constant. Epochs are
    indexed sequentially, we refer to the <math|n<rsup|th>> epoch since
    genesis by <math|\<cal-E\><rsub|n>>. Each epoch is divided into
    <math|>equal length periods known as block production <strong|slot>s
    sequentially indexed in each epoch. Each slot is awarded to a subset of
    block producers during which they are allowed to generate a block.
  </definition>

  <\notation>
    We refer to the number of slots in epoch <math|\<cal-E\><rsub|n>> by
    <math|sc<rsub|n>>. <math|sc<rsub|n>> is set to ??? at the genesis.\ 
  </notation>

  <subsubsection|Block Production Lottery>

  <\definition>
    <strong|Winning threshold> denoted by <strong|<math|\<tau\>>> is the
    threshold which is used in Algorirthm <reference|algo-slot-lottery> to
    decide if a block producer is the winner of a specific slot.
    <math|\<tau\>> is initially set to ???.
  </definition>

  During each epoch, each block producer node should run Algorithm
  <reference|algo-block-lottery> to identify the slots it is awarded. These
  are the slots during which the block producer is allowed to build a block.
  The <math|sk<rsup|v>> is the block producer lottery secret key and <math|n>
  is the epoch for whose slots the block producer is running the lottery.

  <\algorithm|<label|algo-block-production><name|Block-production-lottery><math|<around*|(|sk<rsup|v>,n|)>>>
    <\algorithmic>
      <\state>
        <math|r\<leftarrow\>><name|Epoch-Randomness<math|<around*|(|n|)>>>
      </state>

      <\state>
        <FOR-TO|<math|i\<assign\>1>|<math|sc<rsub|n>>>
      </state>

      <\state>
        <math|<around*|(|d,\<pi\>|)>\<leftarrow\>><em|<name|VRF>>(<math|i,sk<rsup|v>>)
      </state>

      <\state>
        <math|A<around*|[|i|]>\<leftarrow\><around*|(|i,d,\<pi\>|)>><END>
      </state>

      <\state>
        <\RETURN>
          A
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  For any slot <math|i> in epoch <math|n> where <math|d\<less\>\<tau\>>, the
  block producer is required to produce a block. For the definitions of
  <name|Epoch-Randomness<math|>> and <em|<name|VRF>> functions, see Sections
  <reference|sect-randomness> and <reference|sect-vrf> respectively.

  \ <subsubsection|Block Production>

  <subsection|Finality><label|sect-finality>

  Polkadot RE uses GRANDPA Finality protocol
  <cite|alistair_stewart_grandpa:_2019> to finalize blocks. Finality is
  obtained by consecutive rounds of voting by validator nodes. Validators
  execute GRANDPA finality process in parallel to Block Production as an
  independent service. In this section, we describe the different functions
  that GRANDPA service is supposed to perform to successfully participate in
  the block finalization process.

  <subsubsection|Preliminaries>

  <\definition>
    A <strong|GRANDPA Voter>, <math|v>, is represented by a key pair
    <math|<around|(|k<rsup|pr><rsub|v>,v<rsub|id>|)>> where
    <math|k<rsub|v><rsup|pr>> represents its private key which is an
    <math|ED25519> private key, is a node running GRANDPA protocol, and
    broadcasts votes to finalize blocks in a Polkadot RE - based chain. The
    <strong|set of all GRANDPA voters> is indicated by <math|\<bbb-V\>>. For
    a given block B, we have4

    <\equation*>
      \<bbb-V\><rsub|B>=<verbatim|authorities><around*|(|B|)>
    </equation*>

    where <math|<math-tt|authorities>> is the entry into runtime described in
    Section <reference|sect-runtime-api-auth>.
  </definition>

  <\definition>
    <strong|GRANDPA state>, <math|GS>, is defined as

    <\equation*>
      GS\<assign\><around|{|\<bbb-V\>,id<rsub|\<bbb-V\>>,r|}>
    </equation*>

    where:

    <math|\<bbb-V\>>: is the set of voters.

    <strong|<math|\<bbb-V\><rsub|id>>>: is an incremental counter tracking
    <verbatim|>membership, which changes in V.

    <strong|r>: is the voting round number.
  </definition>

  Now we need to define how Polkadot RE counts the number of votes for block
  <math|B>. First a vote is defined as:

  <\definition>
    <label|def-vote>A <strong|GRANDPA vote >or simply a vote for block
    <math|B> is an ordered pair defined as

    <\equation*>
      V<rsub|\<nosymbol\>><around|(|B|)>\<assign\><around|(|H<rsub|h><around|(|B|)>,H<rsub|i><around|(|B|)>|)>
    </equation*>

    where <math|H<rsub|h><around|(|B|)>> and <math|H<rsub|i><around|(|B|)>>
    are the block hash and the block number defined in Definitions
    <reference|def-block-header> and <reference|def-block-header-hash>
    respectively.
  </definition>

  <\definition>
    Voters engage in a maximum of two sub-rounds of voting for each round
    <math|r>. The first sub-round is called <strong|pre-vote> and<verbatim|>
    the second sub-round is called <strong|pre-commit>.

    By <strong|<math|V<rsub|v><rsup|r,pv>>> and
    <strong|<math|V<rsub|v><rsup|r,pc>>> we refer to the vote cast by voter
    <math|v> in round <math|r> (for block <math|B>) during the pre-vote and
    the pre-commit sub-round respectively.
  </definition>

  The GRANDPA protocol dictates how an honest voter should vote in each
  sub-round, which is described in Algorithm <reference|alg-grandpa-round>.
  After defining what constitues a vote in GRANDPA, we define how GRANDPA
  counts votes.

  <\definition>
    Voter <math|v> <strong|equivocates> if they broadcast two or more valid
    votes to blocks not residing on the same branch of the block tree during
    one voting sub-round. In such a situation, we say that <math|v> is an
    <strong|equivocator> and any vote <math|V<rsub|v><rsup|r,stage><around*|(|B|)>>
    cast by <math|v> in that round is an <strong|equivocatory vote> and

    <\equation*>
      \<cal-E\><rsup|r,stage>
    </equation*>

    \ represents the set of all equivocators voters in sub-round
    \P<math|stage>\Q of round <math|r>. When we want to refer to the number
    of<verbatim|> equivocators whose equivocation has been observed by voter
    <math|v> we refer to it by:

    <\equation*>
      \<cal-E\><rsup|r,stage><rsub|obs<around*|(|v|)>>
    </equation*>

    \ 
  </definition>

  <\definition>
    A vote <math|V<rsub|v><rsup|r,stage>=V<around|(|B|)>> is <strong|invalid>
    if

    <\itemize>
      <\itemize-dot>
        <item><math|H<around|(|B|)>> does not correspond to a valid block;

        <item><math|B> is not an (eventual) descendant of a previously
        finalized block;

        <item><math|M<rsup|r,stage><rsub|v>> does not bear a valid signature;

        <item><math|id<rsub|\<bbb-V\>>> does not match the current
        <math|\<bbb-V\>>;

        <item>If <math|V<rsub|v><rsup|r,stage>> is an equivocatory vote.
      </itemize-dot>
    </itemize>
  </definition>

  <\definition>
    For validator v, <strong|the set of observed direct votes for Block
    <math|B> in round <math|r>>, formally denoted by
    <math|VD<rsup|r,stage><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>><around|(|B|)>>
    is equal to the union of:

    <\itemize-dot>
      <item>set of valid votes <math|V<rsup|r,stage><rsub|v<rsub|i>>> cast in
      round <math|r> and received by v such that
      <math|V<rsup|r,stage><rsub|v<rsub|i>>=V<around|(|B|)>>.
    </itemize-dot>
  </definition>

  <\definition>
    We refer to <strong|the set of total votes observed by voter <math|v> in
    sub-round \P<math|stage>\Q of round <math|r>> by
    <strong|<math|V<rsup|r,stage><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>>>>.

    The <strong|set of all observed votes by <math|v> in the sub-round stage
    of round <math|r> for block <math|B>>,
    <strong|<math|V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>>> is
    equal to all of the observed direct votes casted for block <math|B> and
    all of the <math|B>'s descendents defined formally as:

    <\equation*>
      V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>\<assign\><big|cup><rsub|v<rsub|i>\<in\>\<bbb-V\>,B\<geqslant\>B<rprime|'>>VD<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B<rprime|'>|)><rsub|\<nosymbol\>><rsup|\<nosymbol\>><rsub|\<nosymbol\>>
    </equation*>

    The <strong|total number of observed votes for Block <math|B> in round
    <math|r>> is defined to be the size of that set plus the total number of
    equivocators voters:

    <\equation*>
      #V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>=<around|\||V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>|\|>+<around*|\||\<cal-E\><rsup|r,stage><rsub|obs<around*|(|v|)>>|\|>
    </equation*>
  </definition>

  <\definition>
    The current <strong|pre-voted> block <math|B<rsup|r,pv><rsub|v>> is the
    block with

    <\equation*>
      H<rsub|n><around|(|B<rsup|r,pv><rsub|v>|)>=Max<around|(|<around|\<nobracket\>|H<rsub|n><around|(|B|)>|\|>*\<forall\>B:#V<rsub|obs<around|(|v|)>><rsup|r,pv><around|(|B|)>\<geqslant\>2/3<around|\||\<bbb-V\>|\|>|)>
    </equation*>
  </definition>

  Note that for genesis block <math|Genesis> we always have
  <math|#V<rsub|obs<around|(|v|)>><rsup|r,pv><around|(|B|)>=<around*|\||\<bbb-V\>|\|>>.

  \;

  Finally, we define when a voter <math|v> see a round as completable, that
  is when they are confident that <math|B<rsub|v><rsup|r,pv>> is an upper
  bound for what is going to be finalised in this round. \ 

  <\definition>
    We say that round <math|r> is <strong|completable> if
    <math|<around|\||V<rsup|r,pc><rsub|obs<around|(|v|)>>|\|>+\<cal-E\><rsup|r,pc><rsub|obs<around*|(|v|)>>\<gtr\><frac|2|3>\<bbb-V\>>
    and for all <math|B<rprime|'>\<gtr\>B<rsub|v><rsup|r,pv>>:

    <\equation*>
      <tabular|<tformat|<cwith|1|1|1|1|cell-valign|b>|<table|<row|<cell|<around|\||V<rsup|r,pc><rsub|obs<around|(|v|)>>|\|>-\<cal-E\><rsup|r,pc><rsub|obs<around*|(|v|)>>-<around|\||V<rsup|r,pc><rsub|obs<around|(|v|)><rsub|\<nosymbol\>>><around|(|B<rprime|'>|)>|\|>\<gtr\><frac|2|3><around|\||\<bbb-V\>|\|>>>>>>
    </equation*>
  </definition>

  Note that in practice we only need to check the inequality for those
  <math|B<rprime|'>\<gtr\>B<rsub|v><rsup|r,pv>> where
  <math|<around|\||V<rsup|r,pc><rsub|obs<around|(|v|)><rsub|\<nosymbol\>>><around|(|B<rprime|'>|)>|\|>\<gtr\>0>.\ 

  \;

  <subsubsection|Voting Messages Specification>

  Voting is done by means of broadcasting voting messages to the network.
  Validators inform their peers about the block finalized in round <math|r>
  by broadcasting a finalization message (see Algorithm
  <reference|alg-grandpa-round> for more details). These messages are
  specified in this section.

  <\definition>
    A vote casted by voter <math|v> should be broadcasted as a
    <strong|message <math|M<rsup|r,stage><rsub|v>>> to the network by voter
    <math|v> with the following structure:

    <\equation*>
      M<rsup|r,stage><rsub|v>\<assign\>Enc<rsub|SC><around|(|r,id<rsub|\<bbb-V\>>,Enc<rsub|SC><around|(|stage,V<rsub|v><rsup|r,stage>|\<nobracket\>>,Sig<rsub|ED25519><around|(|Enc<rsub|SC><around|(|stage,V<rsub|v><rsup|r,stage>|\<nobracket\>>,r,V<rsub|id>|)>,v<rsub|id>|)>
    </equation*>

    Where:

    <\center>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|r:>|<cell|round
      number>|<cell|64 bit integer>>|<row|<cell|<math|V<rsub|id>>:>|<cell|incremental
      change tracker counter>|<cell|64 bit
      integer>>|<row|<cell|<right-aligned|<math|v<rsub|id>>>:>|<cell|Ed25519
      public key of <math|v>>|<cell|4 byte
      array>>|<row|<cell|<right-aligned|><math|stage>:>|<cell|0 if it is the
      pre-vote sub-round>|<cell|1 byte>>|<row|<cell|>|<cell|1 if it the
      pre-commit sub-round>|<cell|>>>>>
    </center>

    \;
  </definition>

  <\definition>
    <label|def-grandpa-justification>The <strong|justification for block B in
    round <math|r>> of GRANDPA protocol defined
    <math|J<rsup|r><around*|(|B|)>> is a vector of pairs of the type:

    <\equation*>
      <around*|(|V<around*|(|B<rprime|'>|)>,<around*|(|Sign<rsup|r,pc><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>,v<rsub|id>|)>|)>
    </equation*>

    in which either

    <\equation*>
      B<rprime|'>\<gtr\>B
    </equation*>

    or <math|V<rsup|r,pc><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>> is an
    equivocatory vote.

    In all cases, <math|Sign<rsup|r,pc><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>>
    is the signature of voter <math|v<rsub|i>> broadcasted during the
    pre-commit sub-round of round r.
  </definition>

  <\definition>
    <strong|<math|GRANDPA> finalizing message for block <math|B> in round
    <math|r>> represented as <strong|<math|M<rsub|v><rsup|r,Fin>>(B)> is a
    message broadcasted by voter <math|v> to the network indicating that
    voter <math|v> has finalized block <math|B> in round <math|r>. It has the
    following structure:

    <\equation*>
      M<rsup|r,Fin><rsub|v><around*|(|B|)>\<assign\>Enc<rsub|SC><around|(|r,V<around*|(|B|)>,J<rsup|r><around*|(|B|)>|)>
    </equation*>

    in which <math|J<rsup|r><around*|(|B|)>> in the justification defined in
    Definition <reference|def-grandpa-justification>.
  </definition>

  <subsubsection|Initiating the GRANDPA State>

  A validator needs to initiate its state and sync it with other validators,
  to be able to participate coherently in the voting process. In particular,
  considering that voting is happening in different rounds and each round of
  voting is assigned a unique sequential round number <math|r<rsub|v>>, it
  needs to determine and set its round counter <math|r> in accordance with
  the current voting round <math|r<rsub|n>>, which is currently undergoing in
  the network.

  As instructed in Algorithm <reference|alg-join-leave-grandpa>, whenever the
  membership of GRANDPA voters changes, <math|r> is set to 0 and
  <math|V<rsub|id>> needs to be incremented.

  <\algorithm>
    <label|alg-join-leave-grandpa><name|Join-Leave-Grandpa-Voters>
    (<math|\<cal-V\>>)
  <|algorithm>
    <\algorithmic>
      <\state>
        <math|r\<leftarrow\>0>
      </state>

      <\state>
        <math|\<cal-V\><rsub|id>\<leftarrow\>ReadState<around|(|<rprime|'>AUTHORITY_SET_KEY<rprime|'>|)>>
      </state>

      <\state>
        <math|\<cal-V\><rsub|id>\<leftarrow\>\<cal-V\><rsub|id>+1>
      </state>

      <\state>
        <name|Execute-One-Grandpa-Round><math|<around|(|r|)>>
      </state>
    </algorithmic>
  </algorithm>

  Each voter should run Algorithm <reference|alg-completable-round> to verify
  that a round is completable.

  <subsubsection|Voting Process in Round <math|r>>

  For each round <math|r>, an honest voter <math|v> must participate in the
  voting process by following Algorithm <reference|alg-grandpa-round>.

  <\algorithm|<label|alg-grandpa-round><name|Play-Grandpa-round><math|<around|(|r|)>>>
    <\algorithmic>
      <\state>
        <math|t<rsub|r,v>\<leftarrow\>>Time
      </state>

      <\state>
        <math|primary\<leftarrow\>><name|Derive-Primary>
      </state>

      <\state>
        <\IF>
          <math|v=primary>
        </IF>
      </state>

      <\state>
        <name|Broadcast(><left|.><math|M<rsub|v<rsub|\<nosymbol\>>><rsup|r-1,Fin>>(<name|Best-Final-Candidate>(<math|r>-1))<right|)><END>
      </state>

      <\state>
        <name|Receive-Messages>(<strong|until> Time
        <math|\<geqslant\>t<rsub|r<rsub|,>*v>+2\<times\>T> <strong|or>
        <math|r> <strong|is> completable)<END>
      </state>

      <\state>
        <math|L\<leftarrow\>><name|Best-Final-Candidate>(<math|r>-1)
      </state>

      <\state>
        <\IF>
          <name|Received(<math|M<rsub|v<rsub|primary>><rsup|r,pv><around|(|B|)>>)>
          <strong|and> <math|B<rsup|r,pv><rsub|v>\<geqslant\>B\<gtr\>L>
        </IF>
      </state>

      <\state>
        <math|N\<leftarrow\>B><END>
      </state>

      <\state>
        <\ELSE>
          \;
        </ELSE>
      </state>

      <\state>
        <math|N\<leftarrow\>B<rprime|'>:H<rsub|n><around|(|B<rprime|'>|)>=max
        <around|{|H<rsub|n><around|(|B<rprime|'>|)>:B<rprime|'>\<gtr\>L|}><END>>
      </state>

      <\state>
        <name|Broadcast>(<math|M<rsub|v><rsup|r,pv><around|(|N|)>>)
      </state>

      <\state>
        <name|Receive-Messages>(<strong|until>
        <math|B<rsup|r,pv<rsub|\<nosymbol\>>><rsub|v>\<geqslant\>L>
        <strong|and> (Time <math|\<geqslant\>t<rsub|r<rsub|,>*v>+4\<times\>T><strong|
        or ><math|r> <strong|is> completable))
      </state>

      <\state>
        <name|Broadcast(<math|M<rsub|v><rsup|r,pc>>(<math|B<rsub|v><rsup|r,pv>>))>
      </state>

      <\state>
        <name|Play-Grandpa-round>(<math|r+1>)
      </state>
    </algorithmic>
  </algorithm>

  <\algorithm|<label|alg-grandpa-best-candidate><name|Best-Final-Candidate>(<math|r>)>
    <\algorithmic>
      <\state>
        <math|\<cal-C\><rsub|\<nosymbol\>>\<leftarrow\><around|{|B<rprime|'>\|B<rprime|'>\<leqslant\>B<rsub|v><rsup|r,pv>:<around|\||V<rsub|v><rsup|r,pc>|\|>-#V<rsub|v><rsup|r,pc><around|(|B<rprime|'>|)>\<leqslant\>1/3<around|\||\<bbb-V\>|\|>|}>>
      </state>

      <\state>
        <\IF>
          <math|\<cal-C\>=\<phi\>>
        </IF>
      </state>

      <\state>
        <\RETURN>
          <math|\<phi\>><END>
        </RETURN>
      </state>

      <\state>
        <\ELSE>
          \;
        </ELSE>
      </state>

      <\state>
        <\RETURN>
          <math|E\<in\>\<cal-C\>:H<rsub|n><around*|(|E|)>=max
          <around|{|H<rsub|n><around|(|B<rprime|'>|)>:B<rprime|'>\<in\>\<cal-C\>|}>><END>
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  <\algorithm|<name|Attempt-To-Finalize-Round>(<math|r>)>
    <\algorithmic>
      <\state>
        <math|L\<leftarrow\>><name|Last-Finalized-Block>
      </state>

      <\state>
        <math|E\<leftarrow\>><name|Best-Final-Candidate>(<math|r>)
      </state>

      <\state>
        <\IF>
          <math|E\<geqslant\>L> <strong|and>
          <math|V<rsup|r-1,pc><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>><around|(|E|)>\<gtr\>2/3<around|\||\<cal-V\>|\|>>
        </IF>
      </state>

      <\state>
        <name|Last-Finalized-Block><math|\<leftarrow\>B<rsup|r,pc>>
      </state>

      <\state>
        <\IF>
          <math|M<rsub|v><rsup|r,Fin><around|(|E|)>\<nin\>><name|Received-Messages>
        </IF>
      </state>

      <\state>
        <name|Broadcast>(<math|M<rsub|v><rsup|r,Fin><around|(|E|)>>)
      </state>

      <\state>
        <\RETURN>
          <END><END>
        </RETURN>
      </state>

      <\state>
        <strong|schedule-call> <name|Attempt-To-Finalize-Round>(<math|r>)
        <strong|when> <name|Receive-Messages>\ 
      </state>
    </algorithmic>
  </algorithm>

  <section|Cryptographic Algorithms>

  <subsection|Randomness><label|sect-randomness>

  <subsection|VRF><label|sect-vrf>

  \;

  <section|Auxiliary Encodings><label|sect-encoding>

  <subsection|SCALE Codec><label|sect-scale-codec>

  Polkadot RE uses <em|Simple Concatenated Aggregate Little-Endian\Q (SCALE)
  codec> to encode byte arrays that provide canonical encoding and to produce
  consistent hash values across their implementation, including the Merkle
  hash proof for the State Storage.

  <\definition>
    <label|def-scale-codec>The <strong|SCALE codec> for <strong|Byte array>
    <math|A> such that

    <\equation*>
      A\<assign\>b<rsub|1>*b<rsub|2>*\<ldots\>*b<rsub|n>
    </equation*>

    such that <math|n\<less\>2<rsup|536>> is a byte array refered to
    <math|Enc<rsub|SC><around|(|A|)>> and defined as follows:

    <\equation*>
      Enc<rsub|SC><around|(|A|)>\<assign\><around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|l<rsup|\<nosymbol\>><rsub|1>*b<rsub|1>*b<rsub|2>*\<ldots\>*b<rsub|n>>|<cell|>|<cell|0\<leqslant\>n\<less\>2<rsup|6>>>|<row|<cell|i<rsup|\<nosymbol\>><rsub|1>*i<rsup|\<nosymbol\>><rsub|2>*b<rsub|1>*\<ldots\>*b<rsub|n>>|<cell|>|<cell|2<rsup|6>\<leqslant\>n\<less\>2<rsup|14>>>|<row|<cell|j<rsup|\<nosymbol\>><rsub|1>*j<rsup|\<nosymbol\>><rsub|2>*j<rsub|3>*b<rsub|1>*\<ldots\>*b<rsub|n>>|<cell|>|<cell|2<rsup|14>\<leqslant\>n\<less\>2<rsup|30>>>|<row|<cell|k<rsub|1><rsup|\<nosymbol\>>*k<rsub|2><rsup|\<nosymbol\>>*\<ldots\>*k<rsub|m><rsup|\<nosymbol\>>*b<rsub|1>*\<ldots\>*b<rsub|n>>|<cell|>|<cell|2<rsup|30>\<leqslant\>n>>>>>|\<nobracket\>>
    </equation*>

    in which:<space|0.17em>

    <\equation*>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-lborder|1ln>|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-rborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-bborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<table|<row|<cell|l<rsup|1><rsub|1>*l<rsub|1><rsup|0>=00>>|<row|<cell|i<rsup|1><rsub|1>*i<rsub|1><rsup|0>=01>>|<row|<cell|j<rsup|1><rsub|1>*j<rsub|1><rsup|0>=10>>|<row|<cell|k<rsup|1><rsub|1>*k<rsub|1><rsup|0>=11>>>>>
    </equation*>

    and n is stored in <math|Enc<rsub|SC><around|(|A|)>> in little-endian
    format in base-2 as follows:

    <\equation*>
      <around*|\<nobracket\>|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|l<rsup|7><rsub|1>*\<ldots\>*l<rsup|3><rsub|1>*l<rsup|2><rsub|1>>|<cell|>|<cell|n\<less\>2<rsup|6>>>|<row|<cell|i<rsub|2><rsup|7>*\<ldots\>*i<rsub|2><rsup|0>*i<rsub|1><rsup|7>*\<ldots\>*i<rsup|2><rsub|1><rsup|\<nosymbol\>>>|<cell|>|<cell|2<rsup|6>\<leqslant\>n\<less\>2<rsup|14>>>|<row|<cell|j<rsub|4><rsup|7>*\<ldots\>*j<rsub|4><rsup|0>*j<rsub|3><rsup|7>*\<ldots\>*j<rsub|1><rsup|7>*\<ldots\>*j<rsup|2><rsub|1>>|<cell|>|<cell|2<rsup|14>\<leqslant\>n\<less\>2<rsup|30>>>|<row|<cell|k<rsub|2>+k<rsub|3>*2<rsup|8>+k<rsub|4>*2<rsup|2*\<cdummy\>*8>+\<cdots\>+k<rsub|m>*2<rsup|<around|(|m-2|)>*8>>|<cell|>|<cell|2<rsup|30>\<leqslant\>n>>>>>|}>\<assign\>n
    </equation*>

    where:

    <\equation*>
      k<rsup|7><rsub|1>*\<ldots\>*k<rsup|3><rsub|1>*k<rsup|2><rsub|1>:=m-4
    </equation*>
  </definition>

  <\definition>
    The <strong|SCALE codec> for <strong|Tuple> <math|T> such that:

    <\equation*>
      T\<assign\><around|(|A<rsub|1>,\<ldots\>,A<rsub|n>|)>
    </equation*>

    Where <math|A<rsub|i>>'s are values of different types, is defined as:

    <\equation*>
      Enc<rsub|SC><around|(|T|)>\<assign\>Enc<rsub|SC><around|(|A<rsub|1>|)>\|Enc<rsub|SC><around|(|A<rsub|2>|)><around|\||\<ldots\>|\|>*Enc<rsub|SC><around|(|A<rsub|n>|)>
    </equation*>
  </definition>

  In case of a tuple (or struct), the knowledge of the shape of data is
  necessary for decoding.

  <subsection|Hex Encoding>

  Practically, it is more convenient and efficient to store and process data
  which is stored in a byte array. On the other hand, the Trie keys are
  broken into 4-bits nibbles. Accordingly, we need a method to encode
  sequences of 4-bits nibbles into byte arrays canonically:

  <\definition>
    <label|def-hpe>Suppose that <math|PK=<around|(|k<rsub|1>,\<ldots\>,k<rsub|n>|)>>
    is a sequence of nibbles, then

    <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|<math|Enc<rsub|HE><around|(|PK|)>\<assign\>>>>|<row|<cell|<math|<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|Nibbles<rsub|4>>|<cell|\<rightarrow\>>|<cell|\<bbb-B\>>>|<row|<cell|PK=<around|(|k<rsub|1>,\<ldots\>,k<rsub|n>|)>>|<cell|\<mapsto\>>|<cell|<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<table|<row|<cell|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|2|2|cell-rborder|0ln>|<table|<row|<cell|<around|(|0,k<rsub|1>+16*k<rsub|2>,\<ldots\>,k<rsub|2*i-1>+16*k<rsub|2*i>|)>>|<cell|n=2*i>>|<row|<cell|<around|(|k<rsub|1>,k<rsub|2>+16*k<rsub|3>,\<ldots\>,k<rsub|2*i>+16*k<rsub|2*i+1>|)>>|<cell|n=2*i+1>>>>>>>>>>|\<nobracket\>>>>>>>|\<nobracket\>>>>>>>>
  </definition>

  <subsection|Partial Key Encoding>

  <\definition>
    <label|def-key-len-enc>Let <math|N> be a leaf or an extension node in the
    storage state trie with Partial Key <math|PK<rsub|N>>. We define the
    <strong|Partial key length encoding> function, formally referred to as
    <math|Enc<rsub|len><around|(|N|)>,> as follows:

    <\equation*>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|2|2|cell-rborder|0ln>|<table|<row|<cell|Enc<rsub|len><around|(|N|)>>|<cell|\<assign\>>>|<row|<cell|NodePrefix<around|(|N|)>>|<cell|+>>|<row|<cell|<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|<around|(|<around|\<\|\|\>|PK<rsub|N>|\<\|\|\>>|)>>|<cell|>|<cell|<around|\<\|\|\>|PK<rsub|N>|\<\|\|\>>\<less\>BigKeySize<around*|(|NodeType<around*|(|N|)>|)>>>|<row|<cell|<around|(|127|)><around|\|||\|><around|(|<around|\<\|\|\>|PK<rsub|N>|\<\|\|\>>-BigKeySize<around*|(|NodeType<around*|(|N|)>|)>|)>>|<cell|>|<cell|<around|\<\|\|\>|PK<rsub|N>|\<\|\|\>>\<geqslant\>BigKeySize<around*|(|NodeType<around*|(|N|)>|)>>>>>>|\<nobracket\>>>|<cell|>>>>>
    </equation*>

    where <math|NodePrefix>, <math|NodeType> and <math|BigKeySize> functions
    are defined in Definitions <reference|def-node-prefix>,<reference|defn-nodetype>
    and <reference|defn-bigkeysize> respectively.
  </definition>

  <\definition>
    <label|defn-bigkeysize>We define <math|BigKeySize> function for each node
    type of the Trie as follows: \ 

    <\equation*>
      <tabular|<tformat|<table|<row|<cell|BigKeySize<around*|(|T|)>>|<cell|:>|<cell|<around*|{|Leaf,Extension|}>>|<cell|\<rightarrow\>>|<cell|\<bbb-N\>>>|<row|<cell|>|<cell|>|<cell|T>|<cell|\<mapsto\>>|<cell|<around*|{|<tabular|<tformat|<table|<row|<cell|126>|<cell|T=Leaf>>|<row|<cell|125>|<cell|T=Extension>>>>>|\<nobracket\>>>>>>>
    </equation*>
  </definition>

  <section|Genesis Block Specification><label|sect-genisis-block>

  <section|Predefined Storage keys><label|sect-predef-storage-keys>

  <section|Runtime upgrade><label|sect-runtime-upgrade>

  <appendix|Runtime API<label|sect-runtime-api>>

  Runtime API is a set of functions that Polkadot RE exposes to Runtime to
  access external functions needed for various reasons, such as Storage of
  content, access and manipulation, memory allocation, and also efficiency.
  The functions are specified in each subsequent subsection for each category
  of those functions.

  <subsection|Storage>

  <subsubsection|<verbatim|ext_set_storage>>

  Sets the value of a specific key in the state storage.

  <strong|Prototype:>

  <\verbatim>
    (func $ext_storage

    \ \ (param $key_data i32) (param $key_len i32) (param $value_data i32)
    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (param $value_len
    i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key>: a pointer indicating the buffer containing the key.

    <item><verbatim|key_len>: the key length in bytes.

    <item><verbatim|value>: a pointer indicating the buffer containing the
    value to be stored under the key.

    <item><verbatim|value_len>: \ the length of the value buffer in bytes.
  </itemize>

  <subsubsection|<verbatim|ext_storage_root>>

  Retrieves the root of the state storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_storage_root

    \ \ (param $result_ptr i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|result_ptr>: a memory address pointing at a byte array
    which contains the root of the state storage after the function
    concludes.
  </itemize>

  <subsubsection|<verbatim|ext_blake2_256_enumerated_trie_root>>

  Given an array of byte arrays, arranges them in a Merkle trie, defined
  in<verbatim|<em|<strong|>>> Section <reference|sect-merkl-proof>, and
  computes the trie root hash.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_blake2_256_enumerated_trie_root

    \ \ \ \ \ \ (param $values_data i32) (param $lens_data i32) (param
    $lens_len i32)\ 

    \ \ \ \ \ \ (param $result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|values_data>: a memory address pointing at the buffer
    containing the array where byte arrays are stored consecutively.

    <item><verbatim|lens_data>: an array of <verbatim|i32> elements each
    stores the length of each byte array stored in <verbatim|value_data>.

    <item><verbatim|len>s_len: the number of <verbatim|i32> elements in
    <verbatim|lens_data>.

    <item><verbatim|result>: a memory address pointing at the beginning of a
    32-byte byte array containing the root of the Merkle trie corresponding
    to elements of <verbatim|values_data>.
  </itemize>

  <subsubsection|<verbatim|ext_clear_prefix>>

  Given a byte array, this function removes all storage entries whose key
  matches the prefix specified in the array.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_clear_prefix

    \ \ \ \ \ \ (param $prefix_data i32) (param $prefix_len i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|prefix_data>: a memory address pointing at the buffer
    containing the byte array containing the prefix.

    <item><verbatim|prefix_len>: the length of the byte array in number of
    bytes.
  </itemize>

  <subsubsection|<verbatim|><verbatim|ext_clear_storage>>

  Given a byte array, this function removes the storage entry whose key is
  specified in the array.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_clear_storage

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key_data>: a memory address pointing at the buffer
    containing the byte array containing the key value.

    <item><verbatim|key_len>: the length of the byte array in number of
    bytes.
  </itemize>

  <\subsubsection>
    <verbatim|ext_exists_storage>
  </subsubsection>

  Given a byte array, this function checks if the storage entry corresponding
  to the key specified in the array exists.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_exists_storage

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32) (result i32)

    \ \ \ \ )
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key_data>: a memory address pointing at the buffer
    containing the byte array containing the key value.

    <item><verbatim|key_len>: the length of the byte array in number of
    bytes.

    <item><verbatim|result>: An <verbatim|i32> integer which is equal to 1
    verifies if an entry with the given key exists in the storage or 0 if the
    key storage does not contain an entry with the given key.
  </itemize>

  <subsubsection|<verbatim|ext_get_allocated_storage>>

  Given a byte array, this function allocates a large enough buffer in the
  memory and retrieves the value stored under the key that is specified in
  the array. Then, it stores it in the allocated buffer if the entry exists
  in the storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $get_allocated_storage

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32) (param
    $written_out i32) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key_data>: a memory address pointing at the buffer
    containing the byte array containing the key value.

    <item><verbatim|key_len>: the length of the byte array in number of
    bytes.

    <item><verbatim|written_out>: the function stores the length of the
    retrieved value in number of bytes if the enty exists. If the entry does
    not exist, it returns <math|2<rsup|32>-1>.

    <item><verbatim|result>: A pointer to the buffer in which the function
    allocates and stores the value corresponding to the given key if such an
    entry exist; otherwise it is equal to 0.
  </itemize>

  <subsubsection|<verbatim|ext_get_storage_into>>

  Given a byte array, this function retrieves the value stored under the key
  specified in the array and stores a specified chunk of it in the provided
  buffer, if the entry exists in the storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $ext_get_storage_into\ 

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32) (param $value_data
    i32)

    \ \ \ \ \ \ (param $value_len i32) (param $value_offset i32) (result
    i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key_data>: a memory address pointing at the buffer
    containing the byte array containing the key value.

    <item><verbatim|key_len>: the length of the byte array in number of
    bytes.

    <item><verbatim|value_data>: a pointer to the buffer in which the
    function stores the chunk of the value it retrieves.

    <item><verbatim|value_len>: the (maximum) length of the chunk in bytes
    the function will read of the value and will store in the
    <verbatim|value_data> buffer.

    <item><verbatim|value_offset>: the offset of the chunk where the function
    should start storing the value in the provided buffer, i.e. the number of
    bytes the functions should skip from the retrieved value before storing
    the data in the <verbatim|value_data> in number of bytes.

    <item><verbatim|result>: The number of bytes the function writes in
    <verbatim|value_data> if the value exists or <math|2<rsup|32>-1> if the
    entry does not exist under the specified key.
  </itemize>

  <subsubsection|To be Specced>

  <\itemize>
    <item><verbatim|ext_clear_child_storage>

    <item><verbatim|ext_exists_child_storage>

    <item><verbatim|ext_get_allocated_child_storage>

    <item><verbatim|ext_get_child_storage_into>

    <item><verbatim|ext_get_storage_into>

    <item><verbatim|ext_kill_child_storage>

    <item><verbatim|ext_set_child_storage>

    <item><verbatim|ext_storage_changes_root>

    <item><verbatim|ext_storage_root>
  </itemize>

  <subsection|Memory>

  <subsubsection|<verbatim|ext_malloc>>

  Allocates memory of a requested size in the heap.

  \;

  <strong|Prototype>:

  <\verbatim>
    (func $ext_malloc

    \ \ (param $size i32) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|size:> the size of the buffer to be allocated in number
    of bytes.\ 
  </itemize>

  \;

  <strong|Result>:

  <\itemize>
    a memory address pointing at the beginning of the allocated buffer.
  </itemize>

  <subsubsection|<verbatim|ext_free>>

  Deallocates a previously allocated memory.

  \;

  <strong|Prototype>:

  <\verbatim>
    (func $ext_free

    \ \ \ \ \ \ (param $addr i32))
  </verbatim>

  \;

  <\strong>
    Arguments:
  </strong>

  <\itemize>
    <item><verbatim|addr>: a 32bit memory address pointing at the allocated
    memory.
  </itemize>

  <subsubsection|Input/Output>

  <\itemize>
    <item><verbatim|ext_print_hex>

    <item><verbatim|ext_print_num>

    <item><verbatim|ext_print_utf8>
  </itemize>

  <subsection|Cryptograhpic auxilary functions>

  <subsubsection|ext_blake2_256>

  Computes the Blake2s hash of a given byte array.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func (export "ext_blake2_256")

    \ \ \ \ \ \ (param $data i32) (param \ $len i32) (param $out i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a memory address pointing at the buffer and
    containing the byte array to be hashed.

    <item><verbatim|len>: the length of the byte array in bytes.

    <item><verbatim|out>: a memory address pointing at the beginning of a
    32-byte byte array contanining the Blake2s hash of the data.
  </itemize>

  <subsubsection|<verbatim|ext_ed25519_verify>>

  Given a message signed by the ED25519 signature algorithm alongside with
  its signature and the allegedly signer public key, it verifies the validity
  of the signature by the provided public key.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_ed25519_verify

    \ \ \ \ \ \ (param $msg_data i32) (param $msg_len i32) (param $sig_data
    i32)

    \ \ \ \ \ \ (param $pubkey_data i32) (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|msg_data>: a pointer to the buffer containing the message
    body.

    <item><verbatim|msg_len>: an <verbatim|i32> integer indicating the size
    of the message buffer in bytes.

    <item><verbatim|sig_data>: a pointer to the 64 byte memory buffer
    containing the ED25519 signature corresponding to the message.

    <item><verbatim|pubkey_data>: a pointer to the 32 byte buffer containing
    the public key and corresponding to the secret key which has signed the
    message.

    <item><verbatim|result>: \ an integer value equal to 0 indicating the
    validity of the signature or a nonzero value otherwise.
  </itemize>

  <subsubsection|To be Specced>

  <\itemize>
    <item><verbatim|ext_twox_128>

    <item><verbatim|ext_twox_256>

    \;
  </itemize>

  <subsection|Sandboxing>

  <subsubsection|To be Specced>

  <\itemize>
    <item><verbatim|ext_sandbox_instance_teardown>

    <item><verbatim|ext_sandbox_instantiate>

    <item><verbatim|ext_sandbox_invoke>

    <item><verbatim|ext_sandbox_memory_get>

    <item><verbatim|ext_sandbox_memory_new>

    <item><verbatim|ext_sandbox_memory_set>

    <item><verbatim|ext_sandbox_memory_teardown>

    \;
  </itemize>

  <subsubsection|Misc>

  <subsubsection|To be Specced>\ 

  <\itemize-dot>
    <item><verbatim|ext_chain_id>
  </itemize-dot>

  <verbatim|><subsection|Not implemented in Polkadot-JS>

  <\bibliography|bib|alpha|plkadot_re_spec>
    <\bib-list|DGKR18>
      <bibitem*|Ali19><label|bib-alistair_stewart_grandpa:_2019>Alistair
      Stewart. <newblock>GRANDPA: A Byzantine Finality Gadgets, 2019.

      <bibitem*|DGKR18><label|bib-david_ouroboros_2018>Bernardo David, Peter
      Gaºi, Aggelos Kiayias, and Alexander Russell. <newblock>Ouroboros
      praos: An adaptively-secure, semi-synchronous proof-of-stake
      blockchain. <newblock>In <with|font-shape|italic|Annual International
      Conference on the Theory and Applications of Cryptographic Techniques>,
      pages 66\U98. Springer, 2018.

      <bibitem*|Gro19><label|bib-w3f_research_group_blind_2019>W3F<nbsp>Research
      Group. <newblock>Blind Assignment for Blockchain Extension.
      <newblock>Technical Specification, Web 3.0 Foundation,
      http://research.web3.foundation/en/latest/polkadot/BABE/Babe/, 2019.
    </bib-list>
  </bibliography>
</body>

<\initial>
  <\collection>
    <associate|page-height|auto>
    <associate|page-medium|papyrus>
    <associate|page-screen-margin|true>
    <associate|page-screen-right|5mm>
    <associate|page-type|letter>
    <associate|page-width|auto>
    <associate|tex-even-side-margin|5mm>
    <associate|tex-odd-side-margin|5mm>
    <associate|tex-text-width|170mm>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|alg-grandpa-best-candidate|<tuple|5|13>>
    <associate|alg-grandpa-round|<tuple|4|13>>
    <associate|alg-join-leave-grandpa|<tuple|3|12>>
    <associate|algo-block-production|<tuple|2|?>>
    <associate|auto-1|<tuple|1|1>>
    <associate|auto-10|<tuple|3.2.1|4>>
    <associate|auto-11|<tuple|3.2.2|4>>
    <associate|auto-12|<tuple|3.2.3|4>>
    <associate|auto-13|<tuple|3.2.4|4>>
    <associate|auto-14|<tuple|3.3|4>>
    <associate|auto-15|<tuple|1|4>>
    <associate|auto-16|<tuple|3.3.1|5>>
    <associate|auto-17|<tuple|1|5>>
    <associate|auto-18|<tuple|3.3.2|5>>
    <associate|auto-19|<tuple|3.3.3|5>>
    <associate|auto-2|<tuple|2|2>>
    <associate|auto-20|<tuple|2|5>>
    <associate|auto-21|<tuple|3.3.4|5>>
    <associate|auto-22|<tuple|3.3.5|5>>
    <associate|auto-23|<tuple|4|5>>
    <associate|auto-24|<tuple|4.1|6>>
    <associate|auto-25|<tuple|4.2|6>>
    <associate|auto-26|<tuple|4.3|6>>
    <associate|auto-27|<tuple|5|7>>
    <associate|auto-28|<tuple|5.1|7>>
    <associate|auto-29|<tuple|5.2|8>>
    <associate|auto-3|<tuple|2.1|2>>
    <associate|auto-30|<tuple|5.3|9>>
    <associate|auto-31|<tuple|5.4|9>>
    <associate|auto-32|<tuple|6|9>>
    <associate|auto-33|<tuple|6.1|9>>
    <associate|auto-34|<tuple|7|10>>
    <associate|auto-35|<tuple|7.1|10>>
    <associate|auto-36|<tuple|7.2|12>>
    <associate|auto-37|<tuple|7.2.1|12>>
    <associate|auto-38|<tuple|7.2.2|13>>
    <associate|auto-39|<tuple|7.2.3|14>>
    <associate|auto-4|<tuple|2.2|3>>
    <associate|auto-40|<tuple|7.3|14>>
    <associate|auto-41|<tuple|7.3.1|14>>
    <associate|auto-42|<tuple|7.3.2|15>>
    <associate|auto-43|<tuple|7.3.3|15>>
    <associate|auto-44|<tuple|7.3.4|15>>
    <associate|auto-45|<tuple|8|15>>
    <associate|auto-46|<tuple|8.1|15>>
    <associate|auto-47|<tuple|8.2|16>>
    <associate|auto-48|<tuple|9|16>>
    <associate|auto-49|<tuple|9.1|16>>
    <associate|auto-5|<tuple|2.3|3>>
    <associate|auto-50|<tuple|9.2|16>>
    <associate|auto-51|<tuple|9.3|17>>
    <associate|auto-52|<tuple|10|17>>
    <associate|auto-53|<tuple|11|17>>
    <associate|auto-54|<tuple|12|17>>
    <associate|auto-55|<tuple|A|18>>
    <associate|auto-56|<tuple|A.1|18>>
    <associate|auto-57|<tuple|A.1.1|18>>
    <associate|auto-58|<tuple|A.1.2|19>>
    <associate|auto-59|<tuple|A.1.3|19>>
    <associate|auto-6|<tuple|2.4|3>>
    <associate|auto-60|<tuple|A.1.4|19>>
    <associate|auto-61|<tuple|A.1.5|19>>
    <associate|auto-62|<tuple|A.1.6|19>>
    <associate|auto-63|<tuple|A.1.7|20>>
    <associate|auto-64|<tuple|A.1.8|20>>
    <associate|auto-65|<tuple|A.1.9|20>>
    <associate|auto-66|<tuple|A.2|20>>
    <associate|auto-67|<tuple|A.2.1|20>>
    <associate|auto-68|<tuple|A.2.2|20>>
    <associate|auto-69|<tuple|A.2.3|20>>
    <associate|auto-7|<tuple|3|3>>
    <associate|auto-70|<tuple|A.3|?>>
    <associate|auto-71|<tuple|A.3.1|?>>
    <associate|auto-72|<tuple|A.3.2|?>>
    <associate|auto-73|<tuple|A.3.3|?>>
    <associate|auto-74|<tuple|A.4|?>>
    <associate|auto-75|<tuple|A.4.1|?>>
    <associate|auto-76|<tuple|A.4.2|?>>
    <associate|auto-77|<tuple|A.4.3|?>>
    <associate|auto-78|<tuple|A.5|?>>
    <associate|auto-79|<tuple|A.5|?>>
    <associate|auto-8|<tuple|3.1|3>>
    <associate|auto-9|<tuple|3.2|4>>
    <associate|bib-alistair_stewart_grandpa:_2019|<tuple|Ali19|20>>
    <associate|bib-david_ouroboros_2018|<tuple|DGKR18|20>>
    <associate|bib-w3f_research_group_blind_2019|<tuple|Gro19|20>>
    <associate|block|<tuple|2.1|2>>
    <associate|def-block-header|<tuple|10|2>>
    <associate|def-block-header-hash|<tuple|11|2>>
    <associate|def-extrinsic-network-message|<tuple|12|5>>
    <associate|def-grandpa-justification|<tuple|40|12>>
    <associate|def-hpe|<tuple|44|15>>
    <associate|def-key-len-enc|<tuple|45|15>>
    <associate|def-node-prefix|<tuple|18|8>>
    <associate|def-path-graph|<tuple|2|1>>
    <associate|def-radix-tree|<tuple|3|1>>
    <associate|def-scale-codec|<tuple|42|14>>
    <associate|def-state-read-write|<tuple|13|6>>
    <associate|def-vote|<tuple|31|10>>
    <associate|defn-account-key|<tuple|21|?>>
    <associate|defn-bigkeysize|<tuple|46|15>>
    <associate|defn-bit-rep|<tuple|6|1>>
    <associate|defn-block-tree|<tuple|22|9>>
    <associate|defn-little-endian|<tuple|7|1>>
    <associate|defn-nodetype|<tuple|16|7>>
    <associate|key-encode-in-trie|<tuple|1|7>>
    <associate|sect-abi-encoding|<tuple|3.2.1|4>>
    <associate|sect-encoding|<tuple|9|14>>
    <associate|sect-entries-into-runtime|<tuple|3|3>>
    <associate|sect-finality|<tuple|7.3|10>>
    <associate|sect-genisis-block|<tuple|10|15>>
    <associate|sect-merkl-proof|<tuple|5.4|8>>
    <associate|sect-predef-storage-keys|<tuple|11|15>>
    <associate|sect-randomness|<tuple|8.1|?>>
    <associate|sect-runtime-api|<tuple|A|15>>
    <associate|sect-runtime-api-auth|<tuple|3.3.2|5>>
    <associate|sect-runtime-entries|<tuple|3.3|4>>
    <associate|sect-runtime-upgrade|<tuple|12|15>>
    <associate|sect-scale-codec|<tuple|9.1|14>>
    <associate|sect-validate-transaction|<tuple|3.3.5|5>>
    <associate|sect-vrf|<tuple|8.2|?>>
    <associate|snippet-runtime-enteries|<tuple|1|4>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      w3f_research_group_blind_2019

      david_ouroboros_2018

      alistair_stewart_grandpa:_2019
    </associate>
    <\associate|figure>
      <tuple|normal|<surround|<hidden-binding|<tuple>|1>||Snippet to export
      entries into tho Wasm runtime module>|<pageref|auto-15>>
    </associate>
    <\associate|table>
      <tuple|normal|<surround|<hidden-binding|<tuple>|1>||Detail of the
      version data type returns from runtime
      <with|font-family|<quote|tt>|language|<quote|verbatim>|version>
      function>|<pageref|auto-17>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|2>||Detail of the data
      execute_block returns after execution>|<pageref|auto-20>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Conventions
      and Definitions> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Block>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <with|par-left|<quote|1tab>|2.1<space|2spc>Block Header
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1tab>|2.2<space|2spc>Justified Block Header
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|2.3<space|2spc>Extrinsics
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1tab>|2.4<space|2spc>Block Format
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Interactions
      with the Runtime> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7><vspace|0.5fn>

      <with|par-left|<quote|1tab>|3.1<space|2spc>Loading the Runtime code
      \ \ \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|3.2<space|2spc>Code Executor
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|2tab>|3.2.1<space|2spc>ABI Encoding between
      Runtime and the Runtime Environment
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|2tab>|3.2.2<space|2spc>Access to Runtime API
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|2tab>|3.2.3<space|2spc>Sending Arguments to
      Runtime \ \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|2tab>|3.2.4<space|2spc>The Return Value from a
      Runtime Entry <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|1tab>|3.3<space|2spc>Entries into Runtime
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|2tab>|3.3.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_version>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|2tab>|3.3.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_authorities>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|2tab>|3.3.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_execute_block>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|2tab>|3.3.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_initialise_block>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|2tab>|3.3.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|TaggedTransactionQueue_validate_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Network
      Interactions> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23><vspace|0.5fn>

      <with|par-left|<quote|1tab>|4.1<space|2spc>Extrinsics Submission
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|1tab>|4.2<space|2spc>Network Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|1tab>|4.3<space|2spc>Block Submission and
      Validation <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>State
      Storage and the Storage Trie> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27><vspace|0.5fn>

      <with|par-left|<quote|1tab>|5.1<space|2spc>Accessing The System Storage
      \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|1tab>|5.2<space|2spc>The General Tree Structure
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|1tab>|5.3<space|2spc>Different node types
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <with|par-left|<quote|1tab>|5.4<space|2spc>The Merkle proof
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|6<space|2spc>Transactions>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32><vspace|0.5fn>

      <with|par-left|<quote|1tab>|6.1<space|2spc>preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|7<space|2spc>Consensus
      Engine> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34><vspace|0.5fn>

      <with|par-left|<quote|1tab>|7.1<space|2spc>Block Tree
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35>>

      <with|par-left|<quote|1tab>|7.2<space|2spc>Block Production
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36>>

      <with|par-left|<quote|2tab>|7.2.1<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37>>

      <with|par-left|<quote|2tab>|7.2.2<space|2spc>Block Production Lottery
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38>>

      <with|par-left|<quote|2tab>|7.2.3<space|2spc>Block Production
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-39>>

      <with|par-left|<quote|1tab>|7.3<space|2spc>Finality
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40>>

      <with|par-left|<quote|2tab>|7.3.1<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41>>

      <with|par-left|<quote|2tab>|7.3.2<space|2spc>Voting Messages
      Specification <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-42>>

      <with|par-left|<quote|2tab>|7.3.3<space|2spc>Initiating the GRANDPA
      State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-43>>

      <with|par-left|<quote|2tab>|7.3.4<space|2spc>Voting Process in Round
      <with|mode|<quote|math>|r> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-44>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|8<space|2spc>Cryptographic
      Algorithms> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-45><vspace|0.5fn>

      <with|par-left|<quote|1tab>|8.1<space|2spc>Randomness
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-46>>

      <with|par-left|<quote|1tab>|8.2<space|2spc>VRF
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-47>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|9<space|2spc>Auxiliary
      Encodings> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-48><vspace|0.5fn>

      <with|par-left|<quote|1tab>|9.1<space|2spc>SCALE Codec
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-49>>

      <with|par-left|<quote|1tab>|9.2<space|2spc>Hex Encoding
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-50>>

      <with|par-left|<quote|1tab>|9.3<space|2spc>Partial Key Encoding
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-51>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|10<space|2spc>Genesis
      Block Specification> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-52><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|11<space|2spc>Predefined
      Storage keys> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-53><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|12<space|2spc>Runtime
      upgrade> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-54><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Runtime API> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-55><vspace|0.5fn>

      <with|par-left|<quote|1tab>|A.1<space|2spc>Storage
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-56>>

      <with|par-left|<quote|2tab>|A.1.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_set_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-57>>

      <with|par-left|<quote|2tab>|A.1.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-58>>

      <with|par-left|<quote|2tab>|A.1.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_blake2_256_enumerated_trie_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-59>>

      <with|par-left|<quote|2tab>|A.1.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_clear_prefix>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-60>>

      <with|par-left|<quote|2tab>|A.1.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_clear_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-61>>

      <with|par-left|<quote|2tab>|A.1.6<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_exists_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-62>>

      <with|par-left|<quote|2tab>|A.1.7<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_allocated_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-63>>

      <with|par-left|<quote|2tab>|A.1.8<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_storage_into>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-64>>

      <with|par-left|<quote|2tab>|A.1.9<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-65>>

      <with|par-left|<quote|1tab>|A.2<space|2spc>Memory
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-66>>

      <with|par-left|<quote|2tab>|A.2.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_malloc>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-67>>

      <with|par-left|<quote|2tab>|A.2.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_free>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-68>>

      <with|par-left|<quote|2tab>|A.2.3<space|2spc>Input/Output
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-69>>

      <with|par-left|<quote|1tab>|A.3<space|2spc>Cryptograhpic auxilary
      functions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-70>>

      <with|par-left|<quote|2tab>|A.3.1<space|2spc>ext_blake2_256
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-71>>

      <with|par-left|<quote|2tab>|A.3.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_ed25519_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-72>>

      <with|par-left|<quote|2tab>|A.3.3<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-73>>

      <with|par-left|<quote|1tab>|A.4<space|2spc>Sandboxing
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-74>>

      <with|par-left|<quote|2tab>|A.4.1<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-75>>

      <with|par-left|<quote|2tab>|A.4.2<space|2spc>Misc
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-76>>

      <with|par-left|<quote|2tab>|A.4.3<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-77>>

      <with|par-left|<quote|1tab>|A.5<space|2spc>Not implemented in
      Polkadot-JS <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-78>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Bibliography>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-79><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>