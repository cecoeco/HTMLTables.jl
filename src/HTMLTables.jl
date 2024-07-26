"""
Julia package for reading and writing HTML tables.

Reading HTML tables:
- `HTMLTables.get` reads an HTML table as a string based on the given index.
- `HTMLTables.getall` extracts all tables from an HTML document or website.
- `HTMLTables.read` extracts the data from an HTML table using a sink function.
- `HTMLTables.readall` extracts the data from all tables of an HTML document or website.

Writing HTML tables:
- `HTMLTables.table` uses the Tables.jl interface to write an HTML table as a string.
- `HTMLTables.write` uses the Tables.jl interface to write an HTML table in a file.
"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, Tables

export get, getall, read, readall, table, write

include("reading.jl")
include("writing.jl")

end
