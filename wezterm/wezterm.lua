local wezterm = require 'wezterm'
local act = wezterm.action

config = wezterm.config_builder()

-- Appearance
config.color_scheme = 'Oceanic-Next'
config.font = wezterm.font {
    family = 'Iosevka Term', 
    weight = 'Light',
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}
config.font_size = 15.0
config.initial_cols = 130
config.initial_rows = 50
config.window_decorations = "RESIZE"
config.window_frame = {
    font = wezterm.font 'Iosevka Term',
    font_size = 13.0,
}
config.window_padding = {
  left = 2,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Mouse
config.pane_focus_follows_mouse = true
config.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = act.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
}

-- Keys
config.keys = {
  { key = 't', mods = 'CMD', action = act.SpawnCommandInNewTab { domain = 'DefaultDomain', cwd = wezterm.home_dir } },
  { key = 'n', mods = 'CMD', action = act.SpawnCommandInNewWindow { domain = 'DefaultDomain', cwd = wezterm.home_dir } },
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'SHIFT|CMD', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = true } },
  { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
  { key = 'LeftArrow', mods = 'CMD', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD', action = act.ActivateTabRelative(1) },
  { key = 'LeftArrow', mods = 'SHIFT|CMD', action = act.MoveTabRelative(-1) },
  { key = 'RightArrow', mods = 'SHIFT|CMD', action = act.MoveTabRelative(1) },
}

return config