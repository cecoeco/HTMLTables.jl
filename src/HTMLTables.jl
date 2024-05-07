"""
Julia package for reading, writing, and viewing HTML tables.

Reading HTML tables:
- `HTMLTables.get` reads an HTML table as a string.
- `HTMLTables.read` extracts data from HTML tables.

Writing HTML tables:
- `HTMLTables.table` uses the Tables.jl interface to write an HTML table as a string.
- `HTMLTables.write` uses the Tables.jl interface to write an HTML table in a file.

Viewing HTML tables:
- `HTMLTables.display` displays a julia table as an HTML table in julia.
- `HTMLTables.open` opens a julia table as an HTML table in the browser.
"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, Tables

export get, read, table, write, display, open

# reading HTML tables
include("get.jl")
include("read.jl")

# writing HTML tables
include("table.jl")
include("write.jl")

# viewing HTML tables
include("display.jl")
include("open.jl")

end
