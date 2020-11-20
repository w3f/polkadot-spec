use super::Result;
use crate::builder::{Builder, GenesisCmd};
use crate::primitives::runtime::{Block, BlockId, RuntimeApi, RuntimeApiImpl};
use crate::primitives::ChainSpec;
use sc_client_api::in_mem::Backend;
use sc_executor::native_executor_instance;
use sc_executor::{NativeExecutor, WasmExecutionMethod};
use sc_service::client::{new_in_mem, Client, ClientConfig, LocalCallExecutor};
use sp_api::{ApiRef, ProvideRuntimeApi};
use sp_core::testing::TaskExecutor;
use sp_runtime::BuildStorage;
use sp_state_machine::InspectState;
use std::convert::TryFrom;

// Native executor instance.
native_executor_instance!(
    pub Executor,
    toolkit_runtime::api::dispatch,
    toolkit_runtime::native_version,
    frame_benchmarking::benchmarking::HostFunctions,
);

type ClientInMemDef = Client<
    Backend<Block>,
    LocalCallExecutor<Backend<Block>, NativeExecutor<Executor>>,
    Block,
    RuntimeApi,
>;

pub struct ClientInMem {
    client: ClientInMemDef,
}

impl ClientInMem {
    pub fn new() -> Result<ClientInMem> {
        Ok(ClientInMem {
            client: new_in_mem::<_, Block, _, _>(
                NativeExecutor::<Executor>::new(WasmExecutionMethod::Interpreted, None, 8),
                &ChainSpec::try_from(GenesisCmd::default().run()?)?
                    .build_storage()
                    .map_err(|_| failure::err_msg("Failed to build temporary chain-spec"))?,
                None,
                None,
                Box::new(TaskExecutor::new()),
                ClientConfig::default(),
            )
            .map_err(|_| failure::err_msg("failed to create in-memory client"))?,
        })
    }
    #[allow(dead_code)]
    pub fn new_with_genesis(chain_spec: ChainSpec) -> Result<ClientInMem> {
        Ok(ClientInMem {
            client: new_in_mem::<_, Block, _, _>(
                NativeExecutor::<Executor>::new(WasmExecutionMethod::Interpreted, None, 8),
                &chain_spec
                    .build_storage()
                    .map_err(|_| failure::err_msg("Failed to build provided chain-spec"))?,
                None,
                None,
                Box::new(TaskExecutor::new()),
                ClientConfig::default(),
            )
            .map_err(|_| failure::err_msg("failed to create in-memory client"))?,
        })
    }
    pub fn exec_context<T, F: FnOnce() -> Result<Option<T>>>(
        &self,
        at: &BlockId,
        f: F,
    ) -> Result<Option<T>> {
        let mut res = Ok(None);
        self.client
            .state_at(at)
            .map_err(|_| failure::err_msg("Failed to set state"))?
            .inspect_with(|| {
                res = f();
            });

        res
    }
    pub fn runtime_api<'a>(&'a self) -> ApiRef<'a, RuntimeApiImpl<Block, ClientInMemDef>> {
        self.client.runtime_api()
    }
}
