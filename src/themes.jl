const BASIC_TABLE_STYLING::String = """
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
$BASIC_TABLE_STYLING

table {
  background-color: white;
}

tfoot {
  display: none;
}
"""

const RED::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background-color: hsl(0, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(0, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(0, 100%, 85%);
}
"""

const ORANGE::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background-color: hsl(25, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(25, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(25, 100%, 85%);
}

"""

const YELLOW::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background-color: hsl(60, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(60, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(60, 100%, 85%);
}
"""

const GREEN::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background-color: hsl(115, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(115, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(115, 100%, 85%);
}
"""

const BLUE::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background-color: hsl(205, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(205, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(205, 100%, 85%);
}
"""

const VIOLET::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background-color: hsl(260, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(260, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(260, 100%, 85%);
}
"""

const MAGENTA::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background-color: hsl(320, 100%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(320, 100%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(320, 100%, 85%);
}
"""

const BROWN::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background-color: hsl(20, 40%, 50%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(20, 40%, 65%);
}

tbody tr:nth-child(even) {
  background-color: hsl(20, 40%, 75%);
}
"""

const GRAY::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background-color: hsl(0, 0%, 60%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(0, 0%, 75%);
}

tbody tr:nth-child(even) {
  background-color: hsl(0, 0%, 85%);
}
"""

const BLACK::String = """
table {
  font-family: Helvetica;
  font-size: 15px;
  color: white;
  border: 0;
  border-spacing: 0;
  border-collapse: collapse;
  border-top: 1px solid white;
  border-bottom: 1px solid white;
  cursor: default;
}

caption {
  caption-side: top;
  padding: 10px;
}

thead {
  font-weight: bold;
  border-bottom: 1px solid white;
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
  border-top: 1px solid white;
}

thead, tfoot {
  background-color: hsl(0, 0%, 0%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(0, 0%, 10%);
}

tbody tr:nth-child(even) {
  background-color: hsl(0, 0%, 20%);
}
"""

const GOLD::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background: linear-gradient(135deg, #FFD700 0%, #FFFACD 100%);
}

tbody tr:nth-child(odd) {
  background: linear-gradient(135deg, #FFF8DC 0%, #FFD700 100%);
}

tbody tr:nth-child(even) {
  background: linear-gradient(135deg, #FFFACD 0%, #FFD700 100%);
}
"""

const SILVER::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background: linear-gradient(135deg, #C0C0C0 0%, #E0E0E0 100%);
}

tbody tr:nth-child(odd) {
  background: linear-gradient(135deg, #D3D3D3 0%, #C0C0C0 100%);
}

tbody tr:nth-child(even) {
  background: linear-gradient(135deg, #E0E0E0 0%, #C0C0C0 100%);
}
"""

const BRONZE::String = """
$BASIC_TABLE_STYLING

thead, tfoot {
  background: linear-gradient(135deg, #CD7F32 0%, #F4A460 100%);
}

tbody tr:nth-child(odd) {
  background: linear-gradient(135deg, #D2B48C 0%, #CD7F32 100%);
}

tbody tr:nth-child(even) {
  background: linear-gradient(135deg, #F4A460 0%, #CD7F32 100%);
}
"""

const JULIA::String = """
@import url("https://fonts.googleapis.com/css2?family=Arya:wght@400;700");

$BASIC_TABLE_STYLING

table {
	font-size: 15px;
	color: #222222;
	background-color: white;
}

thead, tfoot {
	font-family: "Arya";
	background-color: #a270ba;
}
"""

const SUNSTONE::String = """
@import url('https://fonts.googleapis.com/css2?family=Caladea:ital,wght@0,400;0,700;1,400;1,700&display=swap');

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
"""

const MOONSTONE::String = """
@import url('https://fonts.googleapis.com/css2?family=Caladea:ital,wght@0,400;0,700;1,400;1,700&display=swap');

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
"""

# https://draculatheme.com/
const DRACULA::String = """
$BASIC_TABLE_STYLING

thead {
  color: #bd93f9;
}

thead, tfoot {
  background-color: hsl(232, 15%, 18%);
}

tbody tr:nth-child(odd) {
  background-color: hsl(232, 15%, 31%);
}

tbody tr:nth-child(even) {
  background-color: hsl(232, 15%, 25%);
}
"""

# https://ethanschoonover.com/solarized/
const SOLARIZED::String = """
$BASIC_TABLE_STYLING

thead {
  color: #2aa198;
}

thead, tfoot, tbody tr:nth-child(odd) {
  background-color: hsl(45, 81%, 95%);
}

tbody tr:nth-child(even) {
  background-color: hsl(45, 41%, 90%);
}
"""
