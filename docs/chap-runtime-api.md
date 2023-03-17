---
title: "Appendix C: Runtime API" 
---

Description of how to interact with the Runtime through its exported functions

## C.1. General Information {#id-general-information}

The Polkadot Host assumes that at least the constants and functions described in this Chapter are implemented in the Runtime Wasm blob.

It should be noted that the API can change through the Runtime updates. Therefore, a host should check the API versions of each module returned in the `api` field by `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) after every Runtime upgrade and warn if an updated API is encountered and that this might require an update of the host.

In this section, we describe all Runtime API functions alongside their arguments and the return values. The functions are organized into modules with each being versioned independently.

### C.1.1. JSON-RPC API for external services {#sect-json-rpc-api}

Polkadot Host implementers are encouraged to implement an API in order for external, third-party services to interact with the node. The [JSON-RPC Interface for Polkadot Nodes](https://github.com/w3f/PSPs/blob/master/PSPs/drafts/psp-6.md) (PSP6) is a Polkadot Standard Proposal for such an API and makes it easier to integrate the node with existing tools available in the Polkadot ecosystem, such as [polkadot.js.org](https://polkadot.js.org/). The Runtime API has a few modules designed specifically for use in the official RPC API.

## C.2. Runtime Constants {#id-runtime-constants}

### C.2.1. `__heap_base` {#id-__heap_base}

This constant indicates the beginning of the heap in memory. The space below is reserved for the stack and the data section. For more details please refer to [Section 2.6.3.1](chap-state.html#sect-memory-management).

## C.3. Runtime Call Convention {#id-runtime-call-convention}

###### Definition 215. Runtime API Call Convention {#defn-runtime-call-convention}

The **Runtime API Call Convention** describes that all functions receive and return SCALE-encoded data and as a result have the following prototype signature:

``` rouge
(func $generic_runtime_entry
  (param ${p}{t}{r}{i}{32}{)}{\left({p}{a}{r}{m}$\right.}len i32) (result i64))
```

where `ptr` points to the SCALE encoded tuple of the parameters passed to the function and `len` is the length of this data, while `result` is a pointer-size (Definition [Definition 203](chap-host-api.html#defn-runtime-pointer-size)) to the SCALE-encoded return data.

See [Section 2.6.3](chap-state.html#sect-code-executor) for more information about the behavior of the Wasm Runtime. Also note that any storage changes must be fork-aware ([Section 2.4.5](chap-state.html#sect-managing-multiple-states)).

## C.4. Module Core {#sect-runtime-core-module}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 3** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

### C.4.1. `Core_version` {#defn-rt-core-version}

|     |                                                                                                                                                                                                                                                                                                 |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | For newer Runtimes, the version identifiers can be read directly from the Wasm blob in form of custom sections ([Section 2.6.3.4](chap-state.html#sect-runtime-version-custom-section)). That method of retrieving this data should be preferred since it involves significantly less overhead. |

Returns the version identifiers of the Runtime. This function can be used by the Polkadot Host implementation when it seems appropriate, such as for the JSON-RPC API as described in [Section C.1.1](chap-runtime-api.html#sect-json-rpc-api).

Arguments  
- None

Return  
- A datastructure of the following format:

  ###### Table 6. Details of the version that the data type returns from the Runtime function. {#tabl-rt-core-version}

  | Name                  | Type                                                                  | Description                                     |
  |-----------------------|-----------------------------------------------------------------------|-------------------------------------------------|
  | `spec_name`           | String                                                                | Runtime identifier                              |
  | `impl_name`           | String                                                                | Name of the implementation (e.g. C++)           |
  | `authoring_version`   | Unsigned 32-bit integer                                               | Version of the authorship interface             |
  | `spec_version`        | Unsigned 32-bit integer                                               | Version of the Runtime specification            |
  | `impl_version`        | Unsigned 32-bit integer                                               | Version of the Runtime implementation           |
  | `apis`                | ApiVersions ([Definition 216](chap-runtime-api.html#defn-rt-apisvec)) | List of supported APIs along with their version |
  | `transaction_version` | Unsigned 32-bit integer                                               | Version of the transaction format               |
  | `state_version`       | Unsigned 8-bit integer                                                | Version of the trie format                      |

###### Definition 216. ApiVersions {#defn-rt-apisvec}

**ApiVersions** is a specialized type for the ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) function entry. It represents an array of tuples, where the first value of the tuple is an array of 8-bytes containing the Blake2b hash of the API name. The second value of the tuple is the version number of the corresponding API.

${b}{e}{g}\in{\left\lbrace{a}{l}{i}{g}\ne{d}\right\rbrace}{m}{a}{t}{h}{r}{m}{\left\lbrace{A}\pi{V}{e}{r}{s}{i}{o}{n}{s}\right\rbrace}\:=&{\left({T}_{{0}},\ldots,{T}_{{n}}\right)}$ T :=& ((b_0, \ldots, b_7), \mathrm{UINT32}) \end{aligned}$

Requires `Core_initialize_block` to be called beforehand.

### C.4.2. `Core_execute_block` {#sect-rte-core-execute-block}

This function executes a full block and all its extrinsics and updates the state accordingly. Additionally, some integrity checks are executed such as validating if the parent hash is correct and that the transaction root represents the transactions. Internally, this function performs an operation similar to the process described in [Build-Block](sect-block-production.html#algo-build-block), by calling `Core_initialize_block`,`BlockBuilder_apply_extrinsics` and `BlockBuilder_finalize_block`.

This function should be called when a fully complete block is available that is not actively being built on, such as blocks received from other peers. State changes resulted from calling this function are usually meant to persist when the block is imported successfully.

Additionally, the seal digest in the block header, as described in [Definition 11](chap-state.html#defn-digest), must be removed by the Polkadot host before submitting the block.

Arguments  
- A block represented as a tuple consisting of a block header, as described in [Definition 10](chap-state.html#defn-block-header), and the block body, as described in [Definition 13](chap-state.html#defn-block-body).

Return  
- None.

### C.4.3. `Core_initialize_block` {#sect-rte-core-initialize-block}

Sets up the environment required for building a new block as described in [Build-Block](sect-block-production.html#algo-build-block).

Arguments  
- The header of the new block as defined in [Definition 10](chap-state.html#defn-block-header). The values ${H}_{{r}}$, ${H}_{{e}}$ and ${H}_{{d}}$ are left empty.

Return  
- None.

## C.5. Module Metadata {#sect-runtime-metadata-module}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 1** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

### C.5.1. `Metadata_metadata` {#sect-rte-metadata-metadata}

Returns native Runtime metadata in an opaque form. This function can be used by the Polkadot Host implementation when it seems appropriate, such as for the JSON-RPC API as described in [Section C.1.1](chap-runtime-api.html#sect-json-rpc-api). and returns all the information necessary to build valid transactions.

Arguments  
- None.

Return  
- The scale-encoded ([Section A.2.2](id-cryptography-encoding.html#sect-scale-codec)) runtime metadata as described in [Chapter 12](sect-metadata.html).

## C.6. Module BlockBuilder {#sect-runtime-blockbuilder-module}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 4** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

All calls in this module require `Core_initialize_block` ([Section C.4.3](chap-runtime-api.html#sect-rte-core-initialize-block)) to be called beforehand.

### C.6.1. `BlockBuilder_apply_extrinsic` {#sect-rte-apply-extrinsic}

Apply the extrinsic outside of the block execution function. This does not attempt to validate anything regarding the block, but it builds a list of transaction hashes.

Arguments  
- A byte array of varying size containing the opaque extrinsic.

Return  
- Returns the varying datatype *ApplyExtrinsicResult* as defined in [Definition 217](chap-runtime-api.html#defn-rte-apply-extrinsic-result). This structure lets the block builder know whether an extrinsic should be included into the block or rejected.

###### Definition 217. ApplyExtrinsicResult {#defn-rte-apply-extrinsic-result}

**ApplyExtrinsicResult** is a varying data type as defined in [Definition 191](id-cryptography-encoding.html#defn-result-type). This structure can contain multiple nested structures, indicating either module dispatch outcomes or transaction invalidity errors.

###### Table 7. Possible values of varying data type *ApplyExtrinsicResult*. {#tabl-rte-apply-extrinsic-result}

| **Id** | **Description**                                               | **Type**                                                                                                 |
|--------|---------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| 0      | Outcome of dispatching the extrinsic.                         | *DispatchOutcome* ([Definition 218](chap-runtime-api.html#defn-rte-dispatch-outcome))                    |
| 1      | Possible errors while checking the validity of a transaction. | *TransactionValidityError* ([Definition 221](chap-runtime-api.html#defn-rte-transaction-validity-error)) |

|     |                                                                                                                                                                                                                                                                                          |
|-----|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | As long as a *DispatchOutcome* ([Definition 218](chap-runtime-api.html#defn-rte-dispatch-outcome)) is returned, the extrinsic is always included in the block, even if the outcome is a dispatch error. Dispatch errors do not invalidate the block and all state changes are persisted. |

###### Definition 218. DispatchOutcome {#defn-rte-dispatch-outcome}

**DispatchOutcome** is the varying data type as defined in [Definition 191](id-cryptography-encoding.html#defn-result-type).

###### Table 8. Possible values of varying data type *DispatchOutcome*. {#tabl-rte-dispatch-outcome}

| **Id** | **Description**                                    | **Type**                                                                          |
|--------|----------------------------------------------------|-----------------------------------------------------------------------------------|
| 0      | Extrinsic is valid and was submitted successfully. | None                                                                              |
| 1      | Possible errors while dispatching the extrinsic.   | *DispatchError* ([Definition 219](chap-runtime-api.html#defn-rte-dispatch-error)) |

###### Definition 219. DispatchError {#defn-rte-dispatch-error}

**DispatchError** is a varying data type as defined in [Definition 188](id-cryptography-encoding.html#defn-varrying-data-type). Indicates various reasons why a dispatch call failed.

###### Table 9. Possible values of varying data type *DispatchError*. {#tabl-rte-dispatch-error}

| **Id** | **Description**              | **Type**                                                                                   |
|--------|------------------------------|--------------------------------------------------------------------------------------------|
| 0      | Some unknown error occurred. | SCALE encoded byte array containing a valid UTF-8 sequence.                                |
| 1      | Failed to lookup some data.  | None                                                                                       |
| 2      | A bad origin.                | None                                                                                       |
| 3      | A custom error in a module.  | *CustomModuleError* ([Definition 220](chap-runtime-api.html#defn-rte-custom-module-error)) |

###### Definition 220. CustomModuleError {#defn-rte-custom-module-error}

**CustomModuleError** is a tuple appended after a possible error in as defined in [Definition 219](chap-runtime-api.html#defn-rte-dispatch-error).

###### Table 10. Possible values of varying data type *CustomModuleError*. {#tabl-rte-custom-module-error}

| **Name** | **Description**                                  | **Type**                                                                                                                                                                           |
|----------|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Index    | Module index matching the metadata module index. | Unsigned 8-bit integer.                                                                                                                                                            |
| Error    | Module specific error value.                     | Unsigned 8-bit integer                                                                                                                                                             |
| Message  | Optional error message.                          | Varying data type *Option* ([Definition 190](id-cryptography-encoding.html#defn-option-type)). The optional value is a SCALE encoded byte array containing a valid UTF-8 sequence. |

|     |                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | Whenever *TransactionValidityError* ([Definition 221](chap-runtime-api.html#defn-rte-transaction-validity-error)) is returned, the contained error type will indicate whether an extrinsic should be outright rejected or requested for a later block. This behavior is clarified further in [Definition 222](chap-runtime-api.html#defn-rte-invalid-transaction) and respectively [Definition 223](chap-runtime-api.html#defn-rte-unknown-transaction). |

###### Definition 221. TransactionValidityError {#defn-rte-transaction-validity-error}

**TransactionValidityError** is a varying data type as defined in [Definition 188](id-cryptography-encoding.html#defn-varrying-data-type). It indicates possible errors that can occur while checking the validity of a transaction.

###### Table 11. Possible values of varying data type *TransactionValidityError*. {#tabl-rte-transaction-validity-error}

| **Id** | **Description**                           | **Type**                                                                                    |
|--------|-------------------------------------------|---------------------------------------------------------------------------------------------|
| 0      | Transaction is invalid.                   | *InvalidTransaction* ([Definition 222](chap-runtime-api.html#defn-rte-invalid-transaction)) |
| 1      | Transaction validity can’t be determined. | *UnknownTransaction* ([Definition 223](chap-runtime-api.html#defn-rte-unknown-transaction)) |

###### Definition 222. InvalidTransaction {#defn-rte-invalid-transaction}

**InvalidTransaction** is a varying data type as defined in [Definition 188](id-cryptography-encoding.html#defn-varrying-data-type) and specifies the invalidity of the transaction in more detail.

###### Table 12. Possible values of varying data type *InvalidTransaction*. {#tabl-rte-invalid-transaction}

| **Id** | **Description**                                                                                  | **Type**               | **Reject** |
|--------|--------------------------------------------------------------------------------------------------|------------------------|------------|
| 0      | Call of the transaction is not expected.                                                         | None                   | Yes        |
| 1      | General error to do with the inability to pay some fees (e.g. account balance too low).          | None                   | Yes        |
| 2      | General error to do with the transaction not yet being valid (e.g. nonce too high).              | None                   | No         |
| 3      | General error to do with the transaction being outdated (e.g. nonce too low).                    | None                   | Yes        |
| 4      | General error to do with the transactions’ proof (e.g. signature)                                | None                   | Yes        |
| 5      | The transaction birth block is ancient.                                                          | None                   | Yes        |
| 6      | The transaction would exhaust the resources of the current block.                                | None                   | No         |
| 7      | Some unknown error occurred.                                                                     | Unsigned 8-bit integer | Yes        |
| 8      | An extrinsic with mandatory dispatch resulted in an error.                                       | None                   | Yes        |
| 9      | A transaction with a mandatory dispatch (only inherents are allowed to have mandatory dispatch). | None                   | Yes        |

###### Definition 223. UnknownTransaction {#defn-rte-unknown-transaction}

**UnknownTransaction** is a varying data type as defined in [Definition 188](id-cryptography-encoding.html#defn-varrying-data-type) and specifies the unknown invalidity of the transaction in more detail.

###### Table 13. Possible values of varying data type *UnknownTransaction*. {#tabl-rte-unknown-transaction}

| **Id** | **Description**                                                                 | **Type**               | **Reject** |
|--------|---------------------------------------------------------------------------------|------------------------|------------|
| 0      | Could not lookup some information that is required to validate the transaction. | None                   | Yes        |
| 1      | No validator found for the given unsigned transaction.                          | None                   | Yes        |
| 2      | Any other custom unknown validity that is not covered by this type.             | Unsigned 8-bit integer | Yes        |

### C.6.2. `BlockBuilder_finalize_block` {#defn-rt-blockbuilder-finalize-block}

Finalize the block - it is up to the caller to ensure that all header fields are valid except for the state root. State changes resulting from calling this function are usually meant to persist upon successful execution of the function and appending of the block to the chain.

Arguments  
- None.

Return  
- The header of the new block as defined in [Definition 10](chap-state.html#defn-block-header).

### C.6.3. `BlockBuilder_inherent_extrinisics`: {#defn-rt-builder-inherent-extrinsics}

Generates the inherent extrinsics, which are explained in more detail in [Section 2.3.3](chap-state.html#sect-inherents). This function takes a SCALE-encoded hash table as defined in [Definition 192](id-cryptography-encoding.html#defn-scale-list) and returns an array of extrinsics. The Polkadot Host must submit each of those to the `BlockBuilder_apply_extrinsic`, described in [Section C.6.1](chap-runtime-api.html#sect-rte-apply-extrinsic). This procedure is outlined in [Build-Block](sect-block-production.html#algo-build-block).

Arguments  
- A Inherents-Data structure as defined in [Definition 15](chap-state.html#defn-inherent-data).

Return  
- A byte array of varying size containing extrinisics. Each extrinsic is a byte array of varying size.

### C.6.4. `BlockBuilder_check_inherents` {#id-blockbuilder_check_inherents}

Checks whether the provided inherent is valid. This function can be used by the Polkadot Host when deemed appropriate, e.g. during the block-building process.

Arguments  
- A block represented as a tuple consisting of a block header as described in [Definition 10](chap-state.html#defn-block-header) and the block body as described in [Definition 13](chap-state.html#defn-block-body).

- A Inherents-Data structure as defined in [Definition 15](chap-state.html#defn-inherent-data).

Return  
- A data structure of the following format:

  $$
  {\left({o},{{f}_{{e}},}{e}\right)}
  $$

  where  
  - ${o}$ is a boolean indicating whether the check was successful.

  - ${f_e}$ is a boolean indicating whether a fatal error was encountered.

  - ${e}$ is a Inherents-Data structure as defined in [Definition 15](chap-state.html#defn-inherent-data) containing any errors created by this Runtime function.

### C.6.5. `BlockBuilder_random_seed` {#id-blockbuilder_random_seed}

Generates a random seed.

Arguments  
- None

Return  
- A 32-byte array containing the random seed.

## C.7. Module TaggedTransactionQueue {#sect-runtime-txqueue-module}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 2** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

All calls in this module require `Core_initialize_block` ([Section C.4.3](chap-runtime-api.html#sect-rte-core-initialize-block)) to be called beforehand.

### C.7.1. `TaggedTransactionQueue_validate_transaction` {#sect-rte-validate-transaction}

This entry is invoked against extrinsics submitted through a transaction network message ([Section 4.8.5](chap-networking.html#sect-msg-transactions)) or by an offchain worker through the Host API ([Section B.6.2](chap-host-api.html#sect-ext-offchain-submit-transaction)).

It indicates if the submitted blob represents a valid extrinsics, the order in which it should be applied and if it should be gossiped to other peers. Furthermore this function gets called internally when executing blocks with the runtime function as described in [Section C.4.2](chap-runtime-api.html#sect-rte-core-execute-block).

Arguments  
- The source of the transaction as defined in [Definition 224](chap-runtime-api.html#defn-transaction-source).

- A byte array that contains the transaction.

  ###### Definition 224. TransactionSource {#defn-transaction-source}

  **TransactionSource** is an enum describing the source of a transaction and can have one of the following values:

  ###### Table 14. The *TransactionSource* enum {#tabl-rte-transaction-source}

  | Id  | Name       | Description                                                       |
  |-----|------------|-------------------------------------------------------------------|
  | 0   | *InBlock*  | Transaction is already included in a block.                       |
  | 1   | *Local*    | Transaction is coming from a local source, e.g. off-chain worker. |
  | 2   | *External* | Transaction has been received externally, e.g. over the network.  |

Return  
- This function returns a *Result* as defined in [Definition 191](id-cryptography-encoding.html#defn-result-type) which contains the type *ValidTransaction* as defined in [Definition 225](chap-runtime-api.html#defn-valid-transaction) on success and the type *TransactionValidityError* as defined in [Definition 221](chap-runtime-api.html#defn-rte-transaction-validity-error) on failure.

  ###### Definition 225. ValidTransaction {#defn-valid-transaction}

  **ValidTransaction** is a tuple that contains information concerning a valid transaction.

  ###### Table 15. The tuple provided by in the case the transaction is judged to be valid.

  | **Name**    | **Description**                                                                                                                                                                                           | **Type**                      |
  |-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|
  | *Priority*  | Determines the ordering of two transactions that have all their dependencies (required tags) are satisfied.                                                                                               | Unsigned 64bit integer        |
  | *Requires*  | List of tags specifying extrinsics which should be applied before the current exrinsics can be applied.                                                                                                   | Array containing inner arrays |
  | *Provides*  | Informs Runtime of the extrinsics depending on the tags in the list that can be applied after current extrinsics are being applied. Describes the minimum number of blocks for the validity to be correct | Array containing inner arrays |
  | *Longevity* | After this period, the transaction should be removed from the pool or revalidated.                                                                                                                        | Unsigned 64-bit integer       |
  | *Propagate* | A flag indicating if the transaction should be gossiped to other peers.                                                                                                                                   | Boolean                       |

|     |                                                                                                                                                                                     |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | If *Propagate* is set to `false` the transaction will still be considered for inclusion in blocks that are authored on the current node, but should not be gossiped to other peers. |

|     |                                                                                                                                                                                            |
|-----|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | If this function gets called by the Polkadot Host in order to validate a transaction received from peers, the Polkadot Host disregards and rewinds state changes resulting in such a call. |

## C.8. Module OffchainWorkerApi {#sect-runtime-offchainapi-module}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 2** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

Does not require `Core_initialize_block` ([Section C.4.3](chap-runtime-api.html#sect-rte-core-initialize-block)) to be called beforehand.

### C.8.1. `OffchainWorkerApi_offchain_worker` {#id-offchainworkerapi_offchain_worker}

Starts an off-chain worker and generates extrinsics. \[To do: when is this called?\]

Arguments  
- The block header as defined in [Definition 10](chap-state.html#defn-block-header).

Return  
- None.

## C.9. Module ParachainHost {#sect-anv-runtime-api}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 1** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

### C.9.1. `ParachainHost_validators` {#sect-rt-api-validators}

Returns the validator set at the current state. The specified validators are responsible for backing parachains for the current state.

Arguments  
- None.

Return  
- An array of public keys representing the validators.

### C.9.2. `ParachainHost_validator_groups` {#sect-rt-api-validator-groups}

Returns the validator groups ([Definition 136](chapter-anv.html#defn-validator-groups)) used during the current session. The validators in the groups are referred to by the validator set Id ([Definition 33](chap-sync.html#defn-authority-list)).

Arguments  
- None

Return  
- An array of tuples, ${T}$, of the following format:

  $$
  {T}={\left({I},{G}\right)}
  $$
  $$
  {I}={\left({v}_{{n}},…{v}_{{m}}\right)}
  $$
  $$
  {G}={\left({B}_{{s}},{f},{B}_{{c}}\right)}
  $$

  where  
  - ${I}$ is an array the validator set Ids ([Definition 33](chap-sync.html#defn-authority-list)).

  - ${B}_{{s}}$ indicates the block number where the session started.

  - ${f}$ indicates how often groups rotate. 0 means never.

  - ${B}_{{c}}$ indicates the current block number.

### C.9.3. `ParachainHost_availability_cores` {#sect-rt-api-availability-cores}

Returns information on all availability cores ([Definition 135](chapter-anv.html#defn-availability-core)).

Arguments  
- None

Return  
- An array of core states, S, of the following format:

  $$
  {S}={\left\lbrace\begin{matrix}{0}&->&{C}_{{o}}\\{1}&->&{C}_{{s}}\\{2}&->&\phi\end{matrix}\right.}
  $$ 
  $$
  {C}_{{o}}={\left({n}_{{u}},{B}_{{o}},{B}_{{t}},{n}_{{t}},{b},{G}_{{i}},{C}_{{h}},{C}_{{d}}\right)}
  $$ 
  $$
  {C}_{{s}}={\left({P}_{{i}}{d},{C}_{{i}}\right)}
  $$

  where  
  - ${S}$ specifies the core state. *0* indicates that the core is occupied, *1* implies it’s currently free but scheduled and given the opportunity to occupy and *2* implies it’s free and there’s nothing scheduled.

  - ${n}_{{u}}$ is an *Option* value ([Definition 190](id-cryptography-encoding.html#defn-option-type)) which can contain a ${C}_{{s}}$ value if the core was freed by the Runtime and indicates the assignment that is next scheduled on this core. An empty value indicates there is nothing scheduled.

  - ${B}_{{o}}$ indicates the relay chain block number at which the core got occupied.

  - ${B}_{{t}}$ indicates the relay chain block number the core will time-out at, if any.

  - ${n}_{{t}}$ is an *Option* value ([Definition 190](id-cryptography-encoding.html#defn-option-type)) which can contain a ${C}_{{s}}$ value if the core is freed by a time-out and indicates the assignment that is next scheduled on this core. An empty value indicates there is nothing scheduled.

  - ${b}$ is a bitfield array ([Definition 141](chapter-anv.html#defn-bitfield-array)). A $>\frac{{2}}{{3}}$ majority of assigned validators voting with ${1}$ values means that the core is available.

  - ${G}_{{i}}$ indicates the assigned validator group index ([Definition 136](chapter-anv.html#defn-validator-groups)) is to distribute availability pieces of this candidate.

  - ${C}_{{h}}$ indicates the hash of the candidate occupying the core.

  - ${C}_{{d}}$ is the candidate descriptor ([Definition 106](chapter-anv.html#defn-candidate-descriptor)).

  - ${C}_{{i}}$ is an *Option* value ([Definition 190](id-cryptography-encoding.html#defn-option-type)) which can contain the collators public key indicating who should author the block.

### C.9.4. `ParachainHost_persisted_validation_data` {#sect-rt-api-persisted-validation-data}

Returns the persisted validation data for the given parachain Id and a given occupied core assumption.

Arguments  
- The parachain Id ([Definition 134](chapter-anv.html#defn-para-id)).

- An occupied core assumption ([Definition 226](chap-runtime-api.html#defn-occupied-core-assumption)).

Return  
- An *Option* value ([Definition 190](id-cryptography-encoding.html#defn-option-type)) which can contain the persisted validation data ([Definition 227](chap-runtime-api.html#defn-persisted-validation-data)). The value is empty if the parachain Id is not registered or the core assumption is of index ${2}$, meaning that the core was freed.

###### Definition 226. Occupied Core Assumption {#defn-occupied-core-assumption}

A occupied core assumption is used for fetching certain pieces of information about a parachain by using the relay chain API. The assumption indicates how the Runtime API should compute the result. The assumptions, A, is a varying datatype of the following format:

$$
{A}={\left\lbrace\begin{matrix}{0}&->&\phi\\{1}&->&\phi\\{2}&->&\phi\end{matrix}\right.}
$$

where *0* indicates that the candidate occupying the core was made available and included to free the core, *1* indicates that it timed-out and freed the core without advancing the parachain and *2* indicates that the core was not occupied to begin with.

###### Definition 227. Persisted Validation Data {#defn-persisted-validation-data}

The persisted validation data provides information about how to create the inputs for the validation of a candidate by calling the Runtime. This information is derived from the parachain state and will vary from parachain to parachain, although some of the fields may be the same for every parachain. This validation data acts as a way to authorize the additional data (such as messages) the collator needs to pass to the validation function.

The persisted validation data, ${D}_{{{p}{v}}}$, is a datastructure of the following format:

$$
{D}_{{{p}{v}}}={\left({P}_{{h}},{H}_{{i}},{H}_{{r}},{m}_{{b}}\right)}
$$

where  
- ${P}_{{h}}$ is the parent head data ([Definition 133](chapter-anv.html#defn-head-data)).

- ${H}_{{i}}$ is the relay chain block number this is in the context of.

- ${H}_{{r}}$ is the relay chain storage root this is in the context of.

- ${m}_{{b}}$ is the maximum legal size of the PoV block, in bytes.

The persisted validation data is fetched via the Runtime API ([Section C.9.4](chap-runtime-api.html#sect-rt-api-persisted-validation-data)).

### C.9.5. `ParachainHost_check_validation_outputs` {#id-parachainhost_check_validation_outputs}

Checks if the given validation outputs pass the acceptance criteria.

Arguments  
- The parachain Id ([Definition 134](chapter-anv.html#defn-para-id)).

- The candidate commitments ([Definition 107](chapter-anv.html#defn-candidate-commitments)).

Return  
- A boolean indicating whether the candidate commitments pass the acceptance criteria.

### C.9.6. `ParachainHost_session_index_for_child` {#id-parachainhost_session_index_for_child}

Returns the session index that is expected at the child of a block.

|     |                            |
|-----|----------------------------|
|     | TODO clarify session index |

Arguments  
- None

Return  
- A unsigned 32-bit integer representing the session index.

### C.9.7. `ParachainHost_validation_code` {#sect-rt-api-validation-code}

Fetches the validation code (Runtime) of a parachain by parachain Id.

Arguments  
- The parachain Id ([Definition 134](chapter-anv.html#defn-para-id)).

- The occupied core assumption ([Definition 226](chap-runtime-api.html#defn-occupied-core-assumption)).

Return  
- An *Option* value ([Definition 190](id-cryptography-encoding.html#defn-option-type)) containing the full validation code in an byte array. This value is empty if the parachain Id cannot be found or the assumption is wrong.

### C.9.8. `ParachainHost_validation_code_by_hash` {#sect-rt-api-validation-code-by-hash}

Returns the validation code (Runtime) of a parachain by its hash.

Arguments  
- The hash value of the validation code.

Return  
- An *Option* value ([Definition 190](id-cryptography-encoding.html#defn-option-type)) containing the full validation code in an byte array. This value is empty if the parachain Id cannot be found or the assumption is wrong.

### C.9.9. `ParachainHost_candidate_pending_availability` {#id-parachainhost_candidate_pending_availability}

Returns the receipt of a candidate pending availability for any parachain assigned to an occupied availability core.

Arguments  
- The parachain Id ([Definition 134](chapter-anv.html#defn-para-id)).

Return  
- An *Option* value ([Definition 190](id-cryptography-encoding.html#defn-option-type)) containing the committed candidate receipt ([Definition 104](chapter-anv.html#defn-candidate-receipt)). This value is empty if the given parachain Id is not assigned to an occupied availability cores.

### C.9.10. `ParachainHost_candidate_events` {#id-parachainhost_candidate_events}

Returns an array of candidate events that occurred within the latest state.

Arguments  
- None

Return  
- An array of single candidate events, E, of the following format:

  $$
  {E}={\left\lbrace\begin{matrix}{0}&->&{d}\\{1}&->&{d}\\{2}&->&{\left({C}_{{r}},{h},{I}_{{c}}\right)}\end{matrix}\right.}
  $$
  $$
  {d}={\left({C}_{{r}},{h},{I}_{{c}},{G}_{{i}}\right)}
  $$

  where  
  - ${E}$ specifies the the event type of the candidate. *0* indicates that the candidate receipt was backed in the latest relay chain block, *1* indicates that it was included and became a parachain block at the latest relay chain block and *2* indicates that the candidate receipt was not made available and timed-out.

  - ${C}_{{r}}$ is the candidate receipt ([Definition 104](chapter-anv.html#defn-candidate-receipt)).

  - ${h}$ is the parachain head data ([Definition 133](chapter-anv.html#defn-head-data)).

  - ${I}_{{c}}$ is the index of the availability core as can be retrieved in [Section C.9.3](chap-runtime-api.html#sect-rt-api-availability-cores) that the candidate is occupying. If ${E}$ is of variant ${2}$, then this indicates the core index the candidate *was* occupying.

  - ${G}_{{i}}$ is the group index ([Definition 136](chapter-anv.html#defn-validator-groups)) that is responsible of backing the candidate.

### C.9.11. `ParachainHost_session_info` {#sect-rt-api-session-info}

Get the session info of the given session, if available.

Arguments  
- The unsigned 32-bit integer indicating the session index.

Return  
- An *Option* type ([Definition 190](id-cryptography-encoding.html#defn-option-type)) which can contain the session info structure, ${S}$, of the following format:

  $$
  {S}={\left({A},{D},{K},{G},{c},{z},{s},{d},{x},{a}\right)}
  $$
  $$
  {A}={\left({v}_{{n}},…{v}_{{m}}\right)}
  $$
  $$
  {D}={\left({v}_{{_{n}}},…{v}_{{m}}\right)}
  $$
  $$
  {K}={\left({v}_{{n}},…{v}_{{m}}\right)}
  $$
  $$
  {G}={\left({{g}_{{n}},}…{g}_{{m}}\right)}
  $$
  $$
  {g}={\left({A}_{{n}},…{A}_{{m}}\right)}
  $$

  where  
  - ${A}$ indicates the validators of the current session, in canonical order. There might be more validators in the current session than validators participating in parachain consensus, as returned by the Runtime API ([Section C.9.1](chap-runtime-api.html#sect-rt-api-validators)).

  - ${D}$ indicates the validator authority discovery keys for the given session in canonical order. The first couple of validators are equal to the corresponding validators participating in the parachain consensus, as returned by the Runtime API ([Section C.9.1](chap-runtime-api.html#sect-rt-api-validators)). The remaining authorities are not participating in the parachain consensus.

  - ${K}$ indicates the assignment keys for validators. There might be more authorities in the session that validators participating in parachain consensus, as returned by the Runtime API ([Section C.9.1](chap-runtime-api.html#sect-rt-api-validators)).

  - ${G}$ indicates the validator groups in shuffled order.

  - ${v}_{{n}}$ is public key of the authority.

  - ${A}_{{n}}$ is the authority set Id ([Definition 33](chap-sync.html#defn-authority-list)).

  - ${c}$ is an unsigned 32-bit integer indicating the number of availability cores used by the protocol during the given session.

  - ${z}$ is an unsigned 32-bit integer indicating the zeroth delay tranche width.

  - ${s}$ is an unsigned 32-bit integer indicating the number of samples an assigned validator should do for approval voting.

  - ${d}$ is an unsigned 32-bit integer indicating the number of delay tranches in total.

  - ${x}$ is an unsigned 32-bit integer indicating how many BABE slots must pass before an assignment is considered a “no-show”.

  - ${a}$ is an unsigned 32-bit integer indicating the number of validators needed to approve a block.

### C.9.12. `ParachainHost_dmq_contents` {#id-parachainhost_dmq_contents}

Returns all the pending inbound messages in the downward message queue for a given parachain.

Arguments  
- The parachain Id ([Definition 134](chapter-anv.html#defn-para-id)).

Return  
- An array of inbound downward messages ([Definition 138](chapter-anv.html#defn-downward-message)).

### C.9.13. `ParachainHost_inbound_hrmp_channels_contents` {#id-parachainhost_inbound_hrmp_channels_contents}

Returns the contents of all channels addressed to the given recipient. Channels that have no messages in them are also included.

Arguments  
- The parachain Id ([Definition 134](chapter-anv.html#defn-para-id)).

Return  
- An array of inbound HRMP messages ([Definition 140](chapter-anv.html#defn-inbound-hrmp-message)).

## C.10. Module GrandpaApi {#id-module-grandpaapi}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 2** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

All calls in this module require `Core_initialize_block` ([Section C.4.3](chap-runtime-api.html#sect-rte-core-initialize-block)) to be called beforehand.

### C.10.1. `GrandpaApi_grandpa_authorities` {#sect-rte-grandpa-auth}

This entry fetches the list of GRANDPA authorities according to the genesis block and is used to initialize an authority list at genesis, defined in [Definition 33](chap-sync.html#defn-authority-list). Any future authority changes get tracked via Runtime-to-consensus engine messages, as described in [Section 3.3.2](chap-sync.html#sect-consensus-message-digest).

Arguments  
- None.

Return  
- An authority list as defined in [Definition 33](chap-sync.html#defn-authority-list).

### C.10.2. `GrandpaApi_submit_report_equivocation_unsigned_extrinsic` {#sect-grandpaapi_submit_report_equivocation_unsigned_extrinsic}

A GRANDPA equivocation occurs when a validator votes for multiple blocks during one voting subround, as described further in [Definition 80](sect-finality.html#defn-equivocation). The Polkadot Host is expected to identify equivocators and report those to the Runtime by calling this function.

Arguments  
- The equivocation proof of the following format:

  ${b}{e}{g}\in{\left\lbrace{a}{l}{i}{g}\ne{d}\right\rbrace}{G}_{{{m}{a}{t}{h}{r}{m}{\left\lbrace{E}{p}\right\rbrace}}}=&{\left({m}{a}{t}{h}{r}{m}{\left\lbrace{i}{d}\right\rbrace}_{{{\mathbb{{{V}}}}}},{e},{r},{A}_{{{m}{a}{t}{h}{r}{m}{\left\lbrace{i}{d}\right\rbrace}}},{B}^{{1}}_{h},{B}^{{1}}_{n}{A}^{{1}}_{\left\lbrace{m}{a}{t}{h}{r}{m}{\left\lbrace{s}{i}{g}\right\rbrace}\right\rbrace},{B}^{{2}}_{h},{B}^{{2}}_{n},{A}^{{2}}_{\left\lbrace{m}{a}{t}{h}{r}{m}{\left\lbrace{s}{i}{g}\right\rbrace}\right\rbrace}\right)}$ e =& \begin{cases} 0 &\quad \textrm{Equivocation at prevote stage} ${1}&\quad\text{}{m}{\left\lbrace{E}{q}{u}{i}{v}{o}{c}{a}{t}{i}{o}{n}{a}{t}\prec{o}{m}{m}{i}{t}{s}{t}{a}\ge\right\rbrace}{e}{n}{d}{\left\lbrace{c}{a}{s}{e}{s}\right\rbrace}{e}{n}{d}{\left\lbrace{a}{l}{i}{g}\ne{d}\right\rbrace}$

  where  
  - ${m}{a}{t}{h}{r}{m}{\left\lbrace{i}{d}\right\rbrace}_{{{\mathbb{{{V}}}}}}$ is the authority set id as defined in [Definition 73](sect-finality.html#defn-authority-set-id).

  - ${e}$ indicates the stage at which the equivocation occurred.

  - ${r}$ is the round number the equivocation occurred.

  - ${A}_{{{m}{a}{t}{h}{r}{m}{\left\lbrace{i}{d}\right\rbrace}}}$ is the public key of the equivocator.

  - ${B}^{{1}}_{h}$ is the block hash of the first block the equivocator voted for.

  - ${B}^{{1}}_{n}$ is the block number of the first block the equivocator voted for.

  - ${A}^{{1}}_{\left\lbrace{m}{a}{t}{h}{r}{m}{\left\lbrace{s}{i}{g}\right\rbrace}\right\rbrace}$ is the equivocators signature of the first vote.

  - ${B}^{{2}}_{h}$ is the block hash of the second block the equivocator voted for.

  - ${B}^{{2}}_{n}$ is the block number of the second block the equivocator voted for.

  - ${A}^{{2}}_{\left\lbrace{m}{a}{t}{h}{r}{m}{\left\lbrace{s}{i}{g}\right\rbrace}\right\rbrace}$ is the equivocators signature of the second vote.

  - A proof of the key owner in an opaque form as described in [Section C.10.3](chap-runtime-api.html#sect-grandpaapi_generate_key_ownership_proof).

Return  
- A SCALE encoded *Option* as defined in [Definition 190](id-cryptography-encoding.html#defn-option-type) containing an empty value on success.

### C.10.3. `GrandpaApi_generate_key_ownership_proof` {#sect-grandpaapi_generate_key_ownership_proof}

Generates proof of the membership of a key owner in the specified block state. The returned value is used to report equivocations as described in [Section C.10.2](chap-runtime-api.html#sect-grandpaapi_submit_report_equivocation_unsigned_extrinsic).

Arguments  
- The authority set id as defined in [Definition 73](sect-finality.html#defn-authority-set-id).

- The 256-bit public key of the authority.

Return  
- A SCALE encoded *Option* as defined in [Definition 190](id-cryptography-encoding.html#defn-option-type) containing the proof in an opaque form.

## C.11. Module BabeApi {#id-module-babeapi}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 2** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

All calls in this module require `Core_initialized_block` ([Section C.4.3](chap-runtime-api.html#sect-rte-core-initialize-block)) to be called beforehand.

### C.11.1. `BabeApi_configuration` {#sect-rte-babeapi-epoch}

This entry is called to obtain the current configuration of the BABE consensus protocol.

Arguments  
- None.

Return  
- A tuple containing configuration data used by the Babe consensus engine.

  ###### Table 16. The tuple provided by **BabeApi_configuration**. {#tabl-babeapi-configuration}

  | **Name**             | **Description**                                                                                                                                                                                                             | **Type**                                                                                                                |
  |----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
  | *SlotDuration*       | The slot duration in milliseconds. Currently, only the value provided by this type at genesis will be used. Dynamic slot duration may be supported in the future.                                                           | Unsigned 64bit integer                                                                                                  |
  | *EpochLength*        | The duration of epochs in slots.                                                                                                                                                                                            | Unsigned 64bit integer                                                                                                  |
  | *Constant*           | A constant value that is used in the threshold calculation formula as defined in [Definition 59](sect-block-production.html#defn-babe-constant).                                                                            | Tuple containing two unsigned 64bit integers                                                                            |
  | *GenesisAuthorities* | The authority list for the genesis epoch as defined in [Definition 33](chap-sync.html#defn-authority-list).                                                                                                                 | Array of tuples containing a 256-bit byte array and a unsigned 64bit integer                                            |
  | *Randomness*         | The randomness for the genesis epoch                                                                                                                                                                                        | 32-byte array                                                                                                           |
  | *SecondarySlot*      | Whether this chain should run with round-robin-style secondary slot and if this secondary slot requires the inclusion of an auxiliary VRF output ([Section 5.2](sect-block-production.html#sect-block-production-lottery)). | A one-byte enum as defined in [Definition 58](sect-block-production.html#defn-consensus-message-babe) as ${2}_{{\text{nd}}}$. |

### C.11.2. `BabeApi_current_epoch_start` {#id-babeapi_current_epoch_start}

Finds the start slot of the current epoch.

Arguments  
- None.

Return  
- A unsigned 64-bit integer indicating the slot number.

### C.11.3. `BabeApi_current_epoch` {#sect-babeapi_current_epoch}

Produces information about the current epoch.

Arguments  
- None.

Return  
- A data structure of the following format:

  $$
  {\left({e}_{{i}},{s}_{{s}},{d},{A},{r}\right)}
  $$

  where  
  - ${e}_{{i}}$ is a unsigned 64-bit integer representing the epoch index.

  - ${s}_{{s}}$ is a unsigned 64-bit integer representing the starting slot of the epoch.

  - ${d}$ is a unsigned 64-bit integer representing the duration of the epoch.

  - ${A}$ is an authority list as defined in [Definition 33](chap-sync.html#defn-authority-list).

  - ${r}$ is an 256-bit array containing the randomness for the epoch as defined in [Definition 71](sect-block-production.html#defn-epoch-randomness).

### C.11.4. `BabeApi_next_epoch` {#id-babeapi_next_epoch}

Produces information about the next epoch.

Arguments  
- None.

Return  
- Returns the same datastructure as described in [Section C.11.3](chap-runtime-api.html#sect-babeapi_current_epoch).

### C.11.5. `BabeApi_generate_key_ownership_proof` {#sect-babeapi_generate_key_ownership_proof}

Generates a proof of the membership of a key owner in the specified block state. The returned value is used to report equivocations as described in [Section C.11.6](chap-runtime-api.html#sect-babeapi_submit_report_equivocation_unsigned_extrinsic).

Arguments  
- The unsigned 64-bit integer indicating the slot number.

- The 256-bit public key of the authority.

Return  
- A SCALE encoded *Option* as defined in Definition [Definition 190](id-cryptography-encoding.html#defn-option-type) containing the proof in an opaque form.

### C.11.6. `BabeApi_submit_report_equivocation_unsigned_extrinsic` {#sect-babeapi_submit_report_equivocation_unsigned_extrinsic}

A BABE equivocation occurs when a validator produces more than one block at the same slot. The proof of equivocation are the given distinct headers that were signed by the validator and which include the slot number. The Polkadot Host is expected to identify equivocators and report those to the Runtime using this function.

|     |                                                                                                                                                                                     |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | If there are more than two blocks which cause an equivocation, the equivocation only needs to be reported once i.e. no additional equivocations must be reported for the same slot. |

Arguments  
- The equivocation proof of the following format:

  $$
  {B}_{{{m}{a}{t}{h}{r}{m}{\left\lbrace{E}{p}\right\rbrace}}}={\left({A}_{{{m}{a}{t}{h}{r}{m}{\left\lbrace{i}{d}\right\rbrace}}},{s},{h}_{{1}},{h}_{{2}}\right)}
  $$

  where  
  - ${A}_{{{m}{a}{t}{h}{r}{m}{\left\lbrace{i}{d}\right\rbrace}}}$ is the public key of the equivocator.

  - ${s}$ is the slot as described in [Definition 54](sect-block-production.html#defn-epoch-slot) at which the equivocation occurred.

  - ${h}_{{1}}$ is the block header of the first block produced by the equivocator.

  - ${h}_{{2}}$ is the block header of the second block produced by the equivocator.

    Unlike during block execution, the Seal in both block headers is not removed before submission. The block headers are submitted in its full form.

- An proof of the key owner in an opaque form as described in [Section C.11.5](chap-runtime-api.html#sect-babeapi_generate_key_ownership_proof).

Return  
- A SCALE encoded *Option* as defined in [Definition 190](id-cryptography-encoding.html#defn-option-type) containing an empty value on success.

### C.11.7. Module AuthorityDiscoveryApi {#id-module-authoritydiscoveryapi}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 1** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

All calls in this module require (Section [Section C.4.3](chap-runtime-api.html#sect-rte-core-initialize-block)) to be called beforehand.

#### C.11.7.1. `AuthorityDiscoveryApi_authorities` {#id-authoritydiscoveryapi_authorities}

A function which helps to discover authorities.

Arguments  
- None.

Return  
- A byte array of varying size containing 256-bit pulic keys of the authorities.

### C.11.8. Module SessionKeys {#sect-runtime-sessionkeys-module}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 1** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

All calls in this module require `Core_initialize_block` ([Section C.4.3](chap-runtime-api.html#sect-rte-core-initialize-block)) to be called beforehand.

#### C.11.8.1. `SessionKeys_generate_session_keys` {#id-sessionkeys_generate_session_keys}

Generates a set of session keys with an optional seed. The keys should be stored within the keystore exposed by the Host Api. The seed needs to be valid and UTF-8 encoded.

Arguments  
- A SCALE-encoded *Option* as defined in [Definition 190](id-cryptography-encoding.html#defn-option-type) containing an array of varying sizes indicating the seed.

Return  
- A byte array of varying size containing the encoded session keys.

#### C.11.8.2. `SessionKeys_decode_session_keys` {#id-sessionkeys_decode_session_keys}

Decodes the given public session keys. Returns a list of raw public keys including their key type.

Arguments  
- An array of varying size containing the encoded public session keys.

Return  
- An array of varying size containing tuple pairs of the following format:

  $$
  {\left({k},{k}_{{{m}{a}{t}{h}{r}{m}{\left\lbrace{i}{d}\right\rbrace}}}\right)}
  $$

  where ${k}$ is an array of varying sizes containing the raw public key and ${k}_{{{m}{a}{t}{h}{r}{m}{\left\lbrace{i}{d}\right\rbrace}}}$ is a 4-byte array indicating the key type.

## C.12. Module AccountNonceApi {#id-module-accountnonceapi}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 1** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

All calls in this module require `Core_initialize_block` ([Section C.4.3](chap-runtime-api.html#sect-rte-core-initialize-block)) to be called beforehand.

### C.12.1. `AccountNonceApi_account_nonce` {#sect-accountnonceapi-account-nonce}

Get the current nonce of an account. This function can be used by the Polkadot Host implementation when it seems appropriate, such as for the JSON-RPC API as described in [Section C.1.1](chap-runtime-api.html#sect-json-rpc-api).

Arguments  
- The 256-bit public key of the account.

Return  
- A 32-bit unsigned integer indicating the nonce of the account.

### C.12.2. Module TransactionPaymentApi {#id-module-transactionpaymentapi}

|     |                                                                                                                                                                      |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This section describes **Version 1** of this API. Please check `Core_version` ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)) to ensure compatibility. |

All calls in this module require `Core_initialize_block` ([Section C.4.3](chap-runtime-api.html#sect-rte-core-initialize-block)) to be called beforehand.

#### C.12.2.1. `TransactionPaymentApi_query_info` {#id-transactionpaymentapi_query_info}

Returns information of a given extrinsic. This function is not aware of the internals of an extrinsic, but only interprets the extrinsic as some encoded value and accounts for its weight and length, the Runtime’s extrinsic base weight and the current fee multiplier.

This function can be used by the Polkadot Host implementation when it seems appropriate, such as for the JSON-RPC API as described in [Section C.1.1](chap-runtime-api.html#sect-json-rpc-api).

Arguments  
- A byte array of varying sizes containing the extrinsic.

- The length of the extrinsic. \[To do: why is this needed?\]

Return  
- A data structure of the following format:

  $$
  {\left({w},{c},{f}\right)}
  $$

  where  
  - ${w}$ is the weight of the extrinsic.

  - ${c}$ is the "class" of the extrinsic, where class is a varying data ([Definition 188](id-cryptography-encoding.html#defn-varrying-data-type)) type defined as:

    ${c}=\le{f}{t}$\begin{array}{l} 0 \quad \textrm{Normal extrinsic}${1}\quad\text{}{m}{\left\lbrace{O}{p}{e}{r}{a}{t}{i}{o}{n}{a}{l}{e}{x}{t}{r}\in{s}{i}{c}\right\rbrace}$ 2 \quad \textrm{Mandatory extrinsic, which is always included} \end{array}\right.$

  - ${f}$ is the inclusion fee of the extrinsic. This does not include a tip or anything else that depends on the signature.

#### C.12.2.2. `TransactionPaymentApi_query_fee_details` {#id-transactionpaymentapi_query_fee_details}

Query the detailed fee of a given extrinsic. This function can be used by the Polkadot Host implementation when it seems appropriate, such as for the JSON-RPC API as described in [Section C.1.1](chap-runtime-api.html#sect-json-rpc-api).

Arguments  
- A byte array of varying sizes containing the extrinsic.

- The length of the extrinsic.

Return  
- A data structure of the following format:

  $$
  {\left({f},{t}\right)}
  $$

  where  
  - ${f}$ is a SCALE encoded as defined in [Definition 190](id-cryptography-encoding.html#defn-option-type) containing the following data structure:

    $$
    {f}={\left({{f}_{{b}},}{{f}_{{l}},}{f}_{{a}}\right)}
    $$

    where  
    - ${f_b}$ is the minimum required fee for an extrinsic.

    - ${f_l}$ is the length fee, the amount paid for the encoded length (in bytes) of the extrinsic.

    - ${f_a}$ is the “adjusted weight fee”, which is a multiplication of the fee multiplier and the weight fee. The fee multiplier varies depending on the usage of the network.

  - ${t}$ is the tip for the block author.
