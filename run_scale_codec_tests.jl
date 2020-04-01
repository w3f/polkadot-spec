#!/usr/bin/env julia
using Test

print_verbose = false
if length(ARGS) >= 1
    if ARGS[1] == "verbose"
        print_verbose = true
    end
end

@time begin
  @time @testset "Scale Codec Tests" begin include("scale_codec_tests.jl") end
end

exit()
