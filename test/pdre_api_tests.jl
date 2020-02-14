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

    # Basic parameters for testing CLIs
    sub_cmd = "pdre-api"
    func_arg = "--function"
    input_arg = "--input"

    # ## Test crypto hashing and key functions
    # function run_dataset(func_list, data_list, cli_list, result_list)
    run_dataset(
        PdreApiTestFunctionsLegacy.value,
        PdreApiTestData.value,
        PdreApiTestFixtures.cli_testers,
        PdreApiExpectedResults.value
    )

    # ## Test crypto key functions
    run_dataset(
        PdreApiTestFunctionsLegacy.value_no_output,
        PdreApiTestData.value,
        PdreApiTestFixtures.cli_testers,
        false
    )

    # ## Test key/value storage functions
    run_dataset(
        PdreApiTestFunctionsLegacy.key_value,
        PdreApiTestData.key_value,
        PdreApiTestFixtures.cli_testers,
        PdreApiExpectedResults.key_value
    )

    # ## Test key/value storage functions with offsets
    run_dataset(
        PdreApiTestFunctionsLegacy.key_value_offset,
        PdreApiTestData.key_value_offset,
        PdreApiTestFixtures.cli_testers,
        PdreApiExpectedResults.key_value_offset
    )

    # ## Test multipl key/value storage functions
    run_dataset(
        PdreApiTestFunctionsLegacy.key_value_key_value,
        PdreApiTestData.key_value_key_value,
        PdreApiTestFixtures.cli_testers,
        PdreApiExpectedResults.key_value_key_value
    )

    # ## Test compare/set storage functions
    run_dataset(
        PdreApiTestFunctionsLegacy.key_key_value,
        PdreApiTestData.key_key_value,
        PdreApiTestFixtures.cli_testers,
        PdreApiExpectedResults.key_key_value
    )

    # ## Test storage functions (prefix values)
    run_dataset(
        PdreApiTestFunctionsLegacy.prefix_key_value_key_value,
        PdreApiTestData.prefix_key_value_key_value,
        PdreApiTestFixtures.cli_testers,
        false
    )

    # ## Test storage functions (child storage)
    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value,
        PdreApiTestData.child_child_key_value,
        PdreApiTestFixtures.cli_testers,
        PdreApiExpectedResults.child_child_key_value
    )

    # ## Test child storage function with offsets
    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value_key_value,
        PdreApiTestData.child_child_key_value_key_value,
        PdreApiTestFixtures.cli_testers,
        PdreApiExpectedResults.child_child_key_value_key_value
    )

    # ## Test storage functions (prefix values on child storage)
    run_dataset(
        PdreApiTestFunctionsLegacy.prefix_child_child_key_value_key_value,
        PdreApiTestData.prefix_child_child_key_value_key_value,
        PdreApiTestFixtures.cli_testers,
        false
    )

    # ## Test storage functions with offsets
    run_dataset(
        PdreApiTestFunctionsLegacy.child_child_key_value_offset,
        PdreApiTestData.child_child_key_value_offset,
        PdreApiTestFixtures.cli_testers,
        PdreApiExpectedResults.child_child_key_value_offset
    )

    # ## Test network functions
    for func in PdreApiTestFunctionsLegacy.fn_network
        for cli in PdreApiTestFixtures.cli_testers
            # ...
        end
    end

    cd(root_dir)
end
