use super::create_tx;
use crate::builder::genesis::get_account_id_from_seed;
use crate::executor::ClientInMem;
use crate::primitives::runtime::{Balance, BlockId, RuntimeCall};
use crate::primitives::{ExtrinsicSigner, RawExtrinsic, SpecAccountSeed, SpecChainSpec, SpecHash};
use crate::Result;
use pallet_balances::Call as BalancesCall;
use sc_client_api::BlockBackend;
use sp_core::crypto::Pair;
use sp_core::H256;
use std::convert::{TryFrom, TryInto};
use std::fs;
use std::path::Path;
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

#[derive(Debug, StructOpt, Serialize, Deserialize)]
#[serde(untagged)]
enum ExtraSigned {
    ManualParams(ManualParams),
    FromChainSpec(FromChainSpec),
}

#[derive(Debug, StructOpt, Serialize, Deserialize)]
struct ManualParams {
    #[structopt(long)]
    spec_version: u32,
    #[structopt(long)]
    transaction_version: u32,
    #[structopt(long)]
    genesis_hash: SpecHash,
}

// Temporary work-around for structopt. This will be adjusted to make the CLI
// prettier.
#[derive(Debug, StructOpt, Serialize, Deserialize)]
struct FromChainSpec {
    from_chain_spec: String,
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
            #[structopt(subcommand)]
            extra_signed: ExtraSigned,
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
                    extra_signed,
                } => {
                    let (spec_version, transaction_version, genesis_hash): (_, _, H256) = match extra_signed {
                        ExtraSigned::ManualParams(params) => {
                            (
                                params.spec_version,
                                params.transaction_version,
                                params.genesis_hash.try_into()?,
                            )
                        }
                        ExtraSigned::FromChainSpec(spec) => {
                            let raw = fs::read_to_string(&spec.from_chain_spec)?;
                            let client = ClientInMem::new_with_genesis(SpecChainSpec::from_str(&raw)?.try_into()?)?;
                            let client = client.raw();

                            let best_block_id = BlockId::number(client.chain_info().best_number);
                            let (spec_version, transaction_version) = {
                                let version = client.runtime_version_at(&best_block_id).map_err(|_| failure::err_msg("failed to fetch runtime version from chain spec"))?;
                                (version.spec_version, version.transaction_version)
                            };
                            let genesis_hash = client.block_hash(0).map_err(|_| failure::err_msg("failed to fetch genesis hash from chain spec"))?.ok_or(failure::err_msg("No genesis hash available in chain spec"))?;

                            (
                                spec_version,
                                transaction_version,
                                genesis_hash,
                            )
                        }
                    };

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
