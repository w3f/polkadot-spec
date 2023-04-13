---
title: Block Production
---

## -sec-num- Introduction {#id-introduction-3}

The Polkadot Host uses BABE protocol for block production. It is designed based on Ouroboros praos . BABE execution happens in sequential non-overlapping phases known as an ***epoch***. Each epoch on its turn is divided into a predefined number of slots. All slots in each epoch are sequentially indexed starting from 0. At the beginning of each epoch, the BABE node needs to run [Block-Production-Lottery](sect-block-production#algo-block-production-lottery) to find out in which slots it should produce a block and gossip to the other block producers. In turn, the block producer node should keep a copy of the block tree and grow it as it receives valid blocks from other block producers. A block producer prunes the tree in parallel by eliminating branches that do not include the most recent finalized blocks ([Definition -def-num-ref-](chap-state#defn-pruned-tree)).

### -sec-num- Block Producer {#id-block-producer}

A **block producer**, noted by ${\mathcal{{P}}}_{{j}}$, is a node running the Polkadot Host which is authorized to keep a transaction queue and which it gets a turn in producing blocks.

### -sec-num- Block Authoring Session Key Pair {#id-block-authoring-session-key-pair}

**Block authoring session key pair** ${\left({s}{{k}_{{j}}^{{s}}},{p}{{k}_{{j}}^{{s}}}\right)}$ is an SR25519 key pair which the block producer ${\mathcal{{P}}}_{{j}}$ signs by their account key ([Definition -def-num-ref-](id-cryptography-encoding#defn-account-key)) and is used to sign the produced block as well as to compute its lottery values in [Block-Production-Lottery](sect-block-production#algo-block-production-lottery).

###### Definition -def-num- Epoch and Slot {#defn-epoch-slot}

A block production **epoch**, formally referred to as ${\mathcal{{E}}}$, is a period with a pre-known starting time and fixed-length during which the set of block producers stays constant. Epochs are indexed sequentially, and we refer to the ${n}^{{{t}{h}}}$ epoch since genesis by ${\mathcal{{E}}}_{{n}}$. Each epoch is divided into equal-length periods known as block production **slots**, sequentially indexed in each epoch. The index of each slot is called a **slot number**. The equal length duration of each slot is called the **slot duration** and indicated by ${\mathcal{{T}}}$. Each slot is awarded to a subset of block producers during which they are allowed to generate a block.

|     |                                                                                                                                       |
|-----|---------------------------------------------------------------------------------------------------------------------------------------|
|     | Substrate refers to an epoch as "session" in some places, however, epoch should be the preferred and official name for these periods. |

###### Definition -def-num- Epoch and Slot Duration {#defn-epoch-duration}

We refer to the number of slots in epoch ${\mathcal{{E}}}_{{n}}$ by ${s}{c}_{{n}}$. ${s}{c}_{{n}}$ is set to the `duration` field in the returned data from the call of the Runtime entry `BabeApi_configuration` ([Section -sec-num-ref-](chap-runtime-api#sect-rte-babeapi-epoch)) at genesis. For a given block ${B}$, we use the notation **${s}_{{B}}$** to refer to the slot during which ${B}$ has been produced. Conversely, for slot ${s}$, ${\mathcal{{B}}}_{{c}}$ is the set of Blocks generated at slot ${s}$.

[Definition -def-num-ref-](sect-block-production#defn-epoch-subchain) provides an iterator over the blocks produced during a specific epoch.

###### Definition -def-num- Epoch Subchain {#defn-epoch-subchain}

By ${\text{SubChain}{\left({\mathcal{{E}}}_{{n}}\right)}}$ for epoch ${\mathcal{{E}}}_{{n}}$, we refer to the path graph of ${B}{T}$ containing all the blocks generated during the slots of epoch ${\mathcal{{E}}}_{{n}}$. When there is more than one block generated at a slot, we choose the one which is also on $\text{Longest-Chain}{\left({B}{T}\right)}$.

###### Definition -def-num- Equivocation {#defn-producer-equivocation}

A block producer **equivocates** if they produce more than one block at the same slot. The proof of equivocation are the given distinct headers that were signed by the validator and which include the slot number.

The Polkadot Host must detect equivocations committed by other validators and submit those to the Runtime as described in [Section -sec-num-ref-](chap-runtime-api#sect-babeapi_submit_report_equivocation_unsigned_extrinsic).

###### Definition -def-num- BABE Consensus Message {#defn-consensus-message-babe}

$\text{CM}_{{b}}$, the consensus message for BABE, is of the following format:

$$
\text{CM}_{{b}}={\left\lbrace\begin{matrix}{1}&{\left(\text{Auth}_{{C}},{r}\right)}\\{2}&{A}_{{i}}\\{3}&{D}\end{matrix}\right.}
$$

where

**1** implies *next epoch data*: The Runtime issues this message on every first
block of an epoch. The supplied authority set [Definition -def-num-ref-](chap-sync#defn-authority-list),
${\text{Auth}_C}$, and randomness [Definition -def-num-ref-](sect-block-production#defn-epoch-randomness), ${r}$, are used
in the next epoch $\mathcal E_n + 1$.

**2** implies *on disabled*: A 32-bit integer, ${A_i}$, indicating the
individual authority in the current authority list that should be immediately
disabled until the next authority set changes. This message initial intension
was to cause an immediate suspension of all authority functionality with the
specified authority.

**3** implies *next epoch descriptor*: These messages are only issued on
configuration change and in the first block of an epoch. The supplied
configuration data are intended to be used from the next epoch onwards.

$$
D = \{1, (c,2_{\text{nd}})\}
$$

where ${c}$ is the probability that a slot will not be empty
[Definition -def-num-ref-](sect-block-production#defn-babe-constant). It is encoded as a tuple of two unsigned 64-bit
integers ${c_{nominator},c_{denominator}}$ which are used to compute
the rational ${c = \frac{c_{nominator}}{c_{denominator}}}$.

${2_{\text{nd}}}$ describes what secondary slot [Definition -def-num-ref-](sect-block-production#defn-babe-secondary-slots),
if any, is to be used. It is encoded as one-byte varying datatype:

$$
s_{\text{2nd}} = \begin{cases}
0 \rightarrow \text{no secondary slot} \\
1 \rightarrow \text{plain secondary slot} \\
2 \rightarrow \text{secondary slot with VRF output}
\end{cases}
$$

## -sec-num- Block Production Lottery {#sect-block-production-lottery}

The babe constant ([Definition -def-num-ref-](sect-block-production#defn-babe-constant)) is initialized at genesis to the value returned by calling `BabeApi_configuration` ([Section -sec-num-ref-](chap-runtime-api#sect-rte-babeapi-epoch)). For efficiency reasons, it is generally updated by the Runtime through the *next config data* consensus message in the digest ([Definition -def-num-ref-](chap-state#defn-digest)) of the first block of an epoch for the next epoch.

A block producer aiming to produce a block during ${\mathcal{{E}}}_{{n}}$ should run \<algo-block-production-lottery\>\> to identify the slots it is awarded. These are the slots during which the block producer is allowed to build a block. The ${s}{k}$ is the block producer lottery secret key and ${n}$ is the index of the epoch for whose slots the block producer is running the lottery.

In order to ensure consistent block production, BABE uses secondary slots in case no authority won the (primary) block production lottery. Unlike the lottery, secondary slot assignees are know upfront publically ([Definition -def-num-ref-](sect-block-production#defn-babe-secondary-slots)). The Runtime provides information on how or if secondary slots are executed ([Section -sec-num-ref-](chap-runtime-api#sect-rte-babeapi-epoch)), explained further in [Definition -def-num-ref-](sect-block-production#defn-babe-secondary-slots).

###### Definition -def-num- BABE Constant {#defn-babe-constant}

The **BABE constant** is the probability that a slot will not be empty and used in the winning threshold calculation ([Definition -def-num-ref-](sect-block-production#defn-winning-threshold)). It’s expressed as a rational, ${\left({x},{y}\right)}$, where ${x}$ is the numerator and ${y}$ is the denominator.

###### Definition -def-num- Winning Threshold {#defn-winning-threshold}

The **Winning threshold** denoted by ${T}_{{{\mathcal{{E}}}_{{n}}}}$ is the threshold that is used alongside the result of [Block-Production-Lottery](sect-block-production#algo-block-production-lottery) to decide if a block producer is the winner of a specific slot. ${T}_{{{\mathcal{{E}}}_{{n}}}}$ is calculated as follows:

$$
{A}_{{w}}={\sum_{{{n}={1}}}^{{{\left|\text{Auth}_{{C}}{\left({B}\right)}\right|}}}}{\left({w}_{{A}}\in\text{Auth}_{{C}}{\left({B}\right)}_{{n}}\right)}
$$
$$
{T}_{{{\mathcal{{E}}}_{{n}}}}\:={1}-{\left({1}-{c}\right)}^{{\frac{{w}_{{a}}}{{A}_{{w}}}}}
$$

where ${A}_{{w}}$ is the total sum of all authority weights in the authority set ([Definition -def-num-ref-](chap-sync#defn-authority-list)) for epoch ${\mathcal{{E}}}_{{n}}$, ${w}_{{a}}$ is the weight of the block author and ${c}\in{\left({0},{1}\right)}$ is the BABE constant ([Definition -def-num-ref-](sect-block-production#defn-babe-constant)).

The numbers should be treated as 64-bit rational numbers.

### -sec-num- Primary Block Production Lottery {#id-primary-block-production-lottery}

A block producer aiming to produce a block during ${\mathcal{{E}}}_{{n}}$ should run the $\text{Block-Production-Lottery}$ algorithm to identify the slots it is awarded. These are the slots during which the block producer is allowed to build a block. The session secret key, ${s}{k}$, is the block producer lottery secret key and ${n}$ is the index of the epoch for whose slots the block producer is running the lottery.

\require sk \state ${r}\leftarrow$ \call{Epoch-Randomness}{${n}$} \for{${i}\:={1}~\text{}{f}{\left\lbrace\to\right\rbrace}~{s}{c}_{{n}}$} \state ${\left(\pi,{d}\right)}\leftarrow$ \call{VRF}{${r},{i},{s}{k}$} \state ${A}{\left[{i}\right]}\leftarrow{\left({d},\pi\right)}$ \endfor \return{A}

where $\text{Epoch-Randomness}$ is defined in ([Definition -def-num-ref-](sect-block-production#defn-epoch-randomness)), ${s}{c}_{{n}}$ is defined in [Definition -def-num-ref-](sect-block-production#defn-epoch-duration) , $\text{VRF}$ creates the BABE VRF transcript ([Definition -def-num-ref-](sect-block-production#defn-babe-vrf-transcript)) and ${e}_{{i}}$ is the epoch index, retrieved from the Runtime ([Section -sec-num-ref-](chap-runtime-api#sect-rte-babeapi-epoch)). ${s}_{{k}}$ and ${p}_{{k}}$ is the secret key respectively the public key of the authority. For any slot ${s}$ in epoch ${n}$ where ${o}<{T}_{{{\mathcal{{E}}}_{{n}}}}$ ([Definition -def-num-ref-](sect-block-production#defn-winning-threshold)), the block producer is required to produce a block.

|     |                                                                                                                                                                                                                                                     |
|-----|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | the secondary slots ([Definition -def-num-ref-](sect-block-production#defn-babe-secondary-slots)) are running along side the primary block production lottery and mainly serve as a fallback to in case no authority was selected in the primary lottery. |

###### Definition -def-num- Secondary Slots {#defn-babe-secondary-slots}

**Secondary slots** work along side primary slot to ensure consistent block production, as described in [Section -sec-num-ref-](sect-block-production#sect-block-production-lottery). The secondary assignee of a block is determined by calculating a specific value, ${i}_{{d}}$, which indicates the index in the authority set ([Definition -def-num-ref-](chap-sync#defn-authority-list)). The corresponding authority in that set has the right to author a secondary block. This calculation is done for every slot in the epoch, ${s}\in{s}{c}_{{n}}$ ([Definition -def-num-ref-](sect-block-production#defn-epoch-duration)).

$$
{p}\leftarrow{h}{\left(\text{Enc}_{\text{SC}}{\left({r},{s}\right)}\right)}
$$
$$
{i}_{{d}}\leftarrow{p}\text{mod}{A}_{{l}}
$$

where  
- ${r}$ is the Epoch randomness ([Definition -def-num-ref-](sect-block-production#defn-epoch-randomness)).

- ${s}$ is the slot number ([Definition -def-num-ref-](sect-block-production#defn-epoch-slot)).

- $\text{Enc}_{\text{SC}}{\left(\ldots\right)}$ encodes its inner value to the corresponding SCALE value.

- ${h}{\left(\ldots\right)}$ creates a 256-bit Blake2 hash from its inner value.

- ${A}_{{l}}$ is the lengths of the authority list ([Definition -def-num-ref-](chap-sync#defn-authority-list)).

If ${i}_{{d}}$ points to the authority, that authority must claim the secondary slot by creating a BABE VRF transcript ([Definition -def-num-ref-](sect-block-production#defn-babe-vrf-transcript)). The resulting values ${o}$ and ${p}$ are then used in the Pre-Digest item ([Definition -def-num-ref-](sect-block-production#defn-babe-header)). In case of secondary slots with plain outputs, respectively the Pre-Digest being of value *2*, the transcript respectively the VRF is skipped.

###### Definition -def-num- BABE Slot VRF transcript {#defn-babe-vrf-transcript}

The BABE block production lottery requires a specific transcript structure ([Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-transcript)). That structure is used by both primary slots ([Block-Production-Lottery](sect-block-production#algo-block-production-lottery)) and secondary slots ([Definition -def-num-ref-](sect-block-production#defn-babe-secondary-slots)).

$$
{t}_{{1}}\leftarrow\text{Transcript}{\left(\text{'BABE'}\right)}
$$
$$
{t}_{{2}}\leftarrow\text{append}{\left({t}_{{1}},\text{'slot number'},{s}\right)}
$$
$$
{t}_{{3}}\leftarrow\text{append}{\left({t}_{{2}},\text{'current epoch'},{e}_{{i}}\right)}
$$
$$
{t}_{{4}}\leftarrow\text{append}{\left({t}_{{3}},\text{'chain randomness'},{r}\right)}
$$
$$
{t}_{{5}}\leftarrow\text{append}{\left({t}_{{4}},\text{'vrf-nm-pk'},{p}_{{k}}\right)}
$$
$$
{t}_{{6}}\leftarrow\text{meta-ad}{\left({t}_{{5}},\text{'VRFHash'},\text{False}\right)}
$$
$$
{t}_{{7}}\leftarrow\text{meta-ad}{\left({t}_{{6}},{64}_{\text{le}},\text{True}\right)}
$$
$$
{h}\leftarrow\text{prf}{\left({t}_{{7}},\text{False}\right)}
$$
$$
{o}={s}_{{k}}\cdot{h}
$$
$$
{p}\leftarrow\text{dleq\_prove}{\left({t}_{{7}},{h}\right)}
$$

The operators are defined in [Definition -def-num-ref-](id-cryptography-encoding#defn-strobe-operations), $\text{dleq\_prove}$ in [Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-dleq-prove). The computed outputs, ${o}$ and ${p}$, are included in the block Pre-Digest ([Definition -def-num-ref-](sect-block-production#defn-babe-header)).

## -sec-num- Slot Number Calculation {#sect-slot-number-calculation}

It is imperative for the security of the network that each block producer correctly determines the current slot numbers at a given time by regularly estimating the local clock offset in relation to the network ([Definition -def-num-ref-](sect-block-production#defn-relative-synchronization)).

|     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|-----|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | **The calculation described in this section is still to be implemented and deployed**: For now, each block producer is required to synchronize its local clock using NTP instead. The current slot ${s}$ is then calculated by ${s}={t}_{\text{unix}}{\mathcal{{T}}}$ where ${\mathcal{{T}}}$ is defined in [Definition -def-num-ref-](sect-block-production#defn-epoch-slot) and ${t}_{\text{unix}}$ is defined in [Definition -def-num-ref-](id-cryptography-encoding#defn-unix-time). That also entails that slot numbers are currently not reset at the beginning of each epoch. |

Polkadot does this synchronization without relying on any external clock source (e.g. through the or the ). To stay in synchronization, each producer is therefore required to periodically estimate its local clock offset in relation to the rest of the network.

This estimation depends on the two fixed parameters ${k}$ ([Definition -def-num-ref-](sect-block-production#defn-prunned-best)) and ${s}_{{{c}{q}}}$ ([Definition -def-num-ref-](sect-block-production#defn-chain-quality)). These are chosen based on the results of a [formal security analysis](https://research.web3.foundation/en/latest/polkadot/block-production/Babe#-5.-security-analysis), currently assuming a ${1}{s}$ clock drift per day and targeting a probability lower than ${0.5}\%$ for an adversary to break BABE in 3 years with resistance against a network delay up to $\frac{{1}}{{3}}$ of the slot time and a Babe constant ([Definition -def-num-ref-](sect-block-production#defn-babe-constant)) of ${c}={0.38}$.

All validators are then required to run [Median-Algorithm](sect-block-production#algo-slot-time) at the beginning of each sync period ([Definition -def-num-ref-](sect-block-production#defn-sync-period)) to update their synchronization using all block arrival times of the previous period. The algorithm should only be run once all the blocks in this period have been finalized, even if only probabilistically ([Definition -def-num-ref-](sect-block-production#defn-prunned-best)). The target slot to which to synchronize should be the first slot in the new sync period.

###### Definition -def-num- Slot Offset {#defn-slot-offset}

Let ${s}_{{i}}$ and ${s}_{{j}}$ be two slots belonging to epochs ${\mathcal{{E}}}_{{k}}$ and ${\mathcal{{E}}}_{{l}}$. By **Slot-Offset**${\left({s}_{{i}},{s}_{{j}}\right)}$ we refer to the function whose value is equal to the number of slots between ${s}_{{i}}$ and ${s}_{{j}}$ (counting ${s}_{{j}}$) on the time continuum. As such, we have **Slot-Offset**${\left({s}_{{i}},{s}_{{i}}\right)}={0}$.

It is imperative for the security of the network that each block producer correctly determines the current slot numbers at a given time by regularly estimating the local clock offset in relation to the network ([Definition -def-num-ref-](sect-block-production#defn-relative-synchronization)).

###### Definition -def-num- Relative Time Synchronization {#defn-relative-synchronization}

The **relative time synchronization** is a tuple of a slot number and a local clock timestamp ${\left({s}_{\text{sync}},{t}_{\text{sync}}\right)}$ describing the last point at which the slot numbers have been synchronized with the local clock.

\require ${s}$ \return{${t}_{\text{sync}}+$\call{Slot-Offset}{${s}_{{{s}{y}{n}{c}}},{s}$}$\times{\mathcal{{{T}}}}$}

where ${s}$ is the slot number.

\require ${\mathfrak{{{E}}}},{s}_{{{s}{y}{n}{c}}}$ \state ${T}_{{s}}\leftarrow$ \for{${B}~\text{}{f}{\left\lbrace\in\right\rbrace}~{\mathfrak{{{E}}}}_{{j}}$} \state ${{t}_{{{e}{s}{t}}}^{{{B}}}}\leftarrow{T}_{{B}}+$\call{Slot-Offset}{${s}_{{B}},{s}_{{{s}{y}{n}{c}}}$}$\times{\mathcal{{{T}}}}$ \state ${T}_{{s}}\leftarrow{T}_{{s}}\cup{{t}_{{{e}{s}{t}}}^{{{B}}}}$ \endfor \return \call{Median}{${T}_{{s}}$}

where  
- ${\mathfrak{{{E}}}}$ is the sync period used for the estimate.

- ${s}_{\text{sync}}$ is the slot time to estimate.

- $\text{Slot-Offset}$ is defined in [Slot-Time](sect-block-production#algo-slot-offset).

- ${\mathcal{{{T}}}}$ is the slot duration defined in [Definition -def-num-ref-](sect-block-production#defn-epoch-slot).

###### Definition -def-num- Pruned Best Chain {#defn-prunned-best}

The **pruned best chain** ${C}^{{{r}^{{k}}}}$ is the longest selected chain ([Definition -def-num-ref-](chap-state#defn-longest-chain)) with the last ${k}$ Blocks pruned. We chose ${k}={140}$. The **last (probabilistic) finalized block** describes the last block in this pruned best chain.

###### Definition -def-num- Chain Quality {#defn-chain-quality}

The **chain quality** ${s}_{{{c}{q}}}$ represents the number of slots that are used to estimate the local clock offset. Currently, it is set to ${s}_{{{c}{q}}}={3000}$.

The prerequisite for such a calculation is that each producer stores the arrival time of each block ([Definition -def-num-ref-](sect-block-production#defn-block-time)) measured by a clock that is otherwise not adjusted by any external protocol.

###### Definition -def-num- Block Arrival Time {#defn-block-time}

The **block arrival time** of block ${B}$ for node ${j}$ formally represented by ${{T}_{{B}}^{{j}}}$ is the local time of node ${j}$ when node ${j}$ has received block ${B}$ for the first time. If the node ${j}$ itself is the producer of ${B}$, ${{T}_{{B}}^{{j}}}$ is set equal to the time that the block is produced. The index ${j}$ in ${{T}_{{B}}^{{j}}}$ notation may be dropped and B’s arrival time is referred to by ${T}_{{B}}$ when there is no ambiguity about the underlying node.

###### Definition -def-num- Sync Period {#defn-sync-period}

A is an interval at which each validator (re-)evaluates its local clock offsets. The first sync period ${\mathfrak{{E}}}_{{1}}$ starts just after the genesis block is released. Consequently, each sync period ${\mathfrak{{E}}}_{{i}}$ starts after ${\mathfrak{{E}}}_{{{i}-{1}}}$. The length of the sync period ([Definition -def-num-ref-](sect-block-production#defn-chain-quality)) is equal to ${s}_{{{q}{c}}}$and expressed in the number of slots.

###### Image -img-num- An exemplary result of Median Algorithm in first sync epoch with ${s}_{\text{cq}}={9}$ and ${k}={1}$. {#img-median-algorithm}

![](/img/median-algorithm-result.png)

## -sec-num- Production Algorithm {#block-production}

Throughout each epoch, each block producer should run [Invoke-Block-Authoring](sect-block-production#algo-block-production) to produce blocks during the slots it has been awarded during that epoch. The produced block needs to carry the *Pre-Digest* ([Definition -def-num-ref-](sect-block-production#defn-babe-header)) as well as the *block signature* ([Definition -def-num-ref-](sect-block-production#defn-block-signature)) as Pre-Runtime and Seal digest items.

###### Definition -def-num- Pre-Digest {#defn-babe-header}

The **Pre-Digest**, or BABE header, ${P}$, is a varying datatype of the following format:

$$
{P}={\left\lbrace\begin{matrix}{1}&\rightarrow&{\left({a}_{\text{id}},{s},{o},{p}\right)}\\{2}&\rightarrow&{\left({a}_{\text{id}},{s}\right)}\\{3}&\rightarrow&{\left({a}_{\text{id}},{s},{o},{p}\right)}\end{matrix}\right.}
$$

where  
- *1* indicates a primary slot with VRF outputs, *2* a secondary slot with plain outputs and *3* a secondary slot with VRF outputs ([Section -sec-num-ref-](sect-block-production#sect-block-production-lottery)). Plain outputs are no longer actively used and only exist for backwards compatibility reasons, respectively to sync old blocks.

- ${a}_{\text{id}}$ is the unsigned 32-bit integer indicating the index of the authority in the authority set ([Section -sec-num-ref-](chap-sync#sect-authority-set)) who authored the block.

- ${s}$ is the slot number ([Definition -def-num-ref-](sect-block-production#defn-epoch-slot)).

- ${o}$ is VRF output ([Block-Production-Lottery](sect-block-production#algo-block-production-lottery) respectively [Definition -def-num-ref-](sect-block-production#defn-babe-secondary-slots)).

- ${p}$ is VRF proof ([Block-Production-Lottery](sect-block-production#algo-block-production-lottery) respectively [Definition -def-num-ref-](sect-block-production#defn-babe-secondary-slots)).

The Pre-Digest must be included as a digest item of Pre-Runtime type in the header digest ([Definition -def-num-ref-](chap-state#defn-digest)) ${H}_{{d}}{\left({B}\right)}$.

\require ${s}{k},{p}{k},{n},{B}{T}$ \state ${A}\leftarrow$ \call{Block-production-lottery}{${s}{k},{n}$} \for{${s}\leftarrow{1}~\text{}{f}{\left\lbrace\to\right\rbrace}~{s}{c}_{{n}}$} \state \call{Wait-Until}{\call{Slot-Time}{${s}$}} \state ${\left({d},\pi\right)}\leftarrow{A}{\left[{s}\right]}$ \if{${d}<\tau$} \state ${C}_{{{B}{e}{s}{t}}}\leftarrow$ \call{Longest-Chain}{${B}{T}$} \state ${B}_{{s}}\leftarrow$ \call{Build-Block}{${C}_{{{B}{e}{s}{t}}}$} \state \call{Add-Digest-Item}{${B}_{{s}},\text{Pre-Runtime},{E}_{{{i}{d}}}{\left(\text{BABE}\right)},{H}_{\text{BABE}}{\left({B}_{{s}}\right)}$} \state \call{Add-Digest-Item}{${B}_{{s}},\text{Seal},{S}_{{B}}$} \state \call{Broadcast-Block}{${B}_{{s}}$} \endif \endfor

where $\text{BT}$ is the current block tree, $\text{Block-Production-Lottery}$ is defined in [Block-Production-Lottery](sect-block-production#algo-block-production-lottery) and $\text{Add-Digest-Item}$ appends a digest item to the end of the header digest ${H}_{{d}}{\left({B}\right)}$ ([Definition -def-num-ref-](chap-state#defn-digest)).

###### Definition -def-num- Block Signature {#defn-block-signature}

The **Block Signature** ${S}_{{B}}$ is a signature of the block header hash ([Definition -def-num-ref-](chap-state#defn-block-header-hash)) and defined as

$$
\text{Sig}_{{\text{SR25519},{\text{sk}_{{j}}^{{s}}}}}{\left({H}_{{h}}{\left({B}\right)}\right)}
$$

${m}$ should be included in ${H}_{{d}}{\left({B}\right)}$ as the Seal digest item ([Definition -def-num-ref-](chap-state#defn-digest)) of value:

$$
{\left({t},\text{id}{\left(\text{BABE}\right)},{m}\right)}
$$

in which, ${t}={5}$ is the seal digest identifier and $\text{id}{\left(\text{BABE}\right)}$ is the BABE consensus engine unique identifier ([Definition -def-num-ref-](chap-state#defn-digest)). The Seal digest item is referred to as the **BABE Seal**.

## -sec-num- Epoch Randomness {#sect-epoch-randomness}

At the beginning of each epoch, ${\mathcal{{E}}}_{{n}}$ the host will receive the randomness seed ${\mathcal{{R}}}_{{{\mathcal{{E}}}_{{{n}+{1}}}}}$ ([Definition -def-num-ref-](sect-block-production#defn-epoch-randomness)) necessary to participate in the block production lottery in the next epoch ${\mathcal{{E}}}_{{{n}+{1}}}$ from the Runtime, through the consensus message ([Definition -def-num-ref-](sect-block-production#defn-consensus-message-babe)) in the digest of the first block.

###### Definition -def-num- Randomness Seed {#defn-epoch-randomness}

For epoch ${\mathcal{{E}}}$, there is a 32-byte ${\mathcal{{R}}}_{{{\mathcal{{E}}}}}$ computed based on the previous epochs VRF outputs. For ${\mathcal{{E}}}_{{0}}$ and ${\mathcal{{E}}}_{{1}}$, the randomness seed is provided in the genesis state ([Section -sec-num-ref-](chap-runtime-api#sect-rte-babeapi-epoch)). For any further epochs, the randomness is retrieved from the consensus message ([Definition -def-num-ref-](sect-block-production#defn-consensus-message-babe)).

## -sec-num- Verifying Authorship Right {#sect-verifying-authorship}

When a Polkadot node receives a produced block, it needs to verify if the block producer was entitled to produce the block in the given slot by running [Verify-Authorship-Right](sect-block-production#algo-verify-authorship-right). [Verify-Slot-Winner](sect-block-production#algo-verify-slot-winner) runs as part of the verification process, when a node is importing a block.

\require $\text{Head}_{{{s}{\left({B}\right)}}}$ \state ${s}\leftarrow$ \call{Slot-Number-At-Given-Time}{${T}_{{B}}$} \state ${\mathcal{{{E}}}}_{{c}}\leftarrow$ \call{Current-Epoch}{} \state ${\left({D}_{{1}},\ldots,{D}_{{{\left|{H}_{{d}}{\left({B}\right)}\right|}}}\right)}\leftarrow{H}_{{d}}{\left({B}\right)}$ \state ${D}_{{s}}\leftarrow{D}_{{{\left|{H}_{{d}}{\left({B}\right)}\right|}}}$ \state ${H}_{{d}}{\left({B}\right)}\leftarrow\le{f}{t}{\left({D}_{{1}},\ldots,{D}_{{{\left|{H}_{{d}}{\left({B}\right)}\right|}-{1}}}{r}{i}{g}{h}{t}\right)}$ \comment{remove the seal from the digest} \state ${\left({i}{d},\text{Sig}_{{B}}\right)}\leftarrow\text{Dec}_{{{S}{C}}}{\left({D}_{{s}}\right)}$ \if{${i}{d}\ne{q}$ \textsc{Seal-Id}} \state \textbf{error} \`\`Seal missing'' \endif \state $\text{AuthorID}\leftarrow\text{AuthorityDirectory}^{{{\mathcal{{{E}}}}_{{c}}}}{\left[{H}_{{{B}{A}{B}{E}}}{\left({B}\right)}.\text{SingerIndex}\right]}$ \state \call{Verify-Signature}{$\text{AuthorID},{H}_{{h}}{\left({B}\right)},\text{Sig}_{{B}}$} \if{$\exists{B}'\in{B}{T}:{H}_{{h}}{\left({B}\right)}\ne{q}{H}_{{h}}{\left({B}\right)}$ \and ${s}_{{B}}={s}_{{B}}'$ \and $\text{SignerIndex}_{{B}}=\text{SignerIndex}_{{{B}'}}$} \state \textbf{error} \`\`Block producer is equivocating'' \endif \state \call{Verify-Slot-Winner}{${\left({d}_{{B}},\pi_{{B}}\right)},{s}_{{B}},\text{AuthorID}$}

where  
- $\text{Head}_{{s}}{\left({B}\right)}$ is the header of the block that’s being verified.

- ${T}_{{B}}$ is ${B}$’s arrival time ([Definition -def-num-ref-](sect-block-production#defn-block-time)).

- ${H}_{{d}}{\left({B}\right)}$ is the digest sub-component ([Definition -def-num-ref-](chap-state#defn-digest)) of $\text{Head}{\left({B}\right)}$ ([Definition -def-num-ref-](chap-state#defn-block-header)).

- The Seal ${D}_{{s}}$ is the last element in the digest array ${H}_{{d}}{\left({B}\right)}$ as described in [Definition -def-num-ref-](chap-state#defn-digest).

- $\text{Seal-Id}$ is the type index showing that a digest item ([Definition -def-num-ref-](chap-state#defn-digest)) of varying type ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-variable-type)) is of type *Seal*.

- $\text{AuthorityDirectory}^{{{\mathcal{{E}}}_{{c}}}}$ is the set of Authority ID for block producers of epoch ${\mathcal{{E}}}_{{c}}$.

  1.  $\text{AuthorId}$ is the public session key of the block producer.

- $\text{BT}$ is the pruned block tree ([Definition -def-num-ref-](chap-state#defn-pruned-tree)).

- $\text{Verify-Slot-Winner}$ is defined in [Verify-Slot-Winner](sect-block-production#algo-verify-slot-winner).

\require ${B}$ \state ${\mathcal{{{E}}}}_{{c}}\leftarrow$ \textsc{Current-Epoch} \state $\rho\leftarrow$ \call{Epoch-Randomness}{${c}$} \state \call{Verify-VRF}{$\rho,{H}_{{{B}{A}{B}{E}}}{\left({B}\right)}.{\left({d}_{{B}},\pi_{{B}}\right)},{H}_{{{B}{A}{B}{E}}}{\left({B}\right)}.{s},{c}$} \if{${d}_{{B}}\geq{s}{l}{a}{n}{t}\tau$} \state \textbf{error} \`\`Block producer is not a winner of the slot'' \endif

where  
1.  $\text{Epoch-Randomness}$ is defined in [Definition -def-num-ref-](sect-block-production#defn-epoch-randomness).

2.  ${H}_{\text{BABE}}{\left({B}\right)}$ is the BABE header defined in [Definition -def-num-ref-](sect-block-production#defn-babe-header).

3.  ${\left({o},{p}\right)}$ is the block lottery result for block ${B}$ ([Block-Production-Lottery](sect-block-production#algo-block-production-lottery)), respectively the VRF output ([Definition -def-num-ref-](sect-block-production#defn-babe-vrf-transcript)).

4.  $\text{Verify-VRF}$ is described in [Section -sec-num-ref-](id-cryptography-encoding#sect-vrf).

5.  ${T}_{{{\mathcal{{E}}}_{{n}}}}$ is the winning threshold as defined in [Definition -def-num-ref-](sect-block-production#defn-winning-threshold).

## -sec-num- Block Building Process {#sect-block-building}

The block building process is triggered by [Invoke-Block-Authoring](sect-block-production#algo-block-production) of the consensus engine which in turn runs [Build-Block](sect-block-production#algo-build-block).

\state ${P}_{{B}}\leftarrow$\call{Head}{${C}_{{{B}{e}{s}{t}}}$} \state $\text{Head}{\left({B}\right)}\leftarrow\le{f}{t}{\left({H}_{{p}}\leftarrow{H}_{{h}}{\left({P}_{{B}}\right)},{H}_{{i}}\leftarrow{H}_{{i}}{\left({P}_{{B}}\right)}+{1},{H}_{{r}}\leftarrow\phi,{H}_{{e}}\leftarrow\phi,{H}_{{d}}\leftarrow\phi{r}{i}{g}{h}{t}\right)}$ \state \call{Call-Runtime-Entry}{$\text{}{t}{\left\lbrace{C}{\quad\text{or}\quad}{e}$\right.}initialize${b}{l}{o}{c}{k}{\rbrace},\text{Head}{\left({B}\right)}$} \state \textsc{I-D}$\leftarrow$\call{Call-Runtime-Entry}{$\text{}{t}{\left\lbrace{B}{l}{o}{c}{k}{B}{u}{i}{l}{d}{e}{r}$\right.}inherent${e}{x}{t}{r}\in{s}{i}{c}{s}{\rbrace},$\textsc{Inherent-Data}} \for{${E}~\text{}{f}{\left\lbrace\in\right\rbrace}$\textsc{I-D}} \state \call{Call-Runtime-Entry}{$\text{}{t}{\left\lbrace{B}{l}{o}{c}{k}{B}{u}{i}{l}{d}{e}{r}$\right.}apply${e}{x}{t}{r}\in{s}{i}{c}{s}{\rbrace},{E}$} \endfor \while{\not \call{End-Of-Slot}{${s}$}} \state ${E}\leftarrow$ \call{Next-Ready-Extrinsic}{} \state ${R}\leftarrow$ \call{Call-Runtime-Entry}{$\text{}{t}{\left\lbrace{B}{l}{o}{c}{k}{B}{u}{i}{l}{d}{e}{r}$\right.}apply${e}{x}{t}{r}\in{s}{i}{c}{s}{\rbrace},{E}$} \if{\call{Block-Is-Full}{${R}$}} \break \endif \if{\call{Should-Drop}{${R}$}} \state \call{Drop}{${E}$} \endif \state $\text{Head}{\left({B}\right)}\leftarrow$ \call{Call-Runtime-Entry}{$\text{}{t}{\left\lbrace{B}{l}{o}{c}{k}{B}{u}{i}{l}{d}{e}{r}$\right.}finalize${b}{l}{o}{c}{k}{\rbrace},{B}$} \state ${B}\leftarrow$ \call{Add-Seal}{${B}$} \endwhile

where  
- ${C}_{\text{Best}}$ is the chain head at which the block should be constructed ("parent").

- ${s}$ is the slot number.

- $\text{Head}{\left({B}\right)}$ is defined in [Definition -def-num-ref-](chap-state#defn-block-header).

- $\text{Call-Runtime-Entry}$ is defined in [Definition -def-num-ref-](chap-state#defn-call-into-runtime).

- $\text{Inherent-Data}$ is defined in [Definition -def-num-ref-](chap-state#defn-inherent-data).

- $\text{End-Of-Slot}$ indicates the end of the BABE slot as defined [Median-Algorithm](sect-block-production#algo-slot-time) respectively [Definition -def-num-ref-](sect-block-production#defn-epoch-slot).

- $\text{Next-Ready-Extrinsic}$ indicates picking an extrinsic from the extrinsics queue ([Definition -def-num-ref-](chap-state#defn-transaction-queue)).

- $\text{Block-Is-Full}$ indicates that the maximum block size is being used.

- $\text{Should-Drop}$ determines based on the result ${R}$ whether the extrinsic should be dropped or remain in the extrinsics queue and scheduled for the next block. The *ApplyExtrinsicResult* ([Definition -def-num-ref-](chap-runtime-api#defn-rte-apply-extrinsic-result)) describes this behavior in more detail.

- $\text{Drop}$ indicates removing the extrinsic from the extrinsic queue ([Definition -def-num-ref-](chap-state#defn-transaction-queue)).

- $\text{Add-Seal}$ adds the seal to the block (<<\>\>) before sending it to peers. The seal is removed again before submitting it to the Runtime.
