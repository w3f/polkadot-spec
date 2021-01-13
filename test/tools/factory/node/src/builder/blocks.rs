use crate::builder::{Builder, FunctionName, ModuleInfo, ModuleName};
use crate::executor::ClientInMem;
use crate::primitives::runtime::{Block, BlockId, Header, Timestamp};
use crate::primitives::{RawBlock, SpecBlock, SpecChainSpecRaw, SpecGenesisSource};
use crate::Result;
use sp_api::Core;
use sp_block_builder::BlockBuilder;
use sp_inherents::InherentData;
use sp_runtime::transaction_validity::TransactionValidityError;
use std::convert::{TryFrom, TryInto};
use std::fs;
use std::str::FromStr;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(untagged)]
pub enum BlockCmdResult {
    BuildBlock(BuildBlockMeta),
    ExecuteBlocks,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BuildBlockMeta {
    header: Header,
    raw_block: RawBlock,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BlockCmd {
    call: CallCmd,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum CallCmd {
    #[serde(rename = "build")]
    BuildBlock {
        #[serde(flatten)]
        spec_block: SpecBlock,
    },
    #[serde(rename = "execute")]
    ExecuteBlocks {
        #[serde(flatten)]
        blocks: Vec<RawBlock>,
    },
}

impl From<CallCmd> for BlockCmd {
    fn from(val: CallCmd) -> Self {
        BlockCmd { call: val }
    }
}

impl ModuleInfo for CallCmd {
    fn module_name(&self) -> crate::builder::ModuleName {
        ModuleName::from("block")
    }
    fn function_name(&self) -> crate::builder::FunctionName {
        match self {
            CallCmd::BuildBlock { .. } => FunctionName::from("build"),
            CallCmd::ExecuteBlocks { .. } => FunctionName::from("execute"),
        }
    }
}

impl Builder for BlockCmd {
    type Input = CallCmd;
    type Output = BlockCmdResult;

    fn run(self, client: &ClientInMem) -> Result<BlockCmdResult> {
        match self.call {
            CallCmd::BuildBlock { spec_block } => {
                // Convert into runtime types.
                let (at, header, extrinsics) = spec_block.prep(&client)?;

                let rt = client.runtime_api();

                rt.initialize_block(&at, &header).map_err(|err| {
                    failure::err_msg(format!("Failed to initialize block: {}", err))
                })?;

                for extr in &extrinsics {
                    let apply_result = rt.apply_extrinsic(&at, extr.clone()).map_err(|err| {
                        failure::err_msg(format!("Failed to apply extrinsic: {}", err))
                    })?;

                    if let Err(validity) = apply_result {
                        if validity.exhausted_resources() {
                            return Err(failure::err_msg("Resources exhausted"));
                        } else {
                            return Err(failure::err_msg(format!(
                                "Invalid transaction: {}",
                                <TransactionValidityError as Into<&'static str>>::into(validity)
                            )));
                        }
                    }
                }

                // Create timestamp in an externalities-provided environment.
                let timestamp = client
                    .exec_context(&at, || Ok(Some(Timestamp::now())))
                    .unwrap()
                    .unwrap();

                // Include inherent.
                let x = rt
                    .inherent_extrinsics(&at, {
                        let mut inherent = InherentData::new();
                        inherent.put_data(*b"timstap0", &timestamp).map_err(|err| {
                            failure::err_msg(format!("Failed to create inherent: {}", err))
                        })?;
                        inherent
                    })
                    .map_err(|err| {
                        failure::err_msg(format!("Failed to include inherent: {}", err))
                    })?;

                for e in x {
                    let _ = rt.apply_extrinsic(&at, e).map_err(|err| {
                        failure::err_msg(format!("Failed to apply extrinsic: {}", err))
                    })?;
                }

                let header = rt
                    .finalize_block(&at)
                    .map_err(|_| failure::err_msg("Failed to finalize block"))?;

                Ok(BlockCmdResult::BuildBlock(BuildBlockMeta {
                    header: header.clone(),
                    raw_block: Block {
                        header: header,
                        extrinsics: extrinsics,
                    }
                    .into(),
                }))
            }
            CallCmd::ExecuteBlocks { blocks } => {
                // Create the block by calling the runtime APIs.
                let client = ClientInMem::new()?;
                let rt = client.runtime_api();

                // Convert into runtime native type.
                let blocks = blocks
                    .into_iter()
                    .map(|raw| Block::try_from(raw))
                    .collect::<Result<Vec<Block>>>()?;

                for block in blocks {
                    let at = BlockId::Hash(block.header.parent_hash.clone().try_into()?);

                    rt.execute_block(&at, block.try_into()?).map_err(|err| {
                        failure::err_msg(format!("Failed to execute block: {}", err))
                    })?;
                }

                Ok(BlockCmdResult::ExecuteBlocks)
            }
        }
    }
}
