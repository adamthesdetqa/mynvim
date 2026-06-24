# Gitsigns

#  - gitsigns.nvim (in gitsigns.lua): The <leader>hs range-staging action is incorrectly bound in normal mode "n" using visual lines, overwriting the standard hunk stage mapping. It should be visual mode "v"new line

`gitsigns.nvim` provides inline Git integration directly in Neovim. It displays Git status indicators (signs) in the signcolumn (gutter) and allows you to interact with individual chunks of changes ("hunks") without using a separate Git interface.

## Keybindings

### Navigation

- **`]h`**: Jump to the next modified hunk.
- **`[h`**: Jump to the previous modified hunk.

### Hunk Management

- **`<leader>hs`**: Stage the hunk under the cursor (Normal mode) or stage selected lines (Visual mode).
- **`<leader>hr`**: Reset the hunk under the cursor (Normal mode) or reset selected lines (Visual mode).
- **`<leader>hu`**: Undo the last staging action.
- **`<leader>hS`**: Stage the entire buffer.
- **`<leader>hR`**: Reset the entire buffer.

### Inspection & Diffing

- **`<leader>hp`**: Preview the hunk under the cursor in a floating window.
- **`<leader>hb`**: Show a detailed git blame popup for the current line.
- **`<leader>hB`**: Toggle virtual text current-line blame.
- **`<leader>hd`**: Open a diff split against the index (the staged version).
- **`<leader>hD`**: Open a diff split against the last commit (`~`).

### Hunk Text Object

- **`ih`**: Inner hunk text object.
  - Useful for actions like:
    - **`vih`**: Visually select the current hunk.
    - **`dih`**: Delete the current hunk.
    - **`cih`**: Change the current hunk.

---

## Gutter Signs

In the gutter (next to the line numbers), you'll see the following markers:

- **Green line/plus**: Added lines.
- **Orange/Yellow line**: Modified lines.
- **Red dash/x**: Deleted lines.
