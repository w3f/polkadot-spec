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

# Remove these after they have been collecting into hunter config (otherwise causes build issues)
hunter_config(libp2p
  URL https://github.com/soramitsu/cpp-libp2p/archive/517ca6e4a07db50a87767a3a75258ba3c58776b7.zip
  SHA1 4c191fcb8e9000f663ee665b13c4a55370101470
  CMAKE_ARGS TESTING=OFF
)

hunter_config(libsecp256k1
  URL https://github.com/soramitsu/soramitsu-libsecp256k1/archive/c7630e1bac638c0f16ee66d4dce7b5c49eecbaa5.zip
  SHA1 179e316b0fe5150f1b05ca70ec2ac1490fe2cb3b
  CMAKE_ARGS SECP256K1_BUILD_TEST=OFF
)
