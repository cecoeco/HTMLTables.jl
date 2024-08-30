"""
# HTMLTables

Julia package for reading and writing HTML tables.

Read HTML tables:

- `HTMLTables.read` extracts the data from an HTML table using a sink function.
- `HTMLTables.readall` extracts the data from all tables of an HTML document or website.

Write HTML tables:

- `HTMLTables.table` uses the Tables.jl interface to write an HTML table as a string.
- `HTMLTables.write` uses the Tables.jl interface to write an HTML table in a file.
"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, Tables

export read, readall, table, write

include("read.jl")
include("write.jl")

end
