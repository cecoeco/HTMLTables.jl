const THEMES::Dict{String,Vector{Union{Int,String}}} = Base.Dict(
    "themes/00-default.css" => ["default", "00", 00, "0", 0],
    "themes/01-red.css" => ["red", "01", 01, "1", 1],
    "themes/02-orange.css" => ["orange", "02", 02, "2", 2],
    "themes/03-yellow.css" => ["yellow", "03", 03, "3", 3],
    "themes/04-green.css" => ["green", "04", 04, "4", 4],
    "themes/05-blue.css" => ["blue", "05", 05, "5", 5],
    "themes/06-violet.css" => ["violet", "06", 06, "6", 6],
    "themes/07-magenta.css" => ["magenta", "07", 07, "7", 7],
    "themes/08-brown.css" => ["brown", "08", 08, "8", 8],
    "themes/09-gray.css" => ["gray", "09", 09, "9", 9]
)

function loadtheme(theme::Union{Int,String})::String
    if Base.isa(theme, String) || Base.isa(theme, Int)
        for (css_file, themes) in THEMES
            if theme in themes
                theme_path = Base.Filesystem.joinpath(@__DIR__, css_file)
                css_string = Base.read(theme_path, String)
                return "<style>\n$css_string\n</style>\n"
            end
        end
    elseif Base.Filesystem.ispath(theme) && Base.Filesystem.isfile(theme)
        css_string = Base.read(theme, String)
        return "<style>\n$css_string\n</style>\n"
    else
        return Base.throw(Base.ArgumentError("$theme is not a valid theme or CSS file."))
    end
end

function rgbString(color::RGB)
    r::Float64 = Colors.red(color)
    g::Float64 = Colors.green(color)
    b::Float64 = Colors.blue(color)

    r_int::Int = Base.round(Int, r * 255)
    g_int::Int = Base.round(Int, g * 255)
    b_int::Int = Base.round(Int, b * 255)

    r_string::String = Base.string(r_int)
    g_string::String = Base.string(g_int)
    b_string::String = Base.string(b_int)

    rgb_string::String = "rgb(" * Base.join([r_string, g_string, b_string], ",") * ")"

    return rgb_string
end

"""
    HTMLTables.write()
"""
function write(
    table;
    filename::String="table",
    save_location::String=Base.Filesystem.pwd(),
    header::Bool=true,
    footer::Bool=true,
    id::String="",
    classes::Union{Vector{String},String}="",
    css::Bool=true,
    theme::Union{Int,String}="default",
    colorscale="",
    tooltips::Bool=true
)
    html_table::String = ""

    if css
        html_table *= loadtheme(theme)
    end

    html_table *= "<table"

    if id !== ""
        html_table *= " id=\"$id\""
    end

    if classes !== ""
        if Base.isa(classes, String)
            html_table *= " class=\"$classes\""
        elseif Base.isa(classes, Vector{String})
            html_table *= " class=\"" * Base.join(classes, " ") * "\""
        end
    end

    html_table *= ">\n"

    if header
        html_table *= "<thead>\n<tr>\n"

        for col in Base.names(table)
            html_table *= "<td>$col</td>\n"
        end

        html_table *= "</tr>\n</thead>\n"
    end

    html_table *= "<tbody>\n"

    for row in Tables.rows(table)
        html_table *= "<tr>\n"

        for col in Base.names(table)
            cell_value = row[Base.Symbol(col)]

            if tooltips
                title_attribute = " title=\"$cell_value\""
            else
                title_attribute = ""
            end

            if colorscale !== "" && css
                colors::ColorScheme = Base.getfield(ColorSchemes, Base.Symbol(colorscale))

                rows_min = [Base.minimum(row[2:end]) for row in Base.eachrow(table)]
                min_values = Base.vcat(rows_min...)
                min_val = Base.minimum(min_values)

                rows_max = [Base.maximum(row[2:end]) for row in Base.eachrow(table)]
                max_values = Base.vcat(rows_max...)
                max_val = Base.maximum(max_values)

                normalized_value = (cell_value - min_val) / (max_val - min_val)
                
                color_index = normalized_value * (Base.length(colors) - 1) + 1
                color_index = ceil(Int, color_index)
                color_index = min(max(color_index, 1), Base.length(colors))

                color = colors[color_index]
                color = rgbString(color)

                style_attribute = "style=\"background-color: $color;\""
            else
                style_attribute = ""
            end

            html_table *= "<td$title_attribute $style_attribute>$cell_value</td>\n"
        end

        html_table *= "</tr>\n"
    end

    html_table *= "</tbody>\n"

    if footer
        html_table *= "<tfoot>\n<tr>\n"

        for _ in Base.names(table)
            html_table *= "<td></td>\n"
        end

        html_table *= "</tr>\n</tfoot>\n"
    end

    html_table *= "</table>"

    path::String = Base.Filesystem.joinpath(save_location, "$filename.html")

    Base.open(path, "w") do io
        Base.write(io, html_table)
    end

    return path
end
