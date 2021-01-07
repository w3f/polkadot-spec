#Copyright (c) 2019 Web3 Technologies Foundation
#
#This file is part of Polkadot Host Test Suite
#
#Polkadot Host Test Suite is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#Polkadot Host Tests is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with Foobar.  If not, see <https://www.gnu.org/licenses/>.

# The version of kagome to be tested
hunter_config(kagome
  GIT_SUBMODULE test/hosts/kagome
  CMAKE_ARGS TESTING=OFF
)

# Extend local hunter config with kagome's settings
include(
  ${CMAKE_SOURCE_DIR}/../../hosts/kagome/cmake/Hunter/config.cmake
  OPTIONAL RESULT_VARIABLE HUNTER_CONFIG_FOUND
)

if(NOT HUNTER_CONFIG_FOUND)
  message(WARNING "Failed to include Hunter config of Kagome")
endif()
