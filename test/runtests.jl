using Test
using CODE

@testset "CODE.jl Tests" begin

    @testset "Analyze Module Tests" begin
        # Testing argument name extraction
        test_func(arg1, arg2) = arg1 + arg2
        @test CODE.argnames(test_func) == [:arg1, :arg2]

        # Testing documentation string extraction
        """
            test_func(arg1, arg2)

        Add two numbers.
        """
        @test CODE.docstring(test_func) == "Add two numbers."

        # Testing type information extraction
        @test typeof(CODE.typeinfo(test_func)) == Tuple
    end

    @testset "Transform Module Tests" begin
        # Testing code modification
        expr = :(1 + 2)
        modified_expr = CODE.modify_code(expr)
        @test eval(modified_expr) == 5  # Since 1^2 + 2^2 = 1 + 4

        # Testing function transformation
        transformed_func = CODE.transform_function(test_func, x -> x isa Integer ? x^2 : x)
        @test transformed_func(2, 3) == 13  # Since 2^2 + 3^2 = 4 + 9
    end

    @testset "Generate Module Tests" begin
        # Testing dynamic function generation
        new_func_expr = CODE.generate_function(:new_func, [:x, :y], :(x * y))
        new_func = eval(new_func_expr)
        @test new_func(3, 4) == 12

        # Testing DSL creation
        dsl_rules = Dict(:double => x -> 2x, :triple => x -> 3x)
        dsl_module = CODE.create_dsl(:TestDSL, dsl_rules)
        @test eval(:(TestDSL.double(3))) == 6
        @test eval(:(TestDSL.triple(3))) == 9
    end

end
