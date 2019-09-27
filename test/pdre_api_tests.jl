@testset "Runtime Environment Tests" begin include("pdre_api_tests.jl") end

cmdparams = ["cargo", "run", "pdre-api"]

@test run(`cargo run pdre-api`)