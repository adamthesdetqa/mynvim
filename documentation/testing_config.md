# Testing the Neovim Configuration

The Neovim configuration itself contains unit tests and debug scripts located in the `tests/` directory.

## Running Plenary Busted Tests

We use `plenary.nvim`'s busted test runner to run unit tests (like `menu_neotree_spec.lua`).

### Pre-commit Git Hook

This repository is configured with a Git pre-commit hook that automatically runs all tests before allowing a commit. 

The hooks are stored in the `.githooks/` directory. If you are cloning this repository for the first time, you must tell Git to use this directory:
```bash
./.githooks/setup.sh
# OR manually: git config core.hooksPath .githooks
```

If tests fail, the commit will be aborted. You can bypass the hook in an emergency using `git commit --no-verify`.

### In Neovim
Open the test file and run:
```vim
:PlenaryBustedFile %
```
Or run a specific file directly from anywhere:
```vim
:PlenaryBustedFile tests/menu_neotree_spec.lua
```

### In a Terminal
Run the tests headlessly without opening the Neovim UI:
```bash
nvim --headless -c "PlenaryBustedFile tests/menu_neotree_spec.lua"
```

## Running Debug Scripts

For isolated debug scripts (e.g., `test_ghost.lua`, `test_autocmd.lua`):

### In Neovim
Open the file and execute it:
```vim
:luafile %
```

### In a Terminal
Run the script using Neovim's headless mode:
```bash
nvim --headless -l tests/test_ghost.lua
```
*(Note: some debug scripts automatically quit by calling `vim.cmd("qa!")`)*
