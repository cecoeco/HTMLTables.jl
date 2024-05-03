function write(
    df::DataFrame;
    filename::String="table",
    save_location::String=Base.Filesystem.pwd(),
    headers::Bool=true,
    id::Union{String}="",
    classes::Union{Vector{String},String}=""
)
    html_table::String = "<table"

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

    html_table *= ">"

    if headers
        html_table *= "<thead><tr>"
        for col in Base.names(df)
            html_table *= "<th>$col</th>"
        end
        html_table *= "</tr></thead>"
    end

    html_table *= "<tbody>"

    for row in 1:DataFrames.nrow(df)
        html_table *= "<tr>"
        for col in 1:DataFrames.ncol(df)
            html_table *= "<td>$(df[row, col])</td>"
        end
        html_table *= "</tr>"
    end

    html_table *= "</tbody></table>"

    path::String = Base.Filesystem.joinpath(save_location, "$filename.html")

    Base.open(path, "w") do io
        Base.write(io, html_table)
    end

    return path
end
