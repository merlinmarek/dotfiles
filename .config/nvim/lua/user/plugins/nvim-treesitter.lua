return {
  -- highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "JoosepAlviste/nvim-ts-context-commentstring", -- set the commentstring based on location in the file
  },
  build = ":TSUpdate",
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
          },
        },
      },
      highlight = {
        enable = "true",
      },
      ensure_installed = {
        "go",
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "vue",
      },
      ts_context_commentstring = {
        enable = true,
      },
    })
  end,
}
