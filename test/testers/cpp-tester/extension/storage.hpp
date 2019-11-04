/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_STORAGE_EXTENSION_HPP
#define KAGOMECROSSTESTCLI_STORAGE_EXTENSION_HPP

#include <string>

struct ClearPrefixCommandArgs {
  std::string prefix;
  std::string key1;
  std::string value1;
  std::string key2;
  std::string value2;
};

// parses CLI input
ClearPrefixCommandArgs extractClearPrefixArgs(int argc, char **argv);

// executes ext_clear_prefix tests according to provided args
void processExtClearPrefix(const ClearPrefixCommandArgs& args);

// executes ext_clear_storage tests according to provided args
// void processExtClearStorage();

// executes ext_exists_storage tests according to provided args
// void processExtExistsStorage();

// TODO: do another args
// executes ext_get_allocated_storage tests according to provided args
// void processExtGetAllocatedStorage(const WasmPtrCommandArgs& args);

// TODO: do another args
// executes ext_get_storage_into tests according to provided args
// void processExtGetStorageInto(const WasmPtrCommandArgs& args);

// TODO: do another args
// executes ext_set_storage tests according to provided args
// void processExtSetStorage(const WasmPtrCommandArgs& args);

// TODO: do another args
// executes ext_blake2_256_enumerated_trie_root tests according to provided args
// void processExtBlake2_256EnumeratedTrieRoot(const WasmPtrCommandArgs& args);

// TODO: do another args
// executes ext_storage_changes_root tests according to provided args
// void processExtStorageChangesRoot(const WasmPtrCommandArgs& args);

// executes ext_storage_root tests according to provided args
// void processExtStorageRoot();

#endif //KAGOMECROSSTESTCLI_STORAGE_EXTENSION_HPP
