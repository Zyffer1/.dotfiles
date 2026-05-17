return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,

  config = function()
    require("rose-pine").setup({
      variant = "moon",

      styles = {
        transparency = true,
      },
    })

    vim.cmd("colorscheme rose-pine")
  end,
}
--return {
--  {
--    "catppuccin/nvim",
--    name = "catppuccin",
--    priority = 1000,
--    opts = {
--      flavour = "mocha",
--      transparent_background = true,
--    },
--    config = function(_, opts)
--      require("catppuccin").setup(opts)
--      vim.cmd.colorscheme("catppuccin")
--    end,
--  },
--}
