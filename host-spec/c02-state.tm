<TeXmacs|1.99.18>

<project|host-spec.tm>

<style|<tuple|tmbook|algorithmacs-style>>

<\body>
  <chapter|State Specification><label|chap-state-spec>

  <section|State Storage and Storage Trie><label|sect-state-storage>

  For storing the state of the system, Polkadot Host implements a hash table
  storage where the keys are used to access each data entry. There is no
  assumption either on the size of the key nor on the size of the data stored
  under them, besides the fact that they are byte arrays with specific upper
  limits on their length. The limit is imposed by the encoding algorithms to
  store the key and the value in the storage trie.

  <subsection|Accessing System Storage >

  The Polkadot Host implements various functions to facilitate access to the
  system storage for the Runtime. See Section
  <reference|sect-entries-into-runtime> for a an explaination of those
  functions. Here we formalize the access to the storage when it is being
  directly accessed by the Polkadot Host (in contrast to Polkadot runtime).

  <\definition>
    <label|defn-stored-value>The <glossary-explain|<math|StoredValue<around*|(|k|)>>|The
    function to retrieve the value stored under a specific key in the state
    storage.><strong|StoredValue> function retrieves the value stored under a
    specific key in the state storage and is formally defined as :

    <\equation*>
      <tabular*|<tformat|<table|<row|<cell|StoredValue:>|<cell|\<cal-K\>\<rightarrow\>\<cal-V\>>>|<row|<cell|>|<cell|k\<mapsto\><around*|{|<tabular*|<tformat|<table|<row|<cell|v>|<cell|<text|if
      (k,v) exists in state storage>>>|<row|<cell|\<phi\>>|<cell|otherwise>>>>>|\<nobracket\>>>>>>>
    </equation*>

    where <math|\<cal-K\>\<subset\>\<bbb-B\>> and
    <math|\<cal-V\>\<subset\>\<bbb-B\>> are respectively the set of all keys
    and values stored in the state storage.

    \;
  </definition>

  <subsection|The General Tree Structure><label|sect-trie-structure>

  In order to ensure the integrity of the state of the system, the stored
  data needs to be re-arranged and hashed in a <em|Merkle radix-16 Tree>,
  which hereafter we refer to as the <em|<strong|State Trie>> or simply as
  the <em|<strong|Trie>><glossary-explain|State Trie, Trie|<em|The Merkle
  radix-16 Tree which stores hashes of storage enteries>.>. This rearrangment
  is necessary to be able to compute the Merkle hash of the whole or part of
  the state storage, consistently and efficiently at any given time.

  The Trie is used to compute the <em|state root>, <math|H<rsub|r>>, (see
  Definition <reference|defn-block-header>), whose purpose is to authenticate
  the validity of the state database. Thus, the Polkadot Host follows a
  rigorous encoding algorithm to compute the values stored in the trie nodes
  to ensure that the computed Merkle hash, <math|H<rsub|r>>, matches across
  the Polkadot Host implementations.

  The Trie is a <em|radix-16> tree as defined in Definition
  <reference|defn-radix-tree>. Each key value identifies a unique node in the
  tree. However, a node in a tree might or might not be associated with a key
  in the storage.\ 

  When traversing the Trie to a specific node, its key can be reconstructed
  by concatenating the subsequences of the key which are stored either
  explicitly in the nodes on the path or implicitly in their position as a
  child of their parent.

  To identify the node corresponding to a key value, <math|k>, first we need
  to encode <math|k> in a consistent with the Trie structure way. Because
  each node in the trie has at most 16 children, we represent the key as a
  sequence of 4-bit nibbles:

  <\definition>
    <math|<label|defn-key-encode-in-trie>>For the purpose of labeling the
    branches of the state trie, the key <math|k> is encoded to
    <math|k<rsub|enc>> using KeyEncode functions, formally referred to by
    KeyEncode(k)<glossary-explain|<math|KeyEncode<around|(|k|)>>|The function
    to encode keys for labeling branaches of the Trie.>:

    <\equation>
      k<rsub|enc>\<assign\><around|(|k<rsub|enc<rsub|1>>,\<ldots\>,k<rsub|enc<rsub|2*n>>|)>\<assign\>KeyEncode<around|(|k|)>
    </equation>

    such that:

    <\equation*>
      KeyEncode<around|(|k|)>:<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|\<bbb-B\><rsup|\<nosymbol\>>>|<cell|\<rightarrow\>>|<cell|Nibbles<rsup|4>>>|<row|<cell|k\<assign\><around|(|b<rsub|1>,\<ldots\>,b<rsub|n>|)>\<assign\>>|<cell|\<mapsto\>>|<cell|<around|(|b<rsup|1><rsub|1>,b<rsup|2><rsub|1>,b<rsub|2><rsup|1>,b<rsup|2><rsub|2>,\<ldots\>,b<rsup|1><rsub|n>,b<rsup|2><rsub|n>|)>>>|<row|<cell|>|<cell|>|<cell|\<assign\><around|(|k<rsub|enc<rsub|1>>,\<ldots\>,k<rsub|enc<rsub|2*n>>|)>>>>>>|\<nobracket\>>
    </equation*>

    where <math|Nibble<rsup|4>> is the set of all nibbles of 4-bit arrays and
    <math|b<rsup|1><rsub|i>> and <math|b<rsup|2><rsub|i>> are 4-bit nibbles,
    which are the big endian representations of <math|b<rsub|i>>:

    <\equation*>
      <around|(|b<rsup|1><rsub|i>,b<rsup|2><rsub|i>|)>\<assign\><around|(|b<rsub|i>/16,b<rsub|i>mod
      16|)>
    </equation*>

    where mod is the remainder and / is the integer division operators.
  </definition>

  By looking at <math|k<rsub|enc>> as a sequence of nibbles, one can walk the
  radix tree to reach the node identifying the storage value of <math|k>.

  <subsection|Trie Structure><label|sect-state-storage-trie-structure>

  In this subsection, we specify the structure of the nodes in the Trie as
  well as the Trie structure:

  <\notation>
    By \<cal-N\><glossary-explain|\<cal-N\>|The set of all nodes in the
    Polkadot state trie>, we refer to the <strong|set of the nodes of
    Polkadot state trie>. By <math|><glossary-explain|<math|N>|An individual
    node in the Trie><math|N\<in\>\<cal-N\>>, we refer to an individual node
    in the trie.
  </notation>

  <\definition>
    <label|defn-nodetype>The State Trie<glossary-dup|State Trie, Trie> is
    <verbatim|>a radix-16 tree. Each node, <math|N>, in the Trie is
    identified with a unique key <math|k<rsub|N>> such that:

    <\itemize-minus>
      <item><math|k<rsub|N>> is the shared prefix of the key of all the
      descendants of N in the Trie.
    </itemize-minus>

    \ and, at least one of the following statements holds:

    <\itemize-minus>
      <item><math|<around*|(|k<rsub|N>,v|)>> corresponds to an existing entry
      in the State Storage.

      <item>N has more than one child.
    </itemize-minus>

    <verbatim|>Conversely, if <math|<around*|(|k,v|)>> is an entry in the
    State Trie then there is a node <math|N\<in\>\<cal-N\>> such that
    <math|k<rsub|N>>=k.
  </definition>

  <\notation>
    A <strong|branch> node, formally referred to by
    \<cal-N\><rsub|b><glossary-explain|\<cal-N\><rsub|b>|A branch node of the
    Trie which has at least one and at most 16 children>, is a node which has
    one child or more. A branch node can have at most 16 children. A
    <strong|leaf> node, referred to by <math|\<cal-N\><rsub|l>><glossary-explain|<math|\<cal-N\><rsub|l>>|A
    childless leaf node of the Trie>, is a childless node. Accordingly:

    <\equation*>
      <tabular*|<tformat|<table|<row|<cell|\<cal-N\><rsub|b>\<assign\><around*|{|N\<in\>\<cal-N\>\|N
      <text|is a branch node>|}>>>|<row|<cell|\<cal-N\><rsub|l>\<assign\><around*|{|N\<in\>\<cal-N\>\|N
      <text|is a leaf node>|}>>>>>>
    </equation*>
  </notation>

  For each node, part of <math|k<rsub|N>> is built while the trie is
  traversed from root to <math|N> part of <math|k<rsub|N>> is stored in
  <math|N> as formalized in Definition <reference|defn-node-key>.

  <\definition>
    <label|defn-node-key>For any <math|N\<in\>\<cal-N\>>, its key
    <math|k<rsub|N>> is divided into an <strong|aggregated prefix key>,
    <strong|<math|pk<rsub|N><rsup|Agr>>><inactive|<glossary-explain|<math|pk<rsub|N><rsup|Agr>>|The
    aggregated prefix key of node N>>, aggregated by Algorithm
    <reference|algo-aggregate-key> and a <strong|partial key>,
    <strong|<math|pk<rsub|N>>><glossary-explain|<math|pk<rsub|N>>|The
    (suffix) partial key of node N> of length
    <math|0\<leqslant\>l<rsub|pk<rsub|N>>\<leqslant\>65535> in nibbles such
    that:

    <\equation*>
      pk<rsub|N>\<assign\><around|(|k<rsub|enc<rsub|i>>,\<ldots\>,k<rsub|enc<rsub|i+l<rsub|pk<rsub|N>>>>|)>
    </equation*>

    where <math|pk<rsub|N>> is a suffix subsequence of <math|k<rsub|N>>;
    <math|i> is the length of <math|pk<rsub|N><rsup|Agr>> in nibbles and so
    we have:

    <\equation*>
      KeyEncode<around|(|k<rsub|N>|)>=pk<rsub|N><rsup|Agr><around*|\|||\|>pk<rsub|N>=<around|(|k<rsub|enc<rsub|1>>,\<ldots\>,k<rsub|enc<rsub|i-1>>,k<rsub|enc<rsub|i>>,k<rsub|enc<rsub|i+l<rsub|pk<rsub|N>>>>|)>
    </equation*>
  </definition>

  Part of <math|pk<rsub|N><rsup|Agr>> is explicitly stored in <math|N>'s
  ancestors. Additionally, for each ancestor, a single nibble is implicitly
  derived while traversing from the ancestor to its child included in the
  traversal path using the <math|Index<rsub|N>> function defined in
  Definition <reference|defn-index-function>.

  <\definition>
    <label|defn-index-function>For <math|N\<in\>\<cal-N\><rsub|b>> and
    <math|N<rsub|c>> child of N, we define
    <strong|<math|Index<rsub|N>>><glossary-explain|<math|Index<rsub|N>>|A
    function returning an integer in range of {0,<text-dots>,15} represeting
    the index of a child node of node <math|N> among the children of
    <math|N>> function as:

    <\equation*>
      <tabular*|<tformat|<cwith|1|1|2|2|cell-halign|l>|<table|<row|<cell|Index<rsub|N>:>|<cell|<around*|{|N<rsub|c>\<in\>\<cal-N\>\|N<rsub|c>
      <text|is a child of N>|}>\<rightarrow\>Nibbles<rsup|4><rsub|1>>>|<row|<cell|>|<cell|N<rsub|c>\<mapsto\>i<rsub|>>>>>>
    </equation*>

    such that

    <\equation*>
      k<rsub|N<rsub|c>>=k<rsub|N><around*|\|||\|>i<around*|\|||\|>pk<rsub|N<rsub|c>>
    </equation*>
  </definition>

  Assuming that <math|P<rsub|N>> is the path (see Definition
  <reference|defn-path-graph>) from the Trie root to node <math|N>, Algorithm
  <reference|algo-aggregate-key> rigorously demonstrates how to build
  <math|pk<rsup|Agr><rsub|N>> while traversing <math|P<rsub|N>>.

  <\algorithm>
    <label|algo-aggregate-key><name|Aggregate-Key><math|<around*|(|P<rsub|N>:=<around*|(|TrieRoot=N<rsub|1>,\<ldots\>,N<rsub|j>=N|)>|)>>
  <|algorithm>
    <\algorithmic>
      <\state>
        <math|pk<rsup|Agr><rsub|N>\<leftarrow\>\<phi\>>
      </state>

      <\state>
        <math|i\<leftarrow\>1>
      </state>

      <\state>
        <\WHILE>
          <math|<around*|(|N<rsub|i>\<neq\>N|)>>
        </WHILE>
      </state>

      <\state>
        <math|pk<rsup|Agr><rsub|N>\<leftarrow\>pk<rsup|Agr><rsub|N><around*|\|||\|>pk<rsub|N<rsub|i>>
        >
      </state>

      <\state>
        <math|pk<rsup|Agr><rsub|N>\<leftarrow\>pk<rsup|Agr><rsub|N><around*|\|||\|>Index<rsub|N<rsub|i>><around*|(|N<rsub|i+1>|)>>
      </state>

      <\state>
        <math|i\<leftarrow\>i+1><END>
      </state>

      <\state>
        <math|pk<rsup|Agr><rsub|N>\<leftarrow\>pk<rsup|Agr><rsub|N><around*|\|||\|>pk<rsub|N<rsub|i>>>
      </state>

      <\state>
        <\RETURN>
          <math|pk<rsup|Agr><rsub|N>>
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  <\definition>
    <label|defn-node-value>A node <math|N\<in\>\<cal-N\>> stores the
    <strong|node value>, <strong|<math|v<rsub|N>>><glossary-explain|<math|v<rsub|N>>|Node
    value containing the header of node <math|N>, its partial key and the
    digest of its childern values>, consisting of the following concatenated
    data:

    <\equation*>
      <tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-lborder|1ln>|<cwith|1|1|1|-1|cell-rborder|1ln>|<table|<row|<cell|Node
      Header>|<cell|Partial key>|<cell|Node Subvalue>>>>>
    </equation*>

    Formally noted as follows:

    <\equation*>
      v<rsub|N>\<assign\>Head<rsub|N><around*|\|||\|>Enc<rsub|HE><around*|(|pk<rsub|N>|)><around*|\|||\|>sv<rsub|N>
    </equation*>

    where <math|Head<rsub|N>>, <math|pk<rsub|N>>, <math|Enc<rsub|nibbles>>
    and <math|sv<rsub|N>> are defined in Definitions
    <reference|defn-node-header>,<reference|defn-node-key>,
    <reference|defn-hex-encoding> and <reference|defn-node-subvalue>,
    respectively.
  </definition>

  <\definition>
    <label|defn-node-header>The <strong|node header> of node <math|N>,
    <math|Head<rsub|N>><glossary-explain|<math|Head<rsub|N>>|The node header
    of Trie node <math|N> storing information about the node's type and kay>,
    consists of <math|l+1\<geqslant\>1> bytes
    <math|Head<rsub|N,1>,\<ldots\>,Head<rsub|N,l+1>> such that:

    \;

    <\equation*>
      <tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-lborder|1ln>|<cwith|1|1|1|-1|cell-rborder|1ln>|<cwith|2|2|1|1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-bborder|1ln>|<cwith|2|2|1|1|cell-bborder|1ln>|<cwith|2|2|1|1|cell-lborder|1ln>|<cwith|2|2|2|2|cell-tborder|1ln>|<cwith|1|1|2|2|cell-bborder|1ln>|<cwith|2|2|2|2|cell-bborder|1ln>|<cwith|2|2|2|2|cell-lborder|0ln>|<cwith|2|2|1|1|cell-rborder|0ln>|<cwith|2|2|2|2|cell-rborder|1ln>|<cwith|2|2|1|1|cell-halign|c>|<cwith|2|2|2|2|cell-halign|c>|<table|<row|<cell|Node
      Type>|<cell|pk length>>|<row|<cell|Head<rsub|N,1><rsup|6-7><rsup|><rsub|>>|<cell|Head<rsub|N,1><rsup|0-5><rsup|><rsub|>>>>>>
      <block|<tformat|<cwith|2|2|1|1|cell-halign|c>|<table|<row|<cell|pk
      length extra byte 1>>|<row|<cell|Head<rsub|N,2><rsub|>>>>>>
      <block|<tformat|<cwith|2|2|1|1|cell-halign|c>|<table|<row|<cell|pk key
      length extra byte 2>>|<row|<cell|\<ldots\>.>>>>>\<ldots\><block|<tformat|<cwith|2|2|1|1|cell-halign|c>|<table|<row|<cell|pk
      length extra byte l>>|<row|<cell|Head<rsub|N,l+1><rsup|><rsub|>>>>>>
    </equation*>

    \;

    In which <math|Head<rsub|N,1><rsup|6-7><rsup|><rsub|>>, the two most
    significant bits of the first byte of <math|Head<rsub|N>> are determined
    as follows:

    <\equation*>
      Head<rsub|N,1><rsup|6-7><rsup|><rsub|>\<assign\><around*|{|<tabular|<tformat|<table|<row|<cell|00>|<cell|Special
      case>>|<row|<cell|01>|<cell|Leaf Node>>|<row|<cell|10>|<cell|Branch
      Node with k<rsub|N>\<nin\>\<cal-K\>>>|<row|<cell|11>|<cell|Branch Node
      with k<rsub|N>\<in\>\<cal-K\>>>>>>|\<nobracket\>>
    </equation*>

    where <math|\<cal-K\>> is defined in Definition
    <reference|defn-stored-value>.\ 

    <math|Head<rsub|N,1><rsup|0-5><rsup|><rsub|>>, the 6 least significant
    bits of the first byte of <math|Head<rsub|N>> are defined to be:

    <\equation*>
      Head<rsub|N,1><rsup|0-5><rsup|><rsub|>\<assign\><around*|{|<tabular|<tformat|<cwith|1|1|2|2|cell-valign|b>|<table|<row|<cell|<around*|\<\|\|\>|pk<rsub|N>|\<\|\|\>><rsub|nib>>|<cell|<around*|\<\|\|\>|pk<rsub|N>|\<\|\|\>><rsub|nib>\<less\>63>>|<row|<cell|63>|<cell|<around*|\<\|\|\>|pk<rsub|N>|\<\|\|\>><rsub|nib>\<geqslant\>63>>>>>|\<nobracket\>>
    </equation*>

    In which <strong|<math|<around*|\<\|\|\>|pk<rsub|N>|\<\|\|\>><rsub|nib>>>
    is the length of <math|pk<rsub|N> > in number nibbles.
    <math|Head<rsub|N,2>,\<ldots\>,Head<rsub|N,l+1>> bytes are determined by
    Algorithm <reference|algo-pk-length>.
  </definition>

  <\algorithm>
    <label|algo-pk-length><name|Partial-Key-Length-Encoding<math|<around*|(|Head<rsub|N,1><rsup|6-7><rsup|><rsub|>,pk<rsub|N>|)>>>
  <|algorithm>
    <\algorithmic>
      <\state>
        <\IF>
          <math|<around*|\<\|\|\>|pk<rsub|N>|\<\|\|\>><rsub|nib>\<geqslant\>2<rsup|16>>
        </IF>
      </state>

      <\state>
        <\RETURN>
          Error<END>
        </RETURN>
      </state>

      <\state>
        <math|Head<rsub|N,1>\<leftarrow\>64\<times\>Head<rsub|N,1><rsup|6-7><rsup|><rsub|>>
      </state>

      <\state>
        <\IF>
          <math|<around*|\<\|\|\>|pk<rsub|N>|\<\|\|\>><rsub|nib>\<less\>63>
        </IF>
      </state>

      <\state>
        <math|Head<rsub|N,1>\<leftarrow\>Head<rsub|N,1>+<around*|\<\|\|\>|pk<rsub|N>|\<\|\|\>><rsub|nib>>
      </state>

      <\state>
        <\RETURN>
          <math|Head<rsub|N><END>>
        </RETURN>
      </state>

      <\state>
        <math|Head<rsub|N,1>\<leftarrow\>Head<rsub|N,1>+63>
      </state>

      <\state>
        <math|l\<leftarrow\><around*|\<\|\|\>|pk<rsub|N>|\<\|\|\>><rsub|nib>-63>
      </state>

      <\state>
        <math|i\<leftarrow\>2>
      </state>

      <\state>
        <\WHILE>
          <math|<around*|(|l\<gtr\>255|)>>
        </WHILE>
      </state>

      <\state>
        <math|Head<rsub|N,i>\<leftarrow\>255>
      </state>

      <\state>
        <math|l\<leftarrow\>l-255>
      </state>

      <\state>
        <math|i\<leftarrow\>i+1<END>>
      </state>

      <\state>
        <math|Head<rsub|N,i>\<leftarrow\>l>
      </state>

      <\state>
        <\RETURN>
          <math|Head<rsub|N>>
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  <subsection|Merkle Proof><label|sect-merkl-proof>

  To prove the consistency of the state storage across the network and its
  modifications both efficiently and effectively, the Trie implements a
  Merkle tree structure. The hash value corresponding to each node needs to
  be computed rigorously to make the inter-implementation data integrity
  possible.

  \;

  The Merkle value of each node should depend on the Merkle value of all its
  children as well as on its corresponding data in the state storage. This
  recursive dependancy is encompassed into the subvalue part of the node
  value which recursively depends on the Merkle value of its children and
  <em|children tries>. As Section <reference|sect-child-trie-structure>
  clarifies, the Merkle value of each <strong|child trie> must be updated
  first before the final Polkadot state root can be calculated.

  \;

  As mentioned in Section <reference|sect-trie-structure>, the Trie is a
  Merkle tree. The hash function used for its Merkle structure is a variant
  of <math|Blake2b> hash function defined in Section <reference|sect-blake2>
  . Specifically, the node value, <math|v<rsub|N>> (see Definition
  <reference|defn-node-value>) itself is presented as instead of its
  <math|Blake2b> hash when it occupies less space than the latter as it is
  defined in the following:

  <\definition>
    <label|defn-merkle-value>For a given node <math|N>, the <strong|Merkle
    value> of <math|N>, denoted by <math|H<around|(|N|)>><glossary-explain|<math|H<around|(|N|)>>|<math|>The
    Merkle value of node <math|N>.> is defined as follows:

    <\equation*>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<table|<row|<cell|>|<cell|H:\<bbb-B\>\<rightarrow\>\<cup\><rsub|i\<rightarrow\>0><rsup|32>\<bbb-B\><rsub|32>>>|<row|<cell|>|<cell|H<around|(|N|)>:<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|2|3|3|cell-halign|l>|<table|<row|<cell|v<rsub|N>>|<cell|>|<cell|<around|\<\|\|\>|v<rsub|N>|\<\|\|\>>\<less\>32<infix-and>N\<neq\>R>>|<row|<cell|Blake2b<around|(|v<rsub|N>|)>>|<cell|>|<cell|<around|\<\|\|\>|v<rsub|N>|\<\|\|\>>\<geqslant\>32<infix-or>N=R>>>>>|\<nobracket\>>>>>>>
    </equation*>

    Where <math|v<rsub|N>> is the node value of <math|N> defined in
    Definition <reference|defn-node-value> and <math|R> is the root of the
    Trie. The <strong|Merkle hash> of the Trie is defined to be
    <math|H<around*|(|R|)>>.
  </definition>

  The node value <math|v<rsub|N>> depends on node subvalue <math|sv<rsub|N>>
  which uses the auxilary function introduced in Definition
  <reference|defn-children-bitmap> to encode and decode information stored in
  a branch node.

  <\definition>
    <label|defn-children-bitmap>Suppose <math|N<rsub|b>,N<rsub|c>\<in\>\<cal-N\>>
    and <math|N<rsub|c>> is a child of <math|N<rsub|b>>. We define<math|>
    where bit <math|b<rsub|i>:=1> if <math|N> has a child with partial key
    <math|i>. Therefore, we define <strong|ChildrenBitmap><glossary-explain|<math|ChildrenBitmap>|The
    binary function indicating which child of a given node is present in the
    Trie.> functions as follows:

    <\equation*>
      <tabular*|<tformat|<cwith|1|1|2|2|cell-halign|l>|<table|<row|<cell|ChildrenBitmap:>|<cell|\<cal-N\><rsub|b>\<rightarrow\>\<bbb-B\><rsub|2>>>|<row|<cell|>|<cell|N\<mapsto\><around*|(|b<rsub|15>,\<ldots\>,b<rsub|8>,b<rsub|7>,\<ldots\>b<rsub|0>|)><rsub|2>>>>>>
    </equation*>

    where

    <\equation*>
      b<rsub|i>\<assign\><around*|{|<tabular*|<tformat|<table|<row|<cell|1>|<cell|\<exists\>N<rsub|c>\<in\>\<cal-N\>:k<rsub|N<rsub|c>>=k<rsub|N<rsub|b>><around*|\|||\|>i<around*|\|||\|>pk<rsub|N<rsub|c>>>>|<row|<cell|0>|<cell|<text|otherwise>>>>>>|\<nobracket\>>
    </equation*>
  </definition>

  <verbatim|>Having defined functions <math|H> and <math|ChildrenBitmap>, we
  are able to define the <math|subvalue<below||>> of a node as follows:

  <\definition>
    <label|defn-node-subvalue>For a given node <math|N>, the
    <strong|subvalue> of <math|N>, formally referred to as
    <math|sv<rsub|N>><glossary-explain|<math|sv<rsub|N>>|The subvalue of a
    Trie node <math|N>.>, is determined as follows:

    <\itemize>
      <\equation*>
        <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<table|<row|<cell|sv<rsub|N>\<assign\>>>|<row|<cell|<around*|{|<tabular*|<tformat|<cwith|2|3|1|1|cell-halign|l>|<cwith|2|3|1|1|cell-lborder|0ln>|<cwith|2|3|1|1|cell-rborder|0ln>|<cwith|1|1|1|1|cell-halign|l>|<table|<row|<cell|StoredValue<rsub|SC>>>|<row|<cell|\<nobracket\>*Enc<rsup|><rsub|SC><around*|(|ChildrenBitmap<around*|(|N|)>|)>\<\|\|\>StoredValue<rsub|SC><around*|\<\|\|\>||\<nobracket\>>Enc<rsub|SC><around*|(|H<around|(|N<rsub|C<rsub|1>>|)>|)>*\<ldots\>*Enc<rsub|SC><around*|(|H<around*|(|N<rsub|C<rsub|n>>|)>|)>*>>>>>|\<nobracket\>>>>|<row|<cell|>>|<row|<cell|<text|where
        the first variant is a leaf node and the second variant is a branch
        node.>>>|<row|<cell|>>|<row|<cell|StoredValue<rsub|SC>\<assign\><around*|{|<tabular*|<tformat|<cwith|1|-1|1|-1|cell-halign|l>|<table|<row|<cell|Enc<rsub|SC><around*|(|StoredValue<around*|(|k<rsub|N>|)>|)>>|<cell|>|<cell|<with|font-family|rm|if<space|1em>>StoredValue<around*|(|k<rsub|N>|)>=v>>|<row|<cell|\<b-phi\>>|<cell|>|<cell|<with|font-family|rm|if<space|1em>>StoredValue<around*|(|k<rsub|N>|)>=\<phi\>>>>>>|\<nobracket\>>>>>>>
      </equation*>
    </itemize>
  </definition>

  <math|N<rsub|C<rsub|1>>*\<ldots\>*N<rsub|C<rsub|n>>> with
  <math|n\<leqslant\>16> are the children nodes of the branch node <math|N>
  and Enc<rsub|SC> is the SCALE encoding defined in Definition
  <reference|sect-scale-codec>. Stored<math|Value> is defned in Definition
  <reference|defn-stored-value>. <math|H> and
  <math|*ChildrenBitmap<around|(|N|)>> are defined in Definitions
  <reference|defn-merkle-value> and <reference|defn-children-bitmap>
  respectively.

  <section|Child Storage><label|sect-child-storages>

  As clarified in Section <reference|sect-state-storage>, the Polkadot state
  storage implements a hash table for inserting and reading key-value
  entries. The child storage<glossary-explain|Child storage|A sub storage of
  the state storage which has the same structure although being stored
  seperately> works the same way but is stored in a separate and isolated
  environment. Entries in the child storage are not directly accessible via
  querying the main state storage.

  \;

  The Polkadot Host supports as many child storages as required by Runtime
  and identifies each separate child storage by its unique identifying key.
  Child storages are usually used in situations where Runtime deals with
  multiple instances of a certain type of objects such as Parachains or Smart
  Contracts. In such cases, the execution of the Runtime entry might result
  in generating repeated keys across multiple instances of certain objects.
  Even with repeated keys, all such instances of key-value pairs must be able
  to be stored within the Polkadot state.

  \;

  In these situations, the child storage can be used to provide the isolation
  necessary to prevent any undesired interference between the state of
  separated instances. The Polkadot Host makes no assumptions about how child
  storages are used, but provides the functionality for it. This is described
  in more detail in the Host API, as described in Section
  <reference|sect-child-storages>.

  <subsection|Child Tries><label|sect-child-trie-structure>

  The child trie<glossary-explain|Child Trie|State trie of a child storage>
  specification is the same as the one described in Section
  <reference|sect-state-storage-trie-structure>. Child tries have their own
  isol<verbatim|>ated environment. Nonetheless, the main Polkadot state trie
  depends on them by storing a node (<math|K<rsub|N>,V<rsub|N>>) which
  corresponds to an individual child trie. Here, <math|K<rsub|N>> is the
  child storage key associated to the child trie, and <math|V<rsub|N>> is the
  Merkle value of its corresponding child trie computed according to the
  procedure described in Section <reference|sect-merkl-proof>

  \;

  The Polkadot Host APIs as defined in <reference|sect-child-storages> allows
  the Runtime to provide the key <math|K<rsub|N>> in order to identify the
  child trie, followed by a second key in order to identify the value within
  that child trie. Every time a child trie is modified, the Merkle proof
  <math|V<rsub|N>> of the child trie stored in the Polkadot state must be
  updated first. After that, the final Merkle proof of the Polkadot state can
  be computed. This mechanism provides a proof of the full Polkadot state
  including all its child states.

  <verbatim|>

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|1>
    <associate|save-aux|false>
  </collection>
</initial>

<references|<\collection>
</collection>>

<auxiliary|<\collection>
</collection>>