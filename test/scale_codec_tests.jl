include("./test_fixtures.jl")
using Test
@testset "Scale codec byte arrey tests" begin
    for test_byte_array in ScaleCodecFixtures.test_byte_arrays
        test_result_array = []
        for cli_encoder in ScaleCodecFixtures.cli_scale_encoders
            cmdparams = [cli_encoder, " encode ", " --input ", "\"", String(test_byte_array), "\""]
            cmd = join(cmdparams)
            push!(test_result_array, read(`sh -c $cmd`, String))
            println(test_result_array[end])

            if cli_encoder != ScaleCodecFixtures.cli_scale_encoders[ScaleCodecFixtures.reference_implementation]
                @test test_result_array[end] == test_result_array[ScaleCodecFixtures.reference_implementation]
            end
        end
    end
end

