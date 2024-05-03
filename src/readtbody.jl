function readtbody(
    source::String;
    id::Union{String,Missing}=missing,
    classes::Union{Vector{String},String,Missing}=missing
)
    is_url::Bool = Base.startswith(source, "http://") || Base.startswith(source, "https://")

    if is_url
        response = HTTP.get(source)
        html_content = Base.String(response.body)
    else
        html_content = Base.read(source, String)
    end

    html::Gumbo.HTMLDocument = Gumbo.parsehtml(html_content)

    selector::String = ""
    if Base.ismissing(id)
        if !Base.ismissing(classes)
            if Base.isa(classes, String)
                selector *= ".$classes"
            elseif Base.isa(classes, Vector{String})
                selector *= Base.join([".$cls" for cls in classes], ",")
            else
                Base.throw(Base.ArgumentError("classes must be a String or Vector{String}"))
            end
        end
    elseif !Base.ismissing(id)
        selector *= "#$id"
    else
        Base.throw(Base.ArgumentError("id must be a String or missing"))
    end

    tbody_elements = Base.eachmatch(Cascadia.Selector("tbody$selector"), html.root)

    if !Base.isempty(tbody_elements)
        tbody_element = tbody_elements[1]
        rows = Base.eachmatch(Cascadia.Selector("tr"), tbody_element)
        data = []
        for row in rows
            cells = Base.eachmatch(Cascadia.Selector("td,th"), row)
            Base.push!(data, [Cascadia.nodeText(cell) for cell in cells])
        end

        return DataFrames.DataFrame(data, :auto)
    else
        return DataFrames.DataFrame()
    end
end
