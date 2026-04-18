return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    priority = 999,
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "clangd",
        "gopls",
        "pyright",
        "sqls",
        "terraformls",
      },
      automatic_enable = {
        "clangd",
        "gopls",
        "pyright",
        "sqls",
        "terraformls",
      },
    },
  },
}
