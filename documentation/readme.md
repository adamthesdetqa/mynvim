# Neovim Configuration

A powerful, custom Neovim configuration built for modern development, featuring support for Angular, Python, and more.

## Architecture

This configuration is modular and managed by [Lazy.nvim](https://github.com/folke/lazy.nvim).

- **`init.lua`**: Entry point, loads the setup.
- **`lua/setup/`**: Core configuration logic.
    - `init.lua`: Main initialization, custom navigation remaps, and autocommands.
    - `settings.lua`: General Neovim options (UI, search, splits, etc.).
    - `keymaps.lua`: Global and LSP-related keybindings.
    - `lazy-init.lua`: Lazy.nvim bootstrap and plugin loading.
- **`lua/setup/lazy/`**: Plugin specifications and configurations.

## Core Features

- **LSP**: Configured with `nvim-lspconfig` and `Telescope` for code navigation and diagnostics.
- **File Explorer**: `Neo-tree` for a modern, sidebar-based file navigation.
- **Fuzzy Finder**: `Telescope` for finding files, strings, and more.
- **Terminal**: Integrated terminal support via `snacks.nvim`.
- **Git**: [Gitsigns](./gitsigns.md) for inline hunk status, staging, and blame.
- **Testing**: `neotest` with support for Jest (Angular), [Vitest](./vitest.md), and [Pytest](./python.md).
- **Python & Jupyter**: [Python Development Guide](./python.md) (`pyright`, `ruff`, `venv-selector`, `nvim-dap`, `molten-nvim` / `quarto-nvim`).
- **Syntax Selection**: [Treesitter Incremental Selection & Textobjects](./treesitter.md) for smart selection and deletion.
- **UI**: `lualine` (statusline), `bufferline` (tabs), `alpha-nvim` (dashboard), and `tokyonight` colorscheme.

---

## Keybindings

### Custom Navigation (HJKL Remap)
*This config uses a custom navigation layout:*
- `;` -> Right (`l`)
- `l` -> Up (`k`)
- `k` -> Down (`j`)
- `j` -> Left (`h`)

**Window Navigation:**
- `<C-j>`: Go to Left window
- `<C-k>`: Go to Down window
- `<C-l>`: Go to Up window
- `<C-;>`: Go to Right window

**Line Deletion:**
- `dk`: Delete current line and line below
- `dl`: Delete current line and line above

### General
- `jk`: Exit Insert/Terminal mode
- `<leader>?`: Show all keymaps (Which-Key)
- `<leader>nh`: Clear search highlights
- `<leader>nm`: Noice message history
- `<leader>+`: Increment number
- `<leader>-`: Decrement number
- `<leader>sm`: Maximize/Minimize split
- `<leader>rr`: Run current file (Python, JS, TS, Go, Lua, Shell)
- `<leader>rc`: Reload Neovim config
- `<C-z>`: Center current line to top

### Terminal (snacks.nvim)
- `<C-/>`: Toggle Terminal
- `<leader>ft`: Toggle Terminal

### File Explorer (Neo-tree)
- `<leader>e`: Toggle Neo-tree

### Fuzzy Finder (Telescope — `<leader>f`)
- `<leader>ff`: Find files in CWD
- `<leader>fr`: Find recent files
- `<leader>fb`: Find open buffers
- `<leader>fs`: Find string in CWD (Live Grep)
- `<leader>fc`: Find string under cursor
- `<leader>fd`: Find Document Symbols (LSP)
- `<leader>fw`: Find Workspace Symbols (LSP)
- `<leader>fh`: Find Help Tags
- `<leader>fk`: Find Keymaps
- `<leader>fT`: Find TODOs

### LSP & Code (`<leader>g` / `<leader>c` / `<leader>r` / `<leader>x`)
- `gd` / `<leader>gd`: Show definitions (Telescope)
- `gD` / `<leader>gD`: Go to declaration
- `gR` / `<leader>gr` / `<leader>gR`: Show references (Telescope)
- `gi` / `<leader>gi`: Show implementations (Telescope)
- `gt` / `<leader>gt`: Show type definitions (Telescope)
- `K`: Show documentation / Jump into hover window
- `<leader>ca`: Code actions (Normal & Visual)
- `<leader>co`: Organize imports (Python `ruff`, TS/JS/Go LSP)
- `<leader>cl`: LSP Info
- `<leader>cm`: Open Mason
- `<leader>mp`: Format file or range (Conform)
- `<leader>rn`: Smart rename
- `<leader>rs`: Restart LSP
- `<leader>d`: Show line diagnostics (Float)
- `<leader>D`: Show buffer diagnostics (Telescope)
- `[d` / `]d`: Previous / Next diagnostic
- `<leader>xx` / `<leader>xw`: Workspace diagnostics (Trouble)
- `<leader>xd`: Buffer diagnostics (Trouble)
- `<leader>xs`: Document symbols (Trouble)
- `<leader>xr`: LSP definitions / references (Trouble)

### Git Hunks (Gitsigns — `<leader>h`)
- `]h` / `[h`: Next / Previous hunk
- `<leader>hs` / `<leader>hr`: Stage / Reset hunk
- `<leader>hS` / `<leader>hR`: Stage / Reset buffer
- `<leader>hp`: Preview hunk
- `<leader>hb` / `<leader>hB`: Blame line / Toggle line blame
- `<leader>hd` / `<leader>hD`: Diff this

### Testing & Coverage (neotest & nvim-coverage — `<leader>l`)
- `<leader>lr`: Run Nearest test
- `<leader>ld`: Debug Nearest test (DAP)
- `<leader>ll`: Run Current File
- `<leader>lT` / `<leader>lA`: Run Project / All
- `<leader>lL`: Run Last test
- `<leader>ls`: Toggle Summary
- `<leader>lo` / `<leader>lO`: Show Output / Toggle Output Panel
- `<leader>lw`: Toggle Watch mode
- `<leader>lc` / `<leader>lC` / `<leader>ly`: Toggle / Load / Summary of Test Coverage

### Tabs, Splits & Tools
- `<leader>sv` / `<leader>sh`: Split vertically / horizontally
- `<leader>se` / `<leader>sx`: Equalize splits / Close current split
- `<leader>to` / `<leader>tx` / `<leader>tn` / `<leader>tp` / `<leader>tf`: New / Close / Next / Prev / Buffer to Tab
- `<leader>zc` / `<leader>zo`: Collapse comments / Expand all folds
- `<leader>md`: Toggle Markdown rendering
- `<leader>Ls` / `<leader>LS`: Start / Stop Live Server
- `<leader>od`: Toggle Database UI (Dadbod)
