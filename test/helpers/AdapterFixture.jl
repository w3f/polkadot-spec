module AdapterFixture

export sub!, arg!, foreach!, commit!, reset!, clear!, prepare!


using Test

using ..StringHelper
using ..Config

"Structure used behind the scene to collect test cases"
mutable struct Builder
    "Name of the testsuite"
    name::String

    "Value to which to reset"
    default::String

    "Command currently being constructed"
    current::StringList

    "Collection of all commands to run"
    inputs::StringList

    "Expected output generated with reference implementations"
    outputs::StringList

    "Constructor: Only allow to set name on construction"
    Builder(name, default="") = new(name, default, [default], [], [])
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
function arg!(self::Builder, arg::AbstractString)
    self.current = combine(self.current, " " * arg)
end

"Add each argument to commands currently being build"
function foreach!(self::Builder, args::StringList)
    self.current = combine(self.current, " " .* args)
end

"""
Commit commands currently being build to inputs list, expects ``prepare!``
to be run before execution to generate expected ouputs."
"""
function commit!(self::Builder)
    append!(self.inputs, self.current)
end

"""
Commit commands currently being build to inputs list together with expected
output. Pass empty list to ignore output checks.
"""
function commit!(self::Builder, outputs::StringList)
    if isempty(outputs)
        outputs = fill("", length(self.current))
    elseif length(outputs) != length(self.current)
        error("Different count of Inputs and expected outputs.")
    end

    append!(self.outputs, outputs)
    append!(self.inputs,  self.current)
end

"Commit commands currently being build to inputs list, disabling output check."
function commit!(self::Builder, _::Nothing)
    commit!(self, StringList())
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
            cmd = "$implementation-adapter $args"
            push!(self.outputs, read(`sh -c $cmd`, String))
        catch e
            error("Failed to cache reference output: $e")
        end
    end
end

"Run all commited test for specified adapter."
function run(self::Builder, adapter::String)
    if length(self.inputs) != length(self.outputs)
        error("Missing or outdated cached reference outputs")
    end

    for (input, output) in zip(self.inputs, self.outputs)
        try
            cmd = "$adapter $input"

            if Config.verbose
                println("[> RUNNING] ", cmd)
            end

            result = read(`sh -c $cmd`, String)

            if output in ["", "\n"]
                # Empty output is used to disable output comparison
                @test true
            elseif isempty(result)
                # Empty test result are interpretted as missing adaption
                @warn "Missing adaption: $cmd"
                @test_skip false
            else
                # Default: Compare result against expected result
                @test result == output

                if Config.verbose
                    println("[OUTPUT]: ", result)
                end
            end
        catch err
            @error "Adapter failed: $err"
            # Should be @test_broken, but does not fail CI
            @test false
        end # try-catch
    end # for inputs
end

"List of implementations with legacy adapter"
IMPLEMENTATIONS_WITH_LEGACY_ADAPTER = [ "substrate" ]

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
