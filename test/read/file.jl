@testset "read HTML table using DataFrame" begin
    df::DataFrame = HTMLTables.read(joinpath(HTML_DIR, "example-01.html"), DataFrame)

    df[!, :Age] = parse.(Int, df[!, :Age])

    @test size(df) == (3, 3)

    @test names(df) == ["Name", "Age", "Occupation"]

    @test df[1, 1] == "Alice"
    @test df[1, 2] == 30
    @test df[1, 3] == "Engineer"

    @test df[2, 1] == "Bob"
    @test df[2, 2] == 25
    @test df[2, 3] == "Designer"

    @test df[3, 1] == "Charlie"
    @test df[3, 2] == 35
    @test df[3, 3] == "Teacher"

    @test isa(df, DataFrame)

    @test isa(df[1, 1], String)
    @test isa(df[1, 2], Int)
    @test isa(df[1, 3], String)

    @test isa(df[2, 1], String)
    @test isa(df[2, 2], Int)
    @test isa(df[2, 3], String)

    @test isa(df[3, 1], String)
    @test isa(df[3, 2], Int)
    @test isa(df[3, 3], String)
end

@testset "read HTML table using DataFrame with empty cells" begin
    df::DataFrame = HTMLTables.read(joinpath(HTML_DIR, "example-02.html"), DataFrame)

    @test size(df) == (3, 3)

    @test names(df) == ["Name", "Age", "Occupation"]

    @test isa(df, DataFrame)

    @test all(x -> x == "" || ismissing(x), df[!, :Name])
    @test all(x -> x == "" || ismissing(x), df[!, :Age])
    @test all(x -> x == "" || ismissing(x), df[!, :Occupation])

    for row in eachindex(df[:, 1])
        @test df[row, :Name] == "" || ismissing(df[row, :Name])
        @test df[row, :Age] == "" || ismissing(df[row, :Age])
        @test df[row, :Occupation] == "" || ismissing(df[row, :Occupation])
    end
end