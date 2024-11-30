<div>
<a href="https://github.com/cecoeco/HTMLTables.jl/actions/workflows/CI.yml"><img alt="CI test" src="https://github.com/cecoeco/HTMLTables.jl/actions/workflows/CI.yml/badge.svg"></a>
<a href="https://zenodo.org/doi/10.5281/zenodo.11253769"><img src="https://zenodo.org/badge/779591300.svg" alt="DOI"></a>
<a href="https://cecoeco.github.io/HTMLTables.jl/dev/"><img src="https://img.shields.io/badge/docs-dev-blue.svg" alt="Documentation Dev"></a>
<a href="https://juliapkgstats.com/pkg/HTMLTables"><img src="https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Ftotal_downloads%2FHTMLTables&query=total_requests&label=Downloads" alt="Package Statistics"></a>
<a href="https://github.com/JuliaDiff/BlueStyle"><img alt="Style: Blue" src="https://img.shields.io/badge/code%20style-blue-4495d1.svg"></a>

</div>

# HTMLTables

<i>Julia package for reading and writing HTML tables.</i>

**Installation:** use this command in the Julia REPL: `using Pkg; Pkg.add("HTMLTables")`

**Examples:**

create an HTML table using a `DataFrame`:

```julia
using HTMLTables, DataFrames

df = DataFrame(x=[10, 40, 70], y=[20, 50, 80], z=[30, 60, 90])

writetable(stdout, df, theme=nothing, footer=false)
```

output:

<table>
<thead>
<tr>
<td>x</td>
<td>y</td>
<td>z</td>
</tr>
</thead>
<tbody>
<tr>
<td title="10">10</td>
<td title="20">20</td>
<td title="30">30</td>
</tr>
<tr>
<td title="40">40</td>
<td title="50">50</td>
<td title="60">60</td>
</tr>
<tr>
<td title="70">70</td>
<td title="80">80</td>
<td title="90">90</td>
</tr>
</tbody>
</table>

create a `DataFrame` from parsing HTML:

```julia
using HTMLTables, DataFrames

url = "https://www.w3schools.com/html/html_tables.asp"

df = readtable(url, DataFrame)

println(df)
```

output:

```
6×3 DataFrame
 Row │ Company                       Contact           Country
     │ String                        String            String
─────┼─────────────────────────────────────────────────────────
   1 │ Alfreds Futterkiste           Maria Anders      Germany
   2 │ Centro comercial Moctezuma    Francisco Chang   Mexico
   3 │ Ernst Handel                  Roland Mendel     Austria
   4 │ Island Trading                Helen Bennett     UK
   5 │ Laughing Bacchus Winecellars  Yoshi Tannamuri   Canada
   6 │ Magazzini Alimentari Riuniti  Giovanni Rovelli  Italy
```
