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
vim.opt.expandtab = true          -- insert spaces when pressing tab
vim.opt.tabstop = 2               -- use 2 spaces for a tab
vim.opt.shiftwidth = 0            -- use whatever tabstop is
vim.opt.softtabstop = -1          -- use whatever shiftwidth is
vim.opt.splitright = true         -- more intuitive split positions
vim.opt.splitbelow = true         -- more intuitive split positions
vim.opt.mouse = ""                -- allow select and copy from vim via mouse
vim.opt.shortmess:append("cI")    -- do not show intro on startup
vim.opt.laststatus = 1            -- only show statusline if there are multiple windows
vim.opt.inccommand = "nosplit"    -- highlight matched words when typing substitution commands
vim.opt.scrolloff = 5             -- keep lines above and below the cursor while scrolling
vim.opt.foldlevelstart = 99       -- expand all folds on start
vim.opt.updatetime = 100          -- check if the file has been changed externally more often
vim.opt.signcolumn = "number"     -- show signs in number column
vim.g.syntax = false              -- disable regex based syntax highlighting, use treesitter instead

-- disable unused builtin plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
-- vim.g.loaded_matchit = 1    -- i use this
-- vim.g.loaded_matchparen = 1 -- i use this
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local timeout_ms = 1000 -- increase if you have a large codebase
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})

-- install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    -- pretty diagnostics and quickfix
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    -- provide ai code completions
    "github/copilot.vim",
  },
  {
    -- browse files
    "justinmk/vim-dirvish",
  },
  {
    -- format files
    "stevearc/conform.nvim",
  },
  {
    -- preview markdown files
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    -- set the commentstring based on location in the file
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  {
    -- nvim lsp client configs
    "neovim/nvim-lspconfig",

    config = function()
      -- Switch for controlling whether you want autoformatting.
      --  Use :KickstartFormatToggle to toggle autoformatting on or off
      local format_is_enabled = true
      vim.api.nvim_create_user_command("KickstartFormatToggle", function()
        format_is_enabled = not format_is_enabled
        print("Setting autoformatting to: " .. tostring(format_is_enabled))
      end, {})

      -- Create an augroup that is used for managing our formatting autocmds.
      --      We need one augroup per client to make sure that multiple clients
      --      can attach to the same buffer without interfering with each other.
      local _augroups = {}
      local get_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = "kickstart-lsp-format-" .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end

        return _augroups[client.id]
      end

      -- Whenever an LSP attaches to a buffer, we will run this function.
      --
      -- See `:help LspAttach` for more information about this autocmd event.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach-format", { clear = true }),
        -- This is where we attach the autoformatting for reasonable clients
        callback = function(args)
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          local bufnr = args.buf

          -- Only attach to clients that support document formatting
          if not client.server_capabilities.documentFormattingProvider then
            return
          end

          -- Tsserver usually works poorly. Sorry you work with bad languages
          -- You can remove this line if you know what you're doing :)
          if client.name == "tsserver" then
            return
          end

          -- Create an autocmd that will run *before* we save the buffer.
          --  Run the formatting command for the LSP that has just attached.
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
              if not format_is_enabled then
                return
              end
              vim.lsp.buf.format({
                async = false,
                filter = function(c)
                  return c.id == client.id
                end,
              })
            end,
          })
        end,
      })
    end,
    dependencies = {
      -- automatically install language servers to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- provide completion for nvim lua api
      "folke/neodev.nvim",
    },
  },
  {
    -- provide autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- snippet engine and corresponding nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- add compltions from lsp
      "hrsh7th/cmp-nvim-lsp",
    },
  },

  {
    -- "gc" to comment visual regions/lines
    "numToStr/Comment.nvim",
    opts = {},
  },

  {
    -- fuzzy finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
  },

  {
    -- highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },
}, {})

require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    lua = { "stylua" },
    json = { "prettier" },
    css = { "prettier" },
    javascript = { "prettier" },
  },
})

-- keymaps
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

-- lsp
k("n", "ge", vim.diagnostic.goto_prev, nore)
k("n", "gE", vim.diagnostic.goto_next, nore)
k("n", "<leader>e", vim.diagnostic.open_float, nore)
k("n", "<leader>d", vim.diagnostic.setloclist, nore)
k("n", "<leader>j", ":nohlsearch<cr>", nore) -- remove current search highlighting

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

-- show treesitter hl group
k("n", "gh", ":TSHighlightCapturesUnderCursor<cr>", nore)

-- dirvish
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <esc> gq")
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <leader>q gq")

-- do not yank when pasting over visual selection
vim.cmd("xnoremap <expr> p '\"_d\"'.v:register.'P'")

-- return to the last edited line when reopening a file
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(opts)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
            not (ft:match("commit") and ft:match("rebase"))
            and last_known_line > 1
            and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], "nx", false)
        end
      end,
    })
  end,
})

-- open terminal with <leader>t
vim.cmd("nnoremap <leader>t :let $VIM_DIR=expand('%:p:h')<cr>:split \\| terminal<cr>cd $VIM_DIR<cr>c<cr>")
vim.cmd('autocmd TermOpen * startinsert " automatically start insert mode when opening term')
vim.cmd("autocmd TermOpen * setlocal listchars= nonumber norelativenumber signcolumn=no laststatus=0 nospell")

-- automatically start in insert mode for git commit messages
vim.cmd("autocmd VimEnter COMMIT_EDITMSG exec 'norm gg' | startinsert!")

-- autoread files when they change outside the editor
vim.cmd(
  "autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() == 'n' && getcmdwintype() == '' | checktime | endif"
)

-- create qr code from selection
vim.cmd("xnoremap <leader>sq :w !qrencode -o - <bar> feh - &<bslash>!<c-b>silent<space><cr>:redraw!<cr>")

-- whitespace settings
vim.cmd("autocmd FileType cs,tex,plaintex,rust,java,nginx,cmake setlocal ts=4 et tw=80")
vim.cmd("autocmd FileType zsh                                   setlocal ts=4 noet")
vim.cmd("autocmd FileType gdscript                              setlocal ts=2 noet")
vim.cmd("autocmd FileType go                                    setlocal ts=4 noet tw=80")
vim.cmd("autocmd FileType python                                setlocal ts=4 et")

-- fold settings
vim.cmd("setlocal foldlevel=1 foldnestmax=1 foldmethod=syntax")
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- abbreviations
vim.cmd("iabbrev rud refactor: update dependencies")

-- :help telescope
-- :help telescope.setup()
require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close,
      },
    },
  },
})

-- enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require("telescope.builtin").live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>h", require("telescope.builtin").oldfiles)
vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>g", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics)
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume)

-- :help nvim-treesitter
-- defer treesitter setup after first render to improve startup time
vim.defer_fn(function()
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
end, 0)

-- do not use virtual text for diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
})

--  this function gets run when an lsp connects to a particular buffer
local on_attach = function(_, bufnr)
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>r", vim.lsp.buf.rename)
  nmap("<leader>a", vim.lsp.buf.code_action)
  nmap("<leader>e", vim.lsp.buf.hover)
  nmap("gD", vim.lsp.buf.declaration)
  nmap("gd", require("telescope.builtin").lsp_definitions)
  nmap("gr", require("telescope.builtin").lsp_references)
  nmap("gi", require("telescope.builtin").lsp_implementations)
  nmap("gy", require("telescope.builtin").lsp_type_definitions)
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

local servers = {
  gopls = {
    gofumpt = true,
  },

  volar = {},

  tsserver = {},

  lua_ls = {
    Lua = {
      format = {
        enable = true,
        quote_style = "double",
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- setup neovim lua configuration
require("neodev").setup({
  override = function(root_dir, library)
    if root_dir:find(".config/nvim", 1, true) == 1 then
      library.enabled = true
      library.plugins = true
    end
  end,
})

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    })
  end,
})

-- :help cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

---@diagnostic disable-next-line: missing-fields
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  ---@diagnostic disable-next-line: missing-fields
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = cmp.mapping.preset.insert({
    ["<cr>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

-- colorscheme
local hl = vim.api.nvim_set_hl

hl(0, "String", { ctermfg = "green" })
hl(0, "Statement", { ctermfg = "blue" })
hl(0, "Constant", { ctermfg = "red" })
hl(0, "Type", { ctermfg = "blue" })
hl(0, "Comment", { ctermfg = "lightgray" })
hl(0, "LineNr", { ctermfg = "lightgray", ctermbg = "black" })
hl(0, "Identifier", { ctermfg = "NONE" })
hl(0, "DiagnosticSignInfo", { ctermfg = "blue", ctermbg = "black" })
hl(0, "DiagnosticSignWarn", { ctermfg = "darkyellow", ctermbg = "black" })
hl(0, "DiagnosticSignError", { ctermfg = "darkred", ctermbg = "black" })
hl(0, "BgBlack", { ctermfg = "NONE", ctermbg = "black" })
hl(0, "NormalFloat", { link = "BgBlack" })
hl(0, "diffRemoved", { ctermfg = "darkred" })
hl(0, "diffAdded", { ctermfg = "green" })
hl(0, "diffFile", { link = "Normal" })
hl(0, "diffOldFile", { link = "Normal" })
hl(0, "diffNewFile", { link = "Normal" })
hl(0, "PreProc", { link = "Normal" })
hl(0, "Special", { link = "Normal" })
hl(0, "Underlined", { ctermfg = "NONE", ctermbg = "NONE", underline = true })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo", linehl = "BgBlack" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn", linehl = "BgBlack" })
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError", linehl = "BgBlack" })

require("local")
