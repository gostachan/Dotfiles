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
        pyright = "pyright",
        intelephense = "intelephense", -- Laravel / PHP
      }

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      for name, _ in pairs(servers) do
        if name == "intelephense" then
          lspconfig[name].setup({
            capabilities = capabilities,
            settings = {
              intelephense = {
                stubs = {
                  "laravel", "apache", "bcmath", "bz2", "calendar", "core",
                  "ctype", "curl", "date", "dom", "fileinfo", "filter", "gd",
                  "hash", "iconv", "json", "libxml", "mbstring", "mcrypt",
                  "mysql", "mysqli", "openssl", "pcre", "PDO", "pdo_mysql",
                  "Phar", "readline", "Reflection", "session", "SimpleXML",
                  "sockets", "sodium", "SPL", "standard", "tokenizer", "xml",
                  "zip", "zlib"
                },
                environment = {
                  includePaths = { "vendor" }, -- Laravel の vendor 補完
                },
                files = {
                  maxSize = 5000000,
                },
              },
            },
          })
        else
          lspconfig[name].setup({
            capabilities = capabilities,
          })
        end
      end

      -- LSP 操作のキーマップ
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "<C-r>", function()
        vim.diagnostic.open_float(nil, { float = true })
      end, { desc = "Show diagnostics" })

      -- Phpactor: 未インポートクラスを import
      vim.keymap.set("n", "<Leader>u", function()
        vim.cmd("Phpactor import_class")
      end, { desc = "Import class with Phpactor" })

      -- LSP 有効中のクライアント一覧
      vim.api.nvim_create_user_command("LspInfo", function()
        print(vim.inspect(vim.lsp.get_active_clients()))
      end, {})
    end,
  },
}

