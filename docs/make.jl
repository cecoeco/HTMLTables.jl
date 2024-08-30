module DocsHTMLTables

using Documenter, HTMLTables

Documenter.makedocs(
    modules=[HTMLTables],
    format=Documenter.HTML(),
    pages=["Home" => "index.md", "Reading" => "reading.md", "Writing" => "writing.md"],
    sitename="HTMLTables.jl",
    authors="Ceco Elijah Maples",
)

Documenter.deploydocs(repo="github.com/cecoeco/HTMLTables.jl.git")

end