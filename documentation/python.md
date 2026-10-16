# Python Development Guide

This configuration provides a complete Python and Jupyter/Quarto workflow powered by `pyright`, `ruff`, `conform.nvim`, `venv-selector.nvim`, `nvim-dap` (`debugpy`), `neotest` (`pytest`), and `molten-nvim` / `quarto-nvim` / `jupytext.nvim`.

---

## 1. Running & Virtual Environments

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>vs` | Normal | **Select Python Venv** | Opens Telescope picker (`venv-selector.nvim`) to choose a virtual environment. Automatically syncs `pyright`, `dap-python`, `neotest-python`, and `molten-nvim`. |
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

## 5. Jupyter & Quarto Notebooks (`molten-nvim` + `quarto-nvim`)

`.ipynb` files are automatically converted in-memory to Quarto `.qmd` buffers via `jupytext.nvim` with per-chunk Python LSP via `otter.nvim`. All notebook keybindings use the `<leader>j` (`+jupyter`) prefix.

### Kernel & Output Management (`.py` and `.ipynb` / `.qmd`)

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>ji` | Normal | **Init Molten Kernel** | Initializes and attaches a Jupyter kernel to the buffer (auto-runs when selecting a venv with `<leader>vs` if `ipykernel` is registered). |
| `<leader>jr` | Normal | **Restart Kernel** | Restarts the attached Jupyter kernel. |
| `<leader>jq` | Normal | **Stop Molten** | Deinitializes Molten for the current buffer. |
| `<leader>jo` | Normal | **Enter Output Window** | Moves the cursor into the floating cell output window so you can scroll or copy text. |
| `<leader>jy` | Normal | **Yank Output** | Copies the current cell's output to the system clipboard. |
| `<leader>jh` | Normal | **Hide Output** | Hides the floating cell output window. |
| `<leader>jd` | Normal | **Delete Cell Output** | Clears the current cell's evaluated output. |

### Code Execution

| Keybinding | Mode | Context | Action | Description |
|------------|------|---------|--------|-------------|
| `<leader>jc` | Normal | `.ipynb` / `.qmd` | **Run Cell** | Evaluates the current `{python}` code chunk via Quarto/Molten. |
| `<leader>ja` | Normal | `.ipynb` / `.qmd` | **Run Cell & Above** | Evaluates all chunks up to and including the current chunk. |
| `<leader>jA` | Normal | `.ipynb` / `.qmd` | **Run All Cells** | Evaluates all chunks in the notebook. |
| `<leader>jl` | Normal | `.py` / `.ipynb` / `.qmd` | **Run Line** | Evaluates the current line. |
| `<leader>jv` | Visual | `.py` / `.ipynb` / `.qmd` | **Run Visual Selection** | Evaluates the visually selected code. |
| `<leader>je` | Normal | `.py` / `.ipynb` / `.qmd` | **Evaluate Operator** | Operator-pending evaluation (e.g., `<leader>jeaf` to evaluate a function). |
| `]j` | Normal | `.ipynb` / `.qmd` | **Next Cell** | Jumps to the start of the next code chunk. |
| `[j` | Normal | `.ipynb` / `.qmd` | **Previous Cell** | Jumps to the start of the previous code chunk. |

> **Tip:** To enable automatic kernel attachment when switching virtual environments with `<leader>vs`, register `ipykernel` once inside that venv:
> ```bash
> python -m ipykernel install --user --name=<project-venv-name>
> ```
> For inline plot rendering via `image.nvim`, ensure ImageMagick is installed (`brew install imagemagick`).

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
