#!/usr/bin/env julia

include("helpers/SpecificationTestsuite.jl")

using .SpecificationTestsuite


function print_usage()
    println("usage: $PROGRAM_FILE [OPTIONS] [FILTERS ...]")
    println()
    println("OPTIONS:")
    println("  --help       Display this message")
    println("  --verbose    Print debug information")
    println()
    println("FILTERS:")
    println("A filter can be used to run specific implementations or fixtures.")
    println("If none are provided all are run. Multiple selecetions are possible.")
    println()
    println("IMPLEMENTATIONS:")
    println(join(ALL_IMPLEMENTATIONS, ", "))
    println()
    println("FIXTURES: ")
    println(join(ALL_FIXTURES, ", "))
end


# Collect filters
implementations = []
fixtures = []

# Process all command line arguments
for arg in ARGS
    if arg == "--help"
        print_usage()
        exit()
    end
    if arg == "--verbose"
        Config.set_verbose(true)
        continue
    end

    if arg in ALL_IMPLEMENTATIONS
        push!(implementations, arg)
        continue
    end

    if arg in ALL_FIXTURES
        push!(fixtures, arg)
        continue
    end

    println("Unknown argument: ", arg)
    println()
    print_usage()
    exit()
end

# Apply any specified filters
if !isempty(implementations)
    Config.set_implementations(implementations)
end

if !isempty(fixtures)
    Config.set_fixtures(fixtures)
end

# Display config
println("CONFIGURATION:")
println("Loglevel:        " * (Config.verbose ? "verbose" : "info"))
println("Implementations: " * join(Config.implementations, ", "))
println("Fixtures:        " * join(Config.fixtures, ", "))
println()

# Provide fallback path for locally or ci build adapters
ENV["PATH"] *= ":$(@__DIR__)/adapters/substrate/target/release"
ENV["PATH"] *= ":$(@__DIR__)/adapters/substrate/target/debug"
ENV["PATH"] *= ":$(@__DIR__)/adapters/substrate"
ENV["PATH"] *= ":$(@__DIR__)/adapters/substrate-legacy/target/release"
ENV["PATH"] *= ":$(@__DIR__)/adapters/substrate-legacy/target/debug"
ENV["PATH"] *= ":$(@__DIR__)/adapters/substrate-legacy"
ENV["PATH"] *= ":$(@__DIR__)/adapters/kagome/build"
ENV["PATH"] *= ":$(@__DIR__)/adapters/kagome"
ENV["PATH"] *= ":$(@__DIR__)/adapters/gossamer"
ENV["PATH"] *= ":$(@__DIR__)"

# Execute config
println("EXECUTION:")
execute()

exit()
