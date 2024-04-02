using Documenter
using HTMLTables

Documenter.makedocs(
    modules=[HTMLTables],
    pages=[
        "Home" => "index.md",
        "Reading" => "reading.md",
        "Writing" => "writing.md",
        "Examples" => "examples.md",
    ],
    repo="https://github.com/cecoeco/HTMLTables.jl",
    sitename="HTMLTables.jl",
    authors="Ceco Elijah Maples",
    warnonly=Documenter.except(),
)

Documenter.deploydocs(repo="github.com/cecoeco/HTMLTables.jl.git")