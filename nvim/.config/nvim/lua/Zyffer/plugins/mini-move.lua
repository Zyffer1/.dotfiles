return {
  "echasnovski/mini.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("mini.move").setup({
      mappings = {
        left = "H",
        right = "L",
        down = "J",
        up = "K",
        line_left = "",
        line_right = "",
        line_down = "",
        line_up = "",
      },
    })
  end,
}
