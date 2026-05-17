return {
  "nvim-mini/mini.move",
  version = false,

  config = function()
    require("mini.move").setup({
      mappings = {
        left = "H",
        right = "L",
        down = "J",
        up = "K",

        line_left = "H",
        line_right = "L",
        line_down = "J",
        line_up = "K",
      },

      options = {
        reindent_linewise = true,
      },
    })
  end,
}
