#!/usr/bin/env julia
using Test

print_verbose = false
if length(ARGS) >= 1
    if ARGS[1] == "verbose"
        print_verbose = true
    end
end

@time begin
  @time @testset "PDRE API Tests" begin include("pdre_api_tests.jl") end
end

exit()
