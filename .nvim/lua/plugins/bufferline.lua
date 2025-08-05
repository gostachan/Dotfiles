return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				separator_style = "slant",
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "center",
						separator = true,
					},
				},
			},
		})
		vim.keymap.set("n", "<M-a>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev file" })
		vim.keymap.set("n", "<M-b>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next file" })
		vim.keymap.set("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Delete current buffer" })
	end,
}
