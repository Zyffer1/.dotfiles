return {
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          position = "float",
          border = "rounded",
        },
      },
    },
    keys = {
      {
        "<leader>t",
        function()
          Snacks.terminal.toggle()
        end,
        desc = "Floating terminal",
      },
    },
  },
}
