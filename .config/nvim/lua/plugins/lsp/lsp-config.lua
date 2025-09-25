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
      -- ===== Common =====
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- root_pattern を Neovim 標準APIで実装（lspconfig.util 依存を排除）
      local function root_pattern(patterns)
        return function(fname)
          local start = fname
          if not start or start == "" then
            local bufname = vim.api.nvim_buf_get_name(0)
            start = (bufname ~= "" and bufname) or vim.loop.cwd()
          end
          local dir = vim.fs.dirname(start)
          local found = vim.fs.find(patterns, { path = dir, upward = true })[1]
          return found and vim.fs.dirname(found) or nil
        end
      end

      local function git_root()
        return root_pattern({ ".git" })(vim.api.nvim_buf_get_name(0))
      end

      local function is_laravel_root(root)
        if not root or root == "" then return false end
        if vim.fn.filereadable(root .. "/composer.json") == 1 then
          local ok, lines = pcall(vim.fn.readfile, root .. "/composer.json")
          if ok and table.concat(lines, "\n"):find([["laravel/framework"]]) then
            return true
          end
        end
        return vim.fn.isdirectory(root .. "/vendor/laravel") == 1
      end

      vim.diagnostic.config({
        virtual_text = { source = "always" },
        float        = { source = "always" },
      })

      local function on_attach_once(client, _)
        -- 同一 name & root_dir の多重 attach を防ぐ
        local same_name = vim.lsp.get_clients({ name = client.name })
        for _, c in ipairs(same_name) do
          if c.id ~= client.id
             and c.config and client.config
             and c.config.root_dir == client.config.root_dir
          then
            client:stop()
            return
          end
        end
        -- phpactor の診断を Laravel プロジェクトでは抑制
        if client.name == "phpactor" then
          local root = (client.config and client.config.root_dir) or git_root()
          if is_laravel_root(root) then
            client.server_capabilities.diagnosticProvider = false
          end
        end
      end

      -- 新APIで登録
      local function register(name, extra)
        local cfg = {
          capabilities = capabilities,
          on_attach   = on_attach_once,
        }
        if extra then
          for k, v in pairs(extra) do cfg[k] = v end
        end
        vim.lsp.config(name, cfg)
      end

      -- Mason のバイナリディレクトリ
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

      -- 対応サーバ一覧（ensure_installed と合わせる想定）
      local servers = {
        "clangd",
        "cssls",
        "gopls",
        "html",
        "jsonls",
        "laravel_ls",
        "lua_ls",
        "rust_analyzer",
      }

      -- 個別設定
      for _, server in ipairs(servers) do
        if server == "laravel_ls" then
          register("laravel_ls", {
            root_dir = root_pattern({ "composer.json", ".git" }),
            -- “you need to make through the path to laravel_ls” → Mason の実行ファイルを明示
            cmd = { mason_bin .. "/laravel-ls" },
          })
        elseif server == "lua_ls" then
          register("lua_ls", {
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                workspace   = { checkThirdParty = false },
              },
            },
          })
        else
          register(server)
        end
      end

      -- Terraform の拡張子補完
      vim.filetype.add({ extension = { tr = "terraform" } })

      -- Phpactor import
      vim.keymap.set("n", "<Leader>u", function()
        vim.cmd("Phpactor import_class")
      end, { desc = "Import class with Phpactor" })

      -- 現バッファに attach 済みのクライアント簡易表示
      vim.api.nvim_create_user_command("LspInfo", function()
        print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))
      end, {})
    end,
  },
}

