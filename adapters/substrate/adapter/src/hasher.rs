// Copyright 2018-2019 Parity Technologies (UK) Ltd.
// This file is part of Substrate.

// Substrate is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Substrate is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Substrate.  If not, see <http://www.gnu.org/licenses/>.

//! Substrate Blake2b Hasher implementation

use crate::hash::H256;
use hash256_std_hasher::Hash256StdHasher;
use trie_root::Hasher;

pub mod blake2 {
    use super::{Hash256StdHasher, Hasher, H256};

    /// Do a Blake2 256-bit hash and place result in `dest`.
    pub fn blake2_256_into(data: &[u8], dest: &mut [u8; 32]) {
        dest.copy_from_slice(blake2_rfc::blake2b::blake2b(32, &[], data).as_bytes());
    }

    /// Do a Blake2 256-bit hash and return result.
    pub fn blake2_256(data: &[u8]) -> [u8; 32] {
        let mut r = [0; 32];
        blake2_256_into(data, &mut r);
        r
    }

    /// Concrete implementation of Hasher using Blake2b 256-bit hashes
    #[derive(Debug)]
    pub struct Blake2Hasher;

    impl Hasher for Blake2Hasher {
        type Out = H256;
        type StdHasher = Hash256StdHasher;
        const LENGTH: usize = 32;
        fn hash(x: &[u8]) -> Self::Out {
            blake2_256(x).into()
        }
    }
}
