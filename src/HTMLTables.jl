"""
    HTMLTables

Julia package for reading and writing HTML tables.

Reading HTML tables:
- `HTMLTables.read` extracts data from HTML tables.

Writing HTML tables:
- `HTMLTables.write` uses the Tables.jl interface to write an HTML table.
"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, Tables

export read, write

include("read.jl")
include("write.jl")

end
