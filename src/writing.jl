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
    "gray" => "themes/09-gray.css",
    "julia" => "themes/10-julia.css",
    "sunstone" => "themes/11-sunstone.css",
    "moonstone" => "themes/12-moonstone.css"
)

function writestyle(theme::String; css::Bool=true)::String
    if theme == "" || !css
        return ""
    end

    main_css_path::String = ""
    main_css_dir::String = ""

    if Base.haskey(THEMES, theme)
        main_css_path *= Base.Filesystem.joinpath(@__DIR__, THEMES[theme])
        main_css_dir *= dirname(main_css_path)
    elseif Base.Filesystem.ispath(theme) && Base.Filesystem.isfile(theme)
        main_css_path *= theme
        main_css_dir *= Base.Filesystem.dirname(main_css_path)
    else
        Base.throw(Base.ArgumentError("$theme is not a valid theme or CSS file"))
    end

    css_string::String = Base.read(main_css_path, String)

    import_regex::Regex = r"@import\s+\"([^\"]+)\";"

    matches::Base.RegexMatchIterator = Base.eachmatch(import_regex, css_string)

    for match in matches
        import_path::String = match.captures[1]
        import_full_path::String = Base.Filesystem.joinpath(main_css_dir, import_path)
        import_content::String = Base.read(import_full_path, String)
        css_string = Base.replace(css_string, match.match => import_content)
    end

    return "<style>\n$css_string\n</style>\n"
end

writeid(id::String="")::String = id == "" ? "" : " id=\"$id\""

writeclasses(classes::String="")::String = classes == "" ? "" : " class=\"$classes\""

writecaption(caption::String="")::String = caption == "" ? "" : "<caption>$caption</caption>\n"

writetooltip(tooltips::Bool=true, cell_value="")::String = tooltips ? " title=\"$cell_value\"" : ""

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

function cellcolor(tbl; colorscale::String="", cell_value::Any, css::Bool=true)::String
    numbers::Vector{Number} = getnumbers(tbl)

    if colorscale == "" || Base.ismissing(cell_value) || !(cell_value in numbers) || !css
        return ""
    end

    colorscheme::ColorSchemes.ColorScheme = Base.getfield(ColorSchemes, Symbol(colorscale))

    cell_position::Float64 = (cell_value - Base.minimum(numbers)) / (Base.maximum(numbers) - Base.minimum(numbers))

    color::Colors.Colorant = ColorSchemes.get(colorscheme, cell_position)

    css_color::String = css_rgb(color)

    return " style=\"background-color: $css_color;\""
end

function writetbody(tbl; colorscale::String="", tooltips::Bool=true, css::Bool=true)::String
    tbody::String = "<tbody>\n"

    for row in Tables.rows(tbl)
        tbody *= "<tr>\n"

        for col in Base.names(tbl)
            cell_value = row[Base.Symbol(col)]

            cell::String = "<td"
            cell *= writetooltip(tooltips, cell_value)
            cell *= cellcolor(tbl, colorscale=colorscale, cell_value=cell_value, css=css)
            cell *= ">$cell_value</td>\n"

            tbody *= cell
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
    caption::String="",
    css::Bool=true,
    theme::String="default",
    colorscale="",
    tooltips::Bool=true
)::String
    if colorscale != ""
        if !Base.isa(Base.getfield(ColorSchemes, Symbol(colorscale)), ColorScheme)
            Base.throw(Base.ArgumentError("$colorscale is not a valid color scheme"))
        end
    end

    tbl = numeric_string_to_number.(tbl)

    html_table::String = ""
    html_table *= writecaption(caption)
    html_table *= writestyle(theme, css=css)
    html_table *= "<table$(writeid(id))$(writeclasses(classes))>\n"
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

    Base.println("HTML table saved as $html_table_path")

    return html_table_path
end

function npminstall(npm_packages::Vector{String})
    installed_packages::String = Base.read(`$(NodeJS_20_jll.npm) list --global --depth 0`, String)

    for npm_package in npm_packages
        if !Base.occursin(npm_package, installed_packages)
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

function converttable(
    tbl,
    output_format::String;
    filename::String="table",
    save_location::String=Base.Filesystem.pwd(),
    kwargs...
)
    if output_format == "jpg"
        js_file = "html2jpg.js"
        file_extension = ".jpg"
    elseif output_format == "pdf"
        js_file = "html2pdf.js"
        file_extension = ".pdf"
    elseif output_format == "png"
        js_file = "html2png.js"
        file_extension = ".png"
    else
        Base.error("Unsupported output format: $output_format")
    end

    html_table::String = table(tbl; kwargs...) |> escape_html_for_js

    file_path::String = Base.Filesystem.joinpath(save_location, "$filename$file_extension")

    js_path::String = Base.Filesystem.joinpath(@__DIR__, js_file)

    js_content::String = Base.read(js_path, String)
    
    embedded_js_content::String = "$js_content\nhtml2$output_format(\"$html_table\", \"$file_path\")"

    tempfile::String = "html2$output_format" * "_" * Base.string(Base.rand(1:10^10)) * ".js"
    embedded_js_path::String = Base.Filesystem.joinpath(save_location, tempfile)

    Base.open(embedded_js_path, "w") do file
        Base.write(file, embedded_js_content)
    end

    if output_format in ["jpg", "png"]
        npminstall(["fs", "puppeteer"])
    elseif output_format == "pdf"
        npminstall(["puppeteer"])
    end

    Base.run(`$(NodeJS_20_jll.node()) $embedded_js_path`)

    Base.rm(embedded_js_path)

    Base.println("HTML table saved as $file_path")

    return file_path
end

"""
    HTMLTables.jpg(tbl; kwargs...)
"""
jpg(tbl; kwargs...) = converttable(tbl, "jpg"; kwargs...)

"""
    HTMLTables.pdf(tbl; kwargs...)
"""
pdf(tbl; kwargs...) = converttable(tbl, "pdf"; kwargs...)

"""
    HTMLTables.png(tbl; kwargs...)
"""
png(tbl; kwargs...) = converttable(tbl, "png"; kwargs...)
