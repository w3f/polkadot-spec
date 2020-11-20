use crate::builder::{BlockCmd, GenesisCmd, PalletBalancesCmd};

use crate::Result;
use processor::{Processor, Task};

use std::cmp::PartialEq;
use std::hash::Hash;

mod processor;
pub use processor::{Mapper, TaskOutcome};

mapping!(
    PalletBalances => PalletBalancesCmd,
    Block => BlockCmd,
    Genesis => GenesisCmd,
);

pub fn run_tool_spec(yaml: &str) -> Result<()> {
    Processor::<Mapping>::new(yaml)?.process()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn build_block() {
        run_tool_spec(r#"
            - name: Build block
              block:
                build:
                  header:
                    parent_hash: "0x0000000000000000000000000000000000000000000000000000000000000000"
                    number: "0x1"
                    digest:
                      logs: []
                  extrinsics: []
        "#).unwrap();
    }

    #[test]
    fn pallet_balances() {
        run_tool_spec(
            r#"
            - name: Balance transfer
              pallet_balances:
                transfer:
                  from: alice
                  to: bob
                  balance: 100
        "#,
        )
        .unwrap()
    }

    #[test]
    fn genesis() {
        run_tool_spec(
            r#"
            - name: Create genesis
              genesis:
                custom:
                  accounts:
                    - alice
                    - bob
                    - eve
        "#,
        )
        .unwrap()
    }
}
