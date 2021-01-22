use substrate_wasm_builder::WasmBuilder;

fn main() {
	let mut b = WasmBuilder::new()
		.with_current_project()
		.export_heap_base();

	if !cfg!(feature = "export-memory") {
		b = b.import_memory();
	}

	b.build()
}
