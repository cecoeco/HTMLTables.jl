using Test, HTMLTables, DataFrames

const HTML_DIR::String = joinpath(dirname(@__FILE__), "html")

@testset "read HTML table using DataFrame" begin
    df::DataFrame = HTMLTables.read(joinpath(HTML_DIR, "example-01.html"), DataFrame)

    @test size(df) == (3, 3)

    @test df[1, 1] == "Alice"
    @test df[1, 2] == "30"
    @test df[1, 3] == "Engineer"

    @test df[2, 1] == "Bob"
    @test df[2, 2] == "25"
    @test df[2, 3] == "Designer"

    @test df[3, 1] == "Charlie"
    @test df[3, 2] == "35"
    @test df[3, 3] == "Teacher"

    @test typeof(df) == DataFrame

    @test typeof(df[1, 1]) == String
    @test typeof(df[1, 2]) == String
    @test typeof(df[1, 3]) == String

    @test typeof(df[2, 1]) == String
    @test typeof(df[2, 2]) == String
    @test typeof(df[2, 3]) == String

    @test typeof(df[3, 1]) == String
    @test typeof(df[3, 2]) == String
    @test typeof(df[3, 3]) == String
end
