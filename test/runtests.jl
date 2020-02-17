using Test

print_verbose = false
if length(ARGS) >= 1
    if ARGS[1] == "verbose"
        print_verbose = true
    end
end

function merge_params(params)
    #=
    Input = [
      [[1, 2, 3], [7, 8, 9]],
      [[4, 5, 6], [10, 11, 12]]
    ]

    Output = [
      [1, 2, 3, 4, 5, 6],
      [7, 8, 9, 10, 11, 12]
    ]
    =#
    parts = size(params)[1] # 2
    comps = size(params[1])[1] # 3

    final = []
    for comp in 1:comps
        inner = []
        for part in 1:parts
          x = params[part][comp]
          inner = vcat(inner, x)
        end
        push!(final, inner)
    end

    final
end

#=
Input = [
  [[1, 2, 3], [7, 8, 9]],
  [[4, 5, 6], [10, 11, 12]]
]
println(merge_params(Input))
=#

@time begin
  # @time @testset "Scale Codec Tests" begin include("scale_codec_tests.jl") end
  # @time @testset "State Trie Tests" begin include("state_trie_tests.jl") end
  # @time @testset "PDRE API Tests" begin include("pdre_api_tests_legacy.jl") end
  @time @testset "PDRE API Tests" begin include("pdre_api_tests.jl") end
end

exit()
