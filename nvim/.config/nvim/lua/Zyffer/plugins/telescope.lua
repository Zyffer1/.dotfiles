return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },

    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end },
      { "<leader>fb", function() require("telescope.builtin").buffers() end },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end },
      { "<leader>b",  function() require("telescope.builtin").builtin() end },
    },

    config = function()
      local telescope = require("telescope")
      local themes = require("telescope.themes")

      telescope.setup({
        pickers = {
          find_files = themes.get_ivy({
          })
        },
        extensions = {
          ["ui-select"] = themes.get_dropdown({}),
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
