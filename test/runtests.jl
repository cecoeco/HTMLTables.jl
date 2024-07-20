using Test
using HTMLTables
using DataFrames

df = DataFrame(x=1:10, y=1:10, z=1:10)

@testset "HTMLTables.jl" begin
    HTMLTables.write(df, colorscale="Reds", out="reds.html")
    @test Base.Filesystem.isfile("reds.html")
    Base.Filesystem.rm("reds.html")

    HTMLTables.write(df, colorscale="Blues", out="blues.html")
    @test Base.Filesystem.isfile("blues.html")
    Base.Filesystem.rm("blues.html")

    HTMLTables.write(df, colorscale="Greens", out="greens.html")
    @test Base.Filesystem.isfile("greens.html")
    Base.Filesystem.rm("greens.html")

    HTMLTables.write(df, colorscale="Purples", out="purples.html")
    @test Base.Filesystem.isfile("purples.html")
    Base.Filesystem.rm("purples.html")

    HTMLTables.png(df, colorscale="viridis", out="viridis.png")
    @test Base.Filesystem.isfile("viridis.png")
    Base.Filesystem.rm("viridis.png")

    HTMLTables.pdf(df, colorscale="plasma", out="plasma.pdf")
    @test Base.Filesystem.isfile("plasma.pdf")
    Base.Filesystem.rm("plasma.pdf")

    HTMLTables.jpg(df, colorscale="magma", out="magma.jpg")
    @test Base.Filesystem.isfile("magma.jpg")
    Base.Filesystem.rm("magma.jpg")

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
    Base.Filesystem.write("test.html", test_html)
    @test typeof(HTMLTables.read(test_html, DataFrame)) == DataFrame
    @test typeof(HTMLTables.read("test.html", DataFrame)) == DataFrame
    Base.Filesystem.rm("test.html")
end