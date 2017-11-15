Welcome to the polkadot-spec wiki!

Polkadot is primarily described by the Relay chain protocol; key logic between parachain protocols will likely be shared between parachain implementations but are not inherently a part of the Polkadot protocol.

# Relay chain

The relay chain is a proof-of-stake blockchain in a similar balance/nonce mould to Ethereum, backed by a Web Assembly (Wasm) engine.

# State

Its state is roughly similar to Ethereum: accounts contained in it are a mapping from a `U64` account index to code (`H256`, a SHA3 of Wasm code) and storage (`H256`, a Merkle-trie root for a set of `H256` to `U8[]` mappings). All such accounts are actually known as "high accounts" since their ID is close to 2**64 and, notionally, they have a "high" privilege level.

```
state := U64 -> [ code_hash: H256, storage_root: H256 ]
```

In reality almost all account indices would not represent these high accounts but rather be "virtual". High accounts would each fulfil specific functions (though over time these may expanded or contracted as changes in the protocol determine). The accounts on genesis block can be listed:

- Account 0: Unauthenticated sender. Doesn't actually do anything but represents the unauthenticated (external transaction) origin.
- Accounts 1...: The virtual account indices.
- Account ~7: Timestamp contract. Stores the current time. May be called from the unauthenticated account once per block.
- Account ~6: Authentication account. Basic account lookup account. Stores a mapping `U64 -> H160` providing a partial public-key derivative ("address", similar to an Ethereum address) for each account index. Can be used to register new accounts (in return for some price). Registration begins at some index greater than zero (likely to be 1 + the number of genesis allocations). The current index increments with each new account registered. A nominal fee (whose value may be set by the Administration contract) is payable for each new account registered.
- Account ~5: Para-chain management account. Stores all things to do with para-chains including para-chain balances, their validation function, queue information and current state.
- Account ~4: Staking account. Stores all things to do with the proof-of-stake algorithm particularly currently staked amounts as a mapping from `U64 -> [ balance: U256, nonce: U64 ]`. Informs the Consensus account of its current validator set. Hosts stake-voting.
- Account ~3: Consensus account. Stores all things consensus and code is the relay-chain consensus logic. Requires to be informed of the current validator set and can be queried for behaviour profiles. Checks validator signatures.
- Account ~2: Administration account. Stores and administers low-level chain parameters. Can unilaterally read and replace code/storage in all accounts, &c. Hosts and acts on stake-voting activities. Acts as entry point in block execution.
- Account ~1: System origin. Provides low-level interaction with header fields. Represents the system origin.

For PoC-1, high accounts are likely to be built-in, though eventually they should be implemented as Wasm contracts.

## Transition Function

The transition function is mostly similar to an unmetered variant of Ethereum that removes smart contract functionality except for the use of built-ins. Main points are:

- Utilisation of Wasm engine for code execution rather than EVM.
- High accounts do not harbour or increment a nonce when deploying.
- Wasm intrinsics replace some of the EVM externality functions/opcodes, the rest are unneeded:
  - `BLOCKHASH` -> n/a (provided by `System.block_hash()`)
  - `NUMBER` -> n/a (provided by `System.current_number()`)
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
- let `S` be the state at the end of the execution of block `header.parent_hash`; let `validator_set := S.Consensus.validator_set()`; ensure that `S.Consensus.check_seal(validator_set, block)` does not abortl if it aborts, ; (This will check the `signatures` segment lists the correct number of valid validator signatures with the validator set given by the Consensus account. We require `check_seal` to be stateless with any required state information passed in through `validator_set` to facilitate parallisation.)
- ensure `S` is mutable but that any mutations do not get committed except where explicitly noted;
- `System` calls `S.Administration.start_block(block)`; if it aborts, revert/discard `S` and the block is considered invalid.
- for each transaction `tx` in `block.transactions`, `Unauthenticated` calls `tx.destination[tx.function_name](tx.params...)`. If a transaction aborts, then the block is aborted and considered invalid.
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
    signatures: [[U256, U256, U8], ...]
]
```

## Transaction

Transactions are isolatable components of extrinsic data used in blocks to describe specific communications from the external world.

```
Transaction: [
    destination: U64,
    function_name: bytes,
    parameters: [...]
]
```

- `destination` is the contract on which the function will be called.
- `function_name` is the name of the function of the contract that will be called.
- `message_data` are the parameters to be passed into the function; this is a rich data segment and will be interpreted according to the function's prototype. It should contain exactly the number of the elements as the function's prototype; if any of the function's prototype elements are structured in nature, then the structure of this parameters should reflect that. A more specific mapping between RLP and Wasm ABI will be provided in due course.

## Header

The header stores or crypto-graphically references all intrinsic information relating to a block.

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

# Transaction routing

Importantly, the relay-chain validators do almost nothing regarding transaction routing. All heavy-lifting in terms of tracking egress (outgoing) queues is done by collators.

For each block of each para-chain, there exists a set of outgoing messages. Each message has a destination para-chain. This set of messages is defined by the collator, specified in the candidate block and validated as part of the Validity Function. The set of messages must fulfil certain criteria including respecting limitations on the quantity and size of outgoing queues.

We name four chain parameters:

- `routing_max_messages`: The maximum number of messages that may be sent from a block in total.
- `routing_max_messages_per_chain`: The maximum number of messages that may be sent from a block into a single other chain in total.
- `routing_max_bytes`: The maximum number of bytes that all messages can occupy which may be sent from a block in total.
- `routing_max_bytes_per_chain`: The maximum number of bytes that all messages can occupy which may be sent from a block into a single other chain in total.

Part of the process of validation includes checking these four limitations have been respected by the candidate block.

There is a notional queue for each non-equivalent ordered pair of para-chains. The trie root for each of these queues is stored on the relay chain. Collators prepare the egre

[XXXX The collators, as part of their candidates, include for each (other) destination para-chain two new trie roots; one is the trie root assuming that the destination's queue was drained on this block; the other trie root is the amalgamation of the previous queue with the new queue.]

NOTE:

With the egress queue accepted as valid,
