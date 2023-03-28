---
title: Synchronization
---

Many applications that interact with the Polkadot network to some extent must be able to retrieve certain information about the network. Depending on the utility, this includes validators that interact with Polkadot’s consensus and need access to the full state, either from the past or just the most up-to-date state, or light clients that are only interest in the minimum information required in order to verify some claims about the state of the network, such as the balance of a specific account. To allow implemenations to quickly retrieve the required information, different types of synchronization protocols are available, respectivel Full, Fast and Warp sync suited for different needs.

The associated network messages are specified in [Section -sec-num-ref-](chap-networking#sect-network-messages).

## -sec-num- Warp Sync {#sect-sync-warp}

Warp sync ([Section -sec-num-ref-](chap-networking#sect-msg-warp-sync)) only downloads the block headers where authority set changes occurred, so called fragments ([Definition -def-num-ref-](chap-networking#defn-warp-sync-proof)), and by verifying the GRANDPA justifications ([Definition -def-num-ref-](chap-networking#defn-grandpa-justifications-compact)). This protocols allows nodes to arrive at the desired state much faster than fast sync.

## -sec-num- Fast Sync {#sect-sync-fast}

Fast sync works by downloading the block header history and validating the auhtority set changes ([Section -sec-num-ref-](chap-sync#sect-authority-set)) in order to arrive at a specific (usually the most recent) header. After the desired header has been reached and verified, the state can be downloaded and imported ([Section -sec-num-ref-](chap-networking#sect-msg-state-request)). Once this process has been completed, the node can proceed with a full sync.

## -sec-num- Full Sync {#id-full-sync}

The full sync protocols is the "default" protocol that’s suited for many types of implementations, such as archive nodes (nodes that store everything), validators that participate in Polkadots consensus and light clients that only verify claims about the state of the network. Full sync works by listening to announced blocks ([Section -sec-num-ref-](chap-networking#sect-msg-block-announce)) and requesting the blocks from the announcing peers, or just the block headers in case of light clients.

The full sync protocol usually downloads the entire chain, but no such requirements must be met. If an implemenation only wants the latest, finalized state, it can combine it with protocols such as fast sync ([Section -sec-num-ref-](chap-sync#sect-sync-fast)) and/or warp sync ([Section -sec-num-ref-](chap-sync#sect-sync-warp)) to make synchronization as fast as possible.

### -sec-num- Consensus Authority Set {#sect-authority-set}

Because Polkadot is a proof-of-stake protocol, each of its consensus engines has its own set of nodes represented by known public keys, which have the authority to influence the protocol in pre-defined ways explained in this Section. To verify the validity of each block, the Polkadot node must track the current list of authorities ([Definition -def-num-ref-](chap-sync#defn-authority-list)) for that block.

###### Definition -def-num- Authority List {#defn-authority-list}

The **authority list** of block ${B}$ for consensus engine ${C}$ noted as $\text{Auth}_{{C}}{\left({B}\right)}$ is an array that contains the following pair of types for each of its authorities ${A}\in\text{Auth}_{{C}}{\left({B}\right)}$:

$$
{\left({p}{k}_{{A}},{w}_{{A}}\right)}
$$

${p}{k}_{{A}}$ is the session public key ([Definition -def-num-ref-](id-cryptography-encoding#defn-session-key)) of authority ${A}$. And ${w}_{{A}}$ is an unsigned 64-bit integer indicating the authority weight. The value of $\text{Auth}_{{C}}{\left({B}\right)}$ is part of the Polkadot state. The value for $\text{Auth}_{{C}}{\left({B}_{{0}}\right)}$ is set in the genesis state ([Section -sec-num-ref-](id-cryptography-encoding#chapter-genesis)) and can be retrieved using a runtime entrypoint corresponding to consensus engine ${C}$.

The authorities and their corresponding weights can be retrieved from the Runtime ([Section -sec-num-ref-](chap-runtime-api#sect-rte-grandpa-auth)).

### -sec-num- Runtime-to-Consensus Engine Message {#sect-consensus-message-digest}

The authority list ([Definition -def-num-) is part of the Polkadot state and the Runtime has the authority to update this list in the course of any state transitions. The Runtime informs the corresponding consensus engine about the changes in the authority set by adding the appropriate consensus message in the form of a digest item ([Definition -def-num-)) to the block header of block ${B}$ which caused the transition in the authority set.

The Polkadot Host must inspect the digest header of each block and delegate consensus messages to their consensus engines. The BABE and GRANDPA consensus engine must react based on the type of consensus messages it receives. The active GRANDPA authorities can only vote for blocks that occurred after the finalized block in which they were selected. Any votes for blocks before the came into effect would get rejected.

## -sec-num- Importing and Validating Block {#sect-block-validation}

Block validation is the process by which a node asserts that a block is fit to be added to the blockchain. This means that the block is consistent with the current state of the system and transitions to a new valid state.

New blocks can be received by the Polkadot Host via other peers ([Section -sec-num-ref-](chap-networking#sect-msg-block-request)) or from the Host’s own consensus engine ([Chapter 5](sect-block-production)). Both the Runtime and the Polkadot Host then need to work together to assure block validity. A block is deemed valid if the block author had authorship rights for the slot in which the block was produce as well as if the transactions in the block constitute a valid transition of states. The former criterion is validated by the Polkadot Host according to the block production consensus protocol. The latter can be verified by the Polkadot Host invoking entry into the Runtime as ([Section -sec-num-ref-](chap-runtime-api#sect-rte-core-execute-block)) as a part of the validation process. Any state changes created by this function on successful execution are persisted.

The Polkadot Host implements [Import-and-Validate-Block](chap-sync#algo-import-and-validate-block) to assure the validity of the block.

\require ${B},\text{Just}{\left({B}\right)}$ \state \call{Set-Storage-State-At}{${P}{\left({B}\right)}$} \if{$\text{Just}{\left({B}\right)}\ne{q}\emptyset$} \state \call{Verify-Block-Justification}{${B},\text{Just}{\left({B}\right)}$} \if{${B}~\text{}{f}{\left\lbrace{i}{s}\right\rbrace}~\text{Finalized}~\text{}{f}{\left\lbrace{\quad\text{and}\quad}\right\rbrace}~{P}{\left({B}\right)}~\text{}{f}{\left\lbrace{i}{s}\neg\right\rbrace}~\text{Finalized}$} \state \call{Mark-as-Final}{${P}{\left({B}\right)}$} \endif \endif \if{${H}_{{p}}{\left({B}\right)}\notin{P}{B}{T}$} \return \endif \state \call{Verify-Authorship-Right}{$\text{Head}{\left({B}\right)}$} \state ${B}\leftarrow$ \call{Remove-Seal}{${B}$} \state ${R}\leftarrow$ \call{Call-Runtime-Entry}{$\text{}{t}{\left\lbrace{C}{\quad\text{or}\quad}{e}$\right.}execute${b}{l}{o}{c}{k}{\rbrace},{B}$} \state ${B}\leftarrow$ \call{Add-Seal}{${B}$} \if{${R}=$ \textsc{True}} \state \call{Persist-State}{} \endif

where  
- $\text{Remove-Seal}$ removes the Seal digest from the block ([Definition -def-num-)) before submitting it to the Runtime.

- $\text{Add-Seal}$ adds the Seal digest back to the block ([Definition -def-num-)) for later propagation.

- $\text{Persist-State}$ implies the persistence of any state changes created by ${\mathtt{\text{Core_execute_block}}}$ ([Section -sec-num-ref-](chap-runtime-api#sect-rte-core-execute-block)) on successful execution.

- $\text{PBT}$ is the pruned block tree ([Definition -def-num-ref-](chap-state#defn-block-tree)).

- $\text{Verify-Authorship-Right}$ is part of the block production consensus protocol and is described in [Verify-Authorship-Right](sect-block-production#algo-verify-authorship-right).

- *Finalized block* and *finality* are defined in [Chapter 6](sect-finality).
