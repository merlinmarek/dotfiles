vim.opt.clipboard = "unnamedplus" -- use the system clipboard
vim.opt.showcmd = false           -- do not show partial commands
vim.opt.showmode = false          -- do not show the current mode
vim.opt.number = true             -- show line numbers
vim.opt.linebreak = true          -- do not split words when wrapping
vim.opt.lazyredraw = true         -- do not update screen while executing macros
vim.opt.shiftround = true         -- round indent to multiple of shiftwidth
vim.opt.ignorecase = true         -- ignore case when searching...
vim.opt.smartcase = true          -- ... except when capital letters are used
vim.opt.swapfile = false          -- do not create swapfiles
vim.opt.undofile = true           -- create undo files
vim.opt.pumheight = 20            -- use 20 lines in the popupmenu at maximum
vim.opt.tabstop = 2               -- default, gets overriden for specific file types
vim.opt.shiftwidth = 0            -- use whatever tabstop is
vim.opt.softtabstop = -1          -- use whatever shiftwidth is
vim.opt.expandtab = true          -- insert spaces when pressing tab
vim.opt.splitright = true         -- more intuitive split positions
vim.opt.splitbelow = true         -- more intuitive split positions
vim.opt.mouse = ""                -- allow select and copy from vim via mouse
vim.opt.shortmess:append("cI")    -- do not show intro on startup
vim.opt.laststatus = 1            -- only show statusline if there are multiple windows
vim.opt.inccommand = "nosplit"    -- highlight matched words when typing substitution commands
vim.opt.scrolloff = 5             -- keep lines above and below the cursor while scrolling
vim.opt.foldlevelstart = 99       -- expand all folds on start
vim.opt.updatetime = 100          -- check if the file changed from outside more often

vim.g.syntax = false              -- disable regex based syntax highlighting, use treesitter instead

vim.cmd "colorscheme 16term"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local noremap = { noremap = true }
local keymap = vim.api.nvim_set_keymap
keymap("n", "<space>", "", {})
keymap("n", "<leader>ve", ":edit ~/.config/nvim/init.lua<cr>", noremap)
keymap("n", "<leader>w", ":write<cr>", noremap)
keymap("n", "<leader>q", ":quit<cr>", noremap)
keymap("n", "<leader>x", ":write | quit<cr>", noremap)
keymap("n", "<leader>j", ":nohlsearch<cr>", noremap)            -- remove search highlighting
keymap("n", "<leader><leader>", "<c-^>", noremap)               -- switch to last buffer
keymap("n", "<leader>s", ":%s/\\s\\+$//e<cr>", noremap)         -- remove trailing whitespace
keymap("i", "<c-l>", "<esc>:lua go_insert_err()<cr>", noremap)  -- insert golang return err template
keymap("n", "<leader>k", ":source %<cr>", noremap)              -- eval current file

-- move on visual lines
keymap("x", "j", "gj", noremap)
keymap("x", "k", "gk", noremap)
keymap("n", "j", "gj", noremap)
keymap("n", "k", "gk", noremap)

-- easier movement between windows
keymap("n", "<c-j>", "<c-w>j", noremap)
keymap("n", "<c-k>", "<c-w>k", noremap)
keymap("n", "<c-l>", "<c-w>l", noremap)
keymap("n", "<c-h>", "<c-w>h", noremap)

-- go to first non-whitespace character when pressing 0
keymap("n", "0", "^", noremap)
keymap("n", "^", "0", noremap)

-- return to the last edited line when reopening a file
vim.cmd "autocmd BufReadPost * if line(\"'\\\"\") > 0 && line (\"'\\\"\") <= line(\"$\") | execute 'normal! g`\"zvzz' | endif"

-- do not yank when pasting over visual selection
vim.cmd "xnoremap <expr> p '\"_d\"'.v:register.'P'"

-- open terminal with <leader>t
vim.cmd "nnoremap <leader>t :let $VIM_DIR=expand('%:p:h')<cr>:split \\| terminal<cr>cd $VIM_DIR<cr>c<cr>"
vim.cmd "autocmd TermOpen * startinsert \" automatically start insert mode when opening term"
vim.cmd "autocmd TermOpen * setlocal listchars= nonumber norelativenumber signcolumn=no laststatus=0 nospell"

-- automatically start in insert mode for git commit messages
vim.cmd "autocmd VimEnter COMMIT_EDITMSG exec 'norm gg' | startinsert!"

-- autoread files when they change outside the editor
vim.cmd "autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() == 'n' && getcmdwintype() == '' | checktime | endif"

-- sign column
vim.cmd "autocmd FileType lua,dart,c,cs,cpp,python,go,rust,vue,css,php,javascript,typescript,json,yaml,gdscript,svelte setlocal signcolumn=yes"

-- whitespace settings
vim.cmd "autocmd FileType cs,rust,java,nginx,cmake                                                                setlocal ts=4 et tw=80"
vim.cmd "autocmd FileType c,cpp,dart,sshconfig,css,html,json,yaml,vim,bib,vue,javascript,lua,dockerfile,svelte    setlocal ts=2 et tw=80"
vim.cmd "autocmd FileType tex,plaintex,rust,java,nginx,cmake                                                      setlocal ts=4 et tw=80"
vim.cmd "autocmd FileType zsh                                                                                     setlocal ts=4 noet"
vim.cmd "autocmd FileType gdscript                                                                                setlocal ts=2 noet"
vim.cmd "autocmd FileType go                                                                                      setlocal ts=4 noet tw=80"
vim.cmd "autocmd FileType python                                                                                  setlocal ts=4 et"
vim.cmd "autocmd FileType asm                                                                                     setlocal ts=8 noet"

-- fold settings
vim.cmd "setlocal foldlevel=1 foldnestmax=1 foldmethod=syntax"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- ensure that packer is installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.api.nvim_command 'packadd packer.nvim'
end

-- load plugins
require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use "tpope/vim-commentary"
  use "junegunn/vim-easy-align"
  use "junegunn/fzf.vim"
  use "justinmk/vim-dirvish"
  use "evanleck/vim-svelte"
  use { 'iamcco/markdown-preview.nvim', run = function() vim.fn["mkdp#util#install"]() end, }
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter', }
  use { 'nvim-treesitter/playground', after = 'nvim-treesitter', }
  use "zivyangll/git-blame.vim"
  use { "neoclide/coc.nvim", branch = "release" }
end)

-- commentary
vim.cmd "autocmd FileType c,cpp,cs setlocal commentstring=//%s"
vim.cmd "autocmd FileType terraform setlocal commentstring=#%s"

-- create qr code from selection
vim.cmd "xnoremap <leader>sq :w !qrencode -o - <bar> feh - &<bslash>!<c-b>silent<space><cr>:redraw!<cr>"

-- coc
vim.cmd "inoremap <expr> <tab> !pumvisible() ? \"\\<tab>\" : \"\\<c-y>\""
vim.cmd "inoremap <expr> <cr> !pumvisible() ? \"\\<cr>\" : \"\\<c-y>\""
vim.cmd "inoremap <silent><expr> <c-space> coc#refresh()"
vim.cmd "nmap <silent> gd <Plug>(coc-definition)"
vim.cmd "nmap <silent> gi <Plug>(coc-implementation)"
vim.cmd "nmap <silent> gr <Plug>(coc-references)"
vim.cmd "nmap <silent> gy <Plug>(coc-type-definition)"
vim.cmd "nmap <silent> ge <Plug>(coc-diagnostic-prev)"
vim.cmd "nmap <leader>r <Plug>(coc-rename)"
vim.cmd "nmap <leader>a <Plug>(coc-codeaction)"
vim.cmd "nmap <silent> <leader>e :call CocAction('doHover')<cr>"
vim.cmd "autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')"

-- dirvish
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <esc> gq")
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <leader>q gq")

-- fzf
keymap("n", "<leader>f", ":Files<cr>", noremap)
keymap("n", "<leader>b", ":Buffers<cr>", noremap)
keymap("n", "<leader>g", ":Rg<cr>", noremap)
keymap("n", "<leader>h", ":History<cr>", noremap)
keymap("i", "<c-f>", "<plug>(fzf-complete-path)", {})

-- treesitter
require "nvim-treesitter.configs".setup {
  highlight = { enable = true },
  playground = {
    enabled = true,
  },
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
  ensure_installed = {
    "go",
    "lua",
    "javascript",
    "typescript",
  },
}

-- easy-align
keymap("x", "ga", "<plug>(EasyAlign)", {})
keymap("n", "ga", "<plug>(EasyAlign)", {})

require "goerr"

-- load local extra settings
vim.cmd "silent! source ~/.config/nvim/local/settings.vim"
