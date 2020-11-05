// Copyright 2019 Parity Technologies (UK) Ltd.
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

use std::{env, path::PathBuf};

use substrate_wasm_builder::build_project_with_default_rustflags;

/// Returns the manifest dir from the `CARGO_MANIFEST_DIR` env.
fn get_manifest_dir() -> PathBuf {
	env::var("CARGO_MANIFEST_DIR")
		.expect("`CARGO_MANIFEST_DIR` is always set by cargo; qed")
		.into()
}

/// Returns the output dir from `OUT_DIR` env. 
fn get_output_dir() -> PathBuf {
	env::var("OUT_DIR")
		.expect("`OUT_DIR` is always set by cargo; qed")
		.into()
}

/// Build wasm binary and export path to wasm_binary.rs
fn main() {
	build_project_with_default_rustflags(
		get_output_dir().join("wasm_binary.rs").to_str().expect("Cargo uses valid paths; qed"),
		get_manifest_dir().join("Cargo.toml").to_str().expect("Cargo uses valid paths; qed"),
		// This instructs LLD to export __heap_base as a global variable, which is used by the
		// external memory allocator.
		"-Clink-arg=--export=__heap_base -Clink-arg=--import-memory",
	);
}
