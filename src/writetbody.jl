function writetbody(
    df::DataFrame;
    filename::String="table",
    save_location::String=Base.Filesystem.pwd(),
    id::Union{String}="",
    classes::Union{Vector{String},String}=""
)
    tbody_content::String = ""

    for row in 1:DataFrames.nrow(df)
        tbody_content *= "<tr>"
        for col in 1:DataFrames.ncol(df)
            tbody_content *= "<td>$(df[row, col])</td>"
        end
        tbody_content *= "</tr>"
    end

    table_html::String = "<table"

    if id !== ""
        table_html *= " id=\"$id\""
    end

    if classes !== ""
        if Base.isa(classes, String)
            table_html *= " class=\"$classes\""
        elseif Base.isa(classes, Vector{String})
            table_html *= " class=\"" * Base.join(classes, " ") * "\""
        end
    end

    table_html *= ">$tbody_content</table>"

    path::String = Base.Filesystem.joinpath(save_location, "$filename.html")

    Base.open(path, "w") do io
        Base.write(io, table_html)
    end

    return path
end
