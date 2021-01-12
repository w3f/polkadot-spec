use super::create_tx;
use crate::builder::genesis::get_account_id_from_seed;
use crate::primitives::runtime::{Balance, RuntimeCall};
use crate::primitives::{ExtrinsicSigner, RawExtrinsic, SpecAccountSeed, SpecHash};
use crate::Result;
use pallet_balances::Call as BalancesCall;
use sp_core::crypto::Pair;
use std::convert::{TryFrom, TryInto};
use std::str::FromStr;
use structopt::StructOpt;

#[derive(Debug, Clone, Serialize, Deserialize)]
struct RawPrivateKey(Vec<u8>);

impl FromStr for RawPrivateKey {
    type Err = failure::Error;

    fn from_str(val: &str) -> Result<Self> {
        Ok(RawPrivateKey(
            hex::decode(val.replace("0x", ""))
                .map_err(|err| err.into())
                .and_then(|b| {
                    if b.len() == 32 {
                        Ok(b)
                    } else {
                        Err(failure::err_msg("Private key seed must be 32 bytes"))
                    }
                })?,
        ))
    }
}

module!(
    #[serde(rename = "pallet_balances")]
    struct PalletBalancesCmd;

    enum CallCmd {
        #[serde(rename = "transfer")]
        Transfer {
            #[structopt(long)]
            from: SpecAccountSeed,
            #[structopt(long)]
            to: SpecAccountSeed,
            #[structopt(long)]
            balance: u64,
            #[structopt(long)]
            nonce: u32,
            #[structopt(long)]
            spec_version: u32,
            #[structopt(long)]
            transaction_version: u32,
            #[structopt(long)]
            genesis_hash: SpecHash,
        },
    }

    impl PalletBalancesCmd {
        fn run(self) -> Result<RawExtrinsic> {
            match self.call {
                CallCmd::Transfer {
                    from,
                    to,
                    balance,
                    nonce,
                    spec_version,
                    transaction_version,
                    genesis_hash,
                } => {
                    create_tx::<ExtrinsicSigner>(
                        ExtrinsicSigner::try_from(from.clone())?,
                        RuntimeCall::Balances(BalancesCall::transfer(
                            get_account_id_from_seed::<<ExtrinsicSigner as Pair>::Public>(
                                &format!("//{}", to.as_str()),
                            )
                            .into(),
                            balance as Balance,
                        )),
                        nonce,
                        spec_version,
                        transaction_version,
                        genesis_hash.try_into()?,
                    )
                    .map(|t| RawExtrinsic::from(t))
                }
            }
        }
    }
);
