"""
# HTMLTables

Julia package for reading and writing HTML tables using the Tables.jl interface

## exported functions:

- `readtable`: reads an HTML table into a Tables.jl-compatible table like a `DataFrame`.
- `writetable`: converts a Tables.jl-compatible table to an HTML table and writes it to a file or IO stream.

"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, Tables

export readtable, writetable

include("themes.jl")
include("readtable.jl")
include("writetable.jl")

end