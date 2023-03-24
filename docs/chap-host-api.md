---
title: "Appendix B: Host API"
---

Description of the expected environment available for import by the Polkadot Runtime

## B.1. Preliminaries {#id-preliminaries-4}

The Polkadot Host API is a set of functions that the Polkadot Host exposes to Runtime to access external functions needed for various reasons, such as the Storage of the content, access and manipulation, memory allocation, and also efficiency. The encoding of each data type is specified or referenced in this section. If the encoding is not mentioned, then the default Wasm encoding is used, such as little-endian byte ordering for integers.

###### Definition -def-num- Exposed Host API {#defn-host-api-at-state}

By $\text{RE}_{{B}}$ we refer to the API exposed by the Polkadot Host which interact, manipulate and response based on the state storage whose state is set at the end of the execution of block ${B}$.

###### Definition -def-num- Runtime Pointer {#defn-runtime-pointer}

The **Runtime pointer** type is an unsigned 32-bit integer representing a pointer to data in memory. This pointer is the primary way to exchange data of fixed/known size between the Runtime and Polkadot Host.

###### Definition -def-num- Runtime Pointer Size {#defn-runtime-pointer-size}

The **Runtime pointer-size** type is an unsigned 64-bit integer, representing two consecutive integers. The least significant is **Runtime pointer** ([Definition 202](chap-host-api#defn-runtime-pointer)). The most significant provides the size of the data in bytes. This representation is the primary way to exchange data of arbitrary/dynamic sizes between the Runtime and the Polkadot Host.

###### Definition -def-num- Lexicographic ordering {#defn-lexicographic-ordering}

**Lexicographic ordering** refers to the ascending ordering of bytes or byte arrays, such as:

$$
{\left[{0},{0},{2}\right]}<{\left[{0},{1},{1}\right]}<{\left[{1}\right]}<{\left[{1},{1},{0}\right]}<{\left[{2}\right]}<{\left[\ldots\right]}
$$

The functions are specified in each subsequent subsection for each category of those functions.

## B.2. Storage {#sect-storage-api}

Interface for accessing the storage from within the runtime.

|     |                                                                                                                                                                                                                                                                                                                                                                                       |
|-----|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | As of now, the storage API should silently ignore any keys that start with the `:child_storage:default:` prefix. This applies to reading and writing. If the function expects a return value, then *None* ([Definition 190](id-cryptography-encoding#defn-option-type)) should be returned. See [substrate issue \#12461](https://github.com/paritytech/substrate/issues/12461). |

###### Definition -def-num- State Version {#defn-state-version}

The state version, ${v}$, dictates how a merkle root should be constructed. The datastructure is a varying type of the following format:

$$
{v}={\left\lbrace\begin{matrix}{0}&\text{full values}\\{1}&\text{node hashes}\end{matrix}\right.}
$$

where ${0}$ indicates that the values of the keys should be inserted into the trie directly and ${1}$ makes use of "node hashes" when calculating the merkle proof ([Definition 28](chap-state#defn-hashed-subvalue)).

### B.2.1. `ext_storage_set` {#sect-storage-set}

Sets the value under a given key into storage.

#### B.2.1.1. Version 1 - Prototype {#id-version-1-prototype}

    (func $ext_storage_set_version_1
        (param ${k}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}value i64))

Arguments  
- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the key.

- `value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the value.

### B.2.2. `ext_storage_get` {#id-ext_storage_get}

Retrieves the value associated with the given key from storage.

#### B.2.2.1. Version 1 - Prototype {#id-version-1-prototype-2}

    (func $ext_storage_get_version_1
        (param $key i64) (result i64))

Arguments  
- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the key.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) returning the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the value.

### B.2.3. `ext_storage_read` {#id-ext_storage_read}

Gets the given key from storage, placing the value into a buffer and returning the number of bytes that the entry in storage has beyond the offset.

#### B.2.3.1. Version 1 - Prototype {#id-version-1-prototype-3}

    (func $ext_storage_read_version_1
        (param ${k}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}value_out i64) (param $offset i32) (result i64))

Arguments  
- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the key.

- `value_out`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the buffer to which the value will be written to. This function will never write more then the length of the buffer, even if the value’s length is bigger.

- `offset`: an u32 integer (typed as i32 due to wasm types) containing the offset beyond the value should be read from.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) pointing to a SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing an unsigned 32-bit integer representing the number of bytes left at supplied `offset`. Returns *None* if the entry does not exists.

### B.2.4. `ext_storage_clear` {#id-ext_storage_clear}

Clears the storage of the given key and its value. Non-existent entries are silently ignored.

#### B.2.4.1. Version 1 - Prototype {#id-version-1-prototype-4}

    (func $ext_storage_clear_version_1
        (param $key_data i64))

Arguments  
- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the key.

### B.2.5. `ext_storage_exists` {#id-ext_storage_exists}

Checks whether the given key exists in storage.

#### B.2.5.1. Version 1 - Prototype {#id-version-1-prototype-5}

    (func $ext_storage_exists_version_1
        (param $key_data i64) (return i32))

Arguments  
- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the key.

- `return`: an i32 integer value equal to *1* if the key exists or a value equal to *0* if otherwise.

### B.2.6. `ext_storage_clear_prefix` {#id-ext_storage_clear_prefix}

Clear the storage of each key/value pair where the key starts with the given prefix.

#### B.2.6.1. Version 1 - Prototype {#id-version-1-prototype-6}

    (func $ext_storage_clear_prefix_version_1
        (param $prefix i64))

Arguments  
- `prefix`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the prefix.

#### B.2.6.2. Version 2 - Prototype {#id-version-2-prototype}

    (func $ext_storage_clear_prefix_version_2
        (param ${p}{r}{e}{f}{i}{x}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}limit i64)
        (return i64))

Arguments  
- `prefix`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the prefix.

- `limit`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an *Option* type ([Definition 190](id-cryptography-encoding#defn-option-type)) containing an unsigned 32-bit integer indicating the limit on how many keys should be deleted. No limit is applied if this is *None*. Any keys created during the current block execution do not count towards the limit.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the following variant, ${k}$:

  $$
  {k}={\left\lbrace\begin{matrix}{0}&->{c}\\{1}&->{c}\end{matrix}\right.}
  $$

  where *0* indicates that all keys of the child storage have been removed, followed by the number of removed keys, ${c}$. The variant *1* indicates that there are remaining keys, followed by the number of removed keys.

### B.2.7. `ext_storage_append` {#id-ext_storage_append}

Append the SCALE encoded value to a SCALE encoded sequence ([Definition 192](id-cryptography-encoding#defn-scale-list)) at the given key. This function assumes that the existing storage item is either empty or a SCALE encoded sequence and that the value to append is also SCALE encoded and of the same type as the items in the existing sequence.

To improve performance, this function is allowed to skip decoding the entire SCALE encoded sequence and instead can just append the new item to the end of the existing data and increment the length prefix ${\text{Enc}_{{\text{SC}}}^{{\text{Len}}}}$.

|     |                                                                                                                                                             |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | If the storage item does not exist or is not SCALE encoded, the storage item will be set to the specified value, represented as a SCALE encoded byte array. |

#### B.2.7.1. Version 1 - Prototype {#id-version-1-prototype-7}

    (func $ext_storage_append_version_1
        (param ${k}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}value i64))

Arguments  
- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the key.

- `value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) containing the value to be appended.

### B.2.8. `ext_storage_root` {#id-ext_storage_root}

Compute the storage root.

#### B.2.8.1. Version 1 - Prototype {#sect-ext-storage-root-version-1}

    (func $ext_storage_root_version_1
        (return i64))

Arguments  
- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to a buffer containing the 256-bit Blake2 storage root.

#### B.2.8.2. Version 2 - Prototype {#sect-ext-storage-root-version-2}

    (func $ext_storage_root_version_2
        (param $version i32) (return i64))

Arguments  
- `version`: the state version ([Definition 205](chap-host-api#defn-state-version)).

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the buffer containing the 256-bit Blake2 storage root.

### B.2.9. `ext_storage_changes_root` {#sect-ext-storage-changes-root}

|     |                                                                             |
|-----|-----------------------------------------------------------------------------|
|     | This function is not longer used and only exists for compatibility reasons. |

#### B.2.9.1. Version 1 - Prototype {#id-version-1-prototype-8}

    (func $ext_storage_changes_root_version_1
        (param $parent_hash i64) (return i64))

Arguments  
- `parent_hash`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded block hash.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an *Option* type ([Definition 190](id-cryptography-encoding#defn-option-type)) that’s always *None*.

### B.2.10. `ext_storage_next_key` {#id-ext_storage_next_key}

Get the next key in storage after the given one in lexicographic order ([Definition 204](chap-host-api#defn-lexicographic-ordering)). The key provided to this function may or may not exist in storage.

#### B.2.10.1. Version 1 - Prototype {#id-version-1-prototype-9}

    (func $ext_storage_next_key_version_1
        (param $key i64) (return i64))

Arguments  
- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the next key in lexicographic order.

### B.2.11. `ext_storage_start_transaction` {#sect-ext-storage-start-transaction}

Start a new nested transaction. This allows to either commit or roll back all changes that are made after this call. For every transaction there must be a matching call to either `ext_storage_rollback_transaction` ([Section B.2.12](chap-host-api#sect-ext-storage-rollback-transaction)) or `ext_storage_commit_transaction` ([Section B.2.13](chap-host-api#sect-ext-storage-commit-transaction)). This is also effective for all values manipulated using the child storage API ([Section B.3](chap-host-api#sect-child-storage-api)). It’s legal to call this function multiple times in a row.

|     |                                                                                                                                                                |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | This is a low level API that is potentially dangerous as it can easily result in unbalanced transactions. Runtimes should use high level storage abstractions. |

#### B.2.11.1. Version 1 - Prototype {#id-version-1-prototype-10}

    (func $ext_storage_start_transaction_version_1)

Arguments  
- None.

### B.2.12. `ext_storage_rollback_transaction` {#sect-ext-storage-rollback-transaction}

Rollback the last transaction started by `ext_storage_start_transaction` ([Section B.2.11](chap-host-api#sect-ext-storage-start-transaction)). Any changes made during that transaction are discarded. It’s legal to call this function multiple times in a row.

|     |                                                                                                                                     |
|-----|-------------------------------------------------------------------------------------------------------------------------------------|
|     | Panics if `ext_storage_start_transaction` ([Section B.2.11](chap-host-api#sect-ext-storage-start-transaction)) was not called. |

#### B.2.12.1. Version 1 - Prototype {#id-version-1-prototype-11}

    (func $ext_storage_rollback_transaction_version_1)

Arguments  
- None.

### B.2.13. `ext_storage_commit_transaction` {#sect-ext-storage-commit-transaction}

Commit the last transaction started by `ext_storage_start_transaction` ([Section B.2.11](chap-host-api#sect-ext-storage-start-transaction)). Any changes made during that transaction are committed to the main state. It’s legal to call this function multiple times in a row.

|     |                                                                                                                                     |
|-----|-------------------------------------------------------------------------------------------------------------------------------------|
|     | Panics if `ext_storage_start_transaction` ([Section B.2.11](chap-host-api#sect-ext-storage-start-transaction)) was not called. |

#### B.2.13.1. Version 1 - Prototype {#id-version-1-prototype-12}

    (func $ext_storage_commit_transaction_version_1)

Arguments  
- None.

## B.3. Child Storage {#sect-child-storage-api}

Interface for accessing the child storage from within the runtime.

###### Definition -def-num- Child Storage {#defn-child-storage-type}

**Child storage** key is a unprefixed location of the child trie in the main trie.

### B.3.1. `ext_default_child_storage_set` {#id-ext_default_child_storage_set}

Sets the value under a given key into the child storage.

#### B.3.1.1. Version 1 - Prototype {#id-version-1-prototype-13}

    (func $ext_default_child_storage_set_version_1
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64) (param $value i64))

Arguments  
- `child_storage_key` : a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the value.

### B.3.2. `ext_default_child_storage_get` {#id-ext_default_child_storage_get}

Retrieves the value associated with the given key from the child storage.

#### B.3.2.1. Version 1 - Prototype {#id-version-1-prototype-14}

    (func $ext_default_child_storage_get_version_1
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64) (result i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the value.

### B.3.3. `ext_default_child_storage_read` {#id-ext_default_child_storage_read}

Gets the given key from storage, placing the value into a buffer and returning the number of bytes that the entry in storage has beyond the offset.

#### B.3.3.1. Version 1 - Prototype {#id-version-1-prototype-15}

    (func $ext_default_child_storage_read_version_1
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64) (param $value_out i64)
        (param $offset i32) (result i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `value_out`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the buffer to which the value will be written to. This function will never write more then the length of the buffer, even if the value’s length is bigger.

- `offset`: an u32 integer (typed as i32 due to wasm types) containing the offset beyond the value should be read from.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the number of bytes written into the **value_out** buffer. Returns if the entry does not exists.

### B.3.4. `ext_default_child_storage_clear` {#id-ext_default_child_storage_clear}

Clears the storage of the given key and its value from the child storage. Non-existent entries are silently ignored.

#### B.3.4.1. Version 1 - Prototype {#id-version-1-prototype-16}

    (func $ext_default_child_storage_clear_version_1
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

### B.3.5. `ext_default_child_storage_storage_kill` {#id-ext_default_child_storage_storage_kill}

Clears an entire child storage.

#### B.3.5.1. Version 1 - Prototype {#id-version-1-prototype-17}

    (func $ext_default_child_storage_storage_kill_version_1
        (param $child_storage_key i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

#### B.3.5.2. Version 2 - Prototype {#id-version-2-prototype-2}

    (func $ext_default_child_storage_storage_kill_version_2
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}limit i64)
        (return i32))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `limit`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an *Option* type ([Definition 190](id-cryptography-encoding#defn-option-type)) containing an unsigned 32-bit integer indicating the limit on how many keys should be deleted. No limit is applied if this is *None*. Any keys created during the current block execution do not count towards the limit.

- `return`: a value equal to *1* if all the keys of the child storage have been deleted or a value equal to *0* if there are remaining keys.

#### B.3.5.3. Version 3 - Prototype {#id-version-3-prototype}

    (func $ext_default_child_storage_storage_kill_version_3
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}limit i64)
        (return i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `limit`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an *Option* type ([Definition 190](id-cryptography-encoding#defn-option-type)) containing an unsigned 32-bit integer indicating the limit on how many keys should be deleted. No limit is applied if this is *None*. Any keys created during the current block execution do not count towards the limit.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the following variant, ${k}$:

  $$
  {k}={\left\lbrace\begin{matrix}{0}&->{c}\\{1}&->{c}\end{matrix}\right.}
  $$

  where *0* indicates that all keys of the child storage have been removed, followed by the number of removed keys, ${c}$. The variant *1* indicates that there are remaining keys, followed by the number of removed keys.

### B.3.6. `ext_default_child_storage_exists` {#id-ext_default_child_storage_exists}

Checks whether the given key exists in the child storage.

#### B.3.6.1. Version 1 - Prototype {#id-version-1-prototype-18}

    (func $ext_default_child_storage_exists_version_1
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64) (return i32))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `return`: an i32 integer value equal to *1* if the key exists or a value equal to *0* if otherwise.

### B.3.7. `ext_default_child_storage_clear_prefix` {#id-ext_default_child_storage_clear_prefix}

Clears the child storage of each key/value pair where the key starts with the given prefix.

#### B.3.7.1. Version 1 - Prototype {#id-version-1-prototype-19}

    (func $ext_default_child_storage_clear_prefix_version_1
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}prefix i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `prefix`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the prefix.

#### B.3.7.2. Version 2 - Prototype {#id-version-2-prototype-3}

    (func $ext_default_child_storage_clear_prefix_version_2
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}prefix i64)
        (param $limit i64) (return i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `prefix`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the prefix.

- `limit`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an *Option* type ([Definition 190](id-cryptography-encoding#defn-option-type)) containing an unsigned 32-bit integer indicating the limit on how many keys should be deleted. No limit is applied if this is *None*. Any keys created during the current block execution do not count towards the limit.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the following variant, ${k}$:

  $$
  {k}={\left\lbrace\begin{matrix}{0}&->{c}\\{1}&->{c}\end{matrix}\right.}
  $$

  where *0* indicates that all keys of the child storage have been removed, followed by the number of removed keys, ${c}$. The variant *1* indicates that there are remaining keys, followed by the number of removed keys.

### B.3.8. `ext_default_child_storage_root` {#id-ext_default_child_storage_root}

Commits all existing operations and computes the resulting child storage root.

#### B.3.8.1. Version 1 - Prototype {#id-version-1-prototype-20}

    (func $ext_default_child_storage_root_version_1
        (param $child_storage_key i64) (return i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded storage root.

#### B.3.8.2. Version 2 - Prototype {#id-version-2-prototype-4}

    (func $ext_default_child_storage_root_version_2
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}version i32)
        (return i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `version`: the state version ([Definition 205](chap-host-api#defn-state-version)).

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit Blake2 storage root.

### B.3.9. `ext_default_child_storage_next_key` {#id-ext_default_child_storage_next_key}

Gets the next key in storage after the given one in lexicographic order ([Definition 204](chap-host-api#defn-lexicographic-ordering)). The key provided to this function may or may not exist in storage.

#### B.3.9.1. Version 1 - Prototype {#id-version-1-prototype-21}

    (func $ext_default_child_storage_next_key_version_1
        (param $\chi{l}{d}_{{s}}\to{r}{a}\ge_{{k}}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64) (return i64))

Arguments  
- `child_storage_key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the child storage key ([Definition 206](chap-host-api#defn-child-storage-type)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded as defined in [Definition 190](id-cryptography-encoding#defn-option-type) containing the next key in lexicographic order. Returns if the entry cannot be found.

## B.4. Crypto {#sect-crypto-api}

Interfaces for working with crypto related types from within the runtime.

###### Definition -def-num- Key Type Identifier {#defn-key-type-id}

Cryptographic keys are stored in separate key stores based on their intended use case. The separate key stores are identified by a 4-byte ASCII **key type identifier**. The following known types are available:

###### Table 4. Table of known key type identifiers {#tabl-key-type-ids}

| Id   | Description                                |
|------|--------------------------------------------|
| acco | Key type for the controlling accounts      |
| babe | Key type for the Babe module               |
| gran | Key type for the Grandpa module            |
| imon | Key type for the ImOnline module           |
| audi | Key type for the AuthorityDiscovery module |
| para | Key type for the Parachain Validator Key   |
| asgn | Key type for the Parachain Assignment Key  |

###### Definition -def-num- ECDSA Verify Error {#defn-ecdsa-verify-error}

**EcdsaVerifyError** is a varying data type ([Definition 188](id-cryptography-encoding#defn-varrying-data-type)) that specifies the error type when using ECDSA recovery functionality. Following values are possible:

###### Table 5. Table of error types in ECDSA recovery {#tabl-ecdsa-verify-error}

| Id  | Description               |
|-----|---------------------------|
| 0   | Incorrect value of R or S |
| 1   | Incorrect value of V      |
| 2   | Invalid signature         |

### B.4.1. `ext_crypto_ed25519_public_keys` {#id-ext_crypto_ed25519_public_keys}

Returns all *ed25519* public keys for the given key identifier from the keystore.

#### B.4.1.1. Version 1 - Prototype {#id-version-1-prototype-22}

    (func $ext_crypto_ed25519_public_keys_version_1
        (param $key_type_id i32) (return i64))

Arguments  
- `key_type_id`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key type identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an SCALE encoded 256-bit public keys.

### B.4.2. `ext_crypto_ed25519_generate` {#id-ext_crypto_ed25519_generate}

Generates an *ed25519* key for the given key type using an optional BIP-39 seed and stores it in the keystore.

|     |                                                                                                       |
|-----|-------------------------------------------------------------------------------------------------------|
|     | Panics if the key cannot be generated, such as when an invalid key type or invalid seed was provided. |

#### B.4.2.1. Version 1 - Prototype {#id-version-1-prototype-23}

    (func $ext_crypto_ed25519_generate_version_1
        (param ${k}{e}{y}_{{t}}{y}{p}{e}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}seed i64) (return i32))

Arguments  
- `key_type_id`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key type identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `seed`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the BIP-39 seed which must be valid UTF8.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit public key.

### B.4.3. `ext_crypto_ed25519_sign` {#id-ext_crypto_ed25519_sign}

Signs the given message with the `ed25519` key that corresponds to the given public key and key type in the keystore.

#### B.4.3.1. Version 1 - Prototype {#id-version-1-prototype-24}

    (func $ext_crypto_ed25519_sign_version_1
        (param ${k}{e}{y}_{{t}}{y}{p}{e}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}key i32) (param $msg i64) (return i64))

Arguments  
- `key_type_id`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key type identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `key`: a pointer to the buffer containing the 256-bit public key.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be signed.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the 64-byte signature. This function returns if the public key cannot be found in the key store.

### B.4.4. `ext_crypto_ed25519_verify` {#sect-ext-crypto-ed25519-verify}

Verifies an *ed25519* signature.

#### B.4.4.1. Version 1 - Prototype {#id-version-1-prototype-25}

    (func $ext_crypto_ed25519_verify_version_1
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i64) (param $key i32) (return i32))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 64-byte signature.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be verified.

- `key`: a pointer to the buffer containing the 256-bit public key.

- `return`: a i32 integer value equal to *1* if the signature is valid or a value equal to *0* if otherwise.

### B.4.5. `ext_crypto_ed25519_batch_verify` {#sect-ext-crypto-ed25519-batch-verify}

Registers a ed25519 signature for batch verification. Batch verification is enabled by calling `ext_crypto_start_batch_verify` ([Section B.4.20](chap-host-api#sect-ext-crypto-start-batch-verify)). The result of the verification is returned by `ext_crypto_finish_batch_verify` ([Section B.4.21](chap-host-api#sect-ext-crypto-finish-batch-verify)). If batch verification is not enabled, the signature is verified immediately.

#### B.4.5.1. Version 1 {#id-version-1}

    (func $ext_crypto_ed25519_batch_verify_version_1
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i64) (param $key i32) (return i32))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 64-byte signature.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be verified.

- `key`: a pointer to the buffer containing the 256-bit public key.

- `return`: a i32 integer value equal to *1* if the signature is valid or batched or a value equal *0* to if otherwise.

### B.4.6. `ext_crypto_sr25519_public_keys` {#id-ext_crypto_sr25519_public_keys}

Returns all *sr25519* public keys for the given key id from the keystore.

#### B.4.6.1. Version 1 - Prototype {#id-version-1-prototype-26}

    (func $ext_crypto_sr25519_public_keys_version_1
        (param $key_type_id i32) (return i64))

Arguments  
- `key_type_id`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key type identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded 256-bit public keys.

### B.4.7. `ext_crypto_sr25519_generate` {#id-ext_crypto_sr25519_generate}

Generates an *sr25519* key for the given key type using an optional BIP-39 seed and stores it in the keystore.

|     |                                                                                                       |
|-----|-------------------------------------------------------------------------------------------------------|
|     | Panics if the key cannot be generated, such as when an invalid key type or invalid seed was provided. |

#### B.4.7.1. Version 1 - Prototype {#id-version-1-prototype-27}

    (func $ext_crypto_sr25519_generate_version_1
        (param ${k}{e}{y}_{{t}}{y}{p}{e}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}seed i64) (return i32))

Arguments  
- `key_type_id`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `seed`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the BIP-39 seed which must be valid UTF8.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit public key.

### B.4.8. `ext_crypto_sr25519_sign` {#id-ext_crypto_sr25519_sign}

Signs the given message with the *sr25519* key that corresponds to the given public key and key type in the keystore.

#### B.4.8.1. Version 1 - Prototype {#id-version-1-prototype-28}

    (func $ext_crypto_sr25519_sign_version_1
        (param ${k}{e}{y}_{{t}}{y}{p}{e}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}key i32) (param $msg i64) (return i64))

Arguments  
- `key_type_id`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `key`: a pointer to the buffer containing the 256-bit public key.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be signed.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the 64-byte signature. This function returns *None* if the public key cannot be found in the key store.

### B.4.9. `ext_crypto_sr25519_verify` {#sect-ext-crypto-sr25519-verify}

Verifies an sr25519 signature.

#### B.4.9.1. Version 1 - Prototype {#id-version-1-prototype-29}

    (func $ext_crypto_sr25519_verify_version_1
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i64) (param $key i32) (return i32))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 64-byte signature.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be verified.

- `key`: a pointer to the buffer containing the 256-bit public key.

- `return`: a i32 integer value equal to *1* if the signature is valid or a value equal to *0* if otherwise.

#### B.4.9.2. Version 2 - Prototype {#id-version-2-prototype-5}

    (func $ext_crypto_sr25519_verify_version_2
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i64) (param $key i32) (return i32))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 64-byte signature.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be verified.

- `key`: a pointer to the buffer containing the 256-bit public key.

- `return`: a i32 integer value equal to *1* if the signature is valid or a value equal to *0* if otherwise.

### B.4.10. `ext_crypto_sr25519_batch_verify` {#sect-ext-crypto-sr25519-batch-verify}

Registers a sr25519 signature for batch verification. Batch verification is enabled by calling `ext_crypto_start_batch_verify` ([Section B.4.20](chap-host-api#sect-ext-crypto-start-batch-verify)). The result of the verification is returned by `ext_crypto_finish_batch_verify` ([Section B.4.21](chap-host-api#sect-ext-crypto-finish-batch-verify)). If batch verification is not enabled, the signature is verified immediately.

#### B.4.10.1. Version 1 {#id-version-1-2}

    (func $ext_crypto_sr25519_batch_verify_version_1
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i64) (param $key i32) (return i32))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 64-byte signature.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be verified.

- `key`: a pointer to the buffer containing the 256-bit public key.

- `return`: a i32 integer value equal to *1* if the signature is valid or batched or a value equal *0* to if otherwise.

### B.4.11. `ext_crypto_ecdsa_public_keys` {#id-ext_crypto_ecdsa_public_keys}

Returns all *ecdsa* public keys for the given key id from the keystore.

#### B.4.11.1. Version 1 - Prototype {#id-version-1-prototype-30}

    (func $ext_crypto_ecdsa_public_key_version_1
        (param $key_type_id i64) (return i64))

Arguments  
- `key_type_id`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key type identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded 33-byte compressed public keys.

### B.4.12. `ext_crypto_ecdsa_generate` {#id-ext_crypto_ecdsa_generate}

Generates an *ecdsa* key for the given key type using an optional BIP-39 seed and stores it in the keystore.

|     |                                                                                                       |
|-----|-------------------------------------------------------------------------------------------------------|
|     | Panics if the key cannot be generated, such as when an invalid key type or invalid seed was provided. |

#### B.4.12.1. Version 1 - Prototype {#id-version-1-prototype-31}

    (func $ext_crypto_ecdsa_generate_version_1
        (param ${k}{e}{y}_{{t}}{y}{p}{e}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}seed i64) (return i32))

Arguments  
- `key_type_id`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `seed`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the BIP-39 seed which must be valid UTF8.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 33-byte compressed public key.

### B.4.13. `ext_crypto_ecdsa_sign` {#id-ext_crypto_ecdsa_sign}

Signs the hash of the given message with the *ecdsa* key that corresponds to the given public key and key type in the keystore.

#### B.4.13.1. Version 1 - Prototype {#id-version-1-prototype-32}

    (func $ext_crypto_ecdsa_sign_version_1
        (param ${k}{e}{y}_{{t}}{y}{p}{e}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}key i32) (param $msg i64) (return i64))

Arguments  
- `key_type_id`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `key`: a pointer to the buffer containing the 33-byte compressed public key.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be signed.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the signature. The signature is 65-bytes in size, where the first 512-bits represent the signature and the other 8 bits represent the recovery ID. This function returns if the public key cannot be found in the key store.

### B.4.14. `ext_crypto_ecdsa_sign_prehashed` {#id-ext_crypto_ecdsa_sign_prehashed}

Signs the prehashed message with the *ecdsa* key that corresponds to the given public key and key type in the keystore.

#### B.4.14.1. Version 1 - Prototype {#id-version-1-prototype-33}

    (func $ext_crypto_ecdsa_sign_prehashed_version_1
        (param ${k}{e}{y}_{{t}}{y}{p}{e}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}key i32) (param $msg i64) (return i64))

Arguments  
- `key_type_id`: a pointer-size ([Definition 202](chap-host-api#defn-runtime-pointer)) to the key identifier ([Definition 207](chap-host-api#defn-key-type-id)).

- `key`: a pointer to the buffer containing the 33-byte compressed public key.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be signed.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the signature. The signature is 65-bytes in size, where the first 512-bits represent the signature and the other 8 bits represent the recovery ID. This function returns if the public key cannot be found in the key store.

### B.4.15. `ext_crypto_ecdsa_verify` {#sect-ext-crypto-ecdsa-verify}

Verifies the hash of the given message against a ECDSA signature.

#### B.4.15.1. Version 1 - Prototype {#id-version-1-prototype-34}

This function allows the verification of non-standard, overflowing ECDSA signatures, an implemenation specific mechanism of the Rust [`libsecp256k1` library](https://github.com/paritytech/libsecp256k1), specifically the [`parse_overflowing`](https://docs.rs/libsecp256k1/0.7.0/libsecp256k1/struct.Signature#method.parse_overflowing) function.

    (func $ext_crypto_ecdsa_verify_version_1
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i64) (param $key i32) (return i32))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 65-byte signature. The signature is 65-bytes in size, where the first 512-bits represent the signature and the other 8 bits represent the recovery ID.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be verified.

- `key`: a pointer to the buffer containing the 33-byte compressed public key.

- `return`: a i32 integer value equal *1* to if the signature is valid or a value equal to *0* if otherwise.

#### B.4.15.2. Version 2 - Prototype {#id-version-2-prototype-6}

Does not allow the verification of non-standard, overflowing ECDSA signatures.

    (func $ext_crypto_ecdsa_verify_version_2
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i64) (param $key i32) (return i32))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 65-byte signature. The signature is 65-bytes in size, where the first 512-bits represent the signature and the other 8 bits represent the recovery ID.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be verified.

- `key`: a pointer to the buffer containing the 33-byte compressed public key.

- `return`: a i32 integer value equal *1* to if the signature is valid or a value equal to *0* if otherwise.

### B.4.16. `ext_crypto_ecdsa_verify_prehashed` {#id-ext_crypto_ecdsa_verify_prehashed}

Verifies the prehashed message against a ECDSA signature.

#### B.4.16.1. Version 1 - Prototype {#id-version-1-prototype-35}

    (func $ext_crypto_ecdsa_verify_prehashed_version_1
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i32) (param $key i32) (return i32))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 65-byte signature. The signature is 65-bytes in size, where the first 512-bits represent the signature and the other 8 bits represent the recovery ID.

- `msg`: a pointer to the 32-bit prehashed message to be verified.

- `key`: a pointer to the 33-byte compressed public key.

- `return`: a i32 integer value equal *1* to if the signature is valid or a value equal to *0* if otherwise.

### B.4.17. `ext_crypto_ecdsa_batch_verify` {#sect-ext-crypto-ecdsa-batch-verify}

Registers a ECDSA signature for batch verification. Batch verification is enabled by calling `ext_crypto_start_batch_verify` ([Section B.4.20](chap-host-api#sect-ext-crypto-start-batch-verify)). The result of the verification is returned by `ext_crypto_finish_batch_verify` ([Section B.4.21](chap-host-api#sect-ext-crypto-finish-batch-verify)). If batch verification is not enabled, the signature is verified immediately.

#### B.4.17.1. Version 1 {#id-version-1-3}

    (func $ext_crypto_ecdsa_batch_verify_version_1
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i64) (param $key i32) (return i32))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 64-byte signature.

- `msg`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the message that is to be verified.

- `key`: a pointer to the buffer containing the 256-bit public key.

- `return`: a i32 integer value equal to *1* if the signature is valid or batched or a value equal *0* to if otherwise.

### B.4.18. `ext_crypto_secp256k1_ecdsa_recover` {#id-ext_crypto_secp256k1_ecdsa_recover}

Verify and recover a *secp256k1* ECDSA signature.

#### B.4.18.1. Version 1 - Prototype {#id-version-1-prototype-36}

This function can handle non-standard, overflowing ECDSA signatures, an implemenation specific mechanism of the Rust [`libsecp256k1` library](https://github.com/paritytech/libsecp256k1), specifically the [`parse_overflowing`](https://docs.rs/libsecp256k1/0.7.0/libsecp256k1/struct.Signature#method.parse_overflowing) function.

    (func $ext_crypto_secp256k1_ecdsa_recover_version_1
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i32) (return i64))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 65-byte signature in RSV format. V should be either `0/1` or `27/28`.

- `msg`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit Blake2 hash of the message.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Result* ([Definition 191](id-cryptography-encoding#defn-result-type)). On success it contains the 64-byte recovered public key or an error type ([Definition 208](chap-host-api#defn-ecdsa-verify-error)) on failure.

#### B.4.18.2. Version 2 - Prototype {#id-version-2-prototype-7}

Does not handle non-standard, overflowing ECDSA signatures.

    (func $ext_crypto_secp256k1_ecdsa_recover_version_2
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i32) (return i64))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 65-byte signature in RSV format. V should be either or .

- `msg`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit Blake2 hash of the message.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Result* ([Definition 191](id-cryptography-encoding#defn-result-type)). On success it contains the 64-byte recovered public key or an error type ([Definition 208](chap-host-api#defn-ecdsa-verify-error)) on failure.

### B.4.19. `ext_crypto_secp256k1_ecdsa_recover_compressed` {#id-ext_crypto_secp256k1_ecdsa_recover_compressed}

Verify and recover a *secp256k1* ECDSA signature.

#### B.4.19.1. Version 1 - Prototype {#id-version-1-prototype-37}

This function can handle non-standard, overflowing ECDSA signatures, an implemenation specific mechanism of the Rust [`libsecp256k1` library](https://github.com/paritytech/libsecp256k1), specifically the [`parse_overflowing`](https://docs.rs/libsecp256k1/0.7.0/libsecp256k1/struct.Signature#method.parse_overflowing) function.

    (func $ext_crypto_secp256k1_ecdsa_recover_compressed_version_1
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i32) (return i64))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 65-byte signature in RSV format. V should be either `0/1` or `27/28`.

- `msg`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit Blake2 hash of the message.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded `Result` value ([Definition 191](id-cryptography-encoding#defn-result-type)). On success it contains the 33-byte recovered public key in compressed form on success or an error type ([Definition 208](chap-host-api#defn-ecdsa-verify-error)) on failure.

#### B.4.19.2. Version 2 - Prototype {#id-version-2-prototype-8}

Does not handle non-standard, overflowing ECDSA signatures.

    (func $ext_crypto_secp256k1_ecdsa_recover_compressed_version_2
        (param ${s}{i}{g}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}msg i32) (return i64))

Arguments  
- `sig`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 65-byte signature in RSV format. V should be either `0/1` or `27/28`.

- `msg`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit Blake2 hash of the message.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded `Result` value ([Definition 191](id-cryptography-encoding#defn-result-type)). On success it contains the 33-byte recovered public key in compressed form on success or an error type ([Definition 208](chap-host-api#defn-ecdsa-verify-error)) on failure.

### B.4.20. `ext_crypto_start_batch_verify` {#sect-ext-crypto-start-batch-verify}

Starts the verification extension. The extension is a separate background process and is used to parallel-verify signatures which are pushed to the batch with `ext_crypto_ed25519_batch_verify`([Section B.4.5](chap-host-api#sect-ext-crypto-ed25519-batch-verify)), `ext_crypto_sr25519_batch_verify` ([Section B.4.10](chap-host-api#sect-ext-crypto-sr25519-batch-verify)) or `ext_crypto_ecdsa_batch_verify` ([Section B.4.17](chap-host-api#sect-ext-crypto-ecdsa-batch-verify)). Verification will start immediately and the Runtime can retrieve the result when calling `ext_crypto_finish_batch_verify` ([Section B.4.21](chap-host-api#sect-ext-crypto-finish-batch-verify)).

#### B.4.20.1. Version 1 - Prototype {#id-version-1-prototype-38}

    (func $ext_crypto_start_batch_verify_version_1)

Arguments  
- None.

### B.4.21. `ext_crypto_finish_batch_verify` {#sect-ext-crypto-finish-batch-verify}

Finish verifying the batch of signatures since the last call to this function. Blocks until all the signatures are verified.

|     |                                                                                                                                     |
|-----|-------------------------------------------------------------------------------------------------------------------------------------|
|     | Panics if `ext_crypto_start_batch_verify` ([Section B.4.20](chap-host-api#sect-ext-crypto-start-batch-verify)) was not called. |

#### B.4.21.1. Version 1 - Prototype {#id-version-1-prototype-39}

    (func $ext_crypto_finish_batch_verify_version_1
        (return i32))

Arguments  
- `return`: an i32 integer value equal to *1* if all the signatures are valid or a value equal to *0* if one or more of the signatures are invalid.

## B.5. Hashing {#sect-hashing-api}

Interface that provides functions for hashing with different algorithms.

### B.5.1. `ext_hashing_keccak_256` {#id-ext_hashing_keccak_256}

Conducts a 256-bit Keccak hash.

#### B.5.1.1. Version 1 - Prototype {#id-version-1-prototype-40}

    (func $ext_hashing_keccak_256_version_1
        (param $data i64) (return i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the data to be hashed.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit hash result.

### B.5.2. `ext_hashing_keccak_512` {#id-ext_hashing_keccak_512}

Conducts a 512-bit Keccak hash.

#### B.5.2.1. Version 1 - Prototype {#id-version-1-prototype-41}

    (func $ext_hashing_keccak_512_version_1
        (param $data i64) (return i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the data to be hashed.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 512-bit hash result.

### B.5.3. `ext_hashing_sha2_256` {#id-ext_hashing_sha2_256}

Conducts a 256-bit Sha2 hash.

#### B.5.3.1. Version 1 - Prototype {#id-version-1-prototype-42}

    (func $ext_hashing_sha2_256_version_1
        (param $data i64) (return i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the data to be hashed.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit hash result.

### B.5.4. `ext_hashing_blake2_128` {#id-ext_hashing_blake2_128}

Conducts a 128-bit Blake2 hash.

#### B.5.4.1. Version 1 - Prototype {#id-version-1-prototype-43}

    (func $ext_hashing_blake2_128_version_1
        (param $data i64) (return i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the data to be hashed.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 128-bit hash result.

### B.5.5. `ext_hashing_blake2_256` {#id-ext_hashing_blake2_256}

Conducts a 256-bit Blake2 hash.

#### B.5.5.1. Version 1 - Prototype {#id-version-1-prototype-44}

    (func $ext_hashing_blake2_256_version_1
        (param $data i64) (return i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the data to be hashed.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit hash result.

### B.5.6. `ext_hashing_twox_64` {#id-ext_hashing_twox_64}

Conducts a 64-bit xxHash hash.

#### B.5.6.1. Version 1 - Prototype {#id-version-1-prototype-45}

    (func $ext_hashing_twox_64_version_1
        (param $data i64) (return i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the data to be hashed.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 64-bit hash result.

### B.5.7. `ext_hashing_twox_128` {#id-ext_hashing_twox_128}

Conducts a 128-bit xxHash hash.

#### B.5.7.1. Version 1 - Prototype {#id-version-1-prototype-46}

    (func $ext_hashing_twox_128
        (param $data i64) (return i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the data to be hashed.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 128-bit hash result.

### B.5.8. `ext_hashing_twox_256` {#id-ext_hashing_twox_256}

Conducts a 256-bit xxHash hash.

#### B.5.8.1. Version 1 - Prototype {#id-version-1-prototype-47}

    (func $ext_hashing_twox_256
        (param $data i64) (return i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the data to be hashed.

- `return`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit hash result.

## B.6. Offchain {#sect-offchain-api}

The Offchain Workers allow the execution of long-running and possibly non-deterministic tasks (e.g. web requests, encryption/decryption and signing of data, random number generation, CPU-intensive computations, enumeration/aggregation of on-chain data, etc.) which could otherwise require longer than the block execution time. Offchain Workers have their own execution environment. This separation of concerns is to make sure that the block production is not impacted by the long-running tasks.

All data and results generated by Offchain workers are unique per node and nondeterministic. Information can be propagated to other nodes by submitting a transaction that should be included in the next block. As Offchain workers runs on their own execution environment they have access to their own separate storage. There are two different types of storage available which are defined in [Definition 209](chap-host-api#defn-offchain-persistent-storage) and [Definition 210](chap-host-api#defn-offchain-local-storage).

###### Definition -def-num- Persisted Storage {#defn-offchain-persistent-storage}

**Persistent storage** is non-revertible and not fork-aware. It means that any value set by the offchain worker is persisted even if that block (at which the worker is called) is reverted as non-canonical (meaning that the block was surpassed by a longer chain). The value is available for the worker that is re-run at the new (different block with the same block number) and future blocks. This storage can be used by offchain workers to handle forks and coordinate offchain workers running on different forks.

###### Definition -def-num- Local Storage {#defn-offchain-local-storage}

**Local storage** is revertible and fork-aware. It means that any value set by the offchain worker triggered at a certain block is reverted if that block is reverted as non-canonical. The value is NOT available for the worker that is re-run at the next or any future blocks.

###### Definition -def-num- HTTP Status Code {#defn-http-status-code}

**HTTP status codes** that can get returned by certain Offchain HTTP functions.

- `0`: the specified request identifier is invalid.

- `10`: the deadline for the started request was reached.

- `20`: an error has occurred during the request, e.g. a timeout or the remote server has closed the connection. On returning this error code, the request is considered destroyed and must be reconstructed again.

- `100`-`999`: the request has finished with the given HTTP status code.

###### Definition -def-num- HTTP Error {#defn-http-error}

HTTP error, ${E}$, is a varying data type ([Definition 188](id-cryptography-encoding#defn-varrying-data-type)) and specifies the error types of certain HTTP functions. Following values are possible:

$$
{E}={\left\lbrace\begin{matrix}{0}&\text{The deadile was reached}\\{1}&\text{There was an IO error while processing the request}\\{2}&\text{The Id of the request is invalid}\end{matrix}\right.}
$$

### B.6.1. `ext_offchain_is_validator` {#id-ext_offchain_is_validator}

Check whether the local node is a potential validator. Even if this function returns *1*, it does not mean that any keys are configured or that the validator is registered in the chain.

#### B.6.1.1. Version 1 - Prototype {#id-version-1-prototype-48}

    (func $ext_offchain_is_validator_version_1 (return i32))

Arguments  
- `return`: a i32 integer which is equal to *1* if the local node is a potential validator or a integer equal to *0* if it is not.

### B.6.2. `ext_offchain_submit_transaction` {#sect-ext-offchain-submit-transaction}

Given a SCALE encoded extrinsic, this function submits the extrinsic to the Host’s transaction pool, ready to be propagated to remote peers.

#### B.6.2.1. Version 1 - Prototype {#id-version-1-prototype-49}

    (func $ext_offchain_submit_transaction_version_1
        (param $data i64) (return i64))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the byte array storing the encoded extrinsic.

- `return`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Result* value ([Definition 191](id-cryptography-encoding#defn-result-type)). Neither on success or failure is there any additional data provided. The cause of a failure is implementation specific.

### B.6.3. `ext_offchain_network_state` {#id-ext_offchain_network_state}

Returns the SCALE encoded, opaque information about the local node’s network state.

###### Definition -def-num- Opaque Network State {#defn-opaque-network-state}

The **Opaque network state structure**, ${S}$, is a SCALE encoded blob holding information about the the *libp2p PeerId*, ${P}_{{\text{id}}}$, of the local node and a list of *libp2p Multiaddresses*, ${\left({M}_{{0}},\ldots{M}_{{n}}\right)}$, the node knows it can be reached at:

$$
{S}={\left({P}_{{\text{id}}},{\left({M}_{{0}},\ldots{M}_{{n}}\right)}\right)}
$$

where

$$
{P}_{{\text{id}}}={\left({b}_{{0}},\ldots{b}_{{n}}\right)}
$$
$$
{M}={\left({b}_{{0}},\ldots{b}_{{n}}\right)}
$$

The information contained in this structure is naturally opaque to the caller of this function.

#### B.6.3.1. Version 1 - Prototype {#id-version-1-prototype-50}

    (func $ext_offchain_network_state_version_1 (result i64))

Arguments  
- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded `Result` value ([Definition 191](id-cryptography-encoding#defn-result-type)). On success it contains the *Opaque network state* structure ([Definition 213](chap-host-api#defn-opaque-network-state)). On failure, an empty value is yielded where its cause is implementation specific.

### B.6.4. `ext_offchain_timestamp` {#id-ext_offchain_timestamp}

Returns the current timestamp.

#### B.6.4.1. Version 1 - Prototype {#id-version-1-prototype-51}

    (func $ext_offchain_timestamp_version_1 (result i64))

Arguments  
- `result`: an u64 integer (typed as i64 due to wasm types) indicating the current UNIX timestamp ([Definition 181](id-cryptography-encoding#defn-unix-time)).

### B.6.5. `ext_offchain_sleep_until` {#id-ext_offchain_sleep_until}

Pause the execution until the `deadline` is reached.

#### B.6.5.1. Version 1 - Prototype {#id-version-1-prototype-52}

    (func ${e}{x}{t}_{{o}}{f}{f}{c}{h}{a}\in_{{s}}\le{e}{p}_{{u}}{n}{t}{i}{l}_{{v}}{e}{r}{s}{i}{o}{n}_{{1}}{\left({p}{a}{r}{a}{m}$\right.}deadline i64))

Arguments  
- `deadline`: an u64 integer (typed as i64 due to wasm types) specifying the UNIX timestamp ([Definition 181](id-cryptography-encoding#defn-unix-time)).

### B.6.6. `ext_offchain_random_seed` {#id-ext_offchain_random_seed}

Generates a random seed. This is a truly random non deterministic seed generated by the host environment.

#### B.6.6.1. Version 1 - Prototype {#id-version-1-prototype-53}

    (func $ext_offchain_random_seed_version_1 (result i32))

Arguments  
- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit seed.

### B.6.7. `ext_offchain_local_storage_set` {#id-ext_offchain_local_storage_set}

Sets a value in the local storage. This storage is not part of the consensus, it’s only accessible by the offchain worker tasks running on the same machine and is persisted between runs.

#### B.6.7.1. Version 1 - Prototype {#id-version-1-prototype-54}

    (func $ext_offchain_local_storage_set_version_1
        (param ${k}\in{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64) (param $value i64))

Arguments  
- `kind`: an i32 integer indicating the storage kind. A value equal to *1* is used for a persistent storage ([Definition 209](chap-host-api#defn-offchain-persistent-storage)) and a value equal to *2* for local storage ([Definition 210](chap-host-api#defn-offchain-local-storage)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the value.

### B.6.8. `ext_offchain_local_storage_clear` {#id-ext_offchain_local_storage_clear}

Remove a value from the local storage.

#### B.6.8.1. Version 1 - Prototype {#id-version-1-prototype-55}

    (func $ext_offchain_local_storage_clear_version_1
        (param ${k}\in{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64))

Arguments  
- `kind`: an i32 integer indicating the storage kind. A value equal to *1* is used for a persistent storage ([Definition 209](chap-host-api#defn-offchain-persistent-storage)) and a value equal to *2* for local storage ([Definition 210](chap-host-api#defn-offchain-local-storage)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

### B.6.9. `ext_offchain_local_storage_compare_and_set` {#id-ext_offchain_local_storage_compare_and_set}

Sets a new value in the local storage if the condition matches the current value.

#### B.6.9.1. Version 1 - Prototype {#id-version-1-prototype-56}

    (fund $ext_offchain_local_storage_compare_and_set_version_1
        (param ${k}\in{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64) (param $old_value i64)
        (param $new_value i64) (result i32))

Arguments  
- `kind`: an i32 integer indicating the storage kind. A value equal to *1* is used for a persistent storage ([Definition 209](chap-host-api#defn-offchain-persistent-storage)) and a value equal to *2* for local storage ([Definition 210](chap-host-api#defn-offchain-local-storage)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `old_value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the old key.

- `new_value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the new value.

- `result`: an i32 integer equal to *1* if the new value has been set or a value equal to *0* if otherwise.

### B.6.10. `ext_offchain_local_storage_get` {#id-ext_offchain_local_storage_get}

Gets a value from the local storage.

#### B.6.10.1. Version 1 - Prototype {#id-version-1-prototype-57}

    (func $ext_offchain_local_storage_get_version_1
        (param ${k}\in{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}key i64) (result i64))

Arguments  
- `kind`: an i32 integer indicating the storage kind. A value equal to *1* is used for a persistent storage ([Definition 209](chap-host-api#defn-offchain-persistent-storage)) and a value equal to *2* for local storage ([Definition 210](chap-host-api#defn-offchain-local-storage)).

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the value or the corresponding key.

### B.6.11. `ext_offchain_http_request_start` {#id-ext_offchain_http_request_start}

Initiates a HTTP request given by the HTTP method and the URL. Returns the Id of a newly started request.

#### B.6.11.1. Version 1 - Prototype {#id-version-1-prototype-58}

    (func $ext_offchain_http_request_start_version_1
      (param ${m}{e}{t}{h}{o}{d}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}uri i64) (param $meta i64) (result i64))

Arguments  
- `method`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the HTTP method. Possible values are “GET” and “POST”.

- `uri`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the URI.

- `meta`: a future-reserved field containing additional, SCALE encoded parameters. Currently, an empty array should be passed.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Result* value ([Definition 191](id-cryptography-encoding#defn-result-type)) containing the i16 ID of the newly started request. On failure no additionally data is provided. The cause of failure is implementation specific.

### B.6.12. `ext_offchain_http_request_add_header` {#id-ext_offchain_http_request_add_header}

Append header to the request. Returns an error if the request identifier is invalid, `http_response_wait` has already been called on the specified request identifier, the deadline is reached or an I/O error has happened (e.g. the remote has closed the connection).

#### B.6.12.1. Version 1 - Prototype {#id-version-1-prototype-59}

    (func $ext_offchain_http_request_add_header_version_1
        (param ${r}{e}{q}{u}{e}{s}{t}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}name i64) (param $value i64) (result i64))

Arguments  
- `request_id`: an i32 integer indicating the ID of the started request.

- `name`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the HTTP header name.

- `value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the HTTP header value.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Result* value ([Definition 191](id-cryptography-encoding#defn-result-type)). Neither on success or failure is there any additional data provided. The cause of failure is implementation specific.

### B.6.13. `ext_offchain_http_request_write_body` {#id-ext_offchain_http_request_write_body}

Writes a chunk of the request body. Returns a non-zero value in case the deadline is reached or the chunk could not be written.

#### B.6.13.1. Version 1 - Prototype {#id-version-1-prototype-60}

    (func $ext_offchain_http_request_write_body_version_1
        (param ${r}{e}{q}{u}{e}{s}{t}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}chunk i64) (param $deadline i64) (result i64))

Arguments  
- `request_id`: an i32 integer indicating the ID of the started request.

- `chunk`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the chunk of bytes. Writing an empty chunk finalizes the request.

- `deadline`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the UNIX timestamp ([Definition 181](id-cryptography-encoding#defn-unix-time)). Passing *None* blocks indefinitely.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Result* value ([Definition 191](id-cryptography-encoding#defn-result-type)). On success, no additional data is provided. On error it contains the HTTP error type ([Definition 212](chap-host-api#defn-http-error)).

### B.6.14. `ext_offchain_http_response_wait` {#id-ext_offchain_http_response_wait}

Returns an array of request statuses (the length is the same as IDs). Note that if deadline is not provided the method will block indefinitely, otherwise unready responses will produce DeadlineReached status.

#### B.6.14.1. Version 1 - Prototype {#id-version-1-prototype-61}

    (func $ext_offchain_http_response_wait_version_1
        (param ${i}{d}{s}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}deadline i64) (result i64))

Arguments  
- `ids`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded array of started request IDs.

- `deadline`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the UNIX timestamp ([Definition 181](id-cryptography-encoding#defn-unix-time)). Passing None blocks indefinitely.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded array of request statuses ([Definition 211](chap-host-api#defn-http-status-code)).

### B.6.15. `ext_offchain_http_response_headers` {#id-ext_offchain_http_response_headers}

Read all HTTP response headers. Returns an array of key/value pairs. Response headers must be read before the response body.

#### B.6.15.1. Version 1 - Prototype {#id-version-1-prototype-62}

    (func $ext_offchain_http_response_headers_version_1
        (param $request_id i32) (result i64))

Arguments  
- `request_id`: an i32 integer indicating the ID of the started request.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to a SCALE encoded array of key/value pairs.

### B.6.16. `ext_offchain_http_response_read_body` {#id-ext_offchain_http_response_read_body}

Reads a chunk of body response to the given buffer. Returns the number of bytes written or an error in case a deadline is reached or the server closed the connection. If 0 is returned it means that the response has been fully consumed and the request_id is now invalid. This implies that response headers must be read before draining the body.

#### B.6.16.1. Version 1 - Prototype {#id-version-1-prototype-63}

    (func $ext_offchain_http_response_read_body_version_1
        (param ${r}{e}{q}{u}{e}{s}{t}_{{i}}{d}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}buffer i64) (param $deadline i64) (result i64))

Arguments  
- `request_id`: an i32 integer indicating the ID of the started request.

- `buffer`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the buffer where the body gets written to.

- `deadline`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the UNIX timestamp ([Definition 181](id-cryptography-encoding#defn-unix-time)). Passing *None* will block indefinitely.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Result* value ([Definition 191](id-cryptography-encoding#defn-result-type)). On success it contains an i32 integer specifying the number of bytes written or a HTTP error type ([Definition 212](chap-host-api#defn-http-error)) on failure.

## B.7. Trie {#sect-trie-api}

Interface that provides trie related functionality.

### B.7.1. `ext_trie_blake2_256_root` {#id-ext_trie_blake2_256_root}

Compute a 256-bit Blake2 trie root formed from the iterated items.

#### B.7.1.1. Version 1 - Prototype {#id-version-1-prototype-64}

    (func $ext_trie_blake2_256_root_version_1
        (param $data i64) (result i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the iterated items from which the trie root gets formed. The items consist of a SCALE encoded array containing arbitrary key/value pairs (tuples).

- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit trie root.

#### B.7.1.2. Version 2 - Prototype {#id-version-2-prototype-9}

    (func $ext_trie_blake2_256_root_version_2
        (param ${d}{a}{t}{a}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}version i32)
        (result i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the iterated items from which the trie root gets formed. The items consist of a SCALE encoded array containing arbitrary key/value pairs (tuples).

- `version`: the state version ([Definition 205](chap-host-api#defn-state-version)).

- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit trie root.

### B.7.2. `ext_trie_blake2_256_ordered_root` {#id-ext_trie_blake2_256_ordered_root}

Compute a 256-bit Blake2 trie root formed from the enumerated items.

#### B.7.2.1. Version 1 - Prototype {#id-version-1-prototype-65}

    (func $ext_trie_blake2_256_ordered_root_version_1
        (param $data i64) (result i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the enumerated items from which the trie root gets formed. The items consist of a SCALE encoded array containing only values, where the corresponding key of each value is the index of the item in the array, starting at 0. The keys are compact encoded integers ([Definition 198](id-cryptography-encoding#defn-sc-len-encoding)).

- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit trie root result.

#### B.7.2.2. Version 2 - Prototype {#id-version-2-prototype-10}

    (func $ext_trie_blake2_256_ordered_root_version_2
        (param ${d}{a}{t}{a}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}version i32)
        (result i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the enumerated items from which the trie root gets formed. The items consist of a SCALE encoded array containing only values, where the corresponding key of each value is the index of the item in the array, starting at 0. The keys are compact encoded integers ([Definition 198](id-cryptography-encoding#defn-sc-len-encoding)).

- `version`: the state version ([Definition 205](chap-host-api#defn-state-version)).

- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit trie root result.

### B.7.3. `ext_trie_keccak_256_root` {#id-ext_trie_keccak_256_root}

Compute a 256-bit Keccak trie root formed from the iterated items.

#### B.7.3.1. Version 1 - Prototype {#id-version-1-prototype-66}

    (func $ext_trie_keccak_256_root_version_1
        (param $data i64) (result i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the iterated items from which the trie root gets formed. The items consist of a SCALE encoded array containing arbitrary key/value pairs.

- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit trie root.

#### B.7.3.2. Version 2 - Prototype {#id-version-2-prototype-11}

    (func $ext_trie_keccak_256_root_version_2
        (param ${d}{a}{t}{a}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}version i32)
        (result i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the iterated items from which the trie root gets formed. The items consist of a SCALE encoded array containing arbitrary key/value pairs.

- `version`: the state version ([Definition 205](chap-host-api#defn-state-version)).

- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit trie root.

### B.7.4. `ext_trie_keccak_256_ordered_root` {#id-ext_trie_keccak_256_ordered_root}

Compute a 256-bit Keccak trie root formed from the enumerated items.

#### B.7.4.1. Version 1 - Prototype {#id-version-1-prototype-67}

    (func $ext_trie_keccak_256_ordered_root_version_1
        (param $data i64) (result i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the enumerated items from which the trie root gets formed. The items consist of a SCALE encoded array containing only values, where the corresponding key of each value is the index of the item in the array, starting at 0. The keys are compact encoded integers ([Definition 198](id-cryptography-encoding#defn-sc-len-encoding)).

- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit trie root result.

#### B.7.4.2. Version 2 - Prototype {#id-version-2-prototype-12}

    (func $ext_trie_keccak_256_ordered_root_version_2
        (param ${d}{a}{t}{a}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}version i32)
        (result i32))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the enumerated items from which the trie root gets formed. The items consist of a SCALE encoded array containing only values, where the corresponding key of each value is the index of the item in the array, starting at 0. The keys are compact encoded integers ([Definition 198](id-cryptography-encoding#defn-sc-len-encoding)).

- `version`: the state version ([Definition 205](chap-host-api#defn-state-version)).

- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the buffer containing the 256-bit trie root result.

### B.7.5. `ext_trie_blake2_256_verify_proof` {#id-ext_trie_blake2_256_verify_proof}

Verifies a key/value pair against a Blake2 256-bit merkle root.

#### B.7.5.1. Version 1 - Prototype {#id-version-1-prototype-68}

    (func $ext_trie_blake2_256_verify_proof_version_1
        (param ${\sqrt[{i}]{{32}}}{)}{\left({p}{a}{r}{a}{m}$\right.}proof i64)
        (param ${k}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}value i64)
        (result i32))

Arguments  
- `root`: a pointer to the 256-bit merkle root.

- `proof`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an array containing the node proofs.

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the value.

- `return`: a value equal to *1* if the proof could be successfully verified or a value equal to *0* if otherwise.

#### B.7.5.2. Version 2 - Prototype {#id-version-2-prototype-13}

    (func $ext_trie_blake2_256_verify_proof_version_2
        (param ${\sqrt[{i}]{{32}}}{)}{\left({p}{a}{r}{a}{m}$\right.}proof i64)
        (param ${k}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}value i64)
        (param $version i32) (result i32))

Arguments  
- `root`: a pointer to the 256-bit merkle root.

- `proof`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an array containing the node proofs.

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the value.

- `version`: the state version ([Definition 205](chap-host-api#defn-state-version)).

- `return`: a value equal to *1* if the proof could be successfully verified or a value equal to *0* if otherwise.

### B.7.6. `ext_trie_keccak_256_verify_proof` {#id-ext_trie_keccak_256_verify_proof}

Verifies a key/value pair against a Keccak 256-bit merkle root.

#### B.7.6.1. Version 1 - Prototype {#id-version-1-prototype-69}

    (func $ext_trie_keccak_256_verify_proof_version_1
        (param ${\sqrt[{i}]{{32}}}{)}{\left({p}{a}{r}{a}{m}$\right.}proof i64)
        (param ${k}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}value i64)
        (result i32))

Arguments  
- `root`: a pointer to the 256-bit merkle root.

- `proof`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an array containing the node proofs.

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the value.

- `return`: a value equal to *1* if the proof could be successfully verified or a value equal to *0* if otherwise.

#### B.7.6.2. Version 2 - Prototype {#id-version-2-prototype-14}

    (func $ext_trie_keccak_256_verify_proof_version_2
        (param ${\sqrt[{i}]{{32}}}{)}{\left({p}{a}{r}{a}{m}$\right.}proof i64)
        (param ${k}{e}{y}{i}{64}{)}{\left({p}{a}{r}{a}{m}$\right.}value i64)
        (param $version i32) (result i32))

Arguments  
- `root`: a pointer to the 256-bit merkle root.

- `proof`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to an array containing the node proofs.

- `key`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the key.

- `value`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the value.

- `version`: the state version ([Definition 205](chap-host-api#defn-state-version)).

- `return`: a value equal to *1* if the proof could be successfully verified or a value equal to *0* if otherwise.

## B.8. Miscellaneous {#sect-misc-api}

Interface that provides miscellaneous functions for communicating between the runtime and the node.

### B.8.1. `ext_misc_print_num` {#id-ext_misc_print_num}

Print a number.

#### B.8.1.1. Version 1 - Prototype {#id-version-1-prototype-70}

    (func ${e}{x}{t}_{{m}}{i}{s}{c}_{{p}}{r}\int_{\nu}{m}_{{v}}{e}{r}{s}{i}{o}{n}_{{1}}{\left({p}{a}{r}{a}{m}$\right.}value i64))

Arguments  
- `value`: the number to be printed.

### B.8.2. `ext_misc_print_utf8` {#id-ext_misc_print_utf8}

Print a valid UTF8 encoded buffer.

#### B.8.2.1. Version 1 - Prototype {#id-version-1-prototype-71}

    (func ${e}{x}{t}_{{m}}{i}{s}{c}_{{p}}{r}\int_{{u}}{t}{f}{8}_{{v}}{e}{r}{s}{i}{o}{n}_{{1}}{\left({p}{a}{r}{a}{m}$\right.}data i64))

**Arguments**:

- : a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the valid buffer to be printed.

### B.8.3. `ext_misc_print_hex` {#id-ext_misc_print_hex}

Print any buffer in hexadecimal representation.

#### B.8.3.1. Version 1 - Prototype {#id-version-1-prototype-72}

    (func ${e}{x}{t}_{{m}}{i}{s}{c}_{{p}}{r}\int_{{h}}{e}{x}_{{v}}{e}{r}{s}{i}{o}{n}_{{1}}{\left({p}{a}{r}{a}{m}$\right.}data i64))

**Arguments**:

- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the buffer to be printed.

### B.8.4. `ext_misc_runtime_version` {#id-ext_misc_runtime_version}

Extract the Runtime version of the given Wasm blob by calling `Core_version` ([Section C.4.1](chap-runtime-api#defn-rt-core-version)). Returns the SCALE encoded runtime version or *None* ([Definition 190](id-cryptography-encoding#defn-option-type)) if the call fails. This function gets primarily used when upgrading Runtimes.

|     |                                                                                                                                                                                                                                                                                                                                              |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | Calling this function is very expensive and should only be done very occasionally. For getting the runtime version, it requires instantiating the Wasm blob ([Section 2.6.2](chap-state#sect-loading-runtime-code)) and calling the `Core_version` function ([Section C.4.1](chap-runtime-api#defn-rt-core-version)) in this blob. |

#### B.8.4.1. Version 1 - Prototype {#id-version-1-prototype-73}

    (func ${e}{x}{t}_{{m}}{i}{s}{c}_{{r}}{u}{n}{t}{i}{m}{e}_{{v}}{e}{r}{s}{i}{o}{n}_{{v}}{e}{r}{s}{i}{o}{n}_{{1}}{\left({p}{a}{r}{a}{m}$\right.}data i64) (result i64))

Arguments  
- `data`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the Wasm blob.

- `result`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the SCALE encoded *Option* value ([Definition 190](id-cryptography-encoding#defn-option-type)) containing the Runtime version of the given Wasm blob which is encoded as a byte array.

## B.9. Allocator {#sect-allocator-api}

The Polkadot Runtime does not include a memory allocator and relies on the Host API for all heap allocations. The beginning of this heap is marked by the `__heap_base` symbol exported by the Polkadot Runtime. No memory should be allocated below that address, to avoid clashes with the stack and data section. The same allocator made accessible by this Host API should be used for any other WASM memory allocations and deallocations outside the runtime e.g. when passing the SCALE-encoded parameters to Runtime API calls.

### B.9.1. `ext_allocator_malloc` {#id-ext_allocator_malloc}

Allocates the given number of bytes and returns the pointer to that memory location.

#### B.9.1.1. Version 1 - Prototype {#id-version-1-prototype-74}

    (func ${e}{x}{t}_{{a}}{l}{l}{o}{c}{a}\to{r}_{{m}}{a}{l}{l}{o}{c}_{{v}}{e}{r}{s}{i}{o}{n}_{{1}}{\left({p}{a}{r}{a}{m}$\right.}size i32) (result i32))

Arguments  
- `size`: the size of the buffer to be allocated.

- `result`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the allocated buffer.

### B.9.2. `ext_allocator_free` {#id-ext_allocator_free}

Free the given pointer.

#### B.9.2.1. Version 1 - Prototype {#id-version-1-prototype-75}

    (func ${e}{x}{t}_{{a}}{l}{l}{o}{c}{a}\to{r}_{{\mathfrak{{e}}}}{e}_{{v}}{e}{r}{s}{i}{o}{n}_{{1}}{\left({p}{a}{r}{a}{m}$\right.}ptr i32))

Arguments  
- `ptr`: a pointer ([Definition 202](chap-host-api#defn-runtime-pointer)) to the memory buffer to be freed.

## B.10. Logging {#sect-logging-api}

Interface that provides functions for logging from within the runtime.

###### Definition -def-num- Log Level {#defn-logging-log-level}

The **Log Level**, ${L}$, is a varying data type ([Definition 188](id-cryptography-encoding#defn-varrying-data-type)) and implies the emergency of the log. Possible log levels and the corresponding identifier is as follows:

$$
{L}={\left\lbrace\begin{matrix}{0}&\text{Error = 1}\\{1}&\text{Warn = 2}\\{2}&\text{Info = 3}\\{3}&\text{Debug = 4}\\{4}&\text{Trace = 5}\end{matrix}\right.}
$$

### B.10.1. `ext_logging_log` {#id-ext_logging_log}

Request to print a log message on the host. Note that this will be only displayed if the host is enabled to display log messages with given level and target.

#### B.10.1.1. Version 1 - Prototype {#id-version-1-prototype-76}

    (func $ext_logging_log_version_1
        (param $\le{v}{e}{l}{i}{32}{)}{\left({p}{a}{r}{a}{m}$\right.}target i64) (param $message i64))

Arguments  
- `level`: the log level ([Definition 214](chap-host-api#defn-logging-log-level)).

- `target`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the string which contains the path, module or location from where the log was executed.

- `message`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the UTF-8 encoded log message.

## B.11. Abort Handler {#id-abort-handler}

Interface for aborting the execution of the runtime.

### B.11.1. `ext_panic_handler_abort_on_panic` {#id-ext_panic_handler_abort_on_panic}

Aborts the execution of the runtime with a given message. Note that the message will be only displayed if the host is enabled to display those types of messages, which is implementation specific.

#### B.11.1.1. Version 1 - Prototype {#id-version-1-prototype-77}

    (func $ext_panic_handler_abort_on_panic_version_1
        (param $message i64))

Arguments  
- `message`: a pointer-size ([Definition 203](chap-host-api#defn-runtime-pointer-size)) to the UTF-8 encoded message.
