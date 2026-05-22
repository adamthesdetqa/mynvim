# 🚀 JavaScript Debugging Guide

This guide explains how to debug JavaScript/TypeScript applications (Node.js or Browser) using the built-in Debug Adapter Protocol (DAP) setup.

## 1. Verifying Installation
Your configuration is set to automatically install the `js-debug-adapter` via **Mason**.

### How to check if it's installed:
1.  Open Neovim.
2.  Run the command: `:Mason`
3.  Look for `js-debug-adapter` under the **DAP** section.
    *   If there is a **✔** next to it, you are ready.
    *   If it is missing or has an error, press `i` while hovering over it to install it manually.

---

## 2. Launch Configuration (`launch.json`)
Neovim's `nvim-dap` is compatible with VS Code launch configurations. You **must** have a `.vscode/launch.json` file in your project root for the debugger to know how to start your app.

### Example for Node.js:
Create `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "pwa-node",
      "request": "launch",
      "name": "Launch Program",
      "skipFiles": ["<node_internals>/**"],
      "program": "${file}"
    }
  ]
}
```

### Example for Angular/Chrome:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "pwa-chrome",
      "request": "launch",
      "name": "Launch Chrome against localhost",
      "url": "http://localhost:4200",
      "webRoot": "${workspaceFolder}"
    }
  ]
}
```

---

## 3. Step-by-Step Debugging Flow

### Step 1: Add Breakpoints
Navigate to the line of code where you want to pause and press:
*   `Space` + `d` + `b` (`<leader>db`)
*   A sign (usually a dot or icon) will appear in the gutter.

### Step 2: Start Debugging
Press **`<F5>`**. 
*   If you have multiple configurations in `launch.json`, a menu will appear. Select the one you want.
*   The `dap-ui` will automatically open, showing **Scopes**, **Stacks**, **Watches**, and **Breakpoints**.

### Step 3: Navigating the Code
Once the debugger hits a breakpoint, use these keys:
*   **`<F10>` (Step Over)**: Go to the next line without entering functions.
*   **`<F11>` (Step Into)**: Enter the function on the current line.
*   **`<F12>` (Step Out)**: Finish the current function and return to the caller.
*   **`<F5>` (Continue)**: Resume execution until the next breakpoint.

### Step 4: Inspecting Variables
*   **Scopes Window**: View all local and global variables automatically.
*   **REPL**: Press `Space` + `d` + `r` (`<leader>dr`) to open the interactive console. You can type variable names here to see their values or execute code.

---

## 4. Advanced Features

### Conditional Breakpoints
If you only want to pause when a certain condition is met (e.g., `i > 10`):
1.  Press `Space` + `d` + `B` (`<leader>dB`).
2.  Type your JavaScript condition in the prompt.

### Toggle UI
If you accidentally close the debug windows, press:
*   `Space` + `d` + `u` (`<leader>du`) to toggle the UI back on.

---

## 5. Troubleshooting
*   **Breakpoints not hitting?** Ensure your `launch.json` has the correct `webRoot` or `program` path. For TypeScript, ensure `sourceMap: true` is set in your `tsconfig.json`.
*   **Adapter not found?** Run `:Mason` and ensure `js-debug-adapter` is updated.
