"""
# HTMLTables

Julia package for reading and writing HTML tables using the Tables.jl interface

## exported functions:

- `readtable`: reads an HTML table from into a sink function such as `DataFrame`.
- `writetable`: writes an HTML table to a file, url, io stream, or as a string.

"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, Tables

export readtable, writetable

include("themes.jl")

function isurl(source::String)::Bool
    return Base.startswith(source, r"^(http://|https://|ftp://)")
end

function ishtmlfile(source::String)::Bool
    return Base.Filesystem.splitext(source)[2] == ".html"
end

function extract_row_data(row::Gumbo.HTMLNode)::Vector
    cells::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("td,th"), row)

    return [Cascadia.nodeText(cell) for cell in cells]
end

"""
    readtable(
        source::Union{IO,String},
        sink::Function; 
        id::String="", 
        class::Union{String,Vector{String}}="",
        index::Int=1
    )

Reads a HTML table into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML table.
- `sink`: The function that materializes the table data.

## Keyword Arguments

- `id::String`: The id of the HTML table.
- `class::Union{String,Vector{String}}`: The class of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

## Returns

- `sink`: The sink function such as `DataFrame` with the HTML table data.

## Examples

reading an HTML table from a website into a DataFrame:

```julia
using HTMLTables, DataFrames

url::String = "https://www.w3schools.com/html/html_tables.asp"

df = HTMLTables.readtable(url, DataFrame, index=1)

println(df)
```

output:

```
6×3 DataFrame
 Row │ Company                       Contact           Country
     │ String                        String            String
─────┼─────────────────────────────────────────────────────────
   1 │ Alfreds Futterkiste           Maria Anders      Germany
   2 │ Centro comercial Moctezuma    Francisco Chang   Mexico
   3 │ Ernst Handel                  Roland Mendel     Austria
   4 │ Island Trading                Helen Bennett     UK
   5 │ Laughing Bacchus Winecellars  Yoshi Tannamuri   Canada
   6 │ Magazzini Alimentari Riuniti  Giovanni Rovelli  Italy
```

"""
function readtable(source, sink; id::String="", class="", index::Int=1)
    if isa(source, IO)
        source = Base.read(source, String)
    end

    html_content::String = ""
    if isurl(source) == true
        html_content *= Base.String(HTTP.get(source).body)
    elseif ishtmlfile(source) == true
        html_content *= Base.read(source, String)
    else
        html_content *= source
    end

    html_document::Gumbo.HTMLDocument = Gumbo.parsehtml(html_content)

    selector::String = ""
    if Base.isempty(id)
        if Base.isempty(class)
            selector *= "table"
        elseif !Base.isempty(class) && Base.isa(class, String)
            selector *= "table.$class"
        elseif !Base.isempty(class) && Base.isa(class, Vector{String})
            selector *= "table." * Base.join(class, ".")
        end
    elseif !Base.isempty(id)
        selector *= "#$id"
    end

    tables::Vector{Gumbo.HTMLNode} = Base.eachmatch(
        Cascadia.Selector(selector), html_document.root
    )

    table::Gumbo.HTMLNode = tables[index]

    rows::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("tr"), table)

    headers::Vector = []

    data::Vector{Vector} = []

    for (i, row) in Base.enumerate(rows)
        rowdata = extract_row_data(row)
        if (i == 1 && Base.isempty(headers)) == true
            headers = rowdata
        else
            Base.push!(data, rowdata)
        end
    end

    tuples::Vector = [Base.Tuple(row) for row in data]

    return sink(tuples, headers)
end

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

function iscssfile(file::String)::Bool
    if file == ""
        return false
    end

    return Base.splitext(file)[end] == ".css"
end

function writestyle(file::String; css::Bool)::String
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

function writestyle(files::Vector; css::Bool)::String
    if files == [] || !css
        return ""
    end

    table_css::String = ""
    for file in files
        table_css *= Base.read(file, String)
    end

    return """<style>\n$table_css\n</style>\n"""
end

function writeid(id::String)::String
    if id == ""
        return ""
    else
        return " id=\"$id\""
    end
end

function writeclass(class::String)::String
    if class == ""
        return ""
    else
        return " class=\"$class\""
    end
end

function writeclass(class::Vector)::String
    if class == []
        return ""
    else
        return " class=\"" * Base.join(class, " ") * "\""
    end
end

function writeclass(class::Tuple{String})::String
    if class == ()
        return ""
    else
        return " class=\"" * Base.join(class, " ") * "\""
    end
end

function writecaption(caption::String)::String
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

function cellcolor(tbl; colorscale::String, cell_value, css::Bool=true)::String
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
    tbl; colorscale::String="", tooltips::Bool, css::Bool, editable::Bool
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

"""  
    writetable(
        out,
        tbl;
        header::Bool=true,
        footer::Bool=true,
        id::String="",
        class::Union{String,Vector}="",
        caption::String="",
        css::Bool=true,
        editable::Bool=false,
        theme::Union{Symbol,String,Vector}=:default,
        colorscale::String="",
        tooltips::Bool=true)::String

Uses the Tables.jl interface to write an HTML table.

## Arguments

- `out`: nothing, filepath, string or IO stream.
- `tbl`: The table to write.

## Keyword Arguments

- `header`: Whether to include the table header.
- `footer`: Whether to include the table footer.
- `id`: The id of the HTML table.
- `class`: The class of the HTML table.
- `caption`: The caption of the HTML table.
- `css`: Whether to include the CSS styles.
- `editable`: Whether to enable table editing.
- `theme`: The theme of the HTML table.
- `colorscale`: The colorscale of the HTML table.
- `tooltips`: Whether to include tooltips.

"""
function writetable(
    out,
    tbl;
    header::Bool=true,
    footer::Bool=true,
    id::String="",
    class::Union{String,Vector}="",
    caption::String="",
    css::Bool=true,
    editable::Bool=false,
    theme::Union{Symbol,String,Vector}=:default,
    colorscale::String="",
    tooltips::Bool=true,
)
    html_table::String = ""

    html_table *= writestyle(theme; css=css)
    html_table *= "<table$(writeid(id))$(writeclass(class))>\n"
    html_table *= writecaption(caption)
    html_table *= writethead(tbl; header=header, editable=editable)
    html_table *= writetbody(
        tbl; colorscale=colorscale, tooltips=tooltips, css=css, editable=editable
    )
    html_table *= writetfoot(tbl; footer=footer, editable=editable)
    html_table *= "</table>"

    if !Base.isnothing(out)
        Base.Filesystem.write(out, html_table)

        return nothing
    else
        return html_table
    end
end

function writetable(
    tbl;
    header::Bool=true,
    footer::Bool=true,
    id::String="",
    class::Union{String,Vector}="",
    caption::String="",
    css::Bool=true,
    editable::Bool=false,
    theme::Union{Symbol,String,Vector}=:default,
    colorscale::String="",
    tooltips::Bool=true,
)
    return writetable(
        nothing,
        tbl;
        header=header,
        footer=footer,
        id=id,
        class=class,
        caption=caption,
        css=css,
        editable=editable,
        theme=theme,
        colorscale=colorscale,
        tooltips=tooltips,
    )
end

end
