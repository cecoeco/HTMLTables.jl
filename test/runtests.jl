using Test
using HTMLTables
using DataFrames

df = DataFrame(x=1:10, y=1:10, z=1:10)

test_html = """
    <table>
        <thead>
            <tr>
                <th>x</th>
                <th>y</th>
                <th>z</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>1</td>
                <td>1</td>
            </tr>
            <tr>
                <td>2</td>
                <td>2</td>
                <td>2</td>
            </tr>
            <tr>
                <td>3</td>
                <td>3</td>
                <td>3</td>
            </tr>
            <tr>
                <td>4</td>
                <td>4</td>
                <td>4</td>
            </tr>
            <tr>
                <td>5</td>
                <td>5</td>
                <td>5</td>
            </tr>
            <tr>
                <td>6</td>
                <td>6</td>
                <td>6</td>
            </tr>
            <tr>
                <td>7</td>
                <td>7</td>
                <td>7</td>
            </tr>
            <tr>
                <td>8</td>
                <td>8</td>
                <td>8</td>
            </tr>
            <tr>
                <td>9</td>
                <td>9</td>
                <td>9</td>
            </tr>
            <tr>
                <td>10</td>
                <td>10</td>
                <td>10</td>
            </tr>
        </tbody>
    </table>
"""

@testset "HTMLTables.jl" begin
    HTMLTables.write("reds.html", df, colorscale="Reds")
    @test Base.Filesystem.isfile("reds.html")
    Base.Filesystem.rm("reds.html")

    HTMLTables.write("blues.html", df, colorscale="Blues")
    @test Base.Filesystem.isfile("blues.html")
    Base.Filesystem.rm("blues.html")

    HTMLTables.write("greens.html", df, colorscale="Greens")
    @test Base.Filesystem.isfile("greens.html")
    Base.Filesystem.rm("greens.html")

    HTMLTables.write("purples.html", df, colorscale="Purples")
    @test Base.Filesystem.isfile("purples.html")
    Base.Filesystem.rm("purples.html")

    Base.Filesystem.write("test.html", test_html)
    @test typeof(HTMLTables.read(test_html, DataFrame)) == DataFrame
    @test typeof(HTMLTables.read("test.html", DataFrame)) == DataFrame
    Base.Filesystem.rm("test.html")
end