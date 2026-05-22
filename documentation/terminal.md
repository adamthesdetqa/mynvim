# 🖥️ Terminal Guide

This configuration uses `snacks.nvim` to provide a modern, integrated terminal experience.

## Keybindings

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<C-/>` | Normal, Terminal | **Toggle Terminal** | Opens/closes a floating terminal window. |
| `<leader>ft` | Normal, Terminal | **Toggle Terminal** | Alternative shortcut to toggle the terminal. |
| `jk` | Terminal | **Exit Terminal Mode** | Switches from Terminal mode to Normal mode (allows navigation). |
| `:term <cmd>` | Command | **Run Command** | Built-in Neovim command to run a process in a buffer. |
| `:! <cmd>` | Command | **External Command** | Runs a shell command and displays output in a temporary pager. |

---

## Usage Tips

### 1. Navigating the Terminal
By default, typing in the terminal sends characters to the shell. To scroll back through history or switch windows, you must enter **Normal Mode**:
- Press **`jk`** (as configured) or **`<C-\><C-n>`** (Neovim default).
- Once in Normal Mode, you can use `;`, `l`, `k`, `j` (your custom navigation) to move around the buffer.
- To start typing again, press **`i`** or **`a`**.

### 2. Closing the Terminal
- To hide the terminal but keep the process running: Toggle it with `<C-/>`.
- To kill the terminal process: Type `exit` in the shell or use `:q` while in Normal Mode.

### 3. Running One-off Tasks
If you just need to run a quick command like `ls` or `npm install` without keeping a terminal open:
```vim
:!npm install
```

### 4. Split Terminals
If you prefer a terminal in a split window instead of a floating one, you can use the built-in command:
```vim
:vsplit | term
```
