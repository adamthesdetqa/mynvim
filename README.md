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
- **Git**: `Gitsigns` for inline status and `LazyGit` for full repository management.
- **Debugging**: `nvim-dap` with `nvim-dap-ui`.
- **Testing**: `neotest` with support for Jest (Angular) and Pytest.
- **AI**: GitHub Copilot and Copilot Chat integration.
- **UI**: `lualine` (statusline), `bufferline` (tabs), `alpha-nvim` (dashboard), and `nightfly` colorscheme.

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
- `<leader>nh`: Clear search highlights
- `<leader>+`: Increment number
- `<leader>-`: Decrement number
- `<leader>sm`: Maximize/Minimize split
- `<C-z>`: Center current line to top

### Terminal (snacks.nvim)
- `<C-/>`: Toggle Terminal
- `<leader>ft`: Toggle Terminal

### File Explorer (Neo-tree)
- `<leader>e`: Toggle Neo-tree

### Fuzzy Finder (Telescope)
- `<leader>ff`: Find files in CWD
- `<leader>fr`: Find recent files
- `<leader>fs`: Find string in CWD (Live Grep)
- `<leader>fc`: Find string under cursor
- `<leader>ft`: Find TODOs

### LSP (Language Server Protocol)
- `gR`: Show references (Telescope)
- `gd`: Show definitions (Telescope)
- `gi`: Show implementations (Telescope)
- `gt`: Show type definitions (Telescope)
- `gD`: Go to declaration
- `K`: Show documentation / Jump into hover window
- `<leader>ca`: Code actions (Normal & Visual)
- `<leader>rn`: Smart rename
- `<leader>D`: Show buffer diagnostics (Telescope)
- `<leader>d`: Show line diagnostics
- `[d`: Previous diagnostic
- `]d`: Next diagnostic
- `<leader>rs`: Restart LSP

### Git
- `<leader>gg`: Open LazyGit
- `]h`: Next hunk (Gitsigns)
- `[h`: Previous hunk (Gitsigns)

### Debugging (DAP)
- `<F5>`: Start/Continue
- `<F10>`: Step Over
- `<F11>`: Step Into
- `<F12>`: Step Out
- `<leader>db`: Toggle Breakpoint
- `<leader>du`: Toggle Debugger UI

### Testing (neotest)
- `<leader>lr`: Run Nearest test
- `<leader>ll`: Run Current File
- `<leader>lT`: Run Project
- `<leader>ls`: Toggle Summary
- `<leader>lo`: Show Output
- `<leader>lw`: Toggle Watch mode

### Copilot Chat
- `<leader>cc`: Toggle Copilot Chat
- `<leader>ce`: Explain selection (Visual)
- `<leader>cf`: Fix selection (Visual)
- `<leader>cd`: Generate Docs (Visual)

### Tabs & Windows
- `<leader>sv`: Split vertically
- `<leader>sh`: Split horizontally
- `<leader>se`: Equalize splits
- `<leader>sx`: Close current split
- `<leader>to`: New tab
- `<leader>tx`: Close current tab
- `<leader>tn`: Next tab
- `<leader>tp`: Previous tab
