include("./fixtures/pdre_api_dataset.jl")
include("./fixtures/pdre_api_results.jl")

using Test

function run_dataset(func_list, data_list, cli_list, result_list)
    # Basic parameters for testing CLIs
    sub_cmd = "pdre-api"
    func_arg = "--function"
    input_arg = "--input"

    counter = 1
    for func in func_list
        for data in data_list
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
                    println("Running: ", cmd)
                end

                # Run command
                output = replace(read(`sh -c $cmd`, String), "\n" => "") # remove newline
                if result_list != false
                    #println(output)
                    @test output == result_list[counter]
                else
                    @test true
                end

                if output != "" && print_verbose
                    println("> Result: ", output)
                end
            end
            counter = counter + 1
        end
    end
end

@testset "PDRE API Tests" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    cd(root_dir)

    # ## Test crypto hashing and key functions
    #=
    run_dataset(
        PdreApiTestFunctions.value,
        PdreApiTestData.value,
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.value
    )
    =#

    # ##
    run_dataset(
        PdreApiTestFunctions.child_child_def_type_key_value,
        PdreApiTestData.child_child_def_type_key_value,
        PdreApiTestBinaries.cli_testers,
        PdreApiExpectedResults.child_child_def_type_key_value
    )

    cd(root_dir)
end
