const get_docstrings::String = """
    HTMLTables.get(source::String; id::String="", classes::Union{Vector{String},String}="", index::Int=1)

Returns an HTML table a source as a string.

## Arguments

- `source::String`: URL or path to the HTML table.
- `id::String`: The id of the HTML table.
- `classes::Union{Vector{String},String}`: The classes of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

"""

const read_docstrings::String = """
    HTMLTables.read(source::String; id::String="", classes::Union{Vector{String},String}="")

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

const table_docstrings::String = """
    HTMLTables.table(
        tbl;
        header::Bool=true,
        footer::Bool=true,
        id::String="",
        classes::String="",
        css::Bool=true,
        theme::String="default",
        colorscale="",
        tooltips::Bool=true
    )

Returns a julia table as an HTML table.

## Arguments

- `tbl`: The table to write.
- `header`: Whether to include the table header.
- `footer`: Whether to include the table footer.
- `id`: The id of the HTML table.
- `classes`: The classes of the HTML table.
- `css`: Whether to include the CSS styles.
- `theme`: The theme of the HTML table.
- `colorscale`: The colorscale of the HTML table.
- `tooltips`: Whether to include tooltips.

## Returns

- `html_table`: A string containing the HTML table.

## Examples

```julia
using Tables, DataFrames

df = DataFrame(x=1:10, y=1:10)

html = HTMLTables.table(df)

println(html)
```

```jldoctest

using Tables, DataFrames

df = DataFrame(x=1:10, y=1:10)

html = HTMLTables.table(df)

println(html)

# output
    <style>
    * {
    margin: 0;
    padding: 0;
    }

    html, body {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
    }

    table {
    font-family: Helvetica;
    font-size: 15px;
    color: black;
    border: 0;
    border-spacing: 0;
    border-collapse: collapse;
    border-top: 1px solid black;
    border-bottom: 1px solid black;
    cursor: default;
    }

    caption {
    caption-side: top;
    padding: 10px;
    }

    thead {
    font-weight: bold;
    border-bottom: 1px solid black;
    }

    tbody td:hover {
    text-decoration: underline;
    }

    th, td {
    padding: 5px 10px;
    text-align: center;
    }

    tfoot {
    height: 20px;
    border-top: 1px solid black;
    }


    table {
    background-color: white;
    }

    tfoot {
    display: none;
    }
    </style>
    <table>
    <thead>
    <tr>
    <td>x</td>
    <td>y</td>
    </tr>
    </thead>
    <tbody>
    <tr>
    <td title="1">1</td>
    <td title="1">1</td>
    </tr>
    <tr>
    <td title="2">2</td>
    <td title="2">2</td>
    </tr>
    <tr>
    <td title="3">3</td>
    <td title="3">3</td>
    </tr>
    <tr>
    <td title="4">4</td>
    <td title="4">4</td>
    </tr>
    <tr>
    <td title="5">5</td>
    <td title="5">5</td>
    </tr>
    <tr>
    <td title="6">6</td>
    <td title="6">6</td>
    </tr>
    <tr>
    <td title="7">7</td>
    <td title="7">7</td>
    </tr>
    <tr>
    <td title="8">8</td>
    <td title="8">8</td>
    </tr>
    <tr>
    <td title="9">9</td>
    <td title="9">9</td>
    </tr>
    <tr>
    <td title="10">10</td>
    <td title="10">10</td>
    </tr>
    </tbody>
    <tfoot>
    <tr>
    <td></td>
    <td></td>
    </tr>
    </tfoot>
    </table>
```
"""

const write_docstrings::String = """
    HTMLTables.write(
        tbl;
        filename::String="table",
        save_location::String=Base.Filesystem.pwd(),
        kwargs...
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

const jpg_docstrings::String = """
    HTMLTables.jpg(tbl; kwargs...)

Writes an HTML table as a JPG image.
"""

const pdf_docstrings::String = """
    HTMLTables.pdf(tbl; kwargs...)

Writes an HTML table as a PDF document.
"""

const png_docstrings::String = """
    HTMLTables.png(tbl; kwargs...)

Writes an HTML table as a PNG image.
"""

const open_docstrings::String = """
    HTMLTables.open(tbl; kwargs...)

Opens a julia table as an HTML table in the browser.
"""

const display_docstrings::String = """
    HTMLTables.display(tbl; kwargs...)

Displays a julia table as an HTML table in julia.

## Arguments

- `tbl`: The table to display.
- `kwargs`: Keyword arguments to pass to the `HTMLTables.table` function.

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