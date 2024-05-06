"""
    HTMLTables

Julia package for reading and writing HTML tables.

Reading HTML tables:
- `HTMLTables.read` reads HTML table element `<table></table>` into a `DataFrame`.

Writing HTML tables:
- `HTMLTables.write` writes a `DataFrame` into an HTML table element `<table></table>`.
"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, DataFrames, Gumbo, HTTP, Tables

export read, write

function isurl(source::String)::Bool
    url_pattern::Regex = r"(?i)\b((?:https?|ftp):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?)\b"

    return Base.occursin(url_pattern, source)
end

include("read.jl")
include("write.jl")

end
