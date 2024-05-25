<div>
<a href="https://github.com/cecoeco/HTMLTables.jl/blob/main/LICENSE.md"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg"></a>
<a href="https://github.com/cecoeco/HTMLTables.jl/actions/workflows/CI.yml"><img alt="CI test" src="https://github.com/cecoeco/HTMLTables.jl/actions/workflows/CI.yml/badge.svg"></a>
<a href="https://github.com/JuliaDiff/BlueStyle"><img alt="Style: Blue" src="https://img.shields.io/badge/code%20style-blue-4495d1.svg"></a>
<a href="https://cecoeco.github.io/HTMLTables.jl/stable/"><img src="https://img.shields.io/badge/docs-stable-blue.svg" alt="Documentation Stable" /></a>
<a href="https://zenodo.org/doi/10.5281/zenodo.11253769"><img src="https://zenodo.org/badge/779591300.svg" alt="DOI"></a>
<a href="https://juliapkgstats.com/pkg/HTMLTables"><img src="https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Fmonthly_downloads%2FHTMLTables&query=total_requests&suffix=%2Fmonth&label=Downloads"></a>
<a href='https://www.contributor-covenant.org'><img src='https://img.shields.io/badge/Contributor%20Covenant-v2.1%20adopted-ff69b4.svg' alt='Contributor Covenant'></a>
</div>

Julia package for reading, writing, and viewing HTML tables.

Reading HTML tables:
- `HTMLTables.get` reads an HTML table as a string.
- `HTMLTables.read` extracts data from HTML tables.

Writing HTML tables:
- `HTMLTables.table` uses the Tables.jl interface to write an HTML table as a string.
- `HTMLTables.write` uses the Tables.jl interface to write an HTML table in an HTML file.
- `HTMLTables.jpg` writes an HTML table as a JPG image.
- `HTMLTables.pdf` writes an HTML table as a PDF document.
- `HTMLTables.png` writes an HTML table as a PNG image.

Viewing HTML tables:
- `HTMLTables.display` displays a julia table as an HTML table in julia.
- `HTMLTables.open` opens a julia table as an HTML table in the browser.

## License
Copyright © 2024 Ceco Elijah Maples

This work is licensed under the [MIT License](https://opensource.org/license/mit/) - see the [`LICENSE`](LICENSE.md) file for details.