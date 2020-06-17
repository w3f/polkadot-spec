module ImplementationFixture

using ..Config
using Test

"Represensts a fixture based on a tester"
struct Tester
    "Name of the testsuite"
    name::String

    "Name of the tester to use"
    tester::String
end


"Compute trie root hash from yaml state file"
function compute_root(self::Tester, implementation::String)

    state_file = if implementation == "substrate"
        "$(@__DIR__)/../testers/$(self.tester)/genesis.yaml"
    else
        "$(@__DIR__)/../testers/$(self.tester)-legacy/genesis-legacy.yaml"
    end

    # Make sure state file is available
    if !isfile(state_file)
        @error "Failed to locate state file: $state_file"
    end

    cmd = `substrate-adapter state-trie trie-root --keys-in-hex --values-in-hex --state-file $state_file`

    if Config.verbose
        println("┌ [COMMAND] ", cmd)
    end

    result = read(cmd, String)

    if Config.verbose
        println("└ [OUTPUTS] ", result)
    end

    return result[13:end-1]
end


"Run implementation with tester genesis for certain time in seconds"
function run_tester(self::Tester, implementation::String, duration::Number)
    # Locations of needed files and folders
    tempdir = mktempdir() * "/"

    # Determine correct genesis based on implementation
    genesis = if implementation == "kagome"
        "$(@__DIR__)/../testers/$(self.tester)-legacy/genesis-legacy.kagome.json"
    elseif implementation == "gossamer"
        "$(@__DIR__)/../testers/$(self.tester)-legacy/genesis-legacy.json"
    else # default
        "$(@__DIR__)/../testers/$(self.tester)/genesis.json"
    end
    
    # Make sure genesis is available
    if !isfile(genesis)
        @error "Failed to locate genesis: $genesis"
    end

    # Without docker the tempdir is used for local data
    datadir = tempdir

    # Helper files needed for some implementations
    keystore = "$(@__DIR__)/../testers/$(self.tester)-legacy/kagome.keystore.json"
    config   = if Config.docker
        "$(@__DIR__)/../testers/$(self.tester)-legacy/gossamer.docker.config.toml"
    else
        "$(@__DIR__)/../testers/$(self.tester)-legacy/gossamer.config.toml"
    end

    if Config.docker
        # Provide genesis and other files to container
        cp(genesis, joinpath(tempdir, basename(genesis)))
        genesis = "/config/" * basename(genesis)

        cp(keystore, joinpath(tempdir, basename(keystore)))
        keystore = "/config/" * basename(keystore)

        cp(config, joinpath(tempdir, basename(config)))
        config = "/config/" * basename(config)

        # Use fixed dir inside container
        datadir = "/polkadot"
    end

    # Prepare command and environment based on command
    cmd  = ``
    args = ``
    if implementation == "substrate"
        exec = `polkadot`
        args = `--alice --chain $genesis -d $datadir`
        ENV["RUST_LOG"] = "runtime=debug"
    elseif implementation == "kagome"
        exec = `kagome_full`
        args = `--genesis $genesis --keystore $keystore --leveldb $datadir`
    elseif implementation == "gossamer"
        exec = `gossamer`
        args = `--key=alice --config $config --basepath $datadir --log debug`
    else
        error("Unknown implementation: ", implementation)
    end

    # Prepare container and overwrite command with docker invocation
    if Config.docker
        image = Config.get_container(implementation)

        if isempty(image)
            @error "Implementation '$implementation' has no default docker image."
        end

        println("Caching/updating docker images of '$implementation':")
        run(`docker pull $image`)

        exec = `docker run -e RUST_LOG=runtime=debug -v $tempdir:/config -v $datadir --rm -i $image`
    end

    cmd = `$exec $args`

    if Config.verbose
        println("┌ [COMMAND] ", cmd)
    end

    # Run for specified time
    stream = Pipe()
    proc = run(pipeline(cmd, stdout=stream, stderr=stream), wait=false)
    sleep(duration)

    # Stop process if necessary
    crashed = !process_running(proc)
    if !crashed
        kill(proc)

        while(process_running(proc))
            sleep(0.1)
        end
    end

    # Retrieve result
    close(stream.in)
    result = read(stream, String)

    # Check and warn about unexpected crashes
    if crashed
        @warn "Implementation '$implementation' aborted unexpectedly:\n$result"
    end

    @test !crashed

    if Config.verbose
        println("└ [OUTPUTS] ", result)
    end

    return result
end

"Execute implementation and use supplied function to verify result."
function execute(verify::Function, self::Tester, duration)
    @testset "$(self.name)" begin
        for implementation in Config.implementations
            # Compute expected storage root
            root = compute_root(self, implementation)

            # Run implementation long enough to load genesis
            result = run_tester(self, implementation, duration)

            verify((root, result))
        end
    end # testset
end

end # module
