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

config.window_background_opacity = 0.7

config.keys = {
  {
    key = "O",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window, _)
      local overrides = window:get_config_overrides() or {}

      if overrides.window_background_opacity == 1.0 then
        overrides.window_background_opacity = 0.7
      else
        overrides.window_background_opacity = 1.0
      end

      window:set_config_overrides(overrides)
    end),
  },
}

return config
