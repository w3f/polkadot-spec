---
title: "Glossary"
---

${P}_{{n}}$  
A path graph or a path of ${n}$ nodes.

${\left({b}_{{0}},{b}_{{1}},\ldots,{b}_{{{n}-{1}}}\right)}$  
A sequence of bytes or byte array of length ${n}$

$𝔹_{{n}}$  
A set of all byte arrays of length ${n}$

${I}=\le{f}{t}{\left({B}_{{n}}…{B}_{{0}}{r}{i}{g}{h}{t}\right)}_{{{256}}}$  
A non-negative interger in base 256

${B}={\left({b}_{{0}},{b}_{{1}},…,{b}_{{n}}\right)}$  
The little-endian representation of a non-negative interger ${I}={\left({B}_{{n}}…{B}_{{0}}\right)}_{{{256}}}$ such that ${b}_{{i}}≔{B}_{{i}}$

$\text{}{m}{\left\lbrace{E}{n}{c}\right\rbrace}_{{{L}{E}}}$  
The little-endian encoding function.

${C}$  
A blockchain defined as a directed path graph.

Block  
A node of the directed path graph (blockchain) C

Genesis Block  
The unique sink of blockchain C

Head  
The source of blockchain C

${P}{\left({B}\right)}$  
The parent of block ${B}$

UNIX time  
The number of milliseconds that have elapsed since the Unix epoch as a 64-bit integer

${B}{T}$  
The block tree of a blockchain

${G}$  
The genesis block, the root of the block tree BT

$\text{}{m}{\left\lbrace{C}{H}{A}{I}{N}\right\rbrace}{\left({B}\right)}$  
The path graph from ${G}$ to ${B}$ in ${B}{T}$.

${H}{e}{a}{d}{\left({C}\right)}$  
The head of chain C.

${\left|{C}\right|}$  
The length of chain ${C}$ as a path graph

$\text{}{m}{\left\lbrace{S}{u}{b}{C}{h}{a}\in\right\rbrace}{\left({B}',{B}\right)}$  
The subgraph of ${C}{h}{a}\in{\left({B}\right)}$ path graph containing both ${B}$ and ${B}'$.

$ℂ_{{B}}{\left({B}{T}\right)}$  
The set of all subchains of ${B}{T}$ rooted at block ${B}$.

$ℂ,ℂ{\left({B}{T}\right)}$  
$ℂ_{{G}}{\left({B}{T}\right)}$ i.e. the set of all chains of ${B}{T}$ rooted at genesis block

$\text{}{m}{\left\lbrace{L}{o}{n}\ge{s}{t}-{C}{h}{a}\in\right\rbrace}{\left({B}{T}\right)}$  
The longest sub path graph of ${B}{T}$ i.e. ${C}:{\left|{C}\right|}=\max_{{{C}_{{i}}∈ℂ}}{\left|{C}_{{i}}\right|}$

$\text{}{m}{\left\lbrace{L}{o}{n}\ge{s}{t}-{P}{a}{t}{h}\right\rbrace}{\left({B}{T}\right)}$  
The longest sub path graph of ${\left({P}\right)}{B}{T}$ with earliest block arrival time

$\text{}{m}{\left\lbrace{D}{e}{e}{p}{e}{s}{t}-{L}{e}{a}{f}\right\rbrace}{\left({B}{T}\right)}$  
$\text{}{m}{\left\lbrace{H}{e}{a}{d}\right\rbrace}{\left(\text{}{m}{\left\lbrace{L}{o}{n}\ge{s}{t}-{P}{a}{t}{h}\right\rbrace}{\left({B}{T}\right)}\right)}$ i.e. the head of $\text{}{m}{\left\lbrace{L}{o}{n}\ge{s}{t}-{P}{a}{t}{h}\right\rbrace}{\left({B}{T}\right)}$

${B}>{B}'$  
${B}$ is a descendant of ${B}'$ in the block tree

$\text{}{m}{\left\lbrace{S}\to{r}{e}{d}{V}{a}{l}{u}{e}\right\rbrace}{\left({k}\right)}$  
The function to retrieve the value stored under a specific key in the state storage.

State trie, trie  
The Merkle radix-16 Tree which stores hashes of storage enteries.

$\text{}{m}{\left\lbrace{K}{e}{y}{E}{n}{c}{o}{d}{e}\right\rbrace}{\left({k}\right)}$  
The function to encode keys for labeling branaches of the trie.

$𝒩$  
The set of all nodes in the Polkadot state trie.

${N}$  
An individual node in the trie.

$𝒩_{{b}}$  
A branch node of the trie which has at least one and at most 16 children

$𝒩_{{l}}$  
A childless leaf node of the trie

${p}{{k}_{{N}}^{{{A}{g}{r}}}}$  
The aggregated prefix key of node N

${p}{k}_{{N}}$  
The (suffix) partial key of node N

$\text{}{m}{\left\lbrace{I}{n}{d}{e}{x}\right\rbrace}_{{N}}$  
A function returning an integer in range of {0, . . . ,15} represeting the index of a child node of node ${N}$ among the children of ${N}$

${v}_{{N}}$  
Node value containing the header of node ${N}$, its partial key and the digest of its childern values

$\text{}{m}{\left\lbrace{H}{e}{a}{d}\right\rbrace}_{{N}}$  
The node header of trie node ${N}$ storing information about the node’s type and kay

${H}{\left({N}\right)}$  
The Merkle value of node ${N}$.

$\text{}{m}{\left\lbrace{C}{h}{i}{l}{d}{r}{e}{n}{B}{i}{t}{m}{a}{p}\right\rbrace}$  
The binary function indicating which child of a given node is present in the trie.

${s}{v}_{{N}}$  
The subvalue of a trie node ${N}$.

Child storage  
A sub storage of the state storage which has the same structure although being stored separately

Child trie  
State trie of a child storage

Transaction Queue  
See [Definition 14](chap-state.html#defn-transaction-queue).

${H}_{{p}}$  
The 32-byte Blake2b hash of the header of the parent of the block.

${H}_{{i}},{H}_{{i}}{\left({B}\right)}$  
Block number, the incremental interger index of the current block in the chain.

${H}_{{r}}$  
The hash of the root of the Merkle trie of the state storage at a given block

${H}_{{e}}$  
An auxileray field in block header used by Runtime to validate the integrity of the extrinsics composing the block body.

${H}_{{d}}$, ${H}_{{d}}{\left({B}\right)}$  
A block header used to store any chain-specific auxiliary data.

${H}_{{h}}{\left({B}\right)}$  
The hash of the header of block ${B}$

$\text{}{m}{\left\lbrace{B}{o}{\left.{d}{y}\right.}\right\rbrace}{\left({B}\right)}$  
The body of block ${B}$ consisting of a set of extrinsics

${M}^{{{r},{s}{t}{a}\ge}}_{v}$  
Vote message broadcasted by the voter v as part of the finality protocol

${{M}_{{v}}^{{{r},{F}\in}}}{\left({B}\right)}$  
The commit message broadcasted by voter ${v}$ indicating that they have finalized bock ${B}$ in round ${r}$

${v}$  
GRANDPA voter node which casts vote in the finality protocol

${{k}_{{v}}^{{{p}{r}}}}$  
The private key of voter ${v}$

${v}_{{{i}{d}}}$  
The public key of voter ${v}$

$𝕍_{{B}},𝕍$  
The set of all GRANDPA voters for at block ${B}$

${G}{S}$  
GRANDPA protocol state consisting of the set of voters, number of times voters set has changed and the current round number.

${r}$  
The voting round counter in the finality protocol

${V}_{{{B}}}$  
A GRANDPA vote casted in favor of block B

${{V}_{{v}}^{{{r},{p}{v}}}}$  
A GRANDPA vote casted by voter ${v}$ during the pre-vote stage of round ${r}$

${{V}_{{v}}^{{{r},{p}{c}}}}$  
A GRANDPA vote casted by voter ${v}$ during the pre-commit stage of round ${r}$

${J}^{{{r},{s}{t}{a}\ge}}{\left({B}\right)}$  
The justification for pre-committing or committing to block ${B}$ in round ${r}$ of finality protocol

${S}{i}{g}{n}^{{{r},{s}{t}{a}\ge}}_{\left\lbrace{v}_{{i}}\right\rbrace}{\left({B}\right)}$  
The signature of voter ${v}$ on their voteto block B, broadcasted during the specified stage of finality round ${r}$

$ℰ^{{{r},{s}{t}{a}\ge}}$  
The set of all equivocator voters in sub-round ‘‘stage'' of round ${r}$

$ℰ^{{{r},{s}{t}{a}\ge}}_{\left\lbrace{o}{b}{s}{\left({v}\right)}\right\rbrace}$  
The set of all equivocator voters in sub-round ‘‘stage'' of round ${r}$ observed by voter ${v}$

${V}{D}^{{{r},{s}{t}{a}\ge}}_{\left\lbrace{o}{b}{s}{\left({v}\right)}\right\rbrace}{\left({B}\right)}$  
The set of observed direct votes for block B in round ${r}$

${V}^{{{r},{s}{t}{a}\ge}}_{\left\lbrace{o}{b}{s}{\left({v}\right)}\right\rbrace}$  
The set of total votes observed by voter v in sub-round ‘‘stage'' of round r

${V}^{{{r},{s}{t}{a}\ge}}_{\left\lbrace{o}{b}{s}{\left({v}\right)}\right\rbrace}{\left({B}\right)}$  
The set of all observed votes by ${v}$ in the sub-round “stage” of round ${r}$ (directly or indirectly) for block ${B}$

${B}^{{{r},{p}{v}}}_{v}$  
The currently pre-voted block in round ${r}$. The GRANDPA GHOST of round ${r}$

Account key, ${\left({s}{k}^{{a}},{p}{k}^{{a}}\right)}$  
A key pair of types accepted by the Polkadot protocol which can be used to sign transactions

${E}{n}{c}_{{{S}{C}}}{\left({A}\right)}$  
SCALE encoding of value ${A}$

${T}≔{\left({A}_{{1}},\ldots,{A}_{{n}}\right)}$  
A tuple of values ${A}_{{i}}$'s each of different type

Varying Data Types $𝒯={\left\lbrace{T}_{{1}},…,{T}_{{n}}\right\rbrace}$  
A data type representing any of varying types ${T}_{{1}},…,{T}_{{n}}$.

${S}≔{A}_{{1}},…,{A}_{{n}}$  
Sequence of values ${A}_{{i}}$ of the same type

${E}{n}{c}^{{{L}{e}{n}}}_{\left\lbrace{S}{C}\right\rbrace}{\left({n}\right)}$  
SCALE length encoding aka. compact encoding of non-negative interger ${n}$ of arbitrary size.

${E}{n}{c}_{{{H}{E}}}{\left({P}{K}\right)}$  
Hex encoding
