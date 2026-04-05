return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  build = "cd app && npm install",
  ft = { "markdown" },
  init = function()
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_browser = ""
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_theme = "dark"
  end,
  keys = {
    { "<leader>mp", "<Cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown Preview Toggle" },
  },
}
