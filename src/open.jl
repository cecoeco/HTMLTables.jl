"""
    HTMLTables.open(tbl; kwargs...)

Opens a julia table as an HTML table in the browser.
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