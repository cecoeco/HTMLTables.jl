function isurl(source::AbstractString)::Bool
    return Base.startswith(source, r"^(http://|https://|ftp://)")
end

function ishtmlfile(source::AbstractString)::Bool
    return Base.Filesystem.splitext(source)[2] == ".html"
end

function get(
    source::AbstractString;
    id::AbstractString="",
    classes::Union{Vector{AbstractString},AbstractString}="",
    index::Int=1,
)
    if index <= 0 || Base.isinteger(index) == false
        Base.throw(Base.ArgumentError("Index must be a positive integer"))
    end

    html_content::String = ""
    if isurl(source) == true
        html_content *= Base.String(HTTP.get(source).body)
    elseif ishtmlfile(source) == true
        html_content *= Base.read(source, String)
    else
        html_content *= source
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

    tables::Vector{Gumbo.HTMLNode} = Base.eachmatch(
        Cascadia.Selector(selector), html_document.root
    )

    number_of_tables::Int = Base.length(tables)
    if number_of_tables == 0
        Base.throw(Base.ArgumentError("No HTML tables found"))
    elseif index > number_of_tables
        Base.throw(
            Base.ArgumentError(
                "$number_of_tables table(s) found. Index $index does not exist."
            ),
        )
    end

    table::Gumbo.HTMLNode = tables[index]

    return table
end

function getall(source::AbstractString)::Vector
    html_content::String = ""
    if isurl(source) == true
        html_content *= Base.String(HTTP.get(source).body)
    elseif ishtmlfile(source) == true
        html_content *= Base.read(source, String)
    else
        html_content *= source
    end

    html_document::Gumbo.HTMLDocument = Gumbo.parsehtml(html_content)
    tables::Vector{Gumbo.HTMLNode} = Base.eachmatch(
        Cascadia.Selector("table"), html_document.root
    )

    return tables
end

function extractrowdata(row::Gumbo.HTMLNode)::Vector
    cells::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("td,th"), row)

    return [Cascadia.nodeText(cell) for cell in cells]
end

"""
	HTMLTables.read(
		source::String,
		sink::Function; 
		id::String="", 
		classes::Union{Vector{String},String}="",
        index::Int=1
	)

Reads a HTML table into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML table.
- `sink`: The function that materializes the table data.

## Keyword Arguments

- `id::String`: The id of the HTML table.
- `classes::Union{Vector{String},String}`: The classes of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

## Examples

reading an HTML table from a website into a DataFrame:

```julia
using HTMLTables, DataFrames

url::String = "https://www.w3schools.com/html/html_tables.asp"

df = HTMLTables.read(url, DataFrame; index=1)

println(df)
```

output:

6×3 DataFrame
 Row │ Company                       Contact           Country
     │ String                        String            String
─────┼─────────────────────────────────────────────────────────
   1 │ Alfreds Futterkiste           Maria Anders      Germany
   2 │ Centro comercial Moctezuma    Francisco Chang   Mexico
   3 │ Ernst Handel                  Roland Mendel     Austria
   4 │ Island Trading                Helen Bennett     UK
   5 │ Laughing Bacchus Winecellars  Yoshi Tannamuri   Canada
   6 │ Magazzini Alimentari Riuniti  Giovanni Rovelli  Italy

"""
function read(
    source::AbstractString,
    sink;
    id::AbstractString="",
    classes::Union{Vector{AbstractString},AbstractString}="",
    index::Int=1,
)
    table::Gumbo.HTMLNode = get(source, id=id, classes=classes, index=index)

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

"""
    HTMLTables.read(
        source::IO,
        sink::Function; 
        id::String="", 
        classes::Union{Vector{String},String}="",
        index::Int=1
    )

Reads a HTML table into a sink function such as `DataFrame`.

## Arguments

- `source::IO`: IO stream of the HTML table.
- `sink`: The function that materializes the table data.

## Keyword Arguments

- `id::String`: The id of the HTML table.
- `classes::Union{Vector{String},String}`: The classes of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

"""
function read(
    source::IO,
    sink;
    id::AbstractString="",
    classes::Union{Vector{AbstractString},AbstractString}="",
    index::Int=1,
)
    return read(Base.read(source, String), sink, id=id, classes=classes, index=index)
end

"""
	HTMLTables.readall(source::String, sink::Function)::Vector

Reads all HTML tables into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML document or website.
- `sink`: The function that materializes the table data.

## Examples

```julia
# reading all HTML tables into a DataFrame
using HTMLTables, DataFrames

url::String = "https://www.w3schools.com/html/html_tables.asp"

dataframes::Vector{DataFrame} = HTMLTables.readall(url, DataFrame)

for idx in eachindex(dataframes)
    println("DataFrame \$idx:")
    println(dataframes[idx])
end
```

"""
function readall(source::AbstractString, sink)::Vector
    tables = getall(source)
    results = Vector{Any}(undef, Base.length(tables))

    for (i, table) in Base.pairs(tables)
        rows::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("tr"), table)
        headers::Vector = []
        data::Vector{Vector} = []

        for (j, row) in Base.enumerate(rows)
            rowdata = extractrowdata(row)
            if (j == 1 && Base.isempty(headers)) == true
                headers = rowdata
            else
                Base.push!(data, rowdata)
            end
        end

        tuples::Vector = [Base.Tuple(row) for row in data]
        results[i] = sink(tuples, headers)
    end

    return results
end

"""
    HTMLTables.readall(source::IO, sink::Function)::Vector

Reads all HTML tables into a sink function such as `DataFrame`.

## Arguments

- `source::IO`: IO stream of the HTML document or website.
- `sink`: The function that materializes the table data.

"""
function readall(source::IO, sink)::Vector
    return readall(Base.read(source, String), sink)
end