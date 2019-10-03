include("./fixtures/pairs_pdre_api.jl")
using Test
@testset "RE API Tests" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    manifest_dir = script_dir * "testers/rust-tester/Cargo.toml"
    println(root_dir)
    cd("testers/rust-tester/")
    for cli in PdreApiTestFixtures.cli_testers
        # Test crypto functions
        for func in PdreApiTestFixtures.fn_crypto
            for value in PdreApiTestData.value_data
                cmdparams = ["cargo run pdre-api --function ", func, " --input \"", value, "\""]
                cmd = join(cmdparams)
                @test read(`sh -c $cmd`, String) != 1
            end
        end
        # run(`cargo run pdre-api`)
    end
    cd(root_dir)
end