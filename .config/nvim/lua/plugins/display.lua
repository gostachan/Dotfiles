return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = {
			char = "|",
		},
		whitespace = {
			remove_blankline_trail = false,
		},
		scope = {
			enabled = true,
			show_start = true,
			show_end = true,
		},
		exclude = {
			filetypes = { "help", "terminal", "dashboard" },
		},
	},
}
