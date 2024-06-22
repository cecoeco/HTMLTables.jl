const get_docstring::String = 
"""
    HTMLTables.get(source::String; id::String="", classes::Union{Vector{String},String}="", index::Int=1)

Returns an HTML table a source as a string.

## Arguments

- `source::String`: URL or path to the HTML table.
- `id::String`: The id of the HTML table.
- `classes::Union{Vector{String},String}`: The classes of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

"""

const getall_docstring::String =
"""
    HTMLTables.getall(source::String)

Extracts all tables from an HTML document or website.

## Arguments

- `source::String`: URL or path to the HTML document or website.

"""

const read_docstring::String = 
"""
    HTMLTables.read(source::String, sink::Function; id::String="", classes::Union{Vector{String},String}="")

Reads a HTML table into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML table.
- `sink`: The function that materializes the table data.
- `id::String`: The id of the HTML table.
- `classes::Union{Vector{String},String}`: The classes of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

## Examples

```julia
# reading an HTML table into a DataFrame
using HTMLTables, DataFrames

df = HTMLTables.read("https://www.w3schools.com/html/html_tables.asp", DataFrame)

# writing the html table data into a CSV file
using CSV

CSV.write("table.csv", df)

# writing the html table data into a JSON file
using JSON, JSONTables

json = JSONTables.objecttable(df)

Base.open("table.json", "w") do io
    JSON3.pretty(io, json)
end

# writing the html table data into an Excel file
using XLSX

XLSX.writetable("table.xlsx", "Sheet 1" => df)

```
"""

const readall_docstring::String = 
"""
    HTMLTables.readall(source::String, sink::Function)

Reads all HTML tables into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML document or website.
- `sink`: The function that materializes the table data.

"""

const TABLE_ARGUMENTS::String = 
"""

## Arguments

- `tbl`: The table to write.
- `header`: Whether to include the table header.
- `footer`: Whether to include the table footer.
- `id`: The id of the HTML table.
- `classes`: The classes of the HTML table.
- `css`: Whether to include the CSS styles.
- `editable`: Whether to enable table editing.
- `theme`: The theme of the HTML table.
- `colorscale`: The colorscale of the HTML table.
- `tooltips`: Whether to include tooltips.

"""

const WRITE_ARGUMENTS::String = 
"""

## Arguments

- `tbl`: The table to write.
- `out`: The file to write the table to.
- `header`: Whether to include the table header.
- `footer`: Whether to include the table footer.
- `id`: The id of the HTML table.
- `classes`: The classes of the HTML table.
- `css`: Whether to include the CSS styles.
- `editable`: Whether to enable table editing.
- `theme`: The theme of the HTML table.
- `colorscale`: The colorscale of the HTML table.
- `tooltips`: Whether to include tooltips.

"""

const table_docstring::String = 
"""
    HTMLTables.table(
        tbl;
        header::Bool=true,
        footer::Bool=true,
        id::String="",
        classes::String="",
        css::Bool=true,
        editable::Bool=false,
        theme::String="default",
        colorscale="",
        tooltips::Bool=true
    )

Returns a julia table as an HTML table.

$TABLE_ARGUMENTS

## Returns

- `html_table`: A string containing the HTML table.

## Examples

```julia
using DataFrames, HTMLTables

df = DataFrame(x=1:10, y=1:10)

html = HTMLTables.table(df)

println(html)
```

```julia
using Oxygen, HTTP, HTMLTables, DataFrames

function layout(table::AbstractString)::String
    return \"\"\"
    <!DOCTYPE html>
    <html>
        <head>
            <title>Oxygen.jl + HTMLTables.jl</title>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
        </head>
        <script>
            async function changeTheme() {
                const theme = document.getElementById("theme").value;
                const response = await fetch("/theme", {
                    method: "POST",
                    headers: {
                        "Content-Type": "text/plain"
                    },
                    body: theme
                });
                const data = await response.text();
                document.getElementById("table-container").innerHTML = data;
            }
        </script>
        <body>
            <p>Choose the theme of the table</p>
            <select id="theme" onchange="changeTheme()">
                <option value="default">Default</option>
                <option value="red">Red</option>
                <option value="orange">Orange</option>
                <option value="yellow">Yellow</option>
                <option value="green">Green</option>
                <option value="blue">Blue</option>
                <option value="violet">Violet</option>
                <option value="magenta">Magenta</option>
                <option value="brown">Brown</option>
                <option value="gray">Gray</option>
            </select>
            <div id="table-container">
                \$table
            </div>
        </body>
    </html>
    \"\"\"
end

df = DataFrame(x=1:10, y=1:10, z=1:10)

Oxygen.get("/") do req::HTTP.Request
    Oxygen.html(layout(HTMLTables.table(df)))
end

Oxygen.post("/theme") do req::HTTP.Request
    Oxygen.html((HTMLTables.table(df, theme=String(req.body))))
end

Oxygen.serve(host="127.0.0.1", port=5050)

```

"""

const write_docstring::String = 
"""
    HTMLTables.write(
        tbl;
        filename::String="table",
        save_location::String=Base.Filesystem.pwd(),
        kwargs...
    )

Writes a julia table as an HTML table to an HTML file.

$WRITE_ARGUMENTS

## Returns

- `path`: The path to the HTML file.
"""

const jpg_docstring::String = 
"""
    HTMLTables.jpg(tbl; kwargs...)

Writes an HTML table as a JPG image.

$WRITE_ARGUMENTS

"""

const pdf_docstring::String = 
"""
    HTMLTables.pdf(tbl; kwargs...)

Writes an HTML table as a PDF document.

$WRITE_ARGUMENTS

"""

const png_docstring::String = 
"""
    HTMLTables.png(tbl; kwargs...)

Writes an HTML table as a PNG image.

$WRITE_ARGUMENTS

"""

const open_docstring::String = 
"""
    HTMLTables.open(tbl; kwargs...)

Opens a julia table as an HTML table in the browser.

$WRITE_ARGUMENTS

## Returns

- `path`: The path to the HTML file.

"""

const display_docstring::String = 
"""
    HTMLTables.display(tbl; kwargs...)

Displays a julia table as an HTML table in julia.

$TABLE_ARGUMENTS

## Examples

```julia
using DataFrames, HTMLTables

df = DataFrame(
    "a" => [001, 002, 003, 004, 005, 006, 007, 008, 009, 010],
    "b" => [011, 012, 013, 014, 015, 016, 017, 018, 019, 020],
    "c" => [021, 022, 023, 024, 025, 026, 027, 028, 029, 030],
    "d" => [031, 032, 033, 034, 035, 036, 037, 038, 039, 040],
    "e" => [041, 042, 043, 044, 045, 046, 047, 048, 049, 050],
    "f" => [051, 052, 053, 054, 055, 056, 057, 058, 059, 060],
    "g" => [061, 062, 063, 064, 065, 066, 067, 068, 069, 070],
    "h" => [071, 072, 073, 074, 075, 076, 077, 078, 079, 080],
    "i" => [081, 082, 083, 084, 085, 086, 087, 088, 089, 090],
    "j" => [091, 092, 093, 094, 095, 096, 097, 098, 099, 100]
)

HTMLTables.display(df, theme="green", colorscale="Greens")
```
"""