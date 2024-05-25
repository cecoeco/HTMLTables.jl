function isurl(source::String)::Bool
    url_pattern::Regex = r"(?i)\b((?:https?|ftp):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?)\b"

    return Base.occursin(url_pattern, source)
end

"""
$get_docstrings
"""
function get(
    source::String;
    id::String="",
    classes::Union{Vector{String},String}="",
    index::Int=1
)
    if index <= 0
        Base.throw(Base.ArgumentError("Index must be a positive integer"))
    end

    html_content::String = ""
    if isurl(source) == true
        response::HTTP.Response = HTTP.get(source)
        html_content *= Base.String(response.body)
    else
        html_content *= Base.read(source, String)
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
$getall_docstrings
"""
function getall(source::String)::Vector
    html_content::String = ""
    if isurl(source) == true
        response::HTTP.Response = HTTP.get(source)
        html_content *= Base.String(response.body)
    else
        html_content *= Base.read(source, String)
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
$read_docstrings
"""
function read(
    source::String,
    sink;
    id::String="",
    classes::Union{Vector{String},String}="",
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
$readall_docstrings
"""
function readall(source::String, sink)
    tables = getall(source)
    results = Vector{Any}(undef, length(tables))

    for (i, table) in pairs(tables)
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
