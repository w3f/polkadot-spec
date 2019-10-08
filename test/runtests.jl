using Test

@time begin
  @time @testset "Scale Codec Tests" begin include("scale_codec_tests.jl") end
  @time @testset "State Trie Tests" begin include("state_trie_tests.jl") end
  @time @testset "RE API Tests" begin include("pdre_api_tests.jl") end
end

exit()
