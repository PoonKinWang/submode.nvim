-- check if dap and dap-ui is installed
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local ok, dapui = pcall(require, "dapui")
if not ok then
  return
end

local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

local debug_keys = {
  {
    key = "B",
    rhs = function()
      require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end,
    desc = "Breakpoint Condition",
  },
  {
    key = "b",
    rhs = function()
      require("dap").toggle_breakpoint()
    end,
    desc = "Toggle Breakpoint",
  },
  {
    key = "c",
    rhs = function()
      require("dap").continue()
    end,
    desc = "Run/Continue",
  },
  {
    key = "a",
    rhs = function()
      require("dap").continue({ before = get_args })
    end,
    desc = "Run with Args",
  },
  {
    key = "C",
    rhs = function()
      require("dap").run_to_cursor()
    end,
    desc = "Run to Cursor",
  },
  {
    key = "g",
    rhs = function()
      require("dap").goto_()
    end,
    desc = "Go to Line (No Execute)",
  },
  {
    key = "i",
    rhs = function()
      require("dap").step_into()
    end,
    desc = "Step Into",
  },
  {
    key = "j",
    rhs = function()
      require("dap").down()
    end,
    desc = "Down",
  },
  {
    key = "k",
    rhs = function()
      require("dap").up()
    end,
    desc = "Up",
  },
  {
    key = "l",
    rhs = function()
      require("dap").run_last()
    end,
    desc = "Run Last",
  },
  {
    key = "o",
    rhs = function()
      require("dap").step_out()
    end,
    desc = "Step Out",
  },
  {
    key = "O",
    rhs = function()
      require("dap").step_over()
    end,
    desc = "Step Over",
  },
  {
    key = "P",
    rhs = function()
      require("dap").pause()
    end,
    desc = "Pause",
  },
  {
    key = "r",
    rhs = function()
      require("dap").repl.toggle()
    end,
    desc = "Toggle REPL",
  },
  {
    key = "s",
    rhs = function()
      require("dap").session()
    end,
    desc = "Session",
  },
  {
    key = "t",
    rhs = function()
      require("dap").terminate()
    end,
    desc = "Terminate",
  },
  {
    key = "w",
    rhs = function()
      require("dap.ui.widgets").hover()
    end,
    desc = "Widgets",
  },
  {
    key = "u",
    rhs = function()
      require("dapui").toggle()
    end,
    desc = "Toggle DAP UI",
  },
}

return {
  "PoonKinWang/submode.nvim",
  config = function()
    require("submode").setup({
      submodes = {
        ["debug"] = {
          enter_key = "<leader>dd",
          mappings = debug_keys,
        },
      },
    })
  end,
}
