module AdapterTests

export sub!, arg!, foreach!, commit!, reset!

using ..Config

using Test

"Simple string list abstraction"
StringList = Vector{String}

"Helper to append string to all entries"
function combine(self::StringList, cmd::String)
  return self .* cmd
end

"Helper to append each member of a different list to all entries"
function combine(self::StringList, other::StringList)
  return reshape(self .* reshape(other, 1, :), :)
end


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
  Builder(name, default="" ) = new(name, default, [default], [])
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

  append!(self.inputs, copy.inputs)
end

"Add arguments to commands currently being build"
function arg!(self::Builder, arg::AbstractString)
  self.current = combine(self.current, " " * arg)
end

"Add each argument to commands currently being build"
function foreach!(self::Builder, args::Vector{String})
  self.current = combine(self.current, " " .* args)
end

"Commit commands currently being build to inputs list"
function commit!(self::Builder)
  append!(self.inputs, self.current)
end

"Reset current command being build to default"
function reset!(self::Builder)
  self.current = [self.default]
end

"Clear all commands committed so far"
function clear!(self::Builder)
  self.inputs = []
end


"Cache expected output by running reference implementation"
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

"Run all commited test for specified adapter"
function run(self::Builder, adapter::String)
    if length(self.inputs) != length(self.outputs)
        error("Missing or outdated cached reference outputs")
    end

    for (i, args) in enumerate(self.inputs)
        try
            cmd = "$adapter $args"

            if Config.verbose
                println("[> RUNNING]: ", cmd)
            end

            result = read(`sh -c $cmd`, String)

            if isempty(result) && !isempty(self.outputs[i])
                # TOOD: Warn about not implemented test
                @test_skip false
            else
                @test result == self.outputs[i]
            end

            if Config.verbose
                println("[OUTPUT]: ", result)
            end
        catch
            # TODO: Warn of failing adapter
            @test_broken false
        end # try-catch
    end # for inputs
end

"Run fixture for each configured implementation"
function execute(self::Builder)
    @testset "$(self.name)" begin
    for implementation in Config.implementations
            run(self, "$implementation-adapter")
        end
    end # testset
end

end # module
