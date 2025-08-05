return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			direction = "horizontal",
			shade_terminals = false,
			start_in_insert = true,
		})

		vim.keymap.set({ "n", "t" }, "<C-k><C-o>", "<cmd>ToggleTerm<CR>",
			{ desc = "Toggle terminal", noremap = true, silent = true })

		vim.keymap.set("t", "<C-,>", function()
		  vim.cmd("stopinsert") -- 挿入モード終了
		  vim.cmd("silent !tmux previous-window")
		end, { desc = "Tmux: previous-window", noremap = true, silent = true })
		vim.keymap.set("t", "<C-.>", function()
		  vim.cmd("stopinsert")
		  vim.cmd("silent !tmux next-window")
		end, { desc = "Tmux: next-window", noremap = true, silent = true })

	end,
}
