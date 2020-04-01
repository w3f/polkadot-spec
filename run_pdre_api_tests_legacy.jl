#!/usr/bin/env julia
using Test

print_verbose = false
if length(ARGS) >= 1
    if ARGS[1] == "verbose"
        print_verbose = true
    end
end

@time begin
  @time @testset "PDRE Legacy API Tests" begin include("pdre_api_tests_legacy.jl") end
end

exit()
