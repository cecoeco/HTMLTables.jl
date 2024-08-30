include("themes.jl")

function writestyle(theme::Symbol; css::Bool)::String
    if theme == "" || !css
        return ""
    end

    theme_dictionary::Dict{Symbol,String} = Base.Dict(
        :default => DEFAULT,
        :red => RED,
        :orange => ORANGE,
        :yellow => YELLOW,
        :green => GREEN,
        :blue => BLUE,
        :violet => VIOLET,
        :magenta => MAGENTA,
        :brown => BROWN,
        :gray => GRAY,
        :black => BLACK,
        :gold => GOLD,
        :silver => SILVER,
        :bronze => BRONZE,
        :julia => JULIA,
        :sunstone => SUNSTONE,
        :moonstone => MOONSTONE,
    )

    if Base.haskey(theme_dictionary, theme)
        theme = theme_dictionary[theme]
    else
        Base.throw(Base.ArgumentError("$(theme) is not a valid theme"))
    end

    return """<style>\n$theme\n</style>\n"""
end

function iscssfile(file::AbstractString)::Bool
    if file == ""
        return false
    end

    return Base.splitext(file)[end] == ".css"
end

function writestyle(file::AbstractString; css::Bool)::String
    if file == "" || !css
        return ""
    end

    if file in [
        "default",
        "red",
        "orange",
        "yellow",
        "green",
        "blue",
        "violet",
        "magenta",
        "brown",
        "gray",
        "black",
        "gold",
        "silver",
        "bronze",
        "julia",
        "sunstone",
        "moonstone",
    ]
        return writestyle(Symbol(file); css=css)
    end

    if iscssfile(file)
        file::String = Base.read(file, String)
    else
        nothing
    end

    return """<style>\n$file\n</style>\n"""
end

function writestyle(files::AbstractVector; css::Bool)::String
    if files == [] || !css
        return ""
    end

    table_css::String = ""
    for file in files
        table_css *= Base.read(file, String)
    end

    return """<style>\n$table_css\n</style>\n"""
end

function writeid(id::AbstractString)::String
    if id == ""
        return ""
    else
        return " id=\"$id\""
    end
end

function writeclasses(classes::AbstractString)::String
    if classes == ""
        return ""
    else
        return " class=\"$classes\""
    end
end

function writeclasses(classes::AbstractVector)::String
    if classes == []
        return ""
    else
        return " class=\"" * Base.join(classes, " ") * "\""
    end
end

function writeclasses(classes::Tuple{AbstractString})::String
    if classes == ()
        return ""
    else
        return " class=\"" * Base.join(classes, " ") * "\""
    end
end

function writecaption(caption::AbstractString)::String
    if caption == ""
        return ""
    else
        return "<caption>$caption</caption>\n"
    end
end

function writetooltip(tooltips::Bool, cell_value)::String
    if tooltips
        return " title=\"$cell_value\""
    else
        return ""
    end
end

function writethead(tbl; header::Bool, editable::Bool)::String
    if !header
        return ""
    end

    contenteditable::String = ""
    if editable
        contenteditable *= " contenteditable=\"true\""
    else
        contenteditable *= ""
    end

    thead::String = "<thead$contenteditable>\n<tr>\n"

    for col in Base.names(tbl)
        thead *= "<td$contenteditable>$col</td>\n"
    end

    thead *= "</tr>\n</thead>\n"

    return thead
end

function getnumbers(tbl)::Vector{Float64}
    numbers::Vector{Float64} = Float64[]

    for col in Base.names(tbl)
        for val in tbl[!, col]
            if Base.isa(val, Number)
                Base.push!(numbers, val)
            end
        end
    end

    return numbers
end

function css_rgb(color::Colors.Colorant)::String
    r::Float64 = Colors.red(color) * 255
    g::Float64 = Colors.green(color) * 255
    b::Float64 = Colors.blue(color) * 255

    return "rgb(" * Base.join(["$r", "$g", "$b"], ",") * ")"
end

function cellcolor(tbl; colorscale::AbstractString, cell_value, css::Bool=true)::String
    numbers::Vector{Number} = getnumbers(tbl)

    if colorscale == "" || Base.ismissing(cell_value) || !(cell_value in numbers) || !css
        return ""
    end

    colorscheme::ColorSchemes.ColorScheme = Base.getfield(
        ColorSchemes, Symbol(colorscale)
    )

    cell_position::Float64 =
        (cell_value - Base.minimum(numbers)) /
        (Base.maximum(numbers) - Base.minimum(numbers))

    color::Colors.Colorant = ColorSchemes.get(colorscheme, cell_position)

    css_color::String = css_rgb(color)

    return " style=\"background-color: $css_color;\""
end

function writetbody(
    tbl; colorscale::AbstractString="", tooltips::Bool, css::Bool, editable::Bool
)::String
    contenteditable::String = ""
    if editable
        contenteditable *= " contenteditable=\"true\""
    else
        contenteditable *= ""
    end

    tbody::String = "<tbody $contenteditable>\n"

    for row in Tables.rows(tbl)
        tbody *= "<tr $contenteditable>\n"

        for col in Base.names(tbl)
            cell_value = row[Base.Symbol(col)]

            cell::String = ""
            cell *= "<td $contenteditable"
            cell *= writetooltip(tooltips, cell_value)
            cell *= cellcolor(tbl; colorscale=colorscale, cell_value=cell_value, css=css)
            cell *= ">$cell_value</td>\n"

            tbody *= cell
        end

        tbody *= "</tr>\n"
    end

    tbody *= "</tbody>\n"

    return tbody
end

function writetfoot(tbl; footer::Bool, editable::Bool)::String
    if !footer
        return ""
    end

    contenteditable::String = ""
    if editable
        contenteditable *= " contenteditable=\"true\""
    else
        contenteditable *= ""
    end

    tfoot::String = "<tfoot $contenteditable>\n<tr>\n"

    for _ in Base.names(tbl)
        tfoot *= "<td $contenteditable></td>\n"
    end

    tfoot *= "</tr>\n</tfoot>\n"

    return tfoot
end

function numeric_string_to_number(cell_value)
    try
        parsed = Base.parse(Float64, cell_value)
        if parsed == Base.floor(parsed)
            return Base.Int(parsed)
        else
            return parsed
        end
    catch
        return cell_value
    end
end

"""
    HTMLTables.table(
        tbl;
        header::Bool=true,
        footer::Bool=true,
        id::AbstractString="",
        classes::Union{AbstractString,AbstractVector}="",
        caption::AbstractString="",
        css::Bool=true,
        editable::Bool=false,
        theme::Union{Symbol,AbstractString,AbstractVector}="default",
        colorscale="",
        tooltips::Bool=true
    )

Returns a julia table as an HTML table.

## Argument

- `tbl`: The table to write.

## Keyword Arguments

- `header`: Whether to include the table header.
- `footer`: Whether to include the table footer.
- `id`: The id of the HTML table.
- `classes`: The classes of the HTML table.
- `caption`: The caption of the HTML table.
- `css`: Whether to include the CSS styles.
- `editable`: Whether to enable table editing.
- `theme`: The theme of the HTML table.
- `colorscale`: The colorscale of the HTML table.
- `tooltips`: Whether to include tooltips.

## Returns

- `html_table`: A string containing the HTML table.

## Examples

```julia
using DataFrames, HTMLTables

df = DataFrame(x=1:10, y=1:10)

html = HTMLTables.table(df)

println(html)
```

"""
function table(
    tbl;
    header::Bool=true,
    footer::Bool=true,
    id::AbstractString="",
    classes::Union{AbstractString,AbstractVector}="",
    caption::AbstractString="",
    css::Bool=true,
    editable::Bool=false,
    theme::Union{Symbol,AbstractString,AbstractVector}=:default,
    colorscale::AbstractString="",
    tooltips::Bool=true,
)::String
    if colorscale != ""
        if !Base.isa(Base.getfield(ColorSchemes, Symbol(colorscale)), ColorScheme)
            Base.throw(Base.ArgumentError("$colorscale is not a valid color scheme"))
        end
    end

    tbl = numeric_string_to_number.(tbl)

    html_table::String = ""
    html_table *= writestyle(theme; css=css)
    html_table *= "<table$(writeid(id))$(writeclasses(classes))>\n"
    html_table *= writecaption(caption)
    html_table *= writethead(tbl; header=header, editable=editable)
    html_table *= writetbody(
        tbl; colorscale=colorscale, tooltips=tooltips, css=css, editable=editable
    )
    html_table *= writetfoot(tbl; footer=footer, editable=editable)
    html_table *= "</table>"

    return html_table
end

"""
    HTMLTables.write(out, tbl; kwargs...)::String

Writes a julia table as an HTML table.

## Arguments

- `out`: The path to the HTML file or `IO`.
- `tbl`: The table to write.

## Keyword Arguments

- `header`: Whether to include the table header.
- `footer`: Whether to include the table footer.
- `id`: The id of the HTML table.
- `classes`: The classes of the HTML table.
- `caption`: The caption of the HTML table.
- `css`: Whether to include the CSS styles.
- `editable`: Whether to enable table editing.
- `theme`: The theme of the HTML table.
- `colorscale`: The colorscale of the HTML table.
- `tooltips`: Whether to include tooltips.

## Returns

- `path`: The path to the HTML file.

## Examples

```julia
using DataFrames, HTMLTables

df = DataFrame(x=1:10, y=1:10)

HTMLTables.write("table.html", df)
```

"""
function write(out, tbl; kwargs...)::String
    Base.Filesystem.write(out, table(tbl; kwargs...))

    Base.println("HTML table saved as $out")

    return out
end
