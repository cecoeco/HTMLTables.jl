function extractrowdata(row::Gumbo.HTMLNode)::Vector
    cells::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("td,th"), row)

    return [Cascadia.nodeText(cell) for cell in cells]
end

"""
    HTMLTables.read(source::String; id::String="", classes::Union{Vector{String},String}="")

Reads a HTML table into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML table.
- `sink`: The function that materializes the table data.
- `id::String`: The id of the HTML table.
- `classes::Union{Vector{String},String}`: The classes of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

## Examples

```julia
using HTMLTables, DataFrames

# read an HTML table into a DataFrame
df = HTMLTables.read("https://www.w3schools.com/html/html_tables.asp", DataFrame)
```
"""
function read(
    source::String,
    sink; 
    id::String="", 
    classes::Union{Vector{String},String}="",
    index::Int=1
)
    table = get(source, id=id, classes=classes, index=index)

    rows::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("tr"), table)
    headers::Vector = []
    data::Vector{Vector} = []

    for (i, row) in Base.enumerate(rows)
        rowdata = extractrowdata(row)
        if (i == 1 && Base.isempty(headers)) == true
            headers = rowdata
        else
            Base.push!(data, rowdata)
        end
    end

    tuples::Vector = [Base.Tuple(row) for row in data]

    return sink(tuples, headers)
end
