// Copyright (c) 2019 Web3 Technologies Foundation

// This file is part of Polkadot RE Test Suite

// Polkadot RE Test Suite is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Polkadot RE Tests is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Polkadot RE Test Suite.  If not, see <https://www.gnu.org/licenses/>.

///This file is an interface to run various Polkadot RE functions

// Command line arg parser
#[macro_use]
extern crate clap;

// For PDRE API
extern crate hex;
extern crate executor;
extern crate primitives;
extern crate state_machine;

use clap::App;

mod host_api;

fn main() {
    let yaml_data = load_yaml!("cli.yaml");
    let matches = App::from_yaml(yaml_data).get_matches();

    if let Some(matches) = matches.subcommand_matches("host-api") {
        host_api::process_host_api_tests(matches);
    }
}
