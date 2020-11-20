use super::Result;
use crate::primitives::runtime::{AccountId, RuntimeCall, SignedExtra, UncheckedExtrinsic};
use crate::tool_spec::TaskOutcome;
use codec::Encode;
use serde::de::DeserializeOwned;
use serde::ser::Serialize;
use sp_core::crypto::Pair;
use sp_runtime::generic::{Era, SignedPayload};
use sp_runtime::traits::SignedExtension;
use sp_runtime::MultiSignature;

pub mod balances;
pub mod blocks;
pub mod genesis;

pub use balances::PalletBalancesCmd;
pub use blocks::BlockCmd;
pub use genesis::GenesisCmd;

pub trait ModuleInfo {
    fn module_name(&self) -> ModuleName;
    fn function_name(&self) -> FunctionName;
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModuleName(&'static str);

impl ModuleName {
    const fn from(value: &'static str) -> Self {
        ModuleName(value)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FunctionName(&'static str);

impl FunctionName {
    const fn from(value: &'static str) -> Self {
        FunctionName(value)
    }
}

pub trait Builder: Sized + ModuleInfo {
    type Input: DeserializeOwned;
    type Output: Serialize;

    fn run(self) -> Result<Self::Output>;
    fn run_and_print(self) -> Result<()> {
        println!(
            "{}",
            serde_json::to_string_pretty(&TaskOutcome {
                task_name: Option::<String>::None,
                module: self.module_name(),
                function: self.function_name(),
                data: self.run()?,
            })?
        );

        Ok(())
    }
}

fn create_tx<P: Pair>(pair: P, function: RuntimeCall, nonce: u32) -> Result<UncheckedExtrinsic>
where
    AccountId: From<<P as Pair>::Public>,
    MultiSignature: From<<P as Pair>::Signature>,
{
    fn extra_err() -> failure::Error {
        failure::err_msg("Failed to retrieve additionally signed extra")
    }

    let check_spec_version = frame_system::CheckSpecVersion::new();
    let check_tx_version = frame_system::CheckTxVersion::new();
    let check_genesis = frame_system::CheckGenesis::new();
    let check_era = frame_system::CheckEra::from(Era::Immortal);
    let check_nonce = frame_system::CheckNonce::from(nonce);
    let check_weight = frame_system::CheckWeight::new();
    let payment = pallet_transaction_payment::ChargeTransactionPayment::from(0);

    #[rustfmt::skip]
    let additional_extra = (
        check_spec_version.additional_signed().map_err(|_| extra_err())?,
        check_tx_version.additional_signed().map_err(|_| extra_err())?,
        check_genesis.additional_signed().map_err(|_| extra_err())?,
        check_era.additional_signed().map_err(|_| extra_err())?,
        check_nonce.additional_signed().map_err(|_| extra_err())?,
        check_weight.additional_signed().map_err(|_| extra_err())?,
        payment.additional_signed().map_err(|_| extra_err())?,
    );

    let extra: SignedExtra = (
        check_spec_version,
        check_tx_version,
        check_genesis,
        check_era,
        check_nonce,
        check_weight,
        payment,
    );

    let payload = SignedPayload::from_raw(function, extra, additional_extra);

    let signature = payload.using_encoded(|payload| pair.sign(payload));

    let (function, extra, _) = payload.deconstruct();

    Ok(UncheckedExtrinsic::new_signed(
        function,
        pair.public().into(),
        signature.into(),
        extra,
    ))
}
