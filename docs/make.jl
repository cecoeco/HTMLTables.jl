using Documenter: makedocs, HTML, deploydocs
using DocumenterCitations: CitationBibliography
using HTMLTables

pages::Vector{Pair{String,String}} = [
    "Home" => "index.md",
    "Reading" => "reading.md",
    "Writing" => "writing.md",
    "References" => "references.md"
]

makedocs(
    modules=[HTMLTables],
    format=HTML(assets=["src/assets/bib.css"]),
    pages=pages,
    repo="https://github.com/cecoeco/HTMLTables.jl",
    sitename="HTMLTables.jl",
    authors="Ceco Elijah Maples",
    plugins=[CitationBibliography(joinpath(dirname(@__FILE__), "src/assets/references.bib"), style=:authoryear)]
)

deploydocs(repo="github.com/cecoeco/HTMLTables.jl.git")
