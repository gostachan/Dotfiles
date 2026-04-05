return {
  "numToStr/Comment.nvim",
  lazy = false,
  config = function()
    local comment = require("Comment")

    comment.setup()

    vim.keymap.set("n", "<M-c>", function()
      require("Comment.api").toggle.linewise.current()
    end, { desc = "Toggle comment (current line)" })

    vim.keymap.set("v", "<M-c>", function()
      local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
      vim.api.nvim_feedkeys(esc, "nx", false)
      require("Comment.api").toggle.linewise(vim.fn.visualmode())
    end, { desc = "Toggle comment (visual)" })
  end,
}

