return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 1000,

    dependencies = {
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
              ["<C-c>"]   = cmp.mapping.complete(),
              ["<CR>"]    = cmp.mapping.confirm({ select = true }),
              ["<Tab>"]   = cmp.mapping.select_next_item(),
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
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
	  capabilities.general = {
	    positionEncodings = { "utf-8" },
	  }

	  -- Laravel LS（hover / completion 用）
      vim.lsp.config("laravel_ls", {
        cmd = { "laravel-ls" },
        filetypes = { "php", "blade" },
        capabilities = capabilities,
        on_attach = function(client)
          client.server_capabilities.definitionProvider = false
        end,
      })
      vim.lsp.enable("laravel_ls")
      
	  vim.lsp.config("phpactor", {
        cmd = { "phpactor", "language-server" },
        filetypes = { "php" },
        on_attach = function(client)
          -- Phpactor の診断を完全無視
          client.handlers["textDocument/publishDiagnostics"] = function() end
          -- Hover など不要機能も無効化
          client.server_capabilities.hoverProvider = false
          -- client.server_capabilities.completionProvider = nil
        end,
      })
      vim.lsp.enable("phpactor")

	  vim.lsp.enable('clangd')
    end,
  },
}

