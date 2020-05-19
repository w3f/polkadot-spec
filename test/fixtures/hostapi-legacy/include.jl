include("./inputs.jl")
include("./outputs.jl")

using .StringHelper
using .AdapterFixture

tests = AdapterFixture.Builder("Host API Legacy", "pdre-api")

"Wrapper around new API to support old convention"
function run_dataset(func, input, output)
    global tests

    sub!(tests) do t
        arg!(t, "--function")
        foreach!(t, func),
        arg!(t, "--input")
        foreach!(t, inquotes(commajoin(flatzip(input...))))
        commit!(t, output)
    end
end

run_dataset(
    PdreApiTestFunctionsLegacy.value,
    [
        PdreApiTestDataLegacy.value_1
    ],
    PdreApiExpectedResultsLegacy.value .* "\n",
)

run_dataset(
    PdreApiTestFunctionsLegacy.value_no_output,
    [
        PdreApiTestDataLegacy.value_1
    ],
    nothing,
)

run_dataset(
    PdreApiTestFunctionsLegacy.key_value,
    [
        PdreApiTestDataLegacy.key_value_1
    ],
    PdreApiExpectedResultsLegacy.key_value .* "\n",
)

run_dataset(
    PdreApiTestFunctionsLegacy.key_value_offset,
    [
        PdreApiTestDataLegacy.key_value_1,
        PdreApiTestDataLegacy.offset
    ],
    PdreApiExpectedResultsLegacy.key_value_offset .* "\n",
)

run_dataset(
    PdreApiTestFunctionsLegacy.key_value_key_value,
    [
        PdreApiTestDataLegacy.key_value_1,
        PdreApiTestDataLegacy.key_value_2
    ],
    PdreApiExpectedResultsLegacy.key_value_key_value .* "\n",
)

run_dataset(
    PdreApiTestFunctionsLegacy.key_key_value,
    [
        PdreApiTestDataLegacy.key_value_1,
        PdreApiTestDataLegacy.value_1
    ],
    PdreApiExpectedResultsLegacy.key_key_value .* "\n",
)

run_dataset(
    PdreApiTestFunctionsLegacy.prefix_key_value_key_value,
    [
        PdreApiTestDataLegacy.prefix_key_value_key_value
    ],
    nothing,
)

run_dataset(
    PdreApiTestFunctionsLegacy.child_child_key_value,
    [
        PdreApiTestDataLegacy.child_child,
        PdreApiTestDataLegacy.key_value_1
    ],
    PdreApiExpectedResultsLegacy.child_child_key_value .* "\n",
)

run_dataset(
    PdreApiTestFunctionsLegacy.child_child_key_value_key_value,
    [
        PdreApiTestDataLegacy.child_child,
        PdreApiTestDataLegacy.key_value_1,
        PdreApiTestDataLegacy.key_value_2
    ],
    PdreApiExpectedResultsLegacy.child_child_key_value_key_value .* "\n",
)

run_dataset(
    PdreApiTestFunctionsLegacy.prefix_child_child_key_value_key_value,
    [
        PdreApiTestDataLegacy.child_child,
        PdreApiTestDataLegacy.prefix_key_value_key_value
    ],
    nothing,
)

# Test storage functions with offsets
run_dataset(
    PdreApiTestFunctionsLegacy.child_child_key_value_offset,
    [
        PdreApiTestDataLegacy.child_child,
        PdreApiTestDataLegacy.key_value_1,
        PdreApiTestDataLegacy.offset
    ],
    PdreApiExpectedResultsLegacy.child_child_key_value_offset .* "\n",
)

AdapterFixture.execute(tests, legacy=true)
