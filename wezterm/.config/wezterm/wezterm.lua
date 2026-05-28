local wezterm = require "wezterm"
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

config.keys = {
  {
    key = "R",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ResetFontSize,
  },
}

config.enable_wayland = false
config.max_fps = 165
config.window_background_opacity = 0.0
config.color_scheme = "Rosé-Pine-Moon"
config.automatically_reload_config = true
font = wezterm.font 'jetbrains mono'

return config
