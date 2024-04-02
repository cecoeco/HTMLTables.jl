function read(
    source::String;
    id::Union{String,Missing}=missing,
    classes::Union{Vector{String},String,Missing}=missing
)
    is_url::Bool = Base.startswith(source, "http://") || Base.startswith(source, "https://")
    
    if is_url
        response = HTTP.get(source)
        html_content = String(response.body)
    else
        html_content = Base.read(source, String)
    end

    html::Gumbo.HTMLDocument = Gumbo.parsehtml(html_content)

    selector::String = ""
    if ismissing(id)
        if !ismissing(classes)
            if isa(classes, String)
                selector *= ".$classes"
            elseif isa(classes, Vector{String})
                selector *= join([".$cls" for cls in classes], ",")
            else
                throw(ArgumentError("classes must be a String or Vector{String}"))
            end
        end
    elseif !ismissing(id)
        selector *= "#$id"
    else
        throw(ArgumentError("id must be a String or missing"))
    end

    tables = eachmatch(Selector(selector), html.root)

    if !isempty(tables)
        table = tables[1]
        rows = eachmatch(Selector("tr"), table)
        headers = []
        data = []
        for (i, row) in enumerate(rows)
            cells = eachmatch(Selector("td,th"), row)
            if i == 1 && isempty(headers)
                headers = [nodeText(cell) for cell in cells]
            else
                push!(data, [nodeText(cell) for cell in cells])
            end
        end
        return DataFrame(data, Symbol.(headers))
    else
        return DataFrame()
    end
end

function readtbody(
    source::String;
    id::Union{String,Missing}=missing,
    classes::Union{Vector{String},String,Missing}=missing
)
    is_url::Bool = startswith(source, "http://") || startswith(source, "https://")

    if is_url
        response = HTTP.get(source)
        html_content = String(response.body)
    else
        html_content = Base.read(source, String)
    end

    html::Gumbo.HTMLDocument = parsehtml(html_content)

    selector::String = ""
    if ismissing(id)
        if !ismissing(classes)
            if isa(classes, String)
                selector *= ".$classes"
            elseif isa(classes, Vector{String})
                selector *= join([".$cls" for cls in classes], ",")
            else
                throw(ArgumentError("classes must be a String or Vector{String}"))
            end
        end
    elseif !ismissing(id)
        selector *= "#$id"
    else
        throw(ArgumentError("id must be a String or missing"))
    end

    tbody_elements = eachmatch(Selector("tbody$selector"), html.root)

    if !isempty(tbody_elements)
        tbody_element = tbody_elements[1]
        rows = eachmatch(Selector("tr"), tbody_element)
        data = []
        for row in rows
            cells = eachmatch(Selector("td,th"), row)
            push!(data, [nodeText(cell) for cell in cells])
        end

        return DataFrame(data, :auto)
    else
        return DataFrame()
    end
end
