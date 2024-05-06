function isurl(source::String)::Bool
    url_pattern::Regex = r"(?i)\b((?:https?|ftp):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?)\b"

    return Base.occursin(url_pattern, source)
end

"""
    HTMLTables.get(source::String; id::String="", classes::Union{Vector{String},String}="", index::Int=1)

Returns an HTML table a source as a string.

## Arguments

- `source::String`: URL or path to the HTML table.
- `id::String`: The id of the HTML table.
- `classes::Union{Vector{String},String}`: The classes of the HTML table.
- `index::Int`: The index of the HTML table in the HTML document.

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

    number_of_tables::Int = Base.length(tables)

    if number_of_tables == 0
        Base.throw(Base.ArgumentError("No HTML tables found"))
    elseif index > number_of_tables
        Base.throw(Base.ArgumentError("$number_of_tables table(s) found. Index $index does not exist."))
    end

    table::Gumbo.HTMLNode = tables[index]

    return table
end