-- lua/plugins/treesitter-textobjects.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      ensure_installed = {
        "php","lua","vim","vimdoc","query",
        "javascript","typescript","tsx","json","html","css",
        "bash","markdown","markdown_inline","go","rust","python",
      },
      auto_install = true,

      highlight = { enable = true },

      textobjects = {
        -- ▼ 選択 (visual: v{key})
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- 関数
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            -- クラス
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            -- 条件分岐 (if/switch など)
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            -- ループ (for/while など)
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            -- ブロック ({ ... })
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            -- 引数/パラメータ
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
          },
          selection_modes = {
            ["@function.outer"]   = "V",
            ["@class.outer"]      = "V",
            ["@block.outer"]      = "V",
          },
          include_surrounding_whitespace = true,
        },

        -- ▼ 移動 (normal)
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[i"] = "@conditional.outer",
            ["[l"] = "@loop.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },

        -- ▼ 引数の並べ替え (normal) : 次/前の引数と入れ替え
        swap = {
          enable = true,
          swap_next = {
            ["]p"] = "@parameter.inner",
          },
          swap_previous = {
            ["[p"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}

