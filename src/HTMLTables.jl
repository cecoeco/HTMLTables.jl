"""
# HTMLTables

Julia package for reading and writing HTML tables using the Tables.jl interface

## exported functions:

- `HTMLTables.readtable`: reads an HTML table into a Julia table such as a `DataFrame`.
- `HTMLTables.writetable`: converts a Julia table to an HTML table and writes it to a file or IO stream.

"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, Tables

export readtable, writetable

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
        source,
        sink; 
        id::String="", 
        class::Union{String,Vector{String}}="",
        index::Int=1
    )

Reads an HTML table into a sink function such as `DataFrame`.

## Arguments

- `source`: URL or path to the HTML table.
- `sink`: the function that materializes the table data.

## Keyword Arguments

- `id::String`: the id of the HTML table in the HTML document.
- `class::Union{String,Vector{String}}`: the class of the HTML table.
- `index::Int`: the index of the HTML table in the HTML document.

## Returns

- `sink`: the sink function such as `DataFrame` with the HTML table data.

## Examples

reading an HTML table from a website into a DataFrame:

```julia
using HTMLTables, DataFrames

url = "https://www.w3schools.com/html/html_tables.asp"

df = HTMLTables.readtable(url, DataFrame)

println(df)
```

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

reading the second HTML table from a file into a DataFrame:

```julia
using HTMLTables, DataFrames

url = "tables.html"

df = HTMLTables.readtable(url, DataFrame, index=2)

println(df)
```

```
4×2 DataFrame
 Row │ Name       Age
     │ String     Int64
─────┼─────────────────
   1 │ Bob         25
   2 │ Charlie     35
   3 │ Alice       30
   4 │ David       40
```

reading an HTML table with id="Table" from a string into a DataFrame:

```julia
using HTMLTables, DataFrames

html_str = \"\"\"
<table id="Table">
  <tr>
    <th>Name</th>
    <th>Age</th>
  </tr>
  <tr>
    <td>Bob</td>
    <td>25</td>
  </tr>
  <tr>
    <td>Charlie</td>
    <td>35</td>
  </tr>
  <tr>
    <td>Alice</td>
    <td>30</td>
  </tr>
  <tr>
    <td>David</td>
    <td>40</td>
  </tr>
</table>
\"\"\"

df = HTMLTables.readtable(html_str, DataFrame, id="myTable")

println(df)
```

```
4×2 DataFrame
 Row │ Name       Age
     │ String     Int64
─────┼─────────────────
   1 │ Bob         25
   2 │ Charlie     35
   3 │ Alice       30
   4 │ David       40
```
  
"""
function readtable(
    source, sink; id::String="", class::Union{String,Vector{String}}="", index::Int=1
)
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

include("themes.jl")

function writetheme(theme::Symbol; styles::Bool)::String
    if theme == "" || !styles
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
        :dracula => DRACULA,
        :solarized => SOLARIZED,
    )

    if Base.haskey(theme_dictionary, theme)
        theme = theme_dictionary[theme]
    else
        Base.throw(Base.ArgumentError("$(theme) is not a valid theme"))
    end

    return """<style>\n$theme\n</style>\n"""
end

function writetheme(theme::String; styles::Bool)::String
    return writetheme(Symbol(theme); styles=styles)
end

function iscssfile(file::String)::Bool
    if Base.isempty(file)
        return false
    end

    return Base.splitext(file)[end] == ".css"
end

function writestyle(css::String; styles::Bool)::String
    if Base.isempty(css) || !styles
        return ""
    end

    if iscssfile(css)
        css::String = Base.read(css, String)
    end

    return """<style>\n$css\n</style>\n"""
end

function writeid(id::String)::String
    if Base.isempty(id)
        return ""
    else
        return " id=\"$id\""
    end
end

function writeclass(class::String)::String
    if Base.isempty(class)
        return ""
    else
        return " class=\"$class\""
    end
end

function writeclass(class::Vector)::String
    if Base.isempty(class)
        return ""
    else
        return " class=\"" * Base.join(class, " ") * "\""
    end
end

function writecaption(caption::String)::String
    if Base.isempty(caption)
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

function cellcolor(tbl; colorscale::String, cell_value, styles::Bool)::String
    numbers::Vector{Number} = getnumbers(tbl)

    if colorscale == "" || Base.ismissing(cell_value) || !(cell_value in numbers) || !styles
        return ""
    end

    colorscheme::ColorSchemes.ColorScheme = Base.getfield(ColorSchemes, Symbol(colorscale))

    cell_position::Float64 = Base.div(
        (cell_value - Base.minimum(numbers)),
        (Base.maximum(numbers) - Base.minimum(numbers)),
    )

    return " style=\"background-color: $(css_rgb(ColorSchemes.get(colorscheme, cell_position)));\""
end

function writetbody(
    tbl; colorscale::String, tooltips::Bool, styles::Bool, editable::Bool
)::String
    contenteditable::String = ""
    if editable
        contenteditable *= " contenteditable=\"true\""
    else
        contenteditable *= ""
    end

    tbody::String = "<tbody$contenteditable>\n"

    for row in Tables.rows(tbl)
        tbody *= "<tr$contenteditable>\n"

        for col in Base.names(tbl)
            cell_value = row[Base.Symbol(col)]

            cell::String = ""
            cell *= "<td$contenteditable"
            cell *= writetooltip(tooltips, cell_value)
            cell *= cellcolor(
                tbl; colorscale=colorscale, cell_value=cell_value, styles=styles
            )
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

    tfoot::String = "<tfoot$contenteditable>\n<tr>\n"

    for _ in Base.names(tbl)
        tfoot *= "<td$contenteditable></td>\n"
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
        class::Union{String,Vector{String}}="",
        caption::String="",
        editable::Bool=false,
        tooltips::Bool=true,
        styles::Bool=true,
        css::String="",
        theme::Union{String,Symbol}=:default,
        colorscale::Union{String,Symbol}=""
    )

Uses the Tables.jl interface to write an HTML table.

## Arguments

- `out`: accepts the same types as [`Base.write`](https://docs.julialang.org/en/v1/base/io-network/#Base.write). 
- `tbl`: the table to write.

## Keyword Arguments

- `header::Bool`: whether to include the table header.
- `footer::Bool`: whether to include the table footer.
- `id::String`: the id of the HTML table.
- `class::Union{String,Vector{String}}`: the class of the HTML table.
- `caption::String`: the caption of the HTML table.
- `editable::Bool`: whether to enable table editing.
- `tooltips::Bool`: whether to include tooltips.
- `styles::Bool`: whether to include the CSS. If false `css`, `theme` and `colorscale` are ignored.
- `css::String`: the path to the CSS file to include.
- `theme::Union{Symbol,String}`: the theme of the HTML table.
- `colorscale::Union{Symbol,String}`: the colorscale of the HTML table.

## Examples

creates a simple HTML table from a DataFrame and writes it to the standard output:

```julia
using HTMLTables, DataFrames

df = DataFrame(x=[1, 2, 3], y=[45, 67, 89])

HTMLTables.writetable(stdout, df, styles=false)
```

```html
<table>
<thead>
<tr>
<td>x</td>
<td>y</td>
</tr>
</thead>
<tbody>
<tr>
<td title="1">1</td>
<td title="45">45</td>
</tr>
<tr>
<td title="2">2</td>
<td title="67">67</td>
</tr>
<tr>
<td title="3">3</td>
<td title="89">89</td>
</tr>
</tbody>
<tfoot>
<tr>
<td></td>
<td></td>
</tr>
</tfoot>
</table>
```

creates a simple HTML table from a DataFrame and writes it to a file:

```julia
using HTMLTables, DataFrames

df = DataFrame(x=[1, 2, 3], y=[4, 11, 28])

HTMLTables.writetable("table.html", df)
```

"""
function writetable(
    out,
    tbl;
    header::Bool=true,
    footer::Bool=true,
    id::String="",
    class::Union{String,Vector{String}}="",
    caption::String="",
    editable::Bool=false,
    tooltips::Bool=true,
    styles::Bool=true,
    css::String="",
    theme::Union{String,Symbol}=:default,
    colorscale::Union{String,Symbol}="",
)
    html_table::String = ""
    html_table *= writetheme(theme; styles=styles)
    html_table *= writestyle(css; styles=styles)
    html_table *= "<table$(writeid(id))$(writeclass(class))>\n"
    html_table *= writecaption(caption)
    html_table *= writethead(tbl; header=header, editable=editable)
    html_table *= writetbody(
        tbl; colorscale=colorscale, tooltips=tooltips, styles=styles, editable=editable
    )
    html_table *= writetfoot(tbl; footer=footer, editable=editable)
    html_table *= "</table>"

    Base.write(out, html_table)

    return nothing
end

end
