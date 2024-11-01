function isurl(source::String)::Bool
    return Base.startswith(source, r"^(http://|https://|ftp://)")
end

function ishtmlfile(source::String)::Bool
    return Base.Filesystem.splitext(source)[2] == ".html"
end

function parse_number(html_text::String, number_type::Type)::Union{Number,String}
    try
        return Base.parse(number_type, html_text)
    catch
        return html_text
    end
end

function extract_row_data(row::Gumbo.HTMLNode, number_type::Type)::Vector
    cells::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("td,th"), row)

    return [parse_number(Cascadia.nodeText(cell), number_type) for cell in cells]
end

"""
    readtable(
        source,
        sink=nothing; 
        id::String="", 
        class::Union{String,Vector{String}}="",
        index::Int=1,
        header::Bool=true,
        number_type::Type=Any
    )

Reads an HTML table into a sink function such as `DataFrame`.

## Arguments

- `source`: URL or path to the HTML table.
- `sink`: the function that materializes the table data.

## Keyword Arguments

- `id::String`: the id of the HTML table in the HTML document.
- `class::Union{String,Vector{String}}`: the class of the HTML table.
- `index::Int`: the index of the HTML table in the HTML document.
- `header::Bool`: whether to include the table header.
- `number_type::Type`: the return type of the numeric table data.

## Returns

- `sink`: the sink function such as `DataFrame` with the HTML table data if `sink` is specified.
- `tuples::Vector`: the table data if `sink` is not specified and the `header` keyword argument is false.
- `headers::Vector`: the table headers if `sink` is not specified and the `header` keyword argument is true.

## Examples

reading an HTML table from a website into a DataFrame:

```julia
using HTMLTables, DataFrames

url = "https://www.w3schools.com/html/html_tables.asp"

df = readtable(url, DataFrame)

println(df)
```

```
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
```

reading the second HTML table from a file into a DataFrame:

```julia
using HTMLTables, DataFrames

url = "tables.html"

df = readtable(url, DataFrame, index=2)

println(df)
```

```
4×2 DataFrame
 Row │ Name       Age
     │ String     String
─────┼─────────────────
   1 │ Bob         25
   2 │ Charlie     35
   3 │ Alice       30
   4 │ David       40
```

reading an HTML table with the id "htmltable" from a string into a DataFrame:

```julia
using HTMLTables, DataFrames

html_str = \"\"\"
<table id="htmltable">
  <tr>
    <th>Name</th>
    <th>Age</th>
  </tr>
  <tr>
    <td>Bob</td>
    <td>25</td>
  </tr>
  <tr>
    <td>Charlie</td>
    <td>35</td>
  </tr>
  <tr>
    <td>Alice</td>
    <td>30</td>
  </tr>
  <tr>
    <td>David</td>
    <td>40</td>
  </tr>
</table>
\"\"\"

df = DataFrame(readtable(html_str, id="htmltable", number_type=Int64))

println(df)
```

```
4×2 DataFrame
 Row │ Name       Age
     │ String     Int64
─────┼─────────────────
   1 │ Bob         25
   2 │ Charlie     35
   3 │ Alice       30
   4 │ David       40
```

read the data from the HTML table as a vector of tuples:

```julia
using HTMLTables

url = "tables.html"

tuples = readtable(url, number_type=Int64, header=false)

println(tuples)
```

```
[("Bob", 25), ("Charlie", 35), ("Alice", 30), ("David", 40)]
```

read the data from the HTML table as a matrix:

```julia
using HTMLTables, Tables

url = "tables.html"

mtx = readtable(url, Tables.matrix; number_type=Int64, header=false)

println(mtx)
```

```
Any["Bob" 25; "Charlie" 35; "Alice" 30; "David" 40]
```
"""
function readtable(
    source,
    sink=nothing;
    id::String="",
    class::Union{String,Vector{String}}="",
    index::Int=1,
    header::Bool=true,
    number_type::Type=Number,
)
    if Base.isa(source, IO)
        source = Base.read(source, String)
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
        if Base.isempty(class)
            selector *= "table"
        elseif !Base.isempty(class) && Base.isa(class, String)
            selector *= "table.$class"
        elseif !Base.isempty(class) && Base.isa(class, Vector{String})
            selector *= "table." * Base.join(class, ".")
        end
    elseif !Base.isempty(id)
        selector *= "#$id"
    end

    tables::Vector{Gumbo.HTMLNode} = Base.eachmatch(
        Cascadia.Selector(selector), html_document.root
    )

    table::Gumbo.HTMLNode = tables[index]

    rows::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("tr"), table)

    headers::Vector = []

    data::Vector{Vector} = []

    for (i, row) in Base.enumerate(rows)
        rowdata::Vector = extract_row_data(row, number_type)
        if (i == 1 && Base.isempty(headers)) == true
            headers = rowdata
        else
            Base.push!(data, rowdata)
        end
    end

    tuples::Vector = [Base.Tuple(row) for row in data]

    if header
        return sink !== nothing ? sink(tuples, headers) : (tuples, headers)
    else
        return sink !== nothing ? sink(tuples) : tuples
    end
end
