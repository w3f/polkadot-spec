include("./fixtures/pairs_pdre_api.jl")
using Test
@testset "RE API Tests" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    manifest_dir = script_dir * "testers/rust-tester/Cargo.toml"
    println(root_dir)
    cd(root_dir)
    for cli in PdreApiTestFixtures.cli_testers
        cd("test/testers/rust-tester/")
        # Test crypto functions
        for func in PdreApiTestFixtures.fn_crypto
            for value in PdreApiTestFixtures.value_data
                
            end
        end
        # run(`cargo run pdre-api`)
        @test true
    end
    cd(root_dir)
end