@testset "write table with built-in theme" begin
    df = DataFrame(x = 1:10, y = 1:10)

    themes = [
        :default, :red, :orange, :yellow, :green, :blue, :violet, :magenta, 
        :brown, :gray, :black, :gold, :silver, :bronze, :julia, 
        :sunstone, :moonstone
    ]

    for theme in themes
        html1 = HTMLTables.table(df, theme=theme)
        @test occursin("<style>", html1)

        html2 = HTMLTables.table(df, theme=string(theme))
        @test occursin("<style>", html2)

        @test html1 == html2
    end
end

@testset "write table with CSS string" begin
end

@testset "write table with CSS file" begin
end

@testset "write table with colorscale" begin
end

@testset "write table with built-in theme, CSS string, CSS file, and colorscale" begin
end

@testset "disable CSS" begin
    df = DataFrame(x = 1:10, y = 1:10)

    table_01 = HTMLTables.table(df; css=false, theme=["default", joinpath(CSS_DIR, "example-01.css")], colorscale="Reds")

    @test !occursin("<style>", table_01)

    table_02 = HTMLTables.table(df; css=false, theme=[:gold, joinpath(CSS_DIR, "example-02.css")], colorscale="Viridis")

    @test !occursin("<style>", table_02)

    @test table_01 == table_02
end