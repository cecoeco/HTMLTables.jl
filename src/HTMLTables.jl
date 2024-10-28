"""
# HTMLTables

Julia package for reading and writing HTML tables using the Tables.jl interface

## exported functions:

- `HTMLTables.readtable`: reads an HTML table into a Julia table such as a `DataFrame`.
- `HTMLTables.writetable`: converts a Julia table to an HTML table and writes it to a file or IO stream.

"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, Tables

export readtable, writetable

include("themes.jl")
include("readtable.jl")
include("writetable.jl")

end
