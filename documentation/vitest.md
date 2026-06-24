# Vitest in Neovim

This configuration uses `neotest` with the `neotest-vitest` adapter to provide a seamless testing experience.

## Keybindings

All testing keybindings start with `<leader>l`:

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>lr` | Run Nearest | Runs the test or describe block under the cursor. |
| `<leader>ll` | Run File | Runs all tests in the current file. |
| `<leader>lL` | Run Last | Runs the last executed test again. |
| `<leader>ls` | Toggle Summary | Opens a sidebar showing test results and status. |
| `<leader>lo` | Show Output | Opens a floating window with the raw test output. |
| `<leader>lO` | Toggle Output Panel | Opens a panel at the bottom for live logs. |
| `<leader>lw` | Toggle Watch | Toggles watch mode for the current file. |
| `<leader>lS` | Stop | Stops the currently running test. |

## Features

- **Inline Diagnostics:** Failure messages appear as virtual text next to the failing code.
- **Fast Feedback:** Run specific tests without leaving the editor.
- **Automatic Detection:** Automatically detects Vitest projects via `vitest.config.ts` or `vite.config.ts`.

## Debugging Tests

To debug a Vitest test:
1. Set a breakpoint using `<leader>db`.
2. Run the test using `<leader>lr`.
3. If configured correctly in your project, `nvim-dap` will attach to the Vitest process.
