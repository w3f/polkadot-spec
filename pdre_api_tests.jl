include("pdre_api_helpers.jl")
include("./fixtures/pdre_api_dataset.jl")
include("./fixtures/pdre_api_results.jl")

using Test

@testset "PDRE API Tests" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    cd(root_dir)

    run_dataset(
        PdreApiTestFunctions.value,
        [
            PdreApiTestData.value_1,
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.child_child_def_type_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.key_value_1,
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.child_child_def_type_key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.child_def_type_key_value_offset_buffer_size,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.key_value_1,
            PdreApiTestData.offset,
            PdreApiTestData.buffer_size,
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.key_value_offset_buffer_size, # result can be reused
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.child_child_def_type_prefix_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.prefix_key_value_key_value,
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.child_child_def_type_prefix_key_value_key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.child_child_def_type_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2,
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.child_child_def_type_key_value_key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.key_value,
        [
            PdreApiTestData.key_value_1,
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.key_value_offset_buffer_size,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.offset,
            PdreApiTestData.buffer_size
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.key_value_offset_buffer_size,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.prefix_key_value_key_value,
        [
            PdreApiTestData.prefix_key_value_key_value
        ],
        PdreApiTestBinaries.cli_testers,
        false,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.key_value_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.key_value_key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.seed,
        [
            PdreApiTestData.seed_1,
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.seed,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.seed_seed,
        [
            PdreApiTestData.seed_1,
            PdreApiTestData.seed_2
        ],
        PdreApiTestBinaries.cli_testers,
        false,
        false # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.seed_msg,
        [
            PdreApiTestData.seed_1,
            PdreApiTestData.value_1
        ],
        PdreApiTestBinaries.cli_testers,
        false,
        false # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.key_value_key_value_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2,
            PdreApiTestData.key_value_3
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.key_value_key_value_key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.value_value_value,
        [
            PdreApiTestData.value_1,
            PdreApiTestData.value_2,
            PdreApiTestData.value_3,
        ],
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.value_value_value,
        true # strip newline
    )

    cd(root_dir)
end
