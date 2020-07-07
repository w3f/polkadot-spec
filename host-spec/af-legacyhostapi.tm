<TeXmacs|1.99.12>

<project|host-spec.tm>

<style|book>

<\body>
  <appendix|Legacy Polkadot Host API<label|sect-re-api>>

  \;

  The Legacy Polkadot Host APIs were exceeded and replaces by the current API
  as described in Appendix <reference|appendix-e>. Those legacy functions are
  only required for executing Runtimes prior the official Polkadot Runtime,
  such as the Kusama test network.

  \;

  <strong|Note>: This section will be removed in the future.

  <section|Storage>

  <subsection|<verbatim|ext_set_storage>><label|sect-set-storage>

  Sets the value of a specific key in the state storage.

  <strong|Prototype:>

  <\verbatim>
    (func $ext_storage

    \ \ (param $key_data i32) (param $key_len i32) (param $value_data i32)
    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (param $value_len
    i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key>: a pointer indicating the buffer containing the key.

    <item><verbatim|key_len>: the key length in bytes.

    <item><verbatim|value>: a pointer indicating the buffer containing the
    value to be stored under the key.

    <item><verbatim|value_len>: the length of the value buffer in bytes.
  </itemize>

  <subsection|<verbatim|ext_storage_root>>

  Retrieves the root of the state storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_storage_root

    \ \ (param $result_ptr i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|result_ptr>: a memory address pointing at a byte array
    which contains the root of the state storage after the function
    concludes.
  </itemize>

  <subsection|<verbatim|ext_blake2_256_enumerated_trie_root>>

  Given an array of byte arrays, it arranges them in a Merkle trie, defined
  in<verbatim|<em|<strong|>>> Section <reference|sect-merkl-proof>, where the
  key under which the values are stored is the 0-based index of that value in
  the array. It computes and returns the root hash of the constructed trie.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_blake2_256_enumerated_trie_root

    \ \ \ \ \ \ (param $values_data i32) (param $lens_data i32) (param
    $lens_len i32)\ 

    \ \ \ \ \ \ (param $result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|values_data>: a memory address pointing at the buffer
    containing the array where byte arrays are stored consecutively.

    <item><verbatim|lens_data>: an array of <verbatim|i32> elements each
    stores the length of each byte array stored in <verbatim|value_data>.

    <item><verbatim|len>s_len: the number of <verbatim|i32> elements in
    <verbatim|lens_data>.

    <item><verbatim|result>: a memory address pointing at the beginning of a
    32-byte byte array containing the root of the Merkle trie corresponding
    to elements of <verbatim|values_data>.
  </itemize>

  <subsection|<verbatim|ext_clear_prefix>>

  Given a byte array, this function removes all storage entries whose key
  matches the prefix specified in the array.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_clear_prefix

    \ \ \ \ \ \ (param $prefix_data i32) (param $prefix_len i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|prefix_data>: a memory address pointing at the buffer
    containing the byte array containing the prefix.

    <item><verbatim|prefix_len>: the length of the byte array in number of
    bytes.
  </itemize>

  <subsection|<verbatim|><verbatim|ext_clear_storage>>

  Given a byte array, this function removes the storage entry whose key is
  specified in the array.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_clear_storage

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key_data>: a memory address pointing at the buffer
    containing the byte array containing the key value.

    <item><verbatim|key_len>: the length of the byte array in number of
    bytes.
  </itemize>

  <\subsection>
    <verbatim|ext_exists_storage>
  </subsection>

  Given a byte array, this function checks if the storage entry corresponding
  to the key specified in the array exists.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_exists_storage

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32) (result i32)

    \ \ \ \ )
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key_data>: a memory address pointing at the buffer
    containing the byte array containing the key value.

    <item><verbatim|key_len>: the length of the byte array in number of
    bytes.

    <item><verbatim|result>: An <verbatim|i32> integer which is equal to 1
    verifies if an entry with the given key exists in the storage or 0 if the
    key storage does not contain an entry with the given key.
  </itemize>

  <subsection|<verbatim|ext_get_allocated_storage>>

  Given a byte array, this function allocates a large enough buffer in the
  memory and retrieves the value stored under the key that is specified in
  the array. Then, it stores it in the allocated buffer if the entry exists
  in the storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $get_allocated_storage

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32) (param
    $written_out i32) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key_data>: a memory address pointing at the buffer
    containing the byte array containing the key value.

    <item><verbatim|key_len>: the length of the byte array in number of
    bytes.

    <item><verbatim|written_out>: the function stores the length of the
    retrieved value in number of bytes if the enty exists. If the entry does
    not exist, it returns <math|2<rsup|32>-1>.

    <item><verbatim|result>: A pointer to the buffer in which the function
    allocates and stores the value corresponding to the given key if such an
    entry exist; otherwise it is equal to 0.
  </itemize>

  <subsection|<verbatim|ext_get_storage_into>>

  Given a byte array, this function retrieves the value stored under the key
  specified in the array and stores the specified chunk starting at the
  offset into the provided buffer, if the entry exists in the storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $ext_get_storage_into\ 

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32) (param $value_data
    i32)

    \ \ \ \ \ \ (param $value_len i32) (param $value_offset i32) (result
    i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|key_data>: a memory address pointing at the buffer of the
    byte array containing the key value.

    <item><verbatim|key_len>: the length of the byte array in number of
    bytes.

    <item><verbatim|value_data>: a pointer to the buffer in which the
    function stores the chunk of the value it retrieves.

    <item><verbatim|value_len>: the (maximum) length of the chunk in bytes
    the function will read of the value and will store in the
    <verbatim|value_data> buffer.

    <item><verbatim|value_offset>: the offset of the chunk where the function
    should start storing the value in the provided buffer, i.e. the number of
    bytes the functions should skip from the retrieved value before storing
    the data in the <verbatim|value_data> in number of bytes.

    <item><verbatim|result>: The number of bytes the function writes in
    <verbatim|value_data> if the value exists or <math|2<rsup|32>-1> if the
    entry does not exist under the specified key.
  </itemize>

  <subsection|<verbatim|ext_set_child_storage>>

  Sets the value of a specific key in the child state storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_set_child_storage

    \ \ (param $storage_key_data i32) (param $storage_key_len i32) (param
    $key_data i32)

    \ \ (param $key_len i32) (param $value_data i32) (param $value_len i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|storage_key_data>: a memory address pointing at the
    buffer of the byte array containing the child storage key. This key
    <strong|must> be prefixed with <code|<code*|:child_storage:default:>>

    <item><verbatim|storage_key_len>: the length of the child storage key
    byte array in number of bytes.

    <item><verbatim|key>: a pointer indicating the buffer containing the key.

    <item><verbatim|key_len>: the key length in bytes.

    <item><verbatim|value>: a pointer indicating the buffer containing the
    value to be stored under the key.

    <item><verbatim|value_len>: the length of the value buffer in bytes.
  </itemize>

  <subsection|<verbatim|ext_clear_child_storage>>

  Given a byte array, this function removes the child storage entry whose key
  is specified in the array.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $ext_clear_child_storage

    \ \ \ \ \ \ (param $storage_key_data i32) (param $storage_key_len i32)

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|storage_key_data>: a memory address pointing at the
    buffer of the byte array containing the child storage key.

    <item><verbatim|storage_key_len>: the length of the child storage key
    byte array in number of bytes.

    <item><verbatim|key_data>: a memory address pointing at the buffer of the
    byte array containing the key value.

    <item><verbatim|key_len>: the length of the key byte array in number of
    bytes.
  </itemize>

  <subsection|<verbatim|ext_exists_child_storage>>

  Given a byte array, this function checks if the child storage entry
  corresponding to the key specified in the array exists.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $ext_exists_child_storage

    \ \ \ \ \ \ (param $storage_key_data i32) (param $storage_key_len i32)

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|storage_key_data>: a memory address pointing at the
    buffer of the byte array containing the child storage key.

    <item><verbatim|storage_key_len>: the length of the child storage key
    byte array in number of bytes.

    <item><verbatim|key_data>: a memory address pointing at the buffer of the
    byte array containing the key value.

    <item><verbatim|key_len>: the length of the key byte array in number of
    bytes.

    <item><verbatim|result>: an i32 integer which is equal to 1 verifies if
    an entry with the given key exists in the child storage or 0 if the child
    storage does not contain an entry with the given key.
  </itemize>

  <subsection|<verbatim|ext_get_allocated_child_storage>>

  Given a byte array, this function allocates a large enough buffer in the
  memory and retrieves the child value stored under the key that is specified
  in the array. Then, it stores in in the allocated buffer if the entry
  exists in the child storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $ext_get_allocated_child_storage

    \ \ \ \ \ \ (param $storage_key_data i32) (param $storage_key_len i32)
    (param $key_data i32) \ \ \ \ \ \ \ \ \ \ \ \ (param $key_len i32) (param
    $written_out) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|storage_key_data>: a memory address pointing at the
    buffer of the byte array containing the child storage key.

    <item><verbatim|storage_key_len>: the length of the child storage key
    byte array in number of bytes.

    <item><verbatim|key_data>: a memory address pointing at the buffer of the
    byte array containing the key value.

    <item><verbatim|key_len>: the length of the key byte array in number of
    bytes.

    <item><verbatim|written_out>: the function stores the length of the
    retrieved value in number of bytes if the enty exists. If the entry does
    not exist, it stores <math|2<rsup|32>-1>.

    <item><verbatim|result>: A pointer to the buffer in which the function
    allocates and stores the value corresponding to the given key if such an
    entry exist; otherwise it is equal to 0.
  </itemize>

  <subsection|<verbatim|ext_get_child_storage_into>>

  Given a byte array, this function retrieves the child value stored under
  the key specified in the array and stores the specified chunk starting the
  offset into the provided buffer, if the entry exists in the storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $ext_get_child_storage_into

    \ \ \ \ \ \ (param $storage_key_data i32) (param $storage_key_len i32)

    \ \ \ \ \ \ (param $key_data i32) (param $key_len i32) (param $value_data
    i32)

    \ \ \ \ \ \ (param $value_len i32) (param $value_offset i32) (result
    i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|storage_key_data>: a memory address pointing at the
    buffer of the byte array containing the child storage key.

    <item><verbatim|storage_key_len>: the length of the child storage key
    byte array in number of bytes.

    <item><verbatim|key_data>: a memory address pointing at the buffer of the
    byte array containing the key value.

    <item><verbatim|key_len>: the length of the byte array in number of
    bytes.

    <item><verbatim|value_data>: a pointer to the buffer in which the
    function stores the chunk of the value it retrieves.

    <item><verbatim|value_len>: the (maximum) length of the chunk in bytes
    the function will read of the value and will store in the
    <verbatim|value_data> buffer.

    <item><verbatim|value_offset>: the offset of the chunk where the function
    should start storing the value in the provided buffer, i.e. the number of
    bytes the functions should skip from the retrieved value before storing
    the data in the <verbatim|value_data> in number of bytes.

    <item><verbatim|result>: The number of bytes the function writes in
    <verbatim|value_data> if the value exists or <math|2<rsup|32>-1> if the
    entry does not exist under the specified key.
  </itemize>

  <subsection|<verbatim|ext_kill_child_storage>>

  Given a byte array, this function removes all entries of the child storage
  whose child storage key is specified in the array.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $ext_kill_child_storage

    \ \ \ \ \ \ (param $storage_key_data i32) (param $storage_key_len i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|storage_key_data>: a memory address pointing at the
    buffer of the byte array containing the child storage key.

    <item><verbatim|storage_key_len>: the length of the child storage key
    byte array in number of bytes.
  </itemize>

  <subsection|Memory>

  <subsubsection|<verbatim|ext_malloc>>

  Allocates memory of a requested size in the heap.

  \;

  <strong|Prototype>:

  <\verbatim>
    (func $ext_malloc

    \ \ (param $size i32) (result i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|size:> the size of the buffer to be allocated in number
    of bytes.\ 
  </itemize>

  \;

  <strong|Result>:

  <\itemize>
    a memory address pointing at the beginning of the allocated buffer.
  </itemize>

  <subsubsection|<verbatim|ext_free>>

  Deallocates a previously allocated memory.

  \;

  <strong|Prototype>:

  <\verbatim>
    (func $ext_free

    \ \ \ \ \ \ (param $addr i32))
  </verbatim>

  \;

  <\strong>
    Arguments:
  </strong>

  <\itemize>
    <item><verbatim|addr>: a 32bit memory address pointing at the allocated
    memory.
  </itemize>

  <subsubsection|Input/Output>

  <\itemize>
    <item><verbatim|ext_print_hex>

    <item><verbatim|ext_print_num>

    <item><verbatim|ext_print_utf8>
  </itemize>

  <subsection|Cryptograhpic Auxiliary Functions>

  <subsubsection|<verbatim|ext_blake2_256>>

  Computes the Blake2b 256bit hash of a given byte array.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func (export "ext_blake2_256")

    \ \ \ \ \ \ (param $data i32) (param \ $len i32) (param $out i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a memory address pointing at the buffer containing
    the byte array to be hashed.

    <item><verbatim|len>: the length of the byte array in bytes.

    <item><verbatim|out>: a memory address pointing at the beginning of a
    32-byte byte array contanining the Blake2b hash of the data.
  </itemize>

  <subsubsection|<verbatim|ext_keccak_256>>

  Computes the Keccak-256 hash of a given byte array.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_keccak_256

    \ \ \ \ \ \ (param $data i32) (param $len i32) (param $out i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a memory address pointing at the buffer containing
    the byte array to be hashed.

    <item><verbatim|len>: the length of the byte array in bytes.

    <item><verbatim|out>: a memory address pointing at the beginning of a
    32-byte byte array contanining the Keccak-256 hash of the data.
  </itemize>

  <subsubsection|<verbatim|ext_twox_128>>

  Computes the <em|xxHash64> algorithm (see <cite|collet_extremely_2019>)
  twice initiated with seeds 0 and 1 and applied on a given byte array and
  outputs the concatenated result.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_twox_128

    \ \ \ \ \ \ \ (param $data i32) (param $len i32) (param $out i32))
  </verbatim>

  \;

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a memory address pointing at the buffer containing
    the byte array to be hashed.

    <item><verbatim|len>: the length of the byte array in bytes.

    <item><verbatim|out>: a memory address pointing at the beginning of a
    16-byte byte array containing \ <em|<math|<text|xxhash>64<rsub|0>>>(<verbatim|data>)\|\|<em|<math|<text|xxhash64><rsub|1>>>(<verbatim|data>)
    where <math|><em|<math|<text|xxhash>64<rsub|i>>> is the xxhash64 function
    initiated with seed <math|i> as a 64bit unsigned integer.
  </itemize>

  <subsubsection|<verbatim|ext_ed25519_verify>>

  Given a message signed by the ED25519 signature algorithm alongside with
  its signature and the allegedly signer public key, it verifies the validity
  of the signature by the provided public key.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_ed25519_verify

    \ \ \ \ \ \ (param $msg_data i32) (param $msg_len i32) (param $sig_data
    i32)

    \ \ \ \ \ \ (param $pubkey_data i32) (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|msg_data>: a pointer to the buffer containing the message
    body.

    <item><verbatim|msg_len>: an <verbatim|i32> integer indicating the size
    of the message buffer in bytes.

    <item><verbatim|sig_data>: a pointer to the 64 byte memory buffer
    containing the ED25519 signature corresponding to the message.

    <item><verbatim|pubkey_data>: a pointer to the 32 byte buffer containing
    the public key and corresponding to the secret key which has signed the
    message.

    <item><verbatim|result>: \ an in<verbatim|>teger value equal to 0
    indicating the validity of the signature or a nonzero value otherwise.
  </itemize>

  <subsubsection|<verbatim|ext_sr25519_verify>>

  Given a message signed by the SR25519 signature algorithm alongside with
  its signature and the allegedly signer public key, it verifies the validity
  of the signature by the provided public key.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_sr25519_verify

    \ \ \ \ \ \ (param $msg_data i32) (param $msg_len i32) (param $sig_data
    i32)

    \ \ \ \ \ \ (param $pubkey_data i32) (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|msg_data>: a pointer to the buffer containing the message
    body.

    <item><verbatim|msg_len>: an <verbatim|i32> integer indicating the size
    of the message buffer in bytes.

    <item><verbatim|sig_data>: a pointer to the 64 byte memory buffer
    containing the SR25519 signature corresponding to the message.

    <item><verbatim|pubkey_data>: a pointer to the 32 byte buffer containing
    the public key and corresponding to the secret key which has signed the
    message.

    <item><verbatim|result>: \ an in<verbatim|>teger value equal to 0
    indicating the validity of the signature or a nonzero value otherwise.
  </itemize>

  <subsubsection|To be Specced>

  <\itemize>
    <item><verbatim|ext_twox_256>
  </itemize>

  <subsection|Offchain Worker >

  The Offchain Workers allow the execution of long-running and possibly
  non-deterministic tasks (e.g. web requests, encryption/decryption and
  signing of data, random number generation, CPU-intensive computations,
  enumeration/aggregation of on-chain data, etc.) which could otherwise
  require longer than the block execution time. Offchain Workers have their
  own execution environment. This separation of concerns is to make sure that
  the block production is not impacted by the long-running tasks.\ 

  \;

  All data and results generated by Offchain workers are unique per node and
  nondeterministic. Information can be propagated to other nodes by
  submitting a transaction that should be included in the next block. As
  Offchain workers runs on their own execution environment they have access
  to their own separate storage. There are two different types of storage
  available which are defined in Definitions
  <reference|defn-offchain-persistent-storage> and
  <reference|defn-offchain-local-storage>.

  <\definition>
    <label|defn-offchain-persistent-storage><strong|Persistent
    <strong|storage>> is non-revertible and not fork-aware. It means that any
    value set by the offchain worker is persisted even if that block (at
    which the worker is called) is reverted as non-canonical (meaning that
    the block was surpassed by a longer chain). The value is available for
    the worker that is re-run at the new (different block with the same block
    number) and future blocks. This storage can be used by offchain workers
    to handle forks and coordinate offchain workers running on different
    forks.
  </definition>

  <\definition>
    <label|defn-offchain-local-storage><strong|Local storage> is revertible
    and fork-aware. It means that any value set by the offchain worker
    triggered at a certain block is reverted if that block is reverted as
    non-canonical. The value is NOT available for the worker that is re-run
    at the next or any future blocks.

    <\definition>
      <label|defn-http-return-value><strong|HTTP status codes> that can get
      returned by certain Offchain HTTP functions.

      <\itemize-dot>
        <item><strong|0>: the specified request identifier is invalid.

        <item><strong|10>: the deadline for the started request was reached.

        <item><strong|20>: an error has occurred during the request, e.g. a
        timeout or the remote server has closed the connection. On returning
        this error code, the request is considered destroyed and must be
        reconstructed again.

        <item><strong|100>..<strong|999>: the request has finished with the
        given HTTP status code.
      </itemize-dot>
    </definition>

    \;
  </definition>

  <subsubsection|<verbatim|ext_is_validator>>

  Returns if the local node is a potential validator. Even if this function
  returns 1, it does not mean that any keys are configured and that the
  validator is registered in the chain.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_is_validator

    \ \ \ \ \ \ (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|result>: \ an i32 in<verbatim|>teger which is equal to 1
    if the local node is a potential validator or a equal to 0 if it is not.
  </itemize>

  <subsubsection|<verbatim|ext_submit_transaction>>

  Given an extrinsic as a SCALE encoded byte array, the system decodes the
  byte array and submits the extrinsic in the inherent pool as an extrinsic
  to be included in the next produced block.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_submit_transaction

    \ \ \ \ \ \ (param $data i32) (param $len i32) (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer to the buffer containing the byte array
    storing the encoded extrinsic.

    <item><verbatim|len>: an <verbatim|i32> integer indicating the size of
    the encoded extrinsic.

    <item><verbatim|result>: an in<verbatim|>teger value equal to 0 indicates
    that the extrinsic is successfully added to the pool or a nonzero value
    otherwise.
  </itemize>

  <subsubsection|<verbatim|ext_network_state>>

  Returns the SCALE encoded, opaque information about the local node's
  network state. This information is fetched by calling into
  <verbatim|libp2p>, which <em|might> include the <verbatim|PeerId> and
  possible <verbatim|Multiaddress(-es)> by which the node is publicly known
  by. Those values are unique and have to be known by the node individually.
  Due to its opaque nature, it's unknown whether that information is
  available prior to execution.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_network_state

    \ \ \ \ \ \ (param $written_out i32)(result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|written_out>: a pointer to the 4-byte buffer where the
    size of the opaque network state gets written to.

    <item><verbatim|result>: a pointer to the buffer containing the SCALE
    encoded network state. This includes none or one <verbatim|PeerId>
    followed by none, one or more IPv4 or IPv6 <verbatim|Multiaddress(-es)>
    by which the node is publicly known by.
  </itemize>

  <subsubsection|<verbatim|ext_timestamp>>

  Returns current timestamp.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_timestamp

    \ \ \ \ \ \ (result i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|result>: an i64 integer indicating the current UNIX
    timestamp as defined in Definition <reference|defn-unix-time>.
  </itemize>

  <subsubsection|<verbatim|ext_sleep_until>>

  Pause the execution until `<math|>deadline` is reached.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_sleep_until

    \ \ \ \ \ \ (param $deadline i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|deadline>: an i64 integer specifying the UNIX timestamp
    as defined in Definition <reference|defn-unix-time>.
  </itemize>

  <subsubsection|<verbatim|ext_random_seed>>

  Generates a random seed. This is a truly random non deterministic seed
  generated by the host environment.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_random_seed

    \ \ \ \ \ \ (param $seed_data i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|seed_data>: a memory address pointing at the beginning of
    a 32-byte byte array containing the generated seed.
  </itemize>

  <subsubsection|<verbatim|ext_local_storage_set>>

  Sets a value in the local storage. This storage is not part of the
  consensus, it's only accessible by the offchain worker tasks running on the
  same machine and is persisted between runs.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_local_storage_set

    \ \ \ \ \ \ (param $kind i32) (param $key i32) (param $key_len i32)

    \ \ \ \ \ \ (param $value i32) (param $value_len i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|kind>: an i32 integer indicating the storage kind. A
    value equal to 1 is used for a persistent storage as defined in
    Definition <reference|defn-offchain-persistent-storage> and a value equal
    to 2 for local storage as defined in Definition
    <reference|defn-offchain-local-storage>.

    <item><verbatim|key>: a pointer to the buffer containing the key.

    <item><verbatim|key_len>: an i32 integer indicating the size of the key.

    <item><verbatim|value>: a pointer to the buffer containg the value.

    <item><verbatim|value_len>: an i32 integer indicating the size of the
    value.
  </itemize>

  <subsubsection|<verbatim|ext_local_storage_compare_and_set>>

  Sets a new value in the local storage if the condition matches the current
  value.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_local_storage_compare_and_set\ 

    \ \ \ \ \ \ (param $kind i32) (param $key i32) (param $key_len i32)

    \ \ \ \ \ \ (param $old_value i32) (param $old_value_len) (param
    $new_value i32)

    \ \ \ \ \ \ (param $new_value_len) (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|kind>: an i32 integer indicating the storage kind. A
    value equal to 1 is used for a persistent storage as defined in
    Definition <reference|defn-offchain-persistent-storage> and a value equal
    to 2 for local storage as defined in Definition
    <reference|defn-offchain-local-storage>.

    <item><verbatim|key>: a pointer to the buffer containing the key.

    <item><verbatim|key_len>: an i32 integer indicating the size of the key.

    <item><verbatim|old_value>: a pointer to the buffer containing the
    current value.

    <item><verbatim|old_value_len>: an i32 integer indicating the size of the
    current value.

    <item><verbatim|new_value>: a pointer to the buffer containing the new
    value.

    <item><verbatim|new_value_len>: an i32 integer indicating the size of the
    new value.

    <item><verbatim|result>: an i32 integer equal to 0 if the new value has
    been set or a value equal to 1 if otherwise.
  </itemize>

  <subsubsection|<verbatim|ext_local_storage_get>>

  Gets a value from the local storage.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_local_storage_get

    \ \ \ \ \ \ (param $kind i32) (param $key i32) (param $key_len i32)

    \ \ \ \ \ \ (param $value_len i32) (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|kind>: an i32 integer indicating the storage kind. A
    value equal to 1 is used for a persistent storage as defined in
    Definition <reference|defn-offchain-persistent-storage> and a value equal
    to 2 for local storage as defined in Definition
    <reference|defn-offchain-local-storage>.

    <item><verbatim|key>: a pointer to the buffer containing the key.

    <item><verbatim|key_len>: an i32 integer indicating the size of the key.

    <item><verbatim|value_len>: an i32 integer indicating the size of the
    value.

    <item><verbatim|result>: a pointer to the bu\[er in which the function
    allocates and stores the value corresponding to the given key if such an
    entry exist; otherwise it is equal to 0.
  </itemize>

  <subsubsection|<verbatim|ext_http_request_start>>

  Initiates a http request given by the HTTP method and the URL. Returns the
  id of a newly started request.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_http_request_start

    \ \ \ \ \ \ (param $method i32) (param $method_len i32) (param $url i32)

    \ \ \ \ \ \ (param $url_len i32) (param $meta i32) (param $meta_len i32)
    (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|method>: a pointer to the buffer containing the key.

    <item><verbatim|method_len>: an i32 integer indicating the size of the
    method.

    <item><verbatim|url>: a pointer to the buffer containing the url.

    <item><verbatim|url_len>: an i32 integer indicating the size of the url.

    <item><verbatim|meta>: a future-reserved field containing additional,
    SCALE encoded parameters.

    <item><verbatim|meta_len>: an i32 integer indicating the size of the
    parameters.

    <item><verbatim|result>: an i32 integer indicating the ID of the newly
    started request.
  </itemize>

  <subsubsection|<verbatim|ext_http_request_add_header>>

  Append header to the request. Returns an error if the request identifier is
  invalid, <verbatim|http_response_wait> has already been called on the
  specified request identifier, the deadline is reached or an I/O error has
  happened (e.g. the remote has closed the connection).

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_http_request_add_header

    \ \ \ \ \ \ (param $request_id i32) (param $name i32) (param $name_len
    i32)

    \ \ \ \ \ \ (param $value i32) (param $value_len i32) (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|request_id>: an i32 integer indicating the ID of the
    started request.

    <item><verbatim|name>: a pointer to the buffer containing the header
    name.

    <item><verbatim|name_len>: an i32 integer indicating the size of the
    header name.

    <item><verbatim|value>: a pointer to the buffer containing the header
    value.

    <item><verbatim|value_len>: an i32 integer indicating the size of the
    header value.

    <item><verbatim|result>: an i32 integer where the value equal to 0
    indicates if the header has been set or a value equal to 1 if otherwise.
  </itemize>

  <subsubsection|<verbatim|ext_http_request_write_body>>

  Writes a chunk of the request body. Writing an empty chunk finalises the
  request. Returns a non-zero value in case the deadline is reached or the
  chunk could not be written.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_http_request_write_body

    \ \ \ \ \ \ (param $request_id i32) (param $chunk i32) (param $chunk_len
    i32)

    \ \ \ \ \ \ (param $deadline i64) (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|request_id>: an i32 integer indicating the ID of the
    started request.

    <item><verbatim|chunk>: a pointer to the buffer containing the chunk.

    <item><verbatim|chunk_len>: an i32 integer indicating the size of the
    chunk.

    <item><verbatim|deadline>: an i64 integer specifying the UNIX timestamp
    as defined in Definition <reference|defn-unix-time>. Passing '0' will
    block indefinitely.

    <item><verbatim|result>: an i32 integer where the value equal to 0
    indicates if the header has been set or a non-zero value if otherwise.
  </itemize>

  <subsubsection|<verbatim|ext_http_response_wait>>

  Blocks and waits for the responses for given requests. Returns an array of
  request statuses (the size is the same as number of IDs).

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_http_response_wait

    \ \ \ \ \ \ (param $ids i32) (param $ids_len i32) (param $statuses i32)

    \ \ \ \ \ \ (param $deadline i64))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|ids>: a pointer to the buffer containing the started IDs.

    <item><verbatim|ids_len>: an i32 integer indicating the size of IDs.

    <item><verbatim|statuses>: a pointer to the buffer where the request
    statuses get written to as defined in Definition
    <reference|defn-http-return-value>. The lenght is the same as the length
    of <verbatim|ids>.

    <item><verbatim|deadline>: an i64 integer indicating the UNIX timestamp
    as defined in Definition <reference|defn-unix-time>. Passing '0' as
    deadline will block indefinitely.
  </itemize>

  <subsubsection|<verbatim|ext_http_response_headers>>

  Read all response headers. Returns a vector of key/value pairs. Response
  headers must be read before the response body.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_http_response_headers

    \ \ \ \ \ \ (param $request_id i32) (param $written_out i32) (result
    i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|request_id>: an i32 integer indicating the ID of the
    started request.

    <item><verbatim|written_out>: a pointer to the buffer where the size of
    the response headers gets written to.

    <item><verbatim|result>: a pointer to the buffer containing the response
    headers.
  </itemize>

  <subsubsection|<verbatim|ext_http_response_read_body>>

  Reads a chunk of body response to the given buffer. Returns the number of
  bytes written or an error in case a deadline is reached or the server
  closed the connection. If `0' is returned it means that the response has
  been fully consumed and the <verbatim|request_id> is now invalid. This
  implies that response headers must be read before draining the body.

  \;

  <strong|Prototype:>

  <\verbatim>
    (func $ext_http_response_read_body

    \ \ \ \ \ \ (param $request_id i32) (param $buffer i32) (param
    $buffer_len)

    \ \ \ \ \ \ (param $deadline i64) (result i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|request_id>: an i32 integer indicating the ID of the
    started request.

    <item><verbatim|buffer>: a pointer to the buffer where the body gets
    written to.

    <item><verbatim|buffer_len>: an i32 integer indicating the size of the
    buffer.

    <item><verbatim|deadline>: an i64 integer indicating the UNIX timestamp
    as defined in Definition <reference|defn-unix-time>. Passing '0' will
    block indefinitely.

    <item><verbatim|result>: an i32 integer where the value equal to 0
    indicateds a fully consumed response or a non-zero value if otherwise.
  </itemize>

  <subsection|Sandboxing>

  <subsubsection|To be Specced>

  <\itemize>
    <item><verbatim|ext_sandbox_instance_teardown>

    <item><verbatim|ext_sandbox_instantiate>

    <item><verbatim|ext_sandbox_invoke>

    <item><verbatim|ext_sandbox_memory_get>

    <item><verbatim|ext_sandbox_memory_new>

    <item><verbatim|ext_sandbox_memory_set>

    <item><verbatim|ext_sandbox_memory_teardown>
  </itemize>

  <subsection|Auxillary Debugging API>

  <subsubsection|<verbatim|ext_print_hex>>

  Prints out the content of the given buffer on the host's debugging console.
  Each byte is represented as a two-digit hexadecimal number.

  \;

  <strong|Prototype:>

  <\verbatim>
    \ \ \ \ (func $ext_print_hex

    \ \ \ \ \ \ (param $data i32) (parm $len i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|data>: a pointer to the buffer containing the data that
    needs to be printed.

    <item><verbatim|len>: an <verbatim|i32> integer indicating the size of
    the buffer containing the data in bytes.
  </itemize>

  <subsubsection|<verbatim|ext_print_utf8>>

  Prints out the content of the given buffer on the host's debugging console.
  The buffer content is interpreted as a UTF-8 string if it represents a
  valid UTF-8 string, otherwise does nothing and returns.

  <strong|Prototype:>o

  <\verbatim>
    \ \ \ \ (func $ext_print_utf8

    \ \ \ \ \ \ (param $utf8_data i32) (param $utf8_len i32))
  </verbatim>

  \ 

  <strong|Arguments>:

  <\itemize>
    <item><verbatim|utf8_data>: a pointer to the buffer containing the
    utf8-encoded string to be printed.

    <item><verbatim|utf8_len>: an <verbatim|i32> integer indicating the size
    of the buffer containing the UTF-8 string in bytes.
  </itemize>

  <subsection|Misc>

  <subsubsection|To be Specced>\ 

  <\itemize-dot>
    <item><verbatim|ext_chain_id>
  </itemize-dot>

  <verbatim|><subsection|Block Production>

  <section|Validation>

  \;
  
  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|page-first|?>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|A|?|c01-background.tm>>
    <associate|auto-10|<tuple|A.1.8|?|c01-background.tm>>
    <associate|auto-11|<tuple|A.1.9|?|c01-background.tm>>
    <associate|auto-12|<tuple|A.1.10|?|c01-background.tm>>
    <associate|auto-13|<tuple|A.1.11|?|c01-background.tm>>
    <associate|auto-14|<tuple|A.1.12|?|c01-background.tm>>
    <associate|auto-15|<tuple|A.1.13|?|c01-background.tm>>
    <associate|auto-16|<tuple|A.1.14|?|c01-background.tm>>
    <associate|auto-17|<tuple|A.1.15|?|c01-background.tm>>
    <associate|auto-18|<tuple|A.1.15.1|?|c01-background.tm>>
    <associate|auto-19|<tuple|A.1.15.2|?|c01-background.tm>>
    <associate|auto-2|<tuple|A.1|?|c01-background.tm>>
    <associate|auto-20|<tuple|A.1.15.3|?|c01-background.tm>>
    <associate|auto-21|<tuple|A.1.16|?|c01-background.tm>>
    <associate|auto-22|<tuple|A.1.16.1|?|c01-background.tm>>
    <associate|auto-23|<tuple|A.1.16.2|?|c01-background.tm>>
    <associate|auto-24|<tuple|A.1.16.3|?|c01-background.tm>>
    <associate|auto-25|<tuple|A.1.16.4|?|c01-background.tm>>
    <associate|auto-26|<tuple|A.1.16.5|?|c01-background.tm>>
    <associate|auto-27|<tuple|A.1.16.6|?|c01-background.tm>>
    <associate|auto-28|<tuple|A.1.17|?|c01-background.tm>>
    <associate|auto-29|<tuple|A.1.17.1|?|c01-background.tm>>
    <associate|auto-3|<tuple|A.1.1|?|c01-background.tm>>
    <associate|auto-30|<tuple|A.1.17.2|?|c01-background.tm>>
    <associate|auto-31|<tuple|A.1.17.3|?|c01-background.tm>>
    <associate|auto-32|<tuple|A.1.17.4|?|c01-background.tm>>
    <associate|auto-33|<tuple|A.1.17.5|?|c01-background.tm>>
    <associate|auto-34|<tuple|A.1.17.6|?|c01-background.tm>>
    <associate|auto-35|<tuple|A.1.17.7|?|c01-background.tm>>
    <associate|auto-36|<tuple|A.1.17.8|?|c01-background.tm>>
    <associate|auto-37|<tuple|A.1.17.9|?|c01-background.tm>>
    <associate|auto-38|<tuple|A.1.17.10|?|c01-background.tm>>
    <associate|auto-39|<tuple|A.1.17.11|?|c01-background.tm>>
    <associate|auto-4|<tuple|A.1.2|?|c01-background.tm>>
    <associate|auto-40|<tuple|A.1.17.12|?|c01-background.tm>>
    <associate|auto-41|<tuple|A.1.17.13|?|c01-background.tm>>
    <associate|auto-42|<tuple|A.1.17.14|?|c01-background.tm>>
    <associate|auto-43|<tuple|A.1.17.15|?|c01-background.tm>>
    <associate|auto-44|<tuple|A.1.18|?|c01-background.tm>>
    <associate|auto-45|<tuple|A.1.18.1|?|c01-background.tm>>
    <associate|auto-46|<tuple|A.1.19|?|c01-background.tm>>
    <associate|auto-47|<tuple|A.1.19.1|?|c01-background.tm>>
    <associate|auto-48|<tuple|A.1.19.2|?|c01-background.tm>>
    <associate|auto-49|<tuple|A.1.20|?|c01-background.tm>>
    <associate|auto-5|<tuple|A.1.3|?|c01-background.tm>>
    <associate|auto-50|<tuple|A.1.20.1|?|c01-background.tm>>
    <associate|auto-51|<tuple|A.1.21|?|c01-background.tm>>
    <associate|auto-52|<tuple|A.2|?|c01-background.tm>>
    <associate|auto-6|<tuple|A.1.4|?|c01-background.tm>>
    <associate|auto-7|<tuple|A.1.5|?|c01-background.tm>>
    <associate|auto-8|<tuple|A.1.6|?|c01-background.tm>>
    <associate|auto-9|<tuple|A.1.7|?|c01-background.tm>>
    <associate|defn-http-return-value|<tuple|A.3|?|c01-background.tm>>
    <associate|defn-offchain-local-storage|<tuple|A.2|?|c01-background.tm>>
    <associate|defn-offchain-persistent-storage|<tuple|A.1|?|c01-background.tm>>
    <associate|sect-re-api|<tuple|A|?|c01-background.tm>>
    <associate|sect-set-storage|<tuple|A.1.1|?|c01-background.tm>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      collet_extremely_2019
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Legacy Polkadot Host API>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      A.1<space|2spc>Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      <with|par-left|<quote|1tab>|A.1.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_set_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1tab>|A.1.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|A.1.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_blake2_256_enumerated_trie_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1tab>|A.1.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_clear_prefix>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1tab>|A.1.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_clear_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|1tab>|A.1.6<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_exists_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|A.1.7<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_allocated_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|A.1.8<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_storage_into>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|1tab>|A.1.9<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_set_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|1tab>|A.1.10<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_clear_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|A.1.11<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_exists_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|1tab>|A.1.12<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_allocated_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|1tab>|A.1.13<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_child_storage_into>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|1tab>|A.1.14<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_kill_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|1tab>|A.1.15<space|2spc>Memory
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|2tab>|A.1.15.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_malloc>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|2tab>|A.1.15.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_free>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|2tab>|A.1.15.3<space|2spc>Input/Output
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|1tab>|A.1.16<space|2spc>Cryptograhpic Auxiliary
      Functions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|2tab>|A.1.16.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_blake2_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|2tab>|A.1.16.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_keccak_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <with|par-left|<quote|2tab>|A.1.16.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_twox_128>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|2tab>|A.1.16.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_ed25519_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|2tab>|A.1.16.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_sr25519_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|2tab>|A.1.16.6<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>

      <with|par-left|<quote|1tab>|A.1.17<space|2spc>Offchain Worker
      \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|2tab>|A.1.17.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_is_validator>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|2tab>|A.1.17.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_submit_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <with|par-left|<quote|2tab>|A.1.17.3<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_network_state>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|2tab>|A.1.17.4<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_timestamp>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32>>

      <with|par-left|<quote|2tab>|A.1.17.5<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_sleep_until>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <with|par-left|<quote|2tab>|A.1.17.6<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_random_seed>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34>>

      <with|par-left|<quote|2tab>|A.1.17.7<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_local_storage_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35>>

      <with|par-left|<quote|2tab>|A.1.17.8<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_local_storage_compare_and_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36>>

      <with|par-left|<quote|2tab>|A.1.17.9<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_local_storage_get>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37>>

      <with|par-left|<quote|2tab>|A.1.17.10<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_request_start>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38>>

      <with|par-left|<quote|2tab>|A.1.17.11<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_request_add_header>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-39>>

      <with|par-left|<quote|2tab>|A.1.17.12<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_request_write_body>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40>>

      <with|par-left|<quote|2tab>|A.1.17.13<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_response_wait>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41>>

      <with|par-left|<quote|2tab>|A.1.17.14<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_response_headers>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-42>>

      <with|par-left|<quote|2tab>|A.1.17.15<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_response_read_body>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-43>>

      <with|par-left|<quote|1tab>|A.1.18<space|2spc>Sandboxing
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-44>>

      <with|par-left|<quote|2tab>|A.1.18.1<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-45>>

      <with|par-left|<quote|1tab>|A.1.19<space|2spc>Auxillary Debugging API
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-46>>

      <with|par-left|<quote|2tab>|A.1.19.1<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_print_hex>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-47>>

      <with|par-left|<quote|2tab>|A.1.19.2<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_print_utf8>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-48>>

      <with|par-left|<quote|1tab>|A.1.20<space|2spc>Misc
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-49>>

      <with|par-left|<quote|2tab>|A.1.20.1<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-50>>

      <with|par-left|<quote|1tab>|A.1.21<space|2spc>Block Production
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-51>>

      A.2<space|2spc>Validation <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-52>
    </associate>
  </collection>
</auxiliary>