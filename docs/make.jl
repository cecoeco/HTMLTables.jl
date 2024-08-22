using Documenter, DocumenterCitations, HTMLTables

Documenter.makedocs(
	modules = [HTMLTables],
	format = Documenter.HTML(assets = ["src/assets/bib.css"]),
	pages = [
		"Home" => "index.md",
		"Reading" => "reading.md",
		"Writing" => "writing.md",
		"References" => "references.md",
	],
	repo = "https://github.com/cecoeco/HTMLTables.jl",
	sitename = "HTMLTables.jl",
	authors = "Ceco Elijah Maples",
	plugins = [
		DocumenterCitations.CitationBibliography(
			Base.Filesystem.joinpath(
				Base.Filesystem.dirname(Base.@__FILE__),
				"src/assets/references.bib",
			),
			style = :authoryear,
		),
	],
)

Documenter.deploydocs(repo = "github.com/cecoeco/HTMLTables.jl.git")
