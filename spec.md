Polkadot is primarily described by the Relay chain protocol; key logic between para-chain protocols will likely be shared between para-chain implementations but are not inherently a part of the Polkadot protocol.

# Relay chain

The relay chain is a simplified proof-of-stake blockchain backed by a Web Assembly (Wasm) engine.

# State

Its state is has similarities to Ethereum: accounts contained in it are a mapping from a `U64` account index to code (`H256`, a SHA3 of Wasm code) and storage (`H256`, a Merkle-trie root for a set of `H256` to `U8[]` mappings). All such accounts are actually known as "high accounts" since their ID is close to 2**64 and, notionally, they have a "high" privilege level.

Notably, no balance or nonce information is stored directly in the state. Balances, in general, are unneeded since ralay-chain DOTs are not a crypto-currency per se and cannot be transferred between owners directly. Nonces, for the purposes of replay-protection are managed directly by the contracts that accept transactions.

Ownership of DOTs is managed by two accounts independent bodies of code & state): the Staking account (which manages DOTs stakes by users) and the Parachain account (which manages the DOTs owned by para-chains). Transfer from the Staking to the Parachain account happens via a signed transaction being included in the relay chain. Transfer in the reverse direction is initiated directly by the Parachain account through the forwarding of a message.

```
state := U64 -> [ code_hash: H256, storage_root: H256 ]
```

In reality almost all account indices would not represent these high accounts but rather be "virtual". High accounts would each fulfil specific functions (though over time these may expanded or contracted as changes in the protocol determine). The accounts on genesis block can be listed:

- Account 0: Null, Nobody, Universal. Basic user-level account. Can be queried for non-sensitive universal data (like `block_number()`, `block_hash()`). Represents the unauthenticated (external transaction) origin.
- Accounts 1...: The virtual account indices.
- Account ~7: Timestamp account. Stores the current time. May be called from the unauthenticated account once per block.
- Account ~6: Authentication account. Basic account lookup account. Stores a mapping `U64 -> H160` providing a partial public-key derivative ("address", similar to an Ethereum address) for each account index. Can be used to register new accounts (in return for some price). Registration begins at some index greater than zero (likely to be 1 + the number of genesis allocations). The current index increments with each new account registered. A nominal fee (whose value may be set by the Administration contract) is payable for each new account registered.
- Account ~5: Para-chain management account. Stores all things to do with para-chains including total para-chain balances, relay-chain-native account balances that are transferable (per para-chain), validation function, queue information and current state. Is flushed at the beginning of each block in order to allow the previous block's messages to the relay chain to execute.
- Account ~4: Staking account. Stores all things to do with the proof-of-stake algorithm particularly currently staked amounts as a mapping from `U64 -> [ balance: U256, nonce: U64 ]`. Informs the Consensus account of its current validator set. Hosts stake-voting.
- Account ~3: Consensus account. Stores all things consensus and code is the relay-chain consensus logic. Requires to be informed of the current validator set and can be queried for behaviour profiles. Checks validator signatures.
- Account ~2: Administration account. Stores and administers low-level chain parameters. Can unilaterally read and replace code/storage in all accounts, &c. Hosts and acts on stake-voting activities. Acts as entry point in block execution.
- Account ~1: System. Provides low-level mutable interaction with header, in particular `deposit_log()`. Represents the system origin.

For PoC-1, high accounts are likely to be built-in, though eventually they should be implemented as Wasm contracts.

## Transition Function

The transition function is mostly similar to an unmetered variant of Ethereum that removes smart contract functionality except for the use of built-ins. Main points are:

- Utilisation of Wasm engine for code execution rather than EVM.
- High accounts do not harbour or increment a nonce when deploying.
- Wasm intrinsics replace some of the EVM externality functions/opcodes, the rest are unneeded:
  - `BLOCKHASH` -> n/a (provided by `Null.block_hash()`)
  - `NUMBER` -> n/a (provided by `Null.current_number()`)
  - `LOG*` -> `System.deposit_log()`
  - `CREATE` -> `deploy` (which takes a new account index and clobbers any existing code there; no init function is run).
  - `CALL` -> `call` or `call_const`
  - `RETURN` -> n/a (`return` in Wasm)
  - `CALLDATA*` -> n/a (if coming straight from a transaction message data will be passed as bytes into the function)
  - `TIMESTAMP` -> n/a (there is a timestamp contract)
  - `BALANCE`/`ORIGIN`/`GASPRICE`/`EXTCODE`/`COINBASE`/`DIFFICULTY`/`GASLIMIT`/`GAS`/`CALLCODE`/`DELEGATECALL`/`SUICIDE` -> n/a

In summary, the normative block processing mechanism for a block is:

- check the block data is valid RLP with correct item formats; let `block` be the structured data;
- let `header := block.header`;
- check the `header.transactions_root` properly reflects `block.transactions`;
- check a validated block is stored by the node for `header.number - 1` and that its header-hash is `header.parent_hash` (in the normative case, this will be the current validated head);
- let `S` be the state at the end of the execution of block `header.parent_hash`; let `validator_set := S.Consensus.validator_set()`; ensure that `S.Consensus.check_seal(validator_set, block)` does not abort if it aborts, ; (This will check the `signatures` segment lists the correct number of valid validator signatures with the validator set given by the Consensus account. We require `check_seal` to be stateless with any required state information passed in through `validator_set` to facilitate parallisation.)
- ensure `S` is mutable but that any mutations do not get committed except where explicitly noted;
- `System` calls `S.Administration.start_block(block)`; if it aborts, revert/discard `S` and the block is considered invalid.
- for each transaction `tx` in `block.transactions`, `Nobody` calls `S[tx.destination][tx.function_name](tx.params...)`. If a transaction aborts, then the block is aborted and considered invalid.
  - Transactions can include signed statements from external actors such as fishermen, but crucially can also contain unsigned statements that simply record an "accepted" truth (or piece of extrinsic data). Timestamp would be an example of this. When a validator signs a block as a relay-chain candidate they implicitly ratify each of the blocks statements as being valid truths.
  - One set of statements that appear in the block are selected para-chain candidates. In this case it is a simple message to `S.Parachain.update_head(parachain_id: U64, head_data: bytes, egress_queue_roots: [H256, ...], balance_uploads: [[U64, U256], ...])`. The `*_precondition` function barriers ensure that externally received transactions cannot call these directly. This call ensures any DOT balances on the para-chain required as fees for the egress-queue is burned. `changed_balances` records the change of any funds owned as a result of transfer from on-parachain to parachain-on-relaychain.
- For each para-chain, the egress-queue messages are processed.
- `System` calls `S.Administration.end_block(block)`; if it aborts, revert/discard `S` and the block is considered invalid.

### Invalid blocks

If a block is considered invalid and should be marked so it is not processed again.

## Consensus

Consensus is managed in three parts:

- a PBFT-like instant-finality mechanism that provides forward-verifiable finality on a single relay-chain block;
- a progressive para-chain candidate determination routine that provides a decentralised means of forming eventual consensus over a set of para-chain candidates that fulfil certain criteria;
- a simple leader-based mechanism for relay-chain transaction collation.

# Data formats

Data structures are RLP-encoded using normative Ethereum RLP.

## Block

A block contains all information required to evaluate a relay-chain block. It includes extrinsic data specific to the relay chain.

```
Block: [
    header: Header,
    transactions: Transaction[],
    signatures: [Signature, ...]
]
```

## Transaction

Transactions are isolatable components of extrinsic data used in blocks to describe specific communications from the external world.

```
Transaction: [
    destination: U64,
    function_name: bytes,
    parameters: [...],
	seal: [
		nonce: U64,
		signature: Signature
	]
]
```

- `destination` is the contract on which the function will be called.
- `function_name` is the name of the function of the contract that will be called.
- `message_data` are the parameters to be passed into the function; this is a rich data segment and will be interpreted according to the function's prototype. It should contain exactly the number of the elements as the function's prototype; if any of the function's prototype elements are structured in nature, then the structure of this parameters should reflect that. A more specific mapping between RLP and Wasm ABI will be provided in due course.

## Header

The header stores or cryptographically references all intrinsic information relating to a block.

```
header: [
    parent_hash: H256,
    number: U64,
    state_root: H256,
    transaction_root: H256,
    parachain_activity_bitfield: bytes,
    logs: bytes[]
]
```

## Candidate Para-chain block

Candidate para-chain blocks are passed from collators to validators and express information concerning the latest state of the para-chain. If validated and accepted, then most of this information is duplicated onto the state of the relay chain under the Parachains contract (the exception being `block_data`).

```
Candidate: [
	parachain_index: U64,
	collator_signature: Signature,
	unprocessed_ingress: [ [ [ bytes, ... ], ... ], ... ],	// ordered by para-chain index and then by block number and then by message index.
	block_data: U64
]
```


```
CandidateReceipt: [
	parachain_index: U64,
	collator: H160,
	head_data: bytes,
	balance_uploads: [ [ U64, U256 ], ... ],
	egress_queue_roots: [ H256, ... ],	// or a sparse [[U64, H256], ...] format?
	egress_fees: U256	// TODO: or a structured egress_properties from which fees can be calculated?
]
```

`parachain_index` is the unique identifier for this para-chain. `egress_queue_roots` is the array of roots of the egress queues. Many/most entries may be empty if the para-chain has little outgoing communication with certain other chains. `balance_uploads` is the set of `U64` account identifiers

# Transaction routing

Importantly, the relay-chain validators do almost nothing regarding transaction routing. All heavy-lifting in terms of tracking egress (outgoing) queues is done by collators.

For each block of each para-chain, there exists a set of outgoing messages to each other para-chain. For para-chain `P` sending a message to para-chain `Q`, at block number `B` we can say `chain[B].parachain[P].egress[Q]` represents this queue. If, for whatever reason, `Q` does not process this queue, then the items are not somehow forwarded or copied into `chain[B + 1].parachain[P].egress[Q]` rather this is a separate queue altogether, describing the output messages resulting from `P`'s block `B + 1`. In this case, when validating a candidate for `Q` after block `B`, the egress queues from `B` will need to be managed in the validation logic.

A collators role includes tracking all other para-chains' egress queues for its chain and amalgamating them into a three-dimensional array when they produce a para-chain block:

```
[
	chain_1: IngressQueues, chain_2: IngressQueues, ...
]
```

There is no item for the para-chain itself; it is assumed that the para-chain has no need to send messages to itself.

Each `IngressQueues` item contains a number of arrays of `bytes` messages. The number of such arrays is equal to the number of blocks that have passed since the last para-chain block was finalised (each properly finalised para-chain block necessarily flushes all other para-chain's egress queues to itself).

```
IngressQueues: [
	earliest_block: [ bytes, ... ],
	next_earliest_block: [ bytes, ... ],
	...
	latest_block: [ bytes, ... ]
]
```

It is permissible for any of these `[ bytes, ... ]` arrays to be empty.

### Specifics

Each notional egress queue for a given block `chain[B].parachain[P].egress[Q]` relates to a specific set of data stored in the state. Specific for the end-state `S` of block `B`, we index-key `chain[B].parachain[P].egress[Q]` into a trie and denote the root as `S.Parachain[P].egress_root[Q]`, the egress queue root. Note again, this specifies information *only relevant to items places on the egress queue in the present block*. Notably, if `Q` did not drain the contents of the queue from the previous block, then those contents are *not* reflected in the present block's egress root. It is the job of `Q`'s collators to keep up to date with all previous blocks when processing "ingress" queues (i.e. other blocks' egress queue to it).

As part of its operation, the candidate block validation function requires the unprocessed ingress queues (i.e. relevant other para-chain's egress queues) these queues are provided by the collator as part of the candidate block, *but* are validated externally to the validation function "natively" by the validator. Technically these could be validated as part of the validation function, but it would mean duplication of code between all para-chains and would inevitably be slower and require substantial additional data wrangling as the witness data concerning historical egress information were composed and passed. Requiring the validator node itself to pre-validate this information avoids this.

The candidate specifies the new set of egress queue roots, and the Validation Function ensures that these are reflected by the state transition of the para-chain.

The source and destination are para-chain indices.

This set of messages is defined by the collator, specified in the candidate block and validated as part of the Validity Function. The set of messages must fulfil certain criteria including respecting limitations on the quantity and size of outgoing queues.

We name four chain parameters:

- `routing_max_messages`: The maximum number of messages that may be sent from a block in total.
- `routing_max_messages_per_chain`: The maximum number of messages that may be sent from a block into a single other chain in total.
- `routing_max_bytes`: The maximum number of bytes that all messages can occupy which may be sent from a block in total.
- `routing_max_bytes_per_chain`: The maximum number of bytes that all messages can occupy which may be sent from a block into a single other chain in total.

Part of the process of validation includes checking these four limitations have been respected by the candidate block. This is done at the same time as fee calculation `calculate_fees`.

### Validating & Processing

The specific steps to validate a para-chain candidate on state `S` are:

- Ensure the candidate block is structurally sound. Let `candidate` be the structured data.
- Retrieve the collator signature for the candidate and let `collator := ecrecover(candidate.collator_signature)`.
- For each (`Q`, `Q_index`) in all para-chains where `Q != candidate.parachain_index`:
  - Let `ingress_queue := candidate.unprocessed_ingress[Q_index]`
  - Counting `b` down from `S.Null.block_number()` until `block[b].parachain[Q].egress[candidate.parachain_index] WAS_PROCESSED`.
    - Let `b_index := S.Null.block_number() - b`
    - Assert `index_keyed_trie_root(ingress_queue[b_index]) == chain[b - 1].state.Parachain[Q].egress_root[candidate.parachain_index]` (if not true then this is an invalid para-chain candidate).
- Let `(head_data, egress_queues, balance_uploads) := S.Parachain[candidate.parachain_index].Validate(candidate)`; if it aborts, then this is an invalid para-chain candidate.
- Ensure all limitations regarding egress queues are observed: `let egress_fees := calculate_fees(egress_queues)`, and if it aborts, then this is an invalid para-chain candidate.
- Form candidate receipt `candidate_receipt := (candidate.parachain_index, collator, head_data, balance_uploads, to_index_keyed_trie_roots(egress_queues), egress_queues)`.

# Para-chain management account

```
[
	balances: U64 -> [ U256: balance, U64: nonce ],

]
```

# Authentication contract

The authentication contract will check the validity of an ECDSA signature `(r, s, v)`.

This should be a signature on the Keccak256 hash of the RLP encoding of:

```
[
	transaction: Transaction,
	chain_id: U64
]
```

The `v` value of the signature should be based on the standard `v_standard` (`[27, 28]`):

```
v := v_standard - 26 + chain_id * 2
```
