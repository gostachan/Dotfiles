return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
      if vim.fn.executable("tree-sitter") == 1 then
        vim.cmd("TSUpdate")
      end
    end,
    config = function()
      local has_tree_sitter_cli = vim.fn.executable("tree-sitter") == 1
      local ts = require("nvim-treesitter")
      local ts_parsers = require("nvim-treesitter.parsers")
      local function register_kulala_parser()
        local parser_path = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "kulala.nvim", "lua", "tree-sitter")
        if not vim.uv.fs_stat(parser_path) then
          return false
        end

        vim.opt.rtp:append(parser_path)
        require("nvim-treesitter.parsers").kulala_http = {
          install_info = {
            path = parser_path,
            generate = false,
            generate_from_json = false,
            queries = "queries/kulala_http",
          },
        }

        return true
      end
      local has_kulala_parser = register_kulala_parser()

      ts.setup()

      -- telescope.nvim on 0.1.x still expects this helper from older
      -- nvim-treesitter releases.
      if ts_parsers.ft_to_lang == nil and vim.treesitter.language and vim.treesitter.language.get_lang then
        ts_parsers.ft_to_lang = function(ft)
          return vim.treesitter.language.get_lang(ft) or ft
        end
      end

      if has_tree_sitter_cli or has_kulala_parser then
        local languages = {
          "bash",
          "c",
          "cpp",
          "css",
          "go",
          "hcl",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "php",
          "python",
          "query",
          "rust",
          "sql",
          "terraform",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
        }
        if has_kulala_parser then
          table.insert(languages, "kulala_http")
        end

        local installed = {}
        for _, lang in ipairs(ts.get_installed("parsers")) do
          installed[lang] = true
        end

        local missing = {}
        for _, lang in ipairs(languages) do
          if not installed[lang] then
            table.insert(missing, lang)
          end
        end

        if #missing > 0 then
          vim.schedule(function()
            ts.install(missing, { summary = true })
          end)
        end
      else
        vim.schedule(function()
          vim.notify(
            "tree-sitter CLI not found. Parser auto-install is disabled until the CLI is installed (`brew install tree-sitter-cli`).",
            vim.log.levels.WARN,
            { title = "nvim-treesitter" }
          )
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dotfiles-treesitter-highlight", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
            ["@block.outer"] = "V",
          },
          include_surrounding_whitespace = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      for _, mode in ipairs({ "x", "o" }) do
        vim.keymap.set(mode, "af", function()
          select.select_textobject("@function.outer", "textobjects")
        end)
        vim.keymap.set(mode, "if", function()
          select.select_textobject("@function.inner", "textobjects")
        end)
        vim.keymap.set(mode, "ac", function()
          select.select_textobject("@class.outer", "textobjects")
        end)
        vim.keymap.set(mode, "ic", function()
          select.select_textobject("@class.inner", "textobjects")
        end)
        vim.keymap.set(mode, "ai", function()
          select.select_textobject("@conditional.outer", "textobjects")
        end)
        vim.keymap.set(mode, "ii", function()
          select.select_textobject("@conditional.inner", "textobjects")
        end)
        vim.keymap.set(mode, "al", function()
          select.select_textobject("@loop.outer", "textobjects")
        end)
        vim.keymap.set(mode, "il", function()
          select.select_textobject("@loop.inner", "textobjects")
        end)
        vim.keymap.set(mode, "ab", function()
          select.select_textobject("@block.outer", "textobjects")
        end)
        vim.keymap.set(mode, "ib", function()
          select.select_textobject("@block.inner", "textobjects")
        end)
        vim.keymap.set(mode, "ao", function()
          select.select_textobject("@parameter.outer", "textobjects")
        end)
        vim.keymap.set(mode, "io", function()
          select.select_textobject("@parameter.inner", "textobjects")
        end)
      end

      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]m", function()
        move.goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]i", function()
        move.goto_next_start("@conditional.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]l", function()
        move.goto_next_start("@loop.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]M", function()
        move.goto_next_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]C", function()
        move.goto_next_end("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[m", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[i", function()
        move.goto_previous_start("@conditional.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[l", function()
        move.goto_previous_start("@loop.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[M", function()
        move.goto_previous_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[C", function()
        move.goto_previous_end("@class.outer", "textobjects")
      end)
    end,
  },
}
