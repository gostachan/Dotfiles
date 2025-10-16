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

      -----------------------------------------------------
      -- smart_rename (Phpactor優先)
      -----------------------------------------------------
      local function smart_rename()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
          vim.notify("No LSP client attached", vim.log.levels.WARN)
          return
        end

        -- Phpactorが有効なら優先してrename
        for _, client in ipairs(clients) do
          if client.name == "phpactor" and client.server_capabilities.renameProvider then
            vim.lsp.buf.rename()
            return
          end
        end

        -- Phpactorがない場合はfallback（intelephenseなど）
        for _, client in ipairs(clients) do
          if client.server_capabilities.renameProvider then
            vim.lsp.buf.rename()
            return
          end
        end

        vim.notify("No LSP supports rename for this file", vim.log.levels.WARN)
      end

      -----------------------------------------------------
      -- intelephense 設定 (laravelでは基本これを使う)
      -----------------------------------------------------
      vim.lsp.config("intelephense", {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php", "blade" },
        capabilities = capabilities,
        settings = {
          intelephense = {
            completion = { autoImport = true },
            diagnostics = {
              undefinedTypes = true,
              undefinedSymbols = true,
            },
            environment = { includePaths = { "app", "vendor" } },
            files = { associations = { "*.php", "*.blade.php" } },
          },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.definitionProvider = false
          client.server_capabilities.renameProvider = false

          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "cd", smart_rename, opts)
          vim.keymap.set("n", "<leader>rn", smart_rename, opts)
        end,
      })
      vim.lsp.enable("intelephense")

      -----------------------------------------------------
      -- Phpactor 設定 (definitionProvider, renameProviderだけphpactor)
      -----------------------------------------------------
      vim.lsp.config("phpactor", {
        cmd = { "phpactor", "language-server" },
        filetypes = { "php" },
        on_attach = function(client, bufnr)
          -- phpactorはrename対応にする
          client.server_capabilities.renameProvider = true
          -- hover, completionなどはintelephenseに任せる
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.completionProvider = nil
          client.server_capabilities.signatureHelpProvider = nil
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.codeActionProvider = false
          client.server_capabilities.referencesProvider = false
          client.server_capabilities.workspaceSymbolProvider = false
          client.handlers["textDocument/publishDiagnostics"] = function() end
        end,
      })
      vim.lsp.enable("phpactor")

      vim.lsp.enable("clangd")

	  vim.o.updatetime = 100
	  vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local diags = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
          if vim.tbl_isempty(diags) then return end
          local msg = table.concat(vim.tbl_map(function(d) return d.message end, diags), " | ")
          vim.api.nvim_echo({{msg, "WarningMsg"}}, false, {})
        end
      })

    end,
  },
}

