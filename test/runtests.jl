module TestHTMLTables

using DataFrames, HTMLTables, Test

const DIR::String = Base.Filesystem.dirname(Base.@__FILE__)

const JS_DIR::String = Base.Filesystem.joinpath(DIR, "js")

const JS_FILE_01::String = Base.Filesystem.joinpath(JS_DIR, "example-01.js")
const JS_FILE_02::String = Base.Filesystem.joinpath(JS_DIR, "example-02.js")

const JS_STRING_01::String = Base.read(JS_FILE_01, String)
const JS_STRING_02::String = Base.read(JS_FILE_02, String)

const CSS_DIR::String = Base.Filesystem.joinpath(DIR, "css")

const CSS_FILE_01::String = Base.Filesystem.joinpath(CSS_DIR, "example-01.css")
const CSS_FILE_02::String = Base.Filesystem.joinpath(CSS_DIR, "example-02.css")

const CSS_STRING_01::String = Base.read(CSS_FILE_01, String)
const CSS_STRING_02::String = Base.read(CSS_FILE_02, String)

const HTML_DIR::String = Base.Filesystem.joinpath(DIR, "html")

const HTML_FILE_01::String = Base.Filesystem.joinpath(HTML_DIR, "example-01.html")
const HTML_FILE_02::String = Base.Filesystem.joinpath(HTML_DIR, "example-02.html")

const HTML_STRING_01::String = Base.read(HTML_FILE_01, String)
const HTML_STRING_02::String = Base.read(HTML_FILE_02, String)

const URL_01::String = "https://www.w3schools.com/html/html_tables.asp"

const GLOBAL_DF_01::DataFrame = HTMLTables.readtable(HTML_FILE_01, DataFrame)
const GLOBAL_DF_02::DataFrame = HTMLTables.readtable(HTML_FILE_02, DataFrame)

include("readtests.jl")
include("writetests.jl")

end