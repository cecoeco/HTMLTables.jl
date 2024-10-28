"""
# HTMLTables

Julia package for reading and writing HTML tables using the Tables.jl interface

## exported functions:

- `HTMLTables.readtable`: reads an HTML table into a Julia table such as a `DataFrame`.
- `HTMLTables.writetable`: converts a Julia table to an HTML table and writes it to a file or IO stream.

"""
module HTMLTables

using Cascadia, Colors, ColorSchemes, Gumbo, HTTP, Tables

export readtable, writetable

include("themes.jl")
include("readtable.jl")
include("writetable.jl")

using DataFrames: DataFrame

df = DataFrame(
    "a" => 001:020, "b" => 021:040,
    "c" => 041:060, "d" => 061:080,
    "e" => 081:100, "f" => 101:120,
    "g" => 121:140, "h" => 141:160,
    "i" => 161:180, "j" => 181:200,
    "k" => 201:220, "l" => 221:240,
    "m" => 241:260, "n" => 261:280,
    "o" => 281:300, "p" => 301:320,
    "q" => 321:340, "r" => 341:360,
    "s" => 361:380, "t" => 381:400,
    "u" => 401:420, "v" => 421:440,
    "w" => 441:460, "x" => 461:480,
    "y" => 481:500, "z" => 501:520
)

writetable("test.html", df, js="console.log('hello world');")

end
