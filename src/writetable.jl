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

function isjsfile(file::String)::Bool
    if Base.isempty(file)
        return false
    end

    return Base.splitext(file)[end] == ".js"
end

function writescript(js::String)::String
    if Base.isempty(js)
        return ""
    end

    if isjsfile(js)
        js::String = Base.read(js, String)
    end

    return """<script>\n$js\n</script>\n"""
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

function cellcolor(tbl; colorscale::Union{String,Symbol}, cell_value, styles::Bool)::String
    numbers::Vector{Number} = getnumbers(tbl)

    if colorscale == "" || Base.ismissing(cell_value) || !(cell_value in numbers) || !styles
        return ""
    end

    colorscheme::ColorSchemes.ColorScheme = Base.getfield(ColorSchemes, Symbol(colorscale))

    cell_position::Float64 = /(
        cell_value - Base.minimum(numbers), Base.maximum(numbers) - Base.minimum(numbers)
    )

    return " style=\"background-color: $(css_rgb(ColorSchemes.get(colorscheme, cell_position)));\""
end

function writetbody(
    tbl; colorscale::Union{String,Symbol}, tooltips::Bool, styles::Bool, editable::Bool
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
        js::String="",
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
- `js::String`: the JavaScript to include.
- `styles::Bool`: whether to include the CSS. If false `css`, `theme` and `colorscale` are ignored.
- `css::String`: the path to the CSS file to include.
- `theme::Union{Symbol,String}`: the theme of the HTML table.
- `colorscale::Union{Symbol,String}`: the colorscale from [ColorSchemes.jl](https://juliagraphics.github.io/ColorSchemes.jl/stable/catalogue/) for numeric data.

## Examples

creates a simple HTML table from a DataFrame and writes it to the standard output:

```julia
using HTMLTables, DataFrames

df = DataFrame(x=[1, 2, 3], y=[45, 67, 89])

writetable(stdout, df, styles=false)
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

writetable("table.html", df)
```

"""
function writetable(
    out::Any,
    tbl::Any;
    header::Bool=true,
    footer::Bool=true,
    id::String="",
    class::Union{String,Vector{String}}="",
    caption::String="",
    editable::Bool=false,
    tooltips::Bool=true,
    js::String="",
    styles::Bool=true,
    css::String="",
    theme::Union{String,Symbol}=:default,
    colorscale::Union{String,Symbol}="",
)
    html_table::String = ""
    html_table *= writescript(js)
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
