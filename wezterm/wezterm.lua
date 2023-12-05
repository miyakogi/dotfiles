local wezterm = require('wezterm')

local search_mode_keys = wezterm.gui.default_key_tables().search_mode
local act = wezterm.action

local font = wezterm.font_with_fallback({
  {
    family = 'MonaspiceNe NF',
    weight = 400,
    harfbuzz_features = { 'ss01=1', 'ss02=1', 'ss03=1', 'ss04=1', 'ss05=1', 'ss06=1', 'ss07=1', 'ss08=1', 'calt=1' },
  },
  'Gen Jyuu Gothic L Monospace',
  'Unifont',
})
local font_rules = {
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font({
      family = 'MonaspiceRn NF',
      style = 'Normal',
      harfbuzz_features = { 'ss01=1', 'ss02=1', 'ss03=1', 'ss04=1', 'ss05=1', 'ss06=1', 'ss07=1', 'ss08=1', 'calt=1' },
    })
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font({
      family = 'MonaspiceRn NF',
      weight = 'Bold',
      style = 'Normal',
      harfbuzz_features = { 'ss01=1', 'ss02=1', 'ss03=1', 'ss04=1', 'ss05=1', 'ss06=1', 'ss07=1', 'ss08=1', 'calt=1' },
    })
  },
}
local font_size = 12.0

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

  font = font,
  font_rules = font_rules,
  font_size = font_size,

  bold_brightens_ansi_colors = 'No',

  detect_password_input = false,  -- disable password icon

  window_background_opacity = 0.9,

  -- Tab bar
  use_fancy_tab_bar = true,
  window_frame = {
    font = font,
    font_size = 18.0,

    -- Tab colors
    active_titlebar_bg = '#1e2132',  -- black (normal)
    inactive_titlebar_bg = '#1e2132',  -- black (normal)
  },
  color_scheme = 'Catppuccin Mocha',

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
  },

  key_tables = {
    search_mode = search_mode_keys,
  },
}
