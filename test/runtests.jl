module TestHTMLTables

using DataFrames, HTMLTables, Test

const DIR::String = Base.Filesystem.dirname(Base.@__FILE__)
const CSS_DIR::String = Base.Filesystem.joinpath(DIR, "css")
const HTML_DIR::String = Base.Filesystem.joinpath(DIR, "html")
const HTML_FILE_01::String = Base.Filesystem.joinpath(HTML_DIR, "example-01.html")
const HTML_FILE_02::String = Base.Filesystem.joinpath(HTML_DIR, "example-02.html")

include("read.jl")
include("write.jl")

end