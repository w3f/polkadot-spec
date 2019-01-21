<TeXmacs|1.99.7>

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
  Specification>>|<doc-date|January 21, 2019>>

  <section|Conventions and Definitions>

  <\definition>
    <strong|Runtime> is the state transition function of the decentralized
    ledger protocol.<verbatim|>
  </definition>

  <\definition>
    <label|def-path-graph>A <strong|path graph> or a <strong|path> of
    <math|n> nodes, formally referred to as <strong|<math|P<rsub|n>>>, is a
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
    We represent the concatination of byte arrays
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

      <item><strong|<samp|extrinsics_root:>> is the root of the Merkle trie,
      whose leaves represent individual extrinsics being validated in this
      block. This element is formally referred to as
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

  Each block also contains a list of extrinsics. Polkadot RE does not specify
  or limit the internal of each extrinsics beside the fact that each
  extrinsics is a blob of encoded data. The <samp|extrinsics_root> should
  correspond to the root of the Merkle trie, whose leaves are made of the
  block extrinsics list.

  <section|Runtime><label|sect-entries-into-runtime>

  Polkadot RE expects to receive the code for the runtime of the chain as a
  compiled WebAssembly (Wasm) Blob. The current runtime is stored in the
  state database under the key represented as a byte array:

  <\equation*>
    b=3*a,63,6*f,64,65
  </equation*>

  which is the byte array of ASCII representation of string \P:code\Q (see
  Section <reference|sect-predef-storage-keys>). For any call to the runtime,
  Polkadot RE makes sure that it has most updated runtime as calls to runtime
  have the ability to change the runtime code.

  The initial runtime code of the chain is embedded as an extrinsics into the
  chain initialization JSON file and is submitted to Polkadot RE (see Section
  <reference|sect-genisis-block>).

  Subsequent calls to the runtime have the ability to call the storage API
  (see Section <reference|sect-runtime-api>) to insert a new Wasm blob into
  runtime storage slot to upgrade the runtime.

  <subsection|Entries into Runtime>

  Polkadot RE assumes that at least the following functions are implemented
  in the Runtime Wasm blob and has been exported as shown in Snippet
  <reference|snippet-runtime-enteries> :

  <assign|figure-text|<macro|Snippet>>

  <\small-figure>
    <\cpp-code>
      (export "version" (func $version))

      (export "authorities" (func $authorities))

      (export "execute_block" (func $execute_block))
    </cpp-code>
  </small-figure|<label|snippet-runtime-enteries>Snippet to export entries
  into tho Wasm runtime module>

  <assign|figure-text|<macro|Figure>>

  The following sections describe the standard based on which Polkadot RE
  communicates with each runtime entry.

  <subsubsection|version>

  This entry receives no argument, it returns the vesion data encoded in ABI
  format described in Section <reference|sect-abi-encoding> containing the
  following data:

  \;

  <\with|par-mode|center>
    <small-table|<tabular|<tformat|<cwith|1|7|1|1|cell-halign|l>|<cwith|1|7|1|1|cell-lborder|0ln>|<cwith|1|7|2|2|cell-halign|l>|<cwith|1|7|3|3|cell-halign|l>|<cwith|1|7|3|3|cell-rborder|0ln>|<cwith|1|7|1|3|cell-valign|c>|<cwith|1|1|1|3|cell-tborder|1ln>|<cwith|1|1|1|3|cell-bborder|1ln>|<cwith|7|7|1|3|cell-bborder|1ln>|<cwith|2|-1|1|1|font-base-size|8>|<cwith|2|-1|2|-1|font-base-size|8>|<table|<row|<cell|Name>|<cell|Type>|<cell|Description>>|<row|<cell|<verbatim|spec_name>>|<cell|String>|<cell|runtime
    identifier>>|<row|<cell|<verbatim|impl_name>>|<cell|String>|<cell|the
    name of the implementation (e.g. C++)>>|<row|<cell|<verbatim|authoring_version>>|<cell|32-bit
    uint>|<cell|the version of the authorship
    interface>>|<row|<cell|<verbatim|spec_version>>|<cell|32-bit
    uint>|<cell|the version of the runtime
    specification>>|<row|<cell|<verbatim|impl_version>>|<cell|32-bit
    uint>|<cell|the version of the runtime
    implementation>>|<row|<cell|<verbatim|apis>>|<cell|ApisVec>|<cell|List of
    supported AP>>>>>|Detail of the version data type returns from runtime
    <verbatim|version> function>
  </with>

  <subsubsection|authorities><label|sect-runtime-api-auth>

  This entry is to report the set of authorities at a given block. It
  receives <verbatim|block_id> as an argument, it returns an array of
  <verbatim|authority_id>'s.

  <subsubsection|execute_block>

  This entry is responsible to execute all extrinsics in the block and
  reporting back the changes into the state storage. It receives the block
  header and the block body as its arguments and it returns a triplet:

  <\with|par-mode|center>
    \;

    <small-table|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|2|-1|1|-1|font-base-size|8>|<table|<row|<cell|Name>|<cell|Type>|<cell|Description>>|<row|<cell|<verbatim|results>>|<cell|Boolean>|<cell|Indicating
    if the execution was su>>|<row|<cell|<verbatim|storage_changes>>|<cell|<todo|???>>|<cell|Contains
    all changes to the state storage>>|<row|<cell|<verbatim|change_updat>>|<cell|<todo|???>>|<cell|>>>>>|Detail
    of the data execute_block returns after execution>
  </with>

  <subsection|Code Executor>

  Polkadot RE provide a Wasm Virtual Machine (VM) to run the runtime. The
  Wasm VM exposes the Polkadot RE API to the Runtime. And execute the Runtime
  as a Wasm module.

  <subsection|ABI Encoding between Runtime and the Runtime
  Enviornment><label|sect-abi-encoding>

  All data exchanged between Polkadot RE and the runtime is encoded using
  SCALE codec described in Section <reference|sect-scale-codec>.

  <section|Network API>

  <subsection|Block Submission and Validation>

  Block validation is the process, by which the client asserts that a block
  is fit to be added to the blockchain. This means that the block is
  consistent with the world state and transitions from the state of the
  system to a new valid state.

  \;

  Blocks can be handed to the Polkadot RE both from the network stack and
  from consensus engine.

  \;

  Both the runtime and the Polkadot RE need to work together to assure block
  validity. This can be accomplished by Polkadot RE invoking
  <verbatim|execute_block> entry into the runtime as a part of the validation
  process.

  \;

  Polkadot RE implements the following procedure to assure the validity of
  the block:

  <\algorithm|<name|Import-and-Validate-Block(<math|B,Just<around|(|B|)>>)>>
    <\algorithmic>
      1<space|1em><name|Verify-Block-Justification><math|<around|(|B,Just<around|(|B|)>|)>>

      2<space|1em>Verify <math|H<rsub|p<around|(|B|)>>\<in\>Blockchain>.

      3<space|1em>State-Changes = Runtime.<name|<math|<around|(|B|)>>>

      4<space|1em><name|Update-World-State>(State-Changes)
    </algorithmic>
  </algorithm>

  <section|State Storage and the Storage Trie>

  For storing the state of the system, Polkadot RE implements a hash table
  storage where the keys are used to access each data entry state. There is
  no limitation neither on the size of the key nor the size of the data
  stored under them, besides the fact that they are byte arrays.

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
  re-arranged and hashed in a <em|radix 16 tree> also known as <em|base-16
  modified Merkle Patricia Tree>, which hereafter we will refer to as the
  <em|<strong|Trie>,> in order to compute the hash of the whole state storage
  consistently and efficiently at any given time.

  As well, a modification has been made in the storing of the nodes' hash in
  the Merkle Tree structure to save space on entries storing small entries.

  Because the Trie is used to compute the <em|state root>, <math|H<rsub|r>>,
  (see Definition <reference|def-block-header>), which is used to
  authenticate the validity of the state database, Polkadot RE follows a
  rigorous encoding algorithm to compute the values stored in the trie nodes
  to ensure that the computed Merkle hash, <math|H<rsub|r>>, matches across
  clients.

  <subsection|The General Tree Structure>

  As the trie is a radix 16 tree, in this sense, each key value identifies a
  unique node in the tree. However, a node in a tree might or might not be
  associated with a key in the storage.

  To identify the node corresponding to a key value, <math|k>, first we need
  to encode <math|k> in a uniform way:

  <\definition>
    The for the purpose labeling the branches of the Trie key <math|k> is
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
      <around|(|b<rsup|1><rsub|i>,b<rsup|2><rsub|i>|)>\<assign\><around|(|b<rsub|1>mod
      16,b<rsub|2>/16|)>
    </equation*>

    , where mod is the remainder and / is the integer division operators.
  </definition>

  By looking at <math|k<rsub|enc>> as a sequence of nibbles, one can walk the
  radix tree to reach the node identifying the storage value of <math|k>.

  <subsection|The Merkle proof><label|sect-merkl-proof>

  To prove the consistency of the state storage across the network and its
  modifications efficiently, the Merkle hash of the storage trie needs to be
  computed rigorously.

  The Merkle hash of the trie is computed recursively. As such, hash value of
  each node depends on the hash value of all its children and also on its
  value. Therefore, it suffices to define how to compute the hash value of a
  typical node as a function of the hash value of its children and its own
  value.

  <\definition>
    Suppose node N of storage state trie has key value <math|k<rsub|N>>, and
    parent key value of <math|k<rsub|P<around|(|N|)>>>, such that:

    <\equation*>
      KeyEncode<around|(|k<rsub|N>|)>=<around|(|k<rsub|enc<rsub|1>>,\<ldots\>,k<rsub|enc<rsub|i-1>>,k<rsub|enc<rsub|i>>,\<ldots\>,k<rsub|enc<rsub|2*n>>|)>
    </equation*>

    and

    <\equation*>
      KeyEncode<around|(|k<rsub|P<around|(|N|)>>|)>=<around|(|k<rsub|enc<rsub|1>>,\<ldots\>,k<rsub|enc<rsub|i-1>>|)>
    </equation*>

    We define

    <\equation*>
      pk<rsub|N>\<assign\><around|(|k<rsub|enc<rsub|i>>,\<ldots\>,k<rsub|enc<rsub|2*n>>|)>
    </equation*>

    to be the <strong|the partial key> of N.
  </definition>

  <\definition>
    <label|def-node-prefix>For a trie node N, <strong|Node Prefix >function
    is a value specifying the node type as follows:

    <\equation*>
      NodePrefix<around|(|N|)>\<assign\><around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|1>|<cell|>|<cell|N<text|is
      a leaf node>>>|<row|<cell|254>|<cell|>|<cell|N<text|is a branch node
      without value>>>|<row|<cell|255>|<cell|>|<cell|N<text|is a branch node
      with value>>>>>>|\<nobracket\>>
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
        Enc<rsub|Node><around|(|N|)>\<assign\>Enc<rsub|len><around|(|N|)><around|\|||\|>*HPE<around|(|pk<rsub|N>|)><around|\|||\|>*Enc<rsub|SC><around|(|v|)>
      </equation*>

      <item>N is a branch node:

      <\equation*>
        <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<table|<row|<cell|<text|Enc<rsub|Node>(N)>\<assign\>>>|<row|<cell|\<nobracket\>NodePrefix<around|(|N|)><around|\|||\|>*ChildrenBitmap<around|(|N|)>\<\|\|\>HPE<rsub|PC><around|(|v|)><around|\|||\|>*Enc<rsub|SC><around|(|Enc<rsub|Node>|)><around|\|||\|>>>|<row|<cell|Enc<rsub|SC><around|(|N<rsub|C<rsub|1>>|)>*\<ldots\>*Enc<rsub|SC><around|(|N<rsub|C<rsub|n>>|)>>>>>>
      </equation*>
    </itemize>
  </definition>

  Where <math|N<rsub|C<rsub|1>>*\<ldots\>*N<rsub|C<rsub|n>>> with
  <math|n\<leqslant\>16> are the children nodes of <math|N>.

  <\definition>
    For a given node <math|N>, the <strong|Merkle value> of <math|N>, denoted
    by <math|H<around|(|N|)>> is defined as follows:

    <\equation*>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|>|<cell|H:\<bbb-B\>\<rightarrow\><big|cup><rsub|i=0<rsup|\<nosymbol\>>><rsup|32>\<bbb-B\><rsub|i>>|<cell|>>|<row|<cell|>|<cell|H<around|(|N|)>:<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|Enc<rsub|Node><around|(|N|)>>|<cell|<around|\<\|\|\>|Enc<rsub|Node><around|(|N|)>|\<\|\|\>>\<less\>32>|<cell|>>|<row|<cell|Hash<around|(|Enc<rsub|Node><around|(|N|)>|)>>|<cell|<around|\<\|\|\>|Enc<rsub|Node><around|(|N|)>|\<\|\|\>>\<geqslant\>32>|<cell|>>>>>|\<nobracket\>>>|<cell|>>>>>
    </equation*>
  </definition>

  <section|Extrinsics trie>

  To validate that the Extrinsics data are stored in a block across clients,
  Polkadot RE uses the same trie structure as for the state storage described
  in Section <reference|sect-merkl-proof> to generate the Merkle proof.

  <section|Consensus Engine>

  Consensus in Polkadot RE is achieved during the execution of two different
  procedures. The first procedure is block production and the second is
  finality. Polkadot RE must run these procedures, if and only if it is
  running on a validator node.

  <subsection|Block Tree>

  In the course of formation of a (distributed) blockchain, it is possible
  that the chain forks into multiple sub chains in various block positions.
  We refer to this structure as a <em|block tree:>

  <\definition>
    The <strong|Block Tree> of a blockchain is the union of all different
    versions of the blockchain observed by all the nodes in the system such
    as every such block is a node in the graph and <math|B<rsub|1>> is
    connected to <math|B<rsub|2>> if <math|B<rsub|1>> is a parent of
    <math|B<rsub|2>>.
  </definition>

  Because every block in the blockchain contains a reference to its parent,
  it is easy to see that the block tree is actually a tree.

  A block tree naturally imposes a partial order relationships on the blocks
  as follows:

  <\definition>
    We say <strong|B is descendant of <math|B<rprime|'>>>, formally noted as
    <strong|<math|B\<gtr\>B<rprime|'>>> if <math|B> is a descendent of
    <math|B<rprime|'>> in the block tree.\ 
  </definition>

  <subsection|Block Production>

  <subsection|Finality>

  Polkadot RE uses GRANDPA Finality protocol <cite|AlSt19-Grandpai> to
  finalize blocks. Finality is obtained by consecutive rounds of voting by
  validator nodes. Validators execute GRANDPA finality process in parallel to
  Block Production as an independent service. In this section, we describe
  the different functions that GRANDPA service is supposed to perform to
  successfully participate in the block finalization process.

  <subsubsection|Priliminaries>

  <\definition>
    A <strong|GRANDPA Voter>, <math|v>, is represented by a key pair
    <math|<around|(|k<rsup|pr><rsub|v>,v<rsub|id>|)>> where
    <math|k<rsub|v><rsup|pr>> represents its private key which is a
    <math|ED25519> private key, is a node running GRANDPA protocol, and
    broadcasts votes to finilize blocks in a Polkadot RE - based chain. The
    <strong|set of all GRANDPA voters> is indicated by <math|\<bbb-V\>>. For
    a given block B, we have

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
    membership, which changes in V.

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
    are block hash and block number defined in Definitions
    <reference|def-block-header> and <reference|def-block-header-hash>
    respectively.
  </definition>

  <\definition>
    Voters engage in a maximum two sub-rounds of voting for each round
    <math|r>. The first sub-round is called <strong|pre-vote> and the second
    sub-round is called <strong|pre-commit>.

    By <strong|<math|V<rsub|v><rsup|r,pv>>> and
    <strong|<math|V<rsub|v><rsup|r,pc>>> we refer to the vote casted by voter
    <math|v> in round <math|r> (for block <math|B>) during the pre-vote and
    the pre-commit sub-round respectively.
  </definition>

  The GRANDPA protocol dictates how an honest voter should vote in each
  sub-round, which is described in Algorithm <reference|alg-grandpa-round>.
  After defining what consititues a vote in GRANDPA, we define how GRANDPA
  counts votes.

  <\definition>
    Voter <math|v> <strong|equivocates> if they broadcast two or more valid
    votes to blocks not residing on the same branch of the block tree during
    one voting sub-round. In such a situation, we say that <math|v> is an
    <strong|equivocator> and any vote <math|V<rsub|v><rsup|r,stage><around*|(|B|)>>
    casted by <math|v> in that round is an <strong|equivocatory vote> and

    <\equation*>
      \<cal-E\><rsup|r,stage>
    </equation*>

    \ represents the set of all equivocators voters in sub-round
    \P<math|stage>\Q of round <math|r>. When we want to refer to the number
    of equivocators whose equivocation has been observed by voter <math|v> we
    refer to it by:

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

        <item><math|B> is not an (eventual) descendent of a previously
        finalized block;

        <item><math|M<rsup|r,stage><rsub|v>> does not bear a valid signature;

        <item><math|id<rsub|\<bbb-V\>>> does not match the current
        <math|\<bbb-V\>>;

        <item>If <math|V<rsub|v><rsup|r,stage>> is an equivacatory vote.
      </itemize-dot>
    </itemize>
  </definition>

  <\definition>
    For validator v, <strong|the set of observed direct votes for Block
    <math|B> in round <math|r>>, formally denoted by
    <math|VD<rsup|r,stage><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>><around|(|B|)>>
    is equal to the union of:

    <\itemize-dot>
      <item>set of valid votes <math|V<rsup|r,stage><rsub|v<rsub|i>>> casted
      in round <math|r> and received by v such that
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

  <\definition>
    We say that round <math|r> is <strong|unfinalizable,> if for all
    <math|B<rprime|'>\<geqslant\>B<rsub|v><rsup|r,pv>>:

    <\equation*>
      <around|\||V<rsup|r,pc><rsub|obs<around|(|v|)>>|\|>-<around|\||V<rsup|r,pc><rsub|obs<around|(|v|)><rsub|\<nosymbol\>>><around|(|B<rprime|'>|)>|\|>\<geqslant\><frac|1|3><around|\||\<bbb-V\>|\|>
    </equation*>
  </definition>

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

  The <strong|justification for block B in round <math|r>> of GRANDPA
  protocol defined <math|J<rsup|r><around*|(|B|)>> is a vector of pairs of
  the type:

  <\equation*>
    <around*|(|V<around*|(|B<rprime|'>|)>,<around*|(|Sign<rsup|r,pc><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>,v<rsub|id>|)>|)>
  </equation*>

  in which either

  <\equation*>
    B<rprime|'>\<gtr\>B
  </equation*>

  or <math|V<rsup|r,pc><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>> is an
  equivocatory vote.

  In all cases <math|Sign<rsup|r,pc><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>>
  is the signature of voter <math|v<rsub|i>> broadcasted during the
  pre-commit sub-round of round r.

  <\definition>
    <strong|<math|GRANDPA> finalizing message for block <math|B> in round
    <math|r>> represented as <strong|<math|M<rsub|v><rsup|r,Fin>>(B)> is a
    message broadcasted by voter <math|v> to the network indicating that
    voter <math|v> has finalized block <math|B> in round <math|r>. It has the
    following structure:

    <\equation*>
      M<rsup|r,stage><rsub|v>\<assign\>Enc<rsub|SC><around|(|r,<around|\<nobracket\>|V<around*|(|B|)>,J<rsup|r><around*|(|B|)>|)>|\<nobracket\>>
    </equation*>
  </definition>

  <subsubsection|Initiating the GRANDPA State>

  A validator needs to initiate its state and sync it with other validators,
  to be able to participate coherently in the voting process. In particular,
  considering that voting is happening in different rounds and each round of
  voting is assigned a unique sequential round number <math|r<rsub|v>>, it
  needs to determine and set its round counter <math|r> in accordance with
  the current voting round <math|r<rsub|n>>, which is currently undergoing in
  the network.

  As instructed in Algortihm <reference|alg-join-leave-grandpa>, whenever the
  membership of GRANDPA voters changes, <math|r> is set to 0 and
  <math|V<rsub|id>> needs to be incremented.

  \;

  <\algorithm>
    <label|alg-join-leave-grandpa><name|Join-Leave-Grandpa-Voters>
    (<math|\<cal-V\>>)
  <|algorithm>
    <\algorithmic>
      1<space|1em><math|r\<leftarrow\>0>

      2<space|1em><math|\<cal-V\><rsub|id>\<leftarrow\>ReadState<around|(|<rprime|'>AUTHORITY_SET_KEY<rprime|'>|)>>

      3<space|1em><math|\<cal-V\><rsub|id>\<leftarrow\>\<cal-V\><rsub|id>+1>

      2<space|1em><name|Execute-One-Grandpa-Round><math|<around|(|r|)>>
    </algorithmic>
  </algorithm>

  Each voter should run Algorithm <reference|alg-completable-round> to verify
  that a round is completable.

  <subsubsection|Voting Process in Round <math|r>>

  For each round <math|r>, an honest voter <math|v> must participate in the
  voting process by following Algorithm <reference|alg-grandpa-round>.

  <\algorithm|<label|alg-grandpa-round><name|Play-Grandpa-round><math|<around|(|r|)>>>
    <\algorithmic>
      1<space|1em><math|t<rsub|r,v>\<leftarrow\>>Time

      2<space|1em><math|primary\<leftarrow\>><name|Derive-Primary>

      4<space|1em><strong|if> <math|v=primary>:

      5<space|2em><name|Broadcast(><left|.><math|M<rsub|v<rsub|\<nosymbol\>>><rsup|r-1,fin>>()<right|)>

      6<space|1em><strong|else>

      9<space|1em><name|<space|1em>Receive-Messages>(<strong|until> Time
      <math|\<geqslant\>t<rsub|r<rsub|,>*v>+2\<times\>T> <strong|or>

      <space|3em> <name|Completable>(<math|r>))

      10<space|2em><math|L\<leftarrow\>><name|Received-as-Final()>
      <strong|or> <name|Best-Final-Candidate>(

      <space|3em><math|r>-1):

      11<space|2em><strong|if> <name|Received(<math|M<rsub|v<rsub|primary>><rsup|r,pv><around|(|B|)>>)>
      <strong|and> <math|B<rsup|r,pv><rsub|v>\<geqslant\>B\<gtr\>L>:

      12<space|1em><space|2em><math|N\<leftarrow\>B>

      13<space|2em><strong|else>

      14<space|3em><math|N\<leftarrow\>B<rprime|'>:H<rsub|n><around|(|B<rprime|'>|)>=max
      <around|{|H<rsub|n><around|(|B<rprime|'>|)>:B<rprime|'>\<gtr\>L|}>>

      15<space|1em><name|Broadcast>(<math|M<rsub|v><rsup|r,pv><around|(|N|)>>)

      16<space|1em><name|Receive-Messages>(<strong|until>
      <math|B<rsup|r,pv<rsub|\<nosymbol\>>><rsub|v>\<geqslant\>L>
      <strong|and> (

      <space|3em>Time <math|\<geqslant\>t<rsub|r<rsub|,>*v>+4\<times\>T><strong|
      or ><name|Completable>(<math|r>)))

      12<space|1em><name|Broadcast(<math|M<rsub|v><rsup|r,pc>>(Best-Final-Candidate(<math|r>))>

      13<space|1em><name|Play-Grandpa-round>(<math|r+1>)
    </algorithmic>
  </algorithm>

  <\algorithm|<label|alg-grandpa-best-candidate><name|Best-Final-Candidate>(<math|r>)>
    <\algorithmic>
      1<space|1em><math|\<cal-C\><rsub|\<nosymbol\>>\<leftarrow\><around|{|B<rprime|'>\|B<rprime|'>\<leqslant\>B<rsub|v><rsup|r,pv>:<around|\||V<rsub|v><rsup|r,pc>|\|>-#V<rsub|v><rsup|r,pc><around|(|B<rprime|'>|)>\<leqslant\>1/3<around|\||\<bbb-V\>|\|>|}>>

      2<space|1em><strong|if> <math|\<cal-C\>=\<phi\>>:

      3<space|2em><strong|return> <math|\<phi\>>

      4<space|1em><strong|else>

      5<space|2em><strong|return ><math|E\<in\>\<cal-C\>:H<rsub|n><around*|(|E|)>=max
      <around|{|H<rsub|n><around|(|B<rprime|'>|)>:B<rprime|'>\<in\>\<cal-C\>|}>>
    </algorithmic>
  </algorithm>

  <\algorithm|<label|alg-completable-round><name|Completable>(<math|r>)>
    <\algorithmic>
      1<space|1em><math|E\<leftarrow\>><name|Best-Final-Candidate>(<math|r>)

      1<space|1em><strong|if> <math|E\<neq\>\<phi\>>

      2<space|2em><strong|return> <name|True>

      3<space|1em><strong|elif> <math|r> <strong|is> unfinalizable:

      4<space|2em><strong|return> <name|True>

      5<space|1em><strong|else>

      6<space|2em><strong|return> <name|False>
    </algorithmic>
  </algorithm>

  <\algorithm|<name|FinalizeRound>(<math|r>)>
    <\algorithmic>
      1<space|1em><math|L\<leftarrow\>><name|Last-Finalized-Block>

      2<space|1em><math|E\<leftarrow\>><name|Best-Final-Candidate>(<math|r>)

      2<space|1em><strong|if> <math|E\<geqslant\>L> <strong|and>
      <math|V<rsup|r-1,pc><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>><around|(|E|)>\<gtr\>2/3<around|\||\<cal-V\>|\|>>

      3<space|2em><name|Last-Finalized-Block><math|\<leftarrow\>B<rsup|r,pc>>

      4<space|2em><strong|if> <math|M<rsub|v><rsup|r,Fin><around|(|E|)>\<nin\>><name|Received-Messages>:

      5<space|3em><name|Broadcast>(<math|M<rsub|v><rsup|r,Fin><around|(|E|)>>)
    </algorithmic>
  </algorithm>

  <section|Auxilary Encodings>

  <subsection|SCALE Codec><label|sect-scale-codec>

  Polkadot RE uses <em|Simple Concatenated Aggregate Little-Endian\Q (SCALE)
  codec> to encode byte arrays that provide canonical encoding and to produce
  consistent hash values across their implementation, including the Merkle
  hash proof for the State Storage.

  <\definition>
    The <strong|SCALE codec> for <strong|Byte array> <math|A> such that

    <\equation*>
      A\<assign\>b<rsub|1>*b<rsub|2>*\<ldots\>*b<rsub|n>
    </equation*>

    such that <math|n\<less\>2<rsup|536>> is a byte array refered to
    <math|Enc<rsub|SC><around|(|A|)>> and defined as follows:

    <\equation*>
      Enc<rsub|SC><around|(|A|)>\<assign\><around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|l<rsup|\<nosymbol\>><rsub|1>*b<rsub|1>*b<rsub|2>*\<ldots\>*b<rsub|n>>|<cell|>|<cell|0\<leqslant\>n\<less\>2<rsup|6>>>|<row|<cell|i<rsup|\<nosymbol\>><rsub|1>*i<rsup|\<nosymbol\>><rsub|2>*b<rsub|1>*\<ldots\>*b<rsub|n>>|<cell|>|<cell|2<rsup|6>\<leqslant\>n\<less\>2<rsup|14>>>|<row|<cell|j<rsup|\<nosymbol\>><rsub|1>*j<rsup|\<nosymbol\>><rsub|2>*j<rsub|3>*b<rsub|1>*\<ldots\>*b<rsub|n>>|<cell|>|<cell|2<rsup|14>\<leqslant\>n\<less\>2<rsup|30>>>|<row|<cell|k<rsub|1><rsup|\<nosymbol\>>*k<rsub|2><rsup|\<nosymbol\>>*\<ldots\>*k<rsub|m><rsup|\<nosymbol\>>*b<rsub|1>*\<ldots\>*b<rsub|n>>|<cell|>|<cell|2<rsup|14>\<leqslant\>n>>>>>|\<nobracket\>>
    </equation*>

    in which:<space|0.17em>

    <\equation*>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-lborder|1ln>|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-rborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-bborder|1ln>|<cwith|3|3|1|-1|cell-bborder|1ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<table|<row|<cell|l<rsup|1><rsub|1>*l<rsub|1><rsup|0>=00>>|<row|<cell|i<rsup|1><rsub|1>*i<rsub|1><rsup|0>=01>>|<row|<cell|j<rsup|1><rsub|1>*j<rsub|1><rsup|0>=10>>|<row|<cell|k<rsup|1><rsub|1>*k<rsub|1><rsup|0>=11>>>>>
    </equation*>

    and n is stored in <math|Enc<rsub|SC><around|(|A|)>> in little-endian
    format in base-2 as follows:

    <\equation*>
      n=<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|l<rsup|7><rsub|1>*\<ldots\>*l<rsup|3><rsub|1>*l<rsup|2><rsub|1>>|<cell|>|<cell|n\<less\>2<rsup|6>>>|<row|<cell|i<rsub|2><rsup|7>*\<ldots\>*i<rsub|2><rsup|0>*i<rsub|1><rsup|7>*\<ldots\>*i<rsup|2><rsub|1><rsup|\<nosymbol\>>>|<cell|>|<cell|2<rsup|6>\<leqslant\>n\<less\>2<rsup|14>>>|<row|<cell|j<rsub|4><rsup|7>*\<ldots\>*j<rsub|4><rsup|0>*j<rsub|3><rsup|7>*\<ldots\>*j<rsub|1><rsup|7>*\<ldots\>*j<rsup|2><rsub|1>>|<cell|>|<cell|2<rsup|14>\<leqslant\>n\<less\>2<rsup|30>>>|<row|<cell|k<rsub|2>+k<rsub|3>*2<rsup|8>+k<rsub|4>*2<rsup|2*\<cdummy\>*8>+\<cdots\>+k<rsub|m>*2<rsup|<around|(|m-2|)>*8>>|<cell|>|<cell|2<rsup|30>\<leqslant\>n>>>>>|\<nobracket\>>
    </equation*>

    where:

    <\equation*>
      m=l<rsup|7><rsub|1>*\<ldots\>*l<rsup|3><rsub|1>*l<rsup|2><rsub|1>+4
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

  <subsection|Hex Encoding>

  Practically, it is more convenient and efficient to store and process data
  which is stored in a byte array. On the other hand, radix-16 tree keys are
  broken in 4-bits nibbles. Accordingly, we need a method to encode sequences
  of 4-bits nibbles into byte arrays canonically:

  <\definition>
    <label|def-hpe>Suppose that <math|PK=<around|(|k<rsub|1>,\<ldots\>,k<rsub|n>|)>>
    is a sequence of nibbles, then

    <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|<math|Enc<rsub|HE><around|(|PK|)>\<assign\>>>>|<row|<cell|<math|<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|Nibbles<rsub|4>>|<cell|\<rightarrow\>>|<cell|\<bbb-B\>>>|<row|<cell|PK=<around|(|k<rsub|1>,\<ldots\>,k<rsub|n>|)>>|<cell|\<mapsto\>>|<cell|<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<table|<row|<cell|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|2|2|cell-rborder|0ln>|<table|<row|<cell|<around|(|0,k<rsub|1>+16*k<rsub|2>,\<ldots\>,k<rsub|2*i-1>+16*k<rsub|2*i>|)>>|<cell|n=2*i>>|<row|<cell|<around|(|k<rsub|1>,k<rsub|2>+16*k<rsub|3>,\<ldots\>,k<rsub|2*i>+16*k<rsub|2*i+1>|)>>|<cell|n=2*i+1>>>>>>>>>>|\<nobracket\>>>>>>>|\<nobracket\>>>>>>>>
  </definition>

  <subsection|Partial Key Encoding>

  <\definition>
    <label|def-key-len-enc>Let <math|N> be a node in the storage state trie
    with Partial Key <math|PK<rsub|N>>. We define the <strong|Partial key
    length encoding> function, formally referred to as
    <math|Enc<rsub|len><around|(|N|)>> as follows:

    <\equation*>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|2|2|cell-rborder|0ln>|<table|<row|<cell|Enc<rsub|len><around|(|N|)>>|<cell|\<assign\>>>|<row|<cell|NodePrefix<around|(|N|)>>|<cell|+>>|<row|<cell|<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|4|4|cell-halign|l>|<cwith|1|-1|5|5|cell-halign|l>|<cwith|1|-1|5|5|cell-rborder|0ln>|<table|<row|<cell|<around|(|<around|\<\|\|\>|PK<rsub|N>|\<\|\|\>>|)>>|<cell|>|<cell|NisleafNode>|<cell|&>|<cell|<around|\<\|\|\>|PK<rsub|N>|\<\|\|\>>\<less\>127>>|<row|<cell|<around|(|127|)><around|\|||\|><around|(|LE<around|(|<around|\<\|\|\>|PK<rsub|N>|\<\|\|\>>-127|)>|)>>|<cell|>|<cell|NisaleafNode>|<cell|&>|<cell|<around|\<\|\|\>|PK<rsub|N>|\<\|\|\>>\<geqslant\>127>>>>>|\<nobracket\>>>|<cell|>>>>>
    </equation*>

    where <math|NodePrefix> function is defined in Definition
    <reference|def-node-prefix>.
  </definition>

  <section|Genisis Block Specification><label|sect-genisis-block>

  <section|Predefined Storage keys><label|sect-predef-storage-keys>

  <section|Runtime upgrade><label|sect-runtime-upgrade>

  <section|Runtime API><label|sect-runtime-api>

  Runtime API is a set of functions, which Polkadot RE exposes to Runtime to
  access Storage content and other external functions. Some of the functions
  are exposed to the runtime for efficiency reasons. Here is the list of the
  functions which Polkadot RE exposes to the runtime:

  <\itemize-dot>
    <item><verbatim|ext_blake2_256>

    <item><verbatim|ext_blake2_256_enumerated_trie_root>

    <item><verbatim|ext_chain_id>

    <item><verbatim|ext_child_storage_root>

    <item><verbatim|ext_clear_child_storage>

    <item><verbatim|ext_clear_prefix>

    <item><verbatim|ext_clear_storage>

    <item><verbatim|ext_ed25519_verify>

    <item><verbatim|ext_exists_child_storage>

    <item><verbatim|ext_free>

    <item><verbatim|ext_get_allocated_child_storage>

    <item><verbatim|ext_get_allocated_storage>

    <item><verbatim|ext_get_child_storage_into>

    <item><verbatim|ext_get_storage_into>

    <item><verbatim|ext_kill_child_storage>

    <item><verbatim|ext_malloc>

    <item><verbatim|ext_print_hex>

    <item><verbatim|ext_print_num>

    <item><verbatim|ext_print_utf8>

    <item><verbatim|ext_sandbox_instance_teardown>

    <item><verbatim|ext_sandbox_instantiate>

    <item><verbatim|ext_sandbox_invoke>

    <item><verbatim|ext_sandbox_memory_get>

    <item><verbatim|ext_sandbox_memory_new>

    <item><verbatim|ext_sandbox_memory_set>

    <item><verbatim|ext_sandbox_memory_teardown>

    <item><verbatim|ext_set_child_storage>

    <item><verbatim|ext_set_storage>

    <item><verbatim|ext_storage_changes_root>

    <item><verbatim|ext_storage_root>

    <item><verbatim|ext_twox_128>

    <item><verbatim|ext_twox_256>

    <item><verbatim|ext_exists_storage>
  </itemize-dot>
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
    <associate|alg-completable-round|<tuple|5|11>>
    <associate|alg-grandpa-best-candidate|<tuple|4|10>>
    <associate|alg-grandpa-round|<tuple|3|10>>
    <associate|alg-join-leave-grandpa|<tuple|2|10>>
    <associate|auto-1|<tuple|1|1>>
    <associate|auto-10|<tuple|1|3>>
    <associate|auto-11|<tuple|3.1.2|3>>
    <associate|auto-12|<tuple|3.1.3|3>>
    <associate|auto-13|<tuple|2|3>>
    <associate|auto-14|<tuple|3.2|4>>
    <associate|auto-15|<tuple|3.3|4>>
    <associate|auto-16|<tuple|4|4>>
    <associate|auto-17|<tuple|4.1|4>>
    <associate|auto-18|<tuple|5|4>>
    <associate|auto-19|<tuple|5.1|4>>
    <associate|auto-2|<tuple|2|1>>
    <associate|auto-20|<tuple|5.2|5>>
    <associate|auto-21|<tuple|5.3|5>>
    <associate|auto-22|<tuple|6|6>>
    <associate|auto-23|<tuple|7|6>>
    <associate|auto-24|<tuple|7.1|7>>
    <associate|auto-25|<tuple|7.2|7>>
    <associate|auto-26|<tuple|7.3|7>>
    <associate|auto-27|<tuple|7.3.1|7>>
    <associate|auto-28|<tuple|7.3.2|9>>
    <associate|auto-29|<tuple|7.3.3|9>>
    <associate|auto-3|<tuple|2.1|2>>
    <associate|auto-30|<tuple|7.3.4|10>>
    <associate|auto-31|<tuple|8|11>>
    <associate|auto-32|<tuple|8.1|11>>
    <associate|auto-33|<tuple|8.2|12>>
    <associate|auto-34|<tuple|8.3|12>>
    <associate|auto-35|<tuple|9|13>>
    <associate|auto-36|<tuple|10|13>>
    <associate|auto-37|<tuple|11|13>>
    <associate|auto-38|<tuple|12|13>>
    <associate|auto-4|<tuple|2.2|2>>
    <associate|auto-5|<tuple|2.3|2>>
    <associate|auto-6|<tuple|3|2>>
    <associate|auto-7|<tuple|3.1|3>>
    <associate|auto-8|<tuple|1|3>>
    <associate|auto-9|<tuple|3.1.1|3>>
    <associate|block|<tuple|2.1|2>>
    <associate|def-block-header|<tuple|7|2>>
    <associate|def-block-header-hash|<tuple|8|2>>
    <associate|def-hpe|<tuple|31|12>>
    <associate|def-key-len-enc|<tuple|32|12>>
    <associate|def-node-prefix|<tuple|12|6>>
    <associate|def-path-graph|<tuple|2|1>>
    <associate|def-radix-tree|<tuple|3|1>>
    <associate|def-state-read-write|<tuple|9|5>>
    <associate|def-vote|<tuple|19|7>>
    <associate|defn-bit-rep|<tuple|6|1>>
    <associate|key-encode-in-trie|<tuple|1|5>>
    <associate|sect-abi-encoding|<tuple|3.3|4>>
    <associate|sect-entries-into-runtime|<tuple|3|2>>
    <associate|sect-genisis-block|<tuple|9|13>>
    <associate|sect-merkl-proof|<tuple|5.3|5>>
    <associate|sect-predef-storage-keys|<tuple|10|13>>
    <associate|sect-runtime-api|<tuple|12|13>>
    <associate|sect-runtime-api-auth|<tuple|3.1.2|3>>
    <associate|sect-runtime-upgrade|<tuple|11|13>>
    <associate|sect-scale-codec|<tuple|8.1|11>>
    <associate|snippet-runtime-enteries|<tuple|1|3>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      AlSt19-Grandpai
    </associate>
    <\associate|figure>
      <tuple|normal|<surround|<hidden|<tuple>>||Snippet to export entries
      into tho Wasm runtime module>|<pageref|auto-8>>
    </associate>
    <\associate|table>
      <tuple|normal|<surround|<hidden|<tuple>>||Detail of the version data
      type returns from runtime <with|font-family|<quote|tt>|language|<quote|verbatim>|version>
      function>|<pageref|auto-10>>

      <tuple|normal|<surround|<hidden|<tuple>>||Detail of the data
      execute_block returns after execution>|<pageref|auto-13>>
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

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Runtime>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6><vspace|0.5fn>

      <with|par-left|<quote|1tab>|3.1<space|2spc>Entries into Runtime
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|2tab>|3.1.1<space|2spc>version
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|2tab>|3.1.2<space|2spc>authorities
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|2tab>|3.1.3<space|2spc>execute_block
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|3.2<space|2spc>Code Executor
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|1tab>|3.3<space|2spc>ABI Encoding between Runtime
      and the Runtime Enviornment <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Network
      API> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16><vspace|0.5fn>

      <with|par-left|<quote|1tab>|4.1<space|2spc>Block Submission and
      Validation <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>State
      Storage and the Storage Trie> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18><vspace|0.5fn>

      <with|par-left|<quote|1tab>|5.1<space|2spc>Accessing The System Storage
      \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|1tab>|5.2<space|2spc>The General Tree Structure
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|1tab>|5.3<space|2spc>The Merkle proof
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|6<space|2spc>Extrinsics
      trie> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|7<space|2spc>Consensus
      Engine> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23><vspace|0.5fn>

      <with|par-left|<quote|1tab>|7.1<space|2spc>Block Tree
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|1tab>|7.2<space|2spc>Block Production
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|1tab>|7.3<space|2spc>Finality
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|2tab>|7.3.1<space|2spc>Priliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>

      <with|par-left|<quote|2tab>|7.3.2<space|2spc>Voting Messages
      Specification <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|2tab>|7.3.3<space|2spc>Initiating the GRANDPA
      State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|2tab>|7.3.4<space|2spc>Voting Process in Round
      <with|mode|<quote|math>|r> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|8<space|2spc>Auxilary
      Encodings> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31><vspace|0.5fn>

      <with|par-left|<quote|1tab>|8.1<space|2spc>SCALE Codec
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32>>

      <with|par-left|<quote|1tab>|8.2<space|2spc>Hex Encoding
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <with|par-left|<quote|1tab>|8.3<space|2spc>Partial Key Encoding
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|9<space|2spc>Genisis
      Block Specification> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|10<space|2spc>Predefined
      Storage keys> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|11<space|2spc>Runtime
      upgrade> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|12<space|2spc>Runtime
      API> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>