return {
  -- mason core
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("mason").setup()
    end,
  },

  -- LSP (mason-lspconfig)
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    priority = 999,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "cssls",
          "gopls",
          "html",
          "jsonls",
          "laravel_ls",
          "lua_ls",
          "rust_analyzer",
        },
        automatic_installation = true,
      })
    end,
  },

  -- DAP (php-debug-adapter)
  {
    "jay-babu/mason-nvim-dap.nvim",
    lazy = false,
    priority = 998,
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "php-debug-adapter",
        },
        automatic_installation = true,
      })
    end,
  },
}

