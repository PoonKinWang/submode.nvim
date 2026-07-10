<div align="center">

# submode.nvim

🎯 Temporary keybinding submode for Neovim

</div>

<details>
<summary><code>📖 Table of Contents</code></summary>

- [🔧 Requirements](#-requirements)
- [✨ Features](#-features)
- [🍳 Usage Examples](#-usage-examples)
  - [With lazy.nvim](#with-lazynvim)
  - [Multiple submodes](#multiple-submodes)
- [⚙️ Configuration](#️-configuration)
  - [`submodes`](#submodes)
  - [Submode entry structure](#submode-entry-structure)
- [❓ FAQ](#-faq)
- [📄 License](#-license)

</details>

## 🔧 Requirements

- Neovim >= 0.7.0 (for `vim.keymap.set` support)
- No external dependencies

## ✨ Features

1. **Temporary keybinding isolation** – Enter a submode, remap given keys, exit automatically with exit key.
2. **Lightweight** – Pure Lua, zero overhead.
3. **Fully configurable** – Define any number of submodes with arbitrary key‑action pairs.

## 🍳 Usage Examples

`./EXAMPLE` lists a few practical submode configurations.

### With lazy.nvim

Add the plugin to your lazy.nvim spec:

```lua
return {
  "PoonKinWang/submode.nvim",
  opts = {
     window_adjust = {
      name = "Window Adjust",
      enter_key = "<C-w><C-w>",
      exit_key = "<Esc>",
      mappings = {
        { rhs = "<C-w>+", key = "+", desc = "Increase window height" },
        { rhs = "<C-w>-", key = "-", desc = "Decrease window height" },
        { rhs = "<C-w><", key = "<", desc = "Decrease window width" },
        { rhs = "<C-w>>", key = ">", desc = "Increase window width" },
      },
    } 
  }
}
```

Now pressing `<C-w><C-w>` enters the **window** submode. While inside, single keys `<`, `>`, `+`, `-` remap to window resizing commands, making it easier to adjust window sizes without needing to type the full `<C-w>` prefix each time. Pressing `<Esc>` exits the submode and restores normal keybindings.

Here, `rhs` is the action to execute, `key` is the key to press, and `desc` is an optional description for WhichKey or other plugins that display keybinding hints.

### Multiple submodes

You can define several independent submodes. Here's another example for debugging:

```lua
return {
  "PoonKinWang/submode.nvim",
  opts = {
    window_adjust = {
      name = "Window Adjust",
      enter_key = "<C-w><C-w>",
      exit_key = "<Esc>",
      mappings = {
        { rhs = "<C-w>+", key = "+", desc = "Increase window height" },
        { rhs = "<C-w>-", key = "-", desc = "Decrease window height" },
        { rhs = "<C-w><", key = "<", desc = "Decrease window width" },
        { rhs = "<C-w>>", key = ">", desc = "Increase window width" },
      },
    },
    debugging = {
      name = "Debugging",
      enter_key = "<leader>d",
      exit_key = "<Esc>",
      mappings = {
        { key = "b", rhs = ":lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
        { key = "c", rhs = ":lua require'dap'.continue()<CR>", desc = "Continue execution" },
        { key = "o", rhs = ":lua require'dap'.step_over()<CR>", desc = "Step over" },
        { key = "i", rhs = ":lua require'dap'.step_into()<CR>", desc = "Step into" },
      },
    },
  }
}
```

## ⚙️ Configuration

The `setup` function accepts a single table with the following fields:

```lua
{
  submode_1 = {
    name = "submode_name",
    enter_key = "<key>", -- Key sequence to enter the submode
    exit_key = "<key>",  -- Key sequence to exit the submode
      mappings = {
        { key = "...", rhs = "...", desc = "..." },
        -- more entries...
    },
  },
  submode_2 = {
    ...
  -- more submodes...
}
```

### `submode`

Each submode must contain:

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | The name of the submode (used for notifications) |
| `enter_key` | `string` | Normal‑mode keymap that triggers the submode (e.g. `"<leader>w"`) |
| `exit_key` | `string` | Normal‑mode keymap that exits the submode (e.g. `"<Esc>"`) |
| `mappings` | `table` | List of key‑action definitions |

### Submode entry structure

Each entry in `mappings` is a table:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| mode | `string` | ❌ | The mode for the mapping (default: `"n"` for normal mode) |
| `key` | `string` | ✅ | The key to map (e.g. `"h"`, `"j"`) |
| `rhs` | `string` | ✅ | The action (e.g. `"<C-w>h"`, `":bd<CR>"`) |
| `desc` | `string` | ❌ | Description shown in `WhichKey` or `vim.keymap` |

All mappings are created in **normal mode** (`"n"`).

## ❓ FAQ

> Can I use this with WhichKey?

Yes. The `desc` field in each key entry will be picked up by WhichKey if you have it installed.

> What happens if I press exit key (e.g. `<Esc>`) inside a submode?

The submode exits immediately, all overridden keys are restored, and the normal `<Esc>` behaviour resumes.

> Can I have nested submodes?

No – activating a second submode while one is active shows a warning and ignores the request. You must exit the current submode first.

## 📄 License

GNU General Public License v2.0 – see [LICENSE](./LICENSE) for details.
