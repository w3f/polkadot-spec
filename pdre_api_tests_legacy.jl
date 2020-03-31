include("pdre_api_helpers.jl")
include("./fixtures/pdre_api_dataset.jl")
include("./fixtures/pdre_api_results.jl")

using Test

@testset "PDRE API Tests **LEGACY**" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    cd(root_dir)

    run_dataset(
        PdreApiTestFunctionsLegacy.value,
        [
            PdreApiTestData.value_1
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        PdreApiExpectedResultsLegacy.value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.value_no_output,
        [
            PdreApiTestData.value_1
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        false,
        false # strip newline
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_value,
        [
            PdreApiTestData.key_value_1
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        PdreApiExpectedResultsLegacy.key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_value_offset,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.offset
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        PdreApiExpectedResultsLegacy.key_value_offset,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_value_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        PdreApiExpectedResultsLegacy.key_value_key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.value_1
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        PdreApiExpectedResultsLegacy.key_key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.prefix_key_value_key_value,
        [
            PdreApiTestData.prefix_key_value_key_value
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        false,
        false # strip newline
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.key_value_1
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        PdreApiExpectedResultsLegacy.child_child_key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        PdreApiExpectedResultsLegacy.child_child_key_value_key_value,
        true # strip newline
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.prefix_child_child_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.prefix_key_value_key_value
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        false,
        false # strip newline
    )

    # ## Test storage functions with offsets
    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value_offset,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.key_value_1,
            PdreApiTestData.offset
        ],
        PdreApiTestBinariesLegacy.cli_testers,
        PdreApiExpectedResultsLegacy.child_child_key_value_offset,
        true # strip newline
    )

    cd(root_dir)
end
