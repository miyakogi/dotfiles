local wezterm = require('wezterm')

local font = wezterm.font({
  family = 'JetBrainsMono Nerd Font',
})
local font_size = 12

local gpu = {
  name = 'AMD Radeon RX 6800 XT (RADV NAVI21)',
  backend = 'Vulkan',
  device_type = 'DiscreteGpu',
  device = 29631,
  driver = 'radv',
  vendor = 4098,
}

-- Modify color scheme
-- use tokyonight's foreground color for iceberg-dark
local scheme = wezterm.get_builtin_color_schemes()['iceberg-dark']
scheme.foreground = '#a9b1d6'
scheme.cursor_bg = '#a9b1d6'
scheme.selection_bg = '#a9b1d6'
scheme.ansi[8] = '#a9b1d6'
scheme.brights[8] = '#c0caf5'

return {
  enable_wayland = false,  -- webgpu is broken on wayland, see: https://github.com/wez/wezterm/issues/2770
  max_fps = 120,  -- ignored on wayland, but default is 60fps for X11
  webgpu_power_preference = 'HighPerformance',
  webgpu_preferred_adapter = gpu,
  front_end = 'WebGpu',

  font = font,
  font_size = font_size,

  detect_password_input = false,  -- disable password icon

  window_background_opacity = 0.95,
  color_schemes = {
    ['iceberg-tokyo'] = scheme,
  },
  color_scheme = 'iceberg-tokyo',

  -- Tab bar
  use_fancy_tab_bar = false,
  window_frame = {
    font = font,
    font_size = font_size,
  },

  hide_tab_bar_if_only_one_tab = true,

  -- Key binding
  keys = {
    {
      -- disable window closing by Ctrl+Shift+w
      key = 'w',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.DisableDefaultAssignment,
    },
  },
}
