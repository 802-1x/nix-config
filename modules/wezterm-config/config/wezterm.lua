local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- 1. CROSS-PLATFORM LOGIC
if wezterm.target_triple:find("windows") then
  config.default_prog = { 'wsl.exe', '-d', 'NixOS', '--exec', '/run/current-system/sw/bin/fish', '-l' }
else
  config.default_prog = { 'fish', '-l' }
  config.window_decorations = "TITLE | RESIZE"
end

-- 2. TAB BAR REFINEMENTS (Section 6)
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false -- Disabled so you can see the pretty bar
config.tab_bar_at_bottom = false
config.window_frame = {
  font = wezterm.font { family = 'Noto Sans', weight = 'Bold' },
  active_titlebar_bg = '#1a1b26', -- Matches Tokyo Night background
}

-- Custom Right Status (Clock and Path)
wezterm.on('update-right-status', function(window, pane)
  local date = wezterm.strftime('%Y-%m-%d %H:%M:%S ')
  local cwd = pane:get_current_working_dir()
  local display_path = ""
  if cwd then
    display_path = cwd.file_path .. "  "
  end

  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#7aa2f7' } },
    { Text = display_path },
    { Foreground = { Color = '#bb9af7' } },
    { Text = date },
  }))
end)

-- 3. VISUALS & COLORS
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 14
config.line_height = 1.1
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- 4. GENERAL SETTINGS
config.enable_scroll_bar = true
config.use_dead_keys = false
config.scrollback_lines = 3000
config.adjust_window_size_when_changing_font_size = false
config.enable_wayland = false
config.window_background_opacity = 0.85

-- 5. KEYBINDINGS
config.disable_default_key_bindings = true
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CTRL',
    action = act.IncreaseFontSize,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CTRL',
    action = act.DecreaseFontSize,
  },
}

config.keys = {
  -- Tab/Pane Navigation
  { key = 'l', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'h', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
  { key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection 'Up' },
  
  -- Window Management
  { key = 'f', mods = 'CTRL', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = false } },
  { key = 'x', mods = 'CTRL', action = act.CloseCurrentPane{ confirm = false } },
  { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  { key = 'm', mods = 'CTRL|SHIFT', action = act.Hide },

  -- System
  { key = 'Enter', mods = 'CTRL', action = act.ActivateCopyMode },
  { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },

  -- Font Size
  { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}

return config
