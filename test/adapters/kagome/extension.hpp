/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_EXTENSION_HPP
#define KAGOMECROSSTESTCLI_EXTENSION_HPP

#include <memory>
#include <string>
#include <vector>

struct ExtensionCommandArgs {
  std::string function;
  std::vector<std::string> input;
};

// parses CLI input
ExtensionCommandArgs extractExtensionArgs(int argc, char **argv);

void processExtensionsCommands(const ExtensionCommandArgs& args);

#endif //KAGOMECROSSTESTCLI_STORAGE_EXTENSION_HPP
