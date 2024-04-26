# src/generate.jl
"""
This module provides functionalities for dynamically generating Julia code.
It includes functions to create new functions, DSLs, and other code constructs programmatically.
"""

module Generate

export generate_function, create_dsl, template_function

using Base: eval, Expr

"""
    generate_function(name::Symbol, args::Vector{Symbol}, body::Expr)

Dynamically create a new Julia function.
"""
function generate_function(name::Symbol, args::Vector{Symbol}, body::Expr)
    func_expr = Expr(:function, Expr(:call, name, args...), body)
    eval(func_expr)
    return func_expr
end

"""
    create_dsl(dsl_name::Symbol, rules::Dict{Symbol, Function})

Creates a simple domain-specific language (DSL) by generating functions based on the provided rules.
"""
function create_dsl(dsl_name::Symbol, rules::Dict{Symbol, Function})
    dsl_module = Expr(:module, dsl_name, Expr(:block))
    for (name, func) in rules
        func_expr = generate_function(name, [:input], Expr(:block, func(:input)))
        push!(dsl_module.args[2].args, func_expr)
    end
    eval(dsl_module)
    return dsl_module
end

"""
    template_function(template::String, replacements::Dict{Symbol, Any})

Generates a function from a string template by replacing placeholders with actual code or values.
"""
function template_function(template::String, replacements::Dict{Symbol, Any})
    template_expr = Meta.parse(template)
    replaced_expr = Base.Meta.mapexpr(x -> isa(x, Symbol) && haskey(replacements, x) ? replacements[x] : x, template_expr)
    eval(replaced_expr)
    return replaced_expr
end

end # module Generate
