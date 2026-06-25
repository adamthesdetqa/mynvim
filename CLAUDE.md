# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A personal Neovim configuration (Lua), targeting Node.js / Angular / TypeScript and Python development. Plugins are managed by **lazy.nvim**. There is no build step — changes to `.lua` files take effect on the next Neovim launch or config reload.

## Commands

There is no test suite or build for the config itself. Iterate by editing Lua and reloading:

- **Reload config + plugins in a running session:** `<leader>rc` (unloads every `setup*` Lua module via `package.loaded`, re-`dofile`s `$MYVIMRC`, then `Lazy reload`). Prefer this over `:source` — a plain `dofile` of individual modules will not pick up plugin spec changes.
- **Manage plugins:** `:Lazy` (sync/update/clean). Lock file is `lazy-lock.json`.
- **Manage LSP servers / tools:** `:Mason`. Servers and CLI tools are auto-installed on startup via `mason-lspconfig` and `mason-tool-installer` (see `lua/setup/lazy-init.lua`).
- **Format manually:** `<leader>mp` (conform.nvim). Format-on-save is enabled for all configured filetypes.

The root-level `test_*.lua` / `run_test.lua` files are throwaway debug scripts for the nvzone/menu border issue — not a test framework. Ignore them unless working on the context menu.

## Architecture

Load order is driven from `init.lua` → `require("setup")`:

1. **`lua/setup/init.lua`** — leader keys, Copilot accept maps, diagnostic signs, then requires `lazy-init`, `settings`, `keymaps`. **This file also defines the custom navigation remap and global autocommands** (see below).
2. **`lua/setup/lazy-init.lua`** — bootstraps lazy.nvim, imports plugin spec directories, and contains **all LSP configuration** (Mason setup, `vim.lsp.config`/`vim.lsp.enable` per server, plus the auto-import and autosave autocommands). LSP config lives here, not in a dedicated lsp plugin file.
3. **`lua/setup/settings.lua`** — vanilla `vim.opt` options (2-space indent, folds via foldlevel 99, system clipboard, `exrc` enabled).
4. **`lua/setup/keymaps.lua`** — general keymaps plus the `LspAttach` autocommand that sets all buffer-local LSP keybinds (`gd`, `gR`, `<leader>ca`, etc.).

### Plugin specs

`lua/setup/lazy/` holds one file per plugin (each returns a lazy.nvim spec table). They are auto-imported by directory in `lazy-init.lua`:

- `lazy/` (root) — core editor plugins (cmp, conform, telescope, treesitter, copilot, gitsigns…)
- `lazy/ui/` — UI plugins (lualine, bufferline, neo-tree, noice, snacks, alpha, menu…)
- `lazy/debugging/` — neotest, coverage
- `lazy/mappings/` — plugins whose value is mainly keymaps (fff, substitute, surround)
- `lazy/windows/` — lazygit, tmux-navigator, trouble
- `lazy/langs/` — language-specific specs (currently **not imported** — commented out in `lazy-init.lua`)

To add a plugin, drop a new `return { ... }` spec file into the matching directory; the directory import picks it up automatically.

### Completion & formatting

- Completion engine is **nvim-cmp** (`lazy/cmp.lua`). `lazy/completion.lua` is a fully commented-out blink.cmp alternative — nvim-cmp is the active one.
- Formatting is **conform.nvim** (`lazy/formatting.lua`): JS/TS/CSS/etc. try `dprint` first (only when a `dprint.json` exists upward), falling back to `prettier`; Lua uses `stylua`, Python uses `ruff`.

## Critical gotcha: custom HJKL navigation

`lua/setup/init.lua` **remaps the home-row movement keys** — this affects every keymap and any code you write that references motion keys:

- `j` → left, `k` → down, `l` → up, `;` → right (the default `h/j/k/l` motions are `<Nop>`-ed)
- Window nav: `<C-j>`/`<C-k>`/`<C-l>`/`<C-;>` = left/down/up/right
- Line delete: `dk` = delete line + line below, `dl` = delete line + line above

When adding plugin keymaps for navigation (e.g. inside floating windows or the nvzone menu), you must account for this layout — see `lazy/ui/menu.lua` for the pattern of re-binding `j/k/l/;` inside a plugin buffer.

## Conventions

- Indentation in this repo is **tabs** (stylua-formatted Lua); editor option `expandtab` applies to edited files, but the config's own `.lua` uses tabs — match the surrounding file.
- Commit messages follow Conventional Commits (`feat(scope):`, `fix(scope):`, `style(scope):`).
- Angular templates: `*.component.html` / `*.template.html` are forced to filetype `htmlangular` (autocommand in `init.lua`); `angularls` is configured for it in `lazy-init.lua`.
