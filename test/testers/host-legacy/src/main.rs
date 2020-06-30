use primitives::{Pair, Public, sr25519};
use runtime::{
	AccountId, BabeConfig, BalancesConfig, GenesisConfig, GrandpaConfig,
	SudoConfig, SystemConfig, WASM_BINARY, Signature
};

use babe_primitives::AuthorityId as BabeId;
use grandpa_primitives::AuthorityId as GrandpaId;
use substrate_service;
use sr_primitives::traits::{Verify, IdentifyAccount};

/// Specialized `ChainSpec`. This is a specialization of the general Substrate ChainSpec type.
type ChainSpec = substrate_service::ChainSpec<GenesisConfig>;

/// Helper function to generate a crypto pair from seed
fn get_from_seed<TPublic: Public>(seed: &str) -> <TPublic::Pair as Pair>::Public {
	TPublic::Pair::from_string(&format!("//{}", seed), None)
		.expect("static values are valid; qed")
		.public()
}

type AccountPublic = <Signature as Verify>::Signer;

/// Helper function to generate an account ID from seed
fn get_account_id_from_seed<TPublic: Public>(seed: &str) -> AccountId where
	AccountPublic: From<<TPublic::Pair as Pair>::Public>
{
	AccountPublic::from(get_from_seed::<TPublic>(seed)).into_account()
}

/// Generate default genesis config
fn default_genesis_config() -> GenesisConfig {
	GenesisConfig {
		system: Some(SystemConfig {
			code: WASM_BINARY.to_vec(),
			changes_trie_config: Default::default(),
		}),
		balances: Some(BalancesConfig {
	    balances:vec![
			  get_account_id_from_seed::<sr25519::Public>("Alice"),
				get_account_id_from_seed::<sr25519::Public>("Bob"),
				get_account_id_from_seed::<sr25519::Public>("Alice//stash"),
				get_account_id_from_seed::<sr25519::Public>("Bob//stash"),
			].iter().cloned().map(|k|(k, 1 << 60)).collect(),
			vesting: vec![],
		}),
	babe: Some(BabeConfig {
      authorities: vec![
        (get_from_seed::<BabeId>("Alice"), 1),
        (get_from_seed::<BabeId>("Bob")  , 1),
      ],
		}),
		grandpa: Some(GrandpaConfig {
      authorities: vec![
        (get_from_seed::<GrandpaId>("Alice"), 1),
        (get_from_seed::<GrandpaId>("Bob")  , 1),
      ],
		}),
    sudo: Some(SudoConfig {
			key: get_account_id_from_seed::<sr25519::Public>("Alice"),
    }),
	}
}

/// Create default chain spec
fn default_chain_spec() -> ChainSpec {
  ChainSpec::from_genesis(
    "Specification Conformance Test Runtime",
    "spectest",
    default_genesis_config,
    vec![],
    None,
    None,
    None,
    None,
	)
}

fn main() {
    let raw = true;

    match default_chain_spec().to_json(raw) {
        Ok(json) => println!("{}", json),
        Err(err) => eprintln!("Error: {}", err),
    }
}
