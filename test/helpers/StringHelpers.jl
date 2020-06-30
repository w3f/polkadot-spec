module StringHelpers

export CmdList, CmdString, CmdStringList, CmdStringTuple, cmdjoin, cmdcombine
export StringList, stringify, combine, inquotes, commajoin, flatzip

using Base.Iterators

"Base types used for list abstraction"
List = Vector

"List of lists"
ListList{T} = List{List{T}}


"""
# Cmd collections and helper functions

Thin wrapper around Julia's Cmd handeling _idioms_ for lists of commands and
collections of those, as well as for the interaction with strings.
"""

"Simple command list abstraction."
CmdList = List{Cmd}

"A command or string"
CmdString = Union{Cmd, String}

"A list of command and strings"
CmdStringList = Union{List{Cmd}, List{String}, List{CmdString}}

"Any tuple of commands or strings"
CmdStringTuple = Tuple{CmdString,Vararg{CmdString}}


"Join two commands or strings with a space to a command"
function cmdjoin(self::CmdString, other::CmdString)::Cmd
    return `$self $other`
end

"Combine all commands and strings in vector to single command, seperated by spaces."
function cmdjoin(commands::CmdStringList)::Cmd
    return reduce(cmdjoin, commands)
end

"Combine all commands and strings in tuple to single command, seperated by spaces."
function cmdjoin(commands::CmdStringTuple)::Cmd
    return reduce(cmdjoin, commands)
end


"Helper to append commands or strings to all entries of a list."
function cmdcombine(self::CmdStringList, suffix::CmdString)::CmdList
    return map((x)->cmdjoin(x, suffix), self)
end

"Helper to append each member of another list to all entries of current list."
function cmdcombine(self::CmdStringList, other::CmdStringList)::CmdList
    # For the resulting vector to be in the user expected order the two
    # lists are multiplied in reversed order, while the string are joined
    # in the correct order.
    # Could be replace by transpose operation but Julia seems to be lacking
    # transpose(Matrix{String}), though onw could use `permutedims`.
    return vec(map(cmdjoin ∘ reverse, product(other, self)))
end


"""
# String collections and helper functions

Thin wrapper around Julia's String handeling _idioms_ for lists of strings and
collections of those.
"""

"Simple string list abstraction."
StringList = List{String}

"Ordered collection of string lists."
StringListList = List{StringList}

"Turn parameter set into a pure string representation."
function stringify(self::ListList{<:Any})::StringListList
    map(xs -> map(string, xs), self)
end

"Helper to append string to all entries of a list."
function combine(self::StringList, suffix::String)::StringList
    return self .* suffix
end

"Helper to append each member of a different list to all entries."
function combine(self::StringList, other::StringList)::StringList
    # For the resulting vector to be in the user expected order the two
    # lists are multiplied in reversed order, while the string are joined
    # in the correct order.
    # Could be replace by transpose operation but Julia seems to be lacking
    # transpose(Matrix{String}), though onw could use `permutedims`.
    return vec(map(join ∘ reverse, product(other, self)))
end

"Helper to put each string in list inside double quotes."
function inquotes(self::StringList)::StringList
    return "\"" .* self .* "\""
end

"Helper to join a list of strings with commas."
function commajoin(self::StringList)::String
    return join(self, ",")
end

"Helper to join all string lists inside a collectin with commas."
function commajoin(self::StringListList)::StringList
    return map(commajoin, self)
end

"Helper to join all parameter lists inside a collection with commas."
function commajoin(self::ListList{<:Any})::StringList
    self |> stringify |> commajoin
end


"""
# General collection helper functions
"""

"""
    flatzip(dataset_1, dataset_2, ...)

Helper to zip together multiple collections of parameter lists into a single
collection.

# Description
Combines the inner arrays of the different test data types, iterates over them,
and merges those arrays of each iteration into a single, new array.
This allows to reuse test data for functions of various input types.

# Example
```jldoctest
julia> flatzip( \\
    # Test data type (each inner array represents different values) \\
    [[1, 2, 3], [7, 8, 9],    [13, 14, 15]], \\
    # Different test data type (each inner array represents different values) \\
    [[4, 5, 6], [10, 11, 12], [16, 17, 18]], \\
)
3-element Array{Array{Int,1},1}:
 [1, 2, 3, 4, 5, 6]
 [7, 8, 9, 10, 11, 12]
 [13, 14, 15, 16, 17, 18]
```
"""
function flatzip(self::ListList{<:Any}...)::ListList{<:Any}
    return map(collect ∘ flatten, zip(self...))
end

end # module
