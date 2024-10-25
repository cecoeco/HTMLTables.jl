var documenterSearchIndex = {"docs":
[{"location":"#HTMLTables","page":"Home","title":"HTMLTables","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"HTMLTables.HTMLTables","category":"page"},{"location":"#HTMLTables.HTMLTables","page":"Home","title":"HTMLTables.HTMLTables","text":"HTMLTables\n\nJulia package for reading and writing HTML tables using the Tables.jl interface\n\nexported functions:\n\nHTMLTables.readtable: reads an HTML table into a Julia table such as a DataFrame.\nHTMLTables.writetable: converts a Julia table to an HTML table and writes it to a file or IO stream.\n\n\n\n\n\n","category":"module"},{"location":"reading/#Reading","page":"Reading","title":"Reading","text":"","category":"section"},{"location":"reading/","page":"Reading","title":"Reading","text":"HTMLTables.readtable","category":"page"},{"location":"reading/#HTMLTables.readtable","page":"Reading","title":"HTMLTables.readtable","text":"readtable(\n    source,\n    sink; \n    id::String=\"\", \n    class::Union{String,Vector{String}}=\"\",\n    index::Int=1\n)\n\nReads an HTML table into a sink function such as DataFrame.\n\nArguments\n\nsource: URL or path to the HTML table.\nsink: the function that materializes the table data.\n\nKeyword Arguments\n\nid::String: the id of the HTML table in the HTML document.\nclass::Union{String,Vector{String}}: the class of the HTML table.\nindex::Int: the index of the HTML table in the HTML document.\n\nReturns\n\nsink: the sink function such as DataFrame with the HTML table data.\n\nExamples\n\nreading an HTML table from a website into a DataFrame:\n\nusing HTMLTables, DataFrames\n\nurl = \"https://www.w3schools.com/html/html_tables.asp\"\n\ndf = HTMLTables.readtable(url, DataFrame)\n\nprintln(df)\n\n6×3 DataFrame\n Row │ Company                       Contact           Country\n     │ String                        String            String\n─────┼─────────────────────────────────────────────────────────\n   1 │ Alfreds Futterkiste           Maria Anders      Germany\n   2 │ Centro comercial Moctezuma    Francisco Chang   Mexico\n   3 │ Ernst Handel                  Roland Mendel     Austria\n   4 │ Island Trading                Helen Bennett     UK\n   5 │ Laughing Bacchus Winecellars  Yoshi Tannamuri   Canada\n   6 │ Magazzini Alimentari Riuniti  Giovanni Rovelli  Italy\n\nreading the second HTML table from a file into a DataFrame:\n\nusing HTMLTables, DataFrames\n\nurl = \"tables.html\"\n\ndf = HTMLTables.readtable(url, DataFrame, index=2)\n\nprintln(df)\n\n4×2 DataFrame\n Row │ Name       Age\n     │ String     Int64\n─────┼─────────────────\n   1 │ Bob         25\n   2 │ Charlie     35\n   3 │ Alice       30\n   4 │ David       40\n\nreading an HTML table with the id \"htmltable\" from a string into a DataFrame:\n\nusing HTMLTables, DataFrames\n\nhtml_str = \"\"\"\n<table id=\"htmltable\">\n  <tr>\n    <th>Name</th>\n    <th>Age</th>\n  </tr>\n  <tr>\n    <td>Bob</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td>Charlie</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td>Alice</td>\n    <td>30</td>\n  </tr>\n  <tr>\n    <td>David</td>\n    <td>40</td>\n  </tr>\n</table>\n\"\"\"\n\ndf = HTMLTables.readtable(html_str, DataFrame, id=\"htmltable\")\n\nprintln(df)\n\n4×2 DataFrame\n Row │ Name       Age\n     │ String     Int64\n─────┼─────────────────\n   1 │ Bob         25\n   2 │ Charlie     35\n   3 │ Alice       30\n   4 │ David       40\n\n\n\n\n\n","category":"function"},{"location":"writing/#Writing","page":"Writing","title":"Writing","text":"","category":"section"},{"location":"writing/","page":"Writing","title":"Writing","text":"HTMLTables.writetable","category":"page"},{"location":"writing/#HTMLTables.writetable","page":"Writing","title":"HTMLTables.writetable","text":"writetable(\n    out,\n    tbl;\n    header::Bool=true,\n    footer::Bool=true,\n    id::String=\"\",\n    class::Union{String,Vector{String}}=\"\",\n    caption::String=\"\",\n    editable::Bool=false,\n    tooltips::Bool=true,\n    styles::Bool=true,\n    css::String=\"\",\n    theme::Union{String,Symbol}=:default,\n    colorscale::Union{String,Symbol}=\"\"\n)\n\nUses the Tables.jl interface to write an HTML table.\n\nArguments\n\nout: accepts the same types as Base.write. \ntbl: the table to write.\n\nKeyword Arguments\n\nheader::Bool: whether to include the table header.\nfooter::Bool: whether to include the table footer.\nid::String: the id of the HTML table.\nclass::Union{String,Vector{String}}: the class of the HTML table.\ncaption::String: the caption of the HTML table.\neditable::Bool: whether to enable table editing.\ntooltips::Bool: whether to include tooltips.\nstyles::Bool: whether to include the CSS. If false css, theme and colorscale are ignored.\ncss::String: the path to the CSS file to include.\ntheme::Union{Symbol,String}: the theme of the HTML table.\ncolorscale::Union{Symbol,String}: the colorscale of the HTML table.\n\nExamples\n\ncreates a simple HTML table from a DataFrame and writes it to the standard output:\n\nusing HTMLTables, DataFrames\n\ndf = DataFrame(x=[1, 2, 3], y=[45, 67, 89])\n\nHTMLTables.writetable(stdout, df, styles=false)\n\n<table>\n<thead>\n<tr>\n<td>x</td>\n<td>y</td>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td title=\"1\">1</td>\n<td title=\"45\">45</td>\n</tr>\n<tr>\n<td title=\"2\">2</td>\n<td title=\"67\">67</td>\n</tr>\n<tr>\n<td title=\"3\">3</td>\n<td title=\"89\">89</td>\n</tr>\n</tbody>\n<tfoot>\n<tr>\n<td></td>\n<td></td>\n</tr>\n</tfoot>\n</table>\n\ncreates a simple HTML table from a DataFrame and writes it to a file:\n\nusing HTMLTables, DataFrames\n\ndf = DataFrame(x=[1, 2, 3], y=[4, 11, 28])\n\nHTMLTables.writetable(\"table.html\", df)\n\n\n\n\n\n","category":"function"}]
}
