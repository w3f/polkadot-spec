/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_NETWORK_EXTENSION_HPP
#define KAGOMECROSSTESTCLI_NETWORK_EXTENSION_HPP

#include <string>
#include <vector>

namespace network {
  // executes ext_http tests according to provided args
  // Input:
  // not implemented
  void processExtHttp(const std::vector<std::string> &args);

  // executes ext_network_state tests according to provided args
  // Input:
  // not implemented
  void processExtNetworkState(const std::vector<std::string> &args);
} // namespace network

#endif // KAGOMECROSSTESTCLI_NETWORK_EXTENSION_HPP
