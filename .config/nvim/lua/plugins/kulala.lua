return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    {
      "<leader>Rs",
      function()
        require("kulala").run()
      end,
      desc = "Send HTTP request",
      ft = { "http", "rest" },
    },
    {
      "<leader>Rc",
      function()
        require("kulala.ui").close_kulala_buffer()
      end,
      desc = "Close Kulala result window",
      ft = { "http", "rest" },
    },
    {
      "<leader>Rt",
      function()
        require("kulala").toggle_view()
      end,
      desc = "Toggle Kulala result view",
      ft = { "http", "rest" },
    },
    {
      "<leader>Rk",
      function()
        require("kulala").show_stats()
      end,
      desc = "Show Kulala request stats",
      ft = { "http", "rest" },
    },
  },
  init = function()
    vim.filetype.add({
      extension = {
        http = "http",
        rest = "rest",
      },
    })
  end,
  opts = {
    global_keymaps = false,
    global_keymaps_prefix = "<leader>R",
    kulala_keymaps = true,
    kulala_keymaps_prefix = "",
    default_env = "dev",
    vscode_rest_client_environmentvars = true,
    request_timeout = 10000,
    ui = {
      display_mode = "split",
      split_direction = "vertical",
      default_view = "body",
      winbar = true,
      show_request_summary = true,
    },
    lsp = {
      enable = true,
      filetypes = { "http", "rest" },
      formatter = {
        indent = 2,
      },
    },
  },
}
