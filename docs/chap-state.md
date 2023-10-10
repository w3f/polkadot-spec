---
title: -chap-num- States and Transitions
---
import Block from '/static/img/kaitai_render/block.svg';
import BlockBody from '/static/img/kaitai_render/block_body.svg';
import BlockHeader from '/static/img/kaitai_render/block_header.svg';
import Digest from '/static/img/kaitai_render/digest.svg';

import Pseudocode from '@site/src/components/Pseudocode';
import validateTransactionsAndStore from '!!raw-loader!@site/src/algorithms/validateTransactionsAndStore.tex';
import maintainTransactionPool from '!!raw-loader!@site/src/algorithms/maintainTransactionPool.tex';
import aggregateKey from '!!raw-loader!@site/src/algorithms/aggregateKey.tex';
import interactWithRuntime from '!!raw-loader!@site/src/algorithms/interactWithRuntime.tex';

## -sec-num- Introduction {#id-introduction}

###### Definition -def-num- Discrete State Machine (DSM) {#defn-state-machine}
:::definition
A **Discrete State Machine (DSM)** is a state transition system that admits a starting state and whose set of states and set of transitions are countable. Formally, it is a tuple of

$$
(\Sigma, S, s_0, \delta)
$$

**where**

- $\Sigma$ is the countable set of all possible inputs.

- ${S}$ is a countable set of all possible states.

- ${s}_{{0}}\in{S}$ is the initial state.

- $\delta$ is the state-transition function, known as **Runtime** in the Polkadot vocabulary, such that

$$
\delta : S \times \Sigma \rightarrow S
$$

:::
###### Definition -def-num- Path Graph {#defn-path-graph}
:::definition

A **path graph** or a **path** of ${n}$ nodes, formally referred to as **${P}_{{n}}$**, is a tree with two nodes of vertex degree 1 and the other n-2 nodes of vertex degree 2. Therefore, ${P}_{{n}}$ can be represented by sequences of ${\left({v}_{{1}},\ldots,{v}_{{n}}\right)}$ where ${e}_{{i}}={\left({v}_{{i}},{v}_{{{i}+{1}}}\right)}$ for ${1}\le{i}\le{n}-{1}$ is the edge which connect ${v}_{{i}}$ and ${v}_{{{i}+{1}}}$.

:::
###### Definition -def-num- Blockchain {#defn-blockchain}
::::definition

A **blockchain** ${C}$ is a [directed path graph](https://en.wikipedia.org/wiki/Directed_graph). Each node of the graph is called **Block** and indicated by **${B}$**. The unique sink of ${C}$ is called **Genesis Block**, and the source is called the $\text{Head}$ of ${C}$. For any vertex ${\left({B}_{{1}},{B}_{{2}}\right)}$ where ${B}_{{1}}\rightarrow{B}_{{2}}$ we say ${B}_{{2}}$ is the **parent** of ${B}_{{1}}$, which is the **child** of ${B}_{{2}}$, respectively. We indicate that by:

$$
B_2 := P(B_1)
$$

The parent refers to the child by its hash value ([Definition -def-num-ref-](chap-state#defn-block-header)), making the path graph tamper-proof since any modifications to the child would result in its hash value being changed.

:::info
The term "blockchain" can also be used as a way to refer to the network or system that interacts or maintains the directed path graph.
:::

::::
### -sec-num- Block Tree {#id-block-tree}

In the course of formation of a (distributed) blockchain, it is possible that the chain forks into multiple subchains in various block positions. We refer to this structure as a *block tree*:

###### Definition -def-num- Block {#defn-block-tree}
:::definition

The **block tree** of a blockchain, denoted by ${B}{T}$ is the union of all different versions of the blockchain observed by the Polkadot Host such that every block is a node in the graph and ${B}_{{1}}$ is connected to ${B}_{{2}}$ if ${B}_{{1}}$ is a parent of ${B}_{{2}}$.
:::

When a block in the block tree gets finalized, there is an opportunity to prune the block tree to free up resources into branches of blocks that do not contain all of the finalized blocks or those that can never be finalized in the blockchain ([Chapter -chap-num-ref-](sect-finality)).

###### Definition -def-num- Pruned Block Tree {#defn-pruned-tree}
:::definition

By **Pruned Block Tree**, denoted by $\text{PBT}$, we refer to a subtree of the block tree obtained by eliminating all branches which do not contain the most recent finalized blocks ([Definition -def-num-ref-](sect-finality#defn-finalized-block)). By **pruning**, we refer to the procedure of ${B}{T}\leftarrow\text{PBT}$. When there is no risk of ambiguity and it is safe to prune BT, we use $\text{BT}$ to refer to $\text{PBT}$.
:::

[Definition -def-num-ref-](chap-state#defn-chain-subchain) gives the means to highlight various branches of the block tree.

###### Definition -def-num- Subchain {#defn-chain-subchain}
:::definition

Let ${G}$ be the root of the block tree and ${B}$ be one of its nodes. By $\text{Chain}{\left({B}\right)}$, we refer to the path graph from ${G}$ to ${B}$ in $\text{BT}$. Conversely, for a chain ${C}=\text{Chain}{\left({B}\right)}$, we define **the head of ${C}$** to be ${B}$, formally noted as ${B}\:=\overline{{C}}$. We define ${\left|{C}\right|}$, the length of ${C}$ as a path graph.

If ${B}'$ is another node on $\text{Chain}{\left({B}\right)}$, then by $\text{SubChain}{\left({B}',{B}\right)}$ we refer to the subgraph of $\text{Chain}{\left({B}\right)}$ path graph which contains ${B}$ and ends at ${B}'$ and by ${\left|\text{SubChain}{\left({B}',{B}\right)}\right|}$ we refer to its length.

Accordingly, ${\mathbb{{C}}}_{{{B}'}}{\left({B}{T}\right)}$ is the set of all subchains of ${B}{T}$ rooted at ${B}'$. The set of all chains of ${B}{T}$,${\mathbb{{C}}}_{{G}}{\left({B}{T}\right)}$ is denoted by ${\mathbb{{C}}}{\left({B}{T}\right)}$ or simply ${\mathbb{{C}}}$, for the sake of brevity.

:::
###### Definition -def-num- Longest Chain {#defn-longest-chain}
:::definition

We define the following complete order over ${\mathbb{{C}}}$ as follows. For chains ${C}_{{1}},{C}_{{2}}\in{\mathbb{{C}}}$ we have that ${C}_{{1}}>{C}_{{2}}$ if either ${\left|{C}_{{1}}\right|}>{\left|{C}_{{2}}\right|}$ or ${\left|{C}_{{1}}\right|}={\left|{C}_{{2}}\right|}$.

If ${\left|{C}_{{1}}\right|}={\left|{C}_{{2}}\right|}$ we say ${C}_{{1}}>{C}_{{2}}$ if and only if the block arrival time ([Definition -def-num-ref-](sect-block-production#defn-block-time)) of $\overline{{C}}_{{1}}$ is less than the block arrival time of $\overline{{C}}_{{2}}$, from the *subjective perspective* of the Host. We define the $\text{Longest-Chain}{\left({B}{T}\right)}$ to be the maximum chain given by this order.

:::
###### Definition -def-num- Longest Path {#defn-longest-path}
:::definition

$\text{Longest-Path}{\left({B}{T}\right)}$ returns the path graph of ${B}{T}$ which is the longest among all paths in ${B}{T}$ and has the earliest block arrival time ([Definition -def-num-ref-](sect-block-production#defn-block-time)). $\text{Deepest-Leaf}{\left({B}{T}\right)}$ returns the head of $\text{Longest-Path}{\left({B}{T}\right)}$ chain.
:::

Because every block in the blockchain contains a reference to its parent, it is easy to see that the block tree is de facto a tree. A block tree naturally imposes partial order relationships on the blocks as follows:

###### Definition -def-num- Descendant and Ancestor {#defn-descendant-ancestor}
:::definition

We say ${B}$ is **descendant** of ${B}'$, formally noted as ${B}>{B}'$, if ${\left({\left|{B}\right|}>{\left|{B}'\right|}\right)}\in{C}$. Respectively, we say that ${B}'$ is an **ancestor** of ${B}$, formally noted as ${B}<{B}'$, if ${\left({\left|{B}\right|}<{\left|{B}'\right|}\right)}\in{C}$.

:::
## -sec-num- State Replication {#sect-state-replication}

Polkadot nodes replicate each other’s states by syncing the histories of the extrinsics. This, however, is only practical if a large set of transactions are batched and synced at the same time. The structure in which the transactions are journaled and propagated is known as a block of extrinsics ([Section -sec-num-ref-](chap-state#sect-block-format)). Like any other replicated state machine, state inconsistencies can occur between Polkadot replicas. [Section -sec-num-ref-](chap-state#sect-managing-multiple-states) gives an overview of how a Polkadot Host node manages multiple variants of the state.

### -sec-num- Block Format {#sect-block-format}

A Polkadot block consists a *block header* ([Definition -def-num-ref-](chap-state#defn-block-header)) and a *block body* ([Definition -def-num-ref-](chap-state#defn-block-body)). The *block body*, in turn, is made up out of *extrinsics* , which represent the generalization of the concept of *transactions*. *Extrinsics* can contain any set of external data the underlying chain wishes to validate and track.

###### Image -img-num- Block {#img-block}

<Block className="graphviz fix-img-size" />

###### Definition -def-num- Block Header {#defn-block-header}
:::definition

The **header of block B**, ${H}_{{h}}{\left({B}\right)}$, is a 5-tuple containing the following elements:

- **parent_hash:** formally indicated as ${H}_{{p}}$, is the 32-byte Blake2b hash ([Section -sec-num-ref-](id-cryptography-encoding#sect-blake2)) of the SCALE encoded parent block header ([Definition -def-num-ref-](chap-state#defn-block-header-hash)).

- **number:** formally indicated as ${H}_{{i}}$, is an integer, which represents the index of the current block in the chain. It is equal to the number of the ancestor blocks. The genesis state has the number 0.

- **state_root:** formally indicated as ${H}_{{r}}$, is the root of the Merkle trie, whose leaves implement the storage for the system.

- **extrinsics\_root:** is the field which is reserved for the Runtime to validate the integrity of the extrinsics composing the block body. For example, it can hold the root hash of the Merkle trie which stores an ordered list of the extrinsics being validated in this block. The extrinsics\_root is set by the runtime and its value is opaque to the Polkadot Host. This element is formally referred to as ${H}_{{e}}$.

- **digest:** this field is used to store any chain-specific auxiliary data, which could help the light clients interact with the block without the need of accessing the full storage as well as consensus-related data including the block signature. This field is indicated as ${H}_{{d}}$ ([Definition -def-num-ref-](chap-state#defn-digest)).

:::
###### Image -img-num- Block Header {#img-block-header}

<BlockHeader className="graphviz fix-img-size" />

###### Definition -def-num- Header Digest {#defn-digest}
:::definition

The header **digest** of block ${B}$ formally referred to by ${H}_{{d}}{\left({B}\right)}$ is an array of **digest items** ${{H}_{{d}}^{{i}}}$’s, known as digest items of varying data type ([Definition -def-num-ref-](id-cryptography-encoding#defn-varrying-data-type)) such that:

$$
H_d(B) := H_d^1, ..., H_d^n
$$

where each digest item can hold one of the following type identifiers:

$$
H_d^i = \begin{cases}
4 \text{ } \rarr \text{ } (t, \text{id}, m) \\
5 \text{ } \rarr \text{ } (t, \text{id}, m) \\
6 \text{ } \rarr \text{ } (t, \text{id}, m) \\
8 \text{ } \rarr \text{ } (t)
\end{cases}
$$

**where**  
- $\text{id}$ is a 4-byte ASCII encoded consensus engine identifier

- $\text{m}$ is a SCALE-encoded byte array containing the message payload

$t = 4$ **Consensus Message**, contains scale-encoded message $m$ from the Runtime to the consensus engine. The receiving engine is determined by the *id* identifier:
- *id* = BABE: a message to BABE engine ([Definition -def-num-ref-](sect-block-production#defn-consensus-message-babe))
- *id* = FRNK: a message to GRANDPA engine ([Definition -def-num-ref-](sect-finality#defn-consensus-message-grandpa))
- *id* = BEEF: a message to BEEFY engine ([Definition -def-num-ref-](sect-finality#defn-consensus-message-beefy))


$t = 5$ **Seal**, is produced by the consensus engine and proves the authorship of the block producer. The engine used for this is provided through *id* (at the moment, `BABE`), while $m$ contains the scale-encoded signature ([Definition -def-num-ref-](sect-block-production#defn-block-signature)) of the block producer. In particular, the Seal digest item must be the last item in the digest array and must be stripped off by the Polkadot Host before the block is submitted to any Runtime function, including for validation. The Seal must be added back to the digest afterward.

$t = 6$ **Pre-Runtime digest**, contains messages from the consensus engines to the runtime. Currently only used by BABE to pass the scale encoded BABE Header ([Definition -def-num-ref-](sect-block-production#defn-babe-header)) in $m$ with *id* = `BABE`.

$t = 8$ **Runtime Environment Updated digest**, indicates that changes regarding the Runtime code or heap pages ([Section -sec-num-ref-](chap-state#sect-memory-management)) occurred. No additional data is provided.

:::
###### Image -img-num- Digest {#img-digest}

<Digest className="graphviz fix-img-size" />

###### Definition -def-num- Header Hash {#defn-block-header-hash}
:::definition

The **block header hash of block ${B}$**, ${H}_{{h}}{\left({B}\right)}$, is the hash of the header of block ${B}$ encoded by simple codec:

$$
\displaystyle{H}_{{h}}{\left({B}\right)}\:=\text{Blake2b}{\left(\text{Enc}_{{{S}{C}}}{\left(\text{Head}{\left({B}\right)}\right)}\right)}
$$

:::
###### Definition -def-num- Block Body {#defn-block-body}
:::definition

The block body consists of a sequence of extrinsics, each encoded as a byte array. The content of an extrinsic is completely opaque to the Polkadot Host. As such, from the point of the Polkadot Host, and is simply a SCALE encoded array of byte arrays. The **body of Block** ${B}$ represented as $\text{Body}{\left({B}\right)}$ is defined to be:

$$
\text{Body}(B) := \text{Enc}_{SC}(E_1,...,E_n)
$$

Where each ${E}_{{i}}\in{\mathbb{{B}}}$ is a SCALE encoded extrinsic.

###### Image -img-num- Block Body {#img-block-body}

<BlockBody className="graphviz fix-img-size"/>
:::

## -sec-num- Extrinsics {#sect-extrinsics}

The block body consists of an array of extrinsics. In a broad sense, extrinsics are data from outside of the state which can trigger state transitions. This section describes extrinsics and their inclusion into blocks.

### -sec-num- Preliminaries {#id-preliminaries}

The extrinsics are divided into two main categories defined as follows:

**Transaction extrinsics** are extrinsics which are signed using either of the key types ([Section -sec-num-ref-](id-cryptography-encoding#sect-cryptographic-keys)) and broadcasted between the nodes. **Inherent extrinsics** are unsigned extrinsics that are generated by Polkadot Host and only included in the blocks produced by the node itself. They are broadcasted as part of the produced blocks rather than being gossiped as individual extrinsics.

The Polkadot Host does not specify or limit the internals of each extrinsics and those are defined and dealt with by the Runtime ([Definition -def-num-ref-](chap-state#defn-state-machine)). From the Polkadot Host point of view, each extrinsics is simply a SCALE-encoded blob ([Section -sec-num-ref-](id-cryptography-encoding#sect-scale-codec)).

### -sec-num- Transactions {#id-transactions}

Transaction are submitted and exchanged through *Transactions* network messages ([Section -sec-num-ref-](chap-networking#sect-msg-transactions)). Upon receiving a Transactions message, the Polkadot Host decodes the SCALE-encoded blob and splits it into individually SCALE-encoded transactions.

Alternatively, transactions can be submitted to the host by off-chain worker through the Host API ([Section -sec-num-ref-](chap-host-api#sect-ext-offchain-submit-transaction)).

Any new transaction should be submitted to the Runtime ([Section -sec-num-ref-](chap-runtime-api#sect-rte-validate-transaction)). This will allow the Polkadot Host to check the validity of the received transaction against the current state and if it should be gossiped to other peers. If it considers the submitted transaction as valid, the Polkadot Host should store it for inclusion in future blocks. The whole process of handling new transactions is described in more detail by [Validate-Transactions-and-Store](chap-state#algo-validate-transactions).

Additionally, valid transactions that are supposed to be gossiped are propagated to connected peers of the Polkadot Host. While doing so the Polkadot Host should keep track of peers already aware of each transaction. This includes peers which have already gossiped the transaction to the node as well as those to whom the transaction has already been sent. This behavior is mandated to avoid resending duplicates and unnecessarily overloading the network. To that aim, the Polkadot Host should keep a *transaction pool* and a *transaction queue* defined as follows:

###### Definition -def-num- Transaction Queue {#defn-transaction-queue}
:::definition

The **Transaction Queue** of a block producer node, formally referred to as ${T}{Q}$ is a data structure which stores the transactions ready to be included in a block sorted according to their priorities ([Section -sec-num-ref-](chap-networking#sect-msg-transactions)). The **Transaction Pool**, formally referred to as ${T}{P}$, is a hash table in which the Polkadot Host keeps the list of all valid transactions not in the transaction queue.
:::
Furthermore, [Validate-Transactions-and-Store](chap-state#algo-validate-transactions) updates the transaction pool and the transaction queue according to the received message:

###### Algorithm -algo-num- Validate Transactions and Store {#algo-validate-transactions}
:::algorithm
<Pseudocode
    content={validateTransactionsAndStore}
    algID="validateTransactionsAndStore"
    options={{ "lineNumber": true }}
/>

**where**  
- ${M}_{{T}}$ is the transaction message (offchain transactions?)

- $\text{Dec}_{{{S}{C}}}$ decodes the SCALE encoded message.

- $\text{Longest-Chain}$ is defined in [Definition -def-num-ref-](chap-state#defn-longest-chain).

- ${\tt{TaggedTransactionQueue\_validate\_transaction}}$ is a Runtime entrypoint specified in [Section -sec-num-ref-](chap-runtime-api#sect-rte-validate-transaction) and ${Requires}{\left({R}\right)}$, ${Priority}{\left({R}\right)}$ and ${Propagate}{\left({R}\right)}$ refer to the corresponding fields in the tuple returned by the entrypoint when it deems that ${T}$ is valid.

- $\text{Provided-Tags}{\left({T}\right)}$ is the list of tags that transaction ${T}$ provides. The Polkadot Host needs to keep track of tags that transaction ${T}$ provides as well as requires after validating it.

- $\text{Insert-At}{\left({T}{Q},{T},\text{Requires}{\left({R}\right)},\text{Priority}{\left({R}\right)}\right)}$ places ${T}$ into ${T}{Q}$ approperietly such that the transactions providing the tags which ${T}$ requires or have higher priority than ${T}$ are ahead of ${T}$.

- $\text{Maintain-Transaction-Pool}$ is described in [Maintain-Transaction-Pool](chap-state#algo-maintain-transaction-pool).

- $\text{ShouldPropagate}$ indicates whether the transaction should be propagated based on the `Propagate` field in the `ValidTransaction` type as defined in [Definition -def-num-ref-](chap-runtime-api#defn-valid-transaction), which is returned by ${\mathtt{\text{TaggedTransactionQueue\_validate\_transaction}}}$.

- $\text{Propagate}{\left({T}\right)}$ sends ${T}$ to all connected peers of the Polkadot Host who are not already aware of ${T}$.
:::

###### Algorithm -algo-num- Maintain Transaction Pool {#algo-maintain-transaction-pool}
:::algorithm
<Pseudocode
    content={maintainTransactionPool}
    algID="maintainTransactionPool"
    options={{ "lineNumber": true }}
/>

::::info
This has not been defined yet.
::::
:::

### -sec-num- Inherents {#sect-inherents}

Inherents are unsigned extrinsics inserted into a block by the block author and as a result are not stored in the transaction pool or gossiped across the network. Instead, they are generated by the Polkadot Host by passing the required inherent data, as listed in [Table -tab-num-ref-](chap-state#tabl-inherent-data), to the Runtime method ${\mathtt{\text{BlockBuilder\_inherent\_extrinsics}}}$ ([Section -sec-num-ref-](chap-runtime-api#defn-rt-builder-inherent-extrinsics)). Then the returned extrinsics should be included in the current block as explained in [Build-Block](sect-block-production#algo-build-block).

###### Table -tab-num- Inherent Data {#tabl-inherent-data}

| Identifier | Value Type | Description |
|------------|------------|-------------|
| timstap0   | Unsigned 64-bit integer | Unix epoch time ([Definition -def-num-ref-](id-cryptography-encoding#defn-unix-time)) |
| babeslot   | Unsigned 64-bit integer | The babe slot (*DEPRECATED*) ([Definition -def-num-ref-](sect-block-production#defn-epoch-slot)) |
| parachn0   | Parachain inherent data ([Definition -def-num-ref-](chapter-anv#defn-parachain-inherent-data)) | Parachain candidate inclusion ([Section -sec-num-ref-](chapter-anv#sect-candidate-inclusion)) |

###### Definition -def-num- Inherent Data {#defn-inherent-data}
:::definition

`Inherent-Data` is a hashtable ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)), an array of key-value pairs consisting of the inherent 8-byte identifier and its value, representing the totality of inherent extrinsics included in each block. The entries of this hash table which are listed in [Table -tab-num-ref-](chap-state#tabl-inherent-data) are collected or generated by the Polkadot Host and then handed to the Runtime for inclusion ([Build-Block](sect-block-production#algo-build-block)).

:::
## -sec-num- State Storage Trie {#sect-state-storage}

For storing the state of the system, Polkadot Host implements a hash table storage where the keys are used to access each data entry. There is no assumption on the size of the key or on the size of the data stored under them, besides the fact that they are byte arrays with specific upper limits on their length. The limit is imposed by the encoding algorithms to store the key and the value in the storage trie ([Section -sec-num-ref-](id-cryptography-encoding#sect-sc-length-and-compact-encoding)).

### -sec-num- Accessing System Storage {#id-accessing-system-storage}

The Polkadot Host implements various functions to facilitate access to the system storage for the Runtime ([Section -sec-num-ref-](chap-state#sect-entrypoints-into-runtime)). Here we formalize the access to the storage when it is being directly accessed by the Polkadot Host (in contrast to Polkadot runtime).

###### Definition -def-num- Stored Value {#defn-stored-value}
:::definition

The ${\mathsf{\text{StoredValue}}}$ function retrieves the value stored under a specific key in the state storage and is formally defined as:

$$
\sf \text{StoredValue: } \mathcal K \rarr \mathcal V
$$

$$
k \rarr \begin{cases}
v \text{ if } (k,v) \text{ exists in state storage} \\
\phi \text{ otherwise}
\end{cases}
$$

where ${\mathcal{{K}}}\subset{\mathbb{{B}}}$ and ${\mathcal{{V}}}\subset{\mathbb{{B}}}$ are respectively the set of all keys and values stored in the state storage. ${\mathcal{{V}}}$ can be an empty value.

:::
### -sec-num- General Structure {#id-general-structure}

In order to ensure the integrity of the state of the system, the stored data needs to be re-arranged and hashed in a *radix tree*, which hereafter we refer to as the ***State Trie*** or just ***Trie***. This rearrangement is necessary to be able to compute the Merkle hash of the whole or part of the state storage, consistently and efficiently at any given time.

The trie is used to compute the *Merkle root* ([Section -sec-num-ref-](chap-state#sect-merkl-proof)) of the state, ${H}_{{r}}$ ([Definition -def-num-ref-](chap-state#defn-block-header)), whose purpose is to authenticate the validity of the state database. Thus, the Polkadot Host follows a rigorous encoding algorithm to compute the values stored in the trie nodes to ensure that the computed Merkle hash, ${H}_{{r}}$, matches across the Polkadot Host implementations.

The trie is a *radix-16* tree ([Definition -def-num-ref-](chap-state#defn-radix-tree)). Each key value identifies a unique node in the tree. However, a node in a tree might or might not be associated with a key in the storage.

###### Definition -def-num- Radix-r Tree {#defn-radix-tree}
:::definition

A ***Radix-r tree*** is a variant of a trie in which:

- Every node has at most ${r}$ children where ${r}={2}^{{x}}$ for some ${x}$;

- Each node that is the only child of a parent, which does not represent a valid key is merged with its parent.

As a result, in a radix tree, any path whose interior vertices all have only one child and does not represent a valid key in the data set, is compressed into a single edge. This improves space efficiency when the key space is sparse.
:::

When traversing the trie to a specific node, its key can be reconstructed by concatenating the subsequences of the keys which are stored either explicitly in the nodes on the path or implicitly in their position as a child of their parent.

To identify the node corresponding to a key value, ${k}$, first, we need to encode ${k}$ in a way consistent with the trie structure. Because each node in the trie has at most 16 children, we represent the key as a sequence of 4-bit nibbles:

###### Definition -def-num- Key Encode {#defn-trie-key-encode}
:::definition

For the purpose of labeling the branches of the trie, the key ${k}$ is encoded to ${k}_{{\text{enc}}}$ using ${\mathsf{\text{KeyEncode}}}$ functions:

$$
{k}_{{\text{enc}}}\:={\left({k}_{{\text{enc}_{{1}}}},\ldots,{k}_{{\text{enc}_{{{2}{n}}}}}\right)}\:={\mathsf{\text{KeyEncode}}}{\left({k}\right)}
$$

such that:

$$
{\mathsf{\text{KeyEncode}}}:{\mathbb{{B}}}\rightarrow\text{Nibbles}^{{4}}
$$
$$
{k}	\longmapsto{\left({k}_{{\text{enc}_{{1}}}},\ldots,{k}_{{\text{enc}_{{{2}{n}}}}}\right)}
$$ 
$$
{\left({b}_{{1}},\ldots,{b}_{{n}}\right)}	\longmapsto{\left({{b}_{{1}}^{{{1}}}},{{b}_{{1}}^{{2}}},{{b}_{{2}}^{{1}}},{{b}_{{2}}^{{2}}},\ldots,{{b}_{{n}}^{{1}}},{{b}_{{n}}^{{2}}}\right)}
$$

where $\text{Nibble}^{{4}}$ is the set of all nibbles of 4-bit arrays and ${{b}_{{i}}^{{1}}}$ and ${{b}_{{i}}^{{2}}}$ are 4-bit nibbles, which are the big endian representations of ${b}_{{i}}$:

$$
{k}_{{\text{enc}_{{i}}}}\:={\left({{b}_{{i}}^{{1}}},{{b}_{{i}}^{{2}}}\right)}\:={\left({b}_{{i}}\div{16},{b}_{{i}}\text{mod}{16}\right)}
$$

where $\text{mod}$ is the remainder and $\div$ is the integer division operators.
:::
By looking at ${k}_{{\text{enc}}}$ as a sequence of nibbles, one can walk the radix tree to reach the node identifying the storage value of ${k}$.

### -sec-num- Trie Structure {#sect-state-storage-trie-structure}

In this subsection, we specify the structure of the nodes in the trie as well as the trie structure:

###### Definition -def-num- Set of Nodes {#defn-trie-nodeset}
:::definition

We refer to the **set of the nodes of Polkadot state trie** by ${\mathcal{{N}}}$. By ${N}\in{\mathcal{{N}}}$ to refer to an individual node in the trie.

:::
###### Definition -def-num- State Trie {#defn-nodetype}
:::definition

The state trie is a radix-16 tree ([Definition -def-num-ref-](chap-state#defn-radix-tree)). Each node in the trie is identified with a unique key ${k}_{{N}}$ such that:

- ${k}_{{N}}$ is the shared prefix of the key of all the descendants of ${N}$ in the trie.

and at least one of the following statements holds:

- ${\left({k}_{{N}},{v}\right)}$ corresponds to an existing entry in the State Storage.

- ${N}$ has more than one child.

Conversely, if ${\left({k},{v}\right)}$ is an entry in the state trie then there is a node ${N}\in{\mathcal{{N}}}$ such that ${k}_{{N}}={k}$.

:::
###### Definition -def-num- Branch {#defn-trie-branch}
:::definition

A **branch** node ${N}_{{b}}\in{\mathcal{{N}}}_{{b}}$ is a node which has one child or more. A branch node can have at most 16 children. A **leaf** node ${N}_{{l}}\in{\mathcal{{N}}}_{{l}}$ is a childless node. Accordingly:

$$
{\mathcal{{N}}}_{{b}}\:={\left\lbrace{N}_{{b}}\in{\mathcal{{N}}}{\mid}{N}_{{b}}\ \text{ is a branch node}\right\rbrace}
$$ 
$$
{\mathcal{{N}}}_{{l}}\:={\left\lbrace{N}_{{l}}\in{\mathcal{{N}}}{\mid}{N}_{{l}}\ \text{ is a leaf node}\right\rbrace}
$$
:::
For each node, part of ${k}_{{N}}$ is built while the trie is traversed from the root to ${N}$ and another part of ${k}_{{N}}$ is stored in ${N}$ ([Definition -def-num-ref-](chap-state#defn-node-key)).

###### Definition -def-num- Aggregated Prefix Key {#defn-node-key}
:::definition

For any ${N}\in{\mathcal{{N}}}$, its key ${k}_{{N}}$ is divided into an **aggregated prefix key, ${\text{pk}_{{N}}^{{\text{Agr}}}}$**, aggregated by [Aggregate-Key](chap-state#algo-aggregate-key) and a **partial key**, **$\text{pk}_{{N}}$** of length ${0}\le{l}_{{\text{pk}_{{N}}}}$ in nibbles such that:

$$
\text{pk}_{{N}}\:={\left({k}_{{\text{enc}_{{i}}}},\ldots,{k}_{{\text{enc}_{{{i}+{l}_{{\text{pk}_{{N}}}}}}}}\right)}
$$

where ${\text{pk}_{{N}}^{{\text{Agr}}}}$ is a prefix subsequence of ${k}_{{N}}$; ${i}$ is the length of ${\text{pk}_{{N}}^{{\text{Agr}}}}$ in nibbles and so we have:

$$
{\mathsf{\text{KeyEncode}}}{\left({k}_{{N}}\right)}={\text{pk}_{{N}}^{{\text{Agr}}}}{\mid}{\mid}\text{pk}_{{N}}={\left({k}_{{\text{enc}_{{1}}}},\ldots,{k}_{{\text{enc}_{{{i}-{1}}}}},{k}_{{\text{enc}_{{i}}}},{k}_{{\text{enc}_{{{i}+{l}_{{\text{pk}_{{N}}}}}}}}\right)}
$$
:::
Part of ${\text{pk}_{{N}}^{{\text{Agr}}}}$ is explicitly stored in ${N}$’s ancestors. Additionally, for each ancestor, a single nibble is implicitly derived while traversing from the ancestor to its child included in the traversal path using the $\text{Index}_{{N}}$ function ([Definition -def-num-ref-](chap-state#defn-index-function)).

###### Definition -def-num- Index {#defn-index-function}
:::definition

For ${N}\in{\mathcal{{N}}}_{{b}}$ and ${N}_{{c}}$ child of ${N}$, we define ${\mathsf{\text{Index}}}_{{N}}$ function as:

$$
\textsf{Index}_N: \{N_C \in cc(N) \mid N_c \text{ is a child of } N\} \rightarrow \text{Nibbles}_1^4 \\
N_c \rightarrow i
$$

such that

$$
{k}_{{{N}_{{c}}}}={k}_{{N}}{\mid}{\left|{i}{\mid}\right|}\text{pk}_{{{N}_{{c}}}}
$$
:::

###### Algorithm -algo-num- Aggregate-Key {#algo-aggregate-key}
:::algorithm
<Pseudocode
    content={aggregateKey}
    algID="aggregateKey"
    options={{ "lineNumber": true }}
/>

Assuming that ${P}_{{N}}$ is the path ([Definition -def-num-ref-](chap-state#defn-path-graph)) from the trie root to node ${N}$, [Aggregate-Key](chap-state#algo-aggregate-key) rigorously demonstrates how to build ${\text{pk}_{{N}}^{{\text{Agr}}}}$ while traversing ${P}_{{N}}$.
:::

###### Definition -def-num- Node Value {#defn-node-value}
:::definition

A node ${N}\in{\mathcal{{N}}}$ stores the **node value**, ${v}_{{N}}$, which consists of the following concatenated data:

$$
\text{Node Header}{\left|{\left|\text{Partial Key}\right|}\right|}\text{Node Subvalue}
$$

Formally noted as:

$$
{v}_{{N}}\:=\text{Head}_{{N}}{\left|{\left|\text{Enc}_{\text{HE}}{\left({p}{k}_{{N}}\right)}\right|}\right|}{s}{v}_{{N}}
$$

**where**  
- $\text{Head}_{{N}}$ is the node header from [Definition -def-num-ref-](chap-state#defn-node-header)

- ${p}{k}_{{N}}$ is the partial key from [Definition -def-num-ref-](chap-state#defn-node-key)

- $\text{Enc}_{\text{HE}}$ is hex encoding ([Definition -def-num-ref-](id-cryptography-encoding#defn-hex-encoding))

- ${s}{v}_{{N}}$ is the node subvalue from [Definition -def-num-ref-](chap-state#defn-node-subvalue)

:::
###### Definition -def-num- Node Header {#defn-node-header}
:::definition

The **node header**, consisting of $\ge{1}$ bytes, ${N}_{{1}}\ldots{N}_{{n}}$, specifies the node variant and the partial key length ([Definition -def-num-ref-](chap-state#defn-node-key)). Both pieces of information can be represented in bits within a single byte, ${N}_{{1}}$, where the amount of bits of the variant, ${v}$, and the bits of the partial key length, ${p}_{{l}}$ varies.

$$
{v}={\left\lbrace\begin{matrix}{01}&\text{Leaf}&{p}_{{l}}={2}^{{6}}\\{10}&\text{Branch Node with }\ {k}_{{N}}\notin{\mathcal{{K}}}&{p}_{{l}}={2}^{{6}}\\{11}&\text{Branch Node with }\ {k}_{{N}}\in{\mathcal{{K}}}&{p}_{{l}}={2}^{{6}}\\{001}&\text{Leaf containing a hashed subvalue}&{p}_{{l}}={2}^{{5}}\\{0001}&\text{Branch containing a hashed subvalue}&{p}_{{l}}={2}^{{4}}\\{0000}{0000}&\text{Empty}&{p}_{{l}}={0}\\{0000}{0001}&\text{Reserved for compact encoding}&\end{matrix}\right.}
$$

If the value of ${p}_{{l}}$ is equal to the maximum possible value the bits can hold, such as 63 (${2}^{{6}}-{1}$) in case of the ${01}$ variant, then the value of the next 8 bits (${N}_{{2}}$) are added the length. This process is repeated for every ${N}_{{n}}$ where ${N}_{{n}}={2}^{{8}}-{1}$. Any value smaller than the maximum possible value of ${N}_{{n}}$ implies that the next value of ${N}_{{{n}+{1}}}$ should not be added to the length. The hashed subvalue for variants ${001}$ and ${0001}$ is described in [Definition -def-num-ref-](chap-state#defn-hashed-subvalue).

Formally, the length of the partial key, ${\text{pk}_{{N}}^{{l}}}$, is defined as:

$$
{\text{pk}_{{N}}^{{l}}}={p}_{{l}}+{N}_{{n}}+{N}_{{{n}+{x}}}+\ldots+{N}_{{{n}+{x}+{y}}}
$$

as long as ${p}_{{l}}={m}$, ${N}_{{{n}+{x}}}={2}^{{8}}-{1}$ and ${N}_{{{n}+{x}+{y}}}<{2}^{{8}}-{1}$, where ${m}$ is the maximum possible value that ${p}_{{l}}$ can hold.

:::
### -sec-num- Merkle Proof {#sect-merkl-proof}

To prove the consistency of the state storage across the network and its modifications both efficiently and effectively, the trie implements a Merkle tree structure. The hash value corresponding to each node needs to be computed rigorously to make the inter-implementation data integrity possible.

The Merkle value of each node should depend on the Merkle value of all its children as well as on its corresponding data in the state storage. This recursive dependency is encompassed into the subvalue part of the node value, which recursively depends on the Merkle value of its children. Additionally, as [Section -sec-num-ref-](chap-state#sect-child-trie-structure) clarifies, the Merkle proof of each **child trie** must be updated first before the final Polkadot state root can be calculated.

We use the auxiliary function introduced in [Definition -def-num-ref-](chap-state#defn-children-bitmap) to encode and decode the information stored in a branch node.

###### Definition -def-num- Children Bitmap {#defn-children-bitmap}
:::definition

Suppose ${N}_{{b}},{N}_{{c}}\in{\mathcal{{N}}}$ and ${N}_{{c}}$ is a child of ${N}_{{b}}$. We define bit ${b}_{{i}}:={1}$ if and only if ${N}_{{b}}$ has a child with index ${i}$, therefore we define **ChildrenBitmap** functions as follows:

$$
\text{ChildrenBitmap:}
$$
$$
{\mathcal{{N}}}_{{b}}\rightarrow{\mathbb{{B}}}_{{2}}
$$
$$
{N}_{{b}}\rightarrow{\left({b}_{{{15}}},\ldots,{b}_{{8}},{b}_{{7}},\ldots,{b}_{{0}}\right)}_{{2}}
$$

**where**

$$
{b}_{{i}}\:={\left\lbrace\begin{matrix}{1}&\exists{N}_{{c}}\in{\mathcal{{N}}}:{k}_{{{N}_{{c}}}}={k}_{{{N}_{{b}}}}{\left|{\left|{i}\right|}\right|}{p}{k}_{{{N}_{{c}}}}\\{0}&\text{otherwise}\end{matrix}\right.}
$$

:::
###### Definition -def-num- Subvalue {#defn-node-subvalue}
:::definition

For a given node ${N}$, the **subvalue** of ${N}$, formally referred to as ${s}{v}_{{N}}$, is determined as follows:

$$
{s}{v}_{{N}}\:={\left\lbrace\begin{matrix}\text{StoredValue}_{{\text{SC}}}\\\text{Enc}_{{\text{SC}}}{\left(\text{ChildrenBitmap}{\left({N}\right)}{\left|{\left|\text{StoredValue}_{{\text{SC}}}\right|}\right|}\text{Enc}_{{\text{SC}}}{\left({H}{\left({N}_{{{C}_{{1}}}}\right)}\right)},\ldots,\text{Enc}_{{\text{SC}}}{\left({H}{\left({N}_{{{C}_{{n}}}}\right)}\right)}\right)}\end{matrix}\right.}
$$

where the first variant is a leaf node and the second variant is a branch node.

$$
\text{StoredValue}_{{\text{SC}}}\:={\left\lbrace\begin{matrix}\text{Enc}_{{\text{SC}}}{\left(\text{StoredValue}{\left({k}_{{N}}\right)}\right)}&\text{if StoredValue}{\left({k}_{{N}}\right)}={v}\\\phi&\text{if StoredValue}{\left({k}_{{N}}\right)}=\phi\end{matrix}\right.}
$$

${N}_{{{C}_{{1}}}}\ldots{N}_{{{C}_{{n}}}}$ with ${n}\le{16}$ are the children nodes of the branch node ${N}$.

- $\text{Enc}_{{\text{SC}}}$ is defined in [Section -sec-num-ref-](id-cryptography-encoding#sect-scale-codec).

- $\text{StoredValue}$, where ${v}$ can be empty, is defined in [Definition -def-num-ref-](chap-state#defn-stored-value).

- ${H}$ is defined in [Definition -def-num-ref-](chap-state#defn-merkle-value).

- $\text{ChildrenBitmap}{\left({N}\right)}$ is defined in [Definition -def-num-ref-](chap-state#defn-children-bitmap).

The trie deviates from a traditional Merkle tree in that the node value ([Definition -def-num-ref-](chap-state#defn-node-value)), ${v}_{{N}}$, is presented instead of its hash if it occupies less space than its hash.

:::
###### Definition -def-num- Hashed Subvalue {#defn-hashed-subvalue}
:::definition

To increase performance, a Merkle proof can be generated by inserting the hash of a value into the trie rather than the value itself (which can be quite large). If Merkle proof computation with node hashing is explicitly executed via the Host API ([Section -sec-num-ref-](chap-host-api#sect-ext-storage-root-version-2)), then any value larger than 32 bytes is hashed, resulting in that hash being used as the subvalue ([Definition -def-num-ref-](chap-state#defn-node-subvalue)) under the corresponding key. The node header must specify the variant ${001}$ and ${0001}$ respectively for leaves containing a hash as their subvalue and for branches containing a hash as their subvalue ([Definition -def-num-ref-](chap-state#defn-node-header)).

:::
###### Definition -def-num- Merkle Value {#defn-merkle-value}
:::definition

For a given node ${N}$, the **Merkle value** of ${N}$, denoted by ${H}{\left({N}\right)}$ is defined as follows:

$$
{H}:{\mathbb{{B}}}\rightarrow{{U}_{{{i}\rightarrow{0}}}^{{{32}}}}{\mathbb{{B}}}_{{i}}
$$
$$
{H}{\left({N}\right)}:{\left\lbrace\begin{matrix}{v}_{{N}}&{\left|{\left|{v}_{{N}}\right|}\right|}<{32}\ \text{ and }\ {N}\ne{R}\\\text{Blake2b}{\left({v}_{{N}}\right)}&{\left|{\left|{v}_{{N}}\right|}\right|}\ge{32}\ \text{ or }\ {N}={R}\end{matrix}\right.}
$$

Where ${v}_{{N}}$ is the node value of ${N}$ ([Definition -def-num-ref-](chap-state#defn-node-value)) and ${R}$ is the root of the trie. The **Merkle hash** of the trie is defined to be ${H}{\left({R}\right)}$.

:::
### -sec-num- Managing Multiple Variants of State {#sect-managing-multiple-states}

Unless a node is committed to only updating its state according to the finalized block ([Definition -def-num-ref-](sect-finality#defn-finalized-block)), it is inevitable for the node to store multiple variants of the state (one for each block). This is, for example, necessary for nodes participating in the block production and finalization.

While the state trie structure ([Section -sec-num-ref-](chap-state#sect-state-storage-trie-structure)) facilitates and optimizes storing and switching between multiple variants of the state storage, the Polkadot Host does not specify how a node is required to accomplish this task. Instead, the Polkadot Host is required to implement $\text{Set-State-At}$ ([Definition -def-num-ref-](chap-state#defn-set-state-at)):

###### Definition -def-num- Set State At Block {#defn-set-state-at}
:::definition

The function:

$$
\text{Set-State-At}{\left({B}\right)}
$$

in which ${B}$ is a block in the block tree ([Definition -def-num-ref-](chap-state#defn-block-tree)), sets the content of state storage equal to the resulting state of executing all extrinsics contained in the branch of the block tree from genesis till block B including those recorded in Block ${B}$.

For the definition of the state storage see [Section -sec-num-ref-](chap-state#sect-state-storage).

:::
## -sec-num- Child Storage {#sect-child-storages}

As clarified in [Section -sec-num-ref-](chap-state#sect-state-storage), the Polkadot state storage implements a hash table for inserting and reading key-value entries. The child storage works the same way but is stored in a separate and isolated environment. Entries in the child storage are not directly accessible via querying the main state storage.

The Polkadot Host supports as many child storages as required by Runtime and identifies each separate child storage by its unique identifying key. Child storages are usually used in situations where Runtime deals with multiple instances of a certain type of objects such as Parachains or Smart Contracts. In such cases, the execution of the Runtime entrypoint might result in generating repeated keys across multiple instances of certain objects. Even with repeated keys, all such instances of key-value pairs must be able to be stored within the Polkadot state.

In these situations, the child storage can be used to provide the isolation necessary to prevent any undesired interference between the state of separated instances. The Polkadot Host makes no assumptions about how child storages are used, but provides the functionality for it via the Host API ([Section -sec-num-ref-](chap-host-api#sect-child-storage-api)).

### -sec-num- Child Tries {#sect-child-trie-structure}

The child trie specification is the same as the one described in [Section -sec-num-ref-](chap-state#sect-state-storage-trie-structure). Child tries have their own isolated environment. Nonetheless, the main Polkadot state trie depends on them by storing a node (${K}_{{N}},{V}_{{N}}$) which corresponds to an individual child trie. Here, ${K}_{{N}}$ is the child storage key associated to the child trie, and ${V}_{{N}}$ is the Merkle value of its corresponding child trie computed according to the procedure described in [Section -sec-num-ref-](chap-state#sect-merkl-proof).

The Polkadot Host API ([Section -sec-num-ref-](chap-host-api#sect-child-storage-api)) allows the Runtime to provide the key ${K}_{{N}}$ in order to identify the child trie, followed by a second key in order to identify the value within that child trie. Every time a child trie is modified, the Merkle proof ${V}_{{N}}$ of the child trie stored in the Polkadot state must be updated first. After that, the final Merkle proof of the Polkadot state can be computed. This mechanism provides a proof of the full Polkadot state including all its child states.

## -sec-num- Runtime Interactions {#sect-runtime-interaction}

Like any transaction-based transition system, Polkadot’s state is changed by executing an ordered set of instructions. These instructions are known as *extrinsics*. In Polkadot, the execution logic of the state transition function is encapsulated in a Runtime ([Definition -def-num-ref-](chap-state#defn-state-machine)). For easy upgradability, this Runtime is presented as a Wasm blob. Nonetheless, the Polkadot Host needs to be in constant interaction with the Runtime ([Section -sec-num-ref-](chap-state#sect-entrypoints-into-runtime)).

In [Section -sec-num-ref-](chap-state#sect-extrinsics), we specify the procedure of the process where the extrinsics are submitted, pre-processed, and validated by Runtime and queued to be applied to the current state.

To make state replication feasible, Polkadot journals and batches a series of its extrinsics together into a structure known as a *block*, before propagating them to other nodes, similar to most other prominent distributed ledger systems. The specification of the Polkadot block as well as the process of verifying its validity, are both explained in [Section -sec-num-ref-](chap-state#sect-state-replication).

### -sec-num- Interacting with the Runtime {#sect-entrypoints-into-runtime}

The Runtime ([Definition -def-num-ref-](chap-state#defn-state-machine)) is the code implementing the logic of the chain. This code is decoupled from the Polkadot Host to make the logic of the chain easily upgradable without the need to upgrade the Polkadot Host itself. The general procedure to interact with the Runtime is described by [Interact-With-Runtime](chap-state#algo-runtime-interaction).

###### Algorithm -algo-num- Interact With Runtime {#algo-runtime-interaction}
:::algorithm
<Pseudocode
    content={interactWithRuntime}
    algID="interactWithRuntime"
    options={{ "lineNumber": true }}
/>

**where**  
- ${F}$ is the runtime entry point call.

- ${H}_{{b}}{\left({B}\right)}$ is the block hash indicating the state at the end of ${B}$.

- ${A}_{{1}},\ldots,{A}_{{n}}$ are arguments to be passed to the runtime entrypoint.
:::

In this section, we describe the details upon which the Polkadot Host is interacting with the Runtime. In particular, $\text{Set-State-At}$ and $\text{Call-Runtime-Entrypoint}$ procedures called by [Interact-With-Runtime](chap-state#algo-runtime-interaction) are explained in [Definition -def-num-ref-](chap-state#defn-call-into-runtime) and [Definition -def-num-ref-](chap-state#defn-set-state-at) respectively. ${R}_{{B}}$ is the Runtime code loaded from ${S}_{{B}}$, as described in [Definition -def-num-ref-](chap-state#defn-runtime-code-at-state), and ${R}{E}_{{B}}$ is the Polkadot Host API, as described in [Definition -def-num-ref-](chap-host-api#defn-host-api-at-state).

### -sec-num- Loading the Runtime Code {#sect-loading-runtime-code}

The Polkadot Host expects to receive the code for the Runtime of the chain as a compiled WebAssembly (Wasm) Blob. The current runtime is stored in the state database under the key represented as a byte array:

$$
{b}\:=\text{3A,63,6F,64,65}
$$

which is the ASCII byte representation of the string `:code` ([Section -sec-num-ref-](id-cryptography-encoding#section-genesis)). As a result of storing the Runtime as part of the state, the Runtime code itself becomes state sensitive and calls to Runtime can change the Runtime code itself. Therefore the Polkadot Host needs to always make sure to provide the Runtime corresponding to the state in which the entry point has been called. Accordingly, we define ${R}_{{B}}$ ([Definition -def-num-ref-](chap-state#defn-runtime-code-at-state)).

The initial Runtime code of the chain is provided as part of the genesis state ([Section -sec-num-ref-](id-cryptography-encoding#section-genesis)) and subsequent calls to the Runtime have the ability to, in turn, upgrade the Runtime by replacing this Wasm blob with the help of the storage API ([Section -sec-num-ref-](chap-host-api#sect-storage-api)). Therefore, the executor **must always** load the latest Runtime from storage - or preferably detect Runtime upgrades ([Definition -def-num-ref-](chap-state#defn-digest)) - either based on the parent block when importing blocks or the best/highest block when creating new blocks.

###### Definition -def-num- Runtime Code at State {#defn-runtime-code-at-state}
:::definition

By ${R}_{{B}}$, we refer to the Runtime code stored in the state storage at the end of the execution of block ${B}$.
:::

The WASM blobs may be compressed using [*zstd*](https://github.com/facebook/zstd). In such cases, there is an 8-byte magic identifier at the head of the blob, indicating that it should be decompressed with *zstd* compression. The magic identifier prefix `ZSTD_PREFIX = [82, 188, 83, 118, 70, 219, 142, 5]` is different from the WASM [magic bytes](https://github.com/WebAssembly/design/blob/main/BinaryEncoding.md#high-level-structure). The decompression has to be applied on the blob excluding the `ZSTD-PREFIX` and has a Bomb Limit of `CODE_BLOB_BOMB_LIMIT = 50 * 1024 * 1024` to mitigate compression bomb attacks. 


### -sec-num- Code Executor {#sect-code-executor}

The Polkadot Host executes the calls of Runtime entrypoints inside a Wasm Virtual Machine (VM), which in turn provides the Runtime with access to the Polkadot Host API. This part of the Polkadot Host is referred to as the *Executor*.

[Definition -def-num-ref-](chap-state#defn-call-into-runtime) introduces the notation for calling the runtime entrypoint which is used whenever an algorithm of the Polkadot Host needs to access the runtime.

It is acceptable behavior that the Runtime panics during execution of a function in order to indicate an error. The Polkadot Host must be able to catch that panic and recover from it.

In this section, we specify the general setup for an Executor that calls into the Runtime. In [Appendix -chap-num-ref-](chap-runtime-api) we specify the parameters and return values for each Runtime entrypoint separately.

###### Definition -def-num- Call Runtime Entrypoint {#defn-call-into-runtime}
:::definition

By

$$
\text{Call-Runtime-Entrypoint}{\left({R},{R}{E},\text{Runtime-Entrypoint},{A},{A}_{\le}{n}\right)}
$$

we refer to the task using the executor to invoke the while passing an ${A}_{{1}},\ldots,{A}_{{n}}$ argument to it and using the encoding described in [Section -sec-num-ref-](chap-state#sect-runtime-send-args-to-runtime-enteries).

:::
#### -sec-num- Memory Management {#sect-memory-management}

The Polkadot Host is responsible for managing the WASM heap memory starting at the exported symbol as a part of implementing the allocator Host API ([Section -sec-num-ref-](chap-host-api#sect-allocator-api)) and the same allocator should be used for any other heap allocation to be used by the Polkadot Runtime.

The size of the provided WASM memory should be based on the value of the storage key (an unsigned 64-bit integer), where each page has a size of 64KB. This memory should be made available to the Polkadot Runtime for import under the symbol name `memory`.

#### -sec-num- Sending Data to a Runtime Entrypoint {#sect-runtime-send-args-to-runtime-enteries}

In general, all data exchanged between the Polkadot Host and the Runtime is encoded using the SCALE codec described in [Section -sec-num-ref-](id-cryptography-encoding#sect-scale-codec). Therefore all runtime entrypoints have the following identical Wasm function signatures:

```
(func $runtime_entrypoint (param $data i32) (param $len i32) (result i64))
```

In each invocation of a Runtime entrypoints, the argument(s) which are supposed to be sent to the entrypoint, need to be SCALE encoded into a byte array ${B}$ ([Section -sec-num-ref-](id-cryptography-encoding#sect-scale-codec)) and copied into a section of Wasm shared memory managed by the shared allocator described in [Section -sec-num-ref-](chap-state#sect-memory-management).

When the Wasm method, corresponding to the entrypoint, is invoked, two integers are passed as arguments. The first argument is set to the memory address of the byte array ${B}$ in Wasm memory. The second argument sets the length of the encoded data stored in ${B}$.

#### -sec-num- Receiving Data from a Runtime Entrypoint {#sect-runtime-return-value}

The value which is returned from the invocation is an integer, representing two consecutive integers in which the least significant one indicates the pointer to the offset of the result returned by the entrypoint encoded in SCALE codec in the memory buffer. The most significant one provides the size of the blob.

#### -sec-num- Runtime Version Custom Section {#sect-runtime-version-custom-section}

For newer Runtimes, the Runtime version ([Section -sec-num-ref-](chap-runtime-api#defn-rt-core-version)) can be read directly from the [Wasm custom section](https://webassembly.github.io/spec/core/appendix/custom) with the name `runtime_version.` The content is a SCALE encoded structure as described in [Section -sec-num-ref-](chap-runtime-api#defn-rt-core-version).

Retrieving the Runtime version this way is preferred over calling the `Core_version` entrypoint since it involves significantly less overhead.
