---
title: States and Transitions
---

## [](#id-introduction)[2.1. Introduction](#id-introduction)

Definition 1. [Discrete State Machine (DSM)](chap-state.html#defn-state-machine)

A **Discrete State Machine (DSM)** is a state transition system that admits a starting state and whose set of states and set of transitions are countable. Formally, it is a tuple of

$$
(\Sigma, S, s_0, \delta)
$$

where

- $\Sigma$ is the countable set of all possible inputs.

- $S$ is a countable set of all possible states.

- $s_0 \in S$ is the initial state.

- $\delta$ is the state-transition function, known as **Runtime** in the Polkadot vocabulary, such that

$$
\delta : S \times \Sigma \rightarrow S
$$

Definition 2. [Path Graph](chap-state.html#defn-path-graph)

A **path graph** or a **path** of $n$ nodes formally referred to as **$P_n$**, is a tree with two nodes of vertex degree 1 and the other n-2 nodes of vertex degree 2. Therefore, $P_n$ can be represented by sequences of $(v_1, \ldots, v_n)$ where $e_i = (v_i, v_{i + 1})$ for $1 <= i <= n - 1$ is the edge which connect $v_i$ and $v_{i + 1}$.

Definition 3. [Blockchain](chap-state.html#defn-blockchain)

A **blockchain** $C$ is a [directed path graph](https://en.wikipedia.org/wiki/Directed_graph). Each node of the graph is called **Block** and indicated by **$B$**. The unique sink of $C$ is called **Genesis Block**, and the source is called the $\text{Head}$ of $C$. For any vertex $(B_1, B_2)$ where $B_1 -\> B_2$ we say $B_2$ is the **parent** of $B_1$, which is the **child** of $B_2$, respectively. We indicate that by:

$$
B_2 := P(B_1)
$$

The parent refers to the child by its hash value ([Definition 10](chap-state.html#defn-block-header)), making the path graph tamper proof since any modifications to the child would result in its hash value being changed.

|     |                                                                                                                                        |
|-----|----------------------------------------------------------------------------------------------------------------------------------------|
|     | The term "blockchain" can also be used as a way to refer to the network or system that interacts or maintains the directed path graph. |

### [](#id-block-tree)[2.1.1. Block Tree](#id-block-tree)

In the course of formation of a (distributed) blockchain, it is possible that the chain forks into multiple subchains in various block positions. We refer to this structure as a *block tree*:

Definition 4. [Block](chap-state.html#defn-block-tree)

The **block tree** of a blockchain, denoted by $BT$ is the union of all different versions of the blockchain observed by the Polkadot Host such that every block is a node in the graph and $B_1$ is connected to $B_2$ if $B_1$ is a parent of $B_2$.

When a block in the block tree gets finalized, there is an opportunity to prune the block tree to free up resources into branches of blocks that do not contain all of the finalized blocks or those that can never be finalized in the blockchain ([Chapter 6](sect-finality.html)).

Definition 5. [Pruned Block Tree](chap-state.html#defn-pruned-tree)

By **Pruned Block Tree**, denoted by $\text{PBT}$, we refer to a subtree of the block tree obtained by eliminating all branches which do not contain the most recent finalized blocks ([Definition 90](sect-finality.html#defn-finalized-block)). By **pruning**, we refer to the procedure of $BT \larr \text{PBT}$. When there is no risk of ambiguity and is safe to prune BT, we use $\text{BT}$ to refer to $\text{PBT}$.

[Definition 6](chap-state.html#defn-chain-subchain) gives the means to highlight various branches of the block tree.

Definition 6. [Subchain](chap-state.html#defn-chain-subchain)

Let $G$ be the root of the block tree and $B$ be one of its nodes. By $\text{Chain}(B)$, we refer to the path graph from $G$ to $B$ in $\text{BT}$. Conversely, for a chain $C = |\text{Chain}(B)$, we define **the head of $C$** to be $B$, formally noted as $B := \bar C$. We define $\|C\|$, the length of $C$ as a path graph.

If $B'$ is another node on $\text{Chain}(B)$, then by $\text{SubChain}(B', B)$ we refer to the subgraph of $\text{Chain}(B)$ path graph which contains $B$ and ends at $B'$ and by $\|\text{SubChain}(B', B)\|$ we refer to its length.

Accordingly, $\mathbb C_{B'}(BT)$ is the set of all subchains of $BT$ rooted at $B'$. The set of all chains of $BT$, $\mathbb C_G(BT)$ is denoted by $\mathbb C(BT)$ or simply $\mathbb C$, for the sake of brevity.

Definition 7. [Longest Chain](chap-state.html#defn-longest-chain)

We define the following complete order over $\mathbb C$ as follows. For chains $C_1, C_2 \in \mathbb C$ we have that $C_1 \> C_2$ if either $\|C_1\| \> \|C_2\|$ or $\|C_1\| = \|C_2\|$.

If $\|C_1\| =\| C_2\|$ we say $C_1 \> C_2$ if and only if the block arrival time ([Definition 67](sect-block-production.html#defn-block-time)) of $\bar C_1$ is less than the block arrival time of $\bar C_2$, from the *subjective perspective* of the Host. We define the $\text{Longest-Chain}(BT)$ to be the maximum chain given by this order.

Definition 8. [Longest Path](chap-state.html#defn-longest-path)

$\text{Longest-Path}(BT)$ returns the path graph of $BT$ which is the longest among all paths in $BT$ and has the earliest block arrival time ([Definition 67](sect-block-production.html#defn-block-time)). $\text{Deepest-Leaf}(BT)$ returns the head of $\text{Longest-Path}(BT)$ chain.

Because every block in the blockchain contains a reference to its parent, it is easy to see that the block tree is de facto a tree. A block tree naturally imposes partial order relationships on the blocks as follows:

Definition 9. [Descendant and Ancestor](chap-state.html#defn-descendant-ancestor)

We say $B$ is **descendant** of $B'$, formally noted as $B \> B'$, if $(\|B\| \> \|B'\|) in C$. Respectively, we say that $B'$ is an **ancestor** of $B$, formally noted as $B < B'$, if $(\|B\| < \|B'\|) in C$.

## [](#sect-state-replication)[2.2. State Replication](#sect-state-replication)

Polkadot nodes replicate each other’s state by syncing the history of the extrinsics. This, however, is only practical if a large set of transactions are batched and synced at the time. The structure in which the transactions are journaled and propagated is known as a block of extrinsics ([Section 2.2.1](chap-state.html#sect-block-format)). Like any other replicated state machines, state inconsistency can occure between Polkadot replicas. [Section 2.4.5](chap-state.html#sect-managing-multiple-states) gives an overview of how a Polkadot Host node manages multiple variants of the state.

### [](#sect-block-format)[2.2.1. Block Format](#sect-block-format)

A Polkadot block consists a *block header* ([Definition 10](chap-state.html#defn-block-header)) and a *block body* ([Definition 13](chap-state.html#defn-block-body)). The *block body* in turn is made up out of *extrinsics* , which represent the generalization of the concept of *transactions*. *Extrinsics* can contain any set of external data the underlying chain wishes to validate and track.

seq: - id: header type: block_header - id: body type: block_body

Definition 10. [Block Header](chap-state.html#defn-block-header)

The **header of block B**, $H_h(B)$, is a 5-tuple containing the following elements:

- **parent_hash:** formally indicated as $H_p$, is the 32-byte Blake2b hash ([Section A.1.1.1](id-cryptography-encoding.html#sect-blake2)) of the SCALE encoded parent block header ([Definition 12](chap-state.html#defn-block-header-hash)).

- **number:** formally indicated as $H_i$, is an integer, which represents the index of the current block in the chain. It is equal to the number of the ancestor blocks. The genesis state has number 0.

- **state_root:** formally indicated as $H_r$, is the root of the Merkle trie, whose leaves implement the storage for the system.

- **extrinsics_root:** is the field which is reserved for the Runtime to validate the integrity of the extrinsics composing the block body. For example, it can hold the root hash of the Merkle trie which stores an ordered list of the extrinsics being validated in this block. The extrinsics_root is set by the runtime and its value is opaque to the Polkadot Host. This element is formally referred to as $H_e$.

- **digest:** this field is used to store any chain-specific auxiliary data, which could help the light clients interact with the block without the need of accessing the full storage as well as consensus-related data including the block signature. This field is indicated as $H_d$ ([Definition 11](chap-state.html#defn-digest)).

seq: - id: parent_hash size: 32 - id: number type: scale::compact_int - id: state_root size: 32 - id: extrinsic_root size: 32 - id: num_digests type: scale::compact_int - id: digests type: digest repeat: expr repeat-expr: num_digests.value

Definition 11. [Header Digest](chap-state.html#defn-digest)

The header **digest** of block $B$ formally referred to by $H_d (B)$ is an array of **digest items** $H_d^i$’s, known as digest items of varying data type ([Definition 188](id-cryptography-encoding.html#defn-varrying-data-type)) such that:

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

where  
- $\text{id}$ is a 4-byte ASCII encoded consensus engine identifier

- $\text{m}$ is a scale encoded byte array containing the message payload

[TABLE]

seq: - id: type type: u1 enum: type_id - id: value type: switch-on: type cases: 'type_id::pre_runtime': pre_runtime 'type_id::post_runtime': post_runtime 'type_id::seal': seal 'type_id::runtime_updated': empty enums: type_id: 4: post_runtime 5: seal 6: pre_runtime 8: runtime_updated types: pre_runtime: seq: - id: engine type: str encoding: ASCII size: 4 - id: payload type: scale::bytes post_runtime: seq: - id: engine type: str encoding: ASCII size: 4 - id: payload type: scale::bytes seal: seq: - id: engine type: str encoding: ASCII size: 4 - id: payload type: scale::bytes empty: {}

Definition 12. [Header Hash](chap-state.html#defn-block-header-hash)

The **block header hash of block $B$**, $H_h(B)$, is the hash of the header of block $B$ encoded by simple codec:

$$
H_h(B) := "Blake2b"("Enc"\_(SC)("Head"(B)))
$$

Definition 13. [Block Body](chap-state.html#defn-block-body)

The block body consists of an sequence of extrinsics, each encoded as a byte array. The content of an extrinsic is completely opaque to the Polkadot Host. As such, from the point of the Polkadot Host, and is simply a SCALE encoded array of byte arrays. The **body of Block** $B$ represented as $"Body"(B)$ is defined to be:

$$
\text{Body}(B) := \text{Enc}_{SC}(E_1,...,E_n)
$$

Where each $E_i \in \mathbb B$ is a SCALE encoded extrinsic.

seq: - id: num_transactions type: scale::compact_int - id: transactions type: transaction repeat: expr repeat-expr: num_transactions.value types: transaction: seq: - id: len_data type: scale::compact_int - id: data size: len_data.value

## [](#sect-extrinsics)[2.3. Extrinsics](#sect-extrinsics)

The block body consists of an array of extrinsics. In a broad sense, extrinsics are data from outside of the state which can trigger state transitions. This section describes extrinsics and their inclusion into blocks.

### [](#id-preliminaries)[2.3.1. Preliminaries](#id-preliminaries)

The extrinsics are divided into two main categories defined as follows:

**Transaction extrinsics** are extrinsics which are signed using either of the key types ([Section A.1.4](id-cryptography-encoding.html#sect-cryptographic-keys)) and broadcasted between the nodes. **Inherent extrinsics** are unsigned extrinsics which are generated by Polkadot Host and only included in the blocks produced by the node itself. They are broadcasted as part of the produced blocks rather than being gossiped as individual extrinsics.

The Polkadot Host does not specify or limit the internals of each extrinsics and those are defined and dealt with by the Runtime ([Definition 1](chap-state.html#defn-state-machine)). From the Polkadot Host point of view, each extrinsics is simply a SCALE-encoded blob ([Section A.2.2](id-cryptography-encoding.html#sect-scale-codec)).

### [](#id-transactions)[2.3.2. Transactions](#id-transactions)

Transaction are submitted and exchanged through *Transactions* network messages ([Section 4.8.5](chap-networking.html#sect-msg-transactions)). Upon receiving a Transactions message, the Polkadot Host decodes the SCALE-encoded blob and splits it into individually SCALE-encoded transactions.

Alternative transaction can be submitted to the host by offchain worker through the Host API ([Section B.6.2](chap-host-api.html#sect-ext-offchain-submit-transaction)).

Any new transaction should be submitted to the Runtime ([Section C.7.1](chap-runtime-api.html#sect-rte-validate-transaction)). This will allow the Polkadot Host to check the validity of the received transaction against the current stat and if it should be gossiped to other peers. If it considers the submitted transaction as valid, the Polkadot Host should store it for inclusion in future blocks. The whole process of handling new transactions is described in more detail by [Validate-Transactions-and-Store](chap-state.html#algo-validate-transactions).

Additionally valid transactions that are supposed to be gossiped are propagated to connected peers of the Polkadot Host. While doing so the Polkadot Host should keep track of peers already aware of each transaction. This includes peers which have already gossiped the transaction to the node as well as those to whom the transaction has already been sent. This behavior is mandated to avoid resending duplicates and unnecessarily overloading the network. To that aim, the Polkadot Host should keep a *transaction pool* and a *transaction queue* defined as follows:

Definition 14. [Transaction Queue](chap-state.html#defn-transaction-queue)

The **Transaction Queue** of a block producer node, formally referred to as $TQ$ is a data structure which stores the transactions ready to be included in a block sorted according to their priorities ([Section 4.8.5](chap-networking.html#sect-msg-transactions)). The **Transaction Pool**, formally referred to as $TP$, is a hash table in which the Polkadot Host keeps the list of all valid transactions not in the transaction queue.

Furthermore [Validate-Transactions-and-Store](chap-state.html#algo-validate-transactions) updates the transaction pool and the transaction queue according to the received message:

\state \$L \leftarrow Dec\_{SC}(M_T)\$ \forall{\$$T \in L \mid T \notin TQ \mid T \notin TP$\$} \state \$B_d \leftarrow\$ \call{Head}{\call{Longest-Chain}{\$BT\$}} \state \$N \leftarrow H_n(B_d)\$ \state \$R \leftarrow\$ \call{Call-Runtime-Entry}{\$\texttt{TaggedTransactionQueue$validate$transaction}, N, T\$} \if{\call{Valid}{\$R\$}} \if{\call{Requires}{\$R\$}\$ \subset \bigcup\_{\forall T \in (TQ~\cup~B_i \mid \exists i \< d)}\$ \call{Provided-Tags}{\$T\$}} \state \call{Insert-At}{\$TQ, T, \$\call{Requires}{\$R\$}\$, \$\call{Priority}{\$R\$}} \else \state \call{Add-To}{\$TP,T\$} \endif \state \call{Maintain-Transaction-Pool}{} \if{\call{ShouldPropagate}{\$R\$}} \state \call{Propagate}{\$T\$} \endif \endif \endfor

where  
- $M_T$ is the transaction message (offchain transactions?)

- $\text{Dec}_{SC}$ decodes the SCALE encoded message.

- $"Longest-Chain"$ is defined in [Definition 7](chap-state.html#defn-longest-chain).

- $tt "TaggedTransactionQueue_validate_transaction"$ is a Runtime entrypoint specified in [Section C.7.1](chap-runtime-api.html#sect-rte-validate-transaction) and $Requires(R)$, $Priority(R)$ and $Propagate(R)$ refer to the corresponding fields in the tuple returned by the entrypoint when it deems that $T$ is valid.

- $"Provided-Tags"(T)$ is the list of tags that transaction $T$ provides. The Polkadot Host needs to keep track of tags that transaction $T$ provides as well as requires after validating it.

- $"Insert-At"(TQ,T,"Requires"(R),"Priority"(R))$ places $T$ into $TQ$ approperietly such that the transactions providing the tags which $T$ requires or have higher priority than $T$ are ahead of $T$.

- $"Maintain-Transaction-Pool"$ is described in [Maintain-Transaction-Pool](chap-state.html#algo-maintain-transaction-pool).

- $"ShouldPropagate"$ indictes whether the transaction should be propagated based on the `Propagate` field in the `ValidTransaction` type as defined in [Definition 225](chap-runtime-api.html#defn-valid-transaction), which is returned by $tt "TaggedTransactionQueue_validate_transaction"$.

- $"Propagate"(T)$ sends $T$ to all connected peers of the Polkadot Host who are not already aware of $T$.

\state Scan the pool for ready transactions \state Move them to the transaction queue \state Drop invalid transactions

|     |                                |
|-----|--------------------------------|
|     | This has not been defined yet. |

### [](#sect-inherents)[2.3.3. Inherents](#sect-inherents)

Inherents are unsigned extrinsics inserted into a block by the block author and as a result are not stored in the transaction pool or gossiped across the network. Instead they are generated by the Polkadot Host by passing the required inherent data, as listed in [Table 1](chap-state.html#tabl-inherent-data), to the Runtime method $tt "BlockBuilder_inherent_extrinsics"$ ([Section C.6.3](chap-runtime-api.html#defn-rt-builder-inherent-extrinsics)). Then the returned extrinsics should be included in the current block as explained in [Build-Block](sect-block-production.html#algo-build-block).

| Identifier | Value Type                                                                                | Description                                                                                |
|------------|-------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| timstap0   | Unsigned 64-bit integer                                                                   | Unix epoch time ([Definition 181](id-cryptography-encoding.html#defn-unix-time))           |
| babeslot   | Unsigned 64-bit integer                                                                   | The babe slot (*DEPRECATED*) ([Definition 54](sect-block-production.html#defn-epoch-slot)) |
| parachn0   | Parachain inherent data ([Definition 103](chapter-anv.html#defn-parachain-inherent-data)) | Parachain candidate inclusion ([Section 8.2.2](chapter-anv.html#sect-candidate-inclusion)) |

Table 1. Inherent Data

Definition 15. [Inherent Data](chap-state.html#defn-inherent-data)

`Inherent-Data` is a hashtable ([Definition 192](id-cryptography-encoding.html#defn-scale-list)), an array of key-value pairs consisting of the inherent 8-byte identifier and its value, representing the totality of inherent extrinsics included in each block. The entries of this hash table which are listed in [Table 1](chap-state.html#tabl-inherent-data) are collected or generated by the Polkadot Host and then handed to the Runtime for inclusion ([Build-Block](sect-block-production.html#algo-build-block)).

## [](#sect-state-storage)[2.4. State Storage Trie](#sect-state-storage)

For storing the state of the system, Polkadot Host implements a hash table storage where the keys are used to access each data entry. There is no assumption either on the size of the key nor on the size of the data stored under them, besides the fact that they are byte arrays with specific upper limits on their length. The limit is imposed by the encoding algorithms to store the key and the value in the storage trie ([Section A.2.2.1](id-cryptography-encoding.html#sect-sc-length-and-compact-encoding)).

### [](#id-accessing-system-storage)[2.4.1. Accessing System Storage](#id-accessing-system-storage)

The Polkadot Host implements various functions to facilitate access to the system storage for the Runtime ([Section 2.6.1](chap-state.html#sect-entrypoints-into-runtime)). Here we formalize the access to the storage when it is being directly accessed by the Polkadot Host (in contrast to Polkadot runtime).

Definition 16. [Stored Value](chap-state.html#defn-stored-value)

The $\sf \text{StoredValue}$ function retrieves the value stored under a specific key in the state storage and is formally defined as:

$$
\sf \text{StoredValue: } \mathcal K \rarr \mathcal V
$$

$$
k \rarr \begin{cases}
v \text{ if } (k,v) \text{ exists in state storage} \\
\phi \text{ otherwise}
\end{cases}
$$

where $\mathcal K \sub \mathbb B$ and $\mathcal V \sub \mathbb B$ are respectively the set of all keys and values stored in the state storage. $\mathcal V$ can be an empty value.

### [](#id-general-structure)[2.4.2. General Structure](#id-general-structure)

In order to ensure the integrity of the state of the system, the stored data needs to be re-arranged and hashed in a *radix tree*, which hereafter we refer to as the ***State Trie*** or just ***Trie***. This rearrangment is necessary to be able to compute the Merkle hash of the whole or part of the state storage, consistently and efficiently at any given time.

The trie is used to compute the *merkle root* ([Section 2.4.4](chap-state.html#sect-merkl-proof)) of the state, $H_r$ ([Definition 10](chap-state.html#defn-block-header)), whose purpose is to authenticate the validity of the state database. Thus, the Polkadot Host follows a rigorous encoding algorithm to compute the values stored in the trie nodes to ensure that the computed Merkle hash, $H_r$, matches across the Polkadot Host implementations.

The trie is a *radix-16* tree ([Definition 17](chap-state.html#defn-radix-tree)). Each key value identifies a unique node in the tree. However, a node in a tree might or might not be associated with a key in the storage.

Definition 17. [Radix-r Tree](chap-state.html#defn-radix-tree)

A ***Radix-r tree*** is a variant of a trie in which:

- Every node has at most $r$ children where $r = 2^x$ for some $x$;

- Each node that is the only child of a parent, which does not represent a valid key is merged with its parent.

As a result, in a radix tree, any path whose interior vertices all have only one child and does not represent a valid key in the data set, is compressed into a single edge. This improves space efficiency when the key space is sparse.

When traversing the trie to a specific node, its key can be reconstructed by concatenating the subsequences of the keys which are stored either explicitly in the nodes on the path or implicitly in their position as a child of their parent.

To identify the node corresponding to a key value, $k$, first we need to encode $k$ in a way consistent with the trie structure. Because each node in the trie has at most 16 children, we represent the key as a sequence of 4-bit nibbles:

Definition 18. [Key Encode](chap-state.html#defn-trie-key-encode)

For the purpose of labeling the branches of the trie, the key $k$ is encoded to $k\_("enc")$ using $sf "KeyEncode"$ functions:

$k\_("enc") := (k\_("enc"\_1), ..., k\_("enc"\_(2n))) := sf "KeyEncode"(k)$

such that:

$sf "KeyEncode": \mathbb B -\> "Nibbles"^4$ $k \|-\> (k\_("enc"\_1),...,k\_("enc"\_(2n)))$ $(b_1,...,b_n) \|-\> (b_1^(1),b_1^2,b_2^1,b_2^2,...,b_n^1,b_n^2 )$

where $"Nibble"^4$ is the set of all nibbles of 4-bit arrays and $b_i^1$ and $b_i^2$ are 4-bit nibbles, which are the big endian representations of $b_i$:

$k\_("enc"\_i) := (b_i^1,b_i^2) := (b_i -: 16,b_i mod 16)$

where $mod$ is the remainder and $-:$ is the integer division operators.

By looking at $k\_("enc")$ as a sequence of nibbles, one can walk the radix tree to reach the node identifying the storage value of $k$.

### [](#sect-state-storage-trie-structure)[2.4.3. Trie Structure](#sect-state-storage-trie-structure)

In this subsection, we specify the structure of the nodes in the trie as well as the trie structure:

Definition 19. [Set of Nodes](chap-state.html#defn-trie-nodeset)

We refer to the **set of the nodes of Polkadot state trie** by $\mathcal N$. By $N in \mathcal N$ to refer to an individual node in the trie.

Definition 20. [State Trie](chap-state.html#defn-nodetype)

The state trie is a radix-16 tree ([Definition 17](chap-state.html#defn-radix-tree)). Each node in the trie is identified with a unique key $k_N$ such that:

- $k_N$ is the shared prefix of the key of all the descendants of $N$ in the trie.

and, at least one of the following statements holds:

- $(k_N, v)$ corresponds to an existing entry in the State Storage.

- $N$ has more than one child.

Conversely, if $(k, v)$ is an entry in the state trie then there is a node $N in \mathcal N$ such that $k_N = k$.

Definition 21. [Branch](chap-state.html#defn-trie-branch)

A **branch** node $N_b in \mathcal N_b$ is a node which has one child or more. A branch node can have at most 16 children. A **leaf** node $N_l in \mathcal N_l$ is a childless node. Accordingly:

$\mathcal N_b := {N_b in \mathcal N \| N_b " is a branch node"}$ $\mathcal N_l := {N_l in \mathcal N \| N_l " is a leaf node"}$

For each node, part of $k_N$ is built while the trie is traversed from the root to $N$ and another part of $k_N$ is stored in $N$ ([Definition 22](chap-state.html#defn-node-key)).

Definition 22. [Aggregated Prefix Key](chap-state.html#defn-node-key)

For any $N in \mathcal N$, its key $k_N$ is divided into an **aggregated prefix key, $"pk"\_N^("Agr")$**, aggregated by [Aggregate-Key](chap-state.html#algo-aggregate-key) and a **partial key**, **$"pk"\_N$** of length $0 \<= l\_("pk"\_N)$ in nibbles such that:

$"pk"\_N := (k\_("enc"\_i),...,k\_("enc"\_(i+l\_("pk"\_N))))$

where $"pk"\_N^("Agr")$ is a prefix subsequence of $k_N$; $i$ is the length of $"pk"\_N^("Agr")$ in nibbles and so we have:

$sf "KeyEncode"(k_N) = "pk"\_N^("Agr") \|\| "pk"\_N = (k\_("enc"\_1), ..., k\_("enc"\_(i-1)),k\_("enc"\_i),k\_("enc"\_(i+l\_("pk"\_N))))$

Part of $"pk"\_N^("Agr")$ is explicitly stored in $N$’s ancestors. Additionally, for each ancestor, a single nibble is implicitly derived while traversing from the ancestor to its child included in the traversal path using the $"Index"\_N$ function ([Definition 23](chap-state.html#defn-index-function)).

Definition 23. [Index](chap-state.html#defn-index-function)

For $N in \mathcal N_b$ and $N_c$ child of $N$, we define $sf "Index"\_N$ function as:

$sf "Index"\_N: {N_C in \mathcal N \| N_c " is a child of " N} -\> "Nibbles"\_1^4$ $N_c -\> i$

such that

$k\_(N_c) = k_N \|\| i \|\| "pk"\_(N_c)$

\require{\$P_N \coloneqq (\$\textsc{TrieRoot}\$ = N_1, \dots, N_j = N)\$} \state \$pk^{Agr}\_N \leftarrow \phi\$ \state \$i \leftarrow 1\$ \forall{\$N_i \in P_N\$} \state \$pk^{Agr}\_N \leftarrow pk^{Agr}\_N \|\| pk\_{N_i} \|\| \textrm{Index}\_{N_i}(N\_{i + 1})\$ \endfor \state \$pk^{Agr}\_N \leftarrow pk^{Agr}\_N \|\| pk\_{N}\$ \return \$pk^{Agr}\_N\$

Assuming that $P_N$ is the path ([Definition 2](chap-state.html#defn-path-graph)) from the trie root to node $N$, [Aggregate-Key](chap-state.html#algo-aggregate-key) rigorously demonstrates how to build $"pk"\_N^("Agr")$ while traversing $P_N$.

Definition 24. [Node Value](chap-state.html#defn-node-value)

A node $N in \mathcal N$ stores the **node value**, $v_N$, which consists of the following concatenated data:

$"Node Header"\|\|"Partial Key"\|\|"Node Subvalue"$

Formally noted as:

$v_N := "Head"\_N\|\|"Enc"\_"HE"(pk_N)\|\|sv_N$

where  
- $"Head"\_N$ is the node header from [Definition 25](chap-state.html#defn-node-header)

- $pk_N$ is the partial key from [Definition 22](chap-state.html#defn-node-key)

- $"Enc"\_"HE"$ is hex encoding ([Definition 199](id-cryptography-encoding.html#defn-hex-encoding))

- $sv_N$ is the node subvalue from [Definition 27](chap-state.html#defn-node-subvalue)

Definition 25. [Node Header](chap-state.html#defn-node-header)

The **node header**, consisting of $\>= 1$ bytes, $N_1...N_n$, specifies the node variant and the partial key length ([Definition 22](chap-state.html#defn-node-key)). Both pieces of information can be represented in bits within a single byte, $N_1$, where the amount of bits of the variant, $v$, and the bits of the partial key length, $p_l$ varies.

$v = { (01, "Leaf", p_l = 2^6), (10, "Branch Node with " k_N !in \mathcal K, p_l = 2^6), (11, "Branch Node with " k_N in \mathcal K, p_l = 2^6), (001, "Leaf containing a hashed subvalue", p_l = 2^5), (0001, "Branch containing a hashed subvalue", p_l = 2^4), (0000 0000, "Empty", p_l = 0), (0000 0001, "Reserved for compact encoding",) :}$

If the value of $p_l$ is equal to the maximum possible value the bits can hold, such as 63 ($2^6-1$) in case of the $01$ variant, then the value of the next 8 bits ($N_2$) are added the the length. This process is repeated for every $N_n$ where $N_n = 2^8-1$. Any value smaller than the maximum possible value of $N_n$ implies that the next value of $N\_(n+1)$ should not be added to the length. The hashed subvalue for variants $001$ and $0001$ is described in [Definition 28](chap-state.html#defn-hashed-subvalue).

Formally, the length of the partial key, $"pk"\_N^l$, is defined as:

$"pk"\_N^l = p_l + N_n + N\_(n+x) + ... + N\_(n+x+y)$

as long as $p_l = m$, $N\_(n+x) = 2^8-1$ and $N\_(n+x+y) \< 2^8-1$, where $m$ is the maximum possible value that $p_l$ can hold.

### [](#sect-merkl-proof)[2.4.4. Merkle Proof](#sect-merkl-proof)

To prove the consistency of the state storage across the network and its modifications both efficiently and effectively, the trie implements a Merkle tree structure. The hash value corresponding to each node needs to be computed rigorously to make the inter-implementation data integrity possible.

The Merkle value of each node should depend on the Merkle value of all its children as well as on its corresponding data in the state storage. This recursive dependency is encompassed into the subvalue part of the node value which recursively depends on the Merkle value of its children. Additionally, as [Section 2.5.1](chap-state.html#sect-child-trie-structure) clarifies, the Merkle proof of each **child trie** must be updated first before the final Polkadot state root can be calculated.

We use the auxiliary function introduced in [Definition 26](chap-state.html#defn-children-bitmap) to encode and decode information stored in a branch node.

Definition 26. [Children Bitmap](chap-state.html#defn-children-bitmap)

Suppose $N_b, N_c in \mathcal N$ and $N_c$ is a child of $N_b$. We define bit $b_i : = 1$ if and only if $N_b$ has a child with index $i$, therefore we define **ChildrenBitmap** functions as follows:

$"ChildrenBitmap:"$ $\mathcal N_b -\> \mathbb B_2$ $N_b -\> (b\_(15), ...,b_8,b_7,...,b_0)\_2$

where

$b_i := {(1, EE N_c in \mathcal N: k\_(N_c) = k\_(N_b)\|\|i\|\|pk\_(N_c)),(0, "otherwise"):}$

Definition 27. [Subvalue](chap-state.html#defn-node-subvalue)

For a given node $N$, the **subvalue** of $N$, formally referred to as $sv_N$, is determined as follows:

$sv_N := {("StoredValue"\_("SC")),("Enc"\_("SC")("ChildrenBitmap"(N)\|\|"StoredValue"\_("SC")\|\|"Enc"\_("SC")(H(N\_(C_1))),...,"Enc"\_("SC")(H(N\_(C_n))))):}$

where the first variant is a leaf node and the second variant is a branch node.

$"StoredValue"\_("SC") := {("Enc"\_("SC")("StoredValue"(k_N)),"if StoredValue"(k_N) = v),(phi,"if StoredValue"(k_N) = phi):}$

$N\_(C_1) ... N\_(C_n)$ with $n \<= 16$ are the children nodes of the branch node $N$.

- $"Enc"\_("SC")$ is defined in [Section A.2.2](id-cryptography-encoding.html#sect-scale-codec).

- $"StoredValue"$, where $v$ can be empty, is defined in [Definition 16](chap-state.html#defn-stored-value).

- $H$ is defined in [Definition 29](chap-state.html#defn-merkle-value).

- $"ChildrenBitmap"(N)$ is defined in [Definition 26](chap-state.html#defn-children-bitmap).

The trie deviates from a traditional Merkle tree in that the node value ([Definition 24](chap-state.html#defn-node-value)), $v_N$, is presented instead of its hash if it occupies less space than its hash.

Definition 28. [Hashed Subvalue](chap-state.html#defn-hashed-subvalue)

To increase performance, a merkle proof can be generated by inserting the hash of a value into the trie rather than the value itself (which can be quite large). If merkle proof computation with node hashing is explicitly executed via the Host API ([Section B.2.8.2](chap-host-api.html#sect-ext-storage-root-version-2)), then any value larger than 32 bytes is hashed, resulting in that hash being used as the subvalue ([Definition 27](chap-state.html#defn-node-subvalue)) under the corresponding key. The node header must specify the variant $001$ and $0001$ respectively for leaves containing a hash as their subvalue and for branches containing a hash as their subvalue ([Definition 25](chap-state.html#defn-node-header)).

Definition 29. [Merkle Value](chap-state.html#defn-merkle-value)

For a given node $N$, the **Merkle value** of $N$, denoted by $H(N)$ is defined as follows:

$H: \mathbb B -\> U\_(i -\> 0)^(32) \mathbb B_32$ $H(N): {(v_N,\|\|v_N\|\| \< 32 " and " N != R),("Blake2b"(v_n),\|\|v_N\|\| \>= 32 " or " N = R):}$

Where $v_N$ is the node value of $N$ ([Definition 24](chap-state.html#defn-node-value)) and $R$ is the root of the trie. The **Merkle hash** of the trie is defined to be $H(R)$.

### [](#sect-managing-multiple-states)[2.4.5. Managing Multiple Variants of State](#sect-managing-multiple-states)

Unless a node is committed to only update its state according to the finalized block ([Definition 90](sect-finality.html#defn-finalized-block)), it is inevitable for the node to store multiple variants of the state (one for each block). This is, for example, necessary for nodes participating in the block production and finalization.

While the state trie structure ([Section 2.4.3](chap-state.html#sect-state-storage-trie-structure)) facilitates and optimizes storing and switching between multiple variants of the state storage, the Polkadot Host does not specify how a node is required to accomplish this task. Instead, the Polkadot Host is required to implement $"Set-State-At"$ ([Definition 30](chap-state.html#defn-set-state-at)):

Definition 30. [Set State At Block](chap-state.html#defn-set-state-at)

The function:

$"Set-State-At"(B)$

in which $B$ is a block in the block tree ([Definition 4](chap-state.html#defn-block-tree)), sets the content of state storage equal to the resulting state of executing all extrinsics contained in the branch of the block tree from genesis till block B including those recorded in Block $B$.

For the definition of the state storage see [Section 2.4](chap-state.html#sect-state-storage).

## [](#sect-child-storages)[2.5. Child Storage](#sect-child-storages)

As clarified in [Section 2.4](chap-state.html#sect-state-storage), the Polkadot state storage implements a hash table for inserting and reading key-value entries. The child storage works the same way but is stored in a separate and isolated environment. Entries in the child storage are not directly accessible via querying the main state storage.

The Polkadot Host supports as many child storages as required by Runtime and identifies each separate child storage by its unique identifying key. Child storages are usually used in situations where Runtime deals with multiple instances of a certain type of objects such as Parachains or Smart Contracts. In such cases, the execution of the Runtime entrypoint might result in generating repeated keys across multiple instances of certain objects. Even with repeated keys, all such instances of key-value pairs must be able to be stored within the Polkadot state.

In these situations, the child storage can be used to provide the isolation necessary to prevent any undesired interference between the state of separated instances. The Polkadot Host makes no assumptions about how child storages are used, but provides the functionality for it via the Host API ([Section B.3](chap-host-api.html#sect-child-storage-api)).

### [](#sect-child-trie-structure)[2.5.1. Child Tries](#sect-child-trie-structure)

The child trie specification is the same as the one described in [Section 2.4.3](chap-state.html#sect-state-storage-trie-structure). Child tries have their own isolated environment. Nonetheless, the main Polkadot state trie depends on them by storing a node ($K_N, V_N$) which corresponds to an individual child trie. Here, $K_N$ is the child storage key associated to the child trie, and $V_N$ is the Merkle value of its corresponding child trie computed according to the procedure described in [Section 2.4.4](chap-state.html#sect-merkl-proof).

The Polkadot Host API ([Section B.3](chap-host-api.html#sect-child-storage-api)) allows the Runtime to provide the key $K_N$ in order to identify the child trie, followed by a second key in order to identify the value within that child trie. Every time a child trie is modified, the Merkle proof $V_N$ of the child trie stored in the Polkadot state must be updated first. After that, the final Merkle proof of the Polkadot state can be computed. This mechanism provides a proof of the full Polkadot state including all its child states.

## [](#sect-runtime-interaction)[2.6. Runtime Interactions](#sect-runtime-interaction)

Like any transaction-based transition system, Polkadot’s state is changed by executing an ordered set of instructions. These instructions are known as *extrinsics*. In Polkadot, the execution logic of the state transition function is encapsulated in a Runtime ([Definition 1](chap-state.html#defn-state-machine)). For easy upgradability this Runtime is presented as a Wasm blob. Nonetheless, the Polkadot Host needs to be in constant interaction with the Runtime ([Section 2.6.1](chap-state.html#sect-entrypoints-into-runtime)).

In [Section 2.3](chap-state.html#sect-extrinsics), we specify the procedure of the process where the extrinsics are submitted, pre-processed and validated by Runtime and queued to be applied to the current state.

To make state replication feasible, Polkadot journals and batches series of its extrinsics together into a structure known as a *block*, before propagating them to other nodes, similar to most other prominent distributed ledger systems. The specification of the Polkadot block as well as the process of verifying its validity are both explained in [Section 2.2](chap-state.html#sect-state-replication).

### [](#sect-entrypoints-into-runtime)[2.6.1. Interacting with the Runtime](#sect-entrypoints-into-runtime)

The Runtime ([Definition 1](chap-state.html#defn-state-machine)) is the code implementing the logic of the chain. This code is decoupled from the Polkadot Host to make the the logic of the chain easily upgradable without the need to upgrade the Polkadot Host itself. The general procedure to interact with the Runtime is described by [Interact-With-Runtime](chap-state.html#algo-runtime-interaction).

\require \$F, H_b(B),(A_1,\ldots,A_n)\$ \state \$\mathcal{S}\_B \leftarrow\$ \call{Set-State-At}{\$H_b(B)\$} \state \$A \leftarrow Enc\_{SC}((A_1, \ldots, A_n))\$ \state \call{Call-Runtime-Entrypoint}{\$R_B, \mathcal{RE}\_B, F, A, A\_{len}\$}

where  
- $F$ is the runtime entrypoint call.

- $H_b(B)$ is the block hash indicating the state at the end of $B$.

- $A_1,...,A_n$ are arguments to be passed to the runtime entrypoint.

In this section, we describe the details upon which the Polkadot Host is interacting with the Runtime. In particular, $"Set-State-At"$ and $"Call-Runtime-Entrypoint"$ procedures called by [Interact-With-Runtime](chap-state.html#algo-runtime-interaction) are explained in [Definition 32](chap-state.html#defn-call-into-runtime) and [Definition 30](chap-state.html#defn-set-state-at) respectively. $R_B$ is the Runtime code loaded from $S_B$, as described in [Definition 31](chap-state.html#defn-runtime-code-at-state), and $RE_B$ is the Polkadot Host API, as described in [Definition 201](chap-host-api.html#defn-host-api-at-state).

### [](#sect-loading-runtime-code)[2.6.2. Loading the Runtime Code](#sect-loading-runtime-code)

The Polkadot Host expects to receive the code for the Runtime of the chain as a compiled WebAssembly (Wasm) Blob. The current runtime is stored in the state database under the key represented as a byte array:

$b := "3A,63,6F,64,65"$

which is the ASCII byte representation of the string `:code` ([Section A.3](id-cryptography-encoding.html#chapter-genesis)). As a result of storing the Runtime as part of the state, the Runtime code itself becomes state sensitive and calls to Runtime can change the Runtime code itself. Therefore the Polkadot Host needs to always make sure to provide the Runtime corresponding to the state in which the entrypoint has been called. Accordingly, we define $R_B$ ([Definition 31](chap-state.html#defn-runtime-code-at-state)).

The initial Runtime code of the chain is provided as part of the genesis state ([Section A.3](id-cryptography-encoding.html#chapter-genesis)) and subsequent calls to the Runtime have the ability to, in turn, upgrade the Runtime by replacing this Wasm blob with the help of the storage API ([Section B.2](chap-host-api.html#sect-storage-api)). Therefore, the executor **must always** load the latest Runtime from storage - or preferably detect Runtime upgrades ([Definition 11](chap-state.html#defn-digest)) - either based on the parent block when importing blocks or the best/highest block when creating new blocks.

Definition 31. [Runtime Code at State](chap-state.html#defn-runtime-code-at-state)

By $R_B$, we refer to the Runtime code stored in the state storage at the end of the execution of block $B$.

### [](#sect-code-executor)[2.6.3. Code Executor](#sect-code-executor)

The Polkadot Host executes the calls of Runtime entrypoints inside a Wasm Virtual Machine (VM), which in turn provides the Runtime with access to the Polkadot Host API. This part of the Polkadot Host is referred to as the *Executor*.

[Definition 32](chap-state.html#defn-call-into-runtime) introduces the notation for calling the runtime entrypoint which is used whenever an algorithm of the Polkadot Host needs to access the runtime.

It is acceptable behavior that the Runtime panics during execution of a function in order to indicate an error. The Polkadot Host must be able to catch that panic and recover from it.

In this section, we specify the general setup for an Executor that calls into the Runtime. In [Appendix C](chap-runtime-api.html) we specify the parameters and return values for each Runtime entrypoint separately.

Definition 32. [Call Runtime Entrypoint](chap-state.html#defn-call-into-runtime)

By

$"Call-Runtime-Entrypoint"(R,RE,"Runtime-Entrypoint",A,A_len)$

we refer to the task using the executor to invoke the while passing an $A_1, ..., A_n$ argument to it and using the encoding described in [Section 2.6.3.2](chap-state.html#sect-runtime-send-args-to-runtime-enteries).

#### [](#sect-memory-management)[2.6.3.1. Memory Management](#sect-memory-management)

The Polkadot Host is responsible for managing the WASM heap memory starting at the exported symbol as a part of implementing the allocator Host API ([Section B.9](chap-host-api.html#sect-allocator-api)) and the same allocator should be used for any other heap allocation to be used by the Polkadot Runtime.

The size of the provided WASM memory should be based on the value of the storage key (an unsigned 64-bit integer), where each page has the size of 64KB. This memory should be made available to the Polkadot Runtime for import under the symbol name `memory`.

#### [](#sect-runtime-send-args-to-runtime-enteries)[2.6.3.2. Sending Data to a Runtime Entrypoint](#sect-runtime-send-args-to-runtime-enteries)

In general, all data exchanged between the Polkadot Host and the Runtime is encoded using SCALE codec described in [Section A.2.2](id-cryptography-encoding.html#sect-scale-codec). Therefore all runtime entrypoints have the following identical Wasm function signatures:

``` rouge
(func $runtime_entrypoint (param $data i32) (param $len i32) (result i64))
```

In each invocation of a Runtime entrypoints, the argument(s) which are supposed to be sent to the entrypoint, need to be SCALE encoded into a byte array $B$ ([Section A.2.2](id-cryptography-encoding.html#sect-scale-codec)) and copied into a section of Wasm shared memory managed by the shared allocator described in [Section 2.6.3.1](chap-state.html#sect-memory-management).

When the Wasm method, corresponding to the entrypoint, is invoked, two integers are passed as arguments. The first argument is set to the memory address of the byte array $B$ in Wasm memory. The second argument sets the length of the encoded data stored in $B$.

#### [](#sect-runtime-return-value)[2.6.3.3. Receiving Data from a Runtime Entrypoint](#sect-runtime-return-value)

The value which is returned from the invocation is an integer, representing two consecutive integers in which the least significant one indicates the pointer to the offset of the result returned by the entrypoint encoded in SCALE codec in the memory buffer. The most significant one provides the size of the blob.

#### [](#sect-runtime-version-custom-section)[2.6.3.4. Runtime Version Custom Section](#sect-runtime-version-custom-section)

For newer Runtimes, the Runtime version ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) can be read directly from the [Wasm custom section](https://webassembly.github.io/spec/core/appendix/custom.html) with the name `runtime_version`. The content is a SCALE encoded structure as described in [Section C.4.1](chap-runtime-api.html#defn-rt-core-version).

Retrieving the Runtime version this way is preferred over calling the `Core_version` entrypoint since it involves significantly less overhead.
