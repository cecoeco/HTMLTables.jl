using Documenter, HTMLTables

Documenter.makedocs(
    modules=[HTMLTables],
    format=Documenter.HTML(),
    pages=["Home" => "index.md", "Reading" => "reading.md", "Writing" => "writing.md"],
    repo="https://github.com/cecoeco/HTMLTables.jl",
    sitename="HTMLTables.jl",
    authors="Ceco Elijah Maples",
)

Documenter.deploydocs(repo="github.com/cecoeco/HTMLTables.jl.git")
