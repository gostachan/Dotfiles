return {
  {
    "Aasim-A/scrollEOF.nvim",
    event = { "CursorMoved", "WinScrolled" },
    opts = {
      pattern = "*",
      insert_mode = true,
      floating = true,
      disabled_filetypes = {
        "help",
        "TelescopePrompt",
        "neo-tree",
        "oil",
        "lazy",
        "mason",
        "noice",
        "qf",
      },
      disabled_modes = {},      -- 例: { "c" } でコマンドラインモード無効など
    },
    init = function()
      local so = vim.opt.scrolloff:get()
      if not so or so == 0 then
        vim.opt.scrolloff = 5
      end
    end,
  },
}

