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
  -- color_scheme = 'nordfox',
  -- color_scheme = 'Tinacious Design (Dark)',
  -- color_scheme = 'Tomorrow Night',
  -- color_scheme = 'Neon (terminal.sexy)',
  -- color_scheme = 'Neon Night (Gogh)',
  -- color_scheme = 'nightfox',
  -- color_scheme = 'Nucolors (terminal.sexy)',
  -- color_scheme = 'zenbones_dark',
  -- color_scheme = 'Dracula',
  -- color_scheme = 'duskfox',
  -- color_scheme = 'Snazzy',
  -- color_scheme = 'Sonokai (Gogh)',
  -- color_scheme = 'SpaceGray',
  -- color_scheme = 'Vag (Gogh)',
  -- color_scheme = 'Violet Dark',
  color_scheme = 'tokyonight_night',

  -- Tab bar
  use_fancy_tab_bar = false,
  window_frame = {
    font = font,
    font_size = font_size,
  },

  hide_tab_bar_if_only_one_tab = true,
}
