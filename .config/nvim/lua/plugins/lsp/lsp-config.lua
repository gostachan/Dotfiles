

---------------------------------------------------------------------------
---you need to make throgh the path to laravel_ls
---------------------------------------------------------------------------



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
              ["<C-c>"]  = cmp.mapping.complete(),
              ["<CR>"]   = cmp.mapping.confirm({ select = true }),
              ["<Tab>"]  = cmp.mapping.select_next_item(),
              ["<S-Tab>"]= cmp.mapping.select_prev_item(),
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
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      local servers = {
        -- Mason ensure_installed と対応
        "clangd",
        "cssls",
        "gopls",
        "html",
        "jsonls",
        "laravel_ls",
        "lua_ls",
        "rust_analyzer",
      }

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
        float = { source = "always" },
      })

      local function on_attach_once(client, _)
        local same_name = vim.lsp.get_clients({ name = client.name })
        for _, c in ipairs(same_name) do
          if c.id ~= client.id
             and c.config and client.config
             and c.config.root_dir == client.config.root_dir then
            client:stop()
            return
          end
        end
        if client.name == "phpactor" then
          local root = (client.config and client.config.root_dir) or util.find_git_ancestor(vim.loop.cwd())
          if is_laravel_root(root) then
            client.server_capabilities.diagnosticProvider = false
          end
        end
      end

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

      for _, server in ipairs(servers) do
        if server == "laravel_ls" then
          setup_with("laravel_ls", {
            root_dir = util.root_pattern("composer.json", ".git"),
            cmd = { vim.fn.stdpath("data") .. "/mason/bin/laravel-ls" },
          })
        elseif server == "lua_ls" then
          setup_with("lua_ls", {
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
              },
            },
          })
        else
          setup_with(server)
        end
      end

      vim.filetype.add({ extension = { tr = "terraform" } })

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "<Leader>u", function() vim.cmd("Phpactor import_class") end,
        { desc = "Import class with Phpactor" })

      vim.api.nvim_create_user_command("LspInfo", function()
        print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))
      end, {})
    end,
  },
}

