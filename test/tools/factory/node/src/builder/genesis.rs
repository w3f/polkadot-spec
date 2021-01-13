use crate::primitives::runtime::{
    AccountId, AuraConfig, BalancesConfig, GenesisConfig, GrandpaConfig, Signature, SudoConfig,
    SystemConfig, WASM_BINARY,
};
use crate::primitives::{ChainSpec, ExtrinsicSigner, SpecAccountSeed, SpecChainSpecRaw};
use crate::Result;
use sc_service::ChainType;
use sp_consensus_aura::sr25519::AuthorityId as AuraId;
use sp_core::{sr25519, Pair, Public};
use sp_finality_grandpa::AuthorityId as GrandpaId;
use sp_runtime::traits::{IdentifyAccount, Verify};
use std::convert::{TryFrom, TryInto};

module!(
    #[serde(rename = "genesis")]
    struct GenesisCmd;

    enum CallCmd {
        #[serde(rename = "default")]
        Default {},
        #[serde(rename = "custom")]
        Custom {
            accounts: Vec<SpecAccountSeed>,
        },
    }

    impl GenesisCmd {
        fn run(self) -> Result<SpecChainSpecRaw> {
            match self.call {
                CallCmd::Default {} => gen_chain_spec_default()?.try_into(),
                CallCmd::Custom { accounts } => gen_chain_spec_with_accounts(
                    accounts
                        .into_iter()
                        .map(|seed| ExtrinsicSigner::try_from(seed).map(|pair| pair.public().into()))
                        .collect::<Result<Vec<AccountId>>>()?,
                )?
                .try_into(),
            }
        }
    }
);

/// Generate a crypto pair from seed.
pub fn get_from_seed<TPublic: Public>(seed: &str) -> <TPublic::Pair as Pair>::Public {
    TPublic::Pair::from_string(&format!("//{}", seed), None)
        .expect("static values are valid; qed")
        .public()
}

type AccountPublic = <Signature as Verify>::Signer;

/// Generate an account ID from seed.
pub fn get_account_id_from_seed<TPublic: Public>(seed: &str) -> AccountId
where
    AccountPublic: From<<TPublic::Pair as Pair>::Public>,
{
    AccountPublic::from(get_from_seed::<TPublic>(seed)).into_account()
}

/// Generate an Aura authority key.
pub fn authority_keys_from_seed(s: &str) -> (AuraId, GrandpaId) {
    (get_from_seed::<AuraId>(s), get_from_seed::<GrandpaId>(s))
}

pub fn gen_chain_spec_default() -> Result<ChainSpec> {
    gen_chain_spec_with_accounts(vec![
        get_account_id_from_seed::<<ExtrinsicSigner as Pair>::Public>("alice"),
        get_account_id_from_seed::<<ExtrinsicSigner as Pair>::Public>("bob"),
        get_account_id_from_seed::<<ExtrinsicSigner as Pair>::Public>("dave"),
    ])
}

pub fn gen_chain_spec_with_accounts(endowed_accounts: Vec<AccountId>) -> Result<ChainSpec> {
    let wasm_binary =
        WASM_BINARY.ok_or(failure::err_msg("Development wasm binary not available"))?;

    Ok(ChainSpec::from_genesis(
        // Name
        "Development",
        // ID
        "dev",
        ChainType::Development,
        move || {
            testnet_genesis(
                wasm_binary,
                // Initial PoA authorities
                vec![authority_keys_from_seed("alice")],
                // Sudo account
                get_account_id_from_seed::<sr25519::Public>("alice"),
                // Pre-funded accounts
                &endowed_accounts,
                true,
            )
        },
        // Bootnodes
        vec![],
        // Telemetry
        None,
        // Protocol ID
        None,
        // Properties
        None,
        // Extensions
        None,
    ))
}

/// Configure initial storage state for FRAME modules.
fn testnet_genesis(
    wasm_binary: &[u8],
    initial_authorities: Vec<(AuraId, GrandpaId)>,
    root_key: AccountId,
    endowed_accounts: &Vec<AccountId>,
    _enable_println: bool,
) -> GenesisConfig {
    GenesisConfig {
        frame_system: Some(SystemConfig {
            // Add Wasm runtime to storage.
            code: wasm_binary.to_vec(),
            changes_trie_config: Default::default(),
        }),
        pallet_balances: Some(BalancesConfig {
            // Configure endowed accounts with initial balance of 1 << 60.
            balances: endowed_accounts
                .iter()
                .cloned()
                .map(|k| (k, 1 << 60))
                .collect(),
        }),
        pallet_aura: Some(AuraConfig {
            authorities: initial_authorities.iter().map(|x| (x.0.clone())).collect(),
        }),
        pallet_grandpa: Some(GrandpaConfig {
            authorities: initial_authorities
                .iter()
                .map(|x| (x.1.clone(), 1))
                .collect(),
        }),
        pallet_sudo: Some(SudoConfig {
            // Assign network admin rights.
            key: root_key,
        }),
    }
}
