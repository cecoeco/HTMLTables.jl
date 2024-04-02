sprint(df[row, col]) do io, element
    if showable(MIME"text/html"(), element)
        show(io, MIME"text/html"(), element)
    else
        show(io, element)
    end
end
