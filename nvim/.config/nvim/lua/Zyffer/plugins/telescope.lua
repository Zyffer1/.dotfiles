return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },

    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end },
      { "<leader>fb", function() require("telescope.builtin").buffers() end },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end },
    },

    config = function()
      local telescope = require("telescope")
      local themes = require("telescope.themes")

      telescope.setup({
        extensions = {
          ["ui-select"] = themes.get_dropdown({}),
        },
      })

      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
