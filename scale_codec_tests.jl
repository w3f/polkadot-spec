include("./fixtures/test_fixtures.jl")
using Test
using Debugger
@testset "Scale codec byte arrey tests" begin
    script_dir = @__DIR__
    root_dir = script_dir * "/.."
    cd(root_dir)
    for test_byte_array in ScaleCodecFixtures.test_byte_arrays
        test_result_array = []
        for cli_encoder in ScaleCodecFixtures.cli_testers
            cmdparams = [cli_encoder, ScaleCodecFixtures.scale_codec_test_command, ScaleCodecFixtures.scale_codec_encode_subcommand,  " --input ", "\"", String(test_byte_array), "\""]
            cmd = join(cmdparams)
            push!(test_result_array, read(`sh -c $cmd`, String))
            #println(test_result_array[end])

            if cli_encoder != ScaleCodecFixtures.cli_testers[ScaleCodecFixtures.reference_implementation]
                @test test_result_array[end] == test_result_array[ScaleCodecFixtures.reference_implementation]
            end

        end
    end


end

