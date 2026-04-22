return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("diffview").setup({
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
        },
      },
    })
  end,
}
