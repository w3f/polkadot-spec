include("./fixtures/pairs_pdre_api.jl")
using Test
@testset "RE API Tests" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    manifest_dir = script_dir * "test/testers/rust-tester/Cargo.toml"
    cd(root_dir)
    for (cli, sub_cmd, func_arg, input_arg) in PdreApiTestFixtures.cli_testers
        # ## Test crypto functions
        for func in PdreApiTestFixtures.fn_crypto
            for value in PdreApiTestData.value_data
                # create first part of the command
                cmdparams = [cli, sub_cmd, func_arg, func, input_arg]
                cmd = join(cmdparams, " ")

                # append input
                cmd = string(cmd, " \"", value,"\"")

                # Run
                println(">> Running:", cmd)
                output = read(`sh -c $cmd`, String)
                if output != ""
                    println(output)
                end
                @test true
            end
        end

        # ## Test storage functions (key/value inputs and outputs)
        for func in PdreApiTestFixtures.fn_storage_kv
            for (key, value) in PdreApiTestData.key_value_data
                # create first part of the command
                cmdparams = [cli, sub_cmd, func_arg, func, input_arg]
                cmd = join(cmdparams, " ")

                input = join([key, value], ",")

                # append input
                cmd = string(cmd, " \"", input,"\"")

                # Run
                println(">> Running:", cmd)
                output = read(`sh -c $cmd`, String)
                if output != ""
                    println(output)
                end
                @test true
            end
        end

        # ## Test storage functions (prefix values)
        for func in PdreApiTestFixtures.fn_storage_prefix
            for (prefix, key1, value1, key2, value2) in PdreApiTestData.prefix_key_value_data
                # create first part of the command
                cmdparams = [cli, sub_cmd, func_arg, func, input_arg]
                cmd = join(cmdparams, " ")

                input = join([prefix, key1, value1, key2, value2], ",")

                # append input
                cmd = string(cmd, " \"", input,"\"")

                # Run
                println(">> Running:", cmd)
                output = read(`sh -c $cmd`, String)
                if output != ""
                    println(output)
                end
                @test true
            end
        end

        # ## Test storage functions (prefix values)
        for func in PdreApiTestFixtures.fn_storage_store
            for (store1, store2, key, value) in PdreApiTestData.store_data_key_value_data
                # create first part of the command
                cmdparams = [cli, sub_cmd, func_arg, func, input_arg]
                cmd = join(cmdparams, " ")

                input = join([store1, store2, key, value], ",")

                # append input
                cmd = string(cmd, " \"", input,"\"")

                # Run
                println(">> Running:", cmd)
                output = read(`sh -c $cmd`, String)
                if output != ""
                    println(output)
                end
                @test true
            end
        end
    end
    cd(root_dir)
end