using Documenter
using DocumenterCitations
using HTMLTables

bib_filepath = Base.joinpath(Base.dirname(Base.@__FILE__), "src/assets/references.bib")
bib = DocumenterCitations.CitationBibliography(bib_filepath, style=:authoryear)

Documenter.makedocs(
    modules=[HTMLTables],
    format=Documenter.HTML(
        assets=[
            "src/assets/bib.css"
        ]
    ),
    pages=[
        "Home" => "index.md",
        "Reading" => "reading.md",
        "Writing" => "writing.md",
        "Viewing" => "viewing.md",
        "Examples" => "examples.md",
        "References" => "references.md"
    ],
    repo="https://github.com/cecoeco/HTMLTables.jl",
    sitename="HTMLTables.jl",
    authors="Ceco Elijah Maples",
    plugins=[bib]
)

Documenter.deploydocs(repo="github.com/cecoeco/HTMLTables.jl.git")
