return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help" },
    },

    config = function()
      local telescope = require("telescope")
      local themes = require("telescope.themes")

      telescope.setup({
        defaults = themes.get_ivy({}), -- ivy layout everywhere

        pickers = {
          find_files = {
            hidden = true, -- show dotfiles
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
        },
      })
    end,
  },
}
