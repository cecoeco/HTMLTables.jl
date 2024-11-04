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
        :dracula,
        :solarized,
    ]

    for theme in themes
        io_01::IO = IOBuffer()
        HTMLTables.writetable(io_01, GLOBAL_DF_01; theme=theme)
        table_01::String = String(Base.take!(io_01))
        Base.close(io_01)
        @test Base.occursin("<style>", table_01)

        io_02::IO = IOBuffer()
        HTMLTables.writetable(io_02, GLOBAL_DF_01; theme=string(theme))
        table_02::String = String(Base.take!(io_02))
        Base.close(io_02)
        @test Base.occursin("<style>", table_02)

        @test table_01 == table_02
    end
end

@testset "JavaScript file" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; js=JS_FILE_01)
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("<script>", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; js=JS_FILE_02)
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test Base.occursin("<script>", table_02)
end

@testset "JavaScript string" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; js=JS_STRING_01)
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("<script>", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; js=JS_STRING_02)
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test Base.occursin("<script>", table_02)
end

@testset "CSS file" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; css=CSS_FILE_01)
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("<style>", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; css=CSS_FILE_02)
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test Base.occursin("<style>", table_02)
end

@testset "CSS string" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; css=CSS_STRING_01)
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("<style>", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; css=CSS_STRING_02)
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test Base.occursin("<style>", table_02)
end

@testset "header" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; header=true)
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("<thead", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; header=false)
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test !Base.occursin("<thead", table_02)

    io_03::IO = IOBuffer()
    HTMLTables.writetable(io_03, GLOBAL_DF_01)
    table_03::String = String(Base.take!(io_03))
    Base.close(io_03)
    @test Base.occursin("<thead", table_03)
end

@testset "footer" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; footer=true)
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("<tfoot", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; footer=false)
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test !Base.occursin("<tfoot", table_02)

    io_03::IO = IOBuffer()
    HTMLTables.writetable(io_03, GLOBAL_DF_01)
    table_03::String = String(Base.take!(io_03))
    Base.close(io_03)
    @test Base.occursin("<tfoot", table_03)
end

@testset "id" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; id="table_01")
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("id=\"table_01\"", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; id="table_02")
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test Base.occursin("id=\"table_02\"", table_02)
end

@testset "class" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; class="table_01")
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("class=\"table_01\"", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; class="table_02")
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test Base.occursin("class=\"table_02\"", table_02)

    io_03::IO = IOBuffer()
    HTMLTables.writetable(io_03, GLOBAL_DF_01; class="table_01 table_02")
    table_03::String = String(Base.take!(io_03))
    Base.close(io_03)
    @test Base.occursin("class=\"table_01 table_02\"", table_03)

    io_04::IO = IOBuffer()
    HTMLTables.writetable(io_04, GLOBAL_DF_01; class="table_02 table_01")
    table_04::String = String(Base.take!(io_04))
    Base.close(io_04)
    @test Base.occursin("class=\"table_02 table_01\"", table_04)

    io_05::IO = IOBuffer()
    HTMLTables.writetable(io_05, GLOBAL_DF_01; class=["table_01", "table_02"])
    table_05::String = String(Base.take!(io_05))
    Base.close(io_05)
    @test Base.occursin("class=\"table_01 table_02\"", table_05)

    io_06::IO = IOBuffer()
    HTMLTables.writetable(io_06, GLOBAL_DF_01; class=["table_02", "table_01"])
    table_06::String = String(Base.take!(io_06))
    Base.close(io_06)
    @test Base.occursin("class=\"table_02 table_01\"", table_06)
end

@testset "caption" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; caption="Table 1")
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("<caption", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01)
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test !Base.occursin("<caption", table_02)
end

@testset "tooltips" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; tooltips=true)
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("title", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; tooltips=false)
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test !Base.occursin("title", table_02)

    io_03::IO = IOBuffer()
    HTMLTables.writetable(io_03, GLOBAL_DF_01)
    table_03::String = String(Base.take!(io_03))
    Base.close(io_03)
    @test Base.occursin("title", table_03)
end

@testset "editable" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; editable=true)
    table_01::String = String(Base.take!(io_01))
    Base.close(io_01)
    @test Base.occursin("contenteditable", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; editable=false)
    table_02::String = String(Base.take!(io_02))
    Base.close(io_02)
    @test !Base.occursin("contenteditable", table_02)

    io_03::IO = IOBuffer()
    HTMLTables.writetable(io_03, GLOBAL_DF_01)
    table_03::String = String(Base.take!(io_03))
    Base.close(io_03)
    @test !Base.occursin("contenteditable", table_03)
end

@testset "disabled CSS" begin
    io_01::IO = IOBuffer()
    HTMLTables.writetable(io_01, GLOBAL_DF_01; theme=nothing)
    table_01::String = String(Base.take!(io_01))
    @test !Base.occursin("<style>", table_01)

    io_02::IO = IOBuffer()
    HTMLTables.writetable(io_02, GLOBAL_DF_01; theme=nothing)
    table_02::String = String(Base.take!(io_02))
    @test !Base.occursin("<style>", table_02)

    @test table_01 == table_02
end