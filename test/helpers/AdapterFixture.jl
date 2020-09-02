module AdapterFixture

export sub!, arg!, foreach!, commit!, reset!, clear!, prepare!


using Test

using ..StringHelpers
using ..Config


"Exit code to state outcome of adapter test, based on errno"
@enum AdapterExitCode Success Failure NotSupported=95


"Structure used behind the scene to collect test cases"
mutable struct Builder
    "Name of the testsuite"
    name::String

    "Value to which to reset"
    default::Cmd

    "Command currently being constructed"
    current::CmdList

    "Collection of all commands to run"
    inputs::CmdList

    "Expected output generated with reference implementations"
    outputs::MaybeStringList

    "Constructor: Only allow to set name on construction"
    Builder(name, default=``) = new(name, default, [default], [], [])
end


"Basic iterator support"
Base.iterate(b::Builder, i=1) = i > length(b.inputs) ? nothing : (b.inputs[i], i+1)
Base.eltype(::Type{Builder}) = Int
Base.length(b::Builder) = length(b.inputs)


"Create subcontext and add inputs to main context after execution"
function sub!(context!::Function, self::Builder)
    copy = deepcopy(self)

    clear!(copy)
    context!(copy)

    append!(self.inputs,  copy.inputs)
    append!(self.outputs, copy.outputs)
end

"Add arguments to commands currently being build"
function arg!(self::Builder, arg::CmdString)
    self.current = cmdcombine(self.current, arg)
end

"Add each argument to commands currently being build"
function foreach!(self::Builder, args::CmdStringList)
    self.current = cmdcombine(self.current, args)
end

"""
Commit commands currently being build to inputs list, expects `prepare!`
to be run before execution to generate expected ouputs.
"""
function commit!(self::Builder)
    append!(self.inputs, self.current)
end

"""
Commit commands currently being build to inputs list together with list 
of expected output. Use nothing entries to disable output checks.
"""
function commit!(self::Builder, outputs::MaybeStringList)
    if length(outputs) != length(self.current)
        error("Different count of Inputs and expected outputs.")
    end

    append!(self.outputs, outputs)
    append!(self.inputs,  self.current)
end

"""
Commit commands currently being build to inputs list together with a single
expected output for all of them. Use nothing to disable output checks.
"""
function commit!(self::Builder, output::MaybeString)
    commit!(self, MaybeStringList(output, length(self.current)))
end

"Reset current command being build to default"
function reset!(self::Builder)
    self.current = [self.default]
end

"Clear all commands committed so far"
function clear!(self::Builder)
    self.inputs = StringList()
    self.outputs = StringList()
end


"Cache expected output by running reference implementation, substrate by default."
function prepare!(self::Builder, implementation="substrate")
    self.outputs = []
    for (i, args) in enumerate(self.inputs)
        try
            cmd = `$(implementation)-adapter $args`
            push!(self.outputs, read(cmd, String))
        catch e
            error("Failed to cache reference output: $e")
        end
    end
end

"Run all commited test for specified adapter."
function run(self::Builder, adapter::CmdString)
    if length(self.inputs) != length(self.outputs)
        error("Missing or outdated cached reference outputs")
    end

    for (input, output) in zip(self.inputs, self.outputs)

        # Execute adapter and collect output and exit code
        cmd = cmdjoin(adapter, input)

        if Config.verbose
            println("┌ [COMMAND] ", cmd)
        end

        stream = Pipe()
        proc = Base.run(pipeline(ignorestatus(cmd), stdout=stream, stderr=stream))
        close(stream.in)
        result = read(stream, String)

        # Check if adapter is missing adaption (special case)
        if proc.exitcode == Int(NotSupported)
            @warn "Missing adaption: $cmd"
            @test_skip AdapterExitCode(proc.exitcode) == NotSupported
            continue
        end

        # Check exit code and result
        if success(proc)
            if output != nothing
                # Default: Compare result against expected result
                @test result == output
            else
                # Empty outputs are used to disable comparison
                @test output == nothing
            end

        else
            @error "Adapter failed running $cmd:\n$result"
            @test success(proc)
        end

        if Config.verbose
            if success(proc)
                if output != nothing
                    println("└ [OUTPUTS] ", result)
                else
                    println("└ [IGNORED] ", result)
                end
            else
                println("└ [FAILED] (", proc.exitcode, ") ", result)
            end

            if isempty(result)
                println()
            end
        end
   end # for inputs
end

"List of implementations with legacy adapter"
IMPLEMENTATIONS_WITH_LEGACY_ADAPTER = [ "substrate" "kagome" ]

"Run fixture for each configured implementation, optional flag to use legacy version if available."
function execute(self::Builder; legacy::Bool=false)
    @testset "$(self.name)" begin
        for implementation in Config.implementations
            adapter = "$implementation-adapter"

            if legacy && implementation in IMPLEMENTATIONS_WITH_LEGACY_ADAPTER
                adapter *= "-legacy"
            end

            run(self, adapter)
        end
    end # testset
end

end # module
