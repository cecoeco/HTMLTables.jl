"""
    HTMLTables.write(
        tbl;
        filename::String="table",
        save_location::String=Base.Filesystem.pwd(),
        header::Bool=true,
        footer::Bool=true,
        id::String="",
        classes::Union{Vector{String},String}="",
        css::Bool=true,
        theme::Union{Int,String}="default",
        colorscale="",
        tooltips::Bool=true
    )

Writes a julia table as an HTML table to an HTML file.

## Arguments

- `tbl`: The table to write.
- `filename`: The filename of the HTML table.
- `save_location`: The location to save the HTML table.
- `header`: Whether to include the table header.
- `footer`: Whether to include the table footer.
- `id`: The id of the HTML table.
- `classes`: The classes of the HTML table.
- `css`: Whether to include the CSS styles.
- `theme`: The theme of the HTML table.
- `colorscale`: The colorscale of the HTML table.
- `tooltips`: Whether to include tooltips.

## Returns

- `path`: The path to the HTML file.

"""
function write(
    tbl;
    filename::String="table",
    save_location::String=Base.Filesystem.pwd(),
    header::Bool=true,
    footer::Bool=true,
    id::String="",
    classes::Union{Vector{String},String}="",
    css::Bool=true,
    theme::Union{Int,String}="default",
    colorscale="",
    tooltips::Bool=true
)
    html_table::String = table(
        tbl,
        header=header,
        footer=footer,
        id=id,
        classes=classes,
        css=css,
        theme=theme,
        colorscale=colorscale,
        tooltips=tooltips
    )

    path::String = Base.Filesystem.joinpath(save_location, "$filename.html")

    Base.open(path, "w") do io
        Base.write(io, html_table)
    end

    return path
end
