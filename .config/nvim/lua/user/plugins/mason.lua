return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		mason.setup({})

		mason_lspconfig.setup({
			ensure_installed = {
				"gopls",
				"lua_ls",
				"pylyzer",
			},
		})
		-- -- golang
		--   gopls = {
		--     gofumpt = true,
		--   },
		--   golangci_lint_ls = {},
		--
		--   -- python
		--   pylyzer = {},
		--   ruff_lsp = {},
		--
		--   -- typescript
		--   denols = {},
		--   tsserver = {},
		--
		--   -- vue
		--   volar = {},
		--
		--   -- lua
		--   lua_ls = {
		--     Lua = {
		--       format = {
		--         enable = true,
		--         quote_style = "double",
		--       },
		--       workspace = { checkThirdParty = false },
		--       telemetry = { enable = false },
		--     },
		--   },
	end,
}
