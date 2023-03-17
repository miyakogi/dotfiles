local wezterm = require('wezterm')

local font = 'JetBrainsMono Nerd Font'
local font_size = 12

return {
  font = wezterm.font(font),
  font_size = font_size,

  window_background_opacity = 0.95,
  color_scheme = 'nord',

  -- Tab bar
  use_fancy_tab_bar = false,
  window_frame = {
    font = wezterm.font({ family = font }),
    font_size = font_size,

    inactive_titlebar_bg = '#232831',
    active_titlebar_bg = '#232831',
  },

  colors = {
    cursor_fg = '#2e3440',
    cursor_bg = '#bbc3d4',

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
