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
        :julia => JULIA,
        :sunstone => SUNSTONE,
        :moonstone => MOONSTONE
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

    if file in ["default", "red", "orange", "yellow", "green", "blue", "violet", "magenta", "brown", "gray", "black", "julia", "sunstone", "moonstone"]
        file = Symbol(file)
        return writestyle(file, css=css)
    end

    if iscssfile(file)
        file = Base.read(file, String)
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

function writeclasses(classes::Vector{AbstractString})::String
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

    colorscheme::ColorSchemes.ColorScheme = Base.getfield(ColorSchemes, Symbol(colorscale))

    cell_position::Float64 = (cell_value - Base.minimum(numbers)) / (Base.maximum(numbers) - Base.minimum(numbers))

    color::Colors.Colorant = ColorSchemes.get(colorscheme, cell_position)

    css_color::String = css_rgb(color)

    return " style=\"background-color: $css_color;\""
end

function writetbody(
    tbl;
    colorscale::AbstractString="",
    tooltips::Bool,
    css::Bool,
    editable::Bool)::String

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
            cell *= cellcolor(tbl, colorscale=colorscale, cell_value=cell_value, css=css)
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
$table_docstring
"""
function table(
    tbl;
    header::Bool=true,
    footer::Bool=true,
    id::AbstractString="",
    classes::Union{AbstractString,Vector{AbstractString}}="",
    caption::AbstractString="",
    css::Bool=true,
    editable::Bool=false,
    theme::Union{Symbol,AbstractString,AbstractVector}=:default,
    colorscale::AbstractString="",
    tooltips::Bool=true)::String

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
    html_table *= writethead(tbl, header=header, editable=editable)
    html_table *= writetbody(tbl, colorscale=colorscale, tooltips=tooltips, css=css, editable=editable)
    html_table *= writetfoot(tbl, footer=footer, editable=editable)
    html_table *= "</table>"

    return html_table
end

"""
$write_docstring
"""
function write(tbl; out::AbstractString="table.html", kwargs...)::String
    Base.open(out, "w") do io
        Base.write(io, table(tbl; kwargs...))
    end

    Base.println("HTML table saved as $out")

    return out
end

function npminstall(npm_packages::AbstractVector)::Nothing
    for npm_package in npm_packages
        Base.run(`$(NodeJS.npm) install $npm_package`)
    end

    return nothing
end

function escape_html_for_js(html::AbstractString)::String
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

function html2jpg(html_table::AbstractString, out::AbstractString)::String
    return """
        const fs = require("fs");
        const puppeteer = require("puppeteer");

        async function html2jpg(htmlString, outputPath) {
            const browser = await puppeteer.launch();
            const page = await browser.newPage();
            await page.goto(
            `data:text/html;charset=utf-8,\${encodeURIComponent(htmlString)}`,
            { waitUntil: "domcontentloaded" }
            );
            const jpegBuffer = await page.screenshot({ fullPage: true, type: "jpeg" });
            fs.writeFileSync(outputPath, jpegBuffer);
            await browser.close();
        }

        html2jpg(\"$html_table\", \"$out\")
    """
end

function html2pdf(html_table::AbstractString, out::AbstractString)::String
    return """
        const puppeteer = require("puppeteer");

        async function html2pdf(htmlString, outputPath) {
        const browser = await puppeteer.launch();
        const page = await browser.newPage();

        await page.setContent(htmlString, { waitUntil: "networkidle0" });
        await new Promise((resolve) => setTimeout(resolve, 1000));

        const pdfOptions = {
            path: outputPath,
            printBackground: true,
        };

        await page.pdf(pdfOptions);
        await browser.close();
        }

        html2pdf(\"$html_table\", \"$out\")
    """
end

function html2png(html_table::AbstractString, out::AbstractString)::String
    return """
    const fs = require("fs");
    const puppeteer = require("puppeteer");

        async function html2png(htmlString, outputPath) {
            const browser = await puppeteer.launch();
            const page = await browser.newPage();
            await page.goto(
            `data:text/html;charset=utf-8,\${encodeURIComponent(htmlString)}`,
            { waitUntil: "domcontentloaded" }
            );
            const pngBuffer = await page.screenshot({ fullPage: true });
            fs.writeFileSync(outputPath, pngBuffer);
            await browser.close();
        }

        html2png(\"$html_table\", \"$out\")
    """
end

function converttable(tbl, format::AbstractString; out::AbstractString="table", kwargs...)::String
    html_table::String = table(tbl; kwargs...) |> escape_html_for_js

    ext::String = Base.Filesystem.splitext(out)[end]

    if ext == ""
        out = "$out.$format"
    end

    embedded_js_content::String = ""
    if format == "jpg"
        embedded_js_content = html2jpg(html_table, out)
    elseif format == "pdf"
        embedded_js_content = html2pdf(html_table, out)
    elseif format == "png"
        embedded_js_content = html2png(html_table, out)
    else
        Base.throw(Base.ArgumentError("Output format must be one of jpg, pdf, or png"))
    end

    if format in ["jpg", "png"]
        npminstall(["fs", "puppeteer"])
    elseif format == "pdf"
        npminstall(["puppeteer"])
    end

    node::Cmd = NodeJS_20_jll.node()

    Base.run(`$node -e "$embedded_js_content" --input-type=module`)

    Base.println("HTML table saved as $out")

    return out
end

"""
$jpg_docstring
"""
function jpg(tbl; kwargs...)::String
    return converttable(tbl, "jpg"; kwargs...)
end

"""
$pdf_docstring
"""
function pdf(tbl; kwargs...)::String
    return converttable(tbl, "pdf"; kwargs...)
end

"""
$png_docstring
"""
function png(tbl; kwargs...)::String
    return converttable(tbl, "png"; kwargs...)
end