@testset "write table with built-in theme" begin
    df::DataFrame = DataFrame(x=1:10, y=1:10)

    themes::Vector{Symbol} = [
        :default,
        :red,
        :orange,
        :yellow,
        :green,
        :blue,
        :violet,
        :magenta,
        :brown,
        :gray,
        :black,
        :gold,
        :silver,
        :bronze,
        :julia,
        :sunstone,
        :moonstone,
    ]

    for theme in themes
        table_01::String = HTMLTables.table(df, theme=theme)
        @test occursin("<style>", table_01)

        table_02::String = HTMLTables.table(df, theme=string(theme))
        @test occursin("<style>", table_02)

        @test table_01 == table_02
    end
end

@testset "write table with CSS file" begin
    df = DataFrame(x=1:10, y=1:10)

    table_01 = HTMLTables.table(df; theme=joinpath(CSS_DIR, "example-01.css"))

    @test occursin("<style>", table_01)

    table_02 = HTMLTables.table(df; theme=joinpath(CSS_DIR, "example-02.css"))

    @test occursin("<style>", table_02)
end

@testset "disable CSS" begin
    df = DataFrame(x=1:10, y=1:10)

    table_01 = HTMLTables.table(
        df;
        css=false,
        theme=["default", joinpath(CSS_DIR, "example-01.css")],
        colorscale="Reds",
    )

    @test !occursin("<style>", table_01)

    table_02 = HTMLTables.table(
        df;
        css=false,
        theme=[:gold, joinpath(CSS_DIR, "example-02.css")],
        colorscale="viridis",
    )

    @test !occursin("<style>", table_02)

    @test table_01 == table_02
end