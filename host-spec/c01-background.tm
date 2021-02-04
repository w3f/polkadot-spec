<TeXmacs|1.99.16>

<project|host-spec.tm>

<style|<tuple|book|old-lengths>>

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
  most of the state transition logic for the Polkadot protocol and is
  designed and expected to be upgradable as part of the state transition
  process. The Polkadot Host consists of parts of the
  protocol,<space|1em>shared mostly among peer-to-peer decentralized
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
  transition and the system behaviour. In Chapter <reference|chap-consensu>,
  we specify the consensus protocol, which is responsible for keeping all the
  replica in the same state. Finally, the initial state of the machine is
  identified and discussed in Appendix <reference|sect-genesis-block>. A
  Polkadot Host implementation which conforms with this part of the
  specification should successfully be able to sync its states with the
  Polkadot network.

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
    <glossary-explain|<strong|<math|P<rsub|n>>>|a path graph or a path of n
    nodes, can be represented by sequences of
    <math|<around|(|v<rsub|1>,\<ldots\>,v<rsub|n>|)>> where
    <math|e<rsub|i>=<around|(|v<rsub|i>,v<rsub|i+1>|)>> for
    <math|1\<leqslant\>i\<leqslant\>n-1> is the edge which connect
    <math|v<rsub|i>> and <math|v<rsub|i+1>>><strong|<math|P<rsub|n>>>, is a
    tree with two nodes of vertex degree 1 and the other n-2 nodes of vertex
    degree 2. Therefore, <math|P<rsub|n>> can be represented by sequences of
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
    By a <strong|sequences of bytes> or a <strong|byte array>, <math|b>, of
    length <math|n>, we refer to

    <\equation*>
      b\<assign\><around|(|b<rsub|0>,b<rsub|1>,...,b<rsub|n-1>|)>*<text|such
      that >0\<leqslant\>b<rsub|i>\<leqslant\>255
    </equation*>

    We define <glossary-explain|<math|\<bbb-B\><rsub|n>>|a set of all byte
    arrays of length n><math|\<bbb-B\><rsub|n>> to be the <strong|set of all
    byte arrays of length <math|n>>. Furthermore, we define:

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
    representation of a non-negative integer, <glossary-explain|I|the
    little-endian representation of a non-negative interger, represented as
    <math|I=<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>>I,
    represented as

    <\equation*>
      I=<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>
    </equation*>

    in base 256, we refer to a byte array <glossary-explain|<math|B>|a byte
    array <math|B=<around*|(|b<rsub|0>,b<rsub|1>,\<ldots\>,b<rsub|n>|)>> such
    that <math|b<rsub|i>\<assign\>B<rsub|i>>><math|B=<around*|(|b<rsub|0>,b<rsub|1>,\<ldots\>,b<rsub|n>|)>>
    such that

    <\equation*>
      b<rsub|i>\<assign\>B<rsub|i>
    </equation*>

    Accordingly, define the function <glossary-explain|<math|Enc<rsub|LE>>|<math|<tabular|<tformat|<table|<row|<cell|\<bbb-Z\><rsup|+>>|<cell|\<rightarrow\>>|<cell|\<bbb-B\>>>|<row|<cell|<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>|<cell|\<mapsto\>>|<cell|<around*|(|B<rsub|0,>B<rsub|1>,\<ldots\><rsub|>,B<rsub|n>|)>>>>>>>><math|Enc<rsub|LE>>:

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
    A <glossary-explain|C, blockchain|a blockchain C is a directed path
    graph.><strong|blockchain> <math|C> is a directed path graph. Each node
    of the graph is called <glossary-explain|Block|a node of the graph in
    blockchain C and indicated by <math|B>><strong|Block> and indicated by
    <strong|<math|B>>. The unique sink of <math|C> is called
    <glossary-explain|Genesis Block|the unique sink of blockchain
    C><strong|Genesis Block>, and the source is called the
    <glossary-explain|Head|the source of blockchain C><strong|Head> of C. For
    any vertex <math|<around*|(|B<rsub|1>,B<rsub|2>|)>> where
    <math|B<rsub|1>\<rightarrow\>B<rsub|2>> we say <math|B<rsub|2>> is the
    <glossary-explain|P|for any vertex <math|<around*|(|B<rsub|1>,B<rsub|2>|)>>
    where <math|B<rsub|1>\<rightarrow\>B<rsub|2>> we say <math|B<rsub|2>> is
    the parent of <math|B<rsub|1>> and we indicate it by
    <math|B<rsub|2>\<assign\>P<around*|(|B<rsub|1>|)>>><strong|parent> of
    <math|B<rsub|1>> and we indicate it by\ 

    <\equation*>
      B<rsub|2>\<assign\>P<around*|(|B<rsub|1>|)>
    </equation*>
  </definition>

  <\definition>
    <label|defn-unix-time>By <strong|UNIX time>, we refer to the unsigned,
    little-endian encoded 64-bit integer which stores the number of
    <strong|milliseconds> that have elapsed since the Unix epoch, that is the
    time 00:00:00 UTC on 1 January 1970, minus leap seconds. Leap seconds are
    ignored, and every day is treated as if it contained exactly 86400
    seconds.
  </definition>

  <subsection|Block Tree>

  In the course of formation of a (distributed) blockchain, it is possible
  that the chain forks into multiple subchains in various block positions. We
  refer to this structure as a <em|block tree:>

  <\definition>
    <label|defn-block-tree>The <glossary-explain|BT, block tree|is the union
    of all different versions of the blockchain observed by all the nodes in
    the system such as every such block is a node in the graph and
    <math|B<rsub|1>> is connected to <math|B<rsub|2>> if <math|B<rsub|1>> is
    a parent of <math|B<rsub|2>>><strong|block tree> of a blockchain, denoted
    by <math|BT> is the union of all different versions of the blockchain
    observed by all the nodes in the system such as every such block is a
    node in the graph and <math|B<rsub|1>> is connected to <math|B<rsub|2>>
    if <math|B<rsub|1>> is a parent of <math|B<rsub|2>>.
  </definition>

  When a block in the block tree gets finalized, there is an opportunity to
  prune the block tree to free up resources into branches of blocks that do
  not contain all of the finalized blocks or those that can never be
  finalized in the blockchain. For a definition of finality, see Section
  <reference|sect-finality>.

  <\definition>
    <label|defn-pruned-tree>By <glossary-explain|PBT, Pruned BT|Pruned Block
    Tree refers to a subtree of the block tree obtained by eliminating all
    branches which do not contain the most recent finalized blocks, as
    defined in Definition <reference|defn-finalized-block>.><strong|Pruned
    Block Tree>, denoted by <math|PBT>, we refer to a subtree of the block
    tree obtained by eliminating all branches which do not contain the most
    recent finalized blocks, as defined in Definition
    <reference|defn-finalized-block>. By <glossary-explain|pruning|><strong|pruning>,
    we refer to the procedure of <math|BT\<leftarrow\>PBT>. When there is no
    risk of ambiguity and is safe to prune BT, we use <math|BT> to refer to
    <math|PBT>.
  </definition>

  Definition <reference|defn-chain-subchain> gives the means to highlight
  various branches of the block tree.

  <\definition>
    <label|defn-chain-subchain>Let <glossary-explain|G|is the root of the
    block tree and B is one of its nodes.><math|G> be the root of the block
    tree and <math|B> be one of its nodes. By
    <glossary-explain|CHAIN(B)|refers to the path graph from <math|G> to
    <math|B> in (P)<math|BT>.><name|<strong|Chain(<math|B>)>,> we refer to
    the path graph from <math|G> to <math|B> in (P)<math|BT>. Conversely, for
    a chain <math|C>=<name|Chain(B)>, we define <glossary-explain|head of
    C|defines the head of C to be <math|B>, formally noted as
    <math|B\<assign\>><name|Head(<math|C>)>.><strong|the head of <math|C>> to
    be <math|B>, formally noted as <math|B\<assign\>><name|Head(<math|C>)>.
    We define <glossary-explain|<math|<around*|\||C|\|>>|defines he length of
    <math|C >as a path graph><math|<around*|\||C|\|>>, the length of <math|C
    >as a path graph. If <math|B<rprime|'>> is another node on
    <name|Chain(<math|B>)>, then by <glossary-explain|SubChain(<math|B<rprime|'>,B>)|If
    <math|B<rprime|'>> is another node on <name|Chain(<math|B>)>, then by
    <name|SubChain(<math|B<rprime|'>,B>)> we refer to the subgraph of
    <math|><name|Chain(<math|B>)> path graph which contains both <math|B> and
    <math|B<rprime|'>>.><name|SubChain(<math|B<rprime|'>,B>)> we refer to the
    subgraph of <math|><name|Chain(<math|B>)> path graph which contains both
    <math|B> and <math|B<rprime|'>> and by
    <name|\|SubChain(<math|B<rprime|'>,B>)\|> we refer to its length.
    Accordingly, <glossary-explain|<math|\<bbb-C\><rsub|B<rprime|'>><around*|(|<around*|(|P|)>BT|)>>|is
    the set of all subchains of <math|<around*|(|P|)>BT> rooted at
    <math|B<rprime|'>>.><math|\<bbb-C\><rsub|B<rprime|'>><around*|(|<around*|(|P|)>BT|)>>
    is the set of all subchains of <math|<around*|(|P|)>BT> rooted at
    <math|B<rprime|'>>. The set of all chains of <math|<around*|(|P|)>BT>,
    <math|\<bbb-C\><rsub|G><around*|(|<around*|(|*P|)>BT|)>> is denoted by
    <math|\<bbb-C\>>((P)BT) or simply <glossary-explain|<math|\<bbb-C\>>|the
    set of all chains of <math|<around*|(|P|)>BT>,
    <math|\<bbb-C\><rsub|G><around*|(|<around*|(|*P|)>BT|)>> is denoted by
    <math|\<bbb-C\>>((P)BT) or simply <math|\<bbb-C\>>><math|\<bbb-C\>>, for
    the sake of brevity.
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
    <glossary-explain|LONGEST-CHAIN(BT)|the maximum chain given by the
    complete order over <math|\<bbb-C\>>><strong|<name|Longest-Chain(<math|BT>)>>
    to be the maximum chain given by this order.
  </definition>

  <\definition>
    <glossary-explain|LONGEST-PATH(BT)|the path graph of
    <math|<around*|(|P|)>BT> which is the longest among all paths in
    <math|<around*|(|P|)>BT> and has the earliest block arrival time as
    defined in Definition <reference|defn-block-time>.><name|Longest-Path(<math|BT>)>
    returns the path graph of <math|<around*|(|P|)>BT> which is the longest
    among all paths in <math|<around*|(|P|)>BT> and has the earliest block
    arrival time as defined in Definition <reference|defn-block-time>.
    <glossary-explain|DEEPEST-LEAF(BT)|the head of LONGEST-PATH(BT)>
    <name|Deepest-Leaf(<math|BT>)> returns the head of
    <name|Longest-Path(<math|BT>)> chain.
  </definition>

  Because every block in the blockchain contains a reference to its parent,
  it is easy to see that the block tree is de facto a tree. A block tree
  naturally imposes partial order relationships on the blocks as follows:

  <\definition>
    We say <strong|B is descendant of <math|B<rprime|'>>>, formally noted as
    <strong|<math|B\<gtr\>B<rprime|'>>> if <math|B> is a descendant of
    <math|B<rprime|'>> in the block tree.
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
    <associate|page-first|13>
    <associate|section-nr|0>
    <associate|subsection-nr|0>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-10|<tuple|Block|?>>
    <associate|auto-11|<tuple|Genesis Block|?>>
    <associate|auto-12|<tuple|Head|?>>
    <associate|auto-13|<tuple|P|?>>
    <associate|auto-14|<tuple|1.2.1|?>>
    <associate|auto-15|<tuple|BT, block tree|?>>
    <associate|auto-16|<tuple|PBT, Pruned BT|?>>
    <associate|auto-17|<tuple|pruning|?>>
    <associate|auto-18|<tuple|G|?>>
    <associate|auto-19|<tuple|CHAIN(B)|?>>
    <associate|auto-2|<tuple|1.1|?>>
    <associate|auto-20|<tuple|head of C|?>>
    <associate|auto-21|<tuple|<with|mode|<quote|math>|<around*|\||C|\|>>|?>>
    <associate|auto-22|<tuple|SubChain(<with|mode|<quote|math>|B<rprime|'>,B>)|?>>
    <associate|auto-23|<tuple|<with|mode|<quote|math>|\<bbb-C\><rsub|B<rprime|'>><around*|(|<around*|(|P|)>BT|)>>|?>>
    <associate|auto-24|<tuple|<with|mode|<quote|math>|\<bbb-C\>>|?>>
    <associate|auto-25|<tuple|LONGEST-CHAIN(BT)|?>>
    <associate|auto-26|<tuple|LONGEST-PATH(BT)|?>>
    <associate|auto-27|<tuple|DEEPEST-LEAF(BT)|?>>
    <associate|auto-3|<tuple|1.2|?>>
    <associate|auto-4|<tuple|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|mode|<quote|math>|P<rsub|n>>>|?>>
    <associate|auto-5|<tuple|<with|mode|<quote|math>|\<bbb-B\><rsub|n>>|?>>
    <associate|auto-6|<tuple|I|?>>
    <associate|auto-7|<tuple|<with|mode|<quote|math>|B>|?>>
    <associate|auto-8|<tuple|<with|mode|<quote|math>|Enc<rsub|LE>>|?>>
    <associate|auto-9|<tuple|C, blockchain|?>>
    <associate|defn-bit-rep|<tuple|1.6|?>>
    <associate|defn-block-tree|<tuple|1.11|?>>
    <associate|defn-chain-subchain|<tuple|1.13|?>>
    <associate|defn-little-endian|<tuple|1.7|?>>
    <associate|defn-longest-chain|<tuple|1.14|?>>
    <associate|defn-path-graph|<tuple|1.2|?>>
    <associate|defn-pruned-tree|<tuple|1.12|?>>
    <associate|defn-radix-tree|<tuple|1.3|?>>
    <associate|defn-runtime|<tuple|1.1|?>>
    <associate|defn-state-machine|<tuple|1.1|?>>
    <associate|defn-unix-time|<tuple|1.10|?>>
    <associate|sect-defn-conv|<tuple|1.2|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|gly>
      <tuple|normal|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|mode|<quote|math>|P<rsub|n>>>|a
      path graph or a path of n nodes, can be represented by sequences of
      <with|mode|<quote|math>|<around|(|v<rsub|1>,\<ldots\>,v<rsub|n>|)>>
      where <with|mode|<quote|math>|e<rsub|i>=<around|(|v<rsub|i>,v<rsub|i+1>|)>>
      for <with|mode|<quote|math>|1\<leqslant\>i\<leqslant\>n-1> is the edge
      which connect <with|mode|<quote|math>|v<rsub|i>> and
      <with|mode|<quote|math>|v<rsub|i+1>>|<pageref|auto-4>>

      <tuple|normal|<with|mode|<quote|math>|\<bbb-B\><rsub|n>>|a set of all
      byte arrays of length n|<pageref|auto-5>>

      <tuple|normal|I|the little-endian representation of a non-negative
      interger, represented as <with|mode|<quote|math>|I=<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>|<pageref|auto-6>>

      <tuple|normal|<with|mode|<quote|math>|B>|a byte array
      <with|mode|<quote|math>|B=<around*|(|b<rsub|0>,b<rsub|1>,\<ldots\>,b<rsub|n>|)>>
      such that <with|mode|<quote|math>|b<rsub|i>\<assign\>B<rsub|i>>|<pageref|auto-7>>

      <tuple|normal|<with|mode|<quote|math>|Enc<rsub|LE>>|<with|mode|<quote|math>|<tformat|<tformat|<table|<row|<cell|\<bbb-Z\><rsup|+>>|<cell|\<rightarrow\>>|<cell|\<bbb-B\>>>|<row|<cell|<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>|<cell|\<mapsto\>>|<cell|<around*|(|B<rsub|0,>B<rsub|1>,\<ldots\><rsub|>,B<rsub|n>|)>>>>>>>|<pageref|auto-8>>

      <tuple|normal|C, blockchain|a blockchain C is a directed path
      graph.|<pageref|auto-9>>

      <tuple|normal|Block|a node of the graph in blockchain C and indicated
      by <with|mode|<quote|math>|B>|<pageref|auto-10>>

      <tuple|normal|Genesis Block|the unique sink of blockchain
      C|<pageref|auto-11>>

      <tuple|normal|Head|the source of blockchain C|<pageref|auto-12>>

      <tuple|normal|P|for any vertex <with|mode|<quote|math>|<around*|(|B<rsub|1>,B<rsub|2>|)>>
      where <with|mode|<quote|math>|B<rsub|1>\<rightarrow\>B<rsub|2>> we say
      <with|mode|<quote|math>|B<rsub|2>> is the parent of
      <with|mode|<quote|math>|B<rsub|1>> and we indicate it by
      <with|mode|<quote|math>|B<rsub|2>\<assign\>P<around*|(|B<rsub|1>|)>>|<pageref|auto-13>>

      <tuple|normal|BT, block tree|is the union of all different versions of
      the blockchain observed by all the nodes in the system such as every
      such block is a node in the graph and
      <with|mode|<quote|math>|B<rsub|1>> is connected to
      <with|mode|<quote|math>|B<rsub|2>> if
      <with|mode|<quote|math>|B<rsub|1>> is a parent of
      <with|mode|<quote|math>|B<rsub|2>>|<pageref|auto-15>>

      <tuple|normal|PBT, Pruned BT|Pruned Block Tree refers to a subtree of
      the block tree obtained by eliminating all branches which do not
      contain the most recent finalized blocks, as defined in Definition
      <reference|defn-finalized-block>.|<pageref|auto-16>>

      <tuple|normal|pruning||<pageref|auto-17>>

      <tuple|normal|G|is the root of the block tree and B is one of its
      nodes.|<pageref|auto-18>>

      <tuple|normal|CHAIN(B)|refers to the path graph from
      <with|mode|<quote|math>|G> to <with|mode|<quote|math>|B> in
      (P)<with|mode|<quote|math>|BT>.|<pageref|auto-19>>

      <tuple|normal|head of C|defines the head of C to be
      <with|mode|<quote|math>|B>, formally noted as
      <with|mode|<quote|math>|B\<assign\>><with|font-shape|<quote|small-caps>|Head(<with|mode|<quote|math>|C>)>.|<pageref|auto-20>>

      <tuple|normal|<with|mode|<quote|math>|<around*|\||C|\|>>|defines he
      length of <with|mode|<quote|math>|C >as a path graph|<pageref|auto-21>>

      <tuple|normal|SubChain(<with|mode|<quote|math>|B<rprime|'>,B>)|If
      <with|mode|<quote|math>|B<rprime|'>> is another node on
      <with|font-shape|<quote|small-caps>|Chain(<with|mode|<quote|math>|B>)>,
      then by <with|font-shape|<quote|small-caps>|SubChain(<with|mode|<quote|math>|B<rprime|'>,B>)>
      we refer to the subgraph of <with|mode|<quote|math>|><with|font-shape|<quote|small-caps>|Chain(<with|mode|<quote|math>|B>)>
      path graph which contains both <with|mode|<quote|math>|B> and
      <with|mode|<quote|math>|B<rprime|'>>.|<pageref|auto-22>>

      <tuple|normal|<with|mode|<quote|math>|\<bbb-C\><rsub|B<rprime|'>><around*|(|<around*|(|P|)>BT|)>>|is
      the set of all subchains of <with|mode|<quote|math>|<around*|(|P|)>BT>
      rooted at <with|mode|<quote|math>|B<rprime|'>>.|<pageref|auto-23>>

      <tuple|normal|<with|mode|<quote|math>|\<bbb-C\>>|the set of all chains
      of <with|mode|<quote|math>|<around*|(|P|)>BT>,
      <with|mode|<quote|math>|\<bbb-C\><rsub|G><around*|(|<around*|(|*P|)>BT|)>>
      is denoted by <with|mode|<quote|math>|\<bbb-C\>>((P)BT) or simply
      <with|mode|<quote|math>|\<bbb-C\>>|<pageref|auto-24>>

      <tuple|normal|LONGEST-CHAIN(BT)|the maximum chain given by the complete
      order over <with|mode|<quote|math>|\<bbb-C\>>|<pageref|auto-25>>

      <tuple|normal|LONGEST-PATH(BT)|the path graph of
      <with|mode|<quote|math>|<around*|(|P|)>BT> which is the longest among
      all paths in <with|mode|<quote|math>|<around*|(|P|)>BT> and has the
      earliest block arrival time as defined in Definition
      <reference|defn-block-time>.|<pageref|auto-26>>

      <tuple|normal|DEEPEST-LEAF(BT)|the head of
      LONGEST-PATH(BT)|<pageref|auto-27>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Background>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      1.1<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      1.2<space|2spc>Definitions and Conventions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      <with|par-left|<quote|1tab>|1.2.1<space|2spc>Block Tree
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>
    </associate>
  </collection>
</auxiliary>