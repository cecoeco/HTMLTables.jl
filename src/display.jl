"""
    HTMLTables.display(tbl; kwargs...)

Displays a julia table as an HTML table in julia.
"""
function display(tbl; kwargs...)
    html_table::String = table(tbl; kwargs...)

    Base.display("image/svg+xml", html_table)
end