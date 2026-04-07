return {
  "kylechui/nvim-surround",
  version = "^4.0.0",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({})

    vim.keymap.set("n", "<leader>sa", "ys", { remap = true, desc = "Add surround" })
    vim.keymap.set("x", "<leader>sa", "S", { remap = true, desc = "Add surround" })
    vim.keymap.set("n", "<leader>sd", "ds", { remap = true, desc = "Delete surround" })
    vim.keymap.set("n", "<leader>sr", "cs", { remap = true, desc = "Change surround" })
  end,
}
