return {
  -- UI Select (for nicer vim.ui.select)
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },

  -- Telescope core
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local themes = require("telescope.themes")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },

          -- ここを有効にすると .env など ignore 済み・隠しファイルも候補に入ります
          hidden = true,
          no_ignore = true,

          file_ignore_patterns = {
            "node_modules",
            ".ruff_cache",
            ".git/",
            ".mypy_cache",
          },
        },
        pickers = {
          -- find_files は .gitignore を無視して隠しファイルも拾う
          find_files = {
            hidden = true,
            no_ignore = true,
            file_ignore_patterns = {
              "node_modules",
              ".ruff_cache",
              ".git/",
              ".mypy_cache",
            },
            -- fd が入っているなら明示指定してより確実に
            -- コメントアウトで自動検出にも任せられます
            -- find_command = { "fd", "--type", "f", "--hidden", "--no-ignore" },
          },
          -- live_grep も ignore を無視＆隠しファイル対象に
          live_grep = {
            additional_args = function()
              return { "--hidden", "--no-ignore" }
            end,
          },
        },
        extensions = {
          ["ui-select"] = themes.get_dropdown({}),
        },
      })

      telescope.load_extension("ui-select")

      -- キーマップ（.env 等も検索対象に含まれる）
      vim.keymap.set({ "n", "v" }, "<C-m>", function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end, { desc = "Find files (include hidden & ignored)" })

      vim.keymap.set({ "n", "v" }, "<C-g>", function()
        builtin.live_grep({
          additional_args = function() return { "--hidden", "--no-ignore" } end,
        })
      end, { desc = "Live grep (include hidden & ignored)" })

      vim.keymap.set({ "n", "v" }, "<C-b>", builtin.buffers, { desc = "Find buffer" })
    end,
  },
}

