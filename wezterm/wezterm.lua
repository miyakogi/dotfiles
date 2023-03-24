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
  color_scheme = 'nordfox',

  -- Tab bar
  use_fancy_tab_bar = false,
  window_frame = {
    font = font,
    font_size = font_size,

    inactive_titlebar_bg = '#232831',
    active_titlebar_bg = '#232831',
  },

  colors = {
    cursor_fg = '#2e3440',
    cursor_bg = '#bbc3d4',
    selection_fg = '#2e3440',
    selection_bg = '#bbc3d4',

    tab_bar = {
      background = '#232831',
      active_tab = {
        bg_color = '#39404f',
        fg_color = '#c7cdd9',
      },
      inactive_tab = {
        bg_color = '#2e3440',
        fg_color = '#abb1bb',
      },
      inactive_tab_hover = {
        bg_color = '#444c5e',
        fg_color = '#cdcecf',
        italic = false,
      },
      new_tab = {
        bg_color = '#2e3440',
        fg_color = '#7e8188',
      },
      new_tab_hover = {
        bg_color = '#444c5e',
        fg_color = '#cdcecf',
        italic = false,
      },
    },
  },

  hide_tab_bar_if_only_one_tab = true,
}
