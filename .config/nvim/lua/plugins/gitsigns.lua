return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
      },
      signcolumn = true,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
    })
  end,
}

