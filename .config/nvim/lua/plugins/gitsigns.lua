return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>gd",
      function()
        require("gitsigns").preview_hunk_inline()
      end,
      desc = "Preview current hunk inline",
    },
    {
      "<leader>gq",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview current hunk in popup",
    },
    {
      "]h",
      function()
        require("gitsigns").next_hunk()
      end,
      desc = "Next git hunk",
    },
    {
      "[h",
      function()
        require("gitsigns").prev_hunk()
      end,
      desc = "Previous git hunk",
    },
  },
  config = function()
    local function set_gitsigns_highlights()
      vim.api.nvim_set_hl(0, "GitSignsAddInline", { bg = "#3B4B3F" })
      vim.api.nvim_set_hl(0, "GitSignsChangeInline", { bg = "#3B4654" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { bg = "#553B40" })

      vim.api.nvim_set_hl(0, "GitSignsAddLnInline", { bg = "#3B4B3F" })
      vim.api.nvim_set_hl(0, "GitSignsChangeLnInline", { bg = "#3B4654" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteLnInline", { bg = "#553B40" })

      vim.api.nvim_set_hl(0, "GitSignsDeleteVirtLn", { bg = "#553B40" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteVirtLnInLine", { bg = "#553B40" })
      vim.api.nvim_set_hl(0, "GitSignsVirtLnum", { fg = "#4C566A", bg = "#553B40" })
    end

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

    set_gitsigns_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("dotfiles-gitsigns-highlights", { clear = true }),
      callback = set_gitsigns_highlights,
    })
  end,
}
