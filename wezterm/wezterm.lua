local wezterm = require('wezterm')
local scheme = wezterm.color.get_builtin_schemes()['carbonfox']
scheme.background = 'black'
scheme.cursor_bg = '#fed677'
scheme.ansi = {
  '#282828',  -- black
  '#ee5396',  -- red
  '#08bdba',  -- green
  '#fed576',  -- yellow
  '#78a9ff',  -- blue
  '#be95ff',  -- magenta
  '#33b1ff',  -- cyan
  '#dfdfe0',  -- white
}
scheme.brights = {
  '#484848',  -- black
  '#f16da6',  -- red
  '#2dc7c4',  -- green
  '#ffe787',  -- yellow
  '#6690d9',  -- blue
  '#a27fd9',  -- magenta
  '#2b96d9',  -- cyan
  '#e4e4e5',  -- white
}

local search_mode_keys = wezterm.gui.default_key_tables().search_mode
local act = wezterm.action

local font = wezterm.font_with_fallback({
  'monospace',
  'IBM Plex Sans JP',
})
local font_size = 16.5

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

-- Search mode keybinding
-- delete patterns by <C-w> and <Caps-w>
table.insert(search_mode_keys, {
  key = 'w',
  mods = 'CTRL',
  action = act.CopyMode('ClearPattern'),
})

return {
  webgpu_power_preference = 'HighPerformance',
  webgpu_preferred_adapter = gpu,
  front_end = 'WebGpu',

  term = 'wezterm',

  font = font,
  font_size = font_size,

  default_cursor_style = 'SteadyBar',

  bold_brightens_ansi_colors = 'No',

  scrollback_lines = 10000,

  detect_password_input = true,  -- show password icon

  window_background_opacity = 0.80,

  -- Tab bar
  use_fancy_tab_bar = false,
  color_schemes = {
    ['carbonfox-oled'] = scheme,
  },
  color_scheme = 'carbonfox-oled',

  hide_tab_bar_if_only_one_tab = true,

  -- Key binding
  keys = {
    {
      -- disable closing current tab by Ctrl+Shift+w
      key = 'w',
      mods = 'CTRL|SHIFT',
      action = act.DisableDefaultAssignment,
    },
    {
      -- close current tab by Ctrl+Shift+q
      key = 'q',
      mods = 'CTRL|SHIFT',
      action = act.CloseCurrentTab({ confirm = true }),
    },
    {
      -- map Ctrl+Backspace to Ctrl+W
      key = 'Backspace',
      mods = 'CTRL',
      action = act.SendKey({ key = 'w', mods = 'CTRL' }),
    }
  },

  key_tables = {
    search_mode = search_mode_keys,
  },

  -- close confirmation
  skip_close_confirmation_for_processes_named = {
    'bash',
    'sh',
    'zsh',
    'fish',
    'zellij',
  },
}
