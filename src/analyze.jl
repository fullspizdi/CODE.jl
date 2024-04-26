# src/analyze.jl
"""
This module provides functionalities for analyzing Julia code objects at runtime.
It includes functions to inspect functions, extract argument names, docstrings, type information, and more.
"""

module Analyze

export argnames, docstring, typeinfo

using Base: @doc

"""
    argnames(func::Function)

Extract the names of the arguments from a given function.
"""
function argnames(func::Function)
    return [arg for arg in Base.argnames(func)]
end

"""
    docstring(func::Function)

Retrieve the documentation string associated with a function if available.
"""
function docstring(func::Function)
    return @doc(func)
end

"""
    typeinfo(func::Function)

Extract type information of the arguments and return type of a function.
"""
function typeinfo(func::Function)
    types = Tuple{typeof(func).types.parameters...}
    return_type = typeof(func).return_type
    return (arg_types = types, return_type = return_type)
end

end # module Analyze
