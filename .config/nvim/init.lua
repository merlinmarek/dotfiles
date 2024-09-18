require("user.options")
require("user.keymaps")
require("user.lazy")

-- apply organize imports no save
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

-- do not yank when pasting over visual selection
vim.cmd("xnoremap <expr> p '\"_d\"'.v:register.'P'")

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
vim.cmd("iabbrev newvue <script setup lang='ts'></script><template></template>")

vim.cmd.colorscheme("16term")

-- reload colorscheme when it changes
local function watch_colorscheme()
  local path = vim.fn.stdpath("config") .. "/colors/16term.lua"
  local event = vim.loop.new_fs_event()
  local function start()
    event:start(path, {}, function()
      event:stop()
      vim.schedule_wrap(function()
        vim.cmd("luafile " .. path)
        start()
      end)()
    end)
  end
  start()
end

watch_colorscheme()

vim.cmd("set spelllang=de")

require("local")
