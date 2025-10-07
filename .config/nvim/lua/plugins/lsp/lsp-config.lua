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
      -- ====== 共通Capability ======
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- ====== 汎用root判定（Neovim標準API） ======
      local function root_pattern(patterns)
        return function(fname)
          local start = (fname ~= "" and fname) or vim.api.nvim_buf_get_name(0)
          if not start or start == "" then start = vim.loop.cwd() end
          local dir = vim.fs.dirname(start)
          local found = vim.fs.find(patterns, { path = dir, upward = true })[1]
          return found and vim.fs.dirname(found) or nil
        end
      end

      -- ====== Laravel検出（composer.jsonに"laravel/framework"を含む） ======
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

      -- ====== Diagnostics表示設定 ======
      vim.diagnostic.config({
        virtual_text = { source = "always" },
        float        = { source = "always" },
      })

      -- ====== Laravel Language Server（常時有効 / 自動attach） ======
	  vim.lsp.config("laravel_ls", {
        cmd = { "laravel-ls" },
        filetypes = { "php", "blade" },
        root_dir = function(fname)
          local root = root_pattern({ "composer.json", ".git" })(fname)
          return root or vim.loop.cwd()
        end,
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          general = {
            positionEncodings = { "utf-8" },
          },
        }),
      })
      vim.lsp.enable("laravel_ls")

      -- ====== Lua LS（Neovim自体の設定用） ======
      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
          },
        },
        capabilities = capabilities,
      })
      pcall(vim.lsp.enable, "lua_ls")

      -- ====== Phpactor import（任意） ======
      vim.keymap.set("n", "<Leader>u", function()
        vim.cmd("Phpactor import_class")
      end, { desc = "Import class with Phpactor" })

      -- ====== attachデバッグ ======
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          print("✅ LSP attached:", client.name, "→", client.config.root_dir)
        end,
      })

      -- ====== 自動起動保証（保険） ======
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "php", "blade" },
        callback = function()
          local clients = vim.lsp.get_clients({ name = "laravel_ls", bufnr = 0 })
          if #clients == 0 then
            vim.cmd("LspStart laravel_ls")
          end
        end,
      })
    end,
  },
}

