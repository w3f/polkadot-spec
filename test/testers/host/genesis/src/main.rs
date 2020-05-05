use sp_core::{Pair, Public, sr25519};
use host_tester_runtime::{
	AccountId, BalancesConfig, GenesisConfig,
	SudoConfig, SystemConfig, WASM_BINARY, Signature
};
use sc_service::{GenericChainSpec, ChainType};
use sp_runtime::traits::{Verify, IdentifyAccount};

/// Specialized `ChainSpec`. This is a specialization of the general Substrate ChainSpec type.
type ChainSpec = GenericChainSpec<GenesisConfig>;

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

/// Create default chain specification
fn default_chain_spec() -> ChainSpec {
  ChainSpec::from_genesis(
	  "Specification Test Runtime",
		"spectest",
    ChainType::Local,
	  || GenesisConfig {
		  system: Some(SystemConfig {
			  code: WASM_BINARY.to_vec(),
			  changes_trie_config: Default::default(),
		  }),
		  balances: Some(BalancesConfig {
			  balances: vec![
			    get_account_id_from_seed::<sr25519::Public>("Alice"),
				  get_account_id_from_seed::<sr25519::Public>("Bob"),
				  get_account_id_from_seed::<sr25519::Public>("Alice//stash"),
				  get_account_id_from_seed::<sr25519::Public>("Bob//stash"),
			  ].iter().cloned().map(|k|(k, 1 << 60)).collect(),
		  }),
      babe: Some(Default::default()),
      grandpa: Some(Default::default()),
		  sudo: Some(SudoConfig {
			  key: get_account_id_from_seed::<sr25519::Public>("Alice"),
		  }),
	  },
		vec![], // Bootnodes
 		None,   // Telemetry
		None,   // Protocol Id
		None,   // Properties
		None,   // Extensions
	)
}

fn main() {
    let raw = true;

    match default_chain_spec().as_json(raw) {
        Ok(json) => println!("{}", json),
        Err(err) => eprintln!("Error: {}", err),
    }
}
