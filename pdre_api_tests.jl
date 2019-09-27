@testset "Runtime Environment Tests" begin
    cd("test/testers/rust-tester/")
    @test run(`cargo run pdre-api`)
    true
end