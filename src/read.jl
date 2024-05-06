function isurl(source::String)::Bool
    url_pattern ::Regex = r"(?i)\b((?:https?|ftp):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?)\b"

    return Base.occursin(url_pattern, source)
end

function extractrowdata(row::Gumbo.HTMLNode)::Vector
    cell_matches::Vector{Gumbo.HTMLNode} = Base.eachmatch(
        Cascadia.Selector("td,th"), row
    )

    return [Cascadia.nodeText(cell) for cell in cell_matches]
end

"""
    HTMLTables.read(source::String; id::String="", classes::Union{Vector{String},String}="")

Reads a HTML table into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML table.
- `sink`: The function that materializes the table data.
- `id::String`: The id of the HTML table.
- `classes::Union{Vector{String},String}`: The classes of the HTML table.

## Examples

```julia
using HTMLTables, DataFrames

# read an HTML table into a DataFrame
df = HTMLTables.read("https://www.w3schools.com/html/html_tables.asp", DataFrame)
println(df)

```
"""
function read(
    source::String,
    sink; 
    id::String="", 
    classes::Union{Vector{String},String}="",
    index::Int=1
)
    if index <= 0
        throw(ArgumentError("Index must be a positive integer"))
    end

    if isurl(source) == true
        response::HTTP.Response = HTTP.get(source)
        html_content = Base.String(response.body)
    else
        html_content = Base.read(source, String)
    end

    html_document::Gumbo.HTMLDocument = Gumbo.parsehtml(html_content)

    selector::String = ""
    if Base.isempty(id)
        if Base.isempty(classes)
            selector *= "table"
        elseif !Base.isempty(classes) && Base.isa(classes, String)
            selector *= "table.$classes"
        elseif !Base.isempty(classes) && Base.isa(classes, Vector{String})
            selector *= "table." * Base.join(classes, ".")
        end
    elseif !Base.isempty(id)
        selector *= "#$id"
    end

    tables::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector(selector), html_document.root)

    if Base.isempty(tables) == true
        throw(ArgumentError("No HTML tables found"))
    end

    table::Gumbo.HTMLNode = tables[index]

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
