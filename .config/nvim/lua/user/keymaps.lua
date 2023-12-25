vim.g.mapleader = " "
vim.g.maplocalleader = " "

local nore = { noremap = true }
local k = vim.keymap.set

-- general
k({ "n", "v" }, "<space>", "<nop>", { silent = true })
k("n", "<leader>ve", ":edit $MYVIMRC<cr>", nore)
k("n", "<leader>w", ":write<cr>", nore)
k("n", "<leader>q", ":quit<cr>", nore)
k("n", "<leader>x", ":write | quit<cr>", nore)
k("n", "<leader><leader>", "<c-^>", nore) -- switch to previous buffer
k("n", "<leader>i", ":Inspect<cr>", nore)
k("n", "<leader>l", ":Telescope highlights<cr>", nore)
k("n", "s", ":luafile %<cr>", nore)

-- lsp
k("n", "ge", vim.diagnostic.goto_prev, nore)
k("n", "gE", vim.diagnostic.goto_next, nore)
k("n", "<leader>e", vim.diagnostic.open_float, nore)
k("n", "<leader>d", vim.diagnostic.setloclist, nore)
k("n", "<leader>j", ":nohlsearch<cr>", nore) -- remove current search highlighting

-- debugging
k("n", "<f4>", function()
  require("dap").terminate()
end)
k("n", "<f5>", function()
  require("dap").continue()
end)
k("n", "<f6>", function()
  require("dap").step_over()
end)
k("n", "<f7>", function()
  require("dap").step_into()
end)

-- move on visual lines
k({ "n", "x" }, "k", "gk", { silent = true })
k({ "n", "x" }, "j", "gj", { silent = true })

-- easier movement between windows
k("n", "<c-j>", "<c-w>j", nore)
k("n", "<c-k>", "<c-w>k", nore)
k("n", "<c-l>", "<c-w>l", nore)
k("n", "<c-h>", "<c-w>h", nore)

-- go to first non-whitespace character when pressing 0
k("n", "0", "^", nore)
k("n", "^", "0", nore)

-- easy-align
k("x", "ga", "<plug>(EasyAlign)", {})
k("n", "ga", "<plug>(EasyAlign)", {})

-- dirvish
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <esc> gq")
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <leader>q gq")
