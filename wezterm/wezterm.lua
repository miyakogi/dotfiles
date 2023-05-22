local wezterm = require('wezterm')

local font = wezterm.font({
  family = 'JetBrainsMono Nerd Font',
  weight = 'Light',
})
local font_size = 21.0

local gpu = {
  name = 'AMD Radeon RX 6800 XT (RADV NAVI21)',
  backend = 'Vulkan',
  device_type = 'DiscreteGpu',
  device = 29631,
  driver = 'radv',
  vendor = 4098,
}

-- copy hyperlink (url) instead of opening by browser when clicked
wezterm.on('open-uri', function(window, pane, uri)
  window:perform_action(
    wezterm.action.SpawnCommandInNewWindow {
      args = { 'wl-copy', uri },
    },
    pane
  )
  return false
end)

-- Modify color scheme
-- use tokyonight's foreground color for iceberg-dark
local scheme = wezterm.get_builtin_color_schemes()['iceberg-dark']
scheme.foreground = '#a9b1d6'
scheme.cursor_bg = '#a9b1d6'
scheme.selection_bg = '#a9b1d6'
scheme.ansi[8] = '#a9b1d6'
scheme.brights[8] = '#c0caf5'

return {
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
      -- disable closing current tab by Ctrl+Shift+w
      key = 'w',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      -- close current tab by Ctrl+Shift+q
      key = 'q',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    {
      key = 'Backspace',
      mods = 'CTRL',
      action = wezterm.action.SendKey({ key = 'w', mods = 'CTRL' })
    }
  },
}
