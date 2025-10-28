local wezterm = require('wezterm')

local search_mode_keys = wezterm.gui.default_key_tables().search_mode
local act = wezterm.action

local font_default = 'Google Sans Code'
local font_jp = 'IBM Plex Sans JP'
local weight_normal = 'Light'
local weight_bold = 'Medium'
local font = wezterm.font_with_fallback({
  {
    family =  font_default,
    weight = weight_normal,
  },
  font_jp,
})
local font_rules = {
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font_with_fallback({
      {
        family = font_default,
        weight = weight_normal,
        style = 'Italic',
      },
      font_jp,
    })
  },
  {
    intensity = 'Bold',
    italic = false,
    font = wezterm.font_with_fallback({
      {
        family = font_default,
        weight = weight_bold,
      },
      font_jp,
    })
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font_with_fallback({
      {
        family = font_default,
        weight = weight_bold,
        style = 'Italic',
      },
      font_jp,
    })
  },
}
local font_size = 15

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
  font_rules = font_rules,
  font_size = font_size,

  default_cursor_style = 'SteadyBar',
  -- default_cursor_style = 'BlinkingBar',
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  cursor_blink_rate = 500,
  cursor_thickness = 1,

  bold_brightens_ansi_colors = 'No',

  scrollback_lines = 10000,

  detect_password_input = true,  -- show password icon

  window_background_opacity = 0.92,

  -- Tab bar
  use_fancy_tab_bar = false,
  color_scheme = 'Kanagawa Dragon (Gogh)',

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
