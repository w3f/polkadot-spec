using .Config
using Test

"Compute trie root hash from yaml state file"
function root_tester_host(implementation)

    state_file = if implementation == "substrate"
        "$(@__DIR__)/../../testers/host/genesis.yaml"
    else
        "$(@__DIR__)/../../testers/host-legacy/genesis-legacy.yaml"
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

    keystore = "$(@__DIR__)/kagome.keystore.json"
    config   = "$(@__DIR__)/gossamer.config.toml"

    # Prepare command and environment based on command
    cmd = ``
    if implementation == "substrate"
        ENV["RUST_LOG"] = "runtime=debug"
        cmd = `polkadot --alice --chain $genesis -d $tempdir`
    elseif implementation == "kagome"
        cmd = `kagome_full --genesis $genesis_kagome --keystore $keystore --leveldb $tempdir`
    elseif implementation == "gossamer"
        cmd = `gossamer --key=alice --config $config --basepath $tempdir --log debug`
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

    # Reset path
    cd(current_path)

    result = read(stream, String)

    # Make sure implementation stopped because of signal
    @test Base.process_signaled(proc)

    if !Base.process_signaled(proc)
        @warn "Implementation '$implementation' aborted unexpectedly:\n$result"
    end

    if Config.verbose
        println("[OUTPUT]: ", result)
    end

    return result
end


@testset "Genesis" begin
    for implementation in Config.implementations
        # Compute expected storage root
        storage_root = root_tester_host(implementation)

        # Run implementation long enough to load genesis
        result = run_tester_host(implementation, 5)


        # Extract all hashes returned from log
        hashes = map(m -> m[1], eachmatch(r"##([^#\n]+)##", result)) 

        # Check state root hash
        @test storage_root == hashes[1]


        # Extract all calls made from log
        calls = map(m -> m[1], eachmatch(r"@@([^@\n]+)@@", result))

        # Check that grandpa config is requested
        @test "grandpa_authorities()" in calls

        # Check that babe configuration is requested
        @test "configuration()" in calls
    end
end
