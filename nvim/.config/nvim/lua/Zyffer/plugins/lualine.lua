return{
	"nvim-lualine/lualine.nvim",
	event = "ColorScheme",
	config = function()
		require("lualine").setup({
			options = {
        --theme = "catppuccin-nvim",
				--- @usage 'rose-pine' | 'rose-pine-alt'
				theme = "rose-pine"
			}
		})
	end
}
