include("./HostApiLegacyFunctions.jl")
include("./HostApiLegacyInputs.jl")
include("./HostApiLegacyOutputs.jl")

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
    HostApiLegacyFunctions.value,
    [
        HostApiLegacyInputs.value_1
    ],
    HostApiLegacyOutputs.value .* "\n",
)

run_dataset(
    HostApiLegacyFunctions.value_no_output,
    [
        HostApiLegacyInputs.value_1
    ],
    nothing,
)

run_dataset(
    HostApiLegacyFunctions.key_value,
    [
        HostApiLegacyInputs.key_value_1
    ],
    HostApiLegacyOutputs.key_value .* "\n",
)

run_dataset(
    HostApiLegacyFunctions.key_value_offset,
    [
        HostApiLegacyInputs.key_value_1,
        HostApiLegacyInputs.offset
    ],
    HostApiLegacyOutputs.key_value_offset .* "\n",
)

run_dataset(
    HostApiLegacyFunctions.key_value_key_value,
    [
        HostApiLegacyInputs.key_value_1,
        HostApiLegacyInputs.key_value_2
    ],
    HostApiLegacyOutputs.key_value_key_value .* "\n",
)

run_dataset(
    HostApiLegacyFunctions.key_key_value,
    [
        HostApiLegacyInputs.key_value_1,
        HostApiLegacyInputs.value_1
    ],
    HostApiLegacyOutputs.key_key_value .* "\n",
)

run_dataset(
    HostApiLegacyFunctions.prefix_key_value_key_value,
    [
        HostApiLegacyInputs.prefix_key_value_key_value
    ],
    nothing,
)

run_dataset(
    HostApiLegacyFunctions.child_child_key_value,
    [
        HostApiLegacyInputs.child_child,
        HostApiLegacyInputs.key_value_1
    ],
    HostApiLegacyOutputs.child_child_key_value .* "\n",
)

run_dataset(
    HostApiLegacyFunctions.child_child_key_value_key_value,
    [
        HostApiLegacyInputs.child_child,
        HostApiLegacyInputs.key_value_1,
        HostApiLegacyInputs.key_value_2
    ],
    HostApiLegacyOutputs.child_child_key_value_key_value .* "\n",
)

run_dataset(
    HostApiLegacyFunctions.prefix_child_child_key_value_key_value,
    [
        HostApiLegacyInputs.child_child,
        HostApiLegacyInputs.prefix_key_value_key_value
    ],
    nothing,
)

# Test storage functions with offsets
run_dataset(
    HostApiLegacyFunctions.child_child_key_value_offset,
    [
        HostApiLegacyInputs.child_child,
        HostApiLegacyInputs.key_value_1,
        HostApiLegacyInputs.offset
    ],
    HostApiLegacyOutputs.child_child_key_value_offset .* "\n",
)

AdapterFixture.execute(tests, legacy=true)
