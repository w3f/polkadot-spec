include("./inputs.jl")
include("./outputs.jl")

using .HostAPITests

using Test


@testset "Host API Legacy" begin
#    script_dir = @__DIR__
#    root_dir = script_dir * "/.."
#    cd(root_dir)

    run_dataset(
        PdreApiTestFunctionsLegacy.value,
        [
            PdreApiTestData.value_1
        ],
        PdreApiExpectedResultsLegacy.value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.value_no_output,
        [
            PdreApiTestData.value_1
        ],
        false,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_value,
        [
            PdreApiTestData.key_value_1
        ],
        PdreApiExpectedResultsLegacy.key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_value_offset,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.offset
        ],
        PdreApiExpectedResultsLegacy.key_value_offset,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_value_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2
        ],
        PdreApiExpectedResultsLegacy.key_value_key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.value_1
        ],
        PdreApiExpectedResultsLegacy.key_key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.prefix_key_value_key_value,
        [
            PdreApiTestData.prefix_key_value_key_value
        ],
        false,
        strip=false,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.key_value_1
        ],
        PdreApiExpectedResultsLegacy.child_child_key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2
        ],
        PdreApiExpectedResultsLegacy.child_child_key_value_key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.prefix_child_child_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.prefix_key_value_key_value
        ],
        false, 
        strip=false,
        legacy=true
    )

    # Test storage functions with offsets
    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value_offset,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.key_value_1,
            PdreApiTestData.offset
        ],
        PdreApiExpectedResultsLegacy.child_child_key_value_offset,
        legacy=true
    )

#    cd(root_dir)
end
