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

	  vim.lsp.config("intelephense", {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php", "blade" },
        capabilities = capabilities,
        settings = {
          intelephense = {
            completion = {
              autoImport = true,
            },
            diagnostics = {
              undefinedTypes = true,
              undefinedSymbols = true,
            },
            environment = {
              includePaths = { "app", "vendor" },
            },
            files = {
              associations = { "*.php", "*.blade.php" },
            },
          },
        },
	  -- 定義ジャンプだけ弱いのでphpactorにやらせる
        on_attach = function(client)
          client.server_capabilities.definitionProvider = false
        end,
      })
      vim.lsp.enable("intelephense")
      
      -----------------------------------------------------
      -- Phpactor（定義ジャンプ専用）
      -----------------------------------------------------
      vim.lsp.config("phpactor", {
        cmd = { "phpactor", "language-server" },
        filetypes = { "php" },
        on_attach = function(client)
	    -- 定義ジャンプ以外弱いのでintelephenseにやらせる
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.completionProvider = nil
          client.server_capabilities.signatureHelpProvider = nil
          client.server_capabilities.renameProvider = nil
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.codeActionProvider = false
          client.server_capabilities.referencesProvider = false
          client.server_capabilities.workspaceSymbolProvider = false
          client.handlers["textDocument/publishDiagnostics"] = function() end
        end,
      })
      vim.lsp.enable("phpactor")

	  vim.lsp.enable('clangd')
    end,
  },
}

