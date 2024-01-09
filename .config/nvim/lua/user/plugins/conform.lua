-- format files
return {
  "stevearc/conform.nvim",
  event = {
    "BufReadPre", -- opening a file
    "BufNewFile", -- creating a new file
  },
  config = function()
    local conform = require("conform")

    conform.setup({
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        json = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
        html = { "prettier" },
      },
    })
  end,
}
