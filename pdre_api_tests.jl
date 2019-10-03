include("./fixtures/pairs_pdre_api.jl")
using Test
@testset "RE API Tests" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    manifest_dir = script_dir * "testers/rust-tester/Cargo.toml"
    println(root_dir)
    cd("testers/rust-tester/")
    for (cli, sub_cmd, func_arg, input_arg) in PdreApiTestFixtures.cli_testers
        # Test crypto functions
        for func in PdreApiTestFixtures.fn_crypto
            for value in PdreApiTestData.value_data
                # create first part of the command
                cmdparams = [cli, sub_cmd, func_arg, func, input_arg]
                cmd = join(cmdparams, " ")

                inputparams = [" \"", value, "\""]
                input = join(inputparams)

                # append input
                cmd = string(cmd, input)
                @test read(`sh -c $cmd`, String) != 1
            end
        end
        # run(`cargo run pdre-api`)
    end
    cd(root_dir)
end