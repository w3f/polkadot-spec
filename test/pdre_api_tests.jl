include("pdre_api_helpers.jl")
include("./fixtures/pdre_api_dataset.jl")
include("./fixtures/pdre_api_results.jl")

using Test

@testset "PDRE API Tests" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    cd(root_dir)

    # ## Test crypto hashing and key functions
    run_dataset(
        PdreApiTestFunctions.value,
        [
            PdreApiTestData.value,
        ],
        PdreApiTestBinaries.cli_testers,
        #PdreApiExpectedResults.value,
        false,
        true # strip newline
    )

    # ##
    run_dataset(
        PdreApiTestFunctions.child_child_def_type_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.key_value_1,
        ],
        PdreApiTestBinaries.cli_testers,
        #PdreApiExpectedResults.child_child_def_type_key_value,
        false,
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
        #PdreApiExpectedResults.child_child_def_type_prefix_key_value_key_value,
        false,
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
        #PdreApiExpectedResults.child_child_def_type_key_value_key_value,
        false,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.key_value,
        [
            PdreApiTestData.key_value_1,
        ],
        PdreApiTestBinaries.cli_testers,
        #PdreApiExpectedResults.child_child_def_type_key_value_key_value,
        false,
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
        #PdreApiExpectedResults.child_child_def_type_key_value_key_value,
        false,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.prefix_key_value_key_value,
        [
            PdreApiTestData.prefix_key_value_key_value
        ],
        PdreApiTestBinaries.cli_testers,
        #PdreApiExpectedResults.child_child_def_type_key_value_key_value,
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
        #PdreApiExpectedResults.child_child_def_type_key_value_key_value,
        false,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.seed,
        [
            PdreApiTestData.seed_1,
        ],
        PdreApiTestBinaries.cli_testers,
        #PdreApiExpectedResults.child_child_def_type_key_value_key_value,
        false,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.seed_seed,
        [
            PdreApiTestData.seed_1,
            PdreApiTestData.seed_2
        ],
        PdreApiTestBinaries.cli_testers,
        #PdreApiExpectedResults.child_child_def_type_key_value_key_value,
        false,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctions.seed_msg,
        [
            PdreApiTestData.seed_1,
            PdreApiTestData.value
        ],
        PdreApiTestBinaries.cli_testers,
        #PdreApiExpectedResults.child_child_def_type_key_value_key_value,
        false,
        true # strip newline
    )

    cd(root_dir)
end
