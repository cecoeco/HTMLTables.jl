"""
    HTMLTables 

Julia package for reading and writing HTML tables.

Reading HTML tables:
- `HTMLTables.read` reads HTML table element `<table></table>` into a `DataFrame`.
- `HTMLTables.readtbody` reads the HTML element `<tbody></tbody>` into a `DataFrame`.

Writing HTML tables:
- `HTMLTables.write` writes a `DataFrame` into an HTML table element `<table></table>`.
- `HTMLTables.writetbody` writes a `DataFrame` into an HTML element `<tbody></tbody>`.
"""
module HTMLTables

using Cascadia, DataFrames, Gumbo, HTTP, Tables

export read, readtbody, write, writetbody

include("read.jl")
include("readtbody.jl")
include("write.jl")
include("writetbody.jl")

end