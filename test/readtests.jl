@testset "read HTML table from HTML documents using DataFrame" begin
    df_01::DataFrame = HTMLTables.readtable(HTML_FILE_01, DataFrame)

    df_01[!, :Age] = Base.parse.(Int, df_01[!, :Age])

    @test Base.size(df_01) == (3, 3)

    @test Base.names(df_01) == ["Name", "Age", "Occupation"]

    @test df_01[1, 1] == "Alice"
    @test df_01[1, 2] == 30
    @test df_01[1, 3] == "Engineer"

    @test df_01[2, 1] == "Bob"
    @test df_01[2, 2] == 25
    @test df_01[2, 3] == "Designer"

    @test df_01[3, 1] == "Charlie"
    @test df_01[3, 2] == 35
    @test df_01[3, 3] == "Teacher"

    @test Base.isa(df_01, DataFrame)

    @test Base.isa(df_01[1, 1], String)
    @test Base.isa(df_01[1, 2], Int)
    @test Base.isa(df_01[1, 3], String)

    @test Base.isa(df_01[2, 1], String)
    @test Base.isa(df_01[2, 2], Int)
    @test Base.isa(df_01[2, 3], String)

    @test Base.isa(df_01[3, 1], String)
    @test Base.isa(df_01[3, 2], Int)
    @test Base.isa(df_01[3, 3], String)

    df_02::DataFrame = HTMLTables.readtable(HTML_FILE_02, DataFrame)

    @test Base.size(df_02) == (3, 3)

    @test Base.names(df_02) == ["Name", "Age", "Occupation"]

    @test Base.isa(df_02, DataFrame)

    @test Base.all(x -> x == "" || Base.ismissing(x), df_02[!, :Name])
    @test Base.all(x -> x == "" || Base.ismissing(x), df_02[!, :Age])
    @test Base.all(x -> x == "" || Base.ismissing(x), df_02[!, :Occupation])

    for row in Base.eachindex(df_02[:, 1])
        @test df_02[row, :Name] == "" || Base.ismissing(df_02[row, :Name])
        @test df_02[row, :Age] == "" || Base.ismissing(df_02[row, :Age])
        @test df_02[row, :Occupation] == "" || Base.ismissing(df_02[row, :Occupation])
    end
end

@testset "read HTML table from HTML string using DataFrame" begin
    df_01::DataFrame = HTMLTables.readtable(Base.read(HTML_FILE_01, String), DataFrame)

    df_01[!, :Age] = Base.parse.(Int, df_01[!, :Age])

    @test Base.size(df_01) == (3, 3)

    @test Base.names(df_01) == ["Name", "Age", "Occupation"]

    @test df_01[1, 1] == "Alice"
    @test df_01[1, 2] == 30
    @test df_01[1, 3] == "Engineer"

    @test df_01[2, 1] == "Bob"
    @test df_01[2, 2] == 25
    @test df_01[2, 3] == "Designer"

    @test df_01[3, 1] == "Charlie"
    @test df_01[3, 2] == 35
    @test df_01[3, 3] == "Teacher"

    @test Base.isa(df_01, DataFrame)

    @test Base.isa(df_01[1, 1], String)
    @test Base.isa(df_01[1, 2], Int)
    @test Base.isa(df_01[1, 3], String)

    @test Base.isa(df_01[2, 1], String)
    @test Base.isa(df_01[2, 2], Int)
    @test Base.isa(df_01[2, 3], String)

    @test Base.isa(df_01[3, 1], String)
    @test Base.isa(df_01[3, 2], Int)
    @test Base.isa(df_01[3, 3], String)

    df_02::DataFrame = HTMLTables.readtable(Base.read(HTML_FILE_02, String), DataFrame)

    @test Base.size(df_02) == (3, 3)

    @test Base.names(df_02) == ["Name", "Age", "Occupation"]

    @test Base.isa(df_02, DataFrame)

    @test Base.all(x -> x == "" || Base.ismissing(x), df_02[!, :Name])
    @test Base.all(x -> x == "" || Base.ismissing(x), df_02[!, :Age])
    @test Base.all(x -> x == "" || Base.ismissing(x), df_02[!, :Occupation])

    for row in Base.eachindex(df_02[:, 1])
        @test df_02[row, :Name] == "" || Base.ismissing(df_02[row, :Name])
        @test df_02[row, :Age] == "" || Base.ismissing(df_02[row, :Age])
        @test df_02[row, :Occupation] == "" || Base.ismissing(df_02[row, :Occupation])
    end
end

@testset "read HTML table from IO using DataFrame" begin
    html_io_01::IO = Base.open(HTML_FILE_01, "r")

    df_01::DataFrame = HTMLTables.readtable(html_io_01, DataFrame)

    df_01[!, :Age] = Base.parse.(Int, df_01[!, :Age])

    @test Base.size(df_01) == (3, 3)

    @test Base.names(df_01) == ["Name", "Age", "Occupation"]

    @test df_01[1, 1] == "Alice"
    @test df_01[1, 2] == 30
    @test df_01[1, 3] == "Engineer"

    @test df_01[2, 1] == "Bob"
    @test df_01[2, 2] == 25
    @test df_01[2, 3] == "Designer"

    @test df_01[3, 1] == "Charlie"
    @test df_01[3, 2] == 35
    @test df_01[3, 3] == "Teacher"

    @test Base.isa(df_01, DataFrame)

    @test Base.isa(df_01[1, 1], String)
    @test Base.isa(df_01[1, 2], Int)
    @test Base.isa(df_01[1, 3], String)

    @test Base.isa(df_01[2, 1], String)
    @test Base.isa(df_01[2, 2], Int)
    @test Base.isa(df_01[2, 3], String)

    @test Base.isa(df_01[3, 1], String)
    @test Base.isa(df_01[3, 2], Int)
    @test Base.isa(df_01[3, 3], String)

    html_io_02::IO = Base.open(HTML_FILE_02, "r")

    df_02::DataFrame = HTMLTables.readtable(html_io_02, DataFrame)

    @test Base.size(df_02) == (3, 3)

    @test Base.names(df_02) == ["Name", "Age", "Occupation"]

    @test Base.isa(df_02, DataFrame)

    @test Base.all(x -> x == "" || Base.ismissing(x), df_02[!, :Name])
    @test Base.all(x -> x == "" || Base.ismissing(x), df_02[!, :Age])
    @test Base.all(x -> x == "" || Base.ismissing(x), df_02[!, :Occupation])

    for row in Base.eachindex(df_02[:, 1])
        @test df_02[row, :Name] == "" || Base.ismissing(df_02[row, :Name])
        @test df_02[row, :Age] == "" || Base.ismissing(df_02[row, :Age])
        @test df_02[row, :Occupation] == "" || Base.ismissing(df_02[row, :Occupation])
    end
end