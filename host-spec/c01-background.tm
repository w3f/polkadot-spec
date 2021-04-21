<TeXmacs|1.99.18>

<project|host-spec.tm>

<style|<tuple|tmbook|algorithmacs-style>>

<\body>
  <chapter|Background>

  <section|Introduction>

  Formally, Polkadot is a replicated sharded state machine designed to
  resolve the scalability and interoperability among blockchains. In Polkadot
  vocabulary, shards are called <em|parachains> and Polkadot <em|relay chain>
  is part of the protocol ensuring global consensus among all the parachains.
  The Polkadot relay chain protocol, henceforward called <em|Polkadot
  protocol>, can itself be considered as a replicated state machine on its
  own. As such, the protocol can be specified by identifying the state
  machine and the replication strategy.

  \;

  From a more technical point of view, the Polkadot protocol has been divided
  into two parts, the <em|Runtime> and the <em|Host>. The Runtime comprises
  the state transition logic for the Polkadot protocol and is designed and be
  upgradable via the consensus engine without requiring hard forks of the
  blockchain. The Polkadot Host provides the functionality for the Runtime to
  execute its state transition logic, such as an execution environment, I/O
  and consensus, shared mostly among peer-to-peer decentralized
  cryptographically-secured transaction systems, i.e. blockchains whose
  consensus system is based on the proof-of-stake. The Polkadot Host is
  planned to be stable and static for the lifetime duration of the Polkadot
  protocol.

  \;

  With the current document, we aim to specify the Polkadot Host part of the
  Polkadot protocol as a replicated state machine. After defining the basic
  terms in Chapter 1, we proceed to specify the representation of a valid
  state of the Protocol in Chapter <reference|chap-state-spec>. In Chapter
  <reference|chap-state-transit>, we identify the protocol states, by
  explaining the Polkadot state transition and discussing the detail based on
  which the Polkadot Host interacts with the state transition function, i.e.
  Runtime. Following, we specify the input messages triggering the state
  transition and the system behaviour. In Chapter
  <reference|sect-networking>, we specify the communication protocols and
  network messages required for the Polkadot Host to communicate with other
  nodes in the network, such as exchanging blocks and consensus messages. In
  Chapter <reference|chap-consensu>, we specify the consensus protocol, which
  is responsible for keeping all the replica in the same state. Finally, the
  initial state of the machine is identified and discussed in Appendix
  <reference|sect-genesis-block>. A Polkadot Host implementation which
  conforms with this part of the specification should successfully be able to
  sync its states with the Polkadot network.

  <section|Definitions and Conventions><label|sect-defn-conv>

  <\definition>
    <label|defn-state-machine>A <strong|Discrete State Machine (DSM)> is a
    state transition system whose set of states and set of transitions are
    countable and admits a starting state. Formally, it is a tuple of

    <\equation*>
      *<around*|(|\<Sigma\>,S,s<rsub|0>,\<delta\>|)>
    </equation*>

    where <label|defn-runtime>

    <\itemize>
      <item><math|\<Sigma\>> is the countable set of all possible
      transitions.

      <item><math|S> is a countable set of all possible states.

      <item><math|s<rsub|0>\<in\>S> is the initial state.

      <item><math|\<delta\>> is the state-transition function, known as
      <strong|Runtime> in the Polkadot vocabulary, such that

      <\equation*>
        \<delta\>:S\<times\>\<Sigma\>\<rightarrow\>S
      </equation*>
    </itemize>
  </definition>

  <\definition>
    <label|defn-path-graph>A <strong|path graph> or a <strong|path> of
    <math|n> nodes formally referred to as
    <glossary-explain|<math|P<rsub|n>>|A path graph or a path of <math|n>
    nodes.><strong|<math|P<rsub|n>>>, is a tree with two nodes of vertex
    degree 1 and the other n-2 nodes of vertex degree 2. Therefore,
    <math|P<rsub|n>> can be represented by sequences of
    <math|<around|(|v<rsub|1>,\<ldots\>,v<rsub|n>|)>> where
    <math|e<rsub|i>=<around|(|v<rsub|i>,v<rsub|i+1>|)>> for
    <math|1\<leqslant\>i\<leqslant\>n-1> is the edge which connect
    <math|v<rsub|i>> and <math|v<rsub|i+1>>.
  </definition>

  <\definition>
    <label|defn-radix-tree><strong|Radix-r tree> is a variant of \ a trie in
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
    By a <strong|sequences of bytes> or a <strong|byte array>,
    <math|b><glossary-explain|<math|b\<assign\><around|(|b<rsub|0>,b<rsub|1>,...,b<rsub|n-1>|)>>|A
    sequence of bytes or byte array of length <math|n>> , of length <math|n>,
    we refer to

    <\equation*>
      b\<assign\><around|(|b<rsub|0>,b<rsub|1>,...,b<rsub|n-1>|)>*<text|such
      that >0\<leqslant\>b<rsub|i>\<leqslant\>255
    </equation*>

    We define <glossary-explain|<math|\<bbb-B\><rsub|n>>|A set of all byte
    arrays of length <math|n>><math|\<bbb-B\><rsub|n>> to be the <strong|set
    of all byte arrays of length <math|n>>. Furthermore, we define:

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
    <label|defn-little-endian>Let <glossary-explain|<math|I=<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>|A
    non-negative interger in base 256>I be a non-negative integer represented
    as <math|I=<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>> in base
    256. By <verbatim|>the <strong|little-endian> representation of <math|I>,
    we refer to a byte array <glossary-explain|<math|B=<around*|(|b<rsub|0>,b<rsub|1>,\<ldots\>,b<rsub|n>|)>>|The
    little-endian representation of a non-negative interger
    <math|I=<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>> such that
    <math|b<rsub|i>\<assign\>B<rsub|i>>><math|B<rsub|I>> such that:

    <\equation*>
      B<rsub|I>\<assign\><around*|(|b<rsub|0>,b<rsub|1>,\<ldots\>,b<rsub|n>|)><space|1em><with|font-family|rm|where
      <space|1em>>b<rsub|i>\<assign\>B<rsub|i>
    </equation*>

    Accordingly, we define the function <glossary-explain|<math|Enc<rsub|LE>><math|>|The
    little-endian encoding function.><math|Enc<rsub|LE>>:

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
    A <glossary-explain|C|A blockchain defined as a directed path
    graph.><strong|blockchain> <math|C> is a directed path graph. Each node
    of the graph is called <glossary-explain|Block|A node of the directed
    path graph \ (blockchain) C><strong|Block> and indicated by
    <strong|<math|B>>. The unique sink of <math|C> is called
    <glossary-explain|Genesis Block|The unique sink of blockchain
    C><strong|Genesis Block>, and the source is called the
    <glossary-explain|Head|The source of blockchain C><strong|Head> of C. For
    any vertex <math|<around*|(|B<rsub|1>,B<rsub|2>|)>> where
    <math|B<rsub|1>\<rightarrow\>B<rsub|2>> we say <math|B<rsub|2>> is the
    <glossary-explain|P(B)|The parent of block <math|B>><strong|parent> of
    <math|B<rsub|1>> and we indicate it by\ 

    <\equation*>
      B<rsub|2>\<assign\>P<around*|(|B<rsub|1>|)>
    </equation*>
  </definition>

  <\definition>
    <label|defn-unix-time>By <strong|UNIX time><glossary-explain|UNIX
    time|The number of milliseconds that have elapsed since the Unix epoch as
    a 64-bit integer>, we refer to the unsigned, little-endian encoded 64-bit
    integer which stores the number of <strong|milliseconds> that have
    elapsed since the Unix epoch, that is the time 00:00:00 UTC on 1 January
    1970, minus leap seconds. Leap seconds are ignored, and every day is
    treated as if it contained exactly 86'400 seconds.
  </definition>

  <subsection|Block Tree>

  In the course of formation of a (distributed) blockchain, it is possible
  that the chain forks into multiple subchains in various block positions. We
  refer to this structure as a <em|block tree:>

  <\definition>
    <label|defn-block-tree>The <glossary-explain|BT|The block tree of a
    blockchain><strong|block tree> of a blockchain, denoted by <math|BT> is
    the union of all different versions of the blockchain observed by the
    Polkadot Host such that every block is a node in the graph and
    <math|B<rsub|1>> is connected to <math|B<rsub|2>> if <math|B<rsub|1>> is
    a parent of <math|B<rsub|2>>.
  </definition>

  When a block in the block tree gets finalized, there is an opportunity to
  prune the block tree to free up resources into branches of blocks that do
  not contain all of the finalized blocks or those that can never be
  finalized in the blockchain. For a definition of finality, see Section
  <reference|sect-finality>.

  <\definition>
    <label|defn-pruned-tree>By <glossary-explain|PBT, Pruned BT|Pruned Block
    Tree.><strong|Pruned Block Tree>, denoted by <math|PBT>, we refer to a
    subtree of the block tree obtained by eliminating all branches which do
    not contain the most recent finalized blocks, as defined in Definition
    <reference|defn-finalized-block>. By <glossary-explain|Pruning|The
    transformation of <math|BT> into <math|PBT>><strong|pruning>, we refer to
    the procedure of <math|BT\<leftarrow\>PBT>. When there is no risk of
    ambiguity and is safe to prune BT, we use <math|BT> to refer to
    <math|PBT>.
  </definition>

  Definition <reference|defn-chain-subchain> gives the means to highlight
  various branches of the block tree.

  <\definition>
    <label|defn-chain-subchain>Let <glossary-explain|G|The genesis block, the
    root of the block tree BT><math|G> be the root of the block tree and
    <math|B> be one of its nodes. By <glossary-explain|CHAIN(B)|The path
    graph from <math|G> to <math|B> in (P)<math|BT>.><name|<strong|Chain(<math|B>)>,>
    we refer to the path graph from <math|G> to <math|B> in (P)<math|BT>.
    Conversely, for a chain <math|C>=<name|Chain(B)>, we define
    <glossary-explain|<name|Head(<math|C>)>|The head of chain C.><strong|the
    head of <math|C>> to be <math|B>, formally noted as
    <math|B\<assign\>><name|Head(<math|C>)>. We define
    <glossary-explain|<math|<around*|\||C|\|>>|The length of chain <math|C
    >as a path graph><math|<around*|\||C|\|>>, the length of <math|C >as a
    path graph. If <math|B<rprime|'>> is another node on
    <name|Chain(<math|B>)>, then by <glossary-explain|<name|SubChain>(<math|B<rprime|'>,B>)|The
    subgraph of <math|><name|Chain(<math|B>)> path graph containing both
    <math|B> and <math|B<rprime|'>>.><name|SubChain(<math|B<rprime|'>,B>)> we
    refer to the subgraph of <math|><name|Chain(<math|B>)> path graph which
    contains both <math|B> and <math|B<rprime|'>> and by
    <name|\|SubChain(<math|B<rprime|'>,B>)\|> we refer to its length.
    Accordingly, <glossary-explain|<math|\<bbb-C\><rsub|B<rprime|'>><around*|(|<around*|(|P|)>BT|)>>|The
    set of all subchains of <math|<around*|(|P|)>BT> rooted at block
    <math|B<rprime|'>>.><math|\<bbb-C\><rsub|B<rprime|'>><around*|(|<around*|(|P|)>BT|)>>
    is the set of all subchains of <math|<around*|(|P|)>BT> rooted at
    <math|B<rprime|'>>. The set of all chains of <math|<around*|(|P|)>BT>,
    <math|\<bbb-C\><rsub|G><around*|(|<around*|(|*P|)>BT|)>> is denoted by
    <math|\<bbb-C\>>((P)BT) or simply <glossary-explain|<math|\<bbb-C\>>,
    <math|\<bbb-C\>>((P)BT)|<math|\<bbb-C\><rsub|G><around*|(|<around*|(|*P|)>BT|)>>
    i.e. the set of all chains of <math|<around*|(|P|)>BT> rooted at genesis
    block><math|\<bbb-C\>>, for the sake of brevity.
  </definition>

  <\definition>
    <label|defn-longest-chain>We define the following complete order over
    <math|\<bbb-C\>> such that for <math|C<rsub|1>,C<rsub|2>\<in\>\<bbb-C\>>
    if <math|<around*|\||C<rsub|1>|\|>\<neq\><around*|\||C<rsub|2>|\|>> we
    say <math|C<rsub|1>\<gtr\>C<rsub|2>> if and only if
    <math|<around*|\||C<rsub|1>|\|>\<gtr\><around*|\||C<rsub|2>|\|>>.\ 

    If <math|<around*|\||C<rsub|1>|\|>=<around*|\||C<rsub|2>|\|>> we say
    <math|C<rsub|1>\<gtr\>C<rsub|2>> if and only if the block arrival time of
    <math|Head<around*|(|C<rsub|1>|)><rsub|>> is less than the block arrival
    time of <math|Head<around*|(|C<rsub|2>|)>> as defined in Definition
    <reference|defn-block-time>. We define the
    <glossary-explain|<name|Longest-Chain>(<math|BT>)|The longest sub path
    graph of <math|BT> <math|i.e. C:<around*|\||C|\|>=max<around*|{|<around*|\||C<rsub|i>|\|><around*|\||C<rsub|i>\<in\>\<bbb-C\>|\<nobracket\>>|}>>><strong|<name|Longest-Chain(<math|BT>)>>
    to be the maximum chain given by this order.
  </definition>

  <\definition>
    <glossary-explain|<name|Longest-Path>(<math|BT>)|The longest sub path
    graph of <math|<around*|(|P|)>BT> with earliest block arrival
    time><name|Longest-Path(<math|BT>)> returns the path graph of
    <math|<around*|(|P|)>BT> which is the longest among all paths in
    <math|<around*|(|P|)>BT> and has the earliest block arrival time as
    defined in Definition <reference|defn-block-time>.
    <glossary-explain|<name|Deepest-Leaf>(BT)|<name|Head>(<name|Longest-Path>(<math|BT>))
    i.e. the head of <name|Longest-Path>(<math|BT>)>
    <name|Deepest-Leaf(<math|BT>)> returns the head of
    <name|Longest-Path(<math|BT>)> chain.
  </definition>

  Because every block in the blockchain contains a reference to its parent,
  it is easy to see that the block tree is de facto a tree. A block tree
  naturally imposes partial order relationships on the blocks as follows:

  <\definition>
    We say <strong|B is descendant of <math|B<rprime|'>>>, formally noted as
    <glossary-explain|<math|B\<gtr\>B<rprime|'>>|<math|B> is a descendant of
    <math|B<rprime|'>> in the block tree><strong|<math|B\<gtr\>B<rprime|'>>>
    if <math|B> is a descendant of <math|B<rprime|'>> in the block tree.
  </definition>

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|0>
    <associate|save-aux|false>
  </collection>
</initial>

<references|<\collection>
</collection>>

<auxiliary|<\collection>
</collection>>