use super::builder;
use std::path::PathBuf;
use structopt::StructOpt;

#[derive(Debug, StructOpt)]
pub struct Cli {
    #[structopt(subcommand)]
    pub subcommand: Option<Subcommand>,

    #[structopt(parse(from_os_str))]
    pub spec_path: Option<PathBuf>,
}

#[derive(Debug, StructOpt)]
pub enum Subcommand {
    PalletBalances(builder::PalletBalancesCmd),
}
