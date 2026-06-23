return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    keys = {
      { "<leader>e", desc = "Open parent directory" },
      { "<leader>E", desc = "Toggle oil float" },
    },
    config = function()
      require("oil").setup {
        view_options = {
          show_hidden = true,
        },
        float = {
          border = "rounded",
        },
      }

      -- Open parent directory in current window
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })

      -- Open parent directory in floating window
      vim.keymap.set("n", "<leader>E", require("oil").toggle_float)
    end,
  },
}
