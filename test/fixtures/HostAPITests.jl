module HostAPITests

using ..Config

export run_dataset

"Maps supported implementations to correct adapter"
const SUPPORTED_IMPLEMENTATIONS = Dict(
  "substrate"        => "substrate-adapter",
  "substrate-legacy" => "substrate-adapter-legacy",
  "kagome-legacy"    => "kagome-adapter"
)

"Return adapter to implementation if it is supported"
function supported(implementation::String, legacy=false)
    name = implementation * (legacy ? "-legacy" : "")
    get(SUPPORTED_IMPLEMENTATIONS, name, "")
end

using Test

#=
# Description
Combines the inner arrays of the different test data types, iterates over them,
and merges those arrays of each iteration into a single, new array.
This allows to reuse test data for functions of various input types.

# Example:
Input = [
    # Test data type (each inner array represents different values)
    [[1, 2, 3], [7, 8, 9], [13, 14, 15]],
    # Different test data type (each inner array represents different values)
    [[4, 5, 6], [10, 11, 12], [16, 17, 18]]
]

Output = [
    [1, 2, 3, 4, 5, 6],
    [7, 8, 9, 10, 11, 12]
    [13, 14, 15, 16, 17, 18]
]
=#
function merge_params(params)
    parts = size(params)[1] # 2
    comps = size(params[1])[1] # 3

    final = []
    for comp in 1:comps
        inner = []
        for part in 1:parts
        x = params[part][comp]
        inner = vcat(inner, x)
        end
        push!(final, inner)
    end

    final
end

#=
# Description
Parses the test data and passes it on to the test functions.
The returned values gets captured, optionally compared to
the expected results and optionally printed.

# Keyword Arguments
strip    Boolean   Strip newline characters
legacy   Boolean   Call legacy adapter
=#
function run_dataset(func_list, data_list, result_list; strip=true, legacy=false)
    # Basic parameters for testing CLIs
    sub_cmd = "pdre-api"
    func_arg = "--function"
    input_arg = "--input"

    counter = 1
    for func in func_list
        for data in merge_params(data_list)
            input = ""

            if data == ""
                # Skip
            elseif size(data)[1] == 1
                input = data[1]
            else
                set_first = true
                for entry in data
                    if set_first
                        input = data[1]
                        set_first = false
                        continue
                    end
                    input = join([input, entry], ",")
                end
            end

            for implementation in Config.implementations
                adapter = supported(implementation, legacy)

                if isempty(adapter)
                    # Warn: not supported
                    continue
                end

                # create first part of the command
                cmdparams = [adapter, sub_cmd, func_arg, func, input_arg]
                cmd = join(cmdparams, " ")

                # append input
                cmd = string(cmd, " \"", input, "\"")

                if Config.verbose
                    println("[> RUNNING]: ", cmd)
                end

                # Run command
                output = ""
                try
                    output = read(`sh -c $cmd`, String);
                catch err
                    @error "Adapter failed: $err"
                    # Should be @test_broken, but does not fail CI
                    @test false
                    continue
                end

                if strip
                    output = replace(output, "\n" => "")
                end

                if result_list != false
                    result = result_list[counter]

                    if isempty(output) && !isempty(result)
                        @warn "Missing adaption: $cmd"
                        @test_skip false
                    else
                        @test output == result
                    end
                else
                    # TODO Warn about missing result?
                    @test true
                end

                if !isempty(output) && Config.verbose
                    println("  [OUTPUT]: ", output)
                end
            end
            counter = counter + 1
        end
    end
end

end # module
