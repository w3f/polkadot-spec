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
=#
function run_dataset(func_list, data_list, cli_list, result_list, strip_newline)
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

            for cli in cli_list
                # create first part of the command
                cmdparams = [cli, sub_cmd, func_arg, func, input_arg]
                cmd = join(cmdparams, " ")

                # append input
                cmd = string(cmd, " \"", input, "\"")

                if print_verbose
                    println("[> RUNNING]: ", cmd)
                end

                # Run command
                if strip_newline
                    output = replace(read(`sh -c $cmd`, String), "\n" => "") # remove newline
                else
                    output = read(`sh -c $cmd`, String)
                end

                #println(output)

                if result_list != false
                    @test output == result_list[counter]
                else
                    @test true
                end

                if output != "" && print_verbose
                    println("  [OUTPUT]: ", output)
                end
            end
            counter = counter + 1
        end
    end
end
