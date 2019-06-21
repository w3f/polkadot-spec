Block 0 and Block 1 from PoC3 network.

For test purpose only. 

Note that the Core_import_block should fail on importing block #1 because the stateRoot is computed using the old trie spec in PoC3 unless the RE API provides the old storage trie data to the runtime.

block-001.hex contains data from the network message propagating the block. It is of the following struct type encoded using SCALED codec.

    pub struct BlockData<Header, Hash, Extrinsic> {
		/// Block header hash.
		pub hash: Hash,
		/// Block header if requested.
		pub header: Option<Header>,
		/// Block body if requested.
		pub body: Option<Vec<Extrinsic>>,
		/// Block receipt if requested.
		pub receipt: Option<Vec<u8>>,
		/// Block message queue if requested.
		pub message_queue: Option<Vec<u8>>,
		/// Justification if requested.
		pub justification: Option<Justification>,
    }

Where ``Extrinsic`` is defined to be ``Vecu<u8>``. ``Hash`` and ``<Hash>::output`` serialize to a byte array of 32 byte length.

More specifically the Header is a struct of the following type:

    pub struct Header<Number, Hash, DigestItem> {
	    /// The parent hash.
	    pub parent_hash: <Hash>::Output,
	    /// The block number.
	    pub number: Number,
	    /// The state trie merkle root
	    pub state_root: <Hash>::Output,
	    /// The merkle root of the extrinsics.
	    pub extrinsics_root: <Hash>::Output,
	    /// A chain-specific digest of data useful for light clients or referencing auxiliary data.
	    pub digest: Digest<DigestItem>,
    }
