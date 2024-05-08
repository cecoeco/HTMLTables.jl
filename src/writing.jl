const THEMES::Dict{String,String} = Base.Dict(
    "default" => "themes/00-default.css",
    "red" => "themes/01-red.css",
    "orange" => "themes/02-orange.css",
    "yellow" => "themes/03-yellow.css",
    "green" => "themes/04-green.css",
    "blue" => "themes/05-blue.css",
    "violet" => "themes/06-violet.css",
    "magenta" => "themes/07-magenta.css",
    "brown" => "themes/08-brown.css",
    "gray" => "themes/09-gray.css"
)

function writestyle(theme::String; css::Bool=true)::String
    if theme == "" || !css
        return ""
    end

    if Base.haskey(THEMES, theme)
        theme_path::String = Base.Filesystem.joinpath(@__DIR__, THEMES[theme])
        css_string::String = Base.read(theme_path, String)

        return "<style>\n$css_string\n</style>\n"
    elseif Base.Filesystem.ispath(theme) && Base.Filesystem.isfile(theme)
        css_string = Base.read(theme, String)

        return "<style>\n$css_string\n</style>\n"
    else
        Base.throw(Base.ArgumentError("$theme is not a valid theme or CSS file."))
    end
end

function writeid(id::String="")::String
    if id == ""
        return ""
    end

    return "id=\"$id\""
end

function writeclasses(classes::String)::String
    if classes == ""
        return ""
    end

    return "class=\"$classes\""
end

function writethead(tbl; header::Bool=true)::String
    if !header
        return ""
    end

    thead::String = "<thead>\n<tr>\n"

    for col in Base.names(tbl)
        thead *= "<td>$col</td>\n"
    end

    thead *= "</tr>\n</thead>\n"

    return thead
end

function getnumbers(tbl)
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

function toCSSrgb(color::Colors.Colorant)::String
    r::Float64 = Colors.red(color)
    g::Float64 = Colors.green(color)
    b::Float64 = Colors.blue(color)

    r_int::Int = Base.round(Int, r * 255)
    g_int::Int = Base.round(Int, g * 255)
    b_int::Int = Base.round(Int, b * 255)

    r_string::String = Base.string(r_int)
    g_string::String = Base.string(g_int)
    b_string::String = Base.string(b_int)

    return "rgb(" * Base.join([r_string, g_string, b_string], ",") * ")"

end

function cellcolor(tbl; colorscale::String="", cell_value, css::Bool=true)::String
    if colorscale == "" && !Base.isa(cell_value, Number) || !css
        return ""
    end

    colors::ColorSchemes.ColorScheme = Base.getfield(ColorSchemes, Base.Symbol(colorscale))

    numbers::Vector{Float64} = getnumbers(tbl)

    min_num::Float64 = Base.minimum(numbers)
    max_num::Float64 = Base.maximum(numbers)

    normalized_value::Float64 = (cell_value - min_num) / (max_num - min_num)

    color_index = normalized_value * (Base.length(colors) - 1) + 1
    color_index = Base.ceil(Int, color_index)
    color_index = Base.min(Base.max(color_index, 1), Base.length(colors))

    julia_color::Colors.Colorant = colors[color_index]
    css_color::String = toCSSrgb(julia_color)

    return "style=\"background-color: $css_color;\""
end

function writetbody(tbl; colorscale::String="", tooltips::Bool=true, css::Bool=true)::String
    tbody::String = "<tbody>\n"

    for row in Tables.rows(tbl)
        tbody *= "<tr>\n"

        for col in Base.names(tbl)
            cell_value = row[Base.Symbol(col)]
            cell_value = numeric_string_to_number(cell_value)

            if tooltips
                title_attribute = " title=\"$cell_value\""
            else
                title_attribute = ""
            end

            cell_color = cellcolor(tbl, colorscale=colorscale, cell_value=cell_value, css=css)

            tbody *= "<td$title_attribute $cell_color>$cell_value</td>\n"
        end

        tbody *= "</tr>\n"
    end

    tbody *= "</tbody>\n"

    return tbody
end

function writetfoot(tbl; footer::Bool=true)::String
    if !footer
        return ""
    end

    tfoot::String = "<tfoot>\n<tr>\n"

    for _ in Base.names(tbl)
        tfoot *= "<td></td>\n"
    end

    tfoot *= "</tr>\n</tfoot>\n"

    return tfoot
end

function numeric_string_to_number(i)
    try
        parsed = Base.parse(Float64, i)
        if parsed == Base.floor(parsed)
            return Base.Int(parsed)
        else
            return parsed
        end
    catch
        return i
    end
end

"""
    HTMLTables.table(
        tbl;
        header::Bool=true,
        footer::Bool=true,
        id::String="",
        classes::String="",
        css::Bool=true,
        theme::String="default",
        colorscale="",
        tooltips::Bool=true
    )

Returns a julia table as an HTML table.

## Arguments

- `tbl`: The table to write.
- `filename`: The filename of the HTML table.
- `save_location`: The location to save the HTML table.
- `header`: Whether to include the table header.
- `footer`: Whether to include the table footer.
- `id`: The id of the HTML table.
- `classes`: The classes of the HTML table.
- `css`: Whether to include the CSS styles.
- `theme`: The theme of the HTML table.
- `colorscale`: The colorscale of the HTML table.
- `tooltips`: Whether to include tooltips.

"""
function table(
    tbl;
    header::Bool=true,
    footer::Bool=true,
    id::String="",
    classes::String="",
    css::Bool=true,
    theme::String="default",
    colorscale="",
    tooltips::Bool=true
)
    html_table::String = ""

    html_table *= writestyle(theme, css=css)

    html_table *= "<table"

    html_table *= " " * writeid(id)

    html_table *= " " * writeclasses(classes)

    html_table *= ">\n"

    html_table *= writethead(tbl, header=header)

    html_table *= writetbody(tbl, colorscale=colorscale, tooltips=tooltips, css=css)

    html_table *= writetfoot(tbl, footer=footer)

    html_table *= "</table>"

    return html_table
end

"""
    HTMLTables.write(
        tbl;
        filename::String="table",
        save_location::String=Base.Filesystem.pwd(),
        kwargs...
    )

Writes a julia table as an HTML table to an HTML file.

## Arguments

- `tbl`: The table to write.
- `filename`: The filename of the HTML table.
- `save_location`: The location to save the HTML table.
- `header`: Whether to include the table header.
- `footer`: Whether to include the table footer.
- `id`: The id of the HTML table.
- `classes`: The classes of the HTML table.
- `css`: Whether to include the CSS styles.
- `theme`: The theme of the HTML table.
- `colorscale`: The colorscale of the HTML table.
- `tooltips`: Whether to include tooltips.

## Returns

- `path`: The path to the HTML file.

"""
function write(
    tbl;
    filename::String="table",
    save_location::String=Base.Filesystem.pwd(),
    kwargs...
)
    html_table_content::String = table(tbl; kwargs...)

    html_table_path::String = Base.Filesystem.joinpath(save_location, "$filename.html")

    Base.open(html_table_path, "w") do io
        Base.write(io, html_table_content)
    end

    return html_table_path
end

function npminstall(npm_packages::Vector{String})
    for npm_package in npm_packages
        try
            Base.run(`$(NodeJS_20_jll.npm) list --global $npm_package`)
        catch
            Base.run(`$(NodeJS_20_jll.npm) install --global $npm_package`)
        end
    end
end

function escape_html_for_js(html::String)::String
    replacements::Dict{Char,String} = Base.Dict(
        '\\' => "\\\\",
        '"' => "\\\"",
        '\'' => "\\'",
        '\n' => "\\n",
        '\r' => "\\r",
        '\t' => "\\t",
        '\b' => "\\b",
        '\f' => "\\f"
    )

    return Base.join(Base.get(replacements, c, c) for c in html)
end

function jpg(
    tbl;
    filename::String="table",
    save_location::String=Base.Filesystem.pwd(),
    kwargs...
)
    html_table::String = table(tbl; kwargs...) |> escape_html_for_js

    jpg_path::String = Base.Filesystem.joinpath(save_location, "$filename.jpg")

    jpg_js_path::String = Base.Filesystem.joinpath(@__DIR__, "html2jpg.js")

    jpg_js_content::String = Base.read(jpg_js_path, String)

    embedded_js_content::String = """$jpg_js_content\nhtml2jpg("$html_table", "$jpg_path")"""

    tempfile::String = Base.string("html2jpg_", Base.rand(1:10000000000), ".js")
    embedded_js_path::String = Base.Filesystem.joinpath(save_location, tempfile)

    Base.open(embedded_js_path, "w") do file
        Base.write(file, embedded_js_content)
    end

    npminstall(["fs", "puppeteer"])

    Base.run(`$(NodeJS_20_jll.node()) $embedded_js_path`)

    Base.rm(embedded_js_path)

    return jpg_path
end

function pdf(
    tbl;
    filename::String="table",
    save_location::String=Base.Filesystem.pwd(),
    kwargs...
)
    html_table::String = table(tbl; kwargs...) |> escape_html_for_js

    pdf_path::String = Base.Filesystem.joinpath(save_location, "$filename.pdf")

    pdf_js_path::String = Base.Filesystem.joinpath(@__DIR__, "html2pdf.js")

    pdf_js_content::String = Base.read(pdf_js_path, String)

    embedded_js_content::String = """$pdf_js_content\nhtml2pdf("$html_table", "$pdf_path")"""

    tempfile::String = Base.string("html2pdf_", Base.rand(1:10000000000), ".js")
    embedded_js_path::String = Base.Filesystem.joinpath(save_location, tempfile)

    Base.open(embedded_js_path, "w") do file
        Base.write(file, embedded_js_content)
    end

    npminstall(["puppeteer"])

    Base.run(`$(NodeJS_20_jll.node()) $embedded_js_path`)

    Base.rm(embedded_js_path)

    return pdf_path
end

function png(
    tbl;
    filename::String="table",
    save_location::String=Base.Filesystem.pwd(),
    kwargs...
)
    html_table::String = table(tbl; kwargs...) |> escape_html_for_js

    png_path::String = Base.Filesystem.joinpath(save_location, "$filename.png")

    png_js_path::String = Base.Filesystem.joinpath(@__DIR__, "html2png.js")

    png_js_content::String = Base.read(png_js_path, String)

    embedded_js_content::String = """$png_js_content\nhtml2png("$html_table", "$png_path")"""

    tempfile::String = Base.string("html2png_", Base.rand(1:10000000000), ".js")
    embedded_js_path::String = Base.Filesystem.joinpath(save_location, tempfile)

    Base.open(embedded_js_path, "w") do file
        Base.write(file, embedded_js_content)
    end

    npminstall(["fs", "puppeteer"])

    Base.run(`$(NodeJS_20_jll.node()) $embedded_js_path`)

    Base.rm(embedded_js_path)

    return png_path
end
