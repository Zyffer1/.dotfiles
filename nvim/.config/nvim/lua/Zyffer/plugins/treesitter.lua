return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install({
        "vimdoc",
        "cpp",
        "c",
        "lua",
        "bash",
        "toml",
        "rust",
        "markdown",
        "markdown_inline",
        "go",
        "typescript",
        "javascript",
        "nix",
      })

      -- Highlighting is built into Neovim 0.12; enable it per filetype.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      for _, obj in ipairs({
        { "af", "@function.outer" },
        { "if", "@function.inner" },
        { "ac", "@class.outer" },
        { "ic", "@class.inner" },
        { "ab", "@block.outer" },
        { "ib", "@block.inner" },
      }) do
        vim.keymap.set({ "x", "o" }, obj[1], function()
          select.select_textobject(obj[2], "textobjects")
        end)
      end

      vim.keymap.set({ "n", "x", "o" }, "]m", function()
        move.goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[m", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end)
    end,
  },
}
