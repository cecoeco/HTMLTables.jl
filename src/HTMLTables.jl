"""
Julia package for reading, writing, and viewing HTML tables.

Reading HTML tables:
- `HTMLTables.get` reads an HTML table as a string based on the given index.
- `HTMLTables.getall` extracts all tables from an HTML document or website.
- `HTMLTables.read` extracts the data from an HTML table using a sink function.
- `HTMLTables.readall` extracts the data from all tables of an HTML document or website.

Writing HTML tables:
- `HTMLTables.table` uses the Tables.jl interface to write an HTML table as a string.
- `HTMLTables.write` uses the Tables.jl interface to write an HTML table in a file.
- `HTMLTables.jpg` writes an HTML table as a JPG image.
- `HTMLTables.pdf` writes an HTML table as a PDF document.
- `HTMLTables.png` writes an HTML table as a PNG image.

Viewing HTML tables:
- `HTMLTables.display` displays a julia table as an HTML table in julia.
- `HTMLTables.open` opens a julia table as an HTML table in the browser.
"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, NodeJS_20_jll, Tables

export get, getall, read, readall, table, write, jpg, pdf, png, display, open

include("docstrings.jl")
include("reading.jl")
include("writing.jl")
include("viewing.jl")

end
