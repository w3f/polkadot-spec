include("./test_fixtures.jl")
using Test
@testset "Scale codec byte arrey tests" begin
    for test_byte_array in ScaleCodecFixtures.test_byte_arrays
        test_result_array = []
        for cli_encoder in ScaleCodecFixtures.cli_scale_encoders
            println(String(test_byte_array))
            cmdparams = [cli_encoder, " encode ", " --input ", "\"", String(test_byte_array), "\""]
            cmd = join(cmdparams)
            push!(test_result_array, run(`sh -c $cmd`))
            #println(test_result_array[end])
            @test test_result_array[end] == test_result_array[1]
        end
    end
end

