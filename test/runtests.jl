module TestHTMLTables

using CSV
using DataFrames
using DataStructures
using HTMLTables
using HTTP
using JSON3
using JSONTables
using Statistics
using Random
using Tables
using Test
using XLSX

const CSS_DIR::String = Base.Filesystem.joinpath(
    Base.Filesystem.dirname(Base.@__FILE__), "css"
)

const HTML_DIR::String = Base.Filesystem.joinpath(
    Base.Filesystem.dirname(Base.@__FILE__), "html"
)

include("read/file.jl")
include("read/http.jl")
include("read/io.jl")
include("read/numbers.jl")
include("read/string.jl")

include("write/convert.jl")
include("write/css.jl")
include("write/file.jl")
include("write/io.jl")
include("write/string.jl")
include("write/table.jl")
include("write/write.jl")

end