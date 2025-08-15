return {
	"stevearc/oil.nvim",
	lazy = false,
	priority = 1000,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{
			"benomahony/oil-git.nvim",
			dependencies = { "stevearc/oil.nvim" },
			opts = {
				highlights = {
					OilGitAdded     = { fg = "#a6e3a1" }, -- green
					OilGitModified  = { fg = "#f9e2af" }, -- yellow  
					OilGitDeleted   = { fg = "#f38ba8" }, -- red
					OilGitRenamed   = { fg = "#cba6f7" }, -- purple
					OilGitUntracked = { fg = "#89b4fa" }, -- blue
					OilGitIgnored   = { fg = "#6c7086" }, -- gray
				}
			}
		},
	},

	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			desc = "Open parent directory with oil.nvim",
		},
	},

	config = function()
		require("oil").setup({
			--------------------------------------------------------------------------
			-- 基本設定
			--------------------------------------------------------------------------
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = false,
			prompt_save_on_select_new_entry = true,
			cleanup_delay_ms = 2000,

			--------------------------------------------------------------------------
			-- LSP ファイル操作
			--------------------------------------------------------------------------
			lsp_file_methods = {
				enabled = true,
				timeout_ms = 1000,
				autosave_changes = false,
			},

			--------------------------------------------------------------------------
			-- カーソルと自動リロード
			--------------------------------------------------------------------------
			constrain_cursor = "editable",
			watch_for_changes = false,

			--------------------------------------------------------------------------
			-- キーマップ
			--------------------------------------------------------------------------
			keymaps = {
				["g?"]    = { "actions.show_help", mode = "n" },
				["<CR>"]  = "actions.select",
				["<C-z>"] = "actions.refresh",
				["<C-h>"] = { "actions.parent", mode = "n" },
				["<C-l>"] = "actions.select",
				["g."]    = { "actions.open_cwd", mode = "n" },
				["c."]    = { "actions.cd", mode = "n" },
				["cs"]    = { "actions.change_sort", mode = "n" },
				["gx"]    = "actions.open_external",
				["<Esc>"] = { "actions.close", mode = "n" },
				["<C-p>"] = { "actions.preview", mode = "n" }, 
			},
			use_default_keymaps = true,

			--------------------------------------------------------------------------
			-- ビューオプション
			--------------------------------------------------------------------------
			view_options = {
				show_hidden = true,
				is_hidden_file = function(name) return name:match("^%.") ~= nil end,
				is_always_hidden = function() return false end,
				natural_order = "fast",
				case_insensitive = false,
				sort = {
					{ "type", "asc" },
					{ "name", "asc" },
				},
			},

			--------------------------------------------------------------------------
			-- git 操作（無効化）
			--------------------------------------------------------------------------
			git = {
				add = function() return false end,
				mv  = function() return false end,
				rm  = function() return false end,
			},

			--------------------------------------------------------------------------
			-- フロート設定（プレビュー位置を右側に固定）
			--------------------------------------------------------------------------
			float = {
				padding       = 2,
				max_width     = 0,
				max_height    = 0,
				border        = "rounded",
				win_options   = { winblend = 0 },
				preview_split = "right",
				override      = function(conf) return conf end,
			},

			--------------------------------------------------------------------------
			-- プレビューウィンドウ設定
			--------------------------------------------------------------------------
			preview_win = {
				update_on_cursor_moved = true,
				preview_method = "fast_scratch",
				disable_preview = function() return false end,
				win_options = {},
			},

			--------------------------------------------------------------------------
			-- そのほか UI（confirmation / progress / ssh / help）
			--------------------------------------------------------------------------
			confirmation = {
				max_width   = 0.9,
				min_width   = { 40, 0.4 },
				max_height  = 0.9,
				min_height  = { 5, 0.1 },
				border      = "rounded",
				win_options = { winblend = 0 },
			},
			progress = {
				max_width        = 0.9,
				min_width        = { 40, 0.4 },
				max_height       = { 10, 0.9 },
				min_height       = { 5, 0.1 },
				border           = "rounded",
				minimized_border = "none",
				win_options      = { winblend = 0 },
			},
			ssh = { border = "rounded" },
			keymaps_help = { border = "rounded" },
		})

		-- oil-git 設定
		require("oil-git").setup({
			highlights = {
				OilGitAdded     = { fg = "#a6e3a1" }, -- green
				OilGitModified  = { fg = "#f9e2af" }, -- yellow  
				OilGitDeleted   = { fg = "#f38ba8" }, -- red
				OilGitRenamed   = { fg = "#cba6f7" }, -- purple
				OilGitUntracked = { fg = "#89b4fa" }, -- blue
				OilGitIgnored   = { fg = "#6c7086" }, -- gray
			}
		})

		--------------------------------------------------------------------------
		-- Neovim 起動時にディレクトリ指定があれば Oil を開く
		--------------------------------------------------------------------------
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				local path = vim.fn.argv(0)
				if path ~= "" and vim.fn.isdirectory(path) == 1 then
					require("oil").open(path)
				end
			end,
		})
	end,
}

