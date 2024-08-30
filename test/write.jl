@testset "built-in CSS theme" begin
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
        table_01::String = HTMLTables.table(GLOBAL_DF_01; theme=theme)
        @test occursin("<style>", table_01)

        table_02::String = HTMLTables.table(GLOBAL_DF_01; theme=string(theme))
        @test occursin("<style>", table_02)

        @test table_01 == table_02
    end
end

@testset "CSS file" begin
    table_01 = HTMLTables.table(GLOBAL_DF_01; theme=CSS_FILE_01)
    @test occursin("<style>", table_01)

    table_02 = HTMLTables.table(GLOBAL_DF_01; theme=CSS_FILE_02)
    @test occursin("<style>", table_02)
end

@testset "CSS string" begin
    table_01::String = HTMLTables.table(GLOBAL_DF_01; theme=CSS_STRING_01)
    @test occursin("<style>", table_01)

    table_02::String = HTMLTables.table(GLOBAL_DF_01; theme=CSS_STRING_02)
    @test occursin("<style>", table_02)
end

@testset "header" begin
    table_01 = HTMLTables.table(GLOBAL_DF_01; header=true)
    @test occursin("<thead", table_01)

    table_02 = HTMLTables.table(GLOBAL_DF_01; header=false)
    @test !occursin("<thead", table_02)

    table_03 = HTMLTables.table(GLOBAL_DF_01)
    @test occursin("<thead", table_03)
end

@testset "footer" begin
    table_01 = HTMLTables.table(GLOBAL_DF_01; footer=true)
    @test occursin("<tfoot", table_01)

    table_02 = HTMLTables.table(GLOBAL_DF_01; footer=false)
    @test !occursin("<tfoot", table_02)

    table_03 = HTMLTables.table(GLOBAL_DF_01)
    @test occursin("<tfoot", table_03)
end

@testset "id" begin
    table_01 = HTMLTables.table(GLOBAL_DF_01; id="table_01")
    @test occursin("id=\"table_01\"", table_01)

    table_02 = HTMLTables.table(GLOBAL_DF_01; id="table_02")
    @test occursin("id=\"table_02\"", table_02)
end

@testset "class" begin
    table_01 = HTMLTables.table(GLOBAL_DF_01; class="table_01")
    @test occursin("class=\"table_01\"", table_01)

    table_02 = HTMLTables.table(GLOBAL_DF_01; class="table_02")
    @test occursin("class=\"table_02\"", table_02)

    table_03 = HTMLTables.table(GLOBAL_DF_01; class="table_01 table_02")
    @test occursin("class=\"table_01 table_02\"", table_03)

    table_04 = HTMLTables.table(GLOBAL_DF_01; class="table_02 table_01")
    @test occursin("class=\"table_02 table_01\"", table_04)

    table_05 = HTMLTables.table(GLOBAL_DF_01; class=["table_01", "table_02"])
    @test occursin("class=\"table_01 table_02\"", table_05)

    table_06 = HTMLTables.table(GLOBAL_DF_01; class=["table_02", "table_01"])
    @test occursin("class=\"table_02 table_01\"", table_06)
end

@testset "caption" begin
    table_01 = HTMLTables.table(GLOBAL_DF_01; caption="Table 1")
    @test occursin("<caption", table_01)

    table_02 = HTMLTables.table(GLOBAL_DF_01)
    @test !occursin("<caption", table_02)
end

@testset "tooltips" begin
    table_01 = HTMLTables.table(GLOBAL_DF_01; tooltips=true)
    @test occursin("title=\"", table_01)

    table_02 = HTMLTables.table(GLOBAL_DF_01; tooltips=false)
    @test !occursin("title=\"", table_02)

    table_03 = HTMLTables.table(GLOBAL_DF_01)
    @test occursin("title=\"", table_03)
end

@testset "editable" begin
    table_01 = HTMLTables.table(GLOBAL_DF_01; editable=true)
    @test occursin("contenteditable", table_01)

    table_02 = HTMLTables.table(GLOBAL_DF_01; editable=false)
    @test !occursin("contenteditable", table_02)

    table_03 = HTMLTables.table(GLOBAL_DF_01)
    @test !occursin("contenteditable", table_03)
end

@testset "disabled CSS" begin
    table_01 = HTMLTables.table(
        GLOBAL_DF_01;
        css=false,
        theme=["default", CSS_FILE_01, CSS_STRING_02],
        colorscale="Reds",
    )

    @test !occursin("<style>", table_01)

    table_02 = HTMLTables.table(
        GLOBAL_DF_01;
        css=false,
        theme=[:gold, CSS_FILE_02, CSS_STRING_01],
        colorscale="viridis",
    )

    @test !occursin("<style>", table_02)

    @test table_01 == table_02
end