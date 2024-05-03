function read(
    source::String;
    id::Union{String}="",
    classes::Union{Vector{String},String}=""
)
    if isurl(source)
        response::HTTP.Response = HTTP.get(source)
        html_content = Base.String(response.body)
    else
        html_content = Base.read(source, String)
    end

    html::Gumbo.HTMLDocument = Gumbo.parsehtml(html_content)

    selector::String = ""
    if id == ""
        if classes !== ""
            if Base.isa(classes, String)
                selector *= ".$classes"
            elseif Base.isa(classes, Vector{String})
                selector *= Base.join([".$cls" for cls in classes], ",")
            else
                Base.throw(Base.ArgumentError("classes must be a String or Vector{String}"))
            end
        end
    elseif id !== ""
        selector *= "#$id"
    else
        Base.throw(Base.ArgumentError("id must be a String or missing"))
    end

    tables = Base.eachmatch(Cascadia.Selector(selector), html.root)

    if !Base.isempty(tables)
        table = tables[1]
        rows = Base.eachmatch(Cascadia.Selector("tr"), table)
        headers = []
        data = []
        for (i, row) in Base.Iterators.enumerate(rows)
            cells = Base.eachmatch(Cascadia.Selector("td,th"), row)
            if i == 1 && Base.isempty(headers)
                headers = [Cascadia.nodeText(cell) for cell in cells]
            else
                Base.push!(data, [Cascadia.nodeText(cell) for cell in cells])
            end
        end
        return DataFrames.DataFrame(data, Symbol.(headers))
    else
        return DataFrames.DataFrame()
    end
end
