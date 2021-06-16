<TeXmacs|1.99.16>

<project|host-spec.tm>

<style|<tuple|tmbook|algorithmacs-style>>

<\body>
  <chapter|Consensus><label|chap-consensu>

  Consensus in the Polkadot Host is achieved during the execution of two
  different procedures. The first procedure is the block-production and the
  second is finality. The Polkadot Host must run these procedures if (and
  only if) it is running on a validator node.

  <section|Common Consensus Structures>

  <subsection|Consensus Authority Set><label|sect-authority-set>

  Because Polkadot is a proof-of-stake protocol, each of its consensus
  engines has its own set of nodes represented by known public keys, which
  have the authority to influence the protocol in pre-defined ways explained
  in this Section. To verify the validity of each block, the Polkadot node
  must track the current list of authorities for that block as formalized in
  Definition <reference|defn-authority-list>

  <\definition>
    <label|defn-authority-list>The <strong|authority list> of block
    <math|<math-it|B>> for consensus engine <math|C> noted as
    <strong|<math|Auth<rsub|C><around*|(|B|)>>> is an array that contains the
    following pair of types for each of its authorities
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
    retrieved using a runtime entry corresponding to consensus engine
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
  adding the appropriate consensus message as defined in Definition
  <reference|defn-consensus-message-digest>, in the form of a digest item to
  the block header of block <math|B> which caused the transition in the
  authority set.\ 

  <\definition>
    <label|defn-consensus-message-digest> Consensus Message is a digest item
    of type 4 as defined in Definition <reference|defn-digest> and consists
    of the pair:

    <\equation*>
      <around*|(|E<rsub|id>,CM|)>
    </equation*>

    Where <math|E<rsub|id>\<in\>\<bbb-B\><rsub|4>> is the consensus engine
    unique identifier which can hold the following possible values

    \;

    <\equation*>
      E<rsub|id>\<assign\><around*|{|<tabular*|<tformat|<table|<row|<cell|<rprime|''>BABE<rprime|''>>|<cell|>|<cell|For
      messages related to BABE protocol referred to as
      E<rsub|id><around*|(|BABE|)>>>|<row|<cell|<rprime|''>FRNK<rprime|''>>|<cell|>|<cell|For
      messages related to GRANDPA protocol referred to as
      E<rsub|id><around*|(|FRNK|)>>>>>>|\<nobracket\>>
    </equation*>

    and CM is of varying data type which can hold one of the types described
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
      a tuple of two unsigned 64-bit integers
      <math|<around*|(|c<rsub|nominator>,c<rsub|denominator>|)>> which are
      used to compute the rational <math|c=<frac|c<rsub|nominator>|c<rsub|denominator>>>.

      <item><math|s<rsub|2nd>> is the second slot configuration encoded as an
      8-bit enum.\ 
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
      to Algorithm <reference|algo-import-and-validate-block>. See below for
      details).

      <item><math|Auth<rsub|ID>> is an unsigned 64-bit integer pointing to an
      individual authority in the current authority list.
    </itemize-minus>
  </definition>

  The Polkadot Host should inspect the digest header of each block and
  delegate consensus messages to their consensus engines.

  The BABE consensus engine should react based on the type of consensus
  messages it receives as follows:

  <\itemize-minus>
    <item><with|font-series|bold|Next Epoch Data:> The Runtime issues this
    message on every first block of an epoch <math|\<cal-E\><rsub|n>>. The
    supplied authority set and randomness are intended to be used in the next
    epoch <math|\<cal-E\><rsub|n+1>>. \ 

    <item><strong|On Disabled>: An index to the individual authority in the
    current authority list that should be immediately disabled until the next
    authority set changes. When an authority gets disabled, the node should
    stop performing any authority functionality for that authority, including
    authoring blocks. Similarly, other nodes should ignore all messages from
    the indicated authority which pertain to their authority role.\ 

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
    be scheduled if one is already finalized and the delay has not passed
    completely. If such an inconsistency occurs, the scheduled change should
    be ignored.

    <item><strong|Forced Change>: Force an authority set change after the
    given delay of <math|N<rsub|delay>\<assign\><around*|\|||\<nobracket\>>><name|SubChain><math|<around*|(|B,B<rprime|'>|)><around*|\|||\<nobracket\>>>
    where <math|B<rprime|'>> in the definition of <math|N<rsub|delay>>, is an
    <em|imported> block that has been validated by the block production
    consensus engine. Hence, the authority changeset is valid for every
    subchain containing <em|B> and where the delay has been exceeded. If one
    or more blocks gets finalized before the change takes effect, the
    authority set change should be disregarded. The earliest digest of this
    type in a single block will be respected. No change should be scheduled
    if one is already finalized and the delay has not passed completely. If
    such an inconsistency occurs, the scheduled change should be ignored.

    <item><strong|On Disabled>: <with|font-series|bold|<underline|This
    message is currently ignored by the Polkadot Host and will be for the
    forseeable future.> >An index to the individual authority in the current
    authority list that should be immediately disabled until the next
    authority set changes. \ This message initial intension was to cause an
    imediatly suspension of all authority functionality with the specified
    authority.

    <item><strong|Pause>: A signal to pause the current authority set after
    the given delay of <math|N<rsub|delay>\<assign\><around*|\|||\<nobracket\>>><name|SubChain><math|<around*|(|B,B<rprime|'>|)><around*|\|||\<nobracket\>>>
    where <math|B<rprime|'>> in the definition of <math|N<rsub|delay>>, is a
    block <em|finalized> by the finality consensus engine. After finalizing
    block <math|B<rprime|'>>, the authorities should stop voting.

    <item><strong|Resume>: A signal to resume the current authority set after
    the given delay of <math|N<rsub|delay>\<assign\><around*|\|||\<nobracket\>>><name|SubChain><math|<around*|(|B,B<rprime|'>|)><around*|\|||\<nobracket\>>>
    where <math|B<rprime|'>> in the definition of <math|N<rsub|delay>>, is an
    <em|imported> block and validated by the block production consensus
    engine. After authoring block <math|B<rprime|'>>, the authorities should
    resume voting.
  </itemize-minus>

  The active GRANDPA authorities can only vote for blocks that occurred after
  the finalized block in which they were selected. Any votes for blocks
  before the <verbatim|Scheduled Change> came into effect would get rejected.

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
  branches that do not include the most recent finalized blocks according to
  Definition <reference|defn-pruned-tree>.

  <subsection|Preliminaries>

  <\definition>
    A <strong|block producer>, noted by <math|\<cal-P\><rsub|j>>, is a node
    running the Polkadot Host which is authorized to keep a transaction queue
    and which it gets a turn in producing blocks.
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
    referred to as <math|\<cal-E\>>, is a period with a pre-known starting
    time and fixed-length during which the set of block producers stays
    constant. Epochs are indexed sequentially, and we refer to the
    <math|n<rsup|th>> epoch since genesis by <math|\<cal-E\><rsub|n>>. Each
    epoch is divided into <math|>equal-length periods known as block
    production <strong|slots>, sequentially indexed in each epoch. The index
    of each slot is called a <strong|slot number>. The equal length duration
    of each slot is called the <strong|slot duration> and indicated by
    <math|\<cal-T\>>. Each slot is awarded to a subset of block producers
    during which they are allowed to generate a block.
  </definition>

  <\remark>
    Substrate refers to an epoch as \Psession\Q in some places, however,
    epoch should be the preferred and official name for these periods.
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
    <math|BT> containing all the blocks generated during the slots of epoch
    <math|\<cal-E\><rsub|n>>. When there is more than one block generated at
    a slot, we choose the one which is also on
    <name|Longest-Chain(<math|BT>)>.
  </definition>

  <\definition>
    A block producer <strong|equivocates> if they produce more than one block
    at the same slot. The proof of equivocation are the given distinct
    headers that were signed by the validator and which include the slot
    number.

    \;

    The Polkadot Host must detect equivocations committed by other validators
    and submit those to the Runtime as described in Section
    <reference|sect-babeapi_submit_report_equivocation_unsigned_extrinsic>.
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
  For efficiency reasons, it is generally updated by the Runtime through the
  \PNext Config Data\Q consensus message (see Definition
  <reference|defn-consensus-message-digest>) in the digest of the first block
  of an epoch for the next epoch.\ 

  <\definition>
    <label|defn-winning-threshold>The <strong|Winning threshold> denoted by
    <strong|<math|\<tau\><rsub|\<varepsilon\><rsub|n>>>> is the threshold
    that is used alongside the result of Algorithm
    <reference|algo-block-production-lottery> to decide if a block producer
    is the winner of a specific slot. <math|\<tau\><rsub|\<varepsilon\><rsub|n>>>
    is calculated \ as follows:

    <\equation*>
      \<tau\><rsub|\<varepsilon\><rsub|n>>\<assign\>1-<around*|(|1-c|)><rsup|<frac|1|<around*|\||AuthorityDirectory<rsup|\<cal-E\><rsub|n>>|\|>>>
    </equation*>

    where the <math|AuthorityDirectory<rsup|\<cal-E\><rsub|n>>> is the set of
    BABE authorities for epoch <math|\<varepsilon\><rsub|n>> and
    <math|c\<in\><around*|(|0,1|)>> is the BABE constant as defined in
    definition <reference|defn-babe-constant>.
  </definition>

  \ A block producer aiming to produce a block during
  <math|\<cal-E\><rsub|n>> should run Algorithm
  <reference|algo-block-production-lottery> to identify the slots it is
  awarded. These are the slots during which the block producer is allowed to
  build a block. The <math|sk> is the block producer lottery secret key and
  <math|n> is the index of the epoch for whose slots the block producer is
  running the lottery.

  <\algorithm>
    <label|algo-block-production-lottery><name|Block-production-lottery>(<math|sk:>
    the session secret key of the producer,

    <math|n:> the epoch index)
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

  <subsection|Slot Number Calculation><label|sect-slot-number-calculation>

  <\definition>
    <label|defn-slot-offset>Let <math|s<rsub|i>> and <math|s<rsub|j>> be two
    slots belonging to epochs <math|\<cal-E\><rsub|k>> and
    <math|\<cal-E\><rsub|l>>. By <with|font-series|bold|<name|Slot-Offset><math|<around*|(|s<rsub|i>,s<rsub|j>|)>>>
    we refer to the function whose value is equal to the number of slots
    between <math|s<rsub|i>> and <math|s<rsub|j>> (counting <math|s<rsub|j>>)
    on the time continuum. As such, we have
    <name|Slot-Offset><math|<around*|(|s<rsub|i>,s<rsub|i>|)>=0>.
  </definition>

  It is imperative for the security of the network that each block producer
  correctly determines the current slot numbers at a given time by regularly
  estimating the local clock offset in relation to the network (Definition
  <reference|defn-relative-syncronization>).\ 

  <\definition>
    <label|defn-relative-syncronization>The <with|font-series|bold|relative
    time synchronization> is a tuple of a slot number and a local clock
    timestamp <math|<around*|(|s<rsub|sync>, t<rsub|sync>|)>> describing the
    last point at which the slot numbers have been synchronized with the
    local clock.
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
    to be implemented and deployed.> For now, each block producer is required
    to synchronize its local clock using NTP instead. The current slot
    <math|s> is then calculated by <math|s<rsub|>=t<rsub|unix>/\<cal-T\>>
    where <math|t<rsub|unix>> is the current UNIX time in seconds since
    1970-01-01 00:00:00 UTC. That also entails that slot numbers are
    currently not reset at the beginning of each epoch.\ 
  </note>

  Polkadot does this synchronization without relying on any external clock
  source (e.g. through the <with|font-shape|italic|Network Time Protocol> or
  the <with|font-shape|italic|Global Positioning System>). To stay in
  synchronization, each producer is therefore required to periodically
  estimate its local clock offset in relation to the rest of the network.\ 

  This estimation depends on the two fixed parameters
  <with|font-series|bold|<math|k>> (Definition <reference|defn-prunned-best>)
  and <math|<with|font-series|bold|s<rsub|cq>>> (Definition
  <reference|defn-chain-quality>). These are chosen based on the results of a
  formal security analysis, currently assuming a <math|1 s \ >clock drift per
  day and targeting a probability lower than <math|0.5%> for an adversary to
  break BABE in 3 years with resistance against a network delay up to
  <math|<frac*|1|3>> of the slot time and a Babe constant
  (Definit<line-break>ion <reference|defn-babe-constant>) of <math|c=0.38>.

  <\definition>
    <label|defn-prunned-best>The <with|font-series|bold|pruned best chain>
    <math|<with|font-series|bold|C<rsup|\<#250C\>k>>> is the longest chain
    selected according to Definition <reference|defn-longest-chain> with the
    last k Blocks pruned. We chose <math|k=140>. The
    <with|font-series|bold|last (probabilistically) finalized block>
    describes the last block in this pruned best chain.
  </definition>

  <\definition>
    <label|defn-chain-quality>The <with|font-series|bold|chain quality>
    <math|<with|font-series|bold|s<rsub|cq>>> represents the number of slots
    that are used to estimate the local clock offset. Currently, it is set to
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
    <math|j> when node <math|j> has received block <math|B> for the first
    time. If the node <math|j> itself is the producer of <math|B>,
    <math|T<rsub|B><rsup|j>> is set equal to the time that the block is
    produced. The index <math|j> in <math|T<rsup|j><rsub|B>> notation may be
    dropped and B's arrival time is referred to by <math|T<rsub|B>> when
    there is no ambiguity about the underlying node.
  </definition>

  <todo|Currently still lacks a clear definition of when block arrival times
  are considered valid and how to differentiated imported block on initial
  sync from \Pfresh\Q blocks that were just produced.>

  <\definition>
    <label|defn-sync-period>A <with|font-series|bold|sync period> is an
    interval at which each validator (re-)evaluates its local clock offsets.
    The first sync period <math|\<frak-E\><rsub|1>> starts just after the
    genesis block is released. Consequently, each sync period
    <math|\<frak-E\><rsub|i>> starts after <math|\<frak-E\><rsub|i-1>>. The
    length of the sync period is equal to <math|s<rsub|qc>> as defined in
    Definition <reference|defn-chain-quality> and expressed in the number of
    slots.
  </definition>

  All validators are then required to run Algorithm
  <reference|algo-slot-time> at the beginning of each sync period (Definition
  <reference|defn-sync-period>) to update their synchronization using all
  block arrival times of the previous period. The algorithm should only be
  run once all the blocks in this period have been finalized, even if only
  probabilistically (Definition <reference|defn-prunned-best>). The target
  slot to which to synchronize should be the first slot in the new sync
  period.

  <\algorithm>
    <label|algo-slot-time><name|Median-Algorithm>(<math|\<frak-E\><rsub|j>>:
    sync period used for the estimate, <math|s<rsub|sync>:> slot time to
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

  <\big-figure|<image|figures/c06-babe_time_sync.eps|1par|||>>
    An exemplary result of Median Algorithm in first sync epoch with
    <math|s<rsub|cq>=9> and <math|k=1>.
  </big-figure>

  <subsection|Block Production>

  Throughout each epoch, each block producer should run Algorithm
  <reference|algo-block-production> to produce blocks during the slots it has
  been awarded during that epoch. The produced block needs to carry the
  <em|BABE header> as well as the <em|block signature> as Pre-Runtime and
  Seal digest items defined in Definition <reference|defn-babe-header> and
  <reference|defn-block-signature> respectively.

  <\definition>
    <label|defn-babe-header>The <strong|BABE Header> of block B, referred to
    formally by <strong|<math|H<rsub|BABE><around*|(|B|)>>> is a tuple and
    consists of the following components:

    <\equation*>
      <around*|(|d,\<pi\>,j,s|)>
    </equation*>

    in which:

    <\with|par-mode|center>
      <tabular|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<cwith|3|3|1|1|cell-halign|r>|<cwith|1|-1|1|-1|cell-hyphen|n>|<table|<row|<cell|<math|\<pi\>,d>:>|<cell|the
      results of the block lottery for slot s.
      >>|<row|<cell|<math|j>:>|<cell|the index of the block producer in the
      authority directory of the current epoch>>|<row|<cell|s:>|<cell|the
      slot at which the block is produced.>>>>>

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
    engine unique identifier defined in Definition
    <reference|defn-consensus-message-digest>. The Seal digest item is
    referred to as the <strong|BABE Seal>.
  </definition>

  \;

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
    <label|defn-epoch-randomness>For epoch <math|\<cal-E\>>, there is a
    32-byte <with|font-series|bold|randomness seed>
    <math|\<cal-R\><rsub|\<cal-E\>>> computed based on the previous epochs
    VRF outputs. For <math|\<cal-E\><rsub|0>> and <math|\<cal-E\><rsub|1>>,
    the randomness seed is provided in the genesis state.
  </definition>

  At the beginning of each epoch, <math|\<cal-E\><rsub|n>> the host will
  receive the randomness seed <math|\<cal-R\><rsub|\<cal-E\><rsub|n+1>>>(Definition
  <reference|defn-epoch-randomness>) necessary to participate in the block
  production lottery in the next epoch <math|\<cal-E\><rsub|n+1>> from the
  Runtime, through the <with|font-shape|italic|Next Epoch Data> consensus
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

  Algorithm <reference|algo-verify-slot-winner> runs as a part of the
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
    is where at its head, the block to be constructed, is

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
        <\IF>
          <name|Block-Is-FULL(<math|R>>)
        </IF>
      </state>

      <\state>
        <BREAK><END><END>
      </state>

      <\state>
        <space|2em><strong|if> <name|Should-Drop(R)>
      </state>

      <\state>
        <space|4em><name|Drop(E)>
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

    <item><name|Block-Is-Full> indicates that the maximum block size is being
    used.

    <item><name|Should-Drop> determines based on the result <em|R> whether
    the extrinsic should be dropped or remain in the extrinsics queue and
    scheduled for the next block. The <verbatim|ApplyExtrinsicResult> as
    defined in Definition <reference|defn-rte-apply-extrinsic-result>
    describes this behavior in more detail.

    <item><name|Drop> indicates removing the extrinsic from the extrinsic
    queue (Definition <reference|defn-transaction-queue>).

    <item><name|Add-Seal> adds the seal to the block as defined in Definition
    <reference|defn-digest> before sending it to peers. The seal is removed
    again before submitting it to the Runtime.
  </itemize-minus>

  <section|Finality><label|sect-finality>

  The Polkadot Host uses GRANDPA Finality protocol
  <cite|stewart_grandpa:_2019> to finalize blocks. Finality is obtained by
  consecutive rounds of voting by the validator nodes. Validators execute
  GRANDPA finality process in parallel to Block Production as an independent
  service. In this section, we describe the different functions that GRANDPA
  service performs to successfully participate in the block-finalization
  process.

  <subsection|Preliminaries>

  <\definition>
    <label|defn-grandpa-voter>A <strong|GRANDPA Voter>,
    <math|v><glossary-explain|<math|v>|GRANDPA voter node which casts vote in
    the finality protocol>, represented by a key pair
    <math|<around|(|k<rsup|pr><rsub|v>,v<rsub|id>|)>> where
    <math|k<rsub|v><rsup|pr>><glossary-explain|<math|k<rsub|v><rsup|pr>>|The
    private key of voter <math|v>> represents an <math|ED25519> private key,
    and <math|v<rsub|id>><glossary-explain|<math|v<rsub|id>>|The public key
    of voter <math|v>> represents the public key of <math|v>. It is a node
    running a GRANDPA protocol and broadcasting votes to finalize blocks in a
    Polkadot Host-based chain. The <strong|set of all GRANDPA voters> for a
    given block B is indicated by <math|\<bbb-V\><rsub|B>><glossary-explain|<math|\<bbb-V\><rsub|B>,\<bbb-V\>>|The
    set of all GRANDPA voters for at block <math|B>>. In that regard, we have
    <todo|change function name, only call at genesis, adjust V_B over the
    sections>

    <\equation*>
      \<bbb-V\><rsub|B>=<text|<verbatim|grandpa_authorities>><around*|(|B|)>
    </equation*>

    where <math|<math-tt|grandpa_authorities>> is the entry into the Runtime
    described in Section <reference|sect-rte-grandpa-auth>. We refer to
    <math|\<bbb-V\><rsub|B> > as <math|\<bbb-V\>><glossary-dup|<math|\<bbb-V\><rsub|B>,\<bbb-V\>>|>
    when there is no chance of ambiguity.

    Analogously, we say that a Polkadot node is a <strong|non-voter node> for
    block <math|B>, if it does not own any of the key pairs in
    <math|\<bbb-V\><rsub|B>>.
  </definition>

  <\definition>
    <label|defn-authority-set-id>The <strong|authority set Id>
    (<math|id<rsub|\<bbb-V\>>>) is an incremental counter which tracks the
    amount of authority list changes that occurred (Definition
    <reference|defn-consensus-message-digest>). Starting with the value of
    zero at genesis, the Polkadot Host increments this value by one every
    time a <strong|Scheduled Change> or a <strong|Forced Change> occurs. The
    authority set Id is an unsigned 64-bit integer.
  </definition>

  <\definition>
    <strong|GRANDPA state>, <math|GS><glossary-explain|<math|GS>|GRANDPA
    protocol state consisting of the set of voters, number of times voters
    set has changed and the current round number.>, is defined as
    <todo|verify V_id and id_V usage, unify>

    <\equation*>
      GS\<assign\><around|{|\<bbb-V\>,id<rsub|\<bbb-V\>>,r|}>
    </equation*>

    where:

    <math|<math-bf|\<bbb-V\>>>: is the set of voters.

    <math|<math-bf|id<rsub|\<bbb-V\>>>>: is the authority set ID as defined
    in Definition <reference|defn-authority-set-id>.

    <strong|r><glossary-explain|<math|r>|The voting round counter in the
    finality protocol>: is the votin<verbatim|>g round number.
  </definition>

  Following, we need to define how the Polkadot Host counts the number of
  votes for block <math|B>. First, a vote is defined as:

  <\definition>
    <label|defn-vote>A <strong|GRANDPA vote> or
    <math|V<rsub|\<nosymbol\>><around|(|B|)>><glossary-explain|<math|V<rsub|\<nosymbol\>><around|(|B|)>>|A
    GRANDPA vote casted in favor of block B>, represents a vote for block
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

    By <strong|<math|V<rsub|v><rsup|r,pv>>><glossary-explain|<math|V<rsub|v><rsup|r,pv>>|A
    GRANDPA vote casted by voter <math|v> during the pre-vote stage of round
    <math|r>> and <strong|<math|V<rsub|v><rsup|r,pc>>><glossary-explain|<math|V<rsub|v><rsup|r,pc>>|A
    GRANDPA vote casted by voter <math|v> during the pre-commit stage of
    round <math|r>>, we refer to the vote cast by voter <math|v> in round
    <math|r> (for block <math|B>) during the pre-vote and the pre-commit
    sub-round respectively.
  </definition>

  Voting is done by means of broadcasting voting messages to the network. The
  structure of these messages is described in Section
  <reference|sect-msg-grandpa>. Validators inform their peers about the block
  finalized in round <math|r> by broadcasting a commit message (see Algorithm
  <reference|algo-grandpa-round> for more details).\ 

  <\definition>
    <label|defn-sign-round-vote><strong|<math|Sign<rsup|r,stage><rsub|v<rsub|i>>>>
    refers to the signature of a voter for a specific message in a round and
    is formally defined as:

    <\equation*>
      Sign<rsup|r,stage><rsub|v<rsub|i>>:=Sig<rsub|ED25519><around*|(|msg,r,id<rsub|\<bbb-V\>>|)>
    </equation*>

    Where:

    <center|<tabular|<tformat|<cwith|2|3|1|1|cell-halign|r>|<cwith|2|3|1|1|cell-lborder|0ln>|<cwith|2|3|2|2|cell-halign|l>|<cwith|2|3|3|3|cell-halign|l>|<cwith|2|3|3|3|cell-rborder|0ln>|<cwith|2|3|1|3|cell-valign|c>|<table|<row|<cell|msg>|<cell|the
    message to be signed>|<cell|arbitrary>>|<row|<cell|r:>|<cell|round
    number>|<cell|unsigned 64-bit integer>>|<row|<cell|<math|id<rsub|\<bbb-V\>>>>|<cell|authority
    set Id (Definition <reference|defn-authority-set-id>) of
    v>|<cell|unsigned 64-bit integer>>>>>>

    \;
  </definition>

  <\definition>
    <label|defn-grandpa-justification>The <strong|justification> for block B
    in round <math|r>, <math|<with|font-series|bold|J<rsup|r,stage><around*|(|B|)>>>
    <glossary-explain|<math|J<rsup|r,stage><around*|(|B|)>>|The justification
    for pre-commiting or comming to block <math|B> in round <math|r> of
    finality protocol|>, is a vector of pairs of the type:

    <\equation*>
      <around*|(|V<around*|(|B<rprime|'>|)>,Sign<rsup|r,stage><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>,v<rsub|id>|)>
    </equation*>

    in which either

    <\equation*>
      B<rprime|'>\<geqslant\>B
    </equation*>

    or <math|V<rsup|r,pc><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>> is an
    equivocatory vote.

    \;

    In all cases, <math|Sign<rsup|r,stage><rsub|v<rsub|i>><around*|(|B<rprime|'>|)>>
    <glossary-explain|<math|Sign<rsup|r,stage><rsub|v<rsub|i>><around*|(|B|)>>|The
    signature of voter <math|v> on their voteto block B, broadcasted during
    the specified stage of finality round <math|r>>, as defined in Definition
    <reference|defn-sign-round-vote>, is the signature of voter
    <math|v<rsub|i>\<in\>\<bbb-V\><rsub|B>> broadcasted during either the
    pre-vote (stage = pv) or the pre-commit (stage = pc) sub-round of round
    r. A <strong|valid justification> must only contain up-to-one valid vote
    from each voter and must not contain more than two equivocatory votes
    from each voter.
  </definition>

  <\definition>
    <label|defn-finalizing-justification>We say
    <math|J<rsup|r,pc><around*|(|B|)>> <strong|justifies the finalization> of
    <math|B<rprime|'>\<geqslant\>B> <strong|for a non-voter node <math|n>> if
    the number of valid signatures in <math|J<rsup|r,pc><around*|(|B|)>> for
    <math|B<rprime|'>> is greater than <math|<frac|2|3><around|\||\<bbb-V\><rsub|B>|\|>>.
  </definition>

  Note that <math|J<rsup|r,pc><around*|(|B|)>> can only be used by a
  non-voter node to finalize a block. In contrast, a voter node can only be
  assured of the finality of block <math|B> by actively participating in the
  voting process. That is by invoking Algorithm
  <reference|algo-grandpa-round>. See Definition
  <reference|defn-finalized-block> for more details.

  \;

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

    represents the set of all equivocator voters in sub-round
    \P<math|stage>\Q of round <math|r><glossary-explain|<math|\<cal-E\><rsup|r,stage>>|The
    set of all equivocator voters in sub-round ``stage'' of round <math|r>>.
    When we want to refer to the number of<verbatim|> equivocators whose
    equivocation has been observed by voter <math|v> we refer to it
    by<glossary-explain|<math|\<cal-E\><rsup|r,stage><rsub|obs<around*|(|v|)>>>|The
    set of all equivocator voters in sub-round ``stage'' of round <math|r>
    observed by voter <math|v>>:

    <\equation*>
      \<cal-E\><rsup|r,stage><rsub|obs<around*|(|v|)>>
    </equation*>

    The Polkadot Host must detect equivocations committed by other validators
    and submit those to the Runtime as described in Section
    <reference|sect-grandpaapi_submit_report_equivocation_unsigned_extrinsic>.
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
    <math|VD<rsup|r,stage><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>><around|(|B|)>><glossary-explain|<math|VD<rsup|r,stage><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>><around|(|B|)>>|The
    set of observed direct votes for block B in round <math|r>> is equal to
    the union of:

    <\itemize-dot>
      <item>set of <underline|valid> votes
      <math|V<rsup|r,stage><rsub|v<rsub|i>>> cast in round <math|r> and
      received by v such that <math|V<rsup|r,stage><rsub|v<rsub|i>>=V<around|(|B|)>>.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-observed-votes>We refer to <strong|the set of total votes
    observed by voter <math|v> in sub-round \P<math|stage>\Q of round
    <math|r>> by <strong|<math|V<rsup|r,stage><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>>>><glossary-explain|<math|V<rsup|r,stage><rsub|obs<around|(|v|)>><rsup|\<nosymbol\>><rsub|\<nosymbol\>>>|The
    set of total votes observed by voter v in sub-round ``stage'' of round
    r>.

    The <strong|set of all observed votes by <math|v> in the sub-round stage
    of round <math|r> for block <math|B>>,
    <strong|<math|V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>>><glossary-explain|<math|V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>>|The
    set of all observed votes by <math|v> in the sub-round \Pstage\Q of round
    <math|r> (directly or indirectly) for block <math|B>> is equal to all of
    the observed direct votes cast for block <math|B> and all of the
    <math|B>'s descendants defined formally as:

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
    whose vote in the given stage has not been received. We define the
    <strong|total number of potential votes for Block <math|B> in round
    <math|r>> to be:\ 

    <\equation*>
      #V<rsup|r,stage><rsub|obv<around|(|v|)>,pot><around|(|B|)>\<assign\><around|\||V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>|\|>+<around*|\||V<rsup|r,stage><rsub|unobs<around*|(|v|)>>|\|>+Min<around*|(|<frac|1|3><around*|\||\<bbb-V\>|\|>,<around*|\||\<bbb-V\>|\|>-<around|\||V<rsup|r,stage><rsub|obs<around|(|v|)>><around|(|B|)>|\|>-<around*|\||V<rsup|r,stage><rsub|unobs<around*|(|v|)>>|\|>|)>
    </equation*>
  </definition>

  <\definition>
    The current <strong|pre-voted> block <strong|<math|B<rsup|r,pv><rsub|v>>><glossary-explain|<math|B<rsup|r,pv><rsub|v>>|The
    currently pre-voted block in round <math|r>. The GRANDPA GHOST of round
    <math|r>>, also know as GRANDPA GHOST is the block chosen by Algorithm
    <reference|algo-grandpa-ghost>:

    <\equation*>
      B<rsup|r,pv><rsub|v>\<assign\><text|<name|GRANDPA-GHOS\<#422\>>><around*|(|r|)>
    </equation*>
  </definition>

  Finally, we define when a voter <math|v> sees a round as completable, that
  is when they are confident that <math|B<rsub|v><rsup|r,pv>> is an upper
  bound for what is going to be finalized in this round.

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

  <subsection|Initiating the GRANDPA State>

  In order to participate coherently in the voting process, a validator must
  initiate its state and sync it with other active validators. In particular,
  considering that voting is happening in different distinct rounds where
  each round of voting is assigned a unique sequential round number
  <math|r<rsub|v>>, it needs to determine and set its round counter <math|r>
  equal to the voting round <math|r<rsub|n>> currently undergoing in the
  network.

  The process of joining a new voter set verses rejoining the current voter
  set after possible event of network disconnect are different from each
  other as being explained in this chapter.

  <subsubsection|Voter Set Changes>

  A GRANDPA voter node which is initiating GRANDPA protocol as part of
  joining a new authority set is required to execute Algorithm
  <reference|algo-initiate-grandpa>. Algorithm
  <reference|algo-initiate-grandpa> mandates the initialization procedure for
  GRANDPA protocol. Note that GRANDPA round number reset to 0 for every
  authority set change.

  <\algorithm>
    <label|algo-initiate-grandpa><name|Initiate-Grandpa>(

    <math|B<rsub|last>>: the last block which has been finalized on the chain
    (see Definition <reference|defn-finalized-block>)

    )
  <|algorithm>
    <\algorithmic>
      <\state>
        <name|Last-Finalized-Block><math|\<leftarrow\>><math|B<rsub|last>>
      </state>

      <\state>
        <name|Best-Final-Candidate(0)><math|\<leftarrow\>B<rsub|last>>
      </state>

      <\state>
        <name|GRANDPA-GHOST>(<math|0>)<math|\<leftarrow\>B<rsub|last>>
      </state>

      <\state>
        <name|Last-Completed-Round><math|\<leftarrow\>0>
      </state>

      <\state>
        <math|r<rsub|n>\<leftarrow\>1>
      </state>

      <\state>
        <name|Play-Grandpa-round>(<math|r<rsub|n>>)
      </state>
    </algorithmic>
  </algorithm>

  Voter set changes are signalled by Runtime via a consensus engine message
  as described in Section <reference|sect-consensus-message-digest>. When
  Authorities process such messages they must not vote on any block with a
  higher number than the block at which the change is supposed to happen. The
  new authority set should reinitiate GRANDPA protocol by executing Algorithm
  <reference|algo-initiate-grandpa>.

  <subsubsection|Rejoining the Same Voter Set>

  When a voter node rejoins the network after a possible disconnect from the
  reset of the voter set and there has been no change to the voter set, they
  must continue performing GRANDPA protocol at their latest state they have
  last observed before getting disconnected from the network, essentially
  ignoring any possible progress in GRANDPA finalization. It is through the
  process described in Section <reference|sect-grandpa-catchup> which they
  eventually gets updated about the current GRANDPA round and are able to
  synchronize their state with the rest of the voting set.

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
        <name|Last-Completed-Round><math|\<leftarrow\>r>
      </state>

      <\state>
        <name|Play-Grandpa-round>(<math|r+1>)
      </state>
    </algorithmic>
  </algorithm>

  Where:

  <\itemize-minus>
    <item><math|T> is sampled from a log-normal distribution whose mean and
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
  round<verbatim|>)>
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
    round 1, we get 67 pre-votes for <math|B<rsub|2>> and at least one
    pre-vote for <math|B<rsub|1>> which means that <name|GRANDPA-GHOST(1) =
    <math|B<rsub|2>>>.\ 

    Subsequently, potentially honest voters who could claim not seeing all
    the pre-votes for <math|B<rsub|2>> but receiving the pre-votes for
    <math|B<rsub|1>> would pre-commit to <math|B<rsub|1>>. In this way, we
    receive 66 pre-commits for <math|B<rsub|1>> and 1 pre-commit for
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
      1, no matter to whom the remaining pre-commits are going to be cast for
      (even with considering the possibility of 1/3 of voter equivocating)
      and therefore we have <name|Best-Final-Candidate>(<math|r>)<math|=B<rsub|1>>.
    </itemize-minus>

    Both scenarios unblock the Algorithm <reference|algo-grandpa-round>:14
    <name|Last-Finalized-Block><math|\<geqslant\>><name|Best-Final-Candidate>(<math|r>-1))
    albeit in different ways: the former with increasing the
    <name|Last-Finalized-Block> and the latter with decreasing
    <name|Best-Final-Candidate>(<math|r>-1).
  </example>

  <section|Block Finalization><label|sect-block-finalization>

  <\definition>
    <label|defn-finalized-block>A Polkadot relay chain node <math|n> should
    consider block <math|B> as <strong|finalized> if any of the following
    criteria hold for <math|B<rprime|'>\<geqslant\>B>:\ 

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

    <item>only for rounds <math|r> for which the node <math|n> has invoked
    Algorithm <reference|algo-grandpa-round> if <math|n> is a GRANDPA voter.
  </itemize-dot>

  Note that all Polkadot relay chain nodes are supposed to process GRANDPA
  commit messages regardless of their GRANDPA voter status.

  <subsection|Catching up><label|sect-grandpa-catchup>

  When a Polkadot node (re)joins the network during the process described in
  Chapter <reference|chap-bootstrapping>, it requests the history of state
  transition in the form of blocks, which it is missing. Each finalized block
  comes with the Justification of its finalization as defined in Definition
  <reference|defn-grandpa-justification>. Through this process, they can
  synchronize the authority list currently performing the finalization
  process.

  <subsubsection|Sending the catch-up requests><verbatim|><label|sect-sending-catchup-request>

  When a Polkadot node has the same authority list as a peer node who is
  reporting a higher number for the \Pfinalized round\Q field, it should send
  a catch-up request message, as specified in Definition
  <reference|defn-grandpa-catchup-request-msg>, to the reporting peer in
  order to catch-up to the more advanced finalized round, provided that the
  following criteria hold:

  <\itemize-minus>
    <item>the peer node is a GRANDPA voter, and

    <item>the last known finalized round for the Polkadot node is at least 2
    rounds behind the finalized round for the peer.\ 
  </itemize-minus>

  \ <subsubsection|Processing the catch-up requests>

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
    <item><math|id<rsub|\<bbb-V\>>> is the voter set id with which the
    serving node is operating

    <item><math|r> is the round number for which the catch-up is requested
    for.

    <item><math|\<bbb-P\>> is the set of immediate peers of node <math|v>.

    <item><name|Last-Completed-Round> is initiated in Algorithm
    <reference|algo-initiate-grandpa> and gets updated in Algorithm
    <reference|algo-grandpa-round> respectively.

    <item><math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>> is
    the catch-up response defined in Definition
    <reference|defn-grandpa-catchup-response-msg>.
  </itemize-minus>

  <subsubsection|Processing catch-up responses>

  A Catch-up response message contains critical information for the requester
  node to update their view on the active rounds which are being voted on by
  GRANDPA voters. As such, the requester node should verify the content of
  the catch-up response message and subsequently updates its view of the
  state of the finality of the Relay chain according to Algorithm
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

  <section|Bridge design (BEEFY)><label|sect-grandpa-beefy>

  <\todo>
    NOTE: The BEEFY protocol is currently in early development and subject to
    change
  </todo>

  \;

  The BEEFY (Bridge Effiency Enabling Finality Yielder) is a secondary
  protocol to GRANDPA to support efficient bridging between the Polkadot
  network (relay chain) and remote, segregated blockchains, such as Ethereum,
  which were not built with the Polkadot interchain operability in mind. The
  protocol allows participants of the remote network to verify finality
  proofs created by the Polkadot relay chain validators. In other words:
  clients in the Ethereum network should able to verify that the Polkadot
  network is at a specific state.

  \;

  Storing all the information necessary to verify the state of the remote
  chain, such as the block headers, is too expensive. BEEFY stores the
  information in a space-efficient way and clients can request additional
  information over the protocol.

  <subsection|Preliminaries>

  <\definition>
    Merkle Mountain Ranges, <strong|MMR>, as defined in Definition
    <todo|TODO> are used as an efficient way to send block headers and
    signatures to light clients.
  </definition>

  <\definition>
    <label|defn-beefy-statement>The <strong|statement> is the same piece of
    information which every relay chain validator is voting on. Namely, the
    MMR root of all the block header hashes leading up to the latest,
    finalized block.
  </definition>

  <\definition>
    <strong|<label|defn-beefy-witness-data>Witness data> contains the
    statement as defined in Definition <reference|defn-beefy-statement>, an
    array indicating which validator of the Polkadot network voted for the
    statement (but not the signatures themselves) and a MMR root of the
    signatures. The indicators of which validator voted for the statement are
    just claimes and provide no proofs . The network message is defined in
    Definition <reference|defn-grandpa-beefy-signed-commitment-witness> and
    the relayer saves it on the chain of the remote network.
  </definition>

  <\definition>
    <label|defn-beefy-light-client>A <strong|light client> is an abstract
    entity in a remote network such as Ethereum. It can be a node or a smart
    contract with the intent of requesting finality proofs from the Polkadot
    network. A light client reads the witness data as defined in Definition
    <reference|defn-beefy-witness-data> from the chain, then requests the
    signatures directly from the relayer in order to verify those.

    \;

    The light client is expected to know who the validators are and has
    access to their public keys.
  </definition>

  <\definition>
    <label|defn-beefy-relayer>A <strong|relayer> (or \Pprover\Q) is an
    abstract entity which takes finality proofs from the Polkadot network and
    makes those available to the light clients. Inherently, the relayer tries
    to convince the light clients that the finality proofs have been voted
    for by the Polkadot relay chain validators. The relayer operates offchain
    and can for example be a node or a collection of nodes.
  </definition>

  <subsection|Voting on Statements>

  The Polkadot Host signs a statement as defined in Definition
  <reference|defn-beefy-statement> and gossips it as part of a vote as
  defined in Definition <reference|defn-msg-beefy-gossip> to its peers on
  every new, finalized block. The Polkadot Host uses ECDSA for signing the
  statement, since Ethereum has better compatibility for it compared to
  SR25519 or ED25519. <todo|how does one map the validator set keys to the
  corresponding ECDSA keys?>

  <subsection|Committing Witnesses><label|sect-beefy-committing-witnesses>

  The relayer as defined in Definition <reference|defn-beefy-relayer>
  participates in the Polkadot network by collecting the gossiped votes as
  defined in Definition <reference|defn-msg-beefy-gossip>. Those votes are
  converted into the witness data structure as defined in Definition
  <reference|defn-beefy-witness-data>. and the relayer saves the data on the
  chain of the remote network. The occurrence of saving witnesses on remote
  networks is undefined.

  \;

  How the witness data is saved on the remote chain varies among networks or
  implementations. On Ethereum, for example, the relayer could call a smart
  contract which saves the witness data on chain and light clients can fetch
  this data.

  \;

  <todo|Add note about 2/3 majority>

  <subsection|Requesting Signed Commitments>

  A light client as defined in Definition <reference|defn-beefy-light-client>
  fetches the witness data as defined in Definition
  <reference|defn-beefy-witness-data> from the chain. Once the light client
  knows which validators apparently voted for the specified statement, it
  needs to request the signatures from the relayer to verify whether the
  claims are actually true. This is achieved by requesting signed commitments
  as defined in Definition <reference|defn-grandpa-beefy-signed-commitment>.

  How those signed commitments are requested by the light client and
  delivered by the relayer varies among networks or implementations. On
  Ethereum, for example, the light client can request the signed commitments
  in form of a transaction, which results in a response in form of a
  transaction. <todo|If the signed commitments are just transactions, which
  are stored in the blockchain, why bother with witnesses?>

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|5>
    <associate|save-aux|false>
  </collection>
</initial>
