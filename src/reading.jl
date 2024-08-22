function isurl(source::AbstractString)::Bool
	return startswith(source, "http://") || startswith(source, "https://") || startswith(source, "ftp://")
end

function ishtmlfile(source::AbstractString)::Bool
	return Base.Filesystem.splitext(source)[2] == ".html"
end

"""
	HTMLTables.get(
		source::String; 
		id::String="", 
		classes::Union{Vector{String},String}="", 
		index::Int=1
	)

Returns an HTML table a source as a string.

## Arguments

- `source::String`: URL or path to the HTML table.

## Keyword Arguments

- `id::String`: The id of the HTML table.
- `classes::Union{Vector{String},String}`: The classes of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

"""
function get(
	source::AbstractString;
	id::AbstractString = "",
	classes::Union{Vector{AbstractString}, AbstractString} = "",
	index::Int = 1,
)
	if index <= 0 || Base.isinteger(index) == false
		Base.throw(Base.ArgumentError("Index must be a positive integer"))
	end

	html_content::String = ""
	if isurl(source) == true
		response::HTTP.Response = HTTP.get(source)
		html_content *= Base.String(response.body)
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

	tables::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector(selector), html_document.root)

	number_of_tables::Int = Base.length(tables)
	if number_of_tables == 0
		Base.throw(Base.ArgumentError("No HTML tables found"))
	elseif index > number_of_tables
		Base.throw(Base.ArgumentError("$number_of_tables table(s) found. Index $index does not exist."))
	end

	table::Gumbo.HTMLNode = tables[index]

	return table
end

"""
	HTMLTables.getall(source::String)::Vector

Extracts all tables from an HTML document or website.

## Arguments

- `source::String`: URL or path to the HTML document or website.

"""
function getall(source::AbstractString)::Vector
	html_content::String = ""
	if isurl(source) == true
		response::HTTP.Response = HTTP.get(source)
		html_content *= Base.String(response.body)
	elseif ishtmlfile(source) == true
		html_content *= Base.read(source, String)
	else
		html_content *= source
	end

	html_document::Gumbo.HTMLDocument = Gumbo.parsehtml(html_content)
	tables::Vector{Gumbo.HTMLNode} = Base.eachmatch(Cascadia.Selector("table"), html_document.root)

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

```julia
# reading an HTML table into a DataFrame
using HTMLTables, DataFrames

df = HTMLTables.read("https://www.w3schools.com/html/html_tables.asp", DataFrame)

# writing the html table data into a CSV file
using CSV

CSV.write("table.csv", df)

# writing the html table data into a JSON file
using JSON3, JSONTables

JSON3.write("table.json", JSONTables.objecttable(df)

# writing the html table data into an Excel file
using XLSX

XLSX.writetable("table.xlsx", "Sheet 1" => df)

```

"""
function read(
	source::AbstractString,
	sink;
	id::AbstractString = "",
	classes::Union{Vector{AbstractString}, AbstractString} = "",
	index::Int = 1,
)
	table::Gumbo.HTMLNode = get(source, id = id, classes = classes, index = index)

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
	HTMLTables.readall(source::String, sink::Function)::Vector

Reads all HTML tables into a sink function such as `DataFrame`.

## Arguments

- `source::String`: URL or path to the HTML document or website.
- `sink`: The function that materializes the table data.

"""
function readall(source::AbstractString, sink)
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
