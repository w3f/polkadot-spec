// This file is part of Substrate.

// Copyright (C) 2017-2020 Parity Technologies (UK) Ltd.
// SPDX-License-Identifier: Apache-2.0

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

use crate::builder::Builder;
use crate::cli::{Cli, Subcommand};
use crate::tool_spec::run_tool_spec;
use crate::Result;
use std::fs;
use structopt::StructOpt;

/// Parse and run command line arguments
pub fn run() -> Result<()> {
    let cli = Cli::from_args();

    if let Some(path) = cli.spec_path {
        run_tool_spec(&fs::read_to_string(path)?)?;
    }

    match cli.subcommand {
        Some(Subcommand::PalletBalances(cmd)) => cmd.run_and_print()?,
        _ => {}
    };

    Ok(())
}
