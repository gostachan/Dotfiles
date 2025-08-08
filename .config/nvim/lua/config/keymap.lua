-- Ecs
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })
vim.keymap.set("i", "Jk", "<Esc>", { desc = "Exit insert mode with jk" })
vim.keymap.set("i", "jK", "<Esc>", { desc = "Exit insert mode with jk" })
vim.keymap.set("i", "JK", "<Esc>", { desc = "Exit insert mode with jk" })

-- ヤンク
vim.keymap.set("v", "y", '"0y', { desc = "Yank to internal register only" })
vim.keymap.set("n", "p", '"0p', { desc = "Paste from internal register only" })
vim.keymap.set("n", "P", '"0P', { desc = "Paste before from internal register only" })
-- OS ショートカットをKarabinerでブロック
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to system clipboard in visual mode" }) 
vim.keymap.set("n", "d", '"0d', { noremap = true, desc = "Delete without affecting clipboard" })
vim.keymap.set("n", "x", '"0x', { noremap = true, desc = "Delete char without affecting clipboard" })
vim.keymap.set("v", "d", '"0d', { noremap = true, desc = "Delete in visual mode without affecting clipboard" })
vim.keymap.set("v", "x", '"0x', { noremap = true, desc = "Delete in visual mode without affecting clipboard" })

-- 選択行を移動 
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up", silent = true })

-- Escで検索のハイライトを消す
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- OS ショートカットをKarabinerでブロック
vim.keymap.set("n", "<M-a>", "ggVG", { desc = "Select All" })
