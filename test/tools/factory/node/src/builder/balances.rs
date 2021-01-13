use super::create_tx;
use crate::builder::genesis::get_account_id_from_seed;
use crate::builder::{Builder, FunctionName, ModuleInfo, ModuleName};
use crate::executor::ClientInMem;
use crate::primitives::runtime::{Balance, BlockId, RuntimeCall};
use crate::primitives::{ExtrinsicSigner, RawExtrinsic, SpecAccountSeed, SpecChainSpec, SpecHash};
use crate::Result;
use pallet_balances::Call as BalancesCall;
use sc_client_api::BlockBackend;
use sp_core::crypto::Pair;
use sp_core::H256;
use std::convert::{TryFrom, TryInto};
use std::str::FromStr;

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

#[derive(Debug, Serialize, Deserialize)]
#[serde(untagged)]
pub enum ExtraSigned {
    ManualParams(ManualParams),
    FromChainSpec(SpecChainSpec),
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ManualParams {
    spec_version: u32,
    transaction_version: u32,
    genesis_hash: SpecHash,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename = "pallet_balances")]
pub struct PalletBalancesCmd {
    call: CallCmd,
}

#[derive(Debug, Serialize, Deserialize)]
pub enum CallCmd {
    #[serde(rename = "transfer")]
    Transfer {
        from: SpecAccountSeed,
        to: SpecAccountSeed,
        balance: u64,
        nonce: u32,
        extra_signed: ExtraSigned,
    },
}

impl From<CallCmd> for PalletBalancesCmd {
    fn from(val: CallCmd) -> Self {
        PalletBalancesCmd { call: val }
    }
}

impl ModuleInfo for CallCmd {
    fn module_name(&self) -> crate::builder::ModuleName {
        ModuleName::from("pallet_balances")
    }
    fn function_name(&self) -> crate::builder::FunctionName {
        match self {
            CallCmd::Transfer { .. } => FunctionName::from("transfer"),
        }
    }
}

impl Builder for PalletBalancesCmd {
    type Input = CallCmd;
    type Output = RawExtrinsic;

    fn run(self, client: &ClientInMem) -> Result<RawExtrinsic> {
        match self.call {
            CallCmd::Transfer {
                from,
                to,
                balance,
                nonce,
                extra_signed,
            } => {
                let (spec_version, transaction_version, genesis_hash): (_, _, H256) =
                    match extra_signed {
                        ExtraSigned::ManualParams(params) => (
                            params.spec_version,
                            params.transaction_version,
                            params.genesis_hash.try_into()?,
                        ),
                        ExtraSigned::FromChainSpec(_) => {
                            // Expose the raw client
                            let client = client.raw();

                            let best_block_id = BlockId::number(client.chain_info().best_number);
                            let (spec_version, transaction_version) = {
                                let version =
                                    client.runtime_version_at(&best_block_id).map_err(|_| {
                                        failure::err_msg(
                                            "failed to fetch runtime version from chain spec",
                                        )
                                    })?;
                                (version.spec_version, version.transaction_version)
                            };
                            let genesis_hash = client
                                .block_hash(0)
                                .map_err(|_| {
                                    failure::err_msg("failed to fetch genesis hash from chain spec")
                                })?
                                .ok_or(failure::err_msg(
                                    "No genesis hash available in chain spec",
                                ))?;

                            (spec_version, transaction_version, genesis_hash)
                        }
                    };

                create_tx::<ExtrinsicSigner>(
                    ExtrinsicSigner::try_from(from.clone())?,
                    RuntimeCall::Balances(BalancesCall::transfer(
                        get_account_id_from_seed::<<ExtrinsicSigner as Pair>::Public>(&format!(
                            "//{}",
                            to.as_str()
                        ))
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
