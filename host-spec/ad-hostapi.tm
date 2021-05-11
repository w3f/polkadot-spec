<TeXmacs|1.99.16>

<project|host-spec.tm>

<style|<tuple|tmbook|algorithmacs-style>>

<\body>
  <appendix|Polkadot Host API><label|sect-host-api>

  The Polkadot Host API is a set of functions that the Polkadot Host exposes
  to Runtime to access external functions needed for various reasons, such as
  the Storage of the content, access and manipulation, memory allocation, and
  also efficiency. The encoding of each data type is specified or referenced
  in this section. If the encoding is not mentioned, then the default Wasm
  encoding is used, such as little-endian byte ordering for integers.

  <\notation>
    <label|nota-host-api-at-state>By <math|\<cal-R\>\<cal-E\><rsub|B>> we
    refer to the API exposed by the Polkadot Host which interact, manipulate
    and response based on the state storage whose state is set at the end of
    the execution of block <math|B>.
  </notation>

  <\definition>
    <label|defn-runtime-pointer>The <with|font-series|bold|Runtime pointer
    >type is a <verbatim|i32> integer representing a pointer to data in
    memory. This pointer is the primary way to exchange data of fixed/known
    size between the Runtime and Polkadot Host.
  </definition>

  <\definition>
    <label|defn-runtime-pointer-size>The <strong|Runtime pointer-size> type
    is an <verbatim|i64> integer, representing two consecutive <verbatim|i32>
    integers. The least significant is a pointer to the data in memory. The
    most significant provides the size of the data in bytes. This
    representation is the primary way to exchange data of arbitrary/dynamic
    sizes between the Runtime and the Polkadot Host.
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

  <subsection|<verbatim|ext_storage_set>><label|sect-storage-set>

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
    <reference|defn-runtime-pointer-size> containing the key.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> containing the value.
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
    <reference|defn-runtime-pointer-size> containing the key.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> returning the SCALE encoded
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
    <reference|defn-runtime-pointer-size> containing the key.

    <item><verbatim|value_out>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> containing the buffer to which the
    value will be written to. This function will never write more then the
    length of the buffer, even if the value's length is bigger.

    <item><verbatim|offset>: an i32 integer containing the offset beyond the
    value should be read from.

    <item><verbatim|result>: a pointer-size (Definition
    <reference|defn-runtime-pointer-size>) pointing to a SCALE encoded
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
    <reference|defn-runtime-pointer-size> containing the key.
  </itemize>

  <subsection|<verbatim|ext_storage_exists>>

  Checks whether the given key exists in storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_storage_exists_version_1

    (param $key_data i64) (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> containing the key.

    <item><verbatim|return>:a boolean equal to <verbatim|true> if the key
    does exist, <verbatim|false> if otherwise.
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
    <reference|defn-runtime-pointer-size> containing the prefix.
  </itemize>

  <subsection|<verbatim|ext_storage_append>>

  Append the SCALE encoded value to a SCALE encoded sequence (Definition
  <reference|defn-scale-list>) at the given key. This function assumes that
  the existing storage item is either empty or a SCALE encoded sequence and
  that the value to append is also SCALE encoded and of the same type as the
  items in the existing sequence.

  \;

  To improve performance, this function is allowed to skip decoding the
  entire SCALE encoded sequence and instead can just append the new item to
  the end of the existing data and increment the length prefix
  <math|Enc<rsup|Len><rsub|SC>>.

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
    <reference|defn-runtime-pointer-size> containing the key.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> containing the value to be
    appended.
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
    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
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
    Definition <reference|defn-runtime-pointer-size> indicating the SCALE
    encoded block hash.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the value.
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
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|value_out>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the buffer to which the
    value will be written to. This function will never write more then the
    length of the buffer, even if the value's length is bigger.

    <item><verbatim|offset>: an i32 integer containing the offset beyond the
    value should be read from.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the key.
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
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.
  </itemize>

  <subsubsection|Version 2>

  <\verbatim>
    (func $ext_default_child_storage_storage_kill_version_2

    (param $child_storage_key i64) (param $limit u32) (return i8)
  </verbatim>

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|limit>: a SCALE encoded <verbatim|Option> as defined in
    Definition <reference|defn-option-type> containing the <verbatim|u32>
    intiger indicationg the limit of child storage entries to delete. This
    function call wipes <strong|all> pending (non-finalized) changes which
    should be committed to the specified child storage keys, including
    deleting up to <verbatim|limit> number of database entries in
    lexicographic order. No limit is applied when this value is
    <verbatim|None>.

    <item><verbatim|result>: a SCALE encoded boolean equal to
    <verbatim|false> if there are some keys remaining in the child trie or
    <verbatim|true> if otherwise.
  </itemize-dot>

  <subsubsection|Version 3>

  <\verbatim>
    (func $ext_default_child_storage_storage_kill_version3

    (param $child_storage_key i64) (param $limit u32) (return i32)
  </verbatim>

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|limit>: a SCALE encoded <verbatim|Option> as defined in
    Definition <reference|defn-option-type> containing the <verbatim|u32>
    intiger indicationg the limit of child storage entries to delete. This
    function call wipes <strong|all> pending (non-finalized) changes which
    should be committed to the specified child storage keys, including
    deleting up to <verbatim|limit> number of database entries in
    lexicographic order. No limit is applied when this value is
    <verbatim|None>.

    <item><verbatim|result>: a pointer to the following SCALE encoded varying
    type:

    <\equation*>
      <choice|<tformat|<table|<row|<cell|0<space|1em>No keys remain \ in the
      child trie. Followed by u32.>>|<row|<cell|1<space|1em>At least one key
      still resides. Followed by u32.>>>>>
    </equation*>

    The additional, following integer indicates the number of entries that
    were deleted by the function call. This must consider the specificed
    <verbatim|limit>.

    \;
  </itemize-dot>

  <subsection|<verbatim|ext_default_child_storage_exists>>

  Checks whether the given key exists in the child storage.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_default_child_storage_exists_version_1

    \ \ (param $child_storage_key i64) (param $key i64) (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|child_storage_key>: a pointer-size as defined in
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Defintion <reference|defn-child-storage-type>.

    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|return>: a boolean equal to <verbatim|true> if the key
    does exist, <verbatim|false> if otherwise..
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
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|prefix>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the prefix.
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
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    storage root.
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
    Definition <reference|defn-runtime-pointer-size> indicating the child
    storage key as defined in Definition <reference|defn-child-storage-type>.

    <item><strong|><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the next key in lexicographic order. Returns <verbatim|None>
    if the entry cannot be found.
  </itemize>

  <section|Crypto>

  Interfaces for working with crypto related types from within the runtime.

  <\definition>
    <label|defn-key-type-id>Cryptographic keys are stored in seperate key
    stores based on their intended use case. The seperate key stores are
    identified by a 4-byte ASCII <strong|key type identifier>. The following
    known types are available:

    <\big-table|<tabular|<tformat|<cwith|1|1|2|2|cell-tborder|0ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|1|1|1|1|cell-tborder|0ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|1|1|cell-rborder|0ln>|<cwith|1|1|2|2|cell-lborder|0ln>|<cwith|2|2|2|2|cell-hyphen|n>|<cwith|2|2|1|1|cell-rborder|0ln>|<cwith|2|2|2|2|cell-lborder|0ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-bborder|0ln>|<cwith|3|3|1|-1|cell-tborder|0ln>|<cwith|2|2|1|1|cell-lborder|0ln>|<cwith|2|2|2|2|cell-rborder|0ln>|<table|<row|<cell|<strong|Id>>|<cell|<strong|Description>>>|<row|<cell|acco>|<cell|Key
    type for the controlling accounts>>|<row|<cell|babe>|<cell|Key type for
    the Babe module>>|<row|<cell|gran>|<cell|Key type for the Grandpa
    module>>|<row|<cell|imon>|<cell|Key type for the ImOnline
    module>>|<row|<cell|audi>|<cell|Key type for the AuthorityDiscovery
    module>>|<row|<cell|para>|<cell|Key type for the Parachain Validator
    Key>>|<row|<cell|asgn>|<cell|Key type for the Parachain Assignment
    Key>>>>>>
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

  Returns all <verbatim|ed25519> public keys for the given key identifier
  from the keystore.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ed25519_public_keys_version_1

    (param $key_type_id i32) (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: a 32-bit pointer to the key type
    identifier as defined in Defintion <reference|defn-key-type-id>.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> to an SCALE encoded \ 256-bit
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
    <item><strong|><verbatim|key_type_id>: a 32-bit pointer to the key type
    identifier as defined in Definition <reference|defn-key-type-id>.

    <item><verbatim|seed>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the BIP-39 seed which must be valid UTF8.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
    256-bit public key.
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
    <item><strong|><verbatim|key_type_id>: a 32-bit pointer to the key type
    identifier as defined in Definition <reference|defn-key-type-id>.

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be signed.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the 64-byte signature. This function returns <verbatim|None>
    if the public key cannot be found in the key store.
  </itemize>

  <subsection|<verbatim|ext_crypto_ed25519_verify>><label|sect-ext-crypto-ed25519-verify>

  Verifies a <verbatim|ed25519> signature.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ed25519_verify_version_1

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a 32-bit pointer to the buffer containing
    the 64-byte signature.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be verified.

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|return>: a boolean equal to <verbatim|true> if the
    signature is valid or <verbatim|false> if otherwise.
  </itemize>

  <subsection|<strong|<verbatim|ext_crypto_ed25519_batch_verify>>>

  Registers a <verbatim|ed25519> signature for batch verification. Batch
  verification must be enabled by calling
  <verbatim|ext_crypto_start_batch_verify> as described in Section
  <reference|sect-ext-crypto-start-batch-verify>. If batch verification is
  not enabled, then the signature is verified immediately. To get the result
  of the verification batch, <verbatim|ext_crypto_finish_batch_verify> as
  described in Section <reference|sect-ext-crypto-finish-batch-verify> must
  be called.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ed25519_batch_verify_version_1

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i8))
  </verbatim>

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item><strong|><verbatim|sig>: a 32-bit pointer to the buffer containing
    the 64-byte signature.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be verified.

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|return>: a boolean equal to <verbatim|true> if the
    signature is batched or valid, <verbatim|false> if otherwise.
  </itemize-dot>

  <subsection|<verbatim|ext_crypto_sr25519_public_keys>>

  Returns all <verbatim|sr25519> public keys for the given key id from the
  keystore.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_sr25519_public_keys_version_1

    (param $key_type_id i32) (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|key_type_id>: a 32-bit pointer to the key type
    identifier as defined in <reference|defn-key-type-id>.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    256-bit public keys.
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
    <item><strong|><verbatim|key_type_id>: a 32-bit pointer to the key
    identifier as defined in Definition <reference|defn-key-type-id>.

    <item><verbatim|seed>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the BIP-39 seed which must be valid UTF8.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
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
    <item><strong|><verbatim|key_type_id>: a 32-bit pointer to the key
    identifier as defined in Definition <reference|defn-key-type-id>

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be signed.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the 64-byte signature. This function returns <verbatim|None>
    if the public key cannot be found in the key store.
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

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_sr25519_verify_version_1

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a 32-bit pointer to the buffer containing
    the 64-byte signature.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be verified.

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|return>: a boolean equal to <verbatim|true> if the
    signature is valid, <verbatim|false> if otherwise.
  </itemize>

  <subsubsection|Version 2 - Prototype>

  <\verbatim>
    (func $ext_crypto_sr25519_verify_version_2

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a 32-bit pointer to the buffer containing
    the 64-byte signature.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be verified.

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|return>: a boolean equal to <verbatim|true> if the
    signature is valid, <verbatim|false> if otherwise.
  </itemize>

  <subsection|<strong|<verbatim|ext_crypto_sr25519_batch_verify>>>

  Registers a <verbatim|sr25519> signature for batch verification. Batch
  verification must be enabled by calling
  <verbatim|ext_crypto_start_batch_verify> as described in Section
  <reference|sect-ext-crypto-start-batch-verify>. If batch verification is
  not enabled, then the signature is verified immediately. To get the result
  of the verification batch, <verbatim|ext_crypto_finish_batch_verify> as
  described in Section <reference|sect-ext-crypto-finish-batch-verify> must
  be called.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_sr25519_batch_verify_version_1

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a 32-bit pointer to the buffer containing
    the 64-byte signature.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be verified.

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|return>: a boolean equal to <verbatim|true> if the
    signature is batched or valid, <verbatim|false> if otherwise.
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
    <item><strong|><verbatim|key_type_id>: a 32-bit pointer to the key type
    identifier as defined in <reference|defn-key-type-id>.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    33-byte compressed public keys.
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
    <item><strong|><verbatim|key_type_id>: a 32-bit pointer to the key
    identifier as defined in Definition <reference|defn-key-type-id>.

    <item><verbatim|seed>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the BIP-39 seed which must be valid UTF8.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
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
    <item><strong|><verbatim|key_type_id>: a 32-bit pointer to the key
    identifier as defined in Definition <reference|defn-key-type-id>

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    33-byte compressed public key.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be signed.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a 32-bit pointer to the buffer containing
    the 65-byte signature. The signature is 65-bytes in size, where the first
    512-bits represent the signature and the other 8 bits represent the
    recovery ID.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be verified.

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    33-byte compressed public key.

    <item><verbatim|return>: a boolean equal to <verbatim|true> if the
    signature is valid, <verbatim|false> if otherwise.
  </itemize>

  <subsection|<strong|<verbatim|ext_ecdsa_batch_verify>>>

  Registers a <verbatim|ecdsa> signature for batch verification. Batch
  verification must be enabled by calling
  <verbatim|ext_crypto_start_batch_verify> as described in Section
  <reference|sect-ext-crypto-start-batch-verify>. If batch verification is
  not enabled, then the signature is verified immediately. To get the result
  of the verification batch, <verbatim|ext_crypto_finish_batch_verify> as
  described in Section <reference|sect-ext-crypto-finish-batch-verify> must
  be called.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_ecdsa_batch_verify_version_1

    \ \ (param $sig i32) (param $msg i64) (param $key i32) (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|sig>: a 32-bit pointer to the buffer containing
    the 64-byte signature.

    <item><verbatim|msg>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the message that is to
    be verified.

    <item><verbatim|key>: a 32-bit pointer to the buffer containing the
    256-bit public key.

    <item><verbatim|return>: a boolean equal to <verbatim|true> if the
    signature is batched or valid, <verbatim|false> if otherwise.
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
    <item><strong|><verbatim|sig>: a 32-bit pointer to the buffer containing
    the 65-byte signature in RSV format. V should be either <verbatim|0/1> or
    <verbatim|27/28>.

    <item><verbatim|msg>: a 32-bit pointer to the buffer containing the
    256-bit Blake2 hash of the message.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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
    <item><strong|><verbatim|sig>: a 32-bit pointer to the buffer containing
    the 65-byte signature in RSV format. V should be either <verbatim|0/1> or
    <verbatim|27/28>.

    <item><verbatim|msg>: a 32-bit pointer to the buffer containing the
    256-bit Blake2 hash of the message.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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

  Finish verifying the batch of signatures since calling
  <verbatim|ext_crypto_start_batch_verify>
  (<reference|sect-ext-crypto-start-batch-verify>). Blocks until all the
  signatures are verified. If the batch is empty, this function just returns
  <verbatim|true>.

  \;

  <strong|Warning>: Panics if no verification extension is registered
  <verbatim|(ext_crypto_start_batch_verify>
  (<reference|sect-ext-crypto-start-batch-verify>) was not called.)

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_crypto_finish_batch_verify_version_1

    (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item><verbatim|return>: a boolean equal to <verbatim|true> if all
    signatures are valid or the batch is empty, <verbatim|false> if
    otherwise.
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
    <reference|defn-runtime-pointer-size> indicating the data to be hashed.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
    256-bit hash result.
  </itemize>

  <subsection|<verbatim|ext_hashing_keccak_512>>

  Conducts a 512-bit Keccak hash.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_hashing_keccak_512_version_1

    \ \ (param $data i64) (return i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><strong|><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the data to be hashed.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
    512-bit hash result.
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
    <reference|defn-runtime-pointer-size> indicating the data to be hashed.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the data to be hashed.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the data to be hashed.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the data to be hashed.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the data to be hashed.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the data to be hashed.

    <item><verbatim|return>: a 32-bit pointer to the buffer containing the
    256-bit hash result.
  </itemize>

  <section|Offchain>

  The offchain workers allow the execution of long-running and possibly
  non-deterministic tasks (e.g. web requests, encryption/decryption and
  signing of data, random number generation, CPU-intensive computations,
  enumeration/aggregation of on-chain data, etc.) which could otherwise
  require longer than the block execution time. Offchain workers have their
  own execution environment. This separation of concerns is to make sure that
  the block production is not impacted by the long-running tasks.

  \;

  All data and results generated by offchain workers are unique per node and
  nondeterministic. Information can be propagated to other nodes by
  submitting a transaction that should be included in the next block. As
  offchain workers runs on their own execution environment they have access
  to their own separate storage. There are two different types of storage
  available which are defined in Definitions F.1 and F.2.

  <\definition>
    <label|defn-offchain-persistent-storage><strong|Persistent storage> is
    non-revertible and not fork-aware. It means that any value set by the
    offchain worker is persisted even if that block (at which the worker is
    called) is reverted as non-canonical (meaning that the block was
    surpassed by a longer chain). The value is available for the worker that
    is re-run at the new (different block with the same block number) and
    future blocks. This storage can be used by offchain workers to handle
    forks and coordinate offchain workers running on different forks.
  </definition>

  <\definition>
    <label|defn-offchain-local-storage><strong|Local storage> is revertible
    and fork-aware. It means that any value set by the offchain worker
    triggered at a certain block is reverted if that block is reverted as
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
    (func $ext_offchain_is_validator_version_1 (return i8))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|return>: a boolean equal to <verbatim|true> if the node
    is a validator, <verbatim|false> if otherwise.
  </itemize>

  <subsection|<verbatim|ext_offchain_submit_transaction>><label|sect-ext-offchain-submit-transaction>

  Given a SCALE encoded extrinsic, this function submits the extrinsic to the
  Host's transaction pool, ready to be propagated to remote peers. This
  process is critical for issuing the <verbatim|ImOnline> message
  <todo|refer>.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_submit_transaction_version_1 (param $data i64)
    (return i64))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the byte array storing
    the encoded extrinsic.

    <item><verbatim|return>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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
    about the the <verbatim|libp2p> <verbatim|PeerId>, <math|P<rsub|id>>, of
    the local node and a list of <verbatim|libp2p> <verbatim|Multiaddresses,>
    (<math|M<rsub|0>\<ldots\>M<rsub|n>>), the node knows it can be reached
    at:

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
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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
    <item><verbatim|result>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the value.
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
    <reference|defn-runtime-pointer-size> indicating the key.
  </itemize-dot>

  <subsection|<verbatim|ext_offchain_local_storage_compare_and_set>>

  Sets a new value in the local storage if the condition matches the current
  value.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_local_storage_compare_and_set_version_1

    \ \ (param $kind i32) (param $key i64)

    \ \ (param $old_value i64) (param $new_value i64)

    \ \ (result i8))
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
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|old_value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the old key.

    <item><verbatim|new_value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the new value.

    <item><verbatim|result>: a boolean equal to <verbatim|true> if the new
    value has been set, <verbatim|false> if otherwise.
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
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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
    <reference|defn-runtime-pointer-size> indicating the HTTP method.
    Possible values are <verbatim|\PGET\Q> and <verbatim|\PPOST\Q>.

    <item><verbatim|urli>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the URI.

    <item><verbatim|meta>: a future-reserved field containing additional,
    SCALE encoded parameters. Currently, an empty array should be passed.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Result> as defined in Definition <reference|defn-result-type>
    containing the i16 ID of the newly started request. On failure no
    additionally data is provided. The cause of failure is implementation
    specific.
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
    <reference|defn-runtime-pointer-size> indicating the HTTP header name.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the HTTP header value.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Result> as defined in Definition <reference|defn-result-type>.
    Neither on success or failure is there any additional data provided. The
    cause of failure is implemenation specific.
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
    <reference|defn-runtime-pointer-size> indicating the chunk of bytes.
    Writing an empty chunk finalizes the request.

    <item><verbatim|deadline>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the UNIX timestamp as defined in Definition
    <reference|defn-unix-time>. Passing <verbatim|None> blocks indefinitely.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
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
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded array
    of started request IDs.

    <item><verbatim|deadline>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the UNIX timestamp as defined in Definition 1.10. Passing
    <verbatim|None> blocks indefinitely.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded array
    of request statuses as defined in Definition
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
    <reference|defn-runtime-pointer-size> indicating a SCALE encoded array of
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
    <reference|defn-runtime-pointer-size> indicating the buffer where the
    body gets written to.

    <item><verbatim|deadline>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the UNIX timestamp as defined in Definition
    <reference|defn-unix-time>. Passing <verbatim|None> will block
    indefinitely.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Result> as defined in Definition <reference|defn-result-type>.
    On success it contains an i32 integer specifying the number of bytes
    written or a HTTP error type as defined in Definition
    <reference|defn-http-error> on faiure.
  </itemize>

  <subsection|<verbatim|ext_offchain_set_authorized_nodes>>

  Set the authorized nodes which are allowed to connect to the local node.
  This function is offered by the Substrate codebase and is primarily used
  for custom, non-Polkadot/Kusama chains. It is not required for the public
  and open Polkadot protocol.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_set_authorized_nodes_version_1

    \ \ (param $nodes i64) (param $authorized_only i32)
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize-dot>
    <item><verbatim|nodes>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the buffer of the SCALE
    encoded array of <verbatim|libp2p> <verbatim|PeerId>'s. Invalid
    <verbatim|PeerId>'s are silently ignored.

    <item><verbatim|authorized_only>: If set to <verbatim|1>, then only the
    authorized nodes are allowed to connect to the local node (whitelist).
    All other nodes are rejected. If set to <verbatim|0>, then no such
    restriction is placed.
  </itemize-dot>

  <section|Offchain Index>

  Interface that provides functions to access the Offchain database.

  <subsection|<verbatim|<strong|ext_offchain_index_set<strong|>>>>

  Write a key value pair to the offchain database in a buffered fashion.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_index_set_version_1

    \ \ (param $key i64) (param $value i64))
  </verbatim>

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the key.

    <item><verbatim|value>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the value.\ 
  </itemize-dot>

  <subsection|<verbatim|<strong|ext_offchain_index_clear>>>

  Remove a key and its associated value from the offchain database.

  <subsubsection|Version 1 - Prototype>

  <\verbatim>
    (func $ext_offchain_index_clear_version_1

    \ \ (param $key i64))
  </verbatim>

  \;

  <strong|Arguments>

  <\itemize-dot>
    <item><verbatim|key>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the key.
  </itemize-dot>

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
    <reference|defn-runtime-pointer-size> indicating the iterated items from
    which the trie root gets formed. The items consist of a SCALE encoded
    array containing arbitrary key/value pairs.

    <item><verbatim|result>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the enumerated items
    from which the trie root gets formed. The items consist of a SCALE
    encoded array containing only values, where the corresponding key of each
    value is the index of the item in the array, starting at 0. The keys are
    compact encoded integers as described in Definition
    <reference|defn-sc-len-encoding>.

    <item><verbatim|result>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the iterated items from
    which the trie root gets formed. The items consist of a SCALE encoded
    array containing arbitrary key/value pairs.

    <item>result: a 32-bit pointer to the buffer containing the 256-bit trie
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
    <reference|defn-runtime-pointer-size> indicating the enumerated items
    from which the trie root gets formed. The items consist of a SCALE
    encoded array containing only values, where the corresponding key of each
    value is the index of the item in the array, starting at 0. The keys are
    compact encoded integers as described in Definition
    <reference|defn-sc-len-encoding>.

    <item><verbatim|result>: a 32-bit pointer to the buffer containing the
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
    <reference|defn-runtime-pointer-size> indicating the valid
    <verbatim|UTF8> buffer to be printed.
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
    <reference|defn-runtime-pointer-size> indicating the buffer to be
    printed.
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
    <reference|defn-runtime-pointer-size> indicating the Wasm blob.

    <item><verbatim|result>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the SCALE encoded
    <verbatim|Option> as defined in Definition <reference|defn-option-type>
    containing the Runtime version of the given Wasm blob.
  </itemize>

  <section|Allocator><label|sect-ext-allocator>

  The Polkadot Runtime does not include a memory allocator and relies on the
  Host API for all heap allocations. The beginning of this heap is marked by
  the <verbatim|__heap_base> symbol exported by the Polkadot Runtime. No
  memory should be allocated below that address, to avoid clashes with the
  stack and data section. The same allocator made accessible by this Host API
  should be used for any other WASM memory allocations and deallocations
  outside the runtime e.g. when passing the SCALE-encoded parameters to
  Runtime API calls.

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

    <item><verbatim|result>: a 32-bit pointer to the allocated buffer.
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
    <item><verbatim|ptr>: a 32-bit pointer to the memory buffer to be freed.
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
    <reference|defn-runtime-pointer-size> indicating the string which
    contains the path, module or location from where the log was executed.

    <item><verbatim|message>: a pointer-size as defined in Definition
    <reference|defn-runtime-pointer-size> indicating the log message.
  </itemize>

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|appendix-nr|3>
    <associate|save-aux|false>
  </collection>
</initial>