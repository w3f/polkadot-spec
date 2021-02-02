<TeXmacs|1.99.16>

<project|host-spec.tm>

<style|<tuple|book|old-dots|old-lengths|algorithmacs-style>>

<\body>
  <chapter|Consensus><label|chap-consensu>

  Consensus in the Polkadot Host is achieved during the execution of two
  different procedures. The first procedure is block production and the
  second is finality. The Polkadot Host must run these procedures, if and
  only if it is running on a validator node.

  <section|Common Consensus Structures>

  <subsection|Consensus Authority Set><label|sect-authority-set>

  Because Polkadot is a proof-of-stake protocol, each of its consensus engine
  has its own set of nodes, represented by known public keys which have the
  authority to influence the protocol in pre-defined ways explained in this
  section. In order to verifiy the validity of each block, Polkadot node must
  track the current list of authorities for that block as formalised in
  Definition <reference|defn-authority-list>

  <\definition>
    <label|defn-authority-list>The <strong|authority list> of block
    <math|<math-it|B>> for consensus engine <math|C> noted as
    <strong|<math|Auth<rsub|C><around*|(|B|)>>> is an array which contains
    the following pair of types for each of it authorities
    <math|A\<in\>Auth<rsub|C><around*|(|B|)> >:

    <\equation*>
      <around*|(|pk<rsub|A>,w<rsub|A>|)>
    </equation*>

    <math|pk<rsub|A>> is the session public key of authority A as defined in
    Definition <reference|defn-session-key>. And <math|w<rsub|A>> is a
    <verbatim|u64> value, indicating the authority weight. The value of
    <math|Auth<rsub|C><around*|(|B|)>> is part of the Polkadot state. The
    value for <math|Auth<rsub|C><around*|(|B<rsub|0>|)>> is set in the
    genesis state (see Section <reference|sect-genesis-block>) and can be
    retrieved using a runtime entery corresponding to consensus engine
    <math|C>.
  </definition>

  <\remark>
    In Polkadot, all authorities have the weight <math|w<rsub|A><rsub|>=1>.
    The weight <math|w<rsub|A>> in Definition <reference|defn-authority-list>
    exists for potential improvements in the protocol and could have a
    use-case in the future.
  </remark>

  <subsection|Runtime-to-Consensus Engine
  Message><label|sect-consensus-message-digest>

  The authority list (see Definition <reference|defn-authority-list>) is part
  of the Polkadot state and the Runtime has the authority to update this list
  in the course of any state transitions. The Runtime informs the
  corresponding consensus engine about the changes in the authority set by
  adding the appropiate consensus message as defined in Definition
  <reference|defn-consensus-message-digest>, in form of a digest item to the
  block header of the block <math|B> which caused the transition in the
  authority set.\ 

  <\definition>
    <label|defn-consensus-message-digest> Consensus Message is digest item of
    type 4 as defined in Definition <reference|defn-digest> and consists of
    the pair:

    <\equation*>
      <around*|(|E<rsub|id>,CM|)>
    </equation*>

    Where <math|E<rsub|id>\<in\>\<bbb-B\><rsub|4>> is the consensus engine
    unique identifier which can hold the following possible values

    \;

    <\equation*>
      E<rsub|id>\<assign\><around*|{|<tabular*|<tformat|<table|<row|<cell|<rprime|''>BABE<rprime|''>>|<cell|>|<cell|For
      messages related to BABE protocol refered to as
      E<rsub|id><around*|(|BABE|)>>>|<row|<cell|<rprime|''>FRNK<rprime|''>>|<cell|>|<cell|For
      messages related to GRANDPA protocol referred to as
      E<rsub|id><around*|(|FRNK|)>>>>>>|\<nobracket\>>
    </equation*>

    and CM is of varying data type which can hold one of the type described
    in Table <reference|tabl-consensus-messages-babe> or
    <reference|tabl-consensus-messages-grandpa>:

    <\center>
      <\small-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-tborder|0ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|1|2|2|cell-tborder|0ln>|<cwith|1|-1|2|2|cell-lborder|1ln>|<cwith|1|-1|1|1|cell-rborder|1ln>|<cwith|1|-1|2|2|cell-rborder|1ln>|<table|<row|<cell|<strong|Type
      Id>>|<cell|<strong|Type>>|<cell|<strong|Sub-components>>>|<row|<cell|1>|<cell|Next
      Epoch Data>|<cell|<math|<around*|(|Auth<rsub|BABE>,\<cal-R\>|)>>>>|<row|<cell|2>|<cell|On
      Disabled>|<cell|<math|Auth<rsub|ID>>>>|<row|<cell|3>|<cell|Next Config
      Data>|<cell|<math|<around*|(|c,s<rsub|2nd><rsup|>|)>>>>>>>>
        <label|tabl-consensus-messages-babe>The consensus digest item for
        BABE authorities
      </small-table>
    </center>

    Where:

    <\itemize-minus>
      <item>Auth<math|<rsub|BABE>> is the authority list for the next epoch,
      as defined in definition <reference|defn-authority-list>.

      <item><math|\<cal-R\>> is the 32-byte randomness seed for the next
      epoch, as defined in definition <reference|defn-epoch-randomness>

      <item><math|Auth<rsub|ID>> is an unsigned 64-bit integer pointing to an
      individual authority in the current authority list.

      <item><math|c> is the probability that a slot will not be empty, as
      defined in definition <reference|defn-babe-constant>. It is encoded as
      a tuple of two unsigned 64 bit integers
      <math|<around*|(|c<rsub|nominator>,c<rsub|denominator>|)>> which are
      used to compute the rational <math|c=<frac|c<rsub|nominator>|c<rsub|denominator>>>.

      <item><math|s<rsub|2nd>> is the the second slot configuration encoded
      as a 8-bit enum.\ 
    </itemize-minus>

    <\center>
      <\small-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-tborder|0ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|1|2|2|cell-tborder|0ln>|<cwith|1|-1|2|2|cell-lborder|1ln>|<cwith|1|-1|1|1|cell-rborder|1ln>|<cwith|1|-1|2|2|cell-rborder|1ln>|<table|<row|<cell|<strong|Type
      Id>>|<cell|<strong|Type>>|<cell|<strong|Sub-components>>>|<row|<cell|1>|<cell|Scheduled
      Change>|<cell|<math|<around*|(|Auth<rsub|C>,N<rsub|delay>|)>>>>|<row|<cell|2>|<cell|Forced
      Change>|<cell|<math|<around*|(|Auth<rsub|C>,N<rsub|delay>|)>>>>|<row|<cell|3>|<cell|On
      Disabled>|<cell|<math|Auth<rsub|ID>>>>|<row|<cell|4>|<cell|Pause>|<cell|<math|N<rsub|delay>>>>|<row|<cell|5>|<cell|Resume>|<cell|N<math|<rsub|delay>>>>>>>>
        <label|tabl-consensus-messages-grandpa>The consensus digest item for
        GRANDPA authorities
      </small-table>
    </center>

    Where:

    <\itemize-minus>
      <item>Auth<math|<rsub|C>> is the authority list as defined in
      definition <reference|defn-authority-list>.

      <item><math|N<rsub|delay>\<assign\><around*|\|||\<nobracket\>>><name|SubChain><math|<around*|(|B,B<rprime|'>|)><around*|\|||\<nobracket\>>>
      is an unsigned 32-bit integer indicating the length of the subchain
      starting at <math|B>, the block containing the consensus message in its
      header digest and ending when it reaches <math|N<rsub|delay>> length as
      a path graph. The last block in that subchain, <math|B<rprime|'>>,
      depending on the message type, is either finalized or imported (and
      therefore validated by the block production consensus engine according
      to Algorithm <reference|algo-import-and-validate-block>. see below for
      details).

      <item><math|Auth<rsub|ID>> is an unsigned 64-bit integer pointing to an
      individual authority in the current authority list.
    </itemize-minus>
  </definition>

  The Polkadot Host should inspect the digest header of each block and
  delegate consesus messages to their consensus engines.

  The BABE consensus engine should react based on the type of consensus
  messages it receives as follows:

  <\itemize-minus>
    <item><with|font-series|bold|Next Epoch Data:> The runtime issues this
    message on every first block of an epoch <math|\<cal-E\><rsub|n>>. The
    supplied authority set and randomness is intended to be used in next
    epoch <math|\<cal-E\><rsub|n+1>>. \ 

    <item><strong|On Disabled>: An index to the individual authority in the
    current authority list that should be immediately disabled until the next
    authority set change. When an authority gets disabled, the node should
    stop performing any authority functionality for that authority, including
    authoring blocks. Similarly, other nodes should ignore all messages from
    the indicated authority which pretain to their authority role.\ 

    <item><with|font-series|bold|Next Config Data:> These messages are only
    issued on configuration change and in the first block of an epoch. The
    supplied configuration data are intended to be used from the next epoch
    onwards.\ 
  </itemize-minus>

  The GRANDPA consensus engine should react based on the type of consensus
  messages it receives as follows:

  <\itemize-minus>
    \ <item><strong|Scheduled Change>: Schedule an authority set change after
    the given delay of <math|N<rsub|delay>\<assign\><around*|\|||\<nobracket\>>><name|SubChain><math|<around*|(|B,B<rprime|'>|)><around*|\|||\<nobracket\>>>
    where <math|B<rprime|'>> in the definition of <math|N<rsub|delay>>, is a
    block <em|finalized> by the finality consensus engine. The earliest
    digest of this type in a single block will be respected. No change should
    be scheduled if one is already and the delay has not passed completely.
    If such an inconsitency occures, the scheduled change should be ignored.

    <item><strong|Forced Change>: Force an authority set change after the
    given delay of <math|N<rsub|delay>\<assign\><around*|\|||\<nobracket\>>><name|SubChain><math|<around*|(|B,B<rprime|'>|)><around*|\|||\<nobracket\>>>
    where <math|B<rprime|'>> in the definition of <math|N<rsub|delay>>, is an
    <em|imported> block which has been validated by the block production
    conensus engine. Hence, the authority change set is valid for every
    subchain which contains <em|B> and where the delay has been exceeded. If
    one or more blocks gets finalized before the change takes effect, the
    authority set change should be disregarded. The earliest digest of this
    type in a single block will be respected. No change should be scheduled
    if one is already and the delay has not passed completely. If such an
    inconsitency occures, the scheduled change should be ignored.

    <item><strong|On Disabled>: An index to the individual authority in the
    current authority list that should be immediately disabled until the next
    authority set change. When an authority gets disabled, the node should
    stop performing any authority functionality from that authority,
    including authoring blocks and casting GRANDPA votes for finalization.
    Similarly, other nodes should ignore all messages from the indicated
    authority which pretain to their authority role.\ 

    <item><strong|Pause>: A signal to pause the current authority set after
    the given delay of <math|N<rsub|delay>\<assign\><around*|\|||\<nobracket\>>><name|SubChain><math|<around*|(|B,B<rprime|'>|)><around*|\|||\<nobracket\>>>
    where <math|B<rprime|'>> in the definition of <math|N<rsub|delay>>, is a
    block <em|finalized> by the finality consensus engine. After finalizing
    block <math|B<rprime|'>>, the authorities should stop voting.

    <item><strong|Resume>: A signal to resume the current authority set after
    the given delay of <math|N<rsub|delay>\<assign\><around*|\|||\<nobracket\>>><name|SubChain><math|<around*|(|B,B<rprime|'>|)><around*|\|||\<nobracket\>>>
    where <math|B<rprime|'>> in the definition of <math|N<rsub|delay>>, is an
    <em|imported> block and validated by the block production consensus
    engine. After authoring the block <math|B<rprime|'>>, the authorities
    should resume voting.
  </itemize-minus>

  The active GRANDPA authorities can only vote for blocks that occured after
  the finalized block in which they were selected. Any votes for blocks
  before the <verbatim|Scheduled Change> came into effect get rejected.

  <section|Block Production><label|sect-babe><label|sect-block-production>

  The Polkadot Host uses BABE protocol <cite|w3f_research_group_blind_2019>
  for block production. It is designed based on Ouroboros praos
  <cite|david_ouroboros_2018>. BABE execution happens in sequential
  non-overlapping phases known as an <strong|<em|epoch>>. Each epoch on its
  turn is divided into a predefined number of slots. All slots in each epoch
  are sequentially indexed starting from 0. At the beginning of each epoch,
  the BABE node needs to run Algorithm <reference|algo-block-production-lottery>
  to find out in which slots it should produce a block and gossip to the
  other block producers. In turn, the block producer node should keep a copy
  of the block tree and grow it as it receives valid blocks from other block
  producers. A block producer prunes the tree in parallel by eliminating
  branches which do not include the most recent finalized blocks according to
  Definition <reference|defn-pruned-tree>.

  <subsection|Preliminaries>

  <\definition>
    A <strong|block producer>, noted by <math|\<cal-P\><rsub|j>>, is a node
    running the Polkadot Host which is authorized to keep a transaction queue
    and which gets a turn in producing blocks.
  </definition>

  <\definition>
    <strong|Block authoring session key pair
    <math|<around*|(|sk<rsup|s><rsub|j>,pk<rsup|s><rsub|j>|)>>> is an SR25519
    key pair which the block producer <math|\<cal-P\><rsub|j>> signs by their
    account key (see Definition <reference|defn-account-key>) and is used to
    sign the produced block as well as to compute its lottery values in
    Algorithm <reference|algo-block-production-lottery>.\ 
  </definition>

  <\definition>
    <label|defn-epoch-slot>A block production <strong|epoch>, formally
    referred to as <math|\<cal-E\>>, is a period with pre-known starting time
    and fixed length during which the set of block producers stays constant.
    Epochs are indexed sequentially, and we refer to the <math|n<rsup|th>>
    epoch since genesis by <math|\<cal-E\><rsub|n>>. Each epoch is divided
    into <math|>equal length periods known as block production
    <strong|slots>, sequentially indexed in each epoch. The index of each
    slot is called <strong|slot number>. The equal length duration of each
    slot is called the <strong|slot duration> and indicated by
    <math|\<cal-T\>>. Each slot is awarded to a subset of block producers
    during which they are allowed to generate a block.
  </definition>

  <\remark>
    Substrate refers to an epoch as \Psession\Q in some places, however epoch
    should be the prefered and official name for these periods.
  </remark>

  <\notation>
    <label|note-slot>We refer to the number of slots in epoch
    <math|\<cal-E\><rsub|n>> by <math|sc<rsub|n>>. <math|sc<rsub|n>> is set
    to the <verbatim|duration> field in the returned data from the call of
    the Runtime entry <verbatim|BabeApi_configuration> (see
    <reference|sect-rte-babeapi-epoch>) at genesis. For a given block
    <math|B>, we use the notation <strong|<math|s<rsub|B>>> to refer to the
    slot during which <math|B> has been produced. Conversely, for slot
    <math|s>, <math|\<cal-B\><rsub|s>> is the set of Blocks generated at slot
    <math|s>.
  </notation>

  Definition <reference|defn-epoch-subchain> provides an iterator over the
  blocks produced during a specific epoch.

  <\definition>
    <label|defn-epoch-subchain> By <name|SubChain(<math|\<cal-E\><rsub|n>>)>
    for epoch <math|\<cal-E\><rsub|n>>, we refer to the path graph of
    <math|BT> which contains all the blocks generated during the slots of
    epoch <math|\<cal-E\><rsub|n>>. When there is more than one block
    generated at a slot, we choose the one which is also on
    <name|Longest-Chain(<math|BT>)>.
  </definition>

  <subsection|Block Production Lottery>

  <\definition>
    <label|defn-babe-constant>The <with|font-series|bold|BABE constant>
    <math|<with|font-series|medium|c>\<in\><around*|(|0,1<rsub|>|)>> is the
    probability that a slot will not be empty and used in the winning
    threshold calculation (see Definition
    <reference|defn-winning-threshold>).
  </definition>

  The babe constant (Definition <reference|defn-babe-constant>) is
  initialized at genesis to the value returned by calling
  <verbatim|BabeApi_configuration> (see <reference|sect-rte-babeapi-epoch>).
  For efficiency reasons it is generally updated by the runtime through the
  \PNext Config Data\Q consensus message (see Definition
  <reference|defn-consensus-message-digest>) in the digest of the first block
  of an epoch for the next epoch.\ 

  <\definition>
    <label|defn-winning-threshold><strong|Winning threshold> denoted by
    <strong|<math|\<tau\><rsub|\<varepsilon\><rsub|n>>>> is the threshold
    which is used alongside with the result of Algorirthm
    <reference|algo-block-production-lottery> to decide if a block producer
    is the winner of a specific slot. <math|\<tau\><rsub|\<varepsilon\><rsub|n>>>
    is calculated \ as follows:

    <\equation*>
      \<tau\><rsub|\<varepsilon\><rsub|n>>\<assign\>1-<around*|(|1-c|)><rsup|<frac|1|<around*|\||AuthorityDirectory<rsup|\<cal-E\><rsub|n>>|\|>>>
    </equation*>

    where <math|AuthorityDirectory<rsup|\<cal-E\><rsub|n>>> is the set of
    BABE authorities for epoch <math|\<varepsilon\><rsub|n>> and
    <math|c\<in\><around*|(|0,1|)>> is the BABE constant as defined in
    definition <reference|defn-babe-constant>.
  </definition>

  \ A block producer aiming to produce a block during
  <math|\<cal-E\><rsub|n>> should run Algorithm
  <reference|algo-block-production-lottery> to identify the slots it is
  awarded. These are the slots during which the block producer is allowed to
  build a block. The <math|sk> is the block producer lottery secret key and
  <math|n> is the index of epoch for whose slots the block producer is
  running the lottery.

  <\algorithm>
    <label|algo-block-production-lottery><name|Block-production-lottery>(<math|sk:>session
    secret key of the producer,

    <math|n:>epoch index)
  <|algorithm>
    <\algorithmic>
      <\state>
        <math|r\<leftarrow\>><name|Epoch-Randomness<math|<around*|(|n|)>>>
      </state>

      <\state>
        <FOR-TO|<math|i\<assign\>1>|<math|sc<rsub|n>>>
      </state>

      <\state>
        <math|<around*|(|\<pi\>,d|)>\<leftarrow\>><em|<name|VRF>>(<math|r,i,sk>)
      </state>

      <\state>
        <math|A<around*|[|i|]>\<leftarrow\><around*|(|d,\<pi\>|)>><END>
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
  <name|Epoch-Randomness<math|>> and <em|<name|VRF>> functions, see Section
  <reference|sect-epoch-randomness> and Section <reference|sect-vrf>
  respectively.

  <subsection|Slot Number Calculation>

  <\definition>
    <label|defn-slot-offset>Let <math|s<rsub|i>> and <math|s<rsub|j>> be two
    slots belonging to epochs <math|\<cal-E\><rsub|k>> and
    <math|\<cal-E\><rsub|l>>. By <with|font-series|bold|<name|Slot-Offset><math|<around*|(|s<rsub|i>,s<rsub|j>|)>>>
    we refer to the function whose value is equal to the number of slots
    between <math|s<rsub|i>> and <math|s<rsub|j>> (counting <math|s<rsub|j>>)
    on time continuum. As such, we have <name|Slot-Offset><math|<around*|(|s<rsub|i>,s<rsub|i>|)>=0>.
  </definition>

  It is imperative for the security of the network that each block producer
  correctly determine the current slots number at a given time by regularly
  estimating the local clock offset in relation to the network (Definition
  <reference|defn-relative-syncronization>).\ 

  <\definition>
    <label|defn-relative-syncronization>The <with|font-series|bold|relative
    time syncronization> is a tuple of a slot number and local clock
    timestamp <math|<around*|(|s<rsub|sync>, t<rsub|sync>|)>> describing the
    last point at which slot numbers have been syncronized with the local
    clock.
  </definition>

  <\algorithm>
    <with|font-shape|small-caps|Slot-Time(<with|font-shape|right|<math|s:>
    slot number>)>
  <|algorithm>
    <\algorithmic>
      <\state>
        <\RETURN>
          <with|font-shape|small-caps|<math|t<rsub|sync>+>Slot-Offset>(<math|><math|s<rsub|sync>>,
          <math|s>)<math|\<times\>\<cal-T\>>
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  <\note>
    <with|font-series|bold|The calculation described in this section is still
    to be implemented and deployed.> For now each block producer is required
    to syncronize its local clock using NTP instead. The current slot
    <math|s> is then calculated by <math|s<rsub|>=t<rsub|unix>/\<cal-T\>>
    where <math|t<rsub|unix>> is the current unix time in seconds since
    1970-01-01 00:00:00 UTC. That also entails that slot numbers are
    currently not reset at the beginning of each epoch.\ 
  </note>

  Polkadot does this syncronization without relying on any external clock
  source (e.g. through the <with|font-shape|italic|Network Time Protocol> or
  the <with|font-shape|italic|Global Positioning System>). To stay in
  synchronization each producer is therefore required to periodically
  estimate its local clock offset in relation to the rest of the network.\ 

  This estimation depends on the two fixed parameters
  <with|font-series|bold|<math|k>> (Definition <reference|defn-prunned-best>)
  and <math|<with|font-series|bold|s<rsub|cq>>> (Definition
  <reference|defn-chain-quality>). These are choosen based on the results of
  formal security analysis, currently assuming a <math|1 s \ >clock drift per
  day and targeting a probability lower than <math|0.5%> for an adversary to
  break BABE in 3 years with a resistance against network delay up to
  <math|<frac*|1|3>> of the slot time and a Babe constant
  (Definit<line-break>wion <reference|defn-babe-constant>) of <math|c=0.38>.

  <\definition>
    <label|defn-prunned-best>The <with|font-series|bold|prunned best chain>
    <math|<with|font-series|bold|C<rsup|\<#250C\>k>>> is the longest chain
    selected according to Definition <reference|defn-longest-chain> with the
    last k Blocks prunned. We choose <math|k=140>. The
    <with|font-series|bold|last (probabilistically) finalized block>
    describes the last block in this prunned best chain.
  </definition>

  <\definition>
    <label|defn-chain-quality>The <with|font-series|bold|chain quality>
    <math|<with|font-series|bold|s<rsub|cq>>> represents the number of slots
    that are used to estimate the local clock offset. Currently it is set to
    <math|s<rsub|cq>=3000>.
  </definition>

  The prerequisite for such a calculation is that each producer stores the
  arrival time of each block (Definition <reference|defn-block-time>)
  measured by a clock that is otherwise not adjusted by any external
  protocol.\ 

  <\definition>
    <label|defn-block-time>The <strong|block arrival time> of block <math|B>
    for node <math|j> formally represented by
    <strong|<math|T<rsup|j><rsub|B>>> is the local time of<verbatim|> node
    <math|j> when node <math|j> has received the block <math|B> for the first
    time. If the node <math|j> itself is the producer of <math|B>,
    <math|T<rsub|B><rsup|j>> is set equal to the time that the block is
    produced. The index <math|j> in <math|T<rsup|j><rsub|B>> notation may be
    dropped and B's arrival time is referred to by <math|T<rsub|B>> when
    there is no ambiguity about the underlying node.
  </definition>

  <todo|Currently still lacks a clean definition of when block arrival times
  are considered valid and how to differentiated imported block on intial
  sync from \Pfresh\Q blocks that were just produced.>

  <\definition>
    <label|defn-sync-period>A <with|font-series|bold|sync period> is the
    interval at which each validator (re-)evaluates its local clock offsets.
    The first sync period <math|\<frak-E\><rsub|1>> starts just after the
    genesis block is released. Consequently each sync period
    <math|\<frak-E\><rsub|i>> starts after <math|\<frak-E\><rsub|i-1>>. The
    length of sync period is equal to <math|s<rsub|qc>> as defined in
    Definition <reference|defn-chain-quality> and expressed in number of
    slots.
  </definition>

  All validators are then required to run Algorithm
  <reference|algo-slot-time> at beginning of each sync period (Definition
  <reference|defn-sync-period>) to update their synchronization using all
  block arrival times of the previous period. The algorithm should only be
  run once all the blocks in this period have been finalized, even if only
  probabilistically (Definition <reference|defn-prunned-best>). The target
  slot to which to synchronize should be the first slot in the new sync
  period.

  <\algorithm>
    <label|algo-slot-time><name|Median-Algorithm>(<math|\<frak-E\><rsub|j>>:
    sync period used for estimate, <math|s<rsub|sync>:> slot time to
    estimate)
  <|algorithm>
    <\algorithmic>
      <\state>
        <math|T<rsub|s>\<leftarrow\><around*|{||}>>
      </state>

      <\state>
        <FOR-IN|<math|B<rsub|i>>|<math|\<frak-E\><rsub|j>><name|>>
      </state>

      <\state>
        <name|<math|t<rsub|estimate><rsup|B<rsub|i>>\<leftarrow\>T<rsup|><rsub|B<rsub|i>>>+Slot-Offset(<math|s<rsub|B<rsub|i>>,s<rsub|sync>>)<math|\<times\>\<cal-T\><rsub|>>>
      </state>

      <\state>
        <math|T<rsub|s>\<leftarrow\>T<rsub|s>\<cup\>><math|t<rsub|estimate><rsup|B<rsub|i>>><END>
      </state>

      <\state>
        <\RETURN>
          Median(<math|T<rsub|s>>)
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  \ <math|\<cal-T\>> is the slot duration defined in Definition
  <reference|defn-epoch-slot>.

  <\big-figure|<image|figures/babe_time_sync.eps|1par|||>>
    Examplary result of Median Algorithm in first sync epoch with
    <math|s<rsub|cq>=9> and <math|k=1>.
  </big-figure>

  <subsection|Block Production>

  Throughout each epoch, each block producer should run Algorithm
  <reference|algo-block-production> to produce blocks during the slots it has
  been awarded during that epoch. The produced block needs to carry <em|BABE
  header> as well as the <em|block signature> as Pre-Runtime and Seal digest
  items defined in Definition <reference|defn-babe-header> and
  <reference|defn-block-signature> respectively.

  <\definition>
    <label|defn-babe-header>The <strong|BABE Header> of block B, referred to
    formally by <strong|<math|H<rsub|BABE><around*|(|B|)>>> is a tuple that
    consists of the following components:

    <\equation*>
      <around*|(|d,\<pi\>,j,s|)>
    </equation*>

    in which:

    <\with|par-mode|center>
      <tabular|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|3|3|1|1|cell-halign|r>|<table|<row|<cell|<math|\<pi\>,d>:>|<cell|are
      the results of the block lottery for slot s.
      >>|<row|<cell|<math|j>:>|<cell|is index of the block producer producing
      block in the current authority directory of current epoch.
      >>|<row|<cell|s:>|<cell|is the slot at which the block is
      produced.>>>>>

      \;
    </with>

    \;

    <math|H<rsub|BABE><around*|(|B|)>> must be included as a digest item of
    Pre-Runtime type in the header digest <math|H<rsub|d><around*|(|B|)>> as
    defined in Definition <reference|defn-digest>.\ 
  </definition>

  <\definition>
    <label|defn-block-signature><label|defn-babe-seal>The <strong|Block
    Signature> <math|S<rsub|B>> is a signature of the block header hash (see
    Definition<reference|defn-block-header-hash>) and defined as

    <\equation*>
      Sig<rsub|SR25519,sk<rsup|s><rsub|j>><around*|(|H<rsub|h><around*|(|B|)>|)>
    </equation*>

    \ <math|S<rsub|B>> should be included in <math|H<rsub|d><around*|(|B|)>>
    as the Seal digest item according to Definition <reference|defn-digest>
    of value:

    <\equation*>
      <around*|(|E<rsub|id><around*|(|BABE|)>,S<rsub|B>|)>
    </equation*>

    in which, <math|E<rsub|id><around*|(|BABE|)>> is the BABE consensus
    engine unique identifier defined in Section
    <reference|sect-msg-consensus>. The Seal digest item is referred to as
    <strong|BABE Seal>.

    \;
  </definition>

  <\algorithm|<label|algo-block-production><verbatim|><name|Invoke-Block-Authoring>(<math|sk>,
  pk, <math|n>, <math|BT:Current Block Tree>)>
    <\algorithmic>
      <\state>
        <math|A\<leftarrow\>><name|Block-production-lottery(<math|sk>,
        <math|n>)>
      </state>

      <\state>
        <FOR-TO|<\math>
          s\<leftarrow\>1
        </math>|<math|sc<rsub|n>>>
      </state>

      <\state>
        <name|Wait>(<strong|until> <name|Slot-Time>(s))
      </state>

      <\state>
        <math|<around*|(|d,\<pi\>|)>\<leftarrow\>A<around*|[|s|]>>
      </state>

      <\state>
        <\IF>
          <math|d\<less\>\<tau\>>
        </IF>
      </state>

      <\state>
        <math|C<rsub|Best>\<leftarrow\>><name|Longest-Chain>(BT)
      </state>

      <\state>
        <name|<math|B<rsub|s>\<leftarrow\>>Build-Block(<math|C<rsub|Best>>)>
      </state>

      <\state>
        <name|Add-Digest-Item>(<math|B<rsub|s>>,Pre-Runtime,<math|E<rsub|id><around*|(|BABE|)>,H<rsub|BABE><around*|(|B<rsub|s>|)>>)
      </state>

      <\state>
        <name|Add-Digest-Item>(<math|B<rsub|s>>,Seal,<math|S<rsub|B>>)
      </state>

      <\state>
        <name|Broadcast-Block>(<math|B<rsub|s>>)
      </state>
    </algorithmic>
  </algorithm>

  <name|Add-Digest-Item> appends a digest item to the end of the header
  digest <math|H<rsub|d><around*|(|B|)>> according to Definition
  <reference|defn-digest>.

  <subsection|Epoch Randomness><label|sect-epoch-randomness>

  <\definition>
    <label|defn-epoch-randomness>For epoch <math|\<cal-E\>> there is a
    32-byte <with|font-series|bold|randomness seed>
    <math|\<cal-R\><rsub|\<cal-E\>>> computed based on the previous epochs
    VRF outputs. For <math|\<cal-E\><rsub|0>> and <math|\<cal-E\><rsub|1>>,
    the randomness seed is provided in the genesis state.
  </definition>

  In the beginning of each epoch <math|\<cal-E\><rsub|n>> the host will
  receive the randomness seed <math|\<cal-R\><rsub|\<cal-E\><rsub|n+1>>>(Definition
  <reference|defn-epoch-randomness>) necessary to participate in the block
  production lottery in the next epoch <math|\<cal-E\><rsub|n+1>> from the
  runtime, through the <with|font-shape|italic|Next Epoch Data> consesus
  message (Definition <reference|defn-consensus-message-digest>) in the
  digest of the first block.

  <subsection|Verifying Authorship Right><label|sect-verifying-authorship>

  When a Polkadot node receives a produced block, it needs to verify if the
  block producer was entitled to produce the block in the given slot by
  running Algorithm <reference|algo-verify-authorship-right> where:

  <\itemize-minus>
    <item>T<math|<rsub|B>> is <math|B>'s arrival time defined in Definition
    <reference|defn-block-time>.

    <item><math|H<rsub|d><around*|(|B|)>> is the digest sub-component of
    <math|Head<around*|(|B|)>> defined in Definitions
    <reference|defn-block-header> and <reference|defn-digest>.

    <item>The Seal <math|D<rsub|s>> is the last element in the digest array
    <math|H<rsub|d><around*|(|B|)>> as defined in Definition
    <reference|defn-digest>.

    <item><name|Seal-Id> is the type index showing that a digest item of
    variable type is of <em|Seal> type (See Definitions
    <reference|defn-scale-variable-type> and <reference|defn-digest>)

    <item><math|AuthorityDirectory<rsup|\<cal-E\><rsub|c>>> is the set of
    Authority ID for block producers of epoch <math|\<cal-E\><rsub|c>>.

    <item><name|verify-Slot-Winner> is defined in Algorithm
    <reference|algo-verify-slot-winner>.
  </itemize-minus>

  <\algorithm>
    <label|algo-verify-authorship-right><name|Verify-Authorship-Right>(<math|Head<rsub|s><around*|(|B|)>>:
    The header of the block being verified)\ 
  <|algorithm>
    <\algorithmic>
      <\state>
        <math|s\<leftarrow\>><name|Slot-Number-At-Given-Time>(<math|T<rsub|B<rsub|>>>)
      </state>

      <\state>
        <math|\<cal-E\><rsub|c>\<leftarrow\>><name|Current-Epoch>()
      </state>

      <\state>
        <math|<around*|(|D<rsub|1>,\<ldots\>,D<rsub|length<around*|(|H<rsub|d><around*|(|B|)>|)>>|)>\<leftarrow\>H<rsub|d><around*|(|B|)>>
      </state>

      <\state>
        <math|D<rsub|s>\<leftarrow\>><math|D<rsub|length<around*|(|H<rsub|d><around*|(|B|)>|)>>>
      </state>

      <\state>
        <math|H<rsub|d><around*|(|B|)>\<leftarrow\><around*|(|D<rsub|1>,\<ldots\>,D<rsub|length<around*|(|H<rsub|d><around*|(|B|)>|)>-1>|)>>
        //remove the seal from the digest
      </state>

      <\state>
        (<math|id,Sig<rsub|B>>)<math|\<leftarrow\>Dec<rsub|SC><around*|(|D<rsub|s>|)>>
      </state>

      <\state>
        <\IF>
          <math|id\<neq\>><name|Seal-Id>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PSeal missing\Q<END>
        </ERROR>
      </state>

      <\state>
        AuthorID <math|\<leftarrow\>AuthorityDirectory<rsup|\<cal-E\><rsub|c>><around*|[|H<rsub|BABE><around*|(|B|)>.SingerIndex|]>>
      </state>

      <\state>
        <name|Verify-Signature>(<math|AuthorID,H<rsub|h><around*|(|B|)>,Sig<rsub|B>>)
      </state>

      <\state>
        <\IF>
          <math|\<exists\>B<rprime|'>\<in\>BT:H<rsub|h><around*|(|B|)>\<neq\>H<rsub|h><around*|(|B|)>>
          <strong|and> <math|s<rsub|B>=s<rprime|'><rsub|B>> <strong|and>
          <math|><math|SignerIndex<rsub|B>=SignerIndex<rsub|B<rprime|'>>>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PBlock producer is equivocating\Q<END>
        </ERROR>
      </state>

      <\state>
        <name|Verify-Slot-Winner>(<math|<around*|(|d<rsub|B>,\<pi\><rsub|B>|)>,s>,AuthorID)
      </state>
    </algorithmic>
  </algorithm>

  Algorithm <reference|algo-verify-slot-winner> is run as a part of the
  verification process, when a node is importing a block, in which:

  <\itemize-minus>
    <item><name|Epoch-Randomness> is defined in Definition
    <reference|defn-epoch-randomness>.

    <item><math|H<rsub|BABE><around*|(|B|)>> is the BABE header defined in
    Definition <reference|defn-babe-header>.

    <item><name|Verify-VRF> is described in Section <reference|sect-vrf>.

    <item><math|\<tau\>> is the winning threshold defined in
    <reference|defn-winning-threshold>.
  </itemize-minus>

  <\algorithm>
    <label|algo-verify-slot-winner><name|Verify-Slot-Winner>(<math|B>: the
    block whose winning status to be verified)
  <|algorithm>
    <\algorithmic>
      <\state>
        <math|\<cal-E\><rsub|c>\<leftarrow\>><name|Current-Epoch>
      </state>

      <\state>
        <math|\<rho\>\<leftarrow\>><name|Epoch-Randomness><math|<around*|(|c|)>>
      </state>

      <\state>
        <name|Verify-VRF>(<math|\<rho\>,H<rsub|BABE><around*|(|B|)>.<around*|(|d<rsub|B>,\<pi\><rsub|B>|)>,H<rsub|BABE><around*|(|B|)>.s,c>)
      </state>

      <\state>
        <\IF>
          <math|d<rsub|B>\<geqslant\>\<tau\>>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PBlock producer is not a winner of the slot\Q<END>
        </ERROR>
      </state>
    </algorithmic>
  </algorithm>

  <math|<around*|(|d<rsub|B>,\<pi\><rsub|B>|)>><math|>: Block Lottery Result
  for Block <math|B>,\ 

  <math|s<rsub|n>>: the slot number,

  <math|n>: Epoch index

  AuthorID: The public session key of the block producer

  <subsection|Block Building Process><label|sect-block-building>

  The blocks building process is triggered by Algorithm
  <reference|algo-block-production> of the consensus engine which runs
  Alogrithm <reference|algo-build-block>.

  <\algorithm>
    <label|algo-build-block><name|Build-Block>(<math|C<rsub|Best>>: The chain
    where at its head, the block to be constructed,

    s: Slot number)
  <|algorithm>
    <\algorithmic>
      <\state>
        <math|P<rsub|B>\<leftarrow\><rsub|>><name|Head(<math|C<rsub|Best>>)>
      </state>

      <\state>
        <math|Head<around*|(|B|)>\<leftarrow\>>(<math|H<rsub|p>\<leftarrow\>H<rsub|h><rsub|><around*|(|P<rsub|B>|)>,H<rsub|i>\<leftarrow\>H<rsub|i><around*|(|P<rsub|B>|)>+1,H<rsub|r>\<leftarrow\>\<phi\>,H<rsub|e>\<leftarrow\>\<phi\>,H<rsub|d>\<leftarrow\>\<phi\>>)
      </state>

      <\state>
        <name|Call-Runtime-Entry><math|<around*|(|<text|<verbatim|Core_initialize_block>>,Head<around*|(|<rsub|>B|)>|)>>
      </state>

      <\state>
        <name|<em|I-D>> \<leftarrow\> <name|Call-Runtime-Entry><math|<around*|(|<text|<verbatim|BlockBuilder_inherent_extrinsics>>,<text|<name|Inherent-Data>>|)>><END>
      </state>

      <\state>
        <strong|for> <em|E> <strong|in> <em|I-D>
      </state>

      <\state>
        <space|2em><name|Call-Runtime-Entry>(<verbatim|BlockBuilder_apply_extrinsics,E>)
      </state>

      <\state>
        <\WHILE>
          <strong|not> <name|End-Of-Slot(s)>
        </WHILE>
      </state>

      <\state>
        <math|E\<leftarrow\>><name|Next-Ready-Extrinsic()>
      </state>

      <\state>
        <math|R\<leftarrow\>><name|Call-Runtime-Entry(><verbatim|BlockBuilder_apply_extrinsics>,<em|E>)
      </state>

      <\state>
        <strong|if> <name|Should-Requeue(R)>
      </state>

      <\state>
        <strong|<space|2em>continue>
      </state>

      <\state>
        <\IF>
          <strong|not> <name|Block-Is-FULL(<math|R>>)
        </IF>
      </state>

      <\state>
        <name|Drop(><em|E>)<END>
      </state>

      <\state>
        <\ELSE>
          \;
        </ELSE>
      </state>

      <\state>
        <BREAK><END><END>
      </state>

      <\state>
        <math|Head<around*|(|B|)>\<leftarrow\>><name|Call-Runtime-Entry(><verbatim|BlockBuilder_finalize_block>,<em|B>)
      </state>

      <\state>
        B \<leftarrow\> <name|Add-Seal>(B)
      </state>
    </algorithmic>
  </algorithm>

  <\itemize-minus>
    <item><math|Head<around*|(|B|)>> is defined in Definition
    <reference|defn-block-header>.

    <item><name|Call-Runtime-Entry> is defined in Notation
    <reference|nota-call-into-runtime>.

    <item><name|Inherent-Data> is defined in Definition
    <reference|defn-inherent-data>.

    <item><name|End-Of-Slot> indicates the end of the BABE slot as defined in
    Algorithm <reference|algo-slot-time> respectively Definition
    <reference|defn-epoch-slot>.

    <item><name|Next-Ready-Extrinsic> indicates picking an extrinsic from the
    extrinsics queue (Definition <reference|defn-transaction-queue>).

    <item><name|Block-Is-Full> indicates that the maximum block size as been
    used.

    <item><name|Should-Requeue> determines based on the result <em|R> whether
    the extrinsic should remain in the extrinsics queue and scheduled for the
    next block. The <verbatim|ApplyExtrinsicResult> as defined in Definition
    <reference|defn-rte-apply-extrinsic-result> describes this behavior in
    more detail.

    <item><name|Drop> indicates removing the extrinsic from the transaction
    queue (Definition <reference|defn-transaction-queue>).

    <item><name|Add-Seal> adds the seal to the block as defined in Definition
    <reference|defn-digest> before sending it to peers. The seal is removed
    again before submitting it to the Runtime.
  </itemize-minus>

  <section|Finality><label|sect-finality>

  The Polkadot Host uses GRANDPA Finality protocol
  <cite|stewart_grandpa:_2019> to finalize blocks. Finality is obtained by
  consecutive rounds of voting by validator nodes. Validators execute GRANDPA
  finality process in parallel to Block Production as an independent service.
  In this section, we describe the different functions that GRANDPA service
  performs to successfully participate in the block-finalization process.

  <subsection|Preliminaries>

  <\definition>
    <label|defn-grandpa-voter>A <strong|GRANDPA Voter>, <math|v>, is
    represented by a key pair <math|<around|(|k<rsup|pr><rsub|v>,v<rsub|id>|)>>
    where <math|k<rsub|v><rsup|pr>> represents its private key which is an
    <math|ED25519> private key, is a node running GRANDPA protocol and
    broadcasts votes to finalize blocks in a Polkadot Host-based chain. The
    <strong|set of all GRANDPA voters> for a given block B is indicated by
    <math|\<bbb-V\><rsub|B>>. In that regard, we have <todo|change function
    name, only call at genesis, adjust V_B over the sections>

    <\equation*>
      \<bbb-V\><rsub|B>=<text|<verbatim|grandpa_authorities>><around*|(|B|)>
    </equation*>

    where <math|<math-tt|grandpa_authorities>> is the entry into Runtime
    described in Section <reference|sect-rte-grandpa-auth>. We refer to
    <math|\<bbb-V\><rsub|B> > as <math|\<bbb-V\>> when there is no chance of
    ambiguity.
  </definition>

  <\definition>
    <label|defn-authority-set-id>The <strong|authority set Id>
    (<math|id<rsub|\<bbb-V\>>>) is an incremental counter which tracks the
    amount of authority list (Definition <reference|defn-consensus-message-digest>)
    changes that occurred. Starting with the value of zero at genesis, the
    Polkadot Host increments this value by one every time a <strong|Scheduled
    Change> or a <strong|Forced Change> occurs. The authority set Id is an
    unsigned 64bit integer.
  </definition>

  <\definition>
    <strong|GRANDPA state>, <math|GS>, is defined as <todo|verify V_id and
    id_V usage, unify>

    <\equation*>
      GS\<assign\><around|{|\<bbb-V\>,id<rsub|\<bbb-V\>>,r|}>
    </equation*>

    where:

    <math|<math-bf|\<bbb-V\>>>: is the set of voters.

    <math|<math-bf|id<rsub|\<bbb-V\>>>>: is the authority set ID as defined
    in Definition <reference|defn-authority-set-id>.

    <strong|r>: is the votin<verbatim|>g round number.
  </definition>

  Following, we need to define how the Polkadot Host counts the number of
  votes for block <math|B>. First a vote is defined as:

  <\definition>
    <label|defn-vote>A <strong|GRANDPA vote >or simply a vote for block
    <math|B> is an ordered pair defined as

    <\equation*>
      V<rsub|\<nosymbol\>><around|(|B|)>\<assign\><around|(|H<rsub|h><around|(|B|)>,H<rsub|i><around|(|B|)>|)>
    </equation*>

    where <math|H<rsub|h><around|(|B|)>> and <math|H<rsub|i><around|(|B|)>>
    are the block hash and the block number defined in Definitions
    <reference|defn-block-header> and <reference|defn-block-header-hash>
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
  sub-round, which is described in Algorithm <reference|algo-grandpa-round>.
  After defining what constitutes a vote in GRANDPA, we define how GRANDPA
  counts votes.

  <\definition>
    <label|defn-equivocation>Voter <math|v> <strong|equivocates> if they
    broadcast two or more valid votes to blocks during one voting sub-round.
    In such a situation, we say that <math|v> is an <strong|equivocator> and
    any vote <math|V<rsub|v><rsup|r,stage><around*|(|B|)>> cast by <math|v>
    in that sub-round is an <strong|equivocatory vote>, and

    <\equation*>
      \<cal-E\><rsup|r,stage>
    </equation*>

    represents the set of all equivocators voters in sub-round
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
      <item>set of <underline|valid> votes
      <math|V<rsup|r,stage><rsub|v<rsub|i>>> cast in round <math|r> and
      received by v such that <math|V<rsup|r,stage><rsub|v<rsub|i>>=V<around|(|B|)>>.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-observed-votes>We refer to <strong|the set of total votes
    observed by voter <math|v> in sub-round \P<math|stage>\Q of round
    <math|r>> by <strong|<math|V<rsup|r,stage><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>>>>.

    The <strong|set of all observed votes by <math|v> in the sub-round stage
    of round <math|r> for block <math|B>>,
    <strong|<math|V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>>> is
    equal to all of the observed direct votes cast for block <math|B> and all
    of the <math|B>'s descendants defined formally as:

    <\equation*>
      V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>\<assign\><big|cup><rsub|v<rsub|i>\<in\>\<bbb-V\>,B\<geqslant\>B<rprime|'>>VD<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B<rprime|'>|)><rsub|\<nosymbol\>><rsup|\<nosymbol\>><rsub|\<nosymbol\>>
    </equation*>

    The <strong|total number of observed votes for Block <math|B> in round
    <math|r>> is defined to be the size of that set plus the total number of
    equivocator voters:

    <\equation*>
      #V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>=<around|\||V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>|\|>+<around*|\||\<cal-E\><rsup|r,stage><rsub|obs<around*|(|v|)>>|\|>
    </equation*>
  </definition>

  Note that for genesis state we always have
  <math|#V<rsub|obs<around|(|v|)>><rsup|r,pv><around|(|B|)>=<around*|\||\<bbb-V\>|\|>>.

  <\definition>
    <label|defn-total-potential-votes>Let
    <math|V<rsup|r,stage><rsub|unobs<around*|(|v|)>>> be the set of voters
    whose vote in the given stage has not been received.We define the
    <strong|total number of potential votes for Block <math|B> in round
    <math|r>> to be:\ 

    <\equation*>
      #V<rsup|r,stage><rsub|obv<around|(|v|)>,pot><around|(|B|)>\<assign\><around|\||V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>|\|>+<around*|\||V<rsup|r,stage><rsub|unobs<around*|(|v|)>>|\|>+Min<around*|(|<frac|1|3><around*|\||\<bbb-V\>|\|>,<around*|\||\<bbb-V\>|\|>-<around|\||V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>|\|>-<around*|\||V<rsup|r,stage><rsub|unobs<around*|(|v|)>>|\|>|)>
    </equation*>
  </definition>

  <\definition>
    The current <strong|pre-voted> block <strong|<math|B<rsup|r,pv><rsub|v>>>also
    know as GRANDPA GHOST is the block chosen by Algorithm
    <reference|algo-grandpa-ghost>:

    <\equation*>
      B<rsup|r,pv><rsub|v>\<assign\><text|<name|GRANDPA-GHOS\<#422\>>><around*|(|r|)>
    </equation*>
  </definition>

  Finally, we define when a voter <math|v> sees a round as completable, that
  is when they are confident that <math|B<rsub|v><rsup|r,pv>> is an upper
  bound for what is going to be finalised in this round.

  <\definition>
    <label|defn-grandpa-completable>We say that round <math|r> is
    <strong|completable> if <math|<around|\||V<rsup|r,pc><rsub|obs<around|(|v|)>>|\|>+\<cal-E\><rsup|r,pc><rsub|obs<around*|(|v|)>>\<gtr\><frac|2|3>\<bbb-V\>>
    and for all <math|B<rprime|'>\<gtr\>B<rsub|v><rsup|r,pv>>:

    <\equation*>
      <tabular|<tformat|<cwith|1|1|1|1|cell-valign|b>|<table|<row|<cell|<around|\||V<rsup|r,pc><rsub|obs<around|(|v|)>>|\|>-\<cal-E\><rsup|r,pc><rsub|obs<around*|(|v|)>>-<around|\||V<rsup|r,pc><rsub|obs<around|(|v|)><rsub|\<nosymbol\>>><around|(|B<rprime|'>|)>|\|>\<gtr\><frac|2|3><around|\||\<bbb-V\>|\|>>>>>>
    </equation*>
  </definition>

  Note that in practice we only need to check the inequality for those
  <math|B<rprime|'>\<gtr\>B<rsub|v><rsup|r,pv>> where
  <math|<around|\||V<rsup|r,pc><rsub|obs<around|(|v|)><rsub|\<nosymbol\>>><around|(|B<rprime|'>|)>|\|>\<gtr\>0>.\ 

  <subsection|GRANDPA Messages Specification>

  <\definition>
    <label|defn-gossip-message><strong|GRANDPA Gossip> is a variant, as
    defined in Definition <reference|defn-varrying-data-type>, which
    identifies the message type that is casted by a voter. This type,
    followed by the sub-component, is sent to other validators.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Type>>>|<row|<cell|0>|<cell|Grandpa
    message (vote)>>|<row|<cell|1>|<cell|Grandpa
    pre-commit>>|<row|<cell|2>|<cell|Grandpa neighbor
    packet>>|<row|3|<cell|Grandpa catch up request
    message>>|<row|<cell|4>|<cell|Grandpa catch up message>>>>>>
      \;
    </big-table>
  </definition>

  The sub-components are the individual message types described in this
  section.

  <subsubsection|Vote Messages>

  Voting is done by means of broadcasting voting messages to the network.
  Validators inform their peers about the block finalized in round <math|r>
  by broadcasting a finalization message (see Algorithm
  <reference|algo-grandpa-round> for more details). These messages are
  specified in this section.

  <\definition>
    <label|defn-sign-round-vote><strong|<math|Sign<rsup|r,stage><rsub|v<rsub|i>>>>
    refers to the signature of a voter for a specific message in a round and
    is formally defined as:

    <\equation*>
      Sign<rsup|r,stage><rsub|v<rsub|i>>:=Sig<rsub|ED25519><around*|(|msg,r,id<rsub|\<bbb-V\>>|)>
    </equation*>

    Where:

    <\big-table|<tabular|<tformat|<cwith|2|3|1|1|cell-halign|r>|<cwith|2|3|1|1|cell-lborder|0ln>|<cwith|2|3|2|2|cell-halign|l>|<cwith|2|3|3|3|cell-halign|l>|<cwith|2|3|3|3|cell-rborder|0ln>|<cwith|2|3|1|3|cell-valign|c>|<table|<row|<cell|msg>|<cell|the
    message to be signed>|<cell|arbitrary>>|<row|<cell|r:>|<cell|round
    number>|<cell|unsigned 64-bit integer>>|<row|<cell|<math|id<rsub|\<bbb-V\>>>>|<cell|authority
    set Id (Definition <reference|defn-authority-set-id>) of
    v>|<cell|unsigned 64-bit integer>>>>>>
      Signature for a message in a round.
    </big-table>

    \;
  </definition>

  <\definition>
    A vote casted by voter <math|v> should be broadcasted as a
    <strong|message <math|M<rsup|r,stage><rsub|v>>> to the network by voter
    <math|v> with the following structure:

    <\eqnarray*>
      <tformat|<table|<row|<cell|M<rsup|r,stage><rsub|v>>|<cell|\<assign\>>|<cell|Enc<rsub|SC><around*|(|r,id<rsub|\<bbb-V\>>,<math-it|SigMsg>|)>>>|<row|<cell|<math-it|SigMsg>>|<cell|\<assign\>>|<cell|<math-it|msg>,Sig<rsup|r,stage><rsub|v<rsub|i>>,v<rsub|id>>>|<row|<cell|<math-it|msg>>|<cell|\<assign\>>|<cell|Enc<rsub|SC><around*|(|stage,V<rsup|r,stage><rsub|v>|)>>>>>
    </eqnarray*>

    Where:

    <\center>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|r:>|<cell|round
      number>|<cell|unsigned 64-bit integer>>|<row|<cell|<math|id<rsub|\<bbb-V\>>>>|<cell|authority
      set Id (Definition <reference|defn-authority-set-id>)>|<cell|unsigned
      64-bit integer>>|<row|<cell|<math|Sig<rsup|r,stage><rsub|v<rsub|i>>>>|<cell|signature
      (Definition <reference|defn-sign-round-vote>)>|<cell|512-bit
      array>>|<row|<cell|<right-aligned|<math|v<rsub|id>>>:>|<cell|Ed25519
      public key of <math|v>>|<cell|256-bit
      array>>|<row|<cell|<right-aligned|><math|stage>:>|<cell|0 if it's a
      pre-vote sub-round>|<cell|8-bit integer>>|<row|<cell|>|<cell|1 if it's
      a pre-commit sub-round>|<cell|8-bit integer>>|<row|<cell|>|<cell|2 if
      it's a primary proposal message>|<cell|8-bit integer>>>>>
    </center>

    \;

    \;

    This message is the sub-component of the GRANDPA Gossip as defined in
    Definition <reference|defn-gossip-message> of type Id 0 and 1.

    \;
  </definition>

  <subsubsection|Finalizing Message>

  <\definition>
    <label|defn-grandpa-justification>The <strong|justification for block B
    in round <math|r>> of GRANDPA protocol defined
    <math|J<rsup|r,stage><around*|(|B|)>> is a vector of pairs of the type:

    <\equation*>
      <around*|(|V<around*|(|B<rprime|'>|)>,<around*|(|Sign<rsup|r,stage><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>,v<rsub|id>|)>|)>
    </equation*>

    in which either

    <\equation*>
      B<rprime|'>\<geqslant\>B
    </equation*>

    or <math|V<rsup|r,pc><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>> is an
    equivocatory vote.

    In all cases, <math|Sign<rsup|r,stage><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>>
    as defined in Definition <reference|defn-sign-round-vote> is the
    signature of voter <math|v<rsub|i>\<in\>\<bbb-V\><rsub|B>> broadcasted
    during either the pre-vote (stage = pv) or the pre-commit (stage = pc)
    sub-round of round r. A <strong|valid justification> must only contain
    up-to one valid vote from each voter and must not contain more than two
    equivocatory votes from each voter.

    We say <math|J<rsup|r,pc><around*|(|B|)>> <strong|justifies the
    finalization> of <math|B<rprime|'>\<geqslant\>B> if the number of valid
    signatures in <math|J<rsup|r,pc><around*|(|B|)>> for <math|B<rprime|'>>
    is greater than <math|<frac|2|3><around|\||\<bbb-V\><rsub|B>|\|>>.
    <todo|It should be either the estimate of last round or estimate of this
    round>
  </definition>

  <\definition>
    <strong|<math|GRANDPA> finalizing message for block <math|B> in round
    <math|r>> represented as <strong|<math|M<rsub|v><rsup|r,Fin>>(B)> is a
    message broadcasted by voter <math|v> to the network indicating that
    voter <math|v> has finalized block <math|B> in round <math|r>. It has the
    following structure:

    <\equation*>
      M<rsup|r,Fin><rsub|v><around*|(|B|)>\<assign\>Enc<rsub|SC><around|(|r,V<around*|(|B|)>,J<rsup|r,pc><around*|(|B|)>|)>
    </equation*>

    in which <math|J<rsup|r><around*|(|B|)>> in the justification defined in
    Definition <reference|defn-grandpa-justification>.
  </definition>

  <subsubsection|Catch-up Messages><label|sect-grandpa-catchup-messages>

  Whenever a Polkadot node detects that it is lagging behind the finality
  procedure, it needs to initiate a <em|catch-up> procedure. Neighbor packet
  network message (see Section <reference|sect-msg-neighbor-packet>) reveals
  the round number for the last finalized GRANDPA round which the sending
  peer has observed. This provides a means to identify a discrepancy in the
  latest finalized round number observed among the peers. If such a
  discrepancy is observed, the node needs to initiate the catch-up procedure
  explained in Section <reference|sect-grandpa-catchup>.

  In particular, this procedure involves sending <em|catch-up request> and
  processing <em|catch-up response> messages specified here:

  <\definition>
    <label|defn-grandpa-catchup-request-msg><strong|GRANDPA catch-up request
    message for round r> represented as <strong|<math|M<rsub|i,v><rsup|Cat-q><around*|(|id<rsub|\<bbb-V\>>,r|)>>>
    is a message sent from node <math|i> to its voting peer node <math|v>
    requesting the latest status of a GRANDPA round
    <math|r<rprime|'>\<gtr\>r> of of authority set <math|\<bbb-V\><rsub|id>>
    along with the justification of the status and has the followin
    structure:

    <\equation*>
      M<rsub|i,v><rsup|Cat-q><around*|(|id<rsub|\<bbb-V\>>,r|)>\<assign\>Enc<rsub|SC><around*|(|r,id<rsub|\<bbb-V\>>|)>
    </equation*>

    This message is the sub-component of the GRANDPA Gossip as defined in
    Definition <reference|defn-gossip-message> of type Id 3.
  </definition>

  <\definition>
    <label|defn-grandpa-catchup-response-msg><strong|GRANDPA catch-up
    response message for round r> formally denoted as
    \ <strong|<math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>>>
    is a message sent by a node <math|v> to node i in response of a catch up
    request <math|M<rsub|v,i><rsup|Cat-q><around*|(|id<rsub|\<bbb-V\>>,r<rprime|'>|)>>
    in which <math|r\<geqslant\>r<rprime|'>> is the latest GRNADPA round
    which v has prove of its finalization and has the following structure:

    <\equation*>
      M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>\<assign\>Enc<rsub|SC><around*|(|id<rsub|\<bbb-V\>>,r,J<rsup|r,pv><around*|(|B|)>,J<rsup|r,pc><around*|(|B|)>,H<rsub|h><around*|(|B<rprime|'>|)>,H<rsub|i><around*|(|B<rprime|'>|)>|)>
    </equation*>

    Where B is the highest block which <math|v> believes to be finalized in
    round <math|r>. <math|B<rprime|'>> is the highest anscestor of all blocks
    voted on in <math|J<rsup|r,pc><around*|(|B|)>> with the exception of the
    equivocationary votes. This message is the sub-component of the GRANDPA
    Gossip as defined in Definition <reference|defn-gossip-message> of type
    Id 4.
  </definition>

  <subsection|Initiating the GRANDPA State>

  In order to participate coherently in the voting process, a validator must
  initiate its state and sync it with other active validators. In particular,
  considering that voting is happening in different distinct rounds where
  each round of voting is assigned a unique sequential round number
  <math|r<rsub|v>>, it needs to determine and set its round counter <math|r>
  equal to the voting round <math|r<rsub|n>> currently undergoing in the
  network. Algorithm <reference|algo-initiate-grandpa> mandates the
  initialization procedure for GRANDPA protocol for a joining validator.

  <\algorithm>
    <label|algo-initiate-grandpa><name|Initiate-Grandpa>(

    <math|r<rsub|last>>: <math|>last round number (See the following),

    ,<math|B<rsub|last>>: the last block which has been finalized on the
    chain (see Definitin <reference|defn-finalized-block>)

    )
  <|algorithm>
    <\algorithmic>
      <\state>
        <name|Last-Finalized-Block><math|\<leftarrow\>><math|B<rsub|last>>
      </state>

      <\state>
        <\IF>
          <math|r<rsub|last>=0>
        </IF>
      </state>

      <\state>
        <name|Best-Final-Candidate(0)><math|\<leftarrow\>B<rsub|last>>
      </state>

      <\state>
        <name|GRANDPA-GHOST>(<math|0>)<math|\<leftarrow\>B<rsub|last>><END>
      </state>

      <\state>
        <math|r<rsub|n>\<leftarrow\>r<rsub|last+1>>
      </state>

      <\state>
        <name|Play-Grandpa-round>(<math|r<rsub|n>>)
      </state>
    </algorithmic>
  </algorithm>

  <math|r<rsub|last>> is equal to the latest round the voter has observed
  that other voters are voting on. The voter obtains this information through
  various gossiped messages including those mentioned in Definition
  <reference|defn-finalized-block>.

  <math|r<rsub|last>> is set to 0 if the GRANDPA node is initiating the
  GRANDPA voting process as a part of a new authority set. This is because
  the GRANDPA round number reset to 0 for every authority set change.

  <subsubsection|Voter Set Changes>

  Voter set changes are signaled by Runtime via a consensus engine message as
  described in Section <reference|sect-consensus-message-digest>. When
  Authorities process such messages they must not vote on any block with
  higher number than the block at which the change is supposed to happen. The
  new authority set should reinitiate GRANDPA protocol by exectutig Algorithm
  <reference|algo-initiate-grandpa>.

  <subsection|Voting Process in Round <math|r>>

  For each round <math|r>, an honest voter <math|v> must participate in the
  voting process by following Algorithm <reference|algo-grandpa-round>.

  <\algorithm|<label|algo-grandpa-round><name|Play-Grandpa-round><math|<around|(|r|)>>>
    <\algorithmic>
      <\state>
        <math|t<rsub|r,v>\<leftarrow\>>Current local time
      </state>

      <\state>
        <math|primary\<leftarrow\>><name|Derive-Primary>(<math|r>)
      </state>

      <\state>
        <\IF>
          <math|v=primary>
        </IF>
      </state>

      <\state>
        <name|Broadcast(><left|.><math|M<rsub|v<rsub|\<nosymbol\>>><rsup|r-1,Fin>>(<name|Best-Final-Candidate>(<math|r>-1))<right|)>
      </state>

      <\state>
        <\IF>
          <name|Best-Final-Candidate><math|<around*|(|r-1|)>>
          <math|\<geqslant\>> <name|Last-Finalized-Block>\ 
        </IF>
      </state>

      <\state>
        <name|Broadcast(><left|.><math|M<rsub|v<rsub|\<nosymbol\>>><rsup|r-1,Prim>>(<name|Best-Final-Candidate>(<math|r>-1))<right|)><END><END>
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
        <math|N\<leftarrow\>><name|Best-PreVote-Candidate>(<math|r>)
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
        <name|Attempt-To-Finalize-Round>(<math|r>)
      </state>

      <\state>
        <name|Receive-Messages>(<strong|until> <math|r> <strong|is>
        completable <strong|and> <name|Finalizable>(<math|r-1>)

        <space|2em><strong|and> \ <name|Last-Finalized-Block><math|\<geqslant\>><name|Best-Final-Candidate>(<math|r>-1))
      </state>

      <\state>
        <name|Play-Grandpa-round>(<math|r+1>)
      </state>
    </algorithmic>
  </algorithm>

  Where:

  <\itemize-minus>
    <item><math|T> is sampled from a log normal distribution whose mean and
    standard deviation are equal to the average network delay for a message
    to be sent and received from one validator to another.

    <item><name|Derive-Primary> is described in Algorithm
    <reference|algo-derive-primary>.

    <item>The condition of <em|completablitiy> is defined in Definition
    <reference|defn-grandpa-completable>.

    <item><name|Best-Final-Candidate> function is explained in Algorithm
    <reference|algo-grandpa-best-candidate>.

    <item><name|<name|Attempt-To-Finalize-Round>(<math|r>)> is described in
    Algorithm <reference|algo-attempt-to\Ufinalize>.

    <item><name|Finalizabl> is defined in Algorithm
    <reference|algo-finalizable>.
  </itemize-minus>

  <\algorithm|<label|algo-derive-primary><name|Derive-Primary>(<math|r>: the
  GRANDPA round whose primary to be determined)>
    <\algorithmic>
      <\state>
        <\RETURN>
          <math|r mod<around*|\||\<bbb-V\>|\|>>
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  <math|\<bbb-V\>> is the GRANDPA voter set as defined in Definition
  <reference|defn-grandpa-voter>.

  <\algorithm|<label|algo-grandpa-best-candidate><name|Best-Final-Candidate>(<math|r>)>
    <\algorithmic>
      <\state>
        <math|B<rsub|v><rsup|r,pv>\<leftarrow\>><name|GRANDPA-GHOST><math|<around*|(|r|)>>
      </state>

      <\state>
        <\IF>
          <math|r=0>
        </IF>
      </state>

      <\state>
        <\RETURN>
          <math|B<rsub|v><rsup|r,pv>><END>
        </RETURN>
      </state>

      <\state>
        <\ELSE>
          \;
        </ELSE>
      </state>

      <\state>
        <math|\<cal-C\><rsub|\<nosymbol\>>\<leftarrow\><around|{|B<rprime|'>\|B<rprime|'>\<leqslant\>B<rsub|v><rsup|r,pv>:#V<rsup|r,pc><rsub|obv<around|(|v|)>,pot><around|(|B<rprime|'>|)>\<gtr\>2/3<around|\||\<bbb-V\>|\|>|}>>
      </state>

      <\state>
        <\IF>
          <math|\<cal-C\>=\<phi\>>
        </IF>
      </state>

      <\state>
        <\RETURN>
          <math|B<rsub|v><rsup|r,pv><END>>
        </RETURN>
      </state>

      <\state>
        <\ELSE>
          \;
        </ELSE>
      </state>

      <\state>
        <\RETURN>
          <math|><math|E\<in\>\<cal-C\>:H<rsub|n><around*|(|E|)>=Max
          <around|(|H<rsub|n><around|(|B<rprime|'>|)>:B<rprime|'>\<in\>\<cal-C\>|)>><END>
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  <math|#V<rsup|r,stage><rsub|obv<around|(|v|)>,pot>> is defined in
  Definition <reference|defn-total-potential-votes>.

  <\algorithm>
    <label|algo-grandpa-ghost><name|GRANDPA-GHOST>(<math|r>)
  <|algorithm>
    <\algorithmic>
      <\state>
        <\IF>
          <math|r=0:>
        </IF>
      </state>

      <\state>
        <math|G\<leftarrow\>B<rsub|last><END>>
      </state>

      <\state>
        <\ELSE>
          \;
        </ELSE>
      </state>

      <\state>
        <math|L\<leftarrow\>><name|Best-Final-Candidate>(<math|r-1>)
      </state>

      <\state>
        <math|\<cal-G\>=<around*|{|\<forall\>B\<gtr\>L\|#V<rsub|obs<around|(|v|)>><rsup|r,pv><around|(|B|)>\<geqslant\>2/3<around|\||\<bbb-V\>|\|>|}>>
      </state>

      <\state>
        <\IF>
          <math|\<cal-G\>=\<phi\>>
        </IF>
      </state>

      <\state>
        <math|G\<leftarrow\>L<END>>
      </state>

      <\state>
        <\ELSE>
          \;
        </ELSE>
      </state>

      <\state>
        <math|G\<in\>\<cal-G\>:<around*|\<nobracket\>|H<rsub|n><around*|(|G|)>=Max<around|(|H<rsub|n><around|(|B|)>|\|>*\<forall\>B\<in\>\<cal-G\>|)>><END><END>
      </state>

      <\state>
        <\RETURN>
          <math|G>
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  Where\ 

  <\itemize-minus>
    <item><math|B<rsub|last>> is the last block which has been finalized on
    the chain (see Definitin <reference|defn-finalized-block>)

    <item><math|#V<rsub|obs<around|(|v|)>><rsup|r,pv><around|(|B|)>> is
    defined in Definition <reference|defn-observed-votes>.
  </itemize-minus>

  <\algorithm|<name|Best-PreVote-Candidate(<math|r>:> voting round to cast
  the pre-vote in)>
    <\algorithmic>
      <\state>
        <math|B<rsup|r,pv><rsub|v>\<leftarrow\>><name|GRANDPA-GHOST><math|<around*|(|r|)>><END>
      </state>

      <\state>
        <\IF>
          <name|Received(<math|M<rsub|v<rsub|primary>><rsup|r,prim><around|(|B|)>>)>
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
        <math|N\<leftarrow\>><math|B<rsup|r,pv><rsub|v>>
      </state>
    </algorithmic>
  </algorithm>

  <\algorithm|<label|algo-finalizable><name|Finalizable>(<math|r:>voting
  round)>
    <\algorithmic>
      <\state>
        <\IF>
          <math|r> <strong|is not> Completable
        </IF>
      </state>

      <\state>
        <\RETURN>
          <\strong>
            False<END>
          </strong>
        </RETURN>
      </state>

      <\state>
        <math|G\<leftarrow\>><name|GRANDPA-GHOST>(<math|J<rsup|r,pv><around*|(|B|)>>)
      </state>

      <\state>
        <\IF>
          <math|G=\<phi\>>
        </IF>
      </state>

      <\state>
        <\RETURN>
          <\strong>
            False<END>
          </strong>
        </RETURN>
      </state>

      <\state>
        <math|E<rsub|r>\<leftarrow\>><name|Best-Final-Candidate>(<math|r>)
      </state>

      <\state>
        <\IF>
          <math|E<rsub|r>\<neq\>\<phi\>> <strong|and>
          <math|E<rsub|r-1>\<leqslant\>E<rsub|r><rsub|>\<leqslant\>G>
        </IF>
      </state>

      <\state>
        <\RETURN>
          <\strong>
            True<END>
          </strong>
        </RETURN>
      </state>

      <\state>
        <\ELSE>
          \;
        </ELSE>
      </state>

      <\state>
        <\RETURN>
          <\strong>
            False
          </strong>
        </RETURN>
      </state>
    </algorithmic>
  </algorithm>

  The condition of <em|completablitiy> is defined in Definition
  <reference|defn-grandpa-completable>.

  <\algorithm|<label|algo-attempt-to\Ufinalize><name|Attempt-To-Finalize-Round>(<math|r>)>
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
          <math|V<rsup|r,pc><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>><around|(|E|)>\<gtr\>2/3<around|\||\<bbb-V\>|\|>>
        </IF>
      </state>

      <\state>
        <name|Last-Finalized-Block><math|\<leftarrow\>E>
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

  Note that we might not always succeed in finalizing our best final
  candidate due to the possibility of equivocation. Example
  <reference|exmp-candid-unfinalized> serves to demonstrate such a situation:

  <\example>
    <label|exmp-candid-unfinalized>Let us assume that we have 100 voters and
    there are two blocks in the chain (<math|B<rsub|1>\<less\>B<rsub|2>>). At
    round 1, we get 67 prevotes for <math|B<rsub|2>> and at least one prevote
    for <math|B<rsub|1>> which means that <name|GRANDPA-GHOST(1) =
    <math|B<rsub|2>>>.\ 

    Subsequently potentially honest voters who could claim not seeing all the
    prevotes for <math|B<rsub|2>> but receiving the prevotes for
    <math|B<rsub|1>> would precommit to <math|B<rsub|1>>. In this way, we
    receive 66 precommits for <math|B<rsub|1>> and 1 precommit for
    <math|B<rsub|2>>. Henceforth, we finalize <math|B<rsub|1>> since we have
    a threshold commit (67 votes) for <math|B<rsub|1>>.

    At this point, though, we have <name|Best-Final-Candidate>(<math|r>)<math|=B<rsub|2>>
    as <math|#V<rsup|r,stage><rsub|obv<around|(|v|)>,pot><around|(|B<rsub|2>|)>=67>
    and <math|2\<gtr\>1>.

    However, at this point, the round is already completable as we know that
    we have <name|GRANDPA-GHOST(1) = <math|B<rsub|2>>> as an upper limit on
    what we can finalize and nothing greater than <math|B<rsub|2>> can be
    finalized at <math|r=1>. Therefore, the condition of Algorithm
    <reference|algo-grandpa-round>:14 is satisfied and we must proceed to
    round 2.

    \ Nonetheless, we must continue to attempt to finalize round 1 in the
    background as the condition of <reference|algo-attempt-to\Ufinalize>:3
    has not been fulfilled.\ 

    This prevents us from proceeding to round 3 until either:

    <\itemize-minus>
      <item>We finalize <math|B<rsub|2>> in round 2, or

      <item>We receive an extra pre-commit vote for <math|B<rsub|1>> in round
      1. This will make it impossible to finalize <math|B<rsub|2>> in round
      1, no matter to whom the remaining precommits are going to be casted
      for (even with considering the possibility of 1/3 of voter
      equivocating) and therefore we have
      <name|Best-Final-Candidate>(<math|r>)<math|=B<rsub|1>>.
    </itemize-minus>

    Both scenarios unblock the Algorithm <reference|algo-grandpa-round>:14
    <name|Last-Finalized-Block><math|\<geqslant\>><name|Best-Final-Candidate>(<math|r>-1))
    albeit in different ways: the former with increasing the
    <name|Last-Finalized-Block> and the latter with decreasing
    <name|Best-Final-Candidate>(<math|r>-1).
  </example>

  <section|Block Finalization><label|sect-block-finalization>

  <\definition>
    <label|defn-finalized-block>A Polkadot relay chain node n should consider
    block <math|B> as <strong|finalized> if any of the following criteria
    holds for <math|B<rprime|'>\<geqslant\>B>:\ 

    <\itemize>
      <item><math|V<rsup|r,pc><rsub|obs<around|(|n|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>><around|(|B<rprime|'>|)>\<gtr\>2/3<around|\||\<bbb-V\><rsub|B<rprime|'>>|\|>>.

      <item>it receives a <math|M<rsub|v><rsup|r,Fin><around|(|B<rprime|'>|)>>
      message in which <math|J<rsup|r><around*|(|B|)>> justifies the
      finalization (according to Definition
      <reference|defn-grandpa-justification>).

      <item>it receives a block data message for <math|B<rprime|'>> with
      <math|Just<around*|(|B<rprime|'>|)>> defined in Section
      <reference|sect-justified-block-header> which justifies the
      finalization.\ 
    </itemize>
  </definition>

  for\ 

  <\itemize-dot>
    <item>any round <math|r> if the node <math|n> is <em|not> a GRANDPA
    voter.\ 

    <item>only for rounds <math|r> for which the the node <math|n> has
    invoked Algorithm <reference|algo-grandpa-round> if <math|n> is a GRANDPA
    voter.
  </itemize-dot>

  Note that all Polkadot relay chain nodes are supposed to listen to GRANDPA
  finalizing messages regardless if they are GRANDPA voters.

  <subsection|Catching up><label|sect-grandpa-catchup>

  When a Polkadot node (re)joins the network during the process described in
  Chapter <reference|chap-bootstrapping>, it requests the history of state
  transition which it is missing in form of blocks. Each finalized block
  comes with the Justification of its finalization as defined in Definition
  <reference|defn-grandpa-justification>. Through this process, they can
  synchronize the authority list currently performing the finalization
  process.

  <subsubsection|Sending catch-up requests><label|sect-sending-catchup-request>

  When a Polkadot node has the same authority list as a peer node who is
  reporting a higher number for the \Pfinalized round\Q field, it should send
  a catch-up request message as specified in Definition
  <reference|defn-grandpa-catchup-request-msg> to the reporting peer in order
  to catch-up to the more advanced finalized round, provided that the
  following criteria holds:

  <\itemize-minus>
    <item>the peer node is a GRANDPA voter, and

    <item>the last known finalized round for the Polkadot node is at least 2
    rounds behind the finalized round for the peer.\ 
  </itemize-minus>

  \ <subsubsection|Processing catch-up requests>

  Only GRANDPA voter nodes are required to respond to the catch-up responses.
  When a GRANDPA voter node receives a catch-up request message it needs to
  execute Algorithm <reference|algo-process-catchup-request>.

  <\algorithm>
    <label|algo-process-catchup-request><name|ProcessCatchupRequest>(

    <math|M<rsub|i,v><rsup|Cat-q><around*|(|id<rsub|\<bbb-V\>>,r|)>>: The
    catch-up message received from peer <math|i> (See Definition
    <reference|defn-grandpa-catchup-request-msg>)

    )
  <|algorithm>
    <\algorithmic>
      <\state>
        <\IF>
          <math|M<rsub|i,v><rsup|Cat-q><around*|(|id<rsub|\<bbb-V\>>,r|)>.id<rsub|\<bbb-V\>>\<neq\>id<rsub|\<bbb-V\>>>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PCatching up on different set\Q<END>
        </ERROR>
      </state>

      <\state>
        <\IF>
          <math|i\<nin\>\<bbb-P\>>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PRequesting catching up from a non-peer\Q<END>
        </ERROR>
      </state>

      <\state>
        <\IF>
          <math|r\<gtr\>><name|Last-Completed-Round>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PCatching up on a round in the future\Q<END>
        </ERROR>
      </state>

      <\state>
        <name|Send(<math|i>,><math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>>)
      </state>
    </algorithmic>
  </algorithm>

  In which:

  <\itemize-minus>
    <item><math|id<rsub|\<bbb-V\>>> is the voter set id which the serving
    node is operating

    <item><math|r> is the round number for which the catch-up is requested
    for.

    <item><math|\<bbb-P\>> is the set of immediate peers of node <math|v>.

    <item><name|Last-Completed-Round> is <todo|define:
    https://github.com/w3f/polkadot-spec/issues/161>

    <item><math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>> is
    the catch-up response defined in Definition
    <reference|defn-grandpa-catchup-response-msg>.
  </itemize-minus>

  <subsubsection|Processing catch-up responses>

  A Catch-up response message contains critical information for the requester
  node to update their view on the active rounds which are being voted on by
  GRANDPA voters. As such, the requester node should verify the content of
  the catch-up response message and subsequently updates its view of the
  state of finality of the Relay chain according to Algorithm
  <reference|algo-process-catchup-response>.

  <\algorithm>
    <label|algo-process-catchup-response> <name|Process-Catchup-Response>(

    <math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>>: the
    catch-up response received from node <math|v> (See Definition
    <reference|defn-grandpa-catchup-response-msg>)

    )
  <|algorithm>
    <\algorithmic>
      <\state>
        <math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>.id<rsub|\<bbb-V\>>,r,J<rsup|r,pv><around*|(|B|)>,J<rsup|r,pc><around*|(|B|)>,H<rsub|h><around*|(|B<rprime|'>|)>,H<rsub|i><around*|(|B<rprime|'>|)>\<leftarrow\>><math|Dec<rsub|SC>>(<math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>>)
      </state>

      <\state>
        <\IF>
          <math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>.id<rsub|\<bbb-V\>>\<neq\>id<rsub|\<bbb-V\>>>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PCatching up on different set\Q<END>
        </ERROR>
      </state>

      <\state>
        <\IF>
          <math|r\<leqslant\>><name|Leading-Round>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PCatching up in to the past\Q<END>
        </ERROR>
      </state>

      <\state>
        <\IF>
          <math|J<rsup|r,pv><around*|(|B|)>> is not valid<math|>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PInvalid pre-vote justification\Q<END>
        </ERROR>
      </state>

      <\state>
        <\IF>
          <math|J<rsup|r,pc><around*|(|B|)>> is not valid<math|>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PInvalid pre-commit justification\Q<END>
        </ERROR>
      </state>

      <\state>
        <math|G\<leftarrow\>><name|GRANDPA-GHOST>(<math|J<rsup|r,pv><around*|(|B|)>>)
      </state>

      <\state>
        <\IF>
          <math|G=\<phi\>>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PGHOST-less Catch-up\Q<END>
        </ERROR>
      </state>

      <\state>
        <\IF>
          <name|<math|r>> <strong|is not> completable
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PCatch-up round is not completable\Q<END>
        </ERROR>
      </state>

      <\state>
        <\IF>
          <math|J<rsup|r,pc><around*|(|B|)>> justifies <math|B<rprime|'>>
          finalization
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PUnjustified Catch-up target finalization\Q<END>
        </ERROR>
      </state>

      <\state>
        <name|Last-Completed-Round><math|\<leftarrow\>r>
      </state>

      <\state>
        <\IF>
          <math|i\<in\>\<bbb-V\>>
        </IF>
      </state>

      <\state>
        <name|Play-Grandpa-round><math|<around|(|r+1|)>><END>
      </state>
    </algorithmic>
  </algorithm>

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|5>
    <associate|page-first|43>
    <associate|page-medium|papyrus>
    <associate|preamble|false>
    <associate|section-nr|0<uninit>>
    <associate|subsection-nr|4>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|algo-attempt-to\Ufinalize|<tuple|6.15|48>>
    <associate|algo-block-production|<tuple|6.4|41>>
    <associate|algo-block-production-lottery|<tuple|6.1|39>>
    <associate|algo-build-block|<tuple|6.7|43>>
    <associate|algo-derive-primary|<tuple|6.10|48>>
    <associate|algo-finalizable|<tuple|6.14|48>>
    <associate|algo-grandpa-best-candidate|<tuple|6.11|48>>
    <associate|algo-grandpa-ghost|<tuple|6.12|?>>
    <associate|algo-grandpa-round|<tuple|6.9|47>>
    <associate|algo-initiate-grandpa|<tuple|6.8|47>>
    <associate|algo-process-catchup-request|<tuple|6.16|49>>
    <associate|algo-process-catchup-response|<tuple|6.17|50>>
    <associate|algo-slot-time|<tuple|6.3|40>>
    <associate|algo-verify-authorship-right|<tuple|6.5|42>>
    <associate|algo-verify-slot-winner|<tuple|6.6|42>>
    <associate|auto-1|<tuple|6|37>>
    <associate|auto-10|<tuple|6.2.3|40>>
    <associate|auto-11|<tuple|6.1|41>>
    <associate|auto-12|<tuple|6.2.4|42>>
    <associate|auto-13|<tuple|6.2.5|43>>
    <associate|auto-14|<tuple|6.2.6|43>>
    <associate|auto-15|<tuple|6.2.7|43>>
    <associate|auto-16|<tuple|6.3|45>>
    <associate|auto-17|<tuple|6.3.1|45>>
    <associate|auto-18|<tuple|6.3.2|45>>
    <associate|auto-19|<tuple|6.3|46>>
    <associate|auto-2|<tuple|6.1|37>>
    <associate|auto-20|<tuple|6.3.2.1|46>>
    <associate|auto-21|<tuple|6.4|47>>
    <associate|auto-22|<tuple|6.3.2.2|47>>
    <associate|auto-23|<tuple|6.3.2.3|47>>
    <associate|auto-24|<tuple|6.3.3|49>>
    <associate|auto-25|<tuple|6.3.3.1|49>>
    <associate|auto-26|<tuple|6.3.4|49>>
    <associate|auto-27|<tuple|6.4|49>>
    <associate|auto-28|<tuple|6.4.1|50>>
    <associate|auto-29|<tuple|6.4.1.1|?>>
    <associate|auto-3|<tuple|6.1.1|37>>
    <associate|auto-30|<tuple|6.4.1.2|?>>
    <associate|auto-31|<tuple|6.4.1.3|?>>
    <associate|auto-4|<tuple|6.1.2|37>>
    <associate|auto-5|<tuple|6.1|38>>
    <associate|auto-6|<tuple|6.2|39>>
    <associate|auto-7|<tuple|6.2|39>>
    <associate|auto-8|<tuple|6.2.1|39>>
    <associate|auto-9|<tuple|6.2.2|40>>
    <associate|chap-consensu|<tuple|6|37>>
    <associate|defn-authority-list|<tuple|6.1|37>>
    <associate|defn-authority-set-id|<tuple|6.23|44>>
    <associate|defn-babe-constant|<tuple|6.10|?>>
    <associate|defn-babe-header|<tuple|6.19|40>>
    <associate|defn-babe-seal|<tuple|6.20|41>>
    <associate|defn-block-signature|<tuple|6.20|41>>
    <associate|defn-block-time|<tuple|6.17|40>>
    <associate|defn-chain-quality|<tuple|6.16|?>>
    <associate|defn-consensus-message-digest|<tuple|6.3|37>>
    <associate|defn-epoch-randomness|<tuple|6.21|?>>
    <associate|defn-epoch-slot|<tuple|6.6|39>>
    <associate|defn-epoch-subchain|<tuple|6.9|39>>
    <associate|defn-equivocation|<tuple|6.27|?>>
    <associate|defn-finalized-block|<tuple|6.42|49>>
    <associate|defn-gossip-message|<tuple|6.34|45>>
    <associate|defn-grandpa-catchup-request-msg|<tuple|6.39|46>>
    <associate|defn-grandpa-catchup-response-msg|<tuple|6.40|46>>
    <associate|defn-grandpa-completable|<tuple|6.33|45>>
    <associate|defn-grandpa-justification|<tuple|6.37|46>>
    <associate|defn-grandpa-voter|<tuple|6.22|43>>
    <associate|defn-observed-votes|<tuple|6.30|?>>
    <associate|defn-prunned-best|<tuple|6.15|?>>
    <associate|defn-relative-syncronization|<tuple|6.13|?>>
    <associate|defn-sign-round-vote|<tuple|6.35|?>>
    <associate|defn-slot-offset|<tuple|6.12|40>>
    <associate|defn-sync-period|<tuple|6.18|?>>
    <associate|defn-total-potential-votes|<tuple|6.31|?>>
    <associate|defn-vote|<tuple|6.25|44>>
    <associate|defn-winning-threshold|<tuple|6.11|39>>
    <associate|exmp-candid-unfinalized|<tuple|6.41|?>>
    <associate|note-slot|<tuple|6.8|39>>
    <associate|sect-authority-set|<tuple|6.1.1|37>>
    <associate|sect-babe|<tuple|6.2|39>>
    <associate|sect-block-building|<tuple|6.2.7|43>>
    <associate|sect-block-finalization|<tuple|6.4|49>>
    <associate|sect-block-production|<tuple|6.2|39>>
    <associate|sect-consensus-message-digest|<tuple|6.1.2|37>>
    <associate|sect-epoch-randomness|<tuple|6.2.5|41>>
    <associate|sect-finality|<tuple|6.3|43>>
    <associate|sect-grandpa-catchup|<tuple|6.4.1|49>>
    <associate|sect-grandpa-catchup-messages|<tuple|6.3.2.3|46>>
    <associate|sect-sending-catchup-request|<tuple|6.4.1.1|49>>
    <associate|sect-verifying-authorship|<tuple|6.2.6|42>>
    <associate|tabl-consensus-messages-babe|<tuple|6.1|?>>
    <associate|tabl-consensus-messages-grandpa|<tuple|6.2|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      w3f_research_group_blind_2019

      david_ouroboros_2018

      stewart_grandpa:_2019
    </associate>
    <\associate|figure>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.1>|>
        Examplary result of Median Algorithm in first sync epoch with
        <with|mode|<quote|math>|s<rsub|cq>=9> and
        <with|mode|<quote|math>|k=1>.
      </surround>|<pageref|auto-11>>
    </associate>
    <\associate|table>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.1>|>
        The consensus digest item for BABE authorities
      </surround>|<pageref|auto-5>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.2>|>
        The consensus digest item for GRANDPA authorities
      </surround>|<pageref|auto-6>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.3>|>
        \;
      </surround>|<pageref|auto-19>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.4>|>
        Signature for a message in a round.
      </surround>|<pageref|auto-21>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|6<space|2spc>Consensus>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      6.1<space|2spc>Common Consensus Structures
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      <with|par-left|<quote|1tab>|6.1.1<space|2spc>Consensus Authority Set
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1tab>|6.1.2<space|2spc>Runtime-to-Consensus
      Engine Message <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      6.2<space|2spc>Block Production <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>

      <with|par-left|<quote|1tab>|6.2.1<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|6.2.2<space|2spc>Block Production Lottery
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|6.2.3<space|2spc>Slot Number Calculation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|1tab>|6.2.4<space|2spc>Block Production
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|6.2.5<space|2spc>Epoch Randomness
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|1tab>|6.2.6<space|2spc>Verifying Authorship Right
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|1tab>|6.2.7<space|2spc>Block Building Process
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      6.3<space|2spc>Finality <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>

      <with|par-left|<quote|1tab>|6.3.1<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|1tab>|6.3.2<space|2spc>GRANDPA Messages
      Specification <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|2tab>|6.3.2.1<space|2spc>Vote Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|2tab>|6.3.2.2<space|2spc>Finalizing Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|2tab>|6.3.2.3<space|2spc>Catch-up Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <with|par-left|<quote|1tab>|6.3.3<space|2spc>Initiating the GRANDPA
      State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|2tab>|6.3.3.1<space|2spc>Voter Set Changes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|1tab>|6.3.4<space|2spc>Voting Process in Round
      <with|mode|<quote|math>|r> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      6.4<space|2spc>Block Finalization <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>

      <with|par-left|<quote|1tab>|6.4.1<space|2spc>Catching up
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|2tab>|6.4.1.1<space|2spc>Sending catch-up
      requests <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|2tab>|6.4.1.2<space|2spc>Processing catch-up
      requests <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <with|par-left|<quote|2tab>|6.4.1.3<space|2spc>Processing catch-up
      responses <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>
    </associate>
  </collection>
</auxiliary>