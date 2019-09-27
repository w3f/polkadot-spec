@testset "Runtime Environment Tests" begin
    cd("test/testers/rust-tester/")
    run(`cargo run pdre-api`)
    @test true
end