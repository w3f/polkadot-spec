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

#pragma once

#include "../assert.hpp"

#include <common/buffer.hpp>

#include <scale/scale.hpp>

#include <blockchain/impl/key_value_block_header_repository.hpp>

#include <runtime/binaryen/runtime_api/runtime_api.hpp>

namespace scale = kagome::scale;

namespace helpers {

  using kagome::common::hex_lower;

  using kagome::common::Buffer;
  using MaybeBuffer = boost::optional<Buffer>;

  using kagome::runtime::binaryen::RuntimeApi;
  using kagome::runtime::binaryen::RuntimeEnvironmentFactory;

  using kagome::blockchain::KeyValueBlockHeaderRepository;

  class RuntimeEnvironment {

    public:
      // Initialize a runtime environment
      RuntimeEnvironment();

      // Call function with provided arguments in wasm adapter
      template <typename R, typename... Args>
      R execute(std::string_view name, Args &&... args) {
        auto result = runtime_->execute<R>(
          name,
          RuntimeApi::CallConfig{.persistency = RuntimeApi::CallPersistency::PERSISTENT},
          std::forward<Args>(args)...
        );

        BOOST_ASSERT_MSG(result, result.error().message().data());

        return result.value();
      }

    private:
      // Overwrite to get access to protected function
      struct RawRuntimeApi : public RuntimeApi {
        using RuntimeApi::RuntimeApi;
        using RuntimeApi::execute;
      };

      // Main object used to execute calls
      std::shared_ptr<RawRuntimeApi> runtime_;
  };
}
