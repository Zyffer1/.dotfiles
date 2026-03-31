return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({})
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "lua_ls"
        },
        automatic_installation = true,
      })
    end,
  },
}
