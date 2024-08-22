<div>
<a href="https://github.com/cecoeco/HTMLTables.jl/actions/workflows/CI.yml"><img alt="CI test" src="https://github.com/cecoeco/HTMLTables.jl/actions/workflows/CI.yml/badge.svg"></a>
<a href="https://zenodo.org/doi/10.5281/zenodo.11253769"><img src="https://zenodo.org/badge/779591300.svg" alt="DOI"></a>
<a href="https://juliapkgstats.com/pkg/HTMLTables"><img src="https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Fmonthly_downloads%2FHTMLTables&query=total_requests&suffix=%2Fmonth&label=Downloads" alt="Package Statistics"></a>
<a href="https://github.com/JuliaDiff/BlueStyle"><img alt="Style: Blue" src="https://img.shields.io/badge/code%20style-blue-4495d1.svg"></a>

</div>

# HTMLTables

<i>Julia package for reading and writing HTML tables.</i>

:book: **Documentation:** <a href="https://cecoeco.github.io/HTMLTables.jl/stable/"><img src="https://img.shields.io/badge/docs-stable-aquamarine.svg" alt="Documentation Stable" /></a> <a href="https://cecoeco.github.io/HTMLTables.jl/dev/"><img src="https://img.shields.io/badge/docs-dev-aquamarine.svg" alt="Documentation Dev"></a>

:arrow_down: **Installation:** use this command in the Julia REPL: `using Pkg; Pkg.add("HTMLTables")`

**Examples:**

create an HTML table using a `DataFrame`:

```julia
using HTMLTables, DataFrames

df = DataFrame([i:i+19 for i in 1:20:501], Symbol.("a":"z"))

HTMLTables.write("viridis.html", df, colorscale="viridis")
```

output:

![viridis table example](docs/src/assets/viridis-a-z.png)

create a `DataFrame` from parsing HTML:

```julia
using HTMLTables, DataFrames

url = "https://www.w3schools.com/html/html_tables.asp"

df = HTMLTables.read(url, DataFrame)

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
