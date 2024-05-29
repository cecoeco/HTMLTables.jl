<div>
<a href="https://github.com/cecoeco/HTMLTables.jl/blob/main/LICENSE.md"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg"></a>
<a href="https://github.com/cecoeco/HTMLTables.jl/actions/workflows/CI.yml"><img alt="CI test" src="https://github.com/cecoeco/HTMLTables.jl/actions/workflows/CI.yml/badge.svg"></a>
<a href="https://github.com/JuliaDiff/BlueStyle"><img alt="Style: Blue" src="https://img.shields.io/badge/code%20style-blue-4495d1.svg"></a>
<a href="https://zenodo.org/doi/10.5281/zenodo.11253769"><img src="https://zenodo.org/badge/779591300.svg" alt="DOI"></a>
<a href="https://juliapkgstats.com/pkg/HTMLTables"><img src="https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Fmonthly_downloads%2FHTMLTables&query=total_requests&suffix=%2Fmonth&label=Downloads" alt="Package Statistics"></a>
<a href="https://www.contributor-covenant.org"><img src="https://img.shields.io/badge/Contributor%20Covenant-v2.1%20adopted-ff69b4.svg" alt="Contributor Covenant"></a>
</div>

## HTMLTables
<i>Julia package for reading, writing, and viewing HTML tables.</i>

### Documentation
<div>
<a href="https://cecoeco.github.io/HTMLTables.jl/stable/"><img src="https://img.shields.io/badge/docs-stable-blue.svg" alt="Documentation Stable" /></a>
<a href="https://cecoeco.github.io/HTMLTables.jl/dev/"><img src="https://img.shields.io/badge/docs-dev-blue.svg" alt="Documentation Dev"></a>
</div>

### Installation
Insert `using Pkg; Pkg.add("HTMLTables")` in the Julia REPL.

To install a version containing the latest committs simply use this command instead:
`using Pkg; Pkg.add(url="https://github.com/ceceoeco/HTMLTables.jl")`

### Functions
Reading HTML tables:
- `HTMLTables.get` reads an HTML table as a string based on the given index.
- `HTMLTables.getall` extracts all tables from an HTML document or website.
- `HTMLTables.read` extracts the data from an HTML table using a sink function.
- `HTMLTables.readall` extracts the data from all tables of an HTML document or website.

Writing HTML tables:
- `HTMLTables.table` uses the Tables.jl interface to write an HTML table as a string.
- `HTMLTables.write` uses the Tables.jl interface to write an HTML table in an HTML file.
- `HTMLTables.jpg` writes an HTML table as a JPG image.
- `HTMLTables.pdf` writes an HTML table as a PDF document.
- `HTMLTables.png` writes an HTML table as a PNG image.

Viewing HTML tables:
- `HTMLTables.display` displays a Julia table as an HTML table in a Julia IDE.
- `HTMLTables.open` opens a Julia table as an HTML table in the browser.

### License
Copyright © 2024 Ceco Elijah Maples

This work is licensed under the [MIT License](https://opensource.org/license/mit/) - see the [`LICENSE`](LICENSE.md) file for details.