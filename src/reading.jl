function isurl(source::AbstractString)::Bool
    return startswith(source, "http://") || startswith(source, "https://") || startswith(source, "ftp://")
end

function ishtmlfile(source::AbstractString)::Bool
    return Base.Filesystem.splitext(source)[2] == ".html"
end

"""
$get_docstring
"""
function get(
    source::AbstractString;
    id::AbstractString="",
    classes::Union{Vector{AbstractString},AbstractString}="",
    index::Int=1
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
$getall_docstring
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
$read_docstring
"""
function read(
    source::AbstractString,
    sink;
    id::AbstractString="",
    classes::Union{Vector{AbstractString},AbstractString}="",
    index::Int=1
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
$readall_docstring
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
