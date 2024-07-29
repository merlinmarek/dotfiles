vim.opt.clipboard = "unnamedplus" -- use the system clipboard
vim.opt.showcmd = false -- do not show partial commands
vim.opt.showmode = false -- do not show the current mode
vim.opt.number = true -- show line numbers
vim.opt.linebreak = true -- do not split words when wrapping
vim.opt.lazyredraw = true -- do not update screen while executing macros
vim.opt.shiftround = true -- round indent to multiple of shiftwidth
vim.opt.ignorecase = true -- ignore case when searching...
vim.opt.smartcase = true -- ... except when capital letters are used
vim.opt.swapfile = false -- do not create swapfiles
vim.opt.undofile = true -- create undo files
vim.opt.pumheight = 20 -- use 20 lines in the popupmenu at maximum
vim.opt.expandtab = true -- insert spaces when pressing tab
vim.opt.tabstop = 2 -- use 2 spaces for a tab
vim.opt.shiftwidth = 0 -- use whatever tabstop is
vim.opt.softtabstop = -1 -- use whatever shiftwidth is
-- if splitright is set, step into while debugging does not jump to the function
-- vim.opt.splitright = true         -- more intuitive split positions
vim.opt.splitbelow = true -- more intuitive split positions
vim.opt.mouse = "" -- allow select and copy from vim via mouse
vim.opt.shortmess:append("cI") -- do not show intro on startup
vim.opt.laststatus = 1 -- only show statusline if there are multiple windows
vim.opt.inccommand = "nosplit" -- highlight matched words when typing substitution commands
vim.opt.scrolloff = 5 -- keep lines above and below the cursor while scrolling
vim.opt.foldlevelstart = 99 -- expand all folds on start
vim.opt.updatetime = 100 -- check if the file has been changed externally more often
vim.opt.signcolumn = "number" -- show signs in number column
vim.opt.termguicolors = false -- use cterm attributes instead of gui attributes for color scheme
vim.g.syntax = false -- disable regex based syntax highlighting, use treesitter instead

-- do not use virtual text for diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  float = {
    source = true,
  },
})
