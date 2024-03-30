function write(
    df::DataFrame;
    filename::String="table",
    save_location::String=Base.pwd(),
    headers::Bool=true,
    id::Union{String,Missing}=missing,
    classes::Union{Vector{String},String,Missing}=missing
)
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

    table_html *= ">"

    if headers
        table_html *= "<thead><tr>"
        for col in names(df)
            table_html *= "<th>$col</th>"
        end
        table_html *= "</tr></thead>"
    end

    table_html *= "<tbody>"

    for row in 1:nrow(df)
        table_html *= "<tr>"
        for col in 1:ncol(df)
            table_html *= "<td>$(df[row, col])</td>"
        end
        table_html *= "</tr>"
    end

    table_html *= "</tbody></table>"

    path = joinpath(save_location, "$filename.html")

    Base.open(path, "w") do io
        Base.write(io, table_html)
    end

    return path
end
