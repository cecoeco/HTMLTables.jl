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
