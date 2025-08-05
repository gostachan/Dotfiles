return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({
			defaults = {
				layout_strategy = "horizontal",
				sorting_strategy = "ascending",
				layout_config = {
					prompt_position = "top",
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<C-m>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
		vim.keymap.set({ "n", "v" }, "<C-g>", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
		vim.keymap.set({ "n", "v" }, "<C-b>", "<cmd>Telescope buffers<CR>", { desc = "Find buffer" })
	end,
}
