return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    branch = "master",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "vimdoc",
          "cpp",
          "c",
          "lua",
          "bash",
          "rust",
          "go",
        },
        highlight = {
          enable = true,
        },
      })
    end,
  },
}
