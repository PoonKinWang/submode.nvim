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

1. **Temporary keybinding isolation** – Enter a submode, remap given keys, exit automatically with `<Esc>`.
2. **Lightweight** – Pure Lua, zero overhead.
3. **Fully configurable** – Define any number of submodes with arbitrary key‑action pairs.

## 🍳 Usage Examples

`./EXAMPLE` lists a few practical submode configurations.

### With lazy.nvim

Add the plugin to your lazy.nvim spec:

```lua
return {
  "PoonKinWang/submode.nvim",
  config = function()
    require("submode").setup({
      submodes = {
        ["window adjust"] = {
          enter_key = "<C-w><C-w>",
          mappings = {
            
            { rhs = "<C-w>+", key = "+", desc = "Increase window height" },
            { rhs = "<C-w>-", key = "-", desc = "Decrease window height" },
            { rhs = "<C-w><", key = "<", desc = "Decrease window width" },
            { rhs = "<C-w>>", key = ">", desc = "Increase window width" },
          },
        },
      },
    })
  end,
}
```

Now pressing `<C-w><C-w>` enters the **window** submode. While inside, single keys `<`, `>`, `+`, `-` remap to window resizing commands, making it easier to adjust window sizes without needing to type the full `<C-w>` prefix each time. Pressing `<Esc>` exits the submode and restores normal keybindings.

Here, `rhs` is the action to execute, `key` is the key to press, and `desc` is an optional description for WhichKey or other plugins that display keybinding hints.

### Multiple submodes

You can define several independent submodes. Here's another example for debugging:

```lua
return {
  "PoonKinWang/submode.nvim",
  config = function()
    require("submode").setup({
      submodes = {
        ["window adjust"] = {
          enter_key = "<C-w><C-w>",
          mappings = {
            { rhs = "<C-w>+", key = "+", desc = "Increase window height" },
            { rhs = "<C-w>-", key = "-", desc = "Decrease window height" },
            { rhs = "<C-w><", key = "<", desc = "Decrease window width" },
            { rhs = "<C-w>>", key = ">", desc = "Increase window width" },
          },
        },
        ["debug"] = {
          enter_key = "<leader>d",
          mappings = {
            { key = "b", rhs = ":lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
            { key = "c", rhs = ":lua require'dap'.continue()<CR>", desc = "Continue execution" },
            { key = "o", rhs = ":lua require'dap'.step_over()<CR>", desc = "Step over" },
            { key = "i", rhs = ":lua require'dap'.step_into()<CR>", desc = "Step into" },
          },
        },
      },
    })
  end,
}
```

## ⚙️ Configuration

The `setup` function accepts a single table with the following fields:

```lua
{
  submodes = {
    ["submode_name"] = {
      enter_key = "<key>", -- Key sequence to enter the submode
        mappings = {
          { key = "...", rhs = "...", desc = "..." },
          -- more entries...
      },
    },
    -- more submodes...
  },
}
```

### `submodes`

A dictionary where each key is the name of a submode (used for notifications).  
Each value must contain:

| Field | Type | Description |
|-------|------|-------------|
| `enter_key` | `string` | Normal‑mode keymap that triggers the submode (e.g. `"<leader>w"`) |
| `mappings` | `table` | List of key‑action definitions |

### Submode entry structure

Each entry in `mappings` is a table:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `key` | `string` | ✅ | The key to map (e.g. `"h"`, `"j"`) |
| `rhs` | `string` | ✅ | The action (e.g. `"<C-w>h"`, `":bd<CR>"`) |
| `desc` | `string` | ❌ | Description shown in `WhichKey` or `vim.keymap` |

All mappings are created in **normal mode** (`"n"`).

## ❓ FAQ

> Can I use this with WhichKey?

Yes. The `desc` field in each key entry will be picked up by WhichKey if you have it installed.

> Does it support operator‑pending or visual modes?

Currently only normal mode is supported. Extending to other modes is planned.

> What happens if I press `<Esc>` inside a submode?

The submode exits immediately, all overridden keys are restored, and the normal `<Esc>` behaviour resumes.

> Can I have nested submodes?

No – activating a second submode while one is active shows a warning and ignores the request. You must exit the current submode first.

## 📄 License

GNU General Public License v2.0 – see [LICENSE](./LICENSE) for details.
