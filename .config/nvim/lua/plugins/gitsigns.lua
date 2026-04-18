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
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
    })
  end,
}
