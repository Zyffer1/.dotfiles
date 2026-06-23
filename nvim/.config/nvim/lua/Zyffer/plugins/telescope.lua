return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },

    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Grep" },
      { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Grep word" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help" },
      { "<leader>fq", function() require("telescope.builtin").quickfix() end,   desc = "Quickfix" },
      { "<leader>fr", function() require("telescope.builtin").resume() end,     desc = "Resume last picker" },
      { "<leader>fo", function() require("telescope.builtin").oldfiles() end,   desc = "Recent files" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end, desc = "Git status" },
      { "<leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
    },

    config = function()
      local telescope = require("telescope")
      local themes = require("telescope.themes")

      telescope.setup({
        defaults = themes.get_ivy({}),

        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },

        pickers = {
          find_files = {
            hidden = true,
            find_command = {
              "rg",
              "--files",
              "--hidden",

              "--glob", "!.git/**",
              "--glob", "!node_modules/**",
              "--glob", "!dist/**",
              "--glob", "!build/**",
              "--glob", "!target/**",
            },
          },
          live_grep = {
            additional_args = function()
              return {
                "--hidden",
                "--glob",
                "!.git/*",
              }
            end,
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  },
}
