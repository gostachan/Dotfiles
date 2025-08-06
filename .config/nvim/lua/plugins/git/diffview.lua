return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
  },
  keys = {
    {
      "<leader>gd",
      "<cmd>DiffviewOpen -- %<CR>",
      desc = "Diff current file",
    },
    {
      "<leader>gD",
      "<cmd>DiffviewFileHistory %<CR>",
      desc = "History of current file",
    },
  },
  config = function()
    require("diffview").setup({
      use_icons = false,
      file_panel = {
        listing_style = "list",
        win_config = {
          position = "left",
          width = 30,
        },
      },
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      keymaps = {
        view = {
          { "n", "<tab>", require("diffview.actions").select_next_entry },
          { "n", "<s-tab>", require("diffview.actions").select_prev_entry },
        },
      },
    })
  end,
}


