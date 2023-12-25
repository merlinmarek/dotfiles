return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make"},
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    vim.keymap.set("n", "<leader>h", require("telescope.builtin").oldfiles)
    vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers)
    vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files)
    vim.keymap.set("n", "<leader>g", require("telescope.builtin").live_grep)
    vim.keymap.set("n", "<leader>p", require("telescope.builtin").commands)
    vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics)
    vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume)
  end,
}
