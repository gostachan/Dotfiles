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

      -- 1) 対象サーバ
      local servers = {
        "clangd",
        -- "phpactor",
        "html",
        "cssls",
        "rust_analyzer",
        "laravel_ls",
        "intelephense",
      }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- Laravel 判定（composer.json に "laravel/framework" か vendor/laravel/ があるか）
      local function is_laravel_root(root)
        if not root or root == "" then return false end
        if vim.fn.filereadable(root .. "/composer.json") == 1 then
          local ok, lines = pcall(vim.fn.readfile, root .. "/composer.json")
          if ok then
            local txt = table.concat(lines, "\n")
            if txt:find([["laravel/framework"]]) then
              return true
            end
          end
        end
        if vim.fn.isdirectory(root .. "/vendor/laravel") == 1 then
          return true
        end
        return false
      end

      -- 2) 診断の出所を常に表示（どのLSPが警告出してるか可視化）
      vim.diagnostic.config({
        virtual_text = { source = "always" },
        float = { source = "always" },
      })

      -- 3) 重複 attach 防止（同名 & 同root の2重起動のみ止める）
      local function on_attach_once(client, bufnr)
        local same_name = vim.lsp.get_clients({ name = client.name })
        for _, c in ipairs(same_name) do
          if c.id ~= client.id and c.config and client.config
             and c.config.root_dir == client.config.root_dir then
            client:stop()
            return
          end
        end

        -- Laravel プロジェクトでは phpactor の診断を無効化（view() 未定義等の誤検知対策）
        if client.name == "phpactor" then
          local root = (client.config and client.config.root_dir) or util.find_git_ancestor(vim.loop.cwd())
          if is_laravel_root(root) then
            client.server_capabilities.diagnosticProvider = false
          end
        end
      end

      -- 4) サーバ個別設定をマージして setup するヘルパ
      local function setup_with(name, extra)
        local base = {
          capabilities = capabilities,
          on_attach = on_attach_once,
        }
        if extra then
          for k, v in pairs(extra) do base[k] = v end
        end
        lspconfig[name].setup(base)
      end

      -- 5) 各サーバセットアップ（旧 mason-lspconfig 互換の手動ループ）
      for _, server in ipairs(servers) do
        if server == "laravel_ls" then
          setup_with("laravel_ls", {
            root_dir = util.root_pattern("composer.json", ".git"),
            -- filetypes = { "php", "blade" }, -- 必要なら明示
          })

        elseif server == "intelephense" then
          local cwd = vim.loop.cwd()
          setup_with("intelephense", {
            settings = {
              intelephense = {
                environment = {
                  includePaths = { cwd .. "/vendor" },
                },
                stubs = {
                  "apache","bcmath","bz2","calendar","Core","curl","date","dom","fileinfo","filter",
                  "gd","hash","iconv","json","libxml","mbstring","mcrypt","mysql","mysqli","password",
                  "pcre","PDO","pdo_mysql","pdo_sqlite","pgsql","Phar","readline","regex","session",
                  "SimpleXML","soap","sockets","sodium","sqlite3","standard","tokenizer","xml","xmlreader",
                  "xmlwriter","xsl","zip","zlib","laravel",
                },
                -- 必要に応じて誤検知を抑制
                -- diagnostics = { undefinedFunctions = false },
              },
            },
          })

        else
          setup_with(server)
        end
      end

      -- 6) ファイルタイプ拡張
      vim.filetype.add({
        extension = {
          tr = "terraform",
        },
      })

      -- 7) キーマップ
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

      -- Phpactor: 未インポートクラスを import
      vim.keymap.set("n", "<Leader>u", function()
        vim.cmd("Phpactor import_class")
      end, { desc = "Import class with Phpactor" })

      -- 8) 現在のバッファに attach しているLSP一覧（新API）
      vim.api.nvim_create_user_command("LspInfo", function()
        print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))
      end, {})
    end,
  },
}

