const NORMALIZE::String = """
* {
  margin: 0;
  padding: 0;
}

html, body {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}
"""

const BASIC_STYLING::String = """
table {
  font-family: Helvetica;
  font-size: 15px;
  color: black;
  border: 0;
  border-spacing: 0;
  border-collapse: collapse;
  border-top: 1px solid black;
  border-bottom: 1px solid black;
  cursor: default;
}

caption {
  caption-side: top;
  padding: 10px;
}

thead {
  font-weight: bold;
  border-bottom: 1px solid black;
}

tbody td:hover {
  text-decoration: underline;
}

th, td {
  padding: 5px 10px;
  text-align: center;
}

tfoot {
  height: 20px;
  border-top: 1px solid black;
}
"""

const DEFAULT::String = """
<style>

$NORMALIZE

$BASIC_STYLING

table {
  background-color: white;
}

tfoot {
  display: none;
}
</style>
"""

const RED::String = """
<style>

$NORMALIZE

$BASIC_STYLING

thead {
  background-color: hsl(0, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(0, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(0, 100%, 85%);
}

tfoot {
  background-color: hsl(0, 100%, 65%);
}
</style>
"""

const ORANGE::String = """
<style>

$NORMALIZE

$BASIC_STYLING

thead {
  background-color: hsl(25, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(25, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(25, 100%, 85%);
}

tfoot {
  background-color: hsl(25, 100%, 65%);
}
</style>
"""

const YELLOW::String = """
<style>

$NORMALIZE

$BASIC_STYLING

thead {
  background-color: hsl(60, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(60, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(60, 100%, 85%);
}

tfoot {
  background-color: hsl(60, 100%, 65%);
}
</style>
"""

const GREEN::String = """
<style>

$NORMALIZE

$BASIC_STYLING

thead {
  background-color: hsl(115, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(115, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(115, 100%, 85%);
}

tfoot {
  background-color: hsl(115, 100%, 65%);
}
</style>
"""

const BLUE::String = """
<style>

$NORMALIZE

$BASIC_STYLING

thead {
  background-color: hsl(205, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(205, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(205, 100%, 85%);
}

tfoot {
  background-color: hsl(205, 100%, 65%);
}
</style>
"""

const VIOLET::String = """
<style>

$NORMALIZE

$BASIC_STYLING

thead {
  background-color: hsl(260, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(260, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(260, 100%, 85%);
}

tfoot {
  background-color: hsl(260, 100%, 65%);
}
</style>
"""

const MAGENTA::String = """
<style>

$NORMALIZE

$BASIC_STYLING

thead {
  background-color: hsl(320, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(320, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(320, 100%, 85%);
}

tfoot {
  background-color: hsl(320, 100%, 65%);
}
</style>
"""

const BROWN::String = """
<style>

$NORMALIZE

$BASIC_STYLING

thead {
  background-color: hsl(20, 40%, 50%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(20, 40%, 65%);
}

tbody tr:nth-child(even) {
  background-color: hsl(20, 40%, 75%);
}

tfoot {
  background-color: hsl(20, 40%, 55%);
}
</style>
"""

const GRAY::String = """
<style>

$NORMALIZE

$BASIC_STYLING

thead {
  background-color: hsl(0, 0%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(0, 0%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(0, 0%, 85%);
}

tfoot {
  background-color: hsl(0, 0%, 65%);
}
</style>
"""

const JULIA::String = """
<style>
@import url("https://fonts.googleapis.com/css2?family=Arya:wght@400;700");

$NORMALIZE

$BASIC_STYLING

table {
    font-size: 15px;
    color: #222222;
    background-color: white;
}

thead, tfoot {
    font-family: "Arya";
    background-color: #a270ba;
}
</style>
"""

const SUNSTONE::String = """
<style>
@import url('https://fonts.googleapis.com/css2?family=Caladea:ital,wght@0,400;0,700;1,400;1,700&display=swap');

$NORMALIZE

table {
  font-family: "Arial";
  font-size: 15px;
  color: hsl(20, 100%, 15%);
  border: 0;
  border-spacing: 0;
  border-collapse: collapse;
  border-top: 2px solid #ff8850;
  border-bottom: 2px solid #ff8850;
  cursor: default;
}

caption {
  caption-side: top;
  padding: 10px;
}

thead {
  font-family: "Caladea";
  font-weight: bold;
  border-bottom: 2px solid #ff8850;
  color: #fffdce
}

thead,
tfoot {
  height: 25px;
  min-height: 25px;
  background-color: #e16c52;
}

tbody td:hover {
  text-decoration: underline;
}

tbody tr:nth-child(odd) {
  background-color: #ffaf91;
}

tbody tr:nth-child(even) {
  background-color: #ee8c76;
}

th, td {
  padding: 5px 10px;
  text-align: center;
}

tfoot {
  border-top: 2px solid #ff8850;
}
</style>
"""

const MOONSTONE::String = """
<style>
@import url('https://fonts.googleapis.com/css2?family=Caladea:ital,wght@0,400;0,700;1,400;1,700&display=swap');

$NORMALIZE

table {
  font-family: "Arial";
  font-size: 15px;
  color: hsl(220, 100%, 20%);
  border: 0;
  border-spacing: 0;
  border-collapse: collapse;
  border-top: 2px solid #477edf;
  border-bottom: 2px solid #477edf;
  cursor: default;
}

caption {
  caption-side: top;
  padding: 10px;
}

thead {
  font-family: "Caladea";
  font-weight: bold;
  border-bottom: 2px solid #477edf;
  color: #fffdcc
}

thead,
tfoot {
  height: 25px;
  min-height: 25px;
  background-color: #88c3ff;
}

tbody td:hover {
  text-decoration: underline;
}

tbody tr:nth-child(odd) {
  background-color: #f5faff;
}

tbody tr:nth-child(even) {
  background-color: #c8e4ff;
}

th, td {
  padding: 5px 10px;
  text-align: center;
}

tfoot {
  border-top: 2px solid #477edf;
}
</style>
"""
