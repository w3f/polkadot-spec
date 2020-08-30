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

#include "storage.hpp"

#include "helpers.hpp"

#include <common/buffer.hpp>
#include <common/hexutil.hpp>

#include <iostream>


namespace storage {

// Input: prefix, key1, value1, key2, value2
void processExtClearPrefix(const std::vector<std::string> &args) {
  helpers::RuntimeEnvironment environment;

  // Parse arguments
  auto prefix = args[0];

  auto key1   = args[1];
  auto value1 = args[2];

  auto key2   = args[3];
  auto value2 = args[4];

  // Parse config from arguments
  bool shouldClear1 = (prefix == key1.substr(0, prefix.size()));
  bool shouldClear2 = (prefix == key2.substr(0, prefix.size()));

  // Insert first key value pair
  environment.execute<void>("rtm_ext_set_storage", key1, value1);

  // Insert second key value pair
  environment.execute<void>("rtm_ext_set_storage", key2, value2);

  // Clear prefix
  environment.execute<void>("rtm_ext_clear_prefix", prefix);

  // Retrieve first key 
  auto result = environment.execute<helpers::Buffer>(
    "rtm_ext_get_allocated_storage", key1
  );

  // Check first key
  if (shouldClear1) {
    // Check if key1 was deleted
    BOOST_ASSERT_MSG(result.empty(), "Value1 wasn't deleted");

    //Print result
    std::cout << "Key '" + key1 + "' was deleted\n";
  } else {
    BOOST_ASSERT_MSG(result.toString() == value1, "Value1 was deleted");

    // Print result
    std::cout << "Key '" + key1 + "' remains\n";
  }

  // Retrieve second key
  result = environment.execute<helpers::Buffer>(
    "rtm_ext_get_allocated_storage", key2
  );

  // Check second key
  if (shouldClear2) {
    // Check if key2 was deleted
    BOOST_ASSERT_MSG(result.empty(), "Value2 wasn't deleted");

    // Print result
    std::cout << "Key '" + key2 + "' was deleted\n";
  } else {
    // Check if key2 was stored correctly
    BOOST_ASSERT_MSG(result.toString() == value2, "Value2 was deleted");

    // Print result
    std::cout << "Key '" + key2 + "' remains\n";
  }
}

// Input: key, value
void processExtClearStorage(const std::vector<std::string> &args) {
  helpers::RuntimeEnvironment environment;

  // Parse input arguments
  auto key   = args[0];
  auto value = args[1];

  // Insert data
  environment.execute<void>("rtm_ext_set_storage", key, value);

  // Retrieve stored data
  auto stored = environment.execute<helpers::Buffer>(
    "rtm_ext_get_allocated_storage", key
  );

  // Check data
  BOOST_ASSERT_MSG(!stored.empty(), "No value");
  BOOST_ASSERT_MSG(stored.toString() == value, "Values are different");

  // Clear data
  environment.execute<void>("rtm_ext_clear_storage", key);

  // Retrieve cleared
  auto cleared = environment.execute<helpers::Buffer>(
    "rtm_ext_get_allocated_storage", key
  );

  // Check removal
  BOOST_ASSERT_MSG(cleared.empty(), "Value wasn't deleted");
}

// Input: key, value
void processExtExistsStorage(const std::vector<std::string> &args) {
  helpers::RuntimeEnvironment environment;

  // Parse input arguments
  auto key   = args[0];
  auto value = args[1];
  
  // Check for no data
  auto exists = environment.execute<uint32_t>("rtm_ext_exists_storage", key);

  BOOST_ASSERT_MSG(exists == 0, "Storage exists");

  // Insert data
  environment.execute<void>("rtm_ext_set_storage", key, value);

  // Check for data
  exists = environment.execute<uint32_t>("rtm_ext_exists_storage", key);

  BOOST_ASSERT_MSG(exists == 1, "Storage does not exists");

  // Print result
  std::cout << "true" << std::endl;
}

// Input: key, value
void processExtGetAllocatedStorage(const std::vector<std::string> &args) {
  helpers::RuntimeEnvironment environment;

  // Parse input arguments
  auto key   = args[0];
  auto value = args[1];

  // Check that key has not been set
  auto result = environment.execute<helpers::Buffer>(
    "rtm_ext_get_allocated_storage", key
  );

  BOOST_ASSERT_MSG(result.empty(), "Data exists");

  // Add data to storage
  environment.execute<void>("rtm_ext_set_storage", key, value);

  // Retrieve data from storage
  result = environment.execute<helpers::Buffer>(
    "rtm_ext_get_allocated_storage", key
  );

  // Check returned data
  BOOST_ASSERT_MSG(!result.empty(), "No value");
  BOOST_ASSERT_MSG(result.toString() == value, "Values are different");

  // Print result
  std::cout << result.toString() << std::endl;
}


// Input: key, value, offset
void processExtGetAllocatedStorageInto(const std::vector<std::string> &args) {
  helpers::RuntimeEnvironment environment;

  // Allocate and parse input data
  auto key   = args[0];
  auto value = args[1];

  uint32_t offset = static_cast<uint32_t>(std::stoul(args[2]));

  // Allocate output data
  uint32_t expected = offset > value.length() ? 0 : value.length() - offset;

  helpers::Buffer into(expected, 0);

  // Ensure key does not exist in storage yet
  auto result = environment.execute<helpers::Buffer>(
    "rtm_ext_get_storage_into", key, into, offset
  );

  BOOST_ASSERT_MSG(result == into, "Data exists");

  // Insert test data into storage
  environment.execute<void>("rtm_ext_set_storage", key, value); 

  // Retrieve test data from storage
  result = environment.execute<helpers::Buffer>(
    "rtm_ext_get_storage_into", key, into, offset
  );

  if (offset > value.length())
    BOOST_ASSERT_MSG(result.empty(), "Value not empty");
  else
    BOOST_ASSERT_MSG(result.toString() == value.substr(offset), "Values are different");

  // Print result
  std::cout << result.toString() << std::endl;
}


// Input: key1, value1, key2, valueudo
void processExtStorageRoot(const std::vector<std::string> &args) {
  helpers::RuntimeEnvironment environment;

  // Parse input parameters
  auto key1   = args[0];
  auto value1 = args[1];

  auto key2   = args[2];
  auto value2 = args[3];

  // Insert data
  environment.execute<void>("rtm_ext_set_storage", key1, value1);
  environment.execute<void>("rtm_ext_set_storage", key2, value2);

  // Compute storage root hash
  auto hash = environment.execute<helpers::Buffer>("rtm_ext_storage_root");

  // Print hash
  std::cout << hash.toHex() << std::endl;
}

} // namespace storage
