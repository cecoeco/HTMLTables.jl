"""
$open_docstring
"""
function open(tbl, out::AbstractString="table.html"; kwargs...)::String
    path::String = write(tbl, out; kwargs...)

    if Base.Sys.iswindows()
        Base.run(`start $path`)
    elseif Base.Sys.islinux()
        Base.run(`xdg-open $path`)
    elseif Base.Sys.isapple()
        Base.run(`open $path`)
    end

    Base.println("Opening $path in the browser...")

    return path
end

"""
$display_docstring
"""
function display(tbl; kwargs...)::Nothing
    html_table::String = table(tbl; kwargs...)

    Base.Multimedia.display("juliavscode/html", html_table)

    return nothing
end