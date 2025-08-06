require("config.lazy")
require("config.keymap")

vim.opt.ttimeoutlen = 0
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false
vim.opt.number = true
vim.opt.clipboard:append({"unnamedplus"})
vim.g.neovide_input_use_logo = true
vim.opt.ignorecase = true  -- 通常は大文字小文字を無視
vim.opt.smartcase  = true  -- 大文字を含むときのみ区別


