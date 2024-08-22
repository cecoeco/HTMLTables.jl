using Test, HTMLTables, DataFrames

const CSS_DIR::String = joinpath(dirname(@__FILE__), "css")
const HTML_DIR::String = joinpath(dirname(@__FILE__), "html")

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