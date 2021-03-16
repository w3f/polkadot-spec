module HostFixture

using ..Config
using Test

"Represensts a fixture based on a tester runtime"
struct Tester
    "Name of the testsuite"
    name::String

    "Name of the runtime to use"
    runtime::String
end


"Compute trie root hash from yaml state file"
function compute_root(self::Tester)

    state_file = "$(@__DIR__)/../runtimes/$(self.runtime)/genesis.yaml"

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


"Run host with tester genesis for certain time in seconds"
function run_tester(self::Tester, host::String, duration::Number)
    # Locations of needed files and folders
    tempdir = mktempdir() * "/"

    # Determine correct genesis of runtime
    genesis = "$(@__DIR__)/../runtimes/$(self.runtime)/genesis.json"

    # Make sure genesis is available
    if !isfile(genesis)
        @error "Failed to locate genesis: $genesis"
    end

    # Helper files needed for some hosts
    keystore = "$(@__DIR__)/../runtimes/$(self.runtime)/keystore"
    config   = if Config.docker
        "$(@__DIR__)/../runtimes/$(self.runtime)/gossamer.docker.config.toml"
    else
        "$(@__DIR__)/../runtimes/$(self.runtime)/gossamer.config.toml"
    end

    # Copy prepopulated kagome keystore (TODO: Load chain id from genesis) 
    mkpath(joinpath(tempdir, "spectest"))
    cp(keystore, joinpath(tempdir, "spectest", "keystore"))

    # By default the tempdir is used for local data
    datadir = tempdir

    if Config.docker
        # Provide genesis and other files to container
        cp(genesis, joinpath(tempdir, basename(genesis)))
        cp(config, joinpath(tempdir, basename(config)))

        # Use fixed dir inside container
        datadir = "/data"

        genesis = joinpath(datadir, basename(genesis))
        config = joinpath(datadir, basename(config))
    end

    # Prepare command and environment based on command
    cmd  = ``
    args = ``
    if host == "substrate"
        exec = `polkadot`
        args = `--alice --chain $genesis -d $datadir`
        ENV["RUST_LOG"] = "runtime=debug"
    elseif host == "kagome"
        exec = `kagome_validating`
        args = `--genesis $genesis -d $datadir`
    elseif host == "gossamer"
        exec = `gossamer`
        args = `--key=alice --config $config --basepath $datadir --log debug`
    else
        error("Unknown host: ", host)
    end

    # Prepare container and overwrite command with docker invocation
    if Config.docker
        image = Config.get_container(host)

        if isempty(image)
            @error "Host '$host' has no default docker image."
        end

        println("Caching/updating docker images of '$host':")
        run(`docker pull $image`)

        exec = `docker run -e RUST_LOG=runtime=debug -v $tempdir:$datadir --rm -i $image`
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
        @warn "Host '$host' aborted unexpectedly:\n$result"
    end

    @test !crashed

    if Config.verbose
        println("└ [OUTPUTS] ", result)
    end

    return result
end

"Execute host and use supplied function to verify result."
function execute(verify::Function, self::Tester, duration)
    @testset "$(self.name)" begin
        for host in Config.implementations
            # Compute expected storage root
            root = compute_root(self)

            # Run host long enough to load genesis
            result = run_tester(self, host, duration)

            verify((root, result))
        end
    end # testset
end

end # module
