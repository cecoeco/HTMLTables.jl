# HTMLTables

Julia package for reading, writing, and viewing HTML tables.

Reading HTML tables:
- `HTMLTables.get` reads an HTML table as a string.
- `HTMLTables.read` extracts data from HTML tables.

Writing HTML tables:
- `HTMLTables.table` uses the Tables.jl interface to write an HTML table as a string.
- `HTMLTables.write` uses the Tables.jl interface to write an HTML table in a file.

Viewing HTML tables:
- `HTMLTables.display` displays a julia table as an HTML table in julia.
- `HTMLTables.open` opens a julia table as an HTML table in the browser.

## License
Copyright © 2024 Ceco Elijah Maples

This work is licensed under the [MIT License](https://opensource.org/license/mit/) - see the [`LICENSE`](LICENSE.md) file for details.