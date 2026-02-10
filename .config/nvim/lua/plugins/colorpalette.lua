return {
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nord")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- プロジェクトルート取得
      local function get_project_root()
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if git_root and git_root ~= "" then
          return git_root
        end
        return vim.fn.getcwd()
      end

      -- ルートからの相対パス
      local function relative_path_from_root()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname == "" then
          return "[No Name]"
        end

        local root = get_project_root()
        return vim.fn.fnamemodify(bufname, ":." .. root)
      end

      require("lualine").setup({
        options = {
          theme = "nord",
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              relative_path_from_root,
              icon = "", -- Nerd Font（不要なら消してOK）
            },
          },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}

