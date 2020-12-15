<TeXmacs|1.99.16>

<project|host-spec.tm>

<style|<tuple|book|old-dots|old-lengths>>

<\body>
  <appendix|Polkadot Host API><label|appendix-e>

  The Polkadot Host API is a set of functions that the Polkadot Host exposes
  to Runtime to access external functions needed for various reasons, such as
  the Storage of the content, access and manipulation, memory allocation, and
  also efficiency. The encoding of each data type is specified or referenced
  in this section. If the encoding is not mentioned, then the default Wasm
  encoding is used, such as little-endian byte ordering for integers.

  <\notation>
    <label|nota-re-api-at-state>By <math|\<cal-R\>\<cal-E\><rsub|B>> we refer
    to the API exposed by the Polkadot Host which interact, manipulate and
    response based on the state storage whose state is set at the end of the
    execution of block <math|B>.
  </notation>

  <\definition>
    <label|defn-runtime-pointer>The <strong|Runtime pointer-size> type is an
    <verbatim|i64> integer, representing two consecutive <verbatim|i32>
    integers in which the least significant one indicates the pointer to the
    memory buffer. The most significant one provides the size of the buffer.
    This pointer is the primary way to exchange data of arbitrary sizes
    between the Runtime and the Polkadot Host.
  </definition>

  <\definition>
    <label|defn-lexicographic-ordering><strong|Lexicographic ordering> refers
    to the ascending ordering of bytes or byte arrays, such as:

    <\equation*>
      <around*|[|0,0,2|]>\<less\><around*|[|0,1,1|]>\<less\><around*|[|0,2,0|]>\<less\><around*|[|1|]>\<less\><around*|[|1,1,0|]>\<less\><around*|[|2|]>\<less\><around*|[|\<ldots\>|]>
    </equation*>
  </definition>

  \ The functions are specified in each subsequent subsection for each
  category of those functions.

  <section|Storage>

  Interface for accessing the storage from within the runtime.

  <subsection|<verbatim|ext_storage_set>>

  Sets the value under a given key into storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_set_version_1

    (param $key i64) (param $value i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the key.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the value.
  </itemize>

  <subsection|<verbatim|ext_storage_get>>

  Retrieves the value associated with the given key from storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_get_version_1

    (param $key i64) (result i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the key.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> returning the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the value.
  </itemize>

  <subsection|<verbatim|ext_storage_read>>

  Gets the given key from storage, placing the value into a buffer and
  returning the number of bytes that the entry in storage has beyond the
  offset.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_read_version_1

    \ \ (param $key i64) (param $value_out i64) (param $offset u32) (result
    i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the key.

    <item><verbatim|value_out>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the buffer to which the value
    will be written to. This function will never write more then the length
    of the buffer, even if the value's length is bigger.

    <item><verbatim|offset>: an u32 integer containing the offset beyond the
    value should be read from.

    <item><verbatim|result>: a pointer-size (Definition
    <reference|defn-runtime-pointer>) pointing to a SCALE encoded
    <verbatim|Option> (Definition <reference|defn-option-type>) containing an
    unsinged 32-bit interger representing the number of bytes left at
    supplied <verbatim|offset>. Returns <verbatim|None> if the entry does not
    exists.
  </itemize>

  <subsection|<verbatim|ext_storage_clear>>

  Clears the storage of the given key and its value.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_clear_version_1

    (param $key_data i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the key.
  </itemize>

  <subsection|<verbatim|ext_storage_exists>>

  Checks whether the given key exists in storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_exists_version_1

    (param $key_data i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the key.

    <item><verbatim|return>: an i32 integer value equal to <verbatim|1> if
    the key exists or a value equal to <verbatim|0> if otherwise.
  </itemize>

  <subsection|<verbatim|ext_storage_clear_prefix>>

  Clear the storage of each key/value pair where the key starts with the
  given prefix.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_clear_prefix_version_1

    (param $prefix i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|prefix>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the prefix.
  </itemize>

  <subsection|<verbatim|ext_storage_append>>

  Append the SCALE encoded value to the SCALE encoded storage item at the
  given key. This function loads the storage item with the given key, assumes
  that the existing storage item is a SCALE encoded byte array and that the
  given value is a SCALE encoded item (type) of that array. It then adds that
  given value to the end of that byte array.

  \;

  For improved performance, this function does not decode the entire SCALE
  encoded byte array. Instead, it simply appends the value to the storage
  item and adjusts the length prefix <math|Enc<rsup|Len><rsub|SC>>.

  \;

  <strong|Warning>: If the storage item does not exist or is not SCALE
  encoded, the storage item will be set to the specified value, represented
  as a SCALE encoded byte array.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_append_version_1

    (param $key i64) (param $value i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the key.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> containing the value to be appended.
  </itemize-dot>

  <subsection|<verbatim|ext_storage_root>>

  Compute the storage root.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_root_version_1

    (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|return>: a regular pointer to the buffer containing the
    256-bit Blake2 storage root.
  </itemize>

  <subsection|<verbatim|ext_storage_changes_root>><label|sect-ext-storage-changes-root>

  Compute the root of the Changes Trie as described in Section
  <reference|sect-changes-trie>. The parent hash is a SCALE encoded block
  hash.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_changes_root_version_1

    (param $parent_hash i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|parent_hash>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the SCALE encoded
    block hash.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    256-bit Blake2 changes root.
  </itemize>

  <subsection|<verbatim|ext_storage_next_key>>

  Get the next key in storage after the given one in lexicographic order
  (Definition <reference|defn-lexicographic-ordering>). The key provided to
  this function may or may not exist in storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_next_key_version_1

    (param $key i64) (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the next key in lexicographic order.
  </itemize>

  <subsection|<verbatim|ext_storage_start_transaction>><label|sect-ext-storage-start-transaction>

  Start a new nested transaction. This allows to either commit or roll back
  all changes that are made after this call. For every transaction there must
  be a matching call to either <verbatim|ext_storage_rollback_transaction>
  (<reference|sect-ext-storage-rollback-transaction>) or
  <verbatim|ext_storage_commit_transaction>
  (<reference|sect-ext-storage-commit-transaction>). This is also effective
  for all values manipulated using the child storage API
  (<reference|sect-child-storage-api>).

  \;

  <strong|Warning>: This is a low level API that is potentially dangerous as
  it can easily result in unbalanced transactions. Runtimes should use high
  level storage abstractions.

  <subsubsection|Version 1 - Prototype>

  <verbatim|(func $ext_storage_start_transaction_version_1)>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  <subsection|<verbatim|ext_storage_rollback_transaction>><label|sect-ext-storage-rollback-transaction>

  Rollback the last transaction started by
  <verbatim|ext_storage_start_transaction>
  (<reference|sect-ext-storage-start-transaction>). Any changes made during
  that transaction are discarded.

  \;

  <strong|Warning>: Panics if there is no open transaction
  (<verbatim|ext_storage_start_transaction>
  (<reference|sect-ext-storage-start-transaction>) was not called)

  <subsubsection|Version 1 - Prototype>

  <verbatim|(func $ext_storage_rollback_transaction_version_1)>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  <subsection|<verbatim|ext_storage_commit_transaction>><label|sect-ext-storage-commit-transaction>

  Commit the last transaction started by <verbatim|ext_storage_start_transaction>
  (<reference|sect-ext-storage-start-transaction>). Any changes made during
  that transaction are committed to the main state.

  \;

  <strong|Warning>: Panics if there is no open transaction
  (<verbatim|ext_storage_start_transaction>
  (<reference|sect-ext-storage-start-transaction>) was not called)

  <subsubsection|Version 1 - Prototype>

  <verbatim|(func $ext_storage_commit_transaction_version_1)>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  <section|Child Storage><label|sect-child-storage-api>

  Interface for accessing the child storage from within the runtime.

  <\definition>
    <label|defn-child-storage-type><strong|Child storage> key is a unprefixed
    location of the child trie in the main trie.
  </definition>

  <subsection|<verbatim|ext_default_child_storage_set>>

  Sets the value under a given key into the child storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_set_version_1

    (param $child_storage_key i64) (param $key i64) (param $value i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the child storage
    key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the value.
  </itemize>

  <subsection|<verbatim|ext_default_child_storage_get>>

  Retrieves the value associated with the given key from the child storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_get_version_1

    (param $child_storage_key i64) (param $key i64) (result i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the child storage
    key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the value.
  </itemize>

  <subsection|<verbatim|ext_default_child_storage_read>>

  Gets the given key from storage, placing the value into a buffer and
  returning the number of bytes that the entry in storage has beyond the
  offset.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_read_version_1

    (param $child_storage_key i64) (param $key i64) (param $value_out i64)

    (param $offset u32) (result i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the child storage
    key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.

    <item><verbatim|value_out>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the buffer to which the value
    will be written to. This function will never write more then the length
    of the buffer, even if the value's length is bigger.

    <item><verbatim|offset>: an u32 integer containing the offset beyond the
    value should be read from.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the number of bytes written into the <strong|value_out>
    buffer. Returns <verbatim|None> if the entry does not exists.
  </itemize>

  <subsection|<verbatim|ext_default_child_storage_clear>>

  Clears the storage of the given key and its value from the child storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_clear_version_1

    \ \ (param $child_storage_key i64) (param $key i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the child storage
    key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.
  </itemize>

  <subsection|<verbatim|ext_default_child_storage_storage_kill>>

  Clears an entire child storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_storage_kill_version_1

    (param $child_storage_key i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the child storage
    key as defined in Definition <reference|defn-child-storage-type>.
  </itemize>

  <subsection|<verbatim|ext_default_child_storage_exists>>

  Checks whether the given key exists in the child storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_exists_version_1

    \ \ (param $child_storage_key i64) (param $key i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the child storage
    key as defined in Defintion <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.

    <item><verbatim|return>: an i32 integer value equal to <verbatim|1> if
    the key exists or a value equal to <verbatim|0> if otherwise.
  </itemize>

  <subsection|<verbatim|ext_default_child_storage_clear_prefix>>

  Clears the child storage of each key/value pair where the key starts with
  the given prefix.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_clear_prefix_version_1

    \ \ (param $child_storage_key i64) (param $prefix i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the child storage
    key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|prefix>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the prefix.
  </itemize>

  <subsection|<verbatim|ext_default_child_storage_root>>

  Commits all existing operations and computes the resulting child storage
  root.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_root_version_1

    \ \ (param $child_storage_key i64) (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the child storage
    key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded storage
    root.
  </itemize>

  <subsection|<verbatim|ext_default_child_storage_next_key>>

  Gets the next key in storage after the given one in lexicographic order
  (Definition <reference|defn-lexicographic-ordering>). The key provided to
  this function may or may not exist in storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_next_key_version_1

    \ \ (param $child_storage_key i64) (param $key i64) (return i64))
  </verbatim>

  \;

  <strong|<verbatim|>Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer> indicating the child storage
    key as defined in Definition <reference|defn-child-storage-type>.

    <item><strong|><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the next key in lexicographic order. Returns <verbatim|None>
    if the entry cannot be found.
  </itemize>

  <section|Crypto>

  Interfaces for working with crypto related types from within the runtime.

  <\definition>
    <label|defn-key-type-id>Cryptographic keys are saved in their own
    storages in order to avoid collision with each other. The storages are
    identified by their 4-byte ASCII <strong|key type ID>. The following
    known types are available:

    <\big-table|<tabular|<tformat|<cwith|1|1|2|2|cell-tborder|0ln>|<cwith|1|1|2|2|cell-bborder|1ln>|<cwith|2|2|2|2|cell-tborder|1ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|1|1|1|1|cell-tborder|0ln>|<cwith|1|1|1|1|cell-bborder|1ln>|<cwith|2|2|1|1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|1|1|cell-rborder|0ln>|<cwith|1|1|2|2|cell-lborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>>|<row|<cell|babe>|<cell|Key
    type for the Babe module>>|<row|<cell|gran>|<cell|Key type for the
    Grandpa module>>|<row|<cell|acco>|<cell|Key type for the controlling
    accounts>>|<row|<cell|imon>|<cell|Key type for the ImOnline
    module>>|<row|<cell|audi>|<cell|Key type for the AuthorityDiscovery
    module>>>>>>
      Table of known key type identifiers
    </big-table>
  </definition>

  <\definition>
    <label|defn-ecdsa-verify-error><strong|EcdsaVerifyError> is a varying
    data type as defined in Definition <reference|defn-varrying-data-type>
    and specifies the error type when using ECDSA recovery functionality.
    Following values are possible:

    <\big-table|<tabular|<tformat|<cwith|1|1|2|2|cell-tborder|0ln>|<cwith|1|1|2|2|cell-bborder|1ln>|<cwith|2|2|2|2|cell-tborder|1ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|1|1|1|1|cell-tborder|0ln>|<cwith|1|1|1|1|cell-bborder|1ln>|<cwith|2|2|1|1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|1|1|cell-rborder|0ln>|<cwith|1|1|2|2|cell-lborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>>|<row|<cell|0>|<cell|Incorrect
    value of R or S>>|<row|<cell|1>|<cell|Incorrect value of
    V>>|<row|<cell|2>|<cell|Invalid signature>>>>>>
      Table of error types in ECDSA recovery
    </big-table>
  </definition>

  <subsection|<verbatim|ext_crypto_ed25519_public_keys>>

  Returns all <verbatim|ed25519> public keys for the given key id from the
  keystore.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ed25519_public_keys_version_1

    (param $key_type_id i64) (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: an i32 integer indicating the key
    type ID as defined in Defintion <reference|defn-key-type-id>.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded 256-bit
    public keys.
  </itemize>

  <subsection|<verbatim|ext_crypto_ed25519_generate>>

  Generates an <verbatim|ed25519> key for the given key type using an
  optional BIP-39 seed and stores it in the keystore.

  \;

  <strong|Warning>: Panics if the key cannot be generated, such as when an
  invalid key type or invalid seed was provided.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ed25519_generate_version_1

    \ \ (param $key_type_id i32) (param $seed i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: an i32 integer indicating the key
    type ID as defined in Definition <reference|defn-key-type-id>.

    <item><verbatim|seed>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the BIP-39 seed which must be valid UTF8.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    <version-new|32-byte |256-bit >public key.
  </itemize>

  <subsection|<verbatim|ext_crypto_ed25519_sign>>

  Signs the given message with the <verbatim|ed25519> key that corresponds to
  the given public key and key type in the keystore.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ed25519_sign_version_1

    \ \ (param $key_type_id i32) (param $key i32) (param $msg i64) (return
    i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: an i32 integer indicating the key
    type ID as defined in Definition <reference|defn-key-type-id>.

    <item><verbatim|key>: a regular pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the message that is to be
    signed.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the signature. This function returns <verbatim|None> if the
    public key cannot be found in the key store.
  </itemize>

  <subsection|<verbatim|ext_crypto_ed25519_verify>><label|sect-ext-crypto-ed25519-verify>

  Verifies an <verbatim|ed25519> signature. Returns <verbatim|true> when the
  verification is either successful or batched. If no batching verification
  extension is registered, this function will fully verify the signature and
  return the result. If batching verification is registered, this function
  will push the data to the batch and return immediately. The caller can then
  get the result by calling <verbatim|ext_crypto_finish_batch_verify>
  (<reference|sect-ext-crypto-finish-batch-verify>).

  \;

  The verification extension is explained more in detail in
  <verbatim|ext_crypto_start_batch_verify>
  (<reference|sect-ext-crypto-start-batch-verify>).

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ed25519_verify_version_1

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a regular pointer to the buffer containing
    the 64-byte signature.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the message that is to be
    verified.

    <item><verbatim|key>: a regular pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|return>: a i32 integer value equal to <verbatim|1> if the
    signature is valid or batched or a value equal to <verbatim|0> if
    otherwise.
  </itemize>

  <subsection|<verbatim|ext_crypto_sr25519_public_keys>>

  Returns all <verbatim|sr25519> public keys for the given key id from the
  keystore.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_sr25519_public_keys_version_1

    (param $key_type_id i64) (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: an i32 integer containg the key
    type ID as defined in <reference|defn-key-type-id>.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded 256-bit
    public keys.
  </itemize>

  <subsection|<verbatim|ext_crypto_sr25519_generate>>

  Generates an <verbatim|sr25519> key for the given key type using an
  optional BIP-39 seed and stores it in the keystore.

  \;

  <strong|Warning>: Panics if the key cannot be generated, such as when an
  invalid key type or invalid seed was provided.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_sr25519_generate_version_1

    \ \ (param $key_type_id i32) (param $seed i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: an i32 integer containg the key ID
    as defined in Definition <reference|defn-key-type-id>.

    <item><verbatim|seed>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the BIP-39 seed which must be valid UTF8.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    256-bit public key.
  </itemize>

  <subsection|<verbatim|ext_crypto_sr25519_sign>>

  Signs the given message with the <verbatim|sr25519> key that corresponds to
  the given public key and key type in the keystore.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_sr25519_sign_version_1

    \ \ (param $key_type_id i32) (param $key i32) (param $msg i64) (return
    i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: an i32 integer containg the key ID
    as defined in Definition <reference|defn-key-type-id>

    <item><verbatim|key>: a regular pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the message that is to be
    signed.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the signature. This function returns <verbatim|None> if the
    public key cannot be found in the key store.
  </itemize>

  <subsection|<verbatim|ext_crypto_sr25519_verify>><label|sect-ext-crypto-sr25519-verify>

  Verifies an <verbatim|sr25519> signature. Only version 1 of this function
  supports deprecated Schnorr signatures introduced by the <em|schnorrkel>
  Rust library version 0.1.1 and should only be used for backward
  compatibility.

  \;

  Returns <verbatim|true> when the verification is either successful or
  batched. If no batching verification extension is registered, this function
  will fully verify the signature and return the result. If batching
  verification is registered, this function will push the data to the batch
  and return immediately. The caller can then get the result by calling
  <verbatim|ext_crypto_finish_batch_verify>
  (<reference|sect-ext-crypto-finish-batch-verify>).

  \;

  The verification extension is explained more in detail in
  <verbatim|ext_crypto_start_batch_verify>
  (<reference|sect-ext-crypto-start-batch-verify>).

  <subsubsection|Version 2 - Prototype>

  <\verbatim>
    (func $ext_crypto_sr25519_verify_version_2

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a regular pointer to the buffer containing
    the 64-byte signature.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the message that is to be
    verified.

    <item><verbatim|key>: a regular pointer to the buffer containing the
    <version-new|32-byte |256-bit >public key.

    <item><verbatim|return>: a i32 integer value equal to <verbatim|1> if the
    signature is valid or a value equal to <verbatim|0> if otherwise.
  </itemize>

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_sr25519_verify_version_1

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a regular pointer to the buffer containing
    the 64-byte signature.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the message that is to be
    verified.

    <item><verbatim|key>: a regular pointer to the buffer containing the
    <version-new|32-byte |256-bit >public key.

    <item><verbatim|return>: a i32 integer value equal to <verbatim|1> if the
    signature is valid or a value equal to <verbatim|0> if otherwise.
  </itemize>

  <subsection|<verbatim|ext_crypto_ecdsa_public_keys>>

  Returns all <verbatim|ecdsa> public keys for the given key id from the
  keystore.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ecdsa_public_keys_version_1

    (param $key_type_id i64) (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: an i32 integer containg the key
    type ID as defined in <reference|defn-key-type-id>.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded 33-byte
    compressed public keys.
  </itemize>

  <subsection|<verbatim|ext_crypto_ecdsa_generate>>

  Generates an <verbatim|ecdsa> key for the given key type using an optional
  BIP-39 seed and stores it in the keystore.

  \;

  <strong|Warning>: Panics if the key cannot be generated, such as when an
  invalid key type or invalid seed was provided.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ecdsa_generate_version_1

    \ \ (param $key_type_id i32) (param $seed i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: an i32 integer containg the key ID
    as defined in Definition <reference|defn-key-type-id>.

    <item><verbatim|seed>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the BIP-39 seed which must be valid UTF8.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    33-byte compressed public key.
  </itemize>

  <subsection|<verbatim|ext_crypto_ecdsa_sign>>

  Signs the given message with the <verbatim|ecdsa> key that corresponds to
  the given public key and key type in the keystore.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ecdsa_sign_version_1

    \ \ (param $key_type_id i32) (param $key i32) (param $msg i64) (return
    i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: an i32 integer containg the key ID
    as defined in Definition <reference|defn-key-type-id>

    <item><verbatim|key>: a regular pointer to the buffer containing the
    33-byte compressed public key.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the message that is to be
    signed.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the signature. The signature is 65-bytes in size, where the
    first 512-bits represent the signature and the other 8 bits represent the
    recovery ID. This function returns <verbatim|None> if the public key
    cannot be found in the key store.
  </itemize>

  <subsection|<verbatim|ext_crypto_ecdsa_verify>><label|sect-ext-crypto-ecdsa-verify>

  Verifies an <verbatim|ecdsa> signature. Returns <verbatim|true> when the
  verification is either successful or batched. If no batching verification
  extension is registered, this function will fully verify the signature and
  return the result. If batching verification is registered, this function
  will push the data to the batch and return immediately. The caller can then
  get the result by calling <verbatim|ext_crypto_finish_batch_verify>
  (<reference|sect-ext-crypto-finish-batch-verify>).

  \;

  The verification extension is explained more in detail in
  <verbatim|ext_crypto_start_batch_verify>
  (<reference|sect-ext-crypto-start-batch-verify>).

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ecdsa_verify_version_1

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a regular pointer to the buffer containing
    the 65-byte signature. The signature is 65-bytes in size, where the first
    512-bits represent the signature and the other 8 bits represent the
    recovery ID.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the message that is to be
    verified.

    <item><verbatim|key>: a regular pointer to the buffer containing the
    33-byte compressed public key.

    <item><verbatim|return>: a i32 integer value equal to <verbatim|1> if the
    signature is valid or a value equal to <verbatim|0> if otherwise.
  </itemize>

  <subsection|<verbatim|ext_crypto_secp256k1_ecdsa_recover>>

  Verify and recover a <verbatim|secp256k1> ECDSA signature.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_secp256k1_ecdsa_recover_version_1

    \ \ (param $sig i32) (param $msg i32) (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a regular pointer to the buffer containing
    the 65-byte signature in RSV format. V should be either <verbatim|0/1> or
    <verbatim|27/28>.

    <item><verbatim|msg>: a regular pointer to the buffer containing the
    <version-new|32-byte |256-bit >Blake2 hash of the message.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Result> as defined in Definition <reference|defn-result-type>.
    On success it contains the 64-byte recovered public key or an error type
    as defined in Definition <reference|defn-ecdsa-verify-error> on failure.
  </itemize>

  <subsection|<verbatim|ext_crypto_secp256k1_ecdsa_recover_compressed>>

  Verify and recover a <verbatim|secp256k1> ECDSA signature.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_secp256k1_ecdsa_recover_compressed_version_1

    \ \ (param $sig i32) (param $msg i32) (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a regular pointer to the buffer containing
    the 65-byte signature in RSV format. V should be either <verbatim|0/1> or
    <verbatim|27/28>.

    <item><verbatim|msg>: a regular pointer to the buffer containing the
    256-bit Blake2 hash of the message.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Result> as defined in Definiton <reference|defn-result-type>.
    On success it contains the 33-byte recovered public key in compressed
    form on success or an error type as defined in Definition
    <reference|defn-ecdsa-verify-error> on failure.
  </itemize>

  <subsection|<verbatim|ext_crypto_start_batch_verify>><label|sect-ext-crypto-start-batch-verify>

  Starts the verification extension. The extension is a separate background
  process and is used to parallel-verify signatures which are pushed to the
  batch with <verbatim|ext_crypto_ed25519_verify>
  (<reference|sect-ext-crypto-ed25519-verify>),
  <verbatim|ext_crypto_sr25519_verify> (<reference|sect-ext-crypto-sr25519-verify>)
  or <verbatim|ext_crypto_ecdsa_verify> (<reference|sect-ext-crypto-ecdsa-verify>).
  Verification will start immediatly and the Runtime can retrieve the result
  when calling <verbatim|ext_crypto_finish_batch_verify>
  (<reference|sect-ext-crypto-finish-batch-verify>).

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_start_batch_verify_version_1)
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item>None.
  </itemize-dot>

  <subsection|<verbatim|ext_crypto_finish_batch_verify>><label|sect-ext-crypto-finish-batch-verify>

  Finish verifying the batch of signatures since the last call to this
  function. Blocks until all the signatures are verified. Panics if the
  verification extension was not registered
  <verbatim|(ext_crypto_start_batch_verify>
  (<reference|sect-ext-crypto-start-batch-verify>) was not called).

  \;

  <strong|Warning>: Panics if no verification extension is registered
  <verbatim|(ext_crypto_start_batch_verify>
  (<reference|sect-ext-crypto-start-batch-verify>) was not called.)

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_finish_batch_verify_version_1

    (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item><verbatim|return>: an i32 integer value equal to <verbatim|1> if
    all the signatures are valid or a value equal to <verbatim|0> if one or
    more of the signatures are invalid.
  </itemize-dot>

  <section|Hashing>

  Interface that provides functions for hashing with different algorithms.

  <subsection|<verbatim|ext_hashing_keccak_256>>

  Conducts a 256-bit Keccak hash.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_hashing_keccak_256_version_1

    \ \ (param $data i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the data to be hashed.

    <item><verbatim|return>: a reglar pointer to the buffer containing the
    256-bit hash result.
  </itemize>

  <subsection|<verbatim|ext_hashing_sha2_256>>

  Conducts a 256-bit Sha2 hash.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_hashing_sha2_256_version_1

    \ \ (param $data i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the data to be hashed.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    256-bit hash result.
  </itemize>

  <subsection|<verbatim|ext_hashing_blake2_128>>

  Conducts a 128-bit Blake2 hash.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_hashing_blake2_128_version_1

    \ \ (param $data i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the data to be hashed.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    128-bit hash result.
  </itemize>

  <subsection|<verbatim|ext_hashing_blake2_256>>

  Conducts a 256-bit Blake2 hash.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_hashing_blake2_256_version_1

    \ \ (param $data i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the data to be hashed.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    256-bit hash result.
  </itemize>

  <subsection|<verbatim|ext_hashing_twox_64>>

  Conducts a 64-bit xxHash hash.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_hashing_twox_64_version_1

    \ \ (param $data i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the data to be hashed.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    64-bit hash result.
  </itemize>

  <subsection|<verbatim|ext_hashing_twox_128>>

  Conducts a 128-bit xxHash hash.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_hashing_twox_128_version_1

    \ \ (param $data i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the data to be hashed.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    128-bit hash result.
  </itemize>

  <subsection|<verbatim|ext_hashing_twox_256>>

  Conducts a 256-bit xxHash hash.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_hashing_twox_256_version_1

    \ \ (param $data i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the data to be hashed.

    <item><verbatim|return>: a regular pointer to the buffer containing the
    256-bit hash result.
  </itemize>

  <section|Offchain>

  The Offchain Workers allow the execution of long-running and possibly
  non-deterministic tasks (e.g. web requests, encryption/decryption and
  signing of data, random number generation, CPU-intensive computations,
  enumeration/aggregation of on-chain data, etc.) which could otherwise
  require longer than the block execution time. Offchain Workers have their
  own execution environment. This separation of concerns is to make sure that
  the block production is not impacted by the long-running tasks.

  \;

  All data and results generated by Offchain workers are unique per node and
  nondeterministic. Information can be propagated to other nodes by
  submitting a transaction that should be included in the next block. As
  Offchain workers runs on their own execution environment they have access
  to their own separate storage. There are two different types of storage
  available which are defined in Definitions F.1 and F.2.

  <\definition>
    <label|defn-persistent-storage><strong|Persistent storage> is
    non-revertible and not fork-aware. It means that any value set by the
    offchain worker is persisted even if that block (at which the worker is
    called) is reverted as non-canonical (meaning that the block was
    surpassed by a longer chain). The value is available for the worker that
    is re-run at the new (different block with the same block number) and
    future blocks. This storage can be used by offchain workers to handle
    forks and coordinate offchain workers running on different forks.
  </definition>

  <\definition>
    <label|defn-local-storage><strong|Local storage> is revertible and
    fork-aware. It means that any value set by the offchain worker triggered
    at a certain block is reverted if that block is reverted as
    non-canonical. The value is NOT available for the worker that is re-run
    at the next or any future blocks.
  </definition>

  <\definition>
    <label|defn-http-status-codes><strong|HTTP status codes> that can get
    returned by certain Offchain HTTP functions.

    <\itemize-dot>
      <item><verbatim|0>: the specified request identifier is invalid.
    </itemize-dot>

    <\itemize-dot>
      <item><verbatim|10>: the deadline for the started request was reached.
    </itemize-dot>

    <\itemize-dot>
      <item><verbatim|20>: an error has occurred during the request, e.g. a
      timeout or the remote server has closed the connection. On returning
      this error code, the request is considered destroyed and must be
      reconstructed again.
    </itemize-dot>

    <\itemize-dot>
      <item><verbatim|100-999>: the request has finished with the given HTTP
      status code.
    </itemize-dot>
  </definition>

  <\definition>
    <label|defn-http-error><strong|HTTP error> is a varying data type as
    defined in Definition <reference|defn-varrying-data-type> and specifies
    the error types of certain HTTP functions. Following values are possible:

    <\big-table|<tabular|<tformat|<cwith|1|1|2|2|cell-tborder|0ln>|<cwith|1|1|2|2|cell-bborder|1ln>|<cwith|2|2|2|2|cell-tborder|1ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|1|1|1|1|cell-tborder|0ln>|<cwith|1|1|1|1|cell-bborder|1ln>|<cwith|2|2|1|1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|1|1|cell-rborder|0ln>|<cwith|1|1|2|2|cell-lborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>>|<row|<cell|0>|<cell|The
    deadline was reached>>|<row|<cell|1>|<cell|There was an IO error while
    processing the request>>|<row|<cell|2>|<cell|The ID of the request is
    invalid>>>>>>
      Table of possible HTTP error types
    </big-table>
  </definition>

  <subsection|<verbatim|ext_offchain_is_validator>>

  Check whether the local node is a potential validator. Even if this
  function returns <verbatim|1>, it does not mean that any keys are
  configured or that the validator is registered in the chain.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_is_validator_version_1 (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|return>: a i32 integer which is equal to <verbatim|1> if
    the local node is a potential validator or a integer equal to
    <verbatim|0> if it is not.
  </itemize>

  <subsection|<verbatim|ext_offchain_submit_transaction>>

  Given an extrinsic as a SALE encoded byte array, the system decodes the
  byte array and submits the extrinsic in the inherent pool as an extrinsic
  to be included in the next produced block.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_submit_transaction_version_1 (param $data i64)
    (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the byte array storing the
    encoded extrinsic.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Result> as defined in Definition <reference|defn-result-type>.
    Neither on success or failure is there any additional data provided. The
    cause of a failure is implementation specific.
  </itemize>

  <subsection|<verbatim|ext_offchain_network_state>>

  Returns the SCALE encoded, opaque information about the local node's
  network state.

  <\definition>
    <label|defn-opaque-network-state>The <verbatim|OpaqueNetworkState>
    structure, <math|O<rsub|NS>>, is a SCALE encoded blob holding information
    about the the PeerId, <math|P<rsub|id>>, of the local node and a list of
    Multiaddresses, (<math|M<rsub|0>\<ldots\>M<rsub|n>>), the node knows it
    can be reached at:

    <\eqnarray*>
      <tformat|<table|<row|<cell|O<rsub|NS>>|<cell|=>|<cell|<around*|(|P<rsub|id>,<around*|(|M<rsub|0>\<ldots\>M<rsub|n>|)><rsub|>|)>>>>>
    </eqnarray*>

    where:

    <\eqnarray*>
      <tformat|<table|<row|<cell|P<rsub|id>>|<cell|=>|<cell|<around*|(|b<rsub|0>\<ldots\>b<rsub|n>|)>>>|<row|<cell|M<rsub|>>|<cell|=>|<cell|<around*|(|b<rsub|0>\<ldots\>b<rsub|n>|)>>>>>
    </eqnarray*>

    The information contained in this structure is naturally opaque to the
    caller of this function.
  </definition>

  <strong|<subsubsection|Version 1 - Prototype>>

  <\verbatim>
    (func $ext_offchain_network_state_version_1 (result i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Result> as defined in Definition <reference|defn-result-type>.
    On success it contains the <verbatim|OpaqueNetworkState> structure as
    defined in Definition <reference|defn-opaque-network-state>. On failure,
    an empty value is yielded where its cause is implementation specific.
  </itemize>

  <subsection|<verbatim|ext_offchain_timestamp>>

  Returns current timestamp.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_timestamp_version_1 (result u64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|result>: an u64 integer indicating the current UNIX
    timestamp as defined in Definition <reference|defn-unix-time>.
  </itemize>

  <subsection|<verbatim|ext_offchain_sleep_until>>

  Pause the execution until `<math|>deadline` is reached.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_sleep_until_version_1 (param $deadline u64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|deadline>: an u64 integer specifying the UNIX timestamp
    as defined in Definition <reference|defn-unix-time>.
  </itemize>

  <subsection|<verbatim|ext_offchain_random_seed>>

  Generates a random seed. This is a truly random non deterministic seed
  generated by the host environment.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_random_seed_version_1 (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|result>: a regular pointer to the buffer containing the
    256-bit seed.
  </itemize>

  <subsection|<verbatim|ext_offchain_local_storage_set>>

  Sets a value in the local storage. This storage is not part of the
  consensus, it's only accessible by the offchain worker tasks running on the
  same machine and is persisted between runs.

  <strong|<subsubsection|Version 1 - Prototype>>

  <\verbatim>
    (func $ext_offchain_local_storage_set_version_1

    \ \ (param $kind i32) (param $key i64) (param $value i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|kind>: an i32 integer indicating the storage kind. A
    value equal to <verbatim|1> is used for a persistent storage as defined
    in Definition <reference|defn-offchain-persistent-storage> and a value
    equal to <verbatim|2> for local storage as defined in Definition
    <reference|defn-offchain-local-storage>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the value.
  </itemize>

  <subsection|<verbatim|ext_offchain_local_storage_clear>>

  Remove a value from the local storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_local_storage_clear_version_1

    \ \ (param $kind i32) (param $key i64))
  </verbatim>

  \;

  Arguments:

  <\itemize-dot>
    <item><verbatim|kind>: an i32 integer indicating the storage kind. A
    value equal to <verbatim|1> is used for a persistent storage as defined
    in Definition <reference|defn-offchain-persistent-storage> and a value
    equal to <verbatim|2> for local storage as defined in Definition
    <reference|defn-offchain-local-storage>.

    <item>key: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.
  </itemize-dot>

  <subsection|<verbatim|ext_offchain_local_storage_compare_and_set>>

  Sets a new value in the local storage if the condition matches the current
  value.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_local_storage_compare_and_set_version_1

    \ \ (param $kind i32) (param $key i64) (param $old_value i64) (param
    $new_value i64)

    \ \ (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|kind>: an i32 integer indicating the storage kind. A
    value equal to <verbatim|1> is used for a persistent storage as defined
    in Definition <reference|defn-offchain-persistent-storage> and a value
    equal to <verbatim|2> for local storage as defined in Definition
    <reference|defn-offchain-local-storage>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.

    <item><verbatim|old_value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the old key.

    <item><verbatim|new_value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the new value.

    <item><verbatim|result>: an i32 integer equal to <verbatim|1> if the new
    value has been set or a value equal to <verbatim|0> if otherwise.
  </itemize>

  <subsection|<verbatim|ext_offchain_local_storage_get>>

  Gets a value from the local storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_local_storage_get_version_1

    \ \ (param $kind i32) (param $key i64) (result i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|kind>: an i32 integer indicating the storage kind. A
    value equal to <verbatim|1> is used for a persistent storage as defined
    in Definition <reference|defn-offchain-persistent-storage> and a value
    equal to <verbatim|2> for local storage as defined in Definition
    <reference|defn-offchain-local-storage>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the key.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the value or the corresponding key.
  </itemize>

  <subsection|<verbatim|ext_offchain_http_request_start>>

  Initiates a HTTP request given by the HTTP method and the URL. Returns the
  id of a newly started request.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_http_request_start_version_1

    \ \ (param $method i64) (param $uri i64) (param $meta i64) (result i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|method>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the HTTP method. Possible
    values are <verbatim|\PGET\Q> and <verbatim|\PPOST\Q>.

    <item><verbatim|urli>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the URI.

    <item><verbatim|meta>: a future-reserved field containing additional,
    SCALE encoded parameters. Currently, an empty array should be passed.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Result> as defined in Definition <reference|defn-result-type>
    containing the i16 ID of the newly started request. On failure no
    additionally data is provided.
  </itemize>

  <subsection|<verbatim|ext_offchain_http_request_add_header>>

  Append header to the request. Returns an error if the request identifier is
  invalid, <verbatim|http_response_wait> has already been called on the
  specified request identifier, the deadline is reached or an I/O error has
  happened (e.g. the remote has closed the connection).

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_http_request_add_header_version_1

    \ \ (param $request_id i32) (param $name i64) (param $value i64) (result
    i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|request_id>: an i32 integer indicating the ID of the
    started request.

    <item><verbatim|name>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the HTTP header name.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the HTTP header value.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Result> as defined in Definition <reference|defn-result-type>.
    Neither on success or failure is there any additional data provided.
  </itemize>

  <subsection|<verbatim|ext_offchain_http_request_write_body>>

  Writes a chunk of the request body. Returns a non-zero value in case the
  deadline is reached or the chunk could not be written.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_http_request_write_body_version_1

    \ \ (param $request_id i32) (param $chunk i64) (param $deadline i64)
    (result i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|request_id>: an i32 integer indicating the ID of the
    started request.

    <item><verbatim|chunk>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the chunk of bytes. Writing
    an empty chunk finalizes the request.

    <item><verbatim|deadline>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the UNIX timestamp as defined in Definition
    <reference|defn-unix-time>. Passing <verbatim|None> blocks indefinitely.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Result> as defined Definition <reference|defn-result-type>. On
    success, no additional data is provided. On error it contains the HTTP
    error type as defined in Definition <reference|defn-http-error>.
  </itemize>

  <subsection|<verbatim|ext_offchain_http_response_wait>>

  Returns an array of request statuses (the length is the same as IDs). Note
  that if deadline is not provided the method will block indefinitely,
  otherwise unready responses will produce <verbatim|DeadlineReached> status.

  <strong|<subsubsection|Version 1- Prototype>>

  <\verbatim>
    (func $ext_offchain_http_response_wait_version_1

    \ \ (param $ids i64) (param $deadline i64) (result i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|ids>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded array of
    started request IDs.

    <item><verbatim|deadline>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the UNIX timestamp as defined in Definition 1.10. Passing
    <verbatim|None> blocks indefinitely.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded array of
    request statuses as defined in Definition
    <reference|defn-http-status-codes>.
  </itemize>

  <subsection|<verbatim|ext_offchain_http_response_headers>>

  Read all HTTP response headers. Returns an array of key/value pairs.
  Response headers must be read before the response body.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_http_response_headers_version_1

    \ \ (param $request_id i32) (result i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|request_id>: an i32 integer indicating the ID of the
    started request.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating a SCALE encoded array of
    key/value pairs.
  </itemize>

  <subsection|<verbatim|ext_offchain_http_response_read_body>>

  Reads a chunk of body response to the given buffer. Returns the number of
  bytes written or an error in case a deadline is reached or the server
  closed the connection. If <verbatim|0> is returned it means that the
  response has been fully consumed and the <verbatim|request_id> is now
  invalid. This implies that response headers must be read before draining
  the body.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_http_response_read_body_version_1

    \ \ (param $request_id i32) (param $buffer i64) (param $deadline i64)
    (result i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|request_id>: an i32 integer indicating the ID of the
    started request.

    <item><verbatim|buffer>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the buffer where the body
    gets written to.

    <item><verbatim|deadline>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the UNIX timestamp as defined in Definition
    <reference|defn-unix-time>. Passing <verbatim|None> will block
    indefinitely.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Result> as defined in Definition <reference|defn-result-type>.
    On success it contains an i32 integer specifying the number of bytes
    written or a HTTP error type as defined in Definition
    <reference|defn-http-error> on faiure.
  </itemize>

  <section|Trie>

  Interface that provides trie related functionality.

  <subsection|<verbatim|ext_trie_blake2_256_root>>

  Compute a 256-bit Blake2 trie root formed from the iterated items.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_trie_blake2_256_root_version_1

    \ \ (param $data i64) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the iterated items from which
    the trie root gets formed. The items consist of a SCALE encoded array
    containing arbitrary key/value pairs.

    <item><verbatim|result>: a regular pointer to the buffer containing the
    256-bit trie root.
  </itemize>

  <subsection|<verbatim|ext_trie_blake2_256_ordered_root>>

  Compute a 256-bit Blake2 trie root formed from the enumerated items.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_trie_blake2_256_ordered_root_version_1

    \ \ (param $data i64) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the enumerated items from
    which the trie root gets formed. The items consist of a SCALE encoded
    array containing only values, where the corresponding key of each value
    is the index of the item in the array, starting at 0. The keys are
    compact encoded integers as described in Definition
    <reference|defn-sc-len-encoding>.

    <item><verbatim|result>: a regular pointer to the buffer containing the
    256-bit trie root result.
  </itemize>

  <subsection|<verbatim|ext_trie_keccak_256_root>>

  Compute a 256-bit Keccak trie root formed from the iterated items.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_trie_keccak_256_root_version_1

    (param $data i64) (result i32)
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the iterated items from which
    the trie root gets formed. The items consist of a SCALE encoded array
    containing arbitrary key/value pairs.

    <item>result: a regular pointer to the buffer containing the 256-bit trie
    root.
  </itemize-dot>

  <subsection|<verbatim|ext_trie_keccak_256_ordered_root>>

  Compute a 256-bit Keccak trie root formed from the enumerated items.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_trie_keccak_256_ordered_root_version_1

    \ \ (param $data i64) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the enumerated items from
    which the trie root gets formed. The items consist of a SCALE encoded
    array containing only values, where the corresponding key of each value
    is the index of the item in the array, starting at 0. The keys are
    compact encoded integers as described in Definition
    <reference|defn-sc-len-encoding>.

    <item><verbatim|result>: a regular pointer to the buffer containing the
    256-bit trie root result.
  </itemize>

  <section|Miscellaneous>

  Interface that provides miscellaneous functions for communicating between
  the runtime and the node.

  <subsection|<verbatim|ext_misc_chain_id>>

  Returns the current relay chain identifier.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_misc_chain_id_version_1 (result i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|result>: the current relay chain identifier.
  </itemize>

  <subsection|<verbatim|ext_misc_print_num>>

  Print a number.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_misc_print_num_version_1 (param $value i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|value>: the number to be printed.
  </itemize>

  <subsection|<verbatim|ext_misc_print_utf8>>

  Print a valid <verbatim|UTF8> buffer.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_misc_print_utf8_version_1 (param $data i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the valid <verbatim|UTF8>
    buffer to be printed.
  </itemize>

  <subsection|<verbatim|ext_misc_print_hex>>

  Print any buffer in hexadecimal representation.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_misc_print_hex_version_1 (param $data i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the buffer to be printed.
  </itemize>

  <subsection|<verbatim|ext_misc_runtime_version>>

  Extract the Runtime version of the given Wasm blob by calling
  <verbatim|Core_version> as defined in Definition
  <reference|defn-rt-core-version>. Returns the SCALE encoded runtime version
  or <verbatim|None> as defined in Definition <reference|defn-option-type> if
  the call fails. This function gets primarily used when upgrading Runtimes.

  \;

  <strong|Warning>: Calling this function is very expensive and should only
  be done very occasionally. For getting the runtime version, it requires
  instantiating the Wasm blob as described in Section
  <reference|sect-loading-runtime-code> and calling a function in this blob.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_misc_runtime_version_version_1 (param $data i64) (result i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the Wasm blob.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the Runtime version of the given Wasm blob.
  </itemize>

  <section|Allocator>

  Provides functionality for calling into the memory allocator.

  <subsection|<verbatim|ext_allocator_malloc>>

  Allocates the given number of bytes and returns the pointer to that memory
  location.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_allocator_malloc_version_1 (param $size i32) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|size>: the size of the buffer to be allocated.

    <item><verbatim|result>: a regular pointer to the allocated buffer.
  </itemize>

  <subsection|<verbatim|ext_allocator_free>>

  Free the given pointer.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_allocator_free_version_1 (param $ptr i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|ptr>: a regular pointer to the memory buffer to be freed.
  </itemize>

  <section|Logging>

  Interface that provides functions for logging from within the runtime.

  <\definition>
    <label|defn-logging-log-level><strong|Log Level> is a varying data type
    as defined in Definition <reference|defn-varrying-data-type> and implies
    the emergency of the log. Possible levels and it's identifiers are
    defined in the following table.

    <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Level>
    >>|<row|<cell|0>|<cell|Error = 1>>|<row|<cell|1>|<cell|Warn =
    2>>|<row|<cell|2>|<cell|Info = 3>>|<row|<cell|3>|<cell|Debug =
    4>>|<row|<cell|4>|<cell|Trace = 5>>>>>>
      Log Levels for the logging interface
    </big-table>
  </definition>

  <subsection|<verbatim|ext_logging_log>>

  Request to print a log message on the host. Note that this will be only
  displayed if the host is enabled to display log messages with given level
  and target.

  \;

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_logging_log_version_1

    \ \ (param $level i32) (param $target i64) (param $message i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|level>: the log level as defined in Definition
    <reference|defn-logging-log-level>.

    <item><verbatim|target>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the string which contains the
    path, module or location from where the log was executed.

    <item><verbatim|message>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer> indicating the log message.
  </itemize>
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|8>
    <associate|page-first|97>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
    <associate|section-nr|1>
    <associate|subsection-nr|7>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|appendix-e|<tuple|A|67>>
    <associate|auto-1|<tuple|A|67>>
    <associate|auto-10|<tuple|A.1.4.1|68>>
    <associate|auto-100|<tuple|A.3|82>>
    <associate|auto-101|<tuple|A.5.1|82>>
    <associate|auto-102|<tuple|A.5.1.1|82>>
    <associate|auto-103|<tuple|A.5.2|82>>
    <associate|auto-104|<tuple|A.5.2.1|82>>
    <associate|auto-105|<tuple|A.5.3|83>>
    <associate|auto-106|<tuple|A.5.3.1|83>>
    <associate|auto-107|<tuple|A.5.4|83>>
    <associate|auto-108|<tuple|A.5.4.1|83>>
    <associate|auto-109|<tuple|A.5.5|83>>
    <associate|auto-11|<tuple|A.1.5|68>>
    <associate|auto-110|<tuple|A.5.5.1|83>>
    <associate|auto-111|<tuple|A.5.6|83>>
    <associate|auto-112|<tuple|A.5.6.1|83>>
    <associate|auto-113|<tuple|A.5.7|84>>
    <associate|auto-114|<tuple|A.5.7.1|84>>
    <associate|auto-115|<tuple|A.5.8|84>>
    <associate|auto-116|<tuple|A.5.8.1|84>>
    <associate|auto-117|<tuple|A.5.9|84>>
    <associate|auto-118|<tuple|A.5.9.1|84>>
    <associate|auto-119|<tuple|A.5.10|85>>
    <associate|auto-12|<tuple|A.1.5.1|68>>
    <associate|auto-120|<tuple|A.5.10.1|85>>
    <associate|auto-121|<tuple|A.5.11|85>>
    <associate|auto-122|<tuple|A.5.11.1|85>>
    <associate|auto-123|<tuple|A.5.12|85>>
    <associate|auto-124|<tuple|A.5.12.1|85>>
    <associate|auto-125|<tuple|A.5.13|86>>
    <associate|auto-126|<tuple|A.5.13.1|86>>
    <associate|auto-127|<tuple|A.5.14|86>>
    <associate|auto-128|<tuple|A.5.14.1|86>>
    <associate|auto-129|<tuple|A.5.15|86>>
    <associate|auto-13|<tuple|A.1.6|69>>
    <associate|auto-130|<tuple|A.5.15.1|86>>
    <associate|auto-131|<tuple|A.5.16|87>>
    <associate|auto-132|<tuple|A.5.16.1|87>>
    <associate|auto-133|<tuple|A.6|87>>
    <associate|auto-134|<tuple|A.6.1|87>>
    <associate|auto-135|<tuple|A.6.1.1|87>>
    <associate|auto-136|<tuple|A.6.2|87>>
    <associate|auto-137|<tuple|A.6.2.1|87>>
    <associate|auto-138|<tuple|A.6.3|88>>
    <associate|auto-139|<tuple|A.6.3.1|88>>
    <associate|auto-14|<tuple|A.1.6.1|69>>
    <associate|auto-140|<tuple|A.6.4|88>>
    <associate|auto-141|<tuple|A.6.4.1|88>>
    <associate|auto-142|<tuple|A.7|88>>
    <associate|auto-143|<tuple|A.7.1|88>>
    <associate|auto-144|<tuple|A.7.1.1|88>>
    <associate|auto-145|<tuple|A.7.2|88>>
    <associate|auto-146|<tuple|A.7.2.1|89>>
    <associate|auto-147|<tuple|A.7.3|89>>
    <associate|auto-148|<tuple|A.7.3.1|89>>
    <associate|auto-149|<tuple|A.7.4|89>>
    <associate|auto-15|<tuple|A.1.7|69>>
    <associate|auto-150|<tuple|A.7.4.1|89>>
    <associate|auto-151|<tuple|A.7.5|89>>
    <associate|auto-152|<tuple|A.7.5.1|89>>
    <associate|auto-153|<tuple|A.8|89>>
    <associate|auto-154|<tuple|A.8.1|90>>
    <associate|auto-155|<tuple|A.8.1.1|90>>
    <associate|auto-156|<tuple|A.8.2|90>>
    <associate|auto-157|<tuple|A.8.2.1|90>>
    <associate|auto-158|<tuple|A.9|90>>
    <associate|auto-159|<tuple|A.4|90>>
    <associate|auto-16|<tuple|A.1.7.1|69>>
    <associate|auto-160|<tuple|A.9.1|?>>
    <associate|auto-161|<tuple|A.9.1.1|?>>
    <associate|auto-162|<tuple|A.10.1.1|?>>
    <associate|auto-163|<tuple|A.10.2|?>>
    <associate|auto-164|<tuple|A.10.2.1|?>>
    <associate|auto-165|<tuple|A.10.3|?>>
    <associate|auto-166|<tuple|A.10.3.1|?>>
    <associate|auto-167|<tuple|A.10.4|?>>
    <associate|auto-168|<tuple|A.10.4.1|?>>
    <associate|auto-169|<tuple|A.10.5|?>>
    <associate|auto-17|<tuple|A.1.8|69>>
    <associate|auto-170|<tuple|A.10.5.1|?>>
    <associate|auto-171|<tuple|A.10.6|?>>
    <associate|auto-172|<tuple|A.10.6.1|?>>
    <associate|auto-173|<tuple|A.10.7|?>>
    <associate|auto-18|<tuple|A.1.8.1|69>>
    <associate|auto-19|<tuple|A.1.9|69>>
    <associate|auto-2|<tuple|A.1|67>>
    <associate|auto-20|<tuple|A.1.9.1|69>>
    <associate|auto-21|<tuple|A.1.10|70>>
    <associate|auto-22|<tuple|A.1.10.1|70>>
    <associate|auto-23|<tuple|A.1.11|70>>
    <associate|auto-24|<tuple|A.1.11.1|70>>
    <associate|auto-25|<tuple|A.1.12|70>>
    <associate|auto-26|<tuple|A.1.12.1|70>>
    <associate|auto-27|<tuple|A.1.13|70>>
    <associate|auto-28|<tuple|A.1.13.1|71>>
    <associate|auto-29|<tuple|A.2|71>>
    <associate|auto-3|<tuple|A.1.1|67>>
    <associate|auto-30|<tuple|A.2.1|71>>
    <associate|auto-31|<tuple|A.2.1.1|71>>
    <associate|auto-32|<tuple|A.2.2|71>>
    <associate|auto-33|<tuple|A.2.2.1|71>>
    <associate|auto-34|<tuple|A.2.3|71>>
    <associate|auto-35|<tuple|A.2.3.1|72>>
    <associate|auto-36|<tuple|A.2.4|72>>
    <associate|auto-37|<tuple|A.2.4.1|72>>
    <associate|auto-38|<tuple|A.2.5|72>>
    <associate|auto-39|<tuple|A.2.5.1|72>>
    <associate|auto-4|<tuple|A.1.1.1|67>>
    <associate|auto-40|<tuple|A.2.6|72>>
    <associate|auto-41|<tuple|A.2.6.1|72>>
    <associate|auto-42|<tuple|A.2.7|73>>
    <associate|auto-43|<tuple|A.2.7.1|73>>
    <associate|auto-44|<tuple|A.2.8|73>>
    <associate|auto-45|<tuple|A.2.8.1|73>>
    <associate|auto-46|<tuple|A.2.9|73>>
    <associate|auto-47|<tuple|A.2.9.1|73>>
    <associate|auto-48|<tuple|A.3|74>>
    <associate|auto-49|<tuple|A.1|74>>
    <associate|auto-5|<tuple|A.1.2|67>>
    <associate|auto-50|<tuple|A.2|74>>
    <associate|auto-51|<tuple|A.3.1|74>>
    <associate|auto-52|<tuple|A.3.1.1|74>>
    <associate|auto-53|<tuple|A.3.2|74>>
    <associate|auto-54|<tuple|A.3.2.1|74>>
    <associate|auto-55|<tuple|A.3.3|75>>
    <associate|auto-56|<tuple|A.3.3.1|75>>
    <associate|auto-57|<tuple|A.3.4|75>>
    <associate|auto-58|<tuple|A.3.4.1|75>>
    <associate|auto-59|<tuple|A.3.5|75>>
    <associate|auto-6|<tuple|A.1.2.1|67>>
    <associate|auto-60|<tuple|A.3.5.1|75>>
    <associate|auto-61|<tuple|A.3.6|76>>
    <associate|auto-62|<tuple|A.3.6.1|76>>
    <associate|auto-63|<tuple|A.3.7|76>>
    <associate|auto-64|<tuple|A.3.7.1|76>>
    <associate|auto-65|<tuple|A.3.8|76>>
    <associate|auto-66|<tuple|A.3.8.1|76>>
    <associate|auto-67|<tuple|A.3.8.2|77>>
    <associate|auto-68|<tuple|A.3.9|77>>
    <associate|auto-69|<tuple|A.3.9.1|77>>
    <associate|auto-7|<tuple|A.1.3|68>>
    <associate|auto-70|<tuple|A.3.10|77>>
    <associate|auto-71|<tuple|A.3.10.1|77>>
    <associate|auto-72|<tuple|A.3.11|78>>
    <associate|auto-73|<tuple|A.3.11.1|78>>
    <associate|auto-74|<tuple|A.3.12|78>>
    <associate|auto-75|<tuple|A.3.12.1|78>>
    <associate|auto-76|<tuple|A.3.13|78>>
    <associate|auto-77|<tuple|A.3.13.1|78>>
    <associate|auto-78|<tuple|A.3.14|79>>
    <associate|auto-79|<tuple|A.3.14.1|79>>
    <associate|auto-8|<tuple|A.1.3.1|68>>
    <associate|auto-80|<tuple|A.3.15|79>>
    <associate|auto-81|<tuple|A.3.15.1|79>>
    <associate|auto-82|<tuple|A.3.16|79>>
    <associate|auto-83|<tuple|A.3.16.1|79>>
    <associate|auto-84|<tuple|A.4|80>>
    <associate|auto-85|<tuple|A.4.1|80>>
    <associate|auto-86|<tuple|A.4.1.1|80>>
    <associate|auto-87|<tuple|A.4.2|80>>
    <associate|auto-88|<tuple|A.4.2.1|80>>
    <associate|auto-89|<tuple|A.4.3|80>>
    <associate|auto-9|<tuple|A.1.4|68>>
    <associate|auto-90|<tuple|A.4.3.1|80>>
    <associate|auto-91|<tuple|A.4.4|80>>
    <associate|auto-92|<tuple|A.4.4.1|80>>
    <associate|auto-93|<tuple|A.4.5|81>>
    <associate|auto-94|<tuple|A.4.5.1|81>>
    <associate|auto-95|<tuple|A.4.6|81>>
    <associate|auto-96|<tuple|A.4.6.1|81>>
    <associate|auto-97|<tuple|A.4.7|81>>
    <associate|auto-98|<tuple|A.4.7.1|81>>
    <associate|auto-99|<tuple|A.5|81>>
    <associate|defn-child-storage-type|<tuple|A.4|71>>
    <associate|defn-ecdsa-verify-error|<tuple|A.6|74>>
    <associate|defn-http-error|<tuple|A.10|82>>
    <associate|defn-http-status-codes|<tuple|A.9|82>>
    <associate|defn-key-type-id|<tuple|A.5|74>>
    <associate|defn-lexicographic-ordering|<tuple|A.3|67>>
    <associate|defn-local-storage|<tuple|A.8|82>>
    <associate|defn-logging-log-level|<tuple|A.12|90>>
    <associate|defn-opaque-network-state|<tuple|A.11|?>>
    <associate|defn-persistent-storage|<tuple|A.7|82>>
    <associate|defn-runtime-pointer|<tuple|A.2|67>>
    <associate|nota-re-api-at-state|<tuple|A.1|67>>
    <associate|sect-child-storage-api|<tuple|A.2|71>>
    <associate|sect-ext-crypto-ecdsa-verify|<tuple|A.3.12|78>>
    <associate|sect-ext-crypto-ed25519-verify|<tuple|A.3.4|75>>
    <associate|sect-ext-crypto-finish-batch-verify|<tuple|A.3.16|79>>
    <associate|sect-ext-crypto-sr25519-verify|<tuple|A.3.8|76>>
    <associate|sect-ext-crypto-start-batch-verify|<tuple|A.3.15|79>>
    <associate|sect-ext-storage-changes-root|<tuple|A.1.9|?>>
    <associate|sect-ext-storage-commit-transaction|<tuple|A.1.13|70>>
    <associate|sect-ext-storage-rollback-transaction|<tuple|A.1.12|70>>
    <associate|sect-ext-storage-start-transaction|<tuple|A.1.11|70>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.1>|>
        Table of known key type identifiers
      </surround>|<pageref|auto-49>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.2>|>
        Table of error types in ECDSA recovery
      </surround>|<pageref|auto-50>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.3>|>
        Table of possible HTTP error types
      </surround>|<pageref|auto-100>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.4>|>
        Log Levels for the logging interface
      </surround>|<pageref|auto-157>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Polkadot Host API> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      A.1<space|2spc>Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      <with|par-left|<quote|1tab>|A.1.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|2tab>|A.1.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|A.1.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_get>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|2tab>|A.1.2.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1tab>|A.1.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_read>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|2tab>|A.1.3.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|A.1.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_clear>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|2tab>|A.1.4.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|1tab>|A.1.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_exists>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|2tab>|A.1.5.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|A.1.6<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_clear_prefix>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|2tab>|A.1.6.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|1tab>|A.1.7<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_append>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|2tab>|A.1.7.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|1tab>|A.1.8<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|2tab>|A.1.8.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|1tab>|A.1.9<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_changes_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|2tab>|A.1.9.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|1tab>|A.1.10<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_next_key>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|2tab>|A.1.10.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|1tab>|A.1.11<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_start_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <with|par-left|<quote|2tab>|A.1.11.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|1tab>|A.1.12<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_rollback_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|2tab>|A.1.12.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|1tab>|A.1.13<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_commit_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>

      <with|par-left|<quote|2tab>|A.1.13.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      A.2<space|2spc>Child Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>

      <with|par-left|<quote|1tab>|A.2.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <with|par-left|<quote|2tab>|A.2.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|1tab>|A.2.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_get>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32>>

      <with|par-left|<quote|2tab>|A.2.2.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <with|par-left|<quote|1tab>|A.2.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_read>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34>>

      <with|par-left|<quote|2tab>|A.2.3.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35>>

      <with|par-left|<quote|1tab>|A.2.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_clear>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36>>

      <with|par-left|<quote|2tab>|A.2.4.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37>>

      <with|par-left|<quote|1tab>|A.2.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_storage_kill>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38>>

      <with|par-left|<quote|2tab>|A.2.5.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-39>>

      <with|par-left|<quote|1tab>|A.2.6<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_exists>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40>>

      <with|par-left|<quote|2tab>|A.2.6.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41>>

      <with|par-left|<quote|1tab>|A.2.7<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_clear_prefix>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-42>>

      <with|par-left|<quote|2tab>|A.2.7.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-43>>

      <with|par-left|<quote|1tab>|A.2.8<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-44>>

      <with|par-left|<quote|2tab>|A.2.8.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-45>>

      <with|par-left|<quote|1tab>|A.2.9<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_next_key>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-46>>

      <with|par-left|<quote|2tab>|A.2.9.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-47>>

      A.3<space|2spc>Crypto <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-48>

      <with|par-left|<quote|1tab>|A.3.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ed25519_public_keys>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-51>>

      <with|par-left|<quote|2tab>|A.3.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-52>>

      <with|par-left|<quote|1tab>|A.3.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ed25519_generate>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-53>>

      <with|par-left|<quote|2tab>|A.3.2.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-54>>

      <with|par-left|<quote|1tab>|A.3.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ed25519_sign>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-55>>

      <with|par-left|<quote|2tab>|A.3.3.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-56>>

      <with|par-left|<quote|1tab>|A.3.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ed25519_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-57>>

      <with|par-left|<quote|2tab>|A.3.4.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-58>>

      <with|par-left|<quote|1tab>|A.3.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_sr25519_public_keys>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-59>>

      <with|par-left|<quote|2tab>|A.3.5.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-60>>

      <with|par-left|<quote|1tab>|A.3.6<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_sr25519_generate>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-61>>

      <with|par-left|<quote|2tab>|A.3.6.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-62>>

      <with|par-left|<quote|1tab>|A.3.7<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_sr25519_sign>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-63>>

      <with|par-left|<quote|2tab>|A.3.7.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-64>>

      <with|par-left|<quote|1tab>|A.3.8<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_sr25519_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-65>>

      <with|par-left|<quote|2tab>|A.3.8.1<space|2spc>Version 2 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-66>>

      <with|par-left|<quote|2tab>|A.3.8.2<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-67>>

      <with|par-left|<quote|1tab>|A.3.9<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ecdsa_public_keys>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-68>>

      <with|par-left|<quote|2tab>|A.3.9.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-69>>

      <with|par-left|<quote|1tab>|A.3.10<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ecdsa_generate>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-70>>

      <with|par-left|<quote|2tab>|A.3.10.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-71>>

      <with|par-left|<quote|1tab>|A.3.11<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ecdsa_sign>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-72>>

      <with|par-left|<quote|2tab>|A.3.11.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-73>>

      <with|par-left|<quote|1tab>|A.3.12<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ecdsa_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-74>>

      <with|par-left|<quote|2tab>|A.3.12.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-75>>

      <with|par-left|<quote|1tab>|A.3.13<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_secp256k1_ecdsa_recover>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-76>>

      <with|par-left|<quote|2tab>|A.3.13.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-77>>

      <with|par-left|<quote|1tab>|A.3.14<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_secp256k1_ecdsa_recover_compressed>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-78>>

      <with|par-left|<quote|2tab>|A.3.14.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-79>>

      <with|par-left|<quote|1tab>|A.3.15<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_start_batch_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-80>>

      <with|par-left|<quote|2tab>|A.3.15.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-81>>

      <with|par-left|<quote|1tab>|A.3.16<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_finish_batch_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-82>>

      <with|par-left|<quote|2tab>|A.3.16.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-83>>

      A.4<space|2spc>Hashing <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-84>

      <with|par-left|<quote|1tab>|A.4.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_keccak_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-85>>

      <with|par-left|<quote|2tab>|A.4.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-86>>

      <with|par-left|<quote|1tab>|A.4.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_sha2_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-87>>

      <with|par-left|<quote|2tab>|A.4.2.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-88>>

      <with|par-left|<quote|1tab>|A.4.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_blake2_128>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-89>>

      <with|par-left|<quote|2tab>|A.4.3.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-90>>

      <with|par-left|<quote|1tab>|A.4.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_blake2_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-91>>

      <with|par-left|<quote|2tab>|A.4.4.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-92>>

      <with|par-left|<quote|1tab>|A.4.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_twox_64>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-93>>

      <with|par-left|<quote|2tab>|A.4.5.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-94>>

      <with|par-left|<quote|1tab>|A.4.6<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_twox_128>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-95>>

      <with|par-left|<quote|2tab>|A.4.6.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-96>>

      <with|par-left|<quote|1tab>|A.4.7<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_twox_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-97>>

      <with|par-left|<quote|2tab>|A.4.7.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-98>>

      A.5<space|2spc>Offchain <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-99>

      <with|par-left|<quote|1tab>|A.5.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_is_validator>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-101>>

      <with|par-left|<quote|2tab>|A.5.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-102>>

      <with|par-left|<quote|1tab>|A.5.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_submit_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-103>>

      <with|par-left|<quote|2tab>|A.5.2.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-104>>

      <with|par-left|<quote|1tab>|A.5.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_network_state>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-105>>

      <with|par-left|<quote|2tab>|A.5.3.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-106>>

      <with|par-left|<quote|1tab>|A.5.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_timestamp>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-107>>

      <with|par-left|<quote|2tab>|A.5.4.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-108>>

      <with|par-left|<quote|1tab>|A.5.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_sleep_until>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-109>>

      <with|par-left|<quote|2tab>|A.5.5.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-110>>

      <with|par-left|<quote|1tab>|A.5.6<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_random_seed>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-111>>

      <with|par-left|<quote|2tab>|A.5.6.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-112>>

      <with|par-left|<quote|1tab>|A.5.7<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_local_storage_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-113>>

      <with|par-left|<quote|2tab>|A.5.7.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-114>>

      <with|par-left|<quote|1tab>|A.5.8<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_local_storage_compare_and_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-115>>

      <with|par-left|<quote|2tab>|A.5.8.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-116>>

      <with|par-left|<quote|1tab>|A.5.9<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_local_storage_get>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-117>>

      <with|par-left|<quote|2tab>|A.5.9.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-118>>

      <with|par-left|<quote|1tab>|A.5.10<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_request_start>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-119>>

      <with|par-left|<quote|2tab>|A.5.10.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-120>>

      <with|par-left|<quote|1tab>|A.5.11<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_request_add_header>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-121>>

      <with|par-left|<quote|2tab>|A.5.11.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-122>>

      <with|par-left|<quote|1tab>|A.5.12<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_request_write_body>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-123>>

      <with|par-left|<quote|2tab>|A.5.12.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-124>>

      <with|par-left|<quote|1tab>|A.5.13<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_response_wait>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-125>>

      <with|par-left|<quote|2tab>|A.5.13.1<space|2spc>Version 1- Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-126>>

      <with|par-left|<quote|1tab>|A.5.14<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_response_headers>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-127>>

      <with|par-left|<quote|2tab>|A.5.14.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-128>>

      <with|par-left|<quote|1tab>|A.5.15<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_response_read_body>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-129>>

      <with|par-left|<quote|2tab>|A.5.15.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-130>>

      A.6<space|2spc>Trie <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-131>

      <with|par-left|<quote|1tab>|A.6.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_trie_blake2_256_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-132>>

      <with|par-left|<quote|2tab>|A.6.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-133>>

      <with|par-left|<quote|1tab>|A.6.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_trie_blake2_256_ordered_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-134>>

      <with|par-left|<quote|2tab>|A.6.2.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-135>>

      <with|par-left|<quote|1tab>|A.6.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_trie_keccak_256_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-136>>

      <with|par-left|<quote|2tab>|A.6.3.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-137>>

      <with|par-left|<quote|1tab>|A.6.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_trie_keccak_256_ordered_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-138>>

      <with|par-left|<quote|2tab>|A.6.4.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-139>>

      A.7<space|2spc>Miscellaneous <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-140>

      <with|par-left|<quote|1tab>|A.7.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_chain_id>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-141>>

      <with|par-left|<quote|2tab>|A.7.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-142>>

      <with|par-left|<quote|1tab>|A.7.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_print_num>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-143>>

      <with|par-left|<quote|2tab>|A.7.2.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-144>>

      <with|par-left|<quote|1tab>|A.7.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_print_utf8>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-145>>

      <with|par-left|<quote|2tab>|A.7.3.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-146>>

      <with|par-left|<quote|1tab>|A.7.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_print_hex>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-147>>

      <with|par-left|<quote|2tab>|A.7.4.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-148>>

      <with|par-left|<quote|1tab>|A.7.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_runtime_version>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-149>>

      <with|par-left|<quote|2tab>|A.7.5.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-150>>

      A.8<space|2spc>Allocator <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-151>

      <with|par-left|<quote|1tab>|A.8.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_allocator_malloc>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-152>>

      <with|par-left|<quote|2tab>|A.8.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-153>>

      <with|par-left|<quote|1tab>|A.8.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_allocator_free>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-154>>

      <with|par-left|<quote|2tab>|A.8.2.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-155>>

      A.9<space|2spc>Logging <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-156>

      <with|par-left|<quote|1tab>|A.9.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_logging_log>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-158>>

      <with|par-left|<quote|2tab>|A.9.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-159>>

      A.10<space|2spc>Offchain <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-160>

      <with|par-left|<quote|1tab>|A.10.1<space|2spc>offchain_is_validator
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-161>>

      <with|par-left|<quote|2tab>|A.10.1.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-162>>

      <with|par-left|<quote|1tab>|A.10.2<space|2spc>offchain_submit_transaction
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-163>>

      <with|par-left|<quote|2tab>|A.10.2.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-164>>

      <with|par-left|<quote|1tab>|A.10.3<space|2spc>offchain_network_state
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-165>>

      <with|par-left|<quote|2tab>|A.10.3.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-166>>

      <with|par-left|<quote|1tab>|A.10.4<space|2spc>offchain_timestamp
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-167>>

      <with|par-left|<quote|2tab>|A.10.4.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-168>>

      <with|par-left|<quote|1tab>|A.10.5<space|2spc>offchain_sleep_until
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-169>>

      <with|par-left|<quote|2tab>|A.10.5.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-170>>

      <with|par-left|<quote|1tab>|A.10.6<space|2spc>offchain_random_seed
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-171>>

      <with|par-left|<quote|2tab>|A.10.6.1<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-172>>

      <with|par-left|<quote|1tab>|A.10.7<space|2spc>offchain_local_storage_set
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-173>>
    </associate>
  </collection>
</auxiliary>