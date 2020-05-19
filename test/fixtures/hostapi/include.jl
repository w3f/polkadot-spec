include("./inputs.jl")
include("./outputs.jl")

using .StringHelper
using .AdapterFixture

tests = AdapterFixture.Builder("Host API", "pdre-api")

HOSTAPI_FIXTURE_DATASETS = [
    [
        PdreApiTestFunctions.value,
        [
            PdreApiTestData.value_1,
        ],
        PdreApiExpectedResults.value .* "\n",
    ],[
        PdreApiTestFunctions.child_child_def_type_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.key_value_1,
        ],
        PdreApiExpectedResults.child_child_def_type_key_value .* "\n",
    ],[
        PdreApiTestFunctions.child_def_type_key_value_offset_buffer_size,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.key_value_1,
            PdreApiTestData.offset,
            PdreApiTestData.buffer_size,
        ],
        PdreApiExpectedResults.key_value_offset_buffer_size .* "\n",
    ],[
        PdreApiTestFunctions.child_child_def_type_prefix_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.prefix_key_value_key_value,
        ],
        PdreApiExpectedResults.child_child_def_type_prefix_key_value_key_value,
    ],[
        PdreApiTestFunctions.child_child_def_type_key_value_key_value,
        [
            PdreApiTestData.child_child,
            PdreApiTestData.child_def_child_type,
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2,
        ],
        PdreApiExpectedResults.child_child_def_type_key_value_key_value .* "\n",
    ],[
        PdreApiTestFunctions.key_value,
        [
            PdreApiTestData.key_value_1,
        ],
        PdreApiExpectedResults.key_value .* "\n",
    ],[
        PdreApiTestFunctions.key_value_offset_buffer_size,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.offset,
            PdreApiTestData.buffer_size,
        ],
        PdreApiExpectedResults.key_value_offset_buffer_size .* "\n",
    ],[
        PdreApiTestFunctions.prefix_key_value_key_value,
        [
            PdreApiTestData.prefix_key_value_key_value,
        ],
        nothing,
    ],[
        PdreApiTestFunctions.key_value_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2,
        ],
        PdreApiExpectedResults.key_value_key_value .* "\n",
    ],[
        PdreApiTestFunctions.seed,
        [
            PdreApiTestData.seed_1,
        ],
        PdreApiExpectedResults.seed .* "\n",
    ],[
        PdreApiTestFunctions.seed_seed,
        [
            PdreApiTestData.seed_1,
            PdreApiTestData.seed_2,
        ],
        nothing,
    ],[
        PdreApiTestFunctions.seed_msg,
        [
            PdreApiTestData.seed_1,
            PdreApiTestData.value_1[1:6],
        ],
        nothing,
    ],[
        PdreApiTestFunctions.key_value_key_value_key_value,
        [
            PdreApiTestData.key_value_1,
            PdreApiTestData.key_value_2,
            PdreApiTestData.key_value_3,
        ],
        PdreApiExpectedResults.key_value_key_value_key_value .* "\n",
    ],[
        PdreApiTestFunctions.value_value_value,
        [
            PdreApiTestData.value_1,
            PdreApiTestData.value_2,
            PdreApiTestData.value_3,
        ],
        PdreApiExpectedResults.value_value_value .* "\n",
    ]
]

for (func, input, output) in HOSTAPI_FIXTURE_DATASETS
    sub!(tests) do t
        arg!(t, "--function")
        foreach!(t, func),
        arg!(t, "--input")
        foreach!(t, inquotes(commajoin(flatzip(input...))))
        commit!(t, output)
    end
end

AdapterFixture.execute(tests)
