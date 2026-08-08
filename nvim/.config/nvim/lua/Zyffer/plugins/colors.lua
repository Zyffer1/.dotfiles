return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,

  config = function()
    require("rose-pine").setup({
      variant = "moon",
      styles = {
        transparency = false,
      },
      highlight_groups = {
        Normal = { bg = "#000000" },
        NormalFloat = { bg = "#000000" },
        SignColumn = { bg = "#000000" },
        EndOfBuffer = { bg = "#000000" },

        -- Keep the default statusline and UI on a black background
        StatusLine = { bg = "#000000", fg = "muted" },
        StatusLineNC = { bg = "#000000", fg = "subtle", blend = 100 },
        MsgArea = { bg = "#000000", fg = "muted" },
        MsgSeparator = { bg = "#000000", fg = "subtle" },
        WildMenu = { bg = "#000000", fg = "iris" },
        TabLineFill = { bg = "#000000", fg = "subtle" },
        TabLine = { bg = "#000000", fg = "subtle" },
        TabLineSel = { bg = "#000000", fg = "text" },
        VertSplit = { bg = "#000000", fg = "highlight_med" },
        FloatBorder = { bg = "#000000", fg = "muted" },
        Pmenu = { bg = "#000000", fg = "text" },
        PmenuSel = { bg = "highlight_low", fg = "text" },
        PmenuSbar = { bg = "#000000" },
        PmenuThumb = { bg = "highlight_med" },
        TelescopePrompt = { bg = "#000000", fg = "text" },
        TelescopePromptBorder = { bg = "#000000", fg = "muted" },
        TelescopeResults = { bg = "#000000", fg = "text" },
        TelescopeResultsBorder = { bg = "#000000", fg = "muted" },
        TelescopeSelection = { bg = "highlight_low", fg = "text" },
      },
    })

    vim.cmd("colorscheme rose-pine")
  end,
}
