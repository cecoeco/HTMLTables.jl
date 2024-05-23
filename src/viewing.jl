"""
$open_docstrings
"""
function open(tbl; kwargs...)
    path::String = write(tbl; kwargs...)

    if Base.Sys.iswindows()
        Base.run(`start $path`)
    elseif Base.Sys.islinux()
        Base.run(`xdg-open $path`)
    elseif Base.Sys.isapple()
        Base.run(`open $path`)
    end
end

"""
$display_docstrings
"""
function display(tbl; kwargs...)
    html_table::String = table(tbl; kwargs...)

    Base.Multimedia.display("juliavscode/html", html_table)
end