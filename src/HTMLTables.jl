"""
    HTMLTables 

Read and write HTML tables.

- `HTMLTables.read`: read HTML table into a `DataFrame`.
- `HTMLTables.write`: write a `DataFrame` into an HTML table.
"""
module HTMLTables

using Cascadia, DataFrames, Gumbo, HTTP, Tables

export read, readtbody, write, writetbody

include("read.jl")
include("write.jl")

end