local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28
config.font_size = 22

config.enable_tab_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}


local desktop = os.getenv("XDG_CURRENT_DESKTOP") or ""

if desktop:lower():find("gnome") then
  config.color_scheme = "Catppuccin Mocha"
  config.window_background_opacity = 1.0
else
  config.window_background_opacity = 0.0
  config.keys = {
    {
      key = "O",
      mods = "CTRL|SHIFT",
      action = wezterm.action_callback(function(window, _)
        local overrides = window:get_config_overrides() or {}

        if overrides.window_background_opacity == 1.0 then
          overrides.window_background_opacity = 0.0
        else
          overrides.window_background_opacity = 1.0
        end

        window:set_config_overrides(overrides)
      end),
    },
  }
end

return config
