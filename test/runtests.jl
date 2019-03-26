using Test

@time begin
  @time @testset "Scale Codec Tests" begin include("scale_codec_tests.jl") end
end
