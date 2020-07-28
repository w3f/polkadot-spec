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

# TODO: Move away from custom kagome branch for testing
hunter_config(kagome
    URL https://github.com/soramitsu/kagome/archive/219d46ff77ae8b77974373653ce25e720ef0645f.tar.gz
    SHA1 1a0827b729b4dc1e40e37887df53f05bbcac3607
)
hunter_config(libsecp256k1
    URL https://github.com/soramitsu/soramitsu-libsecp256k1/archive/c7630e1bac638c0f16ee66d4dce7b5c49eecbaa5.zip
    SHA1 179e316b0fe5150f1b05ca70ec2ac1490fe2cb3b
    CMAKE_ARGS SECP256K1_BUILD_TEST=OFF
    )
