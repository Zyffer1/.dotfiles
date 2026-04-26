return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
--return {
--  {
--    "Mofiqul/vscode.nvim",
--    lazy = false,
--    priority = 1000,
--    config = function()
--      vim.opt.termguicolors = true
--
--      require("vscode").setup({
--        transparent = true,
--        italic_comments = true,
--      })
--
--      local set_hl = function()
--        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--
--        vim.api.nvim_set_hl(0, "@variable", { fg = "#9CDCFE" })
--        vim.api.nvim_set_hl(0, "@string", { fg = "#CE9178" })
--        vim.api.nvim_set_hl(0, "@keyword", { fg = "#569CD6" })
--        vim.api.nvim_set_hl(0, "@function", { fg = "#DCDCAA" })
--        vim.api.nvim_set_hl(0, "@comment", { fg = "#6A9955", italic = true })
--      end
--
--      vim.cmd.colorscheme("vscode")
--      set_hl()
--
--      vim.api.nvim_create_autocmd("ColorScheme", {
--        callback = function()
--          set_hl()
--        end,
--      })
--
--      vim.diagnostic.config({
--        virtual_text = true,
--        signs = true,
--        underline = true,
--        update_in_insert = true,
--        severity_sort = true,
--      })
--    end,
--  },
--}
