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

		lspconfig["gopls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["pylyzer"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
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