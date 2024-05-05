return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local on_attach = function(client, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      nmap("<leader>r", vim.lsp.buf.rename)
      nmap("<leader>a", vim.lsp.buf.code_action)
      vim.keymap.set("v", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr })
      nmap("<leader>e", vim.lsp.buf.hover)
      nmap("gD", vim.lsp.buf.declaration)
      nmap("gd", require("telescope.builtin").lsp_definitions)
      nmap("gr", require("telescope.builtin").lsp_references)
      nmap("gi", require("telescope.builtin").lsp_implementations)
      nmap("gy", require("telescope.builtin").lsp_type_definitions)
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    lspconfig["ruff_lsp"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["volar"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      init_options = {
        vue = {
          hybridMode = false,
        },
      },
    })

    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "templ" },
    })

    lspconfig["svelte"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["emmet_language_server"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "templ" },
    })

    vim.filetype.add({ extension = { templ = "templ" } })
    lspconfig["templ"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["tsserver"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["denols"].setup({
      root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
      init_options = {
        lint = true,
        unstable = true,
        suggest = {
          imports = {
            hosts = {
              ["https://deno.land"] = true,
              ["https://cdn.nest.land"] = true,
              ["https://crux.land"] = true,
            }
          }
        }
      },
      on_attach = function(client, bufnr)
        local active_clients = vim.lsp.get_active_clients()
        for _, active_client in pairs(active_clients) do
          -- stop tsserver if denols is active
          if active_client.name == "tsserver" then
            active_client.stop()
          end
        end
        on_attach(client, bufnr)
      end,
    })


    -- vim detects .typ files as sql
    -- we need to add this manually so that the lsp is properly attached
    vim.filetype.add({ extension = { typ = "typst" } })
    lspconfig["typst_lsp"].setup({
      capabilities = capabilities,
      on_init = function(client)
        -- enable formatting
        client.server_capabilities.documentFormattingProvider = true
      end,
      on_attach = on_attach,
      settings = {
        exportPdf = "onSave",
        experimentalFormatterMode = "On",
      },
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          -- make the language server recognize the "vim" global
          diagnostics = {
            globals = {
              "vim",
            },
          },
          workspace = {
            -- make the languages server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
  end,
}
