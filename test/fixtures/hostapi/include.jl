include("./inputs.jl")
include("./outputs.jl")

using .HostAPITests

using Test


@testset "Host API" begin
#    script_dir = @__DIR__
#    root_dir = script_dir * "/.."
#    cd(root_dir)

    run_dataset(
        PdreApiTestFunctions.value,
        [
            PdreApiTestData.value_1,
        ],
        PdreApiExpectedResults.value,
    )

    run_dataset(
        PdreApiTestFunctions.child_child_def_type_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.key_value_1,
        ],
        PdreApiExpectedResults.child_child_def_type_key_value,
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
        PdreApiExpectedResults.key_value_offset_buffer_size, # result can be reused
    )

    run_dataset(
        PdreApiTestFunctions.child_child_def_type_prefix_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.prefix_key_value_key_value,
        ],
        PdreApiExpectedResults.child_child_def_type_prefix_key_value_key_value,
    )

    run_dataset(
        PdreApiTestFunctions.child_child_def_type_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2,
        ],
        PdreApiExpectedResults.child_child_def_type_key_value_key_value,
    )

    run_dataset(
        PdreApiTestFunctions.key_value,
        [
            PdreApiTestData.key_value_1,
        ],
        PdreApiExpectedResults.key_value,
    )

    run_dataset(
        PdreApiTestFunctions.key_value_offset_buffer_size,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.offset,
            PdreApiTestData.buffer_size
        ],
        PdreApiExpectedResults.key_value_offset_buffer_size,
    )

    run_dataset(
        PdreApiTestFunctions.prefix_key_value_key_value,
        [
            PdreApiTestData.prefix_key_value_key_value
        ],
        false,
    )

    run_dataset(
        PdreApiTestFunctions.key_value_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2
        ],
        PdreApiExpectedResults.key_value_key_value,
    )

    run_dataset(
        PdreApiTestFunctions.seed,
        [
            PdreApiTestData.seed_1,
        ],
        PdreApiExpectedResults.seed,
    )

    run_dataset(
        PdreApiTestFunctions.seed_seed,
        [
            PdreApiTestData.seed_1,
            PdreApiTestData.seed_2
        ],
        false,
        strip=false
    )

    run_dataset(
        PdreApiTestFunctions.seed_msg,
        [
            PdreApiTestData.seed_1,
            PdreApiTestData.value_1
        ],
        false,
        strip=false
    )

    run_dataset(
        PdreApiTestFunctions.key_value_key_value_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2,
            PdreApiTestData.key_value_3
        ],
        PdreApiExpectedResults.key_value_key_value_key_value,
    )

    run_dataset(
        PdreApiTestFunctions.value_value_value,
        [
            PdreApiTestData.value_1,
            PdreApiTestData.value_2,
            PdreApiTestData.value_3,
        ],
        PdreApiExpectedResults.value_value_value,
    )

#    cd(root_dir)
end
