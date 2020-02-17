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
        PdreApiExpectedResults.value,
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
        PdreApiExpectedResults.child_child_def_type_key_value,
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

    cd(root_dir)
end
