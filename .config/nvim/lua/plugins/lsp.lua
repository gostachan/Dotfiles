return {
	{
	  "neovim/nvim-lspconfig",
	  lazy = false,
	  priority = 1000,
	  dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",

		{
		  "hrsh7th/nvim-cmp",
		  dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		  },
		  config = function()
			local cmp = require("cmp")
			cmp.setup({
			  mapping = cmp.mapping.preset.insert({
				["<C-c>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
			  }),
			  sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
			  }),
			})
		  end,
		},
	  },
	  config = function()
		require("mason").setup()

		local servers = {
		  clangd = "clangd",
		  phpactor = "phpactor",
		  html = "html",
		  cssls = "cssls",
		  rust_analyzer = "rust_analyzer",
		  gopls = "gopls",
		  pyright = "pyright",
		}

		require("mason-lspconfig").setup({
		  ensure_installed = vim.tbl_keys(servers),
		  automatic_installation = true,
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local lspconfig = require("lspconfig")

		for _, name in pairs(servers) do
		  lspconfig[name].setup({
			capabilities = capabilities,
		  })
		end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
		vim.keymap.set("n", "<C-r>", function()
		  vim.diagnostic.open_float(nil, { float = true })
		end, { desc = "Show diagnostics" })
		vim.api.nvim_create_user_command("LspInfo", function()
		  print(vim.inspect(vim.lsp.get_active_clients()))
		end, {})
	  end,
	}
}


