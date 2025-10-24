return {
  {
    "phpactor/phpactor",
    ft = "php",
    build = "composer install --no-dev -o",
    config = function()
      vim.keymap.set("n", "<leader>pc", ":PhpactorClassNew<CR>", { noremap = true, silent = true, desc = "Phpactor: Create new class" })
      -- vim.keymap.set("n", "<leader>pi", ":PhpactorImportClass<CR>", { noremap = true, silent = true, desc = "Phpactor: Import class" })
      -- vim.keymap.set("n", "<leader>pr", ":PhpactorRenameFile<CR>", { noremap = true, silent = true, desc = "Phpactor: Rename class/file" })
    end,
  },
}

