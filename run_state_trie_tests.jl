#!/usr/bin/env julia
using Test

print_verbose = false
if length(ARGS) >= 1
    if ARGS[1] == "verbose"
        print_verbose = true
    end
end

@time begin
  @time @testset "State Trie Tests" begin include("state_trie_tests.jl") end
end

exit()
