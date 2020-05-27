"Compute trie root hash from yaml state file"
function root_tester_host(legacy=false)

    state_file = if legacy
        "$(@__DIR__)/../../testers/host-legacy/genesis-legacy.yaml"
    else
        "$(@__DIR__)/../../testers/host/genesis.yaml"
    end

    cmd = `substrate-adapter state-trie trie-root --keys-in-hex --values-in-hex --state-file $state_file`

    return read(cmd, String)[13:end-1]
end

"Run implementation with host-tester genesis for certain time"
function run_tester_host(implementation, seconds)
    # Locations of needed files and folders
    tempdir = mktempdir()

    genesis        = "$(@__DIR__)/../../testers/host/genesis.json"
    genesis_legacy = "$(@__DIR__)/../../testers/host-legacy/genesis-legacy.json"
    genesis_kagome = "$(@__DIR__)/../../testers/host-legacy/genesis-legacy.kagome.json"

    keystore = string(@__DIR__, "/kagome.keystore.json")
    config   = string(@__DIR__, "/gossamer.config.toml")

    # Prepare command and environment based on command
    cmd = ``
    if implementation == "substrate"
        ENV["RUST_LOG"] = "runtime=debug"
        cmd = `polkadot --alice --chain $genesis -d $tempdir`
    elseif implementation == "kagome"
        cmd = `kagome_full --genesis $genesis_kagome --keystore $keystore --leveldb $tempdir`
    elseif implementation == "gossamer"
        cmd = `gossamer --key=alice --config $config --datadir $tempdir`
    else
        error("Unknown implementation: ", implementation)
    end

    # Run from test subfolder (required by gossamer to find genesis)
    current_path = pwd()
    cd("$(@__DIR__)/../..")

    if Config.verbose
      println("[> RUNNING] ", cmd)
    end

    # Run for specified time
    stream = Pipe()
    proc = run(pipeline(cmd, stdout=stream, stderr=stream), wait=false)
    sleep(seconds)
    kill(proc)
    close(stream.in)

    # TODO Check if killed by signal or error

    # Reset path
    cd(current_path)
 
    result = read(stream, String)

    if Config.verbose
      println("[OUTPUT]: ", result)
    end

    return result
end


using .Config
using Test


@testset "Genesis" begin
    for implementation in Config.implementations

        result = run_tester_host(implementation, 10)

        calls = map(m -> m[1], eachmatch(r"@@([^@\n]+)@@", result))

        if length(calls) == 0
          @error "Failed to run implementation '$implementation':\n$result"
        end

        @test length(calls) > 0
    end
end
