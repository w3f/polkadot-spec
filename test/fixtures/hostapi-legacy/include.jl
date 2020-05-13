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
            PdreApiTestDataLegacy.value_1
        ],
        PdreApiExpectedResultsLegacy.value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.value_no_output,
        [
            PdreApiTestDataLegacy.value_1
        ],
        false,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_value,
        [
            PdreApiTestDataLegacy.key_value_1
        ],
        PdreApiExpectedResultsLegacy.key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_value_offset,
        [
            PdreApiTestDataLegacy.key_value_1,
            PdreApiTestDataLegacy.offset
        ],
        PdreApiExpectedResultsLegacy.key_value_offset,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_value_key_value,
        [
            PdreApiTestDataLegacy.key_value_1,
            PdreApiTestDataLegacy.key_value_2
        ],
        PdreApiExpectedResultsLegacy.key_value_key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.key_key_value,
        [
            PdreApiTestDataLegacy.key_value_1,
            PdreApiTestDataLegacy.value_1
        ],
        PdreApiExpectedResultsLegacy.key_key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.prefix_key_value_key_value,
        [
            PdreApiTestDataLegacy.prefix_key_value_key_value
        ],
        false,
        strip=false,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value,
        [
            PdreApiTestDataLegacy.child_child,
            PdreApiTestDataLegacy.key_value_1
        ],
        PdreApiExpectedResultsLegacy.child_child_key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value_key_value,
        [
            PdreApiTestDataLegacy.child_child,
            PdreApiTestDataLegacy.key_value_1,
            PdreApiTestDataLegacy.key_value_2
        ],
        PdreApiExpectedResultsLegacy.child_child_key_value_key_value,
        legacy=true
    )

    run_dataset(
        PdreApiTestFunctionsLegacy.prefix_child_child_key_value_key_value,
        [
            PdreApiTestDataLegacy.child_child,
            PdreApiTestDataLegacy.prefix_key_value_key_value
        ],
        false, 
        strip=false,
        legacy=true
    )

    # Test storage functions with offsets
    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value_offset,
        [
            PdreApiTestDataLegacy.child_child,
            PdreApiTestDataLegacy.key_value_1,
            PdreApiTestDataLegacy.offset
        ],
        PdreApiExpectedResultsLegacy.child_child_key_value_offset,
        legacy=true
    )

#    cd(root_dir)
end
