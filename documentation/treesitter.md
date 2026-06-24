# Treesitter Textobjects & Incremental Selection

Your configuration utilizes **Treesitter** to understand the semantic structure of your code. This enables precise, structure-aware code selection, deletion, manipulation, and navigation.

---

## 1. Incremental Selection
Instead of manually selecting blocks of code character-by-character or line-by-line, you can expand or shrink selection based on the syntax tree.

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| **`<C-space>`** | **Initialize / Expand** | Start selection on the current word, or expand selection to the parent syntax node. |
| **`<M-space>`** (Alt/Option + Space) | **Shrink** | Shrink the visual selection back to the previous inner syntax node. |
| **`<C-s>`** | **Scope Incremental** | Expand selection to the surrounding scope/block. |

### How to use it:
1. Put your cursor anywhere inside a block of code (e.g., on a variable name inside an object).
2. Press **`<C-space>`** to select the word under your cursor.
3. Keep pressing **`<C-space>`** to expand the selection to the containing statement, then the whole object, then the parent function, and so on.
4. Press **`<M-space>`** to shrink back down.

---

## 2. Treesitter Textobjects (Selecting & Deleting)
Standard Vim has textobjects like `iw` (inner word) or `i"` (inner quotes). Treesitter extends this to code structures like **functions**, **classes**, and **parameters/arguments**.

You can combine these with any operators: **`v`** (select), **`d`** (delete), **`c`** (change/replace), or **`y`** (yank/copy).

### Key Targets:
* **`f`** — Functions
* **`c`** — Classes
* **`a`** — Arguments / Parameters
* **`u`** — Comments

### Common Command Examples:

#### A. Working with Functions (`f`):
* **`vaf`** — **V**isually select **A**round the entire **F**unction (including declaration and body).
* **`vif`** — **V**isually select **I**nside the **F**unction body.
* **`dif`** — **D**elete **I**nside the **F**unction body (great for clearing out a function to rewrite it).
* **`yaf`** — **Y**ank/copy **A**round the **F**unction.

#### B. Working with Parameters / Arguments (`a`):
* **`via`** — **V**isually select **I**nside the **A**rgument (just the parameter value).
* **`daa`** — **D**elete **A**round the **A**rgument (deletes the parameter and its preceding or following comma perfectly).
* **`cia`** — **C**hange **I**nside the **A**rgument (deletes parameter and enters insert mode to replace it).

#### C. Working with Classes (`c`) & Comments (`u`):
* **`vac`** — **V**isually select **A**round the entire **C**lass.
* **`dic`** — **D**elete **I**nside the **C**lass.
* **`vuc`** — **V**isually select **A**round the **C**omment block.

---

## 3. Jumping / Navigation
You can jump directly between code structures:

* **`]m`** — Jump to the **start** of the **next** function.
* **`[m`** — Jump to the **start** of the **previous** function.
* **`]M`** — Jump to the **end** of the **next** function.
* **`[M`** — Jump to the **end** of the **previous** function.
* **`]]`** — Jump to the **next** class.
* **`[[`** — Jump to the **previous** class.

---

## 4. Swapping Parameters
You can swap the order of function parameters or arguments instantly:

* **`<leader>a`** — Swap the current argument with the **next** argument.
* **`<leader>A`** — Swap the current argument with the **previous** argument.
