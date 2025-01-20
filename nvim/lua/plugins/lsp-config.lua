return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"tsserver",
					"bashls",
					"jsonls",
					"rust_analyzer",
					"cmake",
					"marksman",
					"yamlls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.tsserver.setup({})
			lspconfig.bashls.setup({})
			lspconfig.jsonls.setup({})
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						diagnostics = {
							enable = false,
						},
					},
				},
			})
			lspconfig.cmake.setup({})
			lspconfig.marksman.setup({})
			lspconfig.yamlls.setup({})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
