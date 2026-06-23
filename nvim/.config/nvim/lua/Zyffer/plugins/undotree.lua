return {
  "mbbill/undotree",
  keys = {
    { "<leader>u", desc = "Toggle undotree" },
  },
  config = function()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
  end,
}
