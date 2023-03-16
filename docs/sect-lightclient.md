---
title: Light Clients
---

## 7.1. Requirements for Light Clients {#sect-requirements-lightclient}

We list requirements of a Light Client categorized along the the three dimensions of Functionality, Efficiency, and Security.

- **Functional Requirements:**

  1.  Update state ([Section 2.4](chap-state.html#sect-state-storage)) to reflect the latest view of the blockchain via synchronization with full nodes.

  2.  (Optional) Verify validity of runtime transitions ([Section 2.6](chap-state.html#sect-runtime-interaction)).

  3.  Make queries for data at the latest block height or across a range of blocks.

  4.  Append extrinsics ([Section 2.3](chap-state.html#sect-extrinsics)) to the blockchain via full nodes.

- **Efficiency Requirements:**

  1.  Efficient bootstrapping and syncing: initializations and update functions of the state have tractable computation and communication complexity and grows at most linearly with the chain size. Generally, the complexity is proportional to the GRANDPA validator set change.

  2.  Querying operations happen by requesting athe key-value pair from a full node.

  3.  Further, verifying the validity of responses by the full node is logarithmic in the size of the state.

- **Security Requirements:**

  1.  Secure bootstrapping and Synchronizing: Probability that an adversarial full node convincing a light client of a forged blockchain state is negligible.

  2.  Secure querying: Probability that an adversary convinces light client to accept a forged account state os negligible.

  3.  Assure that the submitted extrinsics are appended in a successor block or inform the user incase of failure.

- **Polkadot Specific Requirements:**

  1.  The client MUST be able to connect to a relay chain using chain state.

  2.  The client MUST be able to retrieve checkpoint state from a trusted source to speed up initialization.

  3.  The client MUST be able to subscribe/unsubscribe to/from any polkadot-spec-conformant relay chain (Polkadot, Westend, Kusama)

  4.  The client MUST be able to subscribe/unsubscribe to/from parachains that do not use custom protocols or cryptography methods other than those that Polkadot, Westend and Kusama use.

  5.  The client MUST support the following [RPC methods](https://github.com/paritytech/json-rpc-interface-spec): `rpc_methods`, `chainHead_unstable_follow`, `chainHead_unstable_unfollow`, `chainHead_unstable_unpin`, `chainHead_unstable_storage`, `chainHead_unstable_call` `chainHead_unstable_stopCall`. `transaction_unstable_submitAndWatch`, and `transaction_unstable_unwatch`

  6.  The client MUST support the @substrate/connect [connection extension protocol](https://github.com/paritytech/substrate-connect/tree/main/packages/connect-extension-protocol): `ToApplicationError`, `ToApplicationChainReady`, `ToApplicationRpc`, `ToExtensionAddChain`, `ToExtensionAddWellKnownChain`, `ToExtensionRpc`, `ToExtensionRemoveChain`.

## 7.2. Warp Sync for Light Clients {#sect-sync-warp-lightclient}

Warp sync ([Section 4.8.4](chap-networking.html#sect-msg-warp-sync)) only downloads the block headers where authority set changes occurred, so-called fragments ([Definition 41](chap-networking.html#defn-warp-sync-proof)), and by verifying the GRANDPA justifications ([Definition 78](sect-finality.html#defn-grandpa-justification)). This protocol allows nodes to arrive at the desired state much faster than fast sync. Warp sync is primarily designed for Light Clients. Although, warp sync could be used by full nodes, the sync process may lack information to cater to complete functionality set of full nodes.

For light clients, it is too expensive to download the state (approx. 550MB) to respond to queries. Rather, the queries are submitted to the Full node and only the response of the full node is validated using the hash of the state root. Requests for warp sync are performed using the `/dot/sync/warp` *Request-Response* substream, the corresponding network messages are detailed in [Section 4.7](chap-networking.html#sect-protocols-substreams).

Light clients base their trust in provided snapshots and the ability to slash grandpa votes for equivocation for the period they are syncing via warp sync. Full nodes and above in contrast verify each block indvidually.

In theory, the `warp sync` process takes the Genesis Block as input and outputs the hash of the state trie root at the latest finalized block. This root hash acts as proof to further validate the responses to queries by the full node. The `warp sync` works by starting from a trusted specified block (for e.g. from a snapshot) and verifying the block headers only at the authority set changes.

Eventually, the light client verifies the finality of the block returned by a full node to ensure that the block is indeed the latest finalized block. This entails two things:

1.  Check the authenticity of GRANDPA Justifications messages from Genesis to the last finalized block.

2.  Check the timestamp of the last finalized block to ensure that no other blocks might have been finalized at a later timestamp.

|     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|-----|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | **Long-Range Attack Vulnerabilities**: Warp syncing is particularly vulnerable to what is called long-range attacks. The authorities allowed to finalize blocks can generate multiple proofs of finality for multiple different blocks of the same height, hence, they can finalize more than one chain at a time. It is possible for two-thirds of the validators that were active at a certain past block N to collude and decide to finalize a different block N', even when N has been finalized for the first time several weeks or months in the past. When a client then warp syncs, it can be tricked to consider this alternative block N' as the finalized one. However, in practice, to mitigate Long-Range Attacks, the starting point of the warp syncing is not too far in the past. How far exactly depends on the logic of the runtime of the chain. For example, in Polkadot, the starting block for the sync should be at max 28 days old, to be within the purview of the slashing period for misbehaving nodes. Hence, even though in theory warp sync can start from Genesis Block, it is not advised to implement the same in practice. |

We outline the warp sync process, abstracting out details of verifying the finality and how the full node to sync with is selected.

\INPUT BlockHeader startblock, the initial block to start the sync. May not be the Genesis Block. \OUTPUT CommitmentRootHash ${\sqrt[$]{}}, State Tries Root hash of the latest finalized Block. \STATE \textsc{fullnode} $\leftarrow$ SelectFullNode \STATE \textsc{latestBlockHeader, grandpaJustifications} $\leftarrow$ SyncWithNode(\textsc{fullnode}) \STATE \textsc{isVerified} $\leftarrow$ verifyAuthoritySetChange(\textsc{grandpaJustifications}) ${l}{\quad\text{and}\quad}$ verifyFinality(\textsc{latestBlockHeader}) \IF{\textsc{isVerified}} \STATE ${r}{e}{t}{u}{r}{n}$ ${S}{O}{M}{E}$ getCommitmentRootHash(\textsc{latestBlockHeader}) \ENDIF \STATE {${t}{h}{r}{o}{w}$ ${E}\mathbb{R}{O}{R}$}

Abstraction of Warp Sync and verification of latest block’s finality.

${S}{e}\le{c}{t}{F}\underline{{l}}{N}{o}{d}{e}$: Determines the full node that the light client syncs with.

${S}{y}{n}{c}{S}{i}{t}{h}{N}{o}{d}{e}$: Returns the header of latest finalized block and a list of Grandpa Justifications by the full node.

${v}{e}{r}{\quad\text{if}\quad}{y}{A}{u}{t}{h}{\quad\text{or}\quad}{i}{t}{y}{S}{e}{t}{C}{h}{a}{n}\ge$: Verification algorithm which checks the authenticity of the header only at the end of an era where the authority set changes iteratively until reaching the latest era.

${v}{e}{r}{\quad\text{if}\quad}{y}{F}\in{a}\lt{y}$: Verifies the finalty of the latest block using the Grandpa Justifications messages.

The warp syncing process is closely coupled with the state querying procedure used the light client. We outline the process of querying the state by a light client and validating the response.

\INPUT Query q, BlockHeight h, CommitmentRootHash ${\sqrt[$]{}} \OUTPUT Maybe Result ${r}{e}{s}$ \STATE (${r}{e}{s}$, $\pi$) $\leftarrow{Q}{u}{e}{r}{y}{F}\underline{{l}}{N}{o}{d}{e}{\left({q},{h}\right)}$ \IF{${v}{a}{l}{i}{d}{i}{t}{y}{C}{h}{e}{c}{k}_{{{\root}}}{\left({r}{e}{s},\pi\right)}$} \STATE ${r}{e}{t}{u}{r}{n}$ ${S}{O}{M}{E}$ ${r}{e}{s}$ \ENDIF \STATE {${t}{h}{r}{o}{w}$ ${E}\mathbb{R}{O}{R}$}

Querying State Algorithm.

${Q}{u}{e}{r}{y}{F}\underline{{l}}{N}{o}{d}{e}$: Returns the response to the query requested from the Full Node for the query ${q}$ at block height ${h}$.

${v}{a}{l}{i}{d}{i}{t}{y}{C}{h}{e}{c}{k}_{{{\root}}}$: Predicate that checks the validity of response ${r}{e}{s}$ and associated merkle proof $\pi$ by matching it against the Commit Root Hash ${\sqrt[$]{}} obtained as a result of warp sync.

## 7.3. Runtime Environment for Light Clients {#sect-runtime-environment-lightclient}

Technically, though a runtime execution environment is not necessary to build a light client, most clients require interacting with the Runtime and the state of the blockchain for integrity checks at the minimum. One can imagine an application scenarios like an on-chain light client which only listens to the latest state without ever adding extrinsics. Current implementations of Light Nodes (for e.g. Smoldot) uses the wasmtime as its runtime environment to drastically simplify the code. The performance of wasmtime is satisfying enough to not require a native runtime. The details of runtime API that the environment needs to suppport can be found in Appendix C ([Appendix C](chap-runtime-api.html)).

## 7.4. Light Client Messages {#sect-light-msg}

Light clients are applications that fetch the required data that they need from a Polkadot node with an associated proof to validate the data. This makes it possible to interact with the Polkadot network without requiring to run a full node or having to trust the remote peers. The light client messages make this functionality possible.

All light client messages are protobuf encoded and are sent over the `/dot/light/2` substream.

### 7.4.1. Request {#id-request}

A message with all possible request messages. All message are sent as part of this message.

| Type                | Id  | Description      |
|---------------------|-----|------------------|
| `oneof` (`request`) |     | The request type |

Where the `request` can be one of the following fields:

| Type                     | Id  | Description                                                                                                |
|--------------------------|-----|------------------------------------------------------------------------------------------------------------|
| `RemoteCallRequest`      | 1   | A remote call request ([Definition 96](sect-lightclient.html#sect-light-remote-call-request))              |
| `RemoteReadRequest`      | 2   | A remote read request ([Definition 98](sect-lightclient.html#sect-light-remote-read-request))              |
| `RemoteReadChildRequest` | 4   | A remote read child request ([Definition 100](sect-lightclient.html#sect-light-remote-read-child-request)) |

### 7.4.2. Response {#id-response}

A message with all possible response messages. All message are sent as part of this message.

| Type                 | Id  | Description       |
|----------------------|-----|-------------------|
| `oneof` (`response`) |     | The response type |

Where the `response` can be one of the following fields:

| Type                 | Id  | Description                                                                                     |
|----------------------|-----|-------------------------------------------------------------------------------------------------|
| `RemoteCallResponse` | 1   | A remote call response ([Definition 97](sect-lightclient.html#sect-light-remote-call-response)) |
| `RemoteReadResponse` | 2   | A remote read response ([Definition 99](sect-lightclient.html#sect-light-remote-read-response)) |

### 7.4.3. Remote Call Messages {#id-remote-call-messages}

Execute a call to a contract at the given block.

Definition 96. [Remote Call Request](sect-lightclient.html#sect-light-remote-call-request)

Remote call request.

| Type     | Id  | Description                    |
|----------|-----|--------------------------------|
| `bytes`  | 2   | Block at which to perform call |
| `string` | 3   | Method name                    |
| `bytes`  | 4   | Call data                      |

Definition 97. [Remote Call Response](sect-lightclient.html#sect-light-remote-call-response)

Remote call response.

| Type    | Id  | Description                                                                                                                                         |
|---------|-----|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `bytes` | 2   | An *Option* type ([Definition 190](id-cryptography-encoding.html#defn-option-type)) containing the call proof or *None* if proof generation failed. |

### 7.4.4. Remote Read Messages {#id-remote-read-messages}

Read a storage value at the given block.

Definition 98. [Remote Read Request](sect-lightclient.html#sect-light-remote-read-request)

Remote read request.

| Type             | Id  | Description                    |
|------------------|-----|--------------------------------|
| `bytes`          | 2   | Block at which to perform call |
| `repeated bytes` | 3   | Storage keys                   |

Definition 99. [Remote Read Response](sect-lightclient.html#sect-light-remote-read-response)

Remote read response.

| Type    | Id  | Description                                                                                                                                         |
|---------|-----|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `bytes` | 2   | An *Option* type ([Definition 190](id-cryptography-encoding.html#defn-option-type)) containing the read proof or *None* if proof generation failed. |

### 7.4.5. Remote Read Child Messages {#id-remote-read-child-messages}

Read a child storage value at the given block.

Definition 100. [Remote Read Child Request](sect-lightclient.html#sect-light-remote-read-child-request)

Remote read child request.

| Type    | Id  | Description                                                            |
|---------|-----|------------------------------------------------------------------------|
| `bytes` | 2   | Block at which to perform call                                         |
| `bytes` | 3   | Child storage key, this is relative to the child type storage location |
| `bytes` | 6   | Storage keys                                                           |

The response is the same as for the *Remote Read Request* message, respectively [Definition 99](sect-lightclient.html#sect-light-remote-read-response).

## 7.5. Storage for Light Clients {#sect-storage-lightclient}

The light client requires a persistent storage for saving the state of the blockchain. In addition it requires efficient Serialization/ De-serialization methods to transform SCALE ([Section A.2.2](id-cryptography-encoding.html#sect-scale-codec)) encoded network traffic for storing and reading from the persistent storage.
