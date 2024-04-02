function write(
    df::DataFrame;
    filename::String="table",
    save_location::String=Base.pwd(),
    headers::Bool=true,
    id::Union{String,Missing}=missing,
    classes::Union{Vector{String},String,Missing}=missing
)
    html_table = "<table"

    if id !== missing
        html_table *= " id=\"$id\""
    end

    if classes !== missing
        if isa(classes, String)
            html_table *= " class=\"$classes\""
        elseif isa(classes, Vector{String})
            html_table *= " class=\"" * join(classes, " ") * "\""
        end
    end

    html_table *= ">"

    if headers
        html_table *= "<thead><tr>"
        for col in names(df)
            html_table *= "<th>$col</th>"
        end
        html_table *= "</tr></thead>"
    end

    html_table *= "<tbody>"

    for row in 1:nrow(df)
        html_table *= "<tr>"
        for col in 1:ncol(df)
            html_table *= "<td>$(df[row, col])</td>"
        end
        html_table *= "</tr>"
    end

    html_table *= "</tbody></table>"

    path = joinpath(save_location, "$filename.html")

    Base.open(path, "w") do io
        Base.write(io, html_table)
    end

    return path
end

function writetbody(
    df::DataFrame;
    filename::String="table",
    save_location::String=Base.pwd(),
    id::Union{String,Missing}=missing,
    classes::Union{Vector{String},String,Missing}=missing
)
    tbody_content = ""

    for row in 1:nrow(df)
        tbody_content *= "<tr>"
        for col in 1:ncol(df)
            tbody_content *= "<td>$(df[row, col])</td>"
        end
        tbody_content *= "</tr>"
    end

    table_html = "<table"

    if id !== missing
        table_html *= " id=\"$id\""
    end

    if classes !== missing
        if isa(classes, String)
            table_html *= " class=\"$classes\""
        elseif isa(classes, Vector{String})
            table_html *= " class=\"" * join(classes, " ") * "\""
        end
    end

    table_html *= ">$tbody_content</table>"

    path = joinpath(save_location, "$filename.html")

    Base.open(path, "w") do io
        Base.write(io, table_html)
    end

    return path
end
