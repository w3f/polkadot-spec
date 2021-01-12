use crate::executor::ClientInMem;
use crate::Result;
use codec::Decode;
use codec::Encode;
use runtime::{Block, BlockId, BlockNumber, Header, UncheckedExtrinsic};
use sc_client_api::BlockBackend;
use sc_service::GenericChainSpec;
use sp_core::crypto::Pair;
use sp_core::sr25519;
use sp_core::H256;
use sp_runtime::generic::{Digest, DigestItem};
use std::collections::HashMap;
use std::convert::{TryFrom, TryInto};
use std::mem;
use std::str::FromStr;

/*
# RUNTIME TYPES

/// Alias to 512-bit hash when used in the context of a transaction signature on the chain.
pub type Signature = MultiSignature;
/// The address format for describing accounts.
pub type Address = AccountId;
/// An index to a block.
pub type BlockNumber = u32;
/// Block header type as expected by this runtime.
pub type Header = generic::Header<BlockNumber, BlakeTwo256>;
/// Block type as expected by this runtime.
pub type Block = generic::Block<Header, UncheckedExtrinsic>;
/// Unchecked extrinsic type as expected by this runtime.
pub type UncheckedExtrinsic = generic::UncheckedExtrinsic<Address, Call, Signature, SignedExtra>;
/// The SignedExtension to the basic transaction logic.
pub type SignedExtra = (
    frame_system::CheckSpecVersion<Runtime>,
    frame_system::CheckTxVersion<Runtime>,
    frame_system::CheckGenesis<Runtime>,
    frame_system::CheckEra<Runtime>,
    frame_system::CheckNonce<Runtime>,
    frame_system::CheckWeight<Runtime>,
    pallet_transaction_payment::ChargeTransactionPayment<Runtime>
);
*/

pub mod runtime {
    // `AccountId` -> `sp_runtime::AccountId32`
    pub use factory_runtime::{
        AccountId, Address, AuraConfig, Balance, BalancesConfig, Block, BlockId, BlockNumber,
        Call as RuntimeCall, CheckedExtrinsic, GenesisConfig, GrandpaConfig, Header, Runtime,
        RuntimeApi, RuntimeApiImpl, Signature, SignedExtra, SudoConfig, SystemConfig, Timestamp,
        TimestampCall, UncheckedExtrinsic, WASM_BINARY,
    };
}

from_str!(SpecHash, SpecBlockNumber, SpecExtrinsic, SpecAccountSeed,);

pub type ChainSpec = GenericChainSpec<runtime::GenesisConfig>;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GenericJson(HashMap<String, serde_json::Value>);

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SpecChainSpecRaw(GenericJson);

impl FromStr for SpecChainSpecRaw {
    type Err = failure::Error;

    fn from_str(s: &str) -> Result<Self> {
        Ok(SpecChainSpecRaw(serde_json::from_str(s)?))
    }
}

impl TryFrom<ChainSpec> for SpecChainSpecRaw {
    type Error = failure::Error;

    fn try_from(value: ChainSpec) -> Result<Self> {
        Ok(SpecChainSpecRaw(serde_json::from_str(
            &value.as_json(false).map_err(|err| {
                failure::err_msg(format!("Failed to parse chain spec as json: {}", err))
            })?,
        )?))
    }
}

impl TryFrom<SpecChainSpecRaw> for ChainSpec {
    type Error = failure::Error;

    fn try_from(value: SpecChainSpecRaw) -> Result<Self> {
        ChainSpec::from_json_bytes(serde_json::to_vec(&value.0)?).map_err(|err| {
            failure::err_msg(format!("Failed to convert bytes into chain spec: {}", err))
        })
    }
}

// TODO: Those should be generic
pub type ExtrinsicSigner = sr25519::Pair;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SpecAccountSeed(String);

impl SpecAccountSeed {
    pub fn alice() -> Self {
        SpecAccountSeed("alice".to_string())
    }
    pub fn bob() -> Self {
        SpecAccountSeed("bob".to_string())
    }
    pub fn dave() -> Self {
        SpecAccountSeed("dave".to_string())
    }
    pub fn eve() -> Self {
        SpecAccountSeed("eve".to_string())
    }
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

const SAMPLE_ACCOUNTS: [&'static str; 4] = ["alice", "bob", "dave", "eve"];

impl TryFrom<SpecAccountSeed> for ExtrinsicSigner {
    type Error = failure::Error;

    fn try_from(value: SpecAccountSeed) -> Result<Self> {
        let input = value.0.to_ascii_lowercase();
        if SAMPLE_ACCOUNTS.contains(&input.as_str()) {
            Ok(ExtrinsicSigner::from_string(&format!("//{}", input), None)
                .map_err(|_| failure::err_msg("Invalid seed phrase"))?)
        } else {
            Ok(ExtrinsicSigner::from_string(&input, None)
                .map_err(|_| failure::err_msg("Invalid seed phrase"))?)
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RawExtrinsic(String);

impl From<UncheckedExtrinsic> for RawExtrinsic {
    fn from(val: UncheckedExtrinsic) -> Self {
        RawExtrinsic(hex::encode(val.encode()))
    }
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct RawBlock(String);

impl FromStr for RawBlock {
    type Err = failure::Error;

    fn from_str(val: &str) -> Result<Self> {
        Ok(RawBlock(String::from_utf8(hex::decode(&val)?)?))
    }
}

impl TryFrom<RawBlock> for Block {
    type Error = failure::Error;

    fn try_from(val: RawBlock) -> Result<Self> {
        Block::decode(&mut val.0.as_bytes()).map_err(|err| err.into())
    }
}

impl From<Block> for RawBlock {
    fn from(val: Block) -> Self {
        RawBlock(hex::encode(&val.encode()))
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SpecTestLayout<T> {
    pub name: String,
    #[serde(rename = "type")]
    pub test_ty: String,
    pub description: String,
    pub genesis: String,
    pub data: T,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct SpecHash(String);

impl TryFrom<SpecHash> for H256 {
    type Error = failure::Error;

    fn try_from(val: SpecHash) -> Result<Self> {
        Ok(H256::from_slice(
            &<[u8; 32]>::try_from(hex::decode(&val.0.replace("0x", ""))?)
                .map_err(|_| failure::err_msg("Failed to convert value into 256-bit hash"))?,
        ))
    }
}

impl From<H256> for SpecHash {
    fn from(val: H256) -> Self {
        SpecHash(hex::encode(val.as_bytes()))
    }
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct SpecBlockNumber(String);

impl TryFrom<SpecBlockNumber> for BlockNumber {
    type Error = failure::Error;

    fn try_from(val: SpecBlockNumber) -> Result<Self> {
        Ok(BlockNumber::from_str_radix(&val.0.replace("0x", ""), 16)?)
    }
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct SpecExtrinsic(String);

impl TryFrom<SpecExtrinsic> for UncheckedExtrinsic {
    type Error = failure::Error;

    fn try_from(val: SpecExtrinsic) -> Result<Self> {
        hex::decode(val.0.replace("0x", ""))
            .map_err(|err| failure::Error::from(err))
            .and_then(|bytes| {
                UncheckedExtrinsic::decode(&mut bytes.as_slice()).map_err(|err| err.into())
            })
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SpecBlock {
    pub chain_spec: SpecGenesisSource,
    pub header: SpecHeader,
    pub extrinsics: Vec<SpecExtrinsic>,
}

impl SpecBlock {
    // Convert relevant fields into runtime native types.
    pub fn prep(
        mut self,
        client: &ClientInMem,
    ) -> Result<(BlockId, Header, Vec<UncheckedExtrinsic>)> {
        // Convert into runtime types.
        let at = match self.header.parent_block {
            SpecParentHash::GenesisHash => {
                let genesis_hash = client
                    .raw()
                    .block_hash(0)
                    .map_err(|_| failure::err_msg("failed to fetch genesis hash from chain spec"))?
                    .ok_or(failure::err_msg("No genesis hash available in chain spec"))?;

                // Set the actual hash directly in the header.
                self.header.parent_block = SpecParentHash::Hash(genesis_hash.into());
                BlockId::Hash(genesis_hash)
            }

            SpecParentHash::Hash(ref mut hash) => BlockId::Hash(hash.clone().try_into()?),
        };

        let header = mem::take(&mut self.header).try_into()?;
        let extrinsics = mem::take(&mut self.extrinsics)
            .into_iter()
            .map(|e| e.try_into())
            .collect::<Result<Vec<UncheckedExtrinsic>>>()?;

        Ok((at, header, extrinsics))
    }
}

impl TryFrom<SpecBlock> for Block {
    type Error = failure::Error;

    fn try_from(val: SpecBlock) -> Result<Self> {
        Ok(Block {
            header: val.header.try_into()?,
            extrinsics: val
                .extrinsics
                .into_iter()
                .map(|e| e.try_into())
                .collect::<Result<Vec<UncheckedExtrinsic>>>()?,
        })
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub struct SpecChainSpec {
    pub chain_spec: SpecGenesisSource,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum SpecGenesisSource {
    Default,
    FromFile(String),
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct SpecHeader {
    pub parent_block: SpecParentHash,
    pub number: SpecBlockNumber,
    pub digest: SpecDigest,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum SpecParentHash {
    GenesisHash,
    Hash(SpecHash),
}

impl Default for SpecParentHash {
    fn default() -> Self {
        SpecParentHash::GenesisHash
    }
}

impl TryFrom<SpecParentHash> for H256 {
    type Error = failure::Error;

    fn try_from(val: SpecParentHash) -> Result<Self> {
        match val {
            // This should never occur.
            SpecParentHash::GenesisHash => Err(failure::err_msg(
                "Cannot convert genesis hash indicator to an actual hash",
            )),
            SpecParentHash::Hash(hash) => hash.try_into(),
        }
    }
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct SpecDigest {
    pub logs: Vec<String>,
}

impl TryFrom<SpecHeader> for Header {
    type Error = failure::Error;

    fn try_from(val: SpecHeader) -> Result<Self> {
        Ok(Header {
            parent_hash: val.parent_block.try_into()?,
            number: val.number.try_into()?,
            state_root: SpecHash::from_str(
                "0x0000000000000000000000000000000000000000000000000000000000000000",
            )?
            .try_into()?,
            extrinsics_root: SpecHash::from_str(
                "0x0000000000000000000000000000000000000000000000000000000000000000",
            )?
            .try_into()?,
            digest: Digest {
                logs: val
                    .digest
                    .logs
                    .iter()
                    .map(|d| hex::decode(d.replace("0x", "")).map_err(|err| err.into()))
                    .collect::<Result<Vec<Vec<u8>>>>()?
                    .iter_mut()
                    .map(|d| DigestItem::decode(&mut d.as_slice()).map_err(|err| err.into()))
                    .collect::<Result<Vec<DigestItem<H256>>>>()?,
            },
        })
    }
}
