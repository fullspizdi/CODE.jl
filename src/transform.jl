# src/transform.jl
"""
This module provides functionalities for transforming Julia code expressions programmatically.
It includes functions to modify existing code, build macros, and operate on other functions.
"""

module Transform

export modify_code, apply_macro, transform_function

using Base.Meta: mapexpr

"""
    modify_code(expr::Expr, transform::Function)

Transform a given code expression using a custom transformation function.
"""
function modify_code(expr::Expr, transform::Function)
    return mapexpr(transform, expr)
end

"""
    apply_macro(macro_func::Function, expr::Expr)

Applies a macro function to a given expression and returns the transformed expression.
"""
function apply_macro(macro_func::Function, expr::Expr)
    macro_expr = Expr(:macrocall, macro_func, expr)
    return eval(macro_expr)
end

"""
    transform_function(func::Function, transform::Function)

Applies a transformation to the body of a given function.
"""
function transform_function(func::Function, transform::Function)
    func_expr = Base.uncompressed_ast(func)
    transformed_body = mapexpr(transform, func_expr.args[2])
    new_func_expr = Expr(:function, func_expr.args[1], transformed_body)
    eval(new_func_expr)
    return new_func_expr
end

end # module Transform
