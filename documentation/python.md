# Python Development Guide

This configuration provides a complete Python and Jupyter notebook workflow powered by `pyright`, `ruff`, `conform.nvim`, `venv-selector.nvim`, `nvim-dap` (`debugpy`), `neotest` (`pytest`), and [`jupynvim`](https://github.com/sheng-tse/jupynvim).

---

## 1. Running & Virtual Environments

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>vs` | Normal | **Select Python Venv** | Opens Telescope picker (`venv-selector.nvim`) to choose a virtual environment. Automatically syncs `pyright`, `dap-python`, `neotest-python`, and `jupynvim`. |
| `<leader>vc` | Normal | **Restore Cached Venv** | Re-activates the previously cached virtual environment for the current project. |
| `<leader>rr` | Normal | **Run Current File** | Runs the current file in an interactive floating terminal (`snacks.nvim`) using the active Python virtual environment (also works for JS, TS, Go, Lua, and Shell scripts). |

---

## 2. Formatting & Imports (`conform.nvim` + `ruff`)

Python files are automatically formatted and import-sorted on save via `ruff_format` and `ruff_organize_imports`.

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>mp` | Normal, Visual | **Format File / Range** | Manually runs `ruff_format` and `ruff_organize_imports` on the buffer or visual selection. |
| `<leader>co` | Normal | **Organize Imports** | Runs `ruff_organize_imports` (or `source.organizeImports` in TS/JS/Go). |

---

## 3. Debugging (`nvim-dap` + `dap-python`)

Uses Mason's isolated `debugpy` adapter while running your target code inside your active project virtual environment (`venv-selector` -> `$VIRTUAL_ENV` -> `.venv/bin/python` -> `python3`).

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<F5>` | Normal | **Continue / Start** | Starts debugging the current Python file or continues execution. |
| `<F6>` | Normal | **Pause** | Pauses the running debug thread. |
| `<F10>` | Normal | **Step Over** | Steps over the current line. |
| `<F11>` | Normal | **Step Into** | Steps into the function call. |
| `<F12>` | Normal | **Step Out** | Steps out of the current function. |
| `<leader>bb` | Normal | **Toggle Breakpoint** | Sets or removes a breakpoint on the current line. |
| `<leader>bc` | Normal | **Conditional Breakpoint** | Prompts for a condition and sets a conditional breakpoint. |
| `<leader>bl` | Normal | **Log Point** | Sets a log point that prints a message without pausing. |
| `<leader>br` | Normal | **Clear Breakpoints** | Removes all breakpoints in all buffers. |
| `<leader>bu` | Normal | **Toggle Debug UI** | Opens or closes the `nvim-dap-ui` panels. |
| `<leader>be` | Normal, Visual | **Evaluate Expression** | Evaluates the word under the cursor or visual selection in a floating window. |
| `<leader>bm` | Normal | **Debug Python Test Method** | Debugs the nearest Python test method via `dap-python`. |
| `<leader>bC` | Normal | **Debug Python Test Class** | Debugs the nearest Python test class via `dap-python`. |
| `<leader>bR` | Normal | **Run Last** | Re-runs the most recent debug session. |
| `<leader>bt` | Normal | **Terminate** | Stops the active debug session. |

---

## 4. Testing & Coverage (`neotest` + `pytest` + `nvim-coverage`)

All test and coverage keybindings live under the `<leader>l` (`+Test & Coverage`) prefix and use the active virtual environment's `pytest`.

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>lr` | Normal | **Run Nearest** | Runs the test function or class under the cursor. |
| `<leader>ld` | Normal | **Debug Nearest Test** | Runs the nearest test under the `nvim-dap` debugger. |
| `<leader>ll` | Normal | **Run File** | Runs all tests in the current Python file. |
| `<leader>lT` / `<leader>lA` | Normal | **Run Project / All** | Runs all tests in the current working directory. |
| `<leader>lL` | Normal | **Run Last** | Re-runs the last executed test. |
| `<leader>ls` | Normal | **Toggle Summary** | Opens/closes the test tree sidebar. |
| `<leader>lo` | Normal | **Show Output** | Opens a floating window with the test output. |
| `<leader>lO` | Normal | **Toggle Output Panel** | Toggles the persistent test output panel at the bottom. |
| `<leader>lw` | Normal | **Toggle Watch** | Watches the current file and re-runs tests on change. |
| `<leader>lS` | Normal | **Stop** | Stops the currently running test job. |
| `<leader>lc` | Normal | **Toggle Coverage Signs** | Shows or hides line coverage gutter signs. |
| `<leader>lC` | Normal | **Load & Show Coverage** | Loads `.coverage` / `lcov.info` and displays gutter signs. |
| `<leader>ly` | Normal | **Coverage Summary** | Opens a floating coverage report summary. |

---

## 5. Jupyter Notebooks (`jupynvim`)

Open any `.ipynb` file directly (`nvim notebook.ipynb`). `jupynvim` renders a VSCode-style cell view backed by a native Rust engine (`jupynvim-core`), auto-detects `.venv` (`auto_venv = true`) or uses the venv selected via `<leader>vs`, and renders inline plots directly in the terminal.

### Cell Command Mode vs. Edit Mode (Adapted to `j`/`k`/`l`/`;` Navigation)

Notebooks open in **Cell Command Mode** (left border is blue). Press `Enter` or `i` to enter **Cell Edit Mode** (left border turns green, motions stay clamped inside the current cell), and press `Esc` in Normal mode to return to **Cell Command Mode**:

| Keybinding | Mode | Action |
|------------|------|--------|
| `k` / `<Down>` | Command / Edit | **Next cell** (Command mode) / **Move down inside cell** (Edit mode) |
| `l` / `<Up>` | Command / Edit | **Previous cell** (Command mode) / **Move up inside cell** (Edit mode) |
| `Enter` / `i` / `I` / `A` / `o` / `O` | Command | **Enter Cell Edit Mode** |
| `Esc` | Normal (Edit) | **Return to Cell Command Mode** |
| `a` / `b` | Command | **Add cell above / below** |
| `dd` / `u` | Command | **Delete cell** / **Undo cell delete** |
| `yy` / `p` / `P` | Command | **Yank cell** / **Paste cell below / above** |
| `gg` / `G` | Command / Edit | **First / Last cell** (Command) or **First / Last line of cell** (Edit) |
| `]c` / `[c` | Normal | **Next / Previous cell** |
| `]i` / `[i` | Normal | **Next / Previous image cell** |

### Running Cells (`<leader>j`)

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<S-CR>` | Normal, Insert | **Run Cell + Advance** | Executes the current cell and advances to the next cell (auto-starts kernel if needed). |
| `<C-CR>` | Normal, Insert | **Run Cell (Stay)** | Executes the current cell and stays on it. |
| `<leader>jc` | Normal | **Run Cell + Advance** | Leader alternative to `<S-CR>`. |
| `<leader>ja` | Normal | **Run All Above** | Executes all cells above the current cell. |
| `<leader>jb` | Normal | **Run All Below** | Executes the current cell and all cells below it. |
| `<leader>jA` | Normal | **Run All Cells** | Executes every code cell in the notebook. |

### Cell & Kernel Management (`<leader>j`)

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>jo` / `<leader>jO` | Normal | **Add Cell Below / Above** | Inserts a new cell below or above the current cell. |
| `<leader>jd` | Normal | **Delete Cell** | Deletes the current cell. |
| `<leader>jk` / `<leader>jl` | Normal | **Move Cell Down / Up** | Moves the current cell down (`k`) or up (`l`). |
| `<leader>jm` / `<leader>jy` | Normal | **To Markdown / Code** | Converts the current cell to Markdown (`m`) or Code (`y`). |
| `<leader>ji` | Normal | **Start Kernel** | Starts the default/venv Jupyter kernel. |
| `<leader>jK` | Normal | **Pick Kernel** | Opens kernel selector (`.venv` + registered kernelspecs). |
| `<leader>jr` | Normal | **Restart Kernel** | Restarts the running kernel. |
| `<leader>jI` | Normal | **Interrupt Kernel** | Sends SIGINT to interrupt a running cell. |
| `<leader>jq` | Normal | **Stop Kernel** | Shuts down the kernel. |

### Outputs & Images (`<leader>j`)

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>jf` / `<leader>jF` | Normal | **Focus Output / Source** | Jumps cursor into the cell's output region (`jf`) or back to source (`jF`). |
| `<leader>je` | Normal | **Expand / Collapse Output** | Toggles truncated output expansion. |
| `<leader>jh` | Normal | **Hide / Show Output** | Collapses or restores the current cell's output. |
| `<leader>jL` | Normal | **Limit Output Lines** | Prompts for max visible output lines for the current cell. |
| `<leader>jx` / `<leader>jX` | Normal | **Clear Cell / All Outputs** | Clears the current cell's output (`jx`) or all outputs (`jX`). |
| `<leader>js` / `<leader>jD` | Normal | **Save / Delete Image** | Saves or deletes the current cell's rendered plot image. |
| `<leader>jR` | Normal | **Refresh Display** | Re-renders notebook borders and images. |

---

## 6. LSP & Code Navigation (`pyright` + `ruff`)

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `gd` / `<leader>gd` | Normal | **Go to Definition** | Opens symbol definitions in Telescope. |
| `gD` / `<leader>gD` | Normal | **Go to Declaration** | Jumps to symbol declaration. |
| `gR` / `<leader>gr` | Normal | **Show References** | Lists all references to the symbol in Telescope. |
| `gi` / `<leader>gi` | Normal | **Show Implementations** | Lists implementations in Telescope. |
| `gt` / `<leader>gt` | Normal | **Type Definitions** | Jumps to the type definition in Telescope. |
| `K` | Normal | **Hover Documentation** | Opens hover doc popup (press `K` again to focus the popup). |
| `<leader>ca` | Normal, Visual | **Code Actions** | Opens available LSP code actions (quick fixes, refactors). |
| `<leader>rn` | Normal | **Smart Rename** | Renames the symbol across the workspace. |
| `<leader>d` | Normal | **Line Diagnostics** | Shows floating diagnostic message for the current line. |
| `<leader>D` | Normal | **Buffer Diagnostics** | Lists all diagnostics in the current file via Telescope. |
| `[d` / `]d` | Normal | **Prev / Next Diagnostic** | Jumps to the previous or next diagnostic in the buffer. |
| `<leader>fd` | Normal | **Document Symbols** | Fuzzy-searches classes, functions, and variables in the file. |
| `<leader>rs` | Normal | **Restart LSP** | Restarts attached LSP servers (`:LspRestart`). |

---

## 7. Treesitter Python Textobjects & Motions

Works with operators like `d` (delete), `c` (change), `y` (yank), `v` (select), or `<leader>je` (Molten evaluate):

| Keybinding | Mode | Target / Action |
|------------|------|-----------------|
| `af` / `if` | Operator / Visual | Outer / Inner **function** (`def`) |
| `ac` / `ic` | Operator / Visual | Outer / Inner **class** (`class`) |
| `aa` / `ia` | Operator / Visual | Outer / Inner **parameter / argument** |
| `uc` | Operator / Visual | Comment block |
| `]m` / `[m` | Normal | Jump to next / previous **function start** |
| `]M` / `[M` | Normal | Jump to next / previous **function end** |
| `]]` / `[[` | Normal | Jump to next / previous **class start** |
| `][` / `[]` | Normal | Jump to next / previous **class end** |
| `<leader>a` / `<leader>A` | Normal | Swap parameter under cursor with **next / previous** parameter |
| `<C-Space>` / `<M-Space>` | Normal, Visual | Incrementally expand / shrink Treesitter syntax selection |
