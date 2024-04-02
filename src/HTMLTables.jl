"""
    HTMLTables 

Julia package for reading and writing HTML tables.

## Reading HTML tables
- `HTMLTables.read`: read HTML table into a `DataFrame`.
- `HTMLTables.readtbody`: read the HTML <tbody></tbody> element into a `DataFrame`.

## Writing HTML tables
- `HTMLTables.write`: write a `DataFrame` into an HTML table.
- `HTMLTables.writetbody`: write a `DataFrame` into an HTML <tbody></tbody> element.
"""
module HTMLTables

using Cascadia, DataFrames, Gumbo, HTTP, Tables

export read, readtbody, write, writetbody

include("read.jl")
include("write.jl")

end