return
{
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  opts = {
    controls = {
      enabled = false,
    },
    expand_lines = false,
    layouts = {
      {
        elements = {
          { id = "scopes",  size = 0.50 },
          { id = "watches", size = 0.25 },
          { id = "stacks",  size = 0.25 },
        },
        size = 0.5,
        position = "right",
      },
      {
        elements = {
          "repl",
        },
        size = 10,
        position = "bottom",
      },
    },
  }
}
