#pragma once

#include <runtime/wasm_memory.hpp>
#include <extensions/extension.hpp>

namespace helpers {

// Helper to intialize in memory testing environment
std::pair<
  std::shared_ptr<kagome::runtime::WasmMemory>,
  std::unique_ptr<kagome::extensions::Extension>
> initialize_environment();

}
