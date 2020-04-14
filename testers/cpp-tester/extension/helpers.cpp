#include "helpers.hpp"

#include <binaryen/shell-interface.h>

#include <kagome/storage/trie/impl/polkadot_trie_db.hpp>
#include <kagome/storage/trie/impl/trie_db_backend_impl.hpp>
#include <kagome/storage/in_memory/in_memory_storage.hpp>
#include <kagome/runtime/binaryen/wasm_memory_impl.hpp>
#include <kagome/extensions/impl/extension_impl.hpp>

namespace helpers {

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

  wasm::ShellExternalInterface interface;

  std::shared_ptr<kagome::runtime::WasmMemory> memory =
    std::make_shared<kagome::runtime::binaryen::WasmMemoryImpl>(&interface.memory, 4096);

  std::unique_ptr<kagome::extensions::Extension> extension =
    std::make_unique<kagome::extensions::ExtensionImpl>(memory, std::move(trie));

  return std::make_pair(memory, std::move(extension));
}

}
