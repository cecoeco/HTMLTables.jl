function isurl(source::String)::Bool
    return Base.startswith(source, r"^(http://|https://|ftp://)")
end

function ishtmlfile(source::String)::Bool
    return Base.Filesystem.splitext(source)[2] == ".html"
end

function get_table(
    source::String; id::String="", class::Union{String,Vector{String}}="", index::Int=1
)::Gumbo.HTMLNode
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

function get_tables(source::String)::Vector{Gumbo.HTMLNode}
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

function extract_row_data(row::Gumbo.HTMLNode)::Vector
    cells::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("td,th"), row)

    return [Cascadia.nodeText(cell) for cell in cells]
end

"""
    HTMLTables.read(
        source::String,
        sink::Function; 
        id::String="", 
        class::Union{String,Vector{String}}="",
        index::Int=1
    )

Reads a HTML table into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML table.
- `sink`: The function that materializes the table data.

## Keyword Arguments

- `id::String`: The id of the HTML table.
- `class::Union{String,Vector{String}}`: The class of the HTML table.
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

"""
function read(
    source::String,
    sink;
    id::String="",
    class::Union{String,Vector{String}}="",
    index::Int=1,
)
    table::Gumbo.HTMLNode = get_table(source; id=id, class=class, index=index)

    rows::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("tr"), table)
    headers::Vector = []
    data::Vector{Vector} = []

    for (i, row) in Base.enumerate(rows)
        rowdata = extract_row_data(row)
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
        class::Union{String,Vector{String}}="",
        index::Int=1
    )

Reads a HTML table into a sink function such as `DataFrame`.

## Arguments

- `source::IO`: IO stream of the HTML table.
- `sink`: The function that materializes the table data.

## Keyword Arguments

- `id::String`: The id of the HTML table.
- `class::Union{String,Vector{String}}`: The class of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

"""
function read(
    source::IO, sink; id::String="", class::Union{String,Vector{String}}="", index::Int=1
)
    return read(Base.read(source, String), sink; id=id, class=class, index=index)
end

"""
	HTMLTables.readall(source::String, sink)::Vector

Reads all HTML tables into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML document or website.
- `sink`: The function that materializes the table data.

## Examples

reading all HTML tables from a website into a vector of DataFrames:

```julia
using HTMLTables, DataFrames

url::String = "https://www.w3schools.com/html/html_tables.asp"

dataframes::Vector{DataFrame} = HTMLTables.readall(url, DataFrame)

for idx in eachindex(dataframes)
    println("DataFrame \$idx:\\n\$(dataframes[idx])\\n")
end
```

output:

```
DataFrame 1:
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

DataFrame 2:
10×2 DataFrame
 Row │ Tag         Description                       
     │ String      String                            
─────┼───────────────────────────────────────────────
   1 │ <table>     Defines a table
   2 │ <th>        Defines a header cell in a table
   3 │ <tr>        Defines a row in a table
   4 │ <td>        Defines a cell in a table
   5 │ <caption>   Defines a table caption
   6 │ <colgroup>  Specifies a group of one or more…
   7 │ <col>       Specifies column properties for …
   8 │ <thead>     Groups the header content in a t…
   9 │ <tbody>     Groups the body content in a tab…
  10 │ <tfoot>     Groups the footer content in a t…
```

"""
function readall(source::String, sink)::Vector
    tables = get_tables(source)
    results = Vector{Any}(undef, Base.length(tables))

    for (i, table) in Base.pairs(tables)
        rows::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("tr"), table)
        headers::Vector = []
        data::Vector{Vector} = []

        for (j, row) in Base.enumerate(rows)
            rowdata = extract_row_data(row)
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
    HTMLTables.readall(source::IO, sink)::Vector

Reads all HTML tables into a sink function such as `DataFrame`.

## Arguments

- `source::IO`: IO stream of the HTML document or website.
- `sink`: The function that materializes the table data.

"""
function readall(source::IO, sink)::Vector
    return readall(Base.read(source, String), sink)
end
