---
title: "Glossary"
---

$P_n$  
A path graph or a path of $n$ nodes.

$(b_0,b_1,...,b\_{n-1})$  
A sequence of bytes or byte array of length $n$

$𝔹_n$  
A set of all byte arrays of length $n$

$I=\left(B_n…B_0\right)\_{256}$  
A non-negative interger in base 256

$B=(b_0,b_1,…,b_n)$  
The little-endian representation of a non-negative interger $I=(B_n…B_0)\_{256}$ such that $b_i≔B_i$

$\textrm{Enc}\_{LE}$  
The little-endian encoding function.

$C$  
A blockchain defined as a directed path graph.

Block  
A node of the directed path graph (blockchain) C

Genesis Block  
The unique sink of blockchain C

Head  
The source of blockchain C

$P(B)$  
The parent of block $B$

UNIX time  
The number of milliseconds that have elapsed since the Unix epoch as a 64-bit integer

$BT$  
The block tree of a blockchain

$G$  
The genesis block, the root of the block tree BT

$\textrm{CHAIN}(B)$  
The path graph from $G$ to $B$ in $BT$.

$Head(C)$  
The head of chain C.

$\|C\|$  
The length of chain $C$ as a path graph

$\textrm{SubChain}(B',B)$  
The subgraph of $Chain(B)$ path graph containing both $B$ and $B'$.

$ℂ_B(BT)$  
The set of all subchains of $BT$ rooted at block $B$.

$ℂ, ℂ(BT)$  
$ℂ_G(BT)$ i.e. the set of all chains of $BT$ rooted at genesis block

$\textrm{Longest-Chain}(BT)$  
The longest sub path graph of $BT$ i.e. $C : \|C\| = \max\_{C_i ∈ ℂ} \|C_i\|$

$\textrm{Longest-Path}(BT)$  
The longest sub path graph of $(P)BT$ with earliest block arrival time

$\textrm{Deepest-Leaf}(BT)$  
$\textrm{Head}(\textrm{Longest-Path}(BT))$ i.e. the head of $\textrm{Longest-Path}(BT)$

$B \> B'$  
$B$ is a descendant of $B'$ in the block tree

$\textrm{StoredValue}(k)$  
The function to retrieve the value stored under a specific key in the state storage.

State trie, trie  
The Merkle radix-16 Tree which stores hashes of storage enteries.

$\textrm{KeyEncode}(k)$  
The function to encode keys for labeling branaches of the trie.

$𝒩$  
The set of all nodes in the Polkadot state trie.

$N$  
An individual node in the trie.

$𝒩_b$  
A branch node of the trie which has at least one and at most 16 children

$𝒩_l$  
A childless leaf node of the trie

$pk_N^{Agr}$  
The aggregated prefix key of node N

$pk_N$  
The (suffix) partial key of node N

$\textrm{Index}\_N$  
A function returning an integer in range of {0, . . . ,15} represeting the index of a child node of node $N$ among the children of $N$

$v_N$  
Node value containing the header of node $N$, its partial key and the digest of its childern values

$\textrm{Head}\_N$  
The node header of trie node $N$ storing information about the node’s type and kay

$H(N)$  
The Merkle value of node $N$.

$\textrm{ChildrenBitmap}$  
The binary function indicating which child of a given node is present in the trie.

$sv_N$  
The subvalue of a trie node $N$.

Child storage  
A sub storage of the state storage which has the same structure although being stored separately

Child trie  
State trie of a child storage

Transaction Queue  
See [Definition 14](chap-state.html#defn-transaction-queue).

$H_p$  
The 32-byte Blake2b hash of the header of the parent of the block.

$H_i,H_i(B)$  
Block number, the incremental interger index of the current block in the chain.

$H_r$  
The hash of the root of the Merkle trie of the state storage at a given block

$H_e$  
An auxileray field in block header used by Runtime to validate the integrity of the extrinsics composing the block body.

$H_d$, $H_d(B)$  
A block header used to store any chain-specific auxiliary data.

$H_h(B)$  
The hash of the header of block $B$

$\textrm{Body}(B)$  
The body of block $B$ consisting of a set of extrinsics

$M^{r,stage}\_v$  
Vote message broadcasted by the voter v as part of the finality protocol

$M_v^{r,Fin}(B)$  
The commit message broadcasted by voter $v$ indicating that they have finalized bock $B$ in round $r$

$v$  
GRANDPA voter node which casts vote in the finality protocol

$k_v^{pr}$  
The private key of voter $v$

$v\_{id}$  
The public key of voter $v$

$𝕍_B,𝕍$  
The set of all GRANDPA voters for at block $B$

$GS$  
GRANDPA protocol state consisting of the set of voters, number of times voters set has changed and the current round number.

$r$  
The voting round counter in the finality protocol

$V\_(B)$  
A GRANDPA vote casted in favor of block B

$V_v^(r,pv)$  
A GRANDPA vote casted by voter $v$ during the pre-vote stage of round $r$

$V_v^(r,pc)$  
A GRANDPA vote casted by voter $v$ during the pre-commit stage of round $r$

$J^{r,stage}(B)$  
The justification for pre-committing or committing to block $B$ in round $r$ of finality protocol

$Sign^{r,stage}\_{v_i}(B)$  
The signature of voter $v$ on their voteto block B, broadcasted during the specified stage of finality round $r$

$ℰ^{r,stage}$  
The set of all equivocator voters in sub-round ‘‘stage'' of round $r$

$ℰ^{r,stage}\_{obs(v)}$  
The set of all equivocator voters in sub-round ‘‘stage'' of round $r$ observed by voter $v$

$VD^{r,stage}\_{obs(v)}(B)$  
The set of observed direct votes for block B in round $r$

$V^{r,stage}\_{obs(v)}$  
The set of total votes observed by voter v in sub-round ‘‘stage'' of round r

$V^{r,stage}\_{obs(v)}(B)$  
The set of all observed votes by $v$ in the sub-round “stage” of round $r$ (directly or indirectly) for block $B$

$B^{r,pv}\_v$  
The currently pre-voted block in round $r$. The GRANDPA GHOST of round $r$

Account key, $(sk^a,pk^a)$  
A key pair of types accepted by the Polkadot protocol which can be used to sign transactions

$Enc\_{SC}(A)$  
SCALE encoding of value $A$

$T≔(A_1,...,A_n)$  
A tuple of values $A_i$'s each of different type

Varying Data Types $𝒯={T_1,…,T_n}$  
A data type representing any of varying types $T_1,…,T_n$.

$S≔A_1,…,A_n$  
Sequence of values $A_i$ of the same type

$Enc^{Len}\_{SC}(n)$  
SCALE length encoding aka. compact encoding of non-negative interger $n$ of arbitrary size.

$Enc\_{HE}(PK)$  
Hex encoding
