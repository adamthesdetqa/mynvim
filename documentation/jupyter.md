# Jupyter Notebooks (`jupynvim`) Guide

This guide covers how to open, edit, run, and manage `.ipynb` Jupyter notebooks in Neovim using [`sheng-tse/jupynvim`](https://github.com/sheng-tse/jupynvim), customized for your `j`/`k`/`l`/`;` navigation layout and `<leader>j` prefix.

---

## 1. How to Edit Code in a Cell (The 3 Modes)

Just like VSCode or JupyterLab, `jupynvim` separates **navigating between cells** from **editing inside a cell**:

1. **Cell Command Mode (Blue left border — default when opening a `.ipynb`)**
   - The cursor is hidden and the whole cell is selected.
   - Use **`k`** (down) and **`l`** (up) to move from cell to cell.
2. **Cell Edit Mode — Normal (Green left border)**
   - Press **`Enter`** or **`i`** on a selected cell to enter **Cell Edit Mode**.
   - The cursor appears inside that cell, and the buffer becomes editable (`modifiable`).
   - Your normal Vim motions (`j` = left, `k` = down, `l` = up, `;` = right, `w`, `b`, `dd`, `ciw`, etc.) now work **inside that cell** and are clamped to the cell's boundaries so you don't accidentally bleed into adjacent cells.
3. **Insert Mode (Typing code)**
   - Once inside Cell Edit Mode, press **`i`** (insert before cursor), **`a`** (append after cursor), **`A`** (append at end of line), **`o`** (new line below), or **`O`** (new line above) to type code.
   - Tip: From **Cell Command Mode**, pressing **`I`**, **`A`**, **`o`**, or **`O`** jumps straight into Cell Edit Mode *and* performs that insert action in one step!

### Exiting Back Out
- **Insert Mode → Cell Edit (Normal) Mode:** Press **`jk`** (or `<Esc>`). You can now use normal-mode motions (`j`/`k`/`l`/`;`) inside the cell.
- **Cell Edit (Normal) Mode → Cell Command Mode:** Press **`<Esc>`**. The left border turns **blue** again, and `k`/`l` now jump between whole cells.
- **Save Notebook:** `:w` (writes directly back to the `.ipynb` file).

---

## 2. Cell Command Mode Shortcuts (Blue Border)

When in **Cell Command Mode** (press `<Esc>` from Normal mode if the border is green):

| Keybinding | Action | Description |
|------------|--------|-------------|
| `k` / `<Down>` | **Next Cell** | Move selection down to the next cell |
| `l` / `<Up>` | **Previous Cell** | Move selection up to the previous cell |
| `gg` / `G` | **First / Last Cell** | Jump to the very first or last cell in the notebook |
| `Enter` / `i` | **Edit Cell** | Enter Cell Edit Mode (Normal mode inside the cell) |
| `I` / `A` | **Insert at Line Start / End** | Enter Cell Edit Mode and start inserting at beginning (`I`) or end (`A`) of line |
| `o` / `O` | **Open Line Below / Above** | Enter Cell Edit Mode and open a new line below (`o`) or above (`O`) |
| `a` | **Add Cell Above** | Insert a new code cell above the current cell |
| `b` | **Add Cell Below** | Insert a new code cell below the current cell |
| `dd` | **Delete Cell** | Delete (and yank) the current cell |
| `yy` | **Yank Cell** | Copy the current cell |
| `p` / `P` | **Paste Cell Below / Above** | Paste the last yanked/deleted cell below (`p`) or above (`P`) |
| `u` | **Undo Cell Action** | Undo the last cell delete, insert, or move |
| `<Esc>` | **Clear Search Highlight** | Runs `:nohlsearch` |

---

## 3. Running Cells

Works in both **Command Mode** and **Edit Mode** (and `<S-CR>` / `<C-CR>` also work directly from **Insert Mode**):

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<S-CR>` | Normal, Insert | **Run Cell + Advance** | Executes the current cell and selects the next cell (auto-starts kernel if needed) |
| `<C-CR>` | Normal, Insert | **Run Cell (Stay)** | Executes the current cell and stays on it |
| `<leader>jc` | Normal | **Run Cell + Advance** | Leader key alternative to `<S-CR>` |
| `<leader>ja` | Normal | **Run All Above** | Executes all cells above the current cell |
| `<leader>jb` | Normal | **Run All Below** | Executes the current cell and all cells below it |
| `<leader>jA` | Normal | **Run All Cells** | Executes every code cell in the notebook |

---

## 4. Cell Management (`<leader>j`)

Works from Normal mode (whether in Command Mode or Edit Mode):

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `]c` / `[c` | Normal | **Next / Prev Cell** | Jump to the next or previous cell (stays in Edit Mode if already editing) |
| `]i` / `[i` | Normal | **Next / Prev Image Cell** | Jump to the next or previous cell containing a plot/image |
| `<leader>jo` | Normal | **Add Cell Below** | Insert a new cell below the current cell |
| `<leader>jO` | Normal | **Add Cell Above** | Insert a new cell above the current cell |
| `<leader>jd` | Normal | **Delete Cell** | Delete the current cell |
| `<leader>jk` | Normal | **Move Cell Down** | Swap the current cell with the cell below it (`k` = down) |
| `<leader>jl` | Normal | **Move Cell Up** | Swap the current cell with the cell above it (`l` = up) |
| `<leader>jm` | Normal | **Convert to Markdown** | Change the current cell type to Markdown |
| `<leader>jy` | Normal | **Convert to Code** | Change the current cell type to Code |

---

## 5. Kernel & Virtual Environment Management (`<leader>j` / `<leader>v`)

`jupynvim` automatically detects a `.venv` in your project directory (`auto_venv = true`). You can also switch virtual environments or kernels at any time:

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>ji` | Normal | **Start Kernel** | Starts the Jupyter kernel for this notebook |
| `<leader>jK` | Normal | **Pick Kernel** | Opens kernel picker (local `.venv` interpreters + registered kernelspecs) |
| `<leader>jr` | Normal | **Restart Kernel** | Restarts the running kernel (clears in-memory state) |
| `<leader>jI` | Normal | **Interrupt Kernel** | Sends `SIGINT` to stop a long-running cell |
| `<leader>jq` | Normal | **Stop Kernel** | Shuts down the kernel process |
| `<leader>vs` | Normal | **Select Python Venv** | Opens `venv-selector` and updates `jupynvim`, `pyright`, `dap`, and `neotest` |

---

## 6. Outputs, Plots & Display (`<leader>j`)

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>jf` | Normal | **Focus Cell Output** | Moves the cursor into the current cell's output region so you can scroll/yank text |
| `<leader>jF` | Normal | **Focus Cell Source** | Moves the cursor from the output region back into the cell's code editor |
| `<leader>je` | Normal | **Expand / Collapse Output** | Expands or collapses truncated cell output (>500 lines) |
| `<leader>jh` | Normal | **Hide / Show Output** | Collapses or restores the current cell's output section |
| `<leader>jL` | Normal | **Limit Output Lines** | Prompts for how many lines of output to display for the current cell |
| `<leader>jx` | Normal | **Clear Cell Output** | Clears the output of the current cell |
| `<leader>jX` | Normal | **Clear All Outputs** | Clears outputs across all cells in the notebook |
| `<leader>js` | Normal | **Save Image** | Saves the current cell's rendered plot/image to a `.png` file |
| `<leader>jD` | Normal | **Delete Image** | Deletes the current cell's rendered plot/image |
| `<leader>jR` | Normal | **Refresh Display** | Re-renders notebook cell borders and inline images |
| `gx` | Normal | **Open Link** | Opens the URL or file link under the cursor |

---

## 7. Useful Ex Commands

| Command | Description |
|---------|-------------|
| `:JupynvimStatus` | Shows active kernel status, Python interpreter path, and backend status |
| `:JupynvimKernels` | Lists available Jupyter kernelspecs and detected `.venv` environments |
| `:JupynvimInstall` | Re-downloads or builds the `jupynvim-core` Rust backend binary |
| `:JupynvimLog` | Opens the `jupynvim` log file for troubleshooting |
| `:checkhealth jupynvim` | Verifies `jupynvim-core`, `python3`, `ipykernel`, and terminal graphics support |
