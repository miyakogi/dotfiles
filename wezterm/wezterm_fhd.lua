local wezterm = require('wezterm')

local font = wezterm.font({
  family = 'JetBrainsMono Nerd Font',
  weight = 'Light',
})

local config = require('./wezterm')
config.font = font
config.font_size = 12.0
config.window_frame.font_size = 10.5

return config
