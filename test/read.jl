@testset "read HTML table from HTML documents using DataFrame" begin
    df_01::DataFrame = HTMLTables.read(HTML_FILE_01, DataFrame)

    df_01[!, :Age] = parse.(Int, df_01[!, :Age])

    @test size(df_01) == (3, 3)

    @test names(df_01) == ["Name", "Age", "Occupation"]

    @test df_01[1, 1] == "Alice"
    @test df_01[1, 2] == 30
    @test df_01[1, 3] == "Engineer"

    @test df_01[2, 1] == "Bob"
    @test df_01[2, 2] == 25
    @test df_01[2, 3] == "Designer"

    @test df_01[3, 1] == "Charlie"
    @test df_01[3, 2] == 35
    @test df_01[3, 3] == "Teacher"

    @test isa(df_01, DataFrame)

    @test isa(df_01[1, 1], String)
    @test isa(df_01[1, 2], Int)
    @test isa(df_01[1, 3], String)

    @test isa(df_01[2, 1], String)
    @test isa(df_01[2, 2], Int)
    @test isa(df_01[2, 3], String)

    @test isa(df_01[3, 1], String)
    @test isa(df_01[3, 2], Int)
    @test isa(df_01[3, 3], String)

    df_02::DataFrame = HTMLTables.read(HTML_FILE_02, DataFrame)

    @test size(df_02) == (3, 3)

    @test names(df_02) == ["Name", "Age", "Occupation"]

    @test isa(df_02, DataFrame)

    @test all(x -> x == "" || ismissing(x), df_02[!, :Name])
    @test all(x -> x == "" || ismissing(x), df_02[!, :Age])
    @test all(x -> x == "" || ismissing(x), df_02[!, :Occupation])

    for row in eachindex(df_02[:, 1])
        @test df_02[row, :Name] == "" || ismissing(df_02[row, :Name])
        @test df_02[row, :Age] == "" || ismissing(df_02[row, :Age])
        @test df_02[row, :Occupation] == "" || ismissing(df_02[row, :Occupation])
    end
end

@testset "read HTML table from HTML string using DataFrame" begin
    df_01::DataFrame = HTMLTables.read(Base.read(HTML_FILE_01, String), DataFrame)

    df_01[!, :Age] = parse.(Int, df_01[!, :Age])

    @test size(df_01) == (3, 3)

    @test names(df_01) == ["Name", "Age", "Occupation"]

    @test df_01[1, 1] == "Alice"
    @test df_01[1, 2] == 30
    @test df_01[1, 3] == "Engineer"

    @test df_01[2, 1] == "Bob"
    @test df_01[2, 2] == 25
    @test df_01[2, 3] == "Designer"

    @test df_01[3, 1] == "Charlie"
    @test df_01[3, 2] == 35
    @test df_01[3, 3] == "Teacher"

    @test isa(df_01, DataFrame)

    @test isa(df_01[1, 1], String)
    @test isa(df_01[1, 2], Int)
    @test isa(df_01[1, 3], String)

    @test isa(df_01[2, 1], String)
    @test isa(df_01[2, 2], Int)
    @test isa(df_01[2, 3], String)

    @test isa(df_01[3, 1], String)
    @test isa(df_01[3, 2], Int)
    @test isa(df_01[3, 3], String)

    df_02::DataFrame = HTMLTables.read(Base.read(HTML_FILE_02, String), DataFrame)

    @test size(df_02) == (3, 3)

    @test names(df_02) == ["Name", "Age", "Occupation"]

    @test isa(df_02, DataFrame)

    @test all(x -> x == "" || ismissing(x), df_02[!, :Name])
    @test all(x -> x == "" || ismissing(x), df_02[!, :Age])
    @test all(x -> x == "" || ismissing(x), df_02[!, :Occupation])

    for row in eachindex(df_02[:, 1])
        @test df_02[row, :Name] == "" || ismissing(df_02[row, :Name])
        @test df_02[row, :Age] == "" || ismissing(df_02[row, :Age])
        @test df_02[row, :Occupation] == "" || ismissing(df_02[row, :Occupation])
    end
end

@testset "read HTML table from URL using DataFrame" begin
    dataframes::Vector{DataFrame} = HTMLTables.readall(URL_01, DataFrame)

    for idx in eachindex(dataframes)
        println("DataFrame $idx:")
        println(dataframes[idx])
    end

    @test length(dataframes) == 2
end

@testset "read HTML table from IO using DataFrame" begin
    html_io_01::IO = open(HTML_FILE_01, "r")

    df_01::DataFrame = HTMLTables.read(html_io_01, DataFrame)

    df_01[!, :Age] = parse.(Int, df_01[!, :Age])

    @test size(df_01) == (3, 3)

    @test names(df_01) == ["Name", "Age", "Occupation"]

    @test df_01[1, 1] == "Alice"
    @test df_01[1, 2] == 30
    @test df_01[1, 3] == "Engineer"

    @test df_01[2, 1] == "Bob"
    @test df_01[2, 2] == 25
    @test df_01[2, 3] == "Designer"

    @test df_01[3, 1] == "Charlie"
    @test df_01[3, 2] == 35
    @test df_01[3, 3] == "Teacher"

    @test isa(df_01, DataFrame)

    @test isa(df_01[1, 1], String)
    @test isa(df_01[1, 2], Int)
    @test isa(df_01[1, 3], String)

    @test isa(df_01[2, 1], String)
    @test isa(df_01[2, 2], Int)
    @test isa(df_01[2, 3], String)

    @test isa(df_01[3, 1], String)
    @test isa(df_01[3, 2], Int)
    @test isa(df_01[3, 3], String)

    html_io_02::IO = Base.open(HTML_FILE_02, "r")

    df_02::DataFrame = HTMLTables.read(html_io_02, DataFrame)

    @test size(df_02) == (3, 3)

    @test names(df_02) == ["Name", "Age", "Occupation"]

    @test isa(df_02, DataFrame)

    @test all(x -> x == "" || ismissing(x), df_02[!, :Name])
    @test all(x -> x == "" || ismissing(x), df_02[!, :Age])
    @test all(x -> x == "" || ismissing(x), df_02[!, :Occupation])

    for row in eachindex(df_02[:, 1])
        @test df_02[row, :Name] == "" || ismissing(df_02[row, :Name])
        @test df_02[row, :Age] == "" || ismissing(df_02[row, :Age])
        @test df_02[row, :Occupation] == "" || ismissing(df_02[row, :Occupation])
    end
end