include("./fixtures/pdre_api_dataset.jl")
include("./fixtures/pdre_api_results.jl")

using Test

function run_dataset_adj(func_list, data_list, cli_list, result_list)
    # Basic parameters for testing CLIs
    sub_cmd = "pdre-api"
    func_arg = "--function"
    input_arg = "--input"

    counter = 1
    for func in func_list
        for data in data_list
            input = ""
            if size(data)[1] == 1
                input = data[1]
            else
                for entry in data
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

function run_dataset(func, cli, input, print_verbose, results, counter)
    # Basic parameters for testing CLIs
    sub_cmd = "pdre-api"
    func_arg = "--function"
    input_arg = "--input"

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
    if results != false
        @test output == results[counter]
    else
        @test true
    end

    if output != "" && print_verbose
        println("> Result: ", output)
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

    # ## Test crypto hashing functions
    counter = 1
    # function run_dataset_adj(func_list, data_list, cli_list, result_list)
    run_dataset_adj(
        PdreApiTestFixtures.fn_crypto_hashes,
        PdreApiTestData.value_data,
        PdreApiTestFixtures.cli_testers,
        PdreApiExpectedResults.res_crypto_hashes
    )

    # ## Test crypto key functions
    counter = 1
    for func in PdreApiTestFixtures.fn_crypto_keys
        for value in PdreApiTestData.value_data
            for cli in PdreApiTestFixtures.cli_testers
                run_dataset(
                    func,
                    cli,
                    value,
                    print_verbose,
                    false,
                    0
                )
            end
            counter = counter + 1
        end
    end

    # ## Test key/value storage functions
    counter = 1
    for func in PdreApiTestFixtures.fn_general_kv
        for (key, value, _) in PdreApiTestData.key_value_data
            for cli in PdreApiTestFixtures.cli_testers
                input = join([key, value], ",")
                run_dataset(
                    func,
                    cli,
                    input,
                    print_verbose,
                    PdreApiExpectedResults.res_storage_kv,
                    counter
                )
            end
            counter = counter + 1
        end
    end

    # ## Test key/value storage functions with offsets
    counter = 1
    for func in PdreApiTestFixtures.fn_storage_kv_offset
        for (key, value, offset) in PdreApiTestData.key_value_data
            for cli in PdreApiTestFixtures.cli_testers
                input = join([key, value, offset], ",")
                run_dataset(
                    func,
                    cli,
                    input,
                    print_verbose,
                    PdreApiExpectedResults.res_storage_kv_offset,
                    counter
                )
            end
            counter = counter + 1
        end
    end

    # ## Test multipl key/value storage functions
    counter = 1
    for func in PdreApiTestFixtures.fn_storage_2x_kv
        for (_, key1, value1, key2, value2) in PdreApiTestData.prefix_key_value_data
            for cli in PdreApiTestFixtures.cli_testers
                input = join([key1, value1, key2, value2], ",")
                run_dataset(
                    func,
                    cli,
                    input,
                    print_verbose,
                    PdreApiExpectedResults.res_storage_2x_kv,
                    counter
                )
            end
            counter = counter + 1
        end
    end

    # ## Test compare/set storage functions
    counter = 1
    for func in PdreApiTestFixtures.fn_storage_compare_set
        for (_, key1, value1, _, value2) in PdreApiTestData.prefix_key_value_data
            for cli in PdreApiTestFixtures.cli_testers
                input = join([key1, value1, value2], ",")
                run_dataset(
                    func,
                    cli,
                    input,
                    print_verbose,
                    PdreApiExpectedResults.res_storage_compare_set,
                    counter
                )
            end
            counter = counter + 1
        end
    end

    # ## Test storage functions (prefix values)
    for func in PdreApiTestFixtures.fn_storage_prefix
        for (prefix, key1, value1, key2, value2) in PdreApiTestData.prefix_key_value_data
            for cli in PdreApiTestFixtures.cli_testers
                input = join([prefix, key1, value1, key2, value2], ",")
                run_dataset(
                    func,
                    cli,
                    input,
                    print_verbose,
                    false,
                    0
                )
            end
        end
    end

    # ## Test storage functions (child storage)
    counter = 1
    for func in PdreApiTestFixtures.fn_storage_child_kv
        for (child1, child2, key, value, _) in PdreApiTestData.child_key_value_data
            for cli in PdreApiTestFixtures.cli_testers
                input = join([child1, child2, key, value], ",")
                run_dataset(
                    func,
                    cli,
                    input,
                    print_verbose,
                    PdreApiExpectedResults.res_storage_child,
                    counter
                )
            end
            counter = counter + 1
        end
    end

    # ## Test child storage function with offsets
    counter = 1
    for func in PdreApiTestFixtures.fn_storage_child_2x_kv
        for (_, child1, child2, key1, value1, key2, value2) in PdreApiTestData.prefix_child_key_value_data
            for cli in PdreApiTestFixtures.cli_testers
                input = join([child1, child2, key1, value1, key2, value2], ",")
                run_dataset(
                    func,
                    cli,
                    input,
                    print_verbose,
                    PdreApiExpectedResults.res_child_storage_root,
                    counter
                )
            end
            counter = counter + 1
        end
    end

    # ## Test storage functions (prefix values on child storage)
    for func in PdreApiTestFixtures.fn_storage_prefix_child
        for (prefix, child1, child2, key1, value1, key2, value2) in PdreApiTestData.prefix_child_key_value_data
            for cli in PdreApiTestFixtures.cli_testers
                input = join([prefix, child1, child2, key1, value1, key2, value2], ",")
                run_dataset(
                    func,
                    cli,
                    input,
                    print_verbose,
                    false,
                    0
                )
            end
        end
    end

    # ## Test storage functions with offsets
    counter = 1
    for func in PdreApiTestFixtures.fn_storage_child_offset
        for (child1, child2, key1, value1, offset) in PdreApiTestData.child_key_value_data
            for cli in PdreApiTestFixtures.cli_testers
                input = join([child1, child2, key1, value1, offset], ",")
                run_dataset(
                    func,
                    cli,
                    input,
                    print_verbose,
                    PdreApiExpectedResults.res_storage_child_offset,
                    counter
                )
            end
            counter = counter + 1
        end
    end

    # ## Test network functions
    for func in PdreApiTestFixtures.fn_network
        for cli in PdreApiTestFixtures.cli_testers
            # ...
        end
    end

    cd(root_dir)
end
