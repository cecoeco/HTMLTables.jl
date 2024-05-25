"""
$open_docstrings
"""
function open(tbl; kwargs...)::String
    path::String = write(tbl; kwargs...)

    if Base.Sys.iswindows()
        Base.run(`start $path`)
    elseif Base.Sys.islinux()
        Base.run(`xdg-open $path`)
    elseif Base.Sys.isapple()
        Base.run(`open $path`)
    end

    Base.println("Opening $path in your default browser...")

    return path
end

"""
$display_docstrings
"""
function display(tbl; kwargs...)::Nothing
    html_table::String = table(tbl; kwargs...)

    Base.Multimedia.display("juliavscode/html", html_table)

    return nothing
end