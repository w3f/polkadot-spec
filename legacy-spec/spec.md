Polkadot is primarily described by the Relay chain protocol; key logic between parachain protocols will likely be shared between parachain implementations but are not inherently a part of the Polkadot protocol.

# Relay chain

The relay chain is a simplified proof-of-stake blockchain backed by a Web Assembly (Wasm) engine. Unlike Ethereum and Bitcoin, balances are not a first-class part of the state-transition function (STF). Indeed the only aspect of the relay-chain which is first-class is the notion of an *object*. Each object is identified through an index (`ObjectID`) and has some code and storage (similar to Ethereum contract accounts). The code exports functions which can be called either from other objects or through a transaction.

Practically speaking, account balances do exist on the relay chain but are entirely an artefact of an object's storage and code. The entire state transition is managed through a single call into a particular object named "Administration". Aside from the consensus algorithm (which is "hard-coded" into the protocol for light-client practicality), all aspects of the protocol are soft-coded as the logic of these objects and can be upgraded without any kind of hard-fork.

## Consensus

Consensus is defined as the job of ensuring that the blockchain, and thus the collection of state-transitions from genesis to head, is agreed upon between all conformant clients and can progress consistently. It is separated from the rest of block-processing and forms a "hard-coded" part of the protocol, not handled by the Wasm object-execution environment. This is primarily because it would make light-client implementation extremely difficult and largely preclude multiple strategies for consensus-forming that could add substantial reliability to the network.

It is managed in three parts:

1. an instant-finality mechanism that provides forward-verifiable finality on a single relay-chain block (eventually likely based on Zyzzyva/Aardvark/Abab. See section below for the PBFT-based algorithm used in early PoCs);
2. a parachain candidate determination routine that provides a means of forming consensus over a set of parachain candidates that fulfil certain criteria based on signed statements from validators;
3. a relay-chain transaction-set collation mechanism for determining which signed, in-bound transactions are included.

Of the three attributes of consensus, namely consistency, availability and partition-tolerance, we are generally prepared to give up large-scale partition-tolerance of the validator set (who we can highly motivate to ensure they remain online and well-connected), and get according guarantees over the consistency and availability. As such an instant-finality consensus algorithm is well-suited, such as PBFT or an optimistic derivative like Zyzzyva.

Points 2 and 3 are both part of the same underlying need to determine the block that will be finalised among all validators as point 1. The only aspect of the block that needs to be determined (i.e. the only part of the block that is non-deterministic) is the transaction set which is included. This covers both parachain candidate selection and external transaction inclusion. (Parachain candidates are selected by means of inclusion of a specific transaction.)

A final parachain candidate-selection algorithm will likely be distributed and progressive, giving both greater efficiency and a more graceful degradation and leading to fewer artefacts which could potentially cause security holes. For PoC-1, a much more centralised mechanism will be used relying on an elevated set of group leaders to collate and specify parachain candidates.

### PoC-1 Parachain candidate selection

Every block, each validator is deterministically assigned (through a CSPRNG function) to a single parachain or the relay-chain. There is exactly one validator who is designated leader for each parachain and exactly one validator who is designated to the relay-chain.

```
let block_number := S.Nobody.block_number()
let (v.home_chain, v.is_leader) := determine_role(v, block_number)
```

`v.home_chain` may be a parachain index or `Relay`.

If the validator is a leader, they will select a valid parachain block candidate (which it is presumed will be provided by the parachain collators), sign it and forward it to each other validator assigned to that parachain.

```
let h := keccak256(block_number ++ 'valid' ++ v.home_chain ++ candidate)

if v.is_leader:
	do:
		let c := find_candidate(v.home_chain)
	loop unless is_valid(c) and all_ingress_data_known(c) then let candidate := c
	let sig := v.sign(h)
	let groupies := every w in validators where:
		determine_role(w, block_number).home_chain == v.home_chain and w != v

	let attests := []
	for w in groupies
		w.send('request_attest' ++ candidate ++ sig).on_reply(r):
			if r == 'attest' ++ sig where recover(sig, h) == w and !attests.contains(w):
				attests.push(w => sig)

	await attests.count == attest_min:
		let relay := w in validators where determine_role(w, block_number).home_chain == Relay
		relay.send(h ++ sig ++ concat_values_of(attests))
else if v.home_chain != Relay:
	let leader := w in validators where
		determine_role(w, block_number).home_chain == v.home_chain and v.is_leader
	await leader.received(msg):
		if let msg == 'request_attest' ++ candidate ++ sig:
			if recover(sig, h) == leader and is_valid(candidate) and all_ingress_data_known(candidate):
				let sig := v.sign(h)
				leader.send('attest' ++ sig)
else
	wait for all parachain validators to send properly attested block or timeout
	author block
```

Each other validator will sign and reply with an attestation that all information relating to this block is available, including extrinsic information such as transactions and externally-dependent information such as the egress-queue data. By signing this attestation, the validators promise to provide this information to any other validator for a minimum of `era_length` blocks.

There must be a strict minimum of attestations (undetermined as yet but called `attest_min`) for the candidate to be considered safe. The set of `attest_min + 1` signatures together with the parachain candidate's hash is then rebroadcast to the validator designated to the relay chain.

The validator designated to the relay chain collects transactions for the relay chain block and, on receipt of all (subject to reasonable timeout) properly signed/attested parachain candidates, constructs and rebroadcasts the final block to each validator together with all signatures. It is up to each validator to verify that all parachain candidates are properly attested. The final block's header is then hashed and used in the finalisation algorithm.

> CONSIDER: Allocating a large CSPRNG subset of validators (maybe 33% + 1) to elect transactions. The subset is ordered with a power-law distribution of transaction allocation. Those allocated greater number of transactions also take a higher priority (and effectively render moot the lower-order validators), meaning that most of the time the first few entrants is enough to get consensus of the transaction set. In the case of a malfunctioning node, the lower-order validators acting in aggregate allow important (e.g. Complaint) transactions to make their way into the block.

### PoC Consensus Algorithm

This is a PBFT-based algorithm.  There are `n` validators altogether, with a maximum of `f` arbitrarily faulty. 

We consider a weakly synchronous network, where the adversary can reorder or delay messages indefinitely, with the only stipulation being that messages eventually arrive. The communication model assumes each validator having a channel with each other validator, although in practice messages are likely to be circulated by gossip.

The algorithm proceeds in rounds (starting at 0), with a primary selected using a deterministic primary selection function `Primary(round)`.

The primary selection algorithm isn't fully determined, but will be similar to taking the `r`th validator mod the number of validators.

The primary's job is to propose a relay chain block for inclusion. 
We also consider a hash function H which maps proposals to their digests such that collisions have a negligible probability.

```
PROPOSE(round, Proposal)
PREPARE(round, Digest)
COMMIT(round, Digest)
ADVANCE(round)
```

Definitions:
  - threshold-prepare: a set of signed `PREPARE(r, D)` messages from at least `n - f` validators with `r` and `D` all the same.
  - justification: a set of signed `COMMIT(r, D)` messages from at least `n - f` validators with `r` and `D` all the same.
  - threhsold-advance: a set of signed `ADVANCE(r)` messages from at least `n - f` validators with `r` all the same.

Description of the algorithm:
  - Upon onset of round r, each validator sets a round timeout which increases exponentially with the round number. `Primary(r)` creates a proposal P and multicasts a signed `PROPOSE(r, P)`.
  - Upon receipt of `PROPOSE(r, P)` signed by `Primary(r)`, a validator V evaluates the validity of P. If P is deemed valid, V multicasts a signed `PREPARE(r, H(P))` unless V has already broadcast a `PREPARE` message in r.
  - Upon witnessing a threshold-prepare for `r` and `H(P)`, a validator multicasts a signed `COMMIT(r, H(P))` unless he has already broadcast `ADVANCE(r)`.
  - Upon timeout or witnessing `f + 1` signed `ADVANCE(r)` messages, a validator multicasts a signed `ADVANCE(r)`.
  - Upon witnessing a threshold-advance for `r`, proceed to round `r + 1`.
  - Upon witnessing a justification for some digest `H(X)`, exit with `H(X)`.

There are two additional "locking" rules:
  - Validators may only `PROPOSE`, `PREPARE`, and `COMMIT` the proposal from the threshold-prepare with highest round witnessed, if it exists.
  - Validators must consider any proposal from the threshold-prepare with highest round witnessed valid, if it exists.

For this consensus protocol to be safe and live, we assume `n = 3f + k`, k > 0.

The first rule is necessary to preserve the "safety" property: 

If `f + k` good validators multicast `COMMIT(r, D)`, the `f` faulty validators can create a valid justification for `D`. Thus if another digest `D'` is finalized by the `n - f` good validators in another round, two proposals have been finalized. 

However, if those `f + k` validators are locked to `D`, there is no way for the remaining `f` good validators to threshold-prepare or even commit to another digest `D'` even when combined with the `f` faulty validators, as `2f < n - f`.

The second rule is necessary to preserve the "liveness" property in Polkadot:

Validators in general will refuse to consider any proposal containing a candidate it has received even a single invalidity vote for as valid.

If the `f` faulty validators go inactive when any good validator is locked, this will require full co-operation of the good `2f + k` validators. If the faulty validators can convince even a single validator not to accept the locked proposal (e.g. by broadcasting an `Invalid` vote for a candidate contained therein), the consensus will halt. Thus we introduce a second rule to relax the validity function somewhat in the case that a proposal has already been prepared for acceptance by the network.

## State

The state of the relay chain has similarities to Ethereum: "objects" contained in it are a mapping from an `ObjectID` identifier to code (a SHA3 of Wasm code) and storage (a Merkle-trie root for a set of `H256` to `bytes` mappings). Objects are bland Wasm code bundles with a couple of external facilities open to them as user-functions, primarily the ability to call into other objects and to access its own storage.

Notably, no balance or nonce information is stored directly in the state. Balances, in general, are unneeded since relay-chain DOTs are not a crypto-currency per se and cannot be transferred between owners directly. Nonces, for the purposes of replay-protection are managed by the specialised Authentication object.

Ownership of DOTs is managed by two objects: the Staking object (which manages DOTs stakes by users) and the Parachains object (which manages the DOTs owned by parachains). Transfer between the Staking and the Parachains objects happens via a signed transaction being included in the relay chain.

```
state := ObjectID -> ( code_hash: Hash, storage_root: Hash )
```

The objects each fulfil specific functions (though over time these may be expanded or contracted as changes in the protocol determine). For PoC-1, the objects are:

- Object 0: Nobody. Basic user-level object. Can be queried for non-sensitive universal data (like `block_number()`, `block_hash()`). Represents the "user-level" authenticated external transaction origin.
- Object 1: System. Provides low-level mutable interaction with header, in particular `set_digest()`. Represents the system origin, which includes all validator-accepted, unsigned transactions.
- Object 2: Administration. Stores and administers low-level chain parameters. Can unilaterally read and replace code/storage in all objects, &c. Hosts and acts on stake-voting activities. Acts as entry point in block execution/state-transition.
- Object 3: Consensus. Stores all things consensus and code is the relay-chain consensus logic. Requires to be informed of the current validator set and can be queried for behaviour profiles. Checks validator signatures.
- Object 4: Staking. Stores all things to do with the proof-of-stake algorithm particularly currently staked amounts. Informs the Consensus object of its current validator set. Hosts stake-voting.
- Object 5: Parachains. Stores all things to do with parachains including total parachain balances, relay-chain-native user balances that are transferable (per parachain), validation function, queue information and current state. Is flushed at the beginning of each block in order to allow the previous block's messages to the relay chain to execute.
- Object 6: Authentication. Manages checking the transaction signatures and replay protection.
- Object 7: Timestamp. Stores the current time. Changed once per block by the System object.

For PoC-1, these objects are likely to be built-in, though eventually they should be implemented as Wasm modules and dynamically compiled/executed.

## Execution Environment

The transition function is mostly similar to an unmetered variant of Ethereum that removes all balance/nonce and the "open" ability to create "smart-contracts" (objects). Main points are:

- Utilisation of Wasm engine for code execution rather than EVM.
- Transactions include a function name and call-execution "automatically" dispatches to a function within the code body.
- Wasm intrinsics replace some of the EVM externality functions/opcodes, the rest are unneeded:
  - `BLOCKHASH` -> n/a (provided by `Nobody.block_hash()`)
  - `NUMBER` -> n/a (provided by `Nobody.current_number()`)
  - `LOG*` -> `System.deposit_log()`
  - `CREATE` -> `deploy` (which takes a new object index and clobbers any existing code there; no init function is run).
  - `CALL` -> `call` or `call_const`
  - `RETURN` -> n/a (`return` in Wasm)
  - `CALLDATA*` -> n/a (parameters are passed into the function pre-deserialised from the transaction using the function's signature as hint)
  - `TIMESTAMP` -> n/a (there is a timestamp object)
  - `BALANCE`/`ORIGIN`/`GASPRICE`/`EXTCODE`/`COINBASE`/`DIFFICULTY`/`GASLIMIT`/`GAS`/`CALLCODE`/`DELEGATECALL`/`SUICIDE` -> n/a

## Block Processing

In summary, the normative mechanism for processing a block is:

- check the block data is valid RLP with correct item formats; let `block` be the structured data;
- let `header := block.header`;
- check the `header.transactions_root` properly reflects `block.transactions`;
- check a validated block is stored by the node for `header.number - 1` and that its header-hash is `header.parent_hash` (in the normative case, this will be the current validated head);
- let `S` be the state at the end of the execution of block `header.parent_hash`; let `validator_set := S.Consensus.validator_set()`; ensure that `S.Consensus.check_seal(validator_set, block)` does not abort; (This will check the `signatures` segment lists the correct number of valid validator signatures with the validator set given by the Consensus object. We require `check_seal` to be stateless with any required state information passed in through `validator_set` to facilitate parallelisation.)
- ensure `S` is mutable but that any mutations do not get committed except where explicitly noted;
- `System` calls `S.Administration.execute_block(block)`; if it aborts, revert/discard `S` and the block is considered invalid.

### Invalid blocks

If a block is considered invalid and should be marked so it is not processed again.

# Data formats

Data structures are RLP-encoded using normative Ethereum RLP.

## Block

A block contains all information required to evaluate a relay-chain block. It includes extrinsic data specific to the relay chain.

```
Block: [
	header: Header,
	transactions: [ Transaction ],
	signatures: [ Signature ]
]
```

## Transaction

Transactions are isolatable components of extrinsic data used in blocks to describe specific communications from outside of the state-transition system. Typically they come from either the external world (in which case they will contain a signature to help authenticate their origin and appear in the block as `SignedTransaction`s) or they will come with the tacit acceptance of the block's validator set (in which case they will appear in the block as a `Transaction` and will be executed as if coming from the System object).

```
Transaction: [
	destination: ObjectID,
	function_name: bytes,
	parameters: [ ... ]
]
```

```
SignedTransaction: [
	unsigned: UnsignedTransaction,
	signature: Signature
]
```

In order to describe the signature format, it is useful to define the `UnsignedTransaction` object which is a `Transaction` with a `nonce`, or index to force an order on transactions coming from the same origin to avoid replay attacks.

```
UnsignedTransaction: [
	tx: Transaction,
	nonce: TxOrder
]
```

- `destination` is the object index on which the function will be called.
- `function_name` is the name of the function of the object that will be called.
- `parameters` are the parameters to be passed into the function; this is a rich data segment and will be interpreted according to the function's prototype. It should contain exactly the number of the elements as the function's prototype; if any of the function's prototype elements are structured in nature, then the structure of these parameters should reflect that. A more specific mapping between RLP and Wasm ABI will be provided in due course.

## Header

The header stores or cryptographically references all intrinsic information relating to a block.

```
Header: [
	parent_hash: Hash,
	number: BlockNumber,
	state_root: Hash,
	transaction_root: Hash,
	digest: Digest
]
```

`Digest` is a second-class item of data that contains summary information of activity that happened in the block that is useful for light-clients. For PoC-1 this is the set of logs and a bit field of active parachains. Its contents are set through the System object.

```
Digest: [
	parachain_activity_bitfield: bytes,
	logs: [ bytes ]
]
```

The format of `Digest` should not be assumed to be an unchanging part of the core protocol. Changing it is not a trivial task (since light-clients will depend on its format), but is possible since all accesses to its internals are done by soft-coded objects.

## Candidate Parachain block

Candidate parachain blocks are passed from collators to validators and express information concerning the latest state of the parachain. If validated and accepted, then most of this information is duplicated onto the state of the relay chain under the Parachains object (the exception being `block_data`).

```
Candidate: [
	parachain_index: ChainID,
	collator_signature: Signature,
	unprocessed_ingress: [ [ [ bytes ] ] ],
	block_data: bytes
]
```

`unprocessed_ingress` is ordered by block number (lowest first), and then by parachain index and then by message index.

Candidate receipts are the final data actionable on the relay chain. They are signed and published by relevant parachain validators and shared amongst the network. They can be derived from any relay-chain synced node and the `Candidate` by running the relevant parachain validation function.

```
CandidateReceipt: [
	parachain_index: ChainID,
	collator: AccountID,
	head_data: bytes,
	balance_uploads: [ ( AccountID, Balance ) ],
	egress_queue_roots: [ ( ChainID, Hash ) ],
	fees: Balance
]
```

- `parachain_index` is the unique identifier for this parachain. 
- `egress_queue_roots` is the array of roots of the egress queues. Many/most entries may be empty if the parachain has little outgoing communication with certain other chains. 
- `balance_uploads` is the set of `AccountID` account identifiers and `U256` positive balance deltas that represent the balances that should be unlocked on the relay chain (since the DOTs have been made unavailable on the parachain itself).

# Transaction routing

Importantly, the relay-chain validators do almost nothing regarding transaction routing. All heavy-lifting in terms of tracking egress (outgoing) queues is done by collators.

For each block of each parachain, there exists a set of outgoing messages to each other parachain. If no state-transition happened for the parachain, then this set will be empty.

For parachain `P` sending a message to parachain `Q`, at block number `B` we can say `chain[B].parachain[P].egress[Q]` represents this queue. If, for whatever reason, `Q` does not process this queue, then the items are not somehow forwarded or copied into `chain[B + 1].parachain[P].egress[Q]` rather this is a separate queue altogether, describing the output messages resulting from `P`'s block `B + 1`. In this case, when validating a candidate for `Q` after block `B`, the egress queues from `B` will need to be managed in the validation logic.

A collators role includes tracking all other parachains' egress queues for its chain and amalgamating them into a three-dimensional array when they produce a parachain block:

```
[
	chain_1: IngressQueues, chain_2: IngressQueues, ...
]
```

There is no item for the parachain itself; it is assumed that the parachain has no need to send messages to itself.

Each `IngressQueues` item contains a number of arrays of `bytes` messages. The number of such arrays is equal to the number of blocks that have passed since the last parachain block was finalised (each properly finalised parachain block necessarily flushes all other parachain's egress queues to itself).

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

Each notional egress queue for a given block `chain[B].parachain[P].egress[Q]` relates to a specific set of data stored in the state. Specific for the end-state `S` of block `B`, we index-key `chain[B].parachain[P].egress_queues[Q]` into a trie. For any given block, the roots of all unprocessed egress queues (at the end of the block's state transition) are stored in its state: `S.Parachains.chain_state(P).egress_queue_roots[Q]`.

As part of its operation, the candidate block validation function requires the unprocessed ingress queues (i.e. relevant other parachain's egress queues). These queues are provided by the collator as part of the candidate block, *but* are validated externally to the validation function "natively" by the validator. Technically these could be validated as part of the validation function, but it would mean duplication of code between all parachains and would inevitably be slower and require substantial additional data wrangling as the witness data concerning historical egress information were composed and passed. Requiring the validator node itself to pre-validate this information avoids this.

The candidate specifies the new set of egress queue roots, and the Validation Function ensures that these are reflected by the state transition of the parachain.

The source and destination are parachain indices.

This set of messages is defined by the collator, specified in the candidate block and validated as part of the Validity Function. The set of messages must fulfil certain criteria including respecting limitations on the quantity and size of outgoing queues.

We name four chain parameters:

- `routing_max_messages`: The maximum number of messages that may be sent from a block in total.
- `routing_max_messages_per_chain`: The maximum number of messages that may be sent from a block into a single other chain in total.
- `routing_max_bytes`: The maximum number of bytes that all messages can occupy which may be sent from a block in total.
- `routing_max_bytes_per_chain`: The maximum number of bytes that all messages can occupy which may be sent from a block into a single other chain in total.

Part of the process of validation includes checking these four limitations have been respected by the candidate block. This is done at the same time as fee calculation `calculate_fees`.

# Interface Definitions

## Types

- `ObjectID : U64`
- `AccountID : H160`
- `Balance : U256`
- `ChainID : U64`
- `Hash : H256`
- `BlockNumber : U64`
- `Proportion : U64`
- `Timestamp : U64`
- `TxOrder : U64`

### ParachainState

```
ParachainState : {
	head_data: bytes,
	balance: Balance,
	user_balances: AccountID -> Balance,
	balance_downloads: AccountID -> ( Balance, bytes ),
	egress_roots: [ Hash ]
}
```

## Static Constants

These are not dependent on state. They just float around in the global environment and are inherent to the chain or node itself.

- `chain_id() -> ChainID`
- `sender() -> ObjectID`

## State-based APIs

### Environment (0)

- READONLY `block_number(self) -> BlockNumber`
- READONLY `block_hash(self, BlockNumber) -> Hash`

### System (1)
- SYSTEM `set_digest(mut self, preserialised_rlp_digest: bytes)`

### Administration (2)
- SYSTEM `execute(mut self, block: Block)`
- READONLY `current_user(self) -> AccountID`
- SYSTEM `deposit_log(mut self, data: bytes)`
- SYSTEM `set_active_parachains(mut self, data: bytes)`

### Consensus (3)
- READONLY `validators(self) -> [ AccountID ]`
- SYSTEM `set_validators(self, validators: [ AccountID ])`
- SYSTEM `flush_statistics(mut self) -> Statistics`

### Staking (4)
- READONLY `era_length(self) -> BlockNumber`
- READONLY `balance(self, AccountID) -> Balance`
- USER `move_to_parachain(mut self, chain_id: ChainID, value: Balance)` User-level function to move funds onto a parachain. Calls `Parachains.credit_parachain`.
- SYSTEM `credit_staker(mut self, value: Balance)` System-level function to be called only by Parachains object when funds have left that object and are to be credited here.
- USER `stake(mut self, minimum_era_return: Proportion)`
- USER `unstake(mut self)`
- USER `complain(mut self, complaint: Complaint)`

Staking happens in batches of blocks called eras. At the end of each era, payouts are processed based upon statistics accrued by the Consensus object and the validator set is reaffirmed or changed. An account's staking profile (i.e. parameters that determine when its balance will be used in the staking system) may be set with the `stake` and `unstake` functions. Both specifically targets the next era. Staking information is retained between eras and further calls are unnecessary if the user doesn't wish to change their profile. Each account has a staking balance associated with it (`balance`); this balance cannot be split between different staking profiles.

### Parachains (5)

- READONLY `chain_ids(self) -> [ ChainID ]`
- READONLY `validation_function(self, chain_id: ChainID) -> Fn(consolidated_ingress: [ ( ChainID, bytes ) ], balance_downloads: [ ( AccountID, Balance ) ], block_data: bytes, previous_head_data: bytes) -> (head_data: bytes, egress_queues: [ [ bytes ] ], balance_uploads: [ ( AccountID, Balance ) ])`
- READONLY `validate_and_calculate_fees_function(self, chain_id: ChainID) -> Fn(egress_queues: [ [ bytes ] ], balance_uploads: [ ( AccountID, Balance ) ]) -> Balance`
- READONLY `balance(self, chain_id: ChainID, id: AccountID) -> Balance`
- READONLY `verify_and_consolidate_queues(self, unprocessed_ingress: [ [ [ bytes ] ] ]) -> [ (chain_id: ChainID, message: bytes) ]`: `unprocessed_ingress` is dereferenced in order from outer to inner: block age (oldest first), parachain ID, message index. It aborts if the `unprocessed_ingress` contains items which do not reflect the historical parachain egress queues. It also aborts if it does not contain all items from egress queues bound for this chain that were not yet processed by this chain. Otherwise it returns all messages (the `bytes` items) passed in `unprocessed_ingress`, ordered by block age (oldest first), then by parachain ID, then by message index and paired up with the source parachain ID.
- READONLY `chain_state(self, chain_id: ChainID) -> ParachainState` returns the state of the parachain `chain_id`.
- USER `move_to_staking(mut self, chain_id: ChainID, value: Balance)` User-level function which moves a user-balance from this object associated with parachain `chain_id` to the Staking object. Implemented through reducing `S.Parachains.balance` and `S.Parachains.chain_state[chain_id].balance[sender()]` and creating it on the Staking chain with the use of `Staking.credit_staker`.
- SYSTEM `credit_parachain(mut self, chain_id: ChainID, value: Balance)` System-level function to be called only by Staking object when funds have left that object and are to be credited here.
- USER `download(mut self, chain_id: ChainID, value: Balance, instruction: bytes)` Denotes a portion of the balance to be downloaded to the parachain. In reality this means reducing the user balance for the `sender()` of parachain `chain_id` by `value` and issuing an out-of-band `balance_downloads` instruction to the parachain through its next validation function. So that the parachain can be told what to do with the DOTs (e.g. whose parachain-based account should be credited) `instruction` is provided. This could reasonably encode more than just a destination address, but it is left for the parachain STF to determine what that encoding is.
- SYSTEM `update_heads(mut self, candidate_receipts: [ ( ChainID, CandidateReceipt ) ])`

> CONSIDER: fold `balance_downloads` and `balance_uploads` into `head_data`; would simplify validation function and make it a little more abstract (though `download` and uploading would then require knowledge of `head_data`'s internals).

> CONSIDER: allowing messages between parachains to contain DOTs. for the use case of sending a bunch of DOTs from one chain to another, this would vastly simplify things (at present, you'd have to create a new secret/address, upload the DOTs into the relay-chain's Parachains object through a parachain tx, transfer to the staking account and then back to the new parachain (two relay chain txs), then issue a download tx (another relay chain tx)). This could be optimised to three transactions if parachains can transfer between themselves, but it's still a lot of faff for one notional operation.

### Authentication (6)

- READONLY `validate_signature(self, tx: Transaction) -> ( AccountID, TxOrder )`
- READONLY `nonce(self, id: AccountID) -> TxOrder`
- SYSTEM `authenticate(mut self, tx: Transaction) -> AccountID`

### Timestamp (7)

- READONLY `timestamp(self) -> Timestamp`
- SYSTEM `set_timestamp(mut self, Timestamp)`


# Notes

All USER transactions must burn a fee as soon as possible into their execution and, having done so, must not abort.

# Implementation Notes

## Administration (2)

The Administration object contains `execute_block` which handles the entire state-transition function. Some of the functions it provides are provided through its ephemeral storage (particularly `deposit_log`, `current_user` and `set_active_parachains`).

Regarding `execute_block`, rough pseudo-code is:
- for each transaction `tx` in `block.transactions`:
  - if `tx.signature` exists (signed transaction):
	- let `current_user := Authorisation.validate(tx)`. If the execution aborts, then the block is aborted and considered invalid.
	- ensure `current_user` is returned if `Administration.current_user` is called during the execution of this transaction.
	- let `caller := Nobody`
  - otherwise if `tx.signature` doesn't exist (unsigned transaction):
	- let `caller := System`
  - call `S[tx.destination][tx.function_name](tx.params...)` from account `caller`, where state `S` is the end-state of the `block`. If the execution aborts, then the block is aborted and considered invalid.
  - reset `current_user` to ensure `Administration.current_user` aborts if called.

Note:

Transactions can include signed statements from external actors such as fishermen or stakers, but can also contain unsigned statements that simply record an "accepted" truth (or piece of extrinsic data). If a transaction is unsigned but is included as part of a block, then its sender is System. The transaction calling `Timestamp.set_timestamp` would be an example of this. When a validator signs a block as a relay-chain candidate they implicitly ratify each of the blocks statements as being valid truths.

One statement that appears in the block is selected parachain candidates. In this case it is a simple message to `S.Parachains.update_heads`. This call ensures that any DOT balances on the parachain that are required as fees for the egress-queue are burned.


## Parachains (5)

### Validating & Processing

Relay-chain validation happens in three contexts:
1. when you are attempting to sync the chain;
2. when you are building a block and you need to determine the validity of a candidate on a parachain that you are not assigned to;
3. when you are attempting to validate a parachain candidate, perhaps as a fisherman, perhaps as a validator who is building a block, perhaps as a validator who is responding to a complaint.

For the first context, it is enough to simply execute all transactions in the block. Validation happens implicitly through the existence of the unsigned `update_heads` transaction that appear in a block signed by validators.

The second context is much like the first, except that `update_heads` is run manually and availability of the source block is affirmed.

In all contexts, it is not assumed that you have any chain history. All operations can be done purely through looking at the "current" (relative to the block to be validated) chain state.

For the latter context, the specific steps to validate a parachain candidate on state `S` are:

- Ensure the candidate block is structurally sound. Let `candidate` be the structured data.
- Retrieve the collator signature for the candidate and let `collator := ecrecover(candidate.collator_signature)`. *NOTE: This is not yet used in the STF; only in the consensus algorithm when determining a preference over possible candidates.*
- Call `S.Parachains.validate_ingress(candidate)`, and if it aborts then this is an invalid parachain candidate. (This function ensures that `candidate.unprocessed_ingress` is properly reflective of all unprocessed egress queues from all other parachains, as described in the Parachains object's storage. If it is not then this is an invalid parachain candidate and the function aborts.)
- Let `consolidated_ingress := S.Parachains.verify_and_consolidate_queues(candidate.unprocessed_ingress)`, and if it aborts then this is an invalid parachain candidate.
- With `S.Parachains.chain_state[candidate.parachain_index]` as `chain`:
- Let `previous_head_data := chain.head_data`
- Let `balance_downloads := TAKE chain.balance_downloads` (where `TAKE` means atomically clear the RHS and return it)
- Let `validate := S.Parachains.validation_function(candidate.parachain_index)`
- Let `(head_data, egress_queues, balance_uploads) := validate(consolidated_ingress, balance_downloads, block_data, previous_head_data)`; if it aborts, then this is an invalid parachain candidate.
- Let `validate_and_calculate_fees := S.Parachains.validate_and_calculate_fees_function(candidate.parachain_index)`
- Ensure all limitations regarding egress queues and balance uploads are observed and calculate fees: Let `fees := validate_and_calculate_fees(egress_queues, balance_uploads)`, and if it aborts, then this is an invalid parachain candidate.
- If `fees > chain.balance` then this is an invalid parachain candidate.
- Let `receipt := CandidateReceipt( parachain_index, collator, head_data, to_index_keyed_trie_roots(egress_queues), balance_uploads, fees )`

After all parachain candidates have been established, let `receipts` be the mapping `ChainID -> CandidateReceipt` then:
- Enact candidate receipt by calling `S.Parachains.update_heads(receipts)`

### Pseudocode for `update_heads`

```
update_heads(
	receipts: ChainID -> CandidateReceipt
) {
	constant routing_from: ChainID -> { ChainID } = S.calculate_routing_from();

	foreach source in receipts.keys():
		with chain as S.Parachains.chain_state[source];
		with receipt as receipts[source];
		foreach dest in receipts.keys():
			if routing_from[source].contains(dest):
				chain.egress[dest].clear();
		chain.egress[dest].push(receipt.egress_queue_roots[dest]);
		chain.head_data := receipt.head_data
		chain.balance -= receipt.fees
		foreach (id, value) in receipt.balance_uploads:
			chain.user_balances[id] += receipt.value
}

unrouted_queue_roots(from: ChainId, to: ChainId) -> [Root] {
	egresses[to][from].clone()
}
```

## Authentication (6)

The Authentication object allows participants lookup of a `Signature`, message-hash and nonce into an `AccountID` (`H160` for now). It allows a transaction to be `authenticate`d, which mutates the state and ensures the same transactions cannot be resubmitted. It also allows a transaction to be `validate`d, which does not mutate the state (and thus does not give any replay protection except against transactions that have previously been `authenticate`d). You can also get the `order` index (aka `nonce` in Ethereum) for any account ID.

- READONLY `validate(self, tx: Transaction) -> (id: AccountID, now: TxOrder, when: TxOrder)` returns the account `id` that signed `tx`, and the ordering of this transaction `when` versus the current order `now`. If `now == when`, then the transaction may be validly included/executed. If the signature is invalid, will abort.
- SYSTEM `authenticate(mut self, tx: Transaction) -> AccountID` returns the account ID that signed `tx` iff the `tx` may be validly executed on the state as it is. Aborts otherwise.
- READONLY `order(self, id: AccountID) -> U64` returns the current order index of account `id`.

The `authenticate` function will likely just call on the `validate` function. Example implementation:

```
fn authenticate(mut self, tx: Transaction) -> AccountID {
	let (id, now, when) := self.validate(tx);
	if (now == when) {
		self.nonce[id]++;
		return id;
	}
	abort();
}
```

The `validate` function will check the validity of an ECDSA signature `(r, s, v)`. This should be a signature on the Keccak256 hash of the RLP encoding of:

```
[
	transaction: UnsignedTransaction,
	chain_id: ChainID
]
```

The `v` value of the signature should be based on the standard `v_standard` (`[27, 28]`):

```
v := v_standard - 26 + chain_id * 2
```



#### Q&A

- *How are fee-charges expected to be kept in sync with chain balance totals?* There are three instances where fees are charged for user activities: Transacting directly with the Staking object, transacting directly with the Parachains object and issuing some parachain-based instruction (e.g. to upload a balance into the Parachains object or to send a message into another parachain). The first two are charged from the user's balance directly as (a very early) part of the execution of the transaction. The latter is charged directly to the parachain's balance. It is assumed that the parachain's state-transition function (STF) ensure that where necessary the user is adequately charged a fee from its parachain-local balance of DOTs; in the case of sending messages, this will appear as a necessary burn of DOT tokens for the parachain to issue an outgoing message into its egress queue. In the case of uploading DOTs, it will likely be a simple reduction in the amount of DOTs that appears in `upload_balances` compared to those burned on the parachain itself (which, were there no fees, would be equal).
