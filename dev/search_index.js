var documenterSearchIndex = {"docs":
[{"location":"#HTMLTables","page":"Home","title":"HTMLTables","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"HTMLTables.HTMLTables","category":"page"},{"location":"#HTMLTables.HTMLTables","page":"Home","title":"HTMLTables.HTMLTables","text":"HTMLTables\n\nJulia package for reading and writing HTML tables using the Tables.jl interface\n\nexported functions:\n\nreadtable: reads an HTML table into a Tables.jl-compatible table like a DataFrame.\nwritetable: converts a Tables.jl-compatible table to an HTML table and writes it to a file or IO stream.\n\n\n\n\n\n","category":"module"},{"location":"reading/#Reading","page":"Reading","title":"Reading","text":"","category":"section"},{"location":"reading/","page":"Reading","title":"Reading","text":"HTMLTables.readtable","category":"page"},{"location":"reading/#HTMLTables.readtable","page":"Reading","title":"HTMLTables.readtable","text":"readtable(\n    source,\n    sink=nothing;\n    header::Bool=true,\n    id::Union{Nothing,String}=nothing,\n    class::Union{Nothing,String,Vector{String}}=nothing,\n    index::Int=1,\n    number_type::Type=Any\n)\n\nReads an HTML table into a sink function such as DataFrame.\n\nArguments\n\nsource: URL or path to the HTML table.\nsink: the function that materializes the table data.\n\nKeyword Arguments\n\nheader::Bool: whether to include the table header.\nid::String: the id of the HTML table in the HTML document.\nclass::Union{String,Vector{String}}: the class of the HTML table.\nindex::Int: the index of the HTML table in the HTML document.\nnumber_type::Type: the return type of the numeric table data.\n\nReturns\n\nsink: the sink function such as DataFrame with the HTML table data if sink is specified.\ntuples::Vector: the table data if sink is not specified and the header keyword argument is false.\nheaders::Vector: the table headers if sink is not specified and the header keyword argument is true.\n\nExamples\n\nreading an HTML table from a website into a DataFrame:\n\nusing HTMLTables, DataFrames\n\nurl = \"https://www.w3schools.com/html/html_tables.asp\"\n\ndf = readtable(url, DataFrame)\n\nprintln(df)\n\n6×3 DataFrame\n Row │ Company                       Contact           Country\n     │ String                        String            String\n─────┼─────────────────────────────────────────────────────────\n   1 │ Alfreds Futterkiste           Maria Anders      Germany\n   2 │ Centro comercial Moctezuma    Francisco Chang   Mexico\n   3 │ Ernst Handel                  Roland Mendel     Austria\n   4 │ Island Trading                Helen Bennett     UK\n   5 │ Laughing Bacchus Winecellars  Yoshi Tannamuri   Canada\n   6 │ Magazzini Alimentari Riuniti  Giovanni Rovelli  Italy\n\nreading the second HTML table from a file into a DataFrame:\n\nusing HTMLTables, DataFrames\n\nurl = \"tables.html\"\n\ndf = readtable(url, DataFrame, index=2)\n\nprintln(df)\n\n4×2 DataFrame\n Row │ Name       Age\n     │ String     String\n─────┼─────────────────\n   1 │ Bob         25\n   2 │ Charlie     35\n   3 │ Alice       30\n   4 │ David       40\n\nreading an HTML table with the id \"htmltable\" from a string into a DataFrame:\n\nusing HTMLTables, DataFrames\n\nhtml_str = \"\"\"\n<table id=\"htmltable\">\n  <tr>\n    <th>Name</th>\n    <th>Age</th>\n  </tr>\n  <tr>\n    <td>Bob</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td>Charlie</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td>Alice</td>\n    <td>30</td>\n  </tr>\n  <tr>\n    <td>David</td>\n    <td>40</td>\n  </tr>\n</table>\n\"\"\"\n\ndf = DataFrame(readtable(html_str, id=\"htmltable\", number_type=Int64))\n\nprintln(df)\n\n4×2 DataFrame\n Row │ Name       Age\n     │ String     Int64\n─────┼─────────────────\n   1 │ Bob         25\n   2 │ Charlie     35\n   3 │ Alice       30\n   4 │ David       40\n\nread the data from the HTML table as a vector of tuples:\n\nusing HTMLTables\n\nurl = \"tables.html\"\n\ntuples = readtable(url, number_type=Int64, header=false)\n\nprintln(tuples)\n\n[(\"Bob\", 25), (\"Charlie\", 35), (\"Alice\", 30), (\"David\", 40)]\n\nread the data from the HTML table as a matrix:\n\nusing HTMLTables, Tables\n\nurl = \"tables.html\"\n\nmtx = readtable(url, Tables.matrix; number_type=Int64, header=false)\n\nprintln(mtx)\n\nAny[\"Bob\" 25; \"Charlie\" 35; \"Alice\" 30; \"David\" 40]\n\n\n\n\n\n","category":"function"},{"location":"writing/#Writing","page":"Writing","title":"Writing","text":"","category":"section"},{"location":"writing/","page":"Writing","title":"Writing","text":"HTMLTables.writetable","category":"page"},{"location":"writing/#HTMLTables.writetable","page":"Writing","title":"HTMLTables.writetable","text":"writetable(\n    out,\n    tbl;\n    header::Bool=true,\n    footer::Bool=true,\n    id::Union{Nothing,String}=nothing,\n    class::Union{Nothing,String,Vector{String}}=nothing,\n    caption::Union{Nothing,String}=nothing,\n    editable::Bool=false,\n    tooltips::Bool=true,\n    js::Union{Nothing,String}=nothing,\n    css::Union{Nothing,String}=nothing,\n    theme::Union{Nothing,String,Symbol}=:default,\n    colorscale::Union{Nothing,String,Symbol}=nothing\n)\n\nUses the Tables.jl interface to write an HTML table.\n\nArguments\n\nout: accepts the same types as Base.write. \ntbl: the table to write.\n\nKeyword Arguments\n\nheader::Bool: whether to include the table header.\nfooter::Bool: whether to include the table footer.\nid::Union{Nothing,String}: the id of the HTML table.\nclass::Union{Nothing,String,Vector{String}}: the class of the HTML table.\ncaption::Union{Nothing,String}: the caption of the HTML table.\neditable::Bool: whether to enable table editing.\ntooltips::Bool: whether to include tooltips.\njs::Union{Nothing,String}: the JavaScript of the HTML table.\ncss::Union{Nothing,String}: the CSS of the HTML table.\ntheme::Union{Nothing,Symbol,String}: the built-in theme of the HTML table.\ncolorscale::Union{Nothing,Symbol,String}: the colorscale from ColorSchemes.jl for numeric data.\n\nExamples\n\ncreates a simple HTML table from a DataFrame and writes it to the standard output:\n\nusing HTMLTables, DataFrames\n\ndf = DataFrame(x=[1, 2, 3], y=[45, 67, 89])\n\nwritetable(stdout, df, styles=false)\n\n<table>\n<thead>\n<tr>\n<td>x</td>\n<td>y</td>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td title=\"1\">1</td>\n<td title=\"45\">45</td>\n</tr>\n<tr>\n<td title=\"2\">2</td>\n<td title=\"67\">67</td>\n</tr>\n<tr>\n<td title=\"3\">3</td>\n<td title=\"89\">89</td>\n</tr>\n</tbody>\n<tfoot>\n<tr>\n<td></td>\n<td></td>\n</tr>\n</tfoot>\n</table>\n\ncreates a simple HTML table from a DataFrame and writes it to a file:\n\nusing HTMLTables, DataFrames\n\ndf = DataFrame(x=[1, 2, 3], y=[4, 11, 28])\n\nwritetable(\"table.html\", df)\n\n\n\n\n\n","category":"function"}]
}