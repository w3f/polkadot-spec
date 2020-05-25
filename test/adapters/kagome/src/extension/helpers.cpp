/*
 * Copyright (c) 2019 Web3 Technologies Foundation
 *
 * This file is part of Polkadot Host Test Suite
 *
 * Polkadot Host Test Suite is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Polkadot Host Tests is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
 */

#include "helpers.hpp"

#include <binaryen/shell-interface.h>

#include <storage/trie/impl/polkadot_trie_db.hpp>
#include <storage/trie/impl/trie_db_backend_impl.hpp>
#include <storage/in_memory/in_memory_storage.hpp>
#include <runtime/binaryen/wasm_memory_impl.hpp>
#include <extensions/impl/extension_impl.hpp>

namespace helpers {

  wasm::ShellExternalInterface GLOBAL_WASM_SHELL;

std::pair<
  std::shared_ptr<kagome::runtime::WasmMemory>,
  std::unique_ptr<kagome::extensions::Extension>
> initialize_environment() {
  auto trie = kagome::storage::trie::PolkadotTrieDb::createEmpty(
    std::make_shared<kagome::storage::trie::TrieDbBackendImpl>(
      std::make_shared<kagome::storage::InMemoryStorage>(),
      kagome::common::Buffer{}
    )
  );

  std::shared_ptr<kagome::runtime::WasmMemory> memory =
    std::make_shared<kagome::runtime::binaryen::WasmMemoryImpl>(&GLOBAL_WASM_SHELL.memory, 4096);

  std::unique_ptr<kagome::extensions::Extension> extension =
    std::make_unique<kagome::extensions::ExtensionImpl>(memory, std::move(trie));

  return std::make_pair(memory, std::move(extension));
}

}
