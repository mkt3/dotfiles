local wezterm = require 'wezterm';

local keys = {
  {key = "Delete",mods = "",action = wezterm.action.SendKey { key = "d", mods = "CTRL" } }, -- for keyball
  {key = "RightArrow",mods = "",action = wezterm.action.SendKey { key = "f", mods = "CTRL" }}, -- for keyball
  {key = "LeftArrow",mods = "",action = wezterm.action.SendKey { key = "b", mods = "CTRL" }}, -- for keyball
  {key = "UpArrow",mods = "",action = wezterm.action.SendKey { key = "p", mods = "CTRL" }}, -- for keyball
  {key = "DownArrow",mods = "",action = wezterm.action.SendKey { key = "n", mods = "CTRL" }}, -- for keyball
  {key="t",mods="CMD",action=wezterm.action.SpawnTab 'CurrentPaneDomain'},
  {key="w",mods="CMD",action=wezterm.action.CloseCurrentTab{confirm=false}},
  {key="o",mods="CMD",action=wezterm.action.SpawnCommandInNewTab{args={"./.config/wezterm/ssh.sh"},cwd = '~'}},
}

font_size = 14.0
if wezterm.target_triple == 'aarch64-apple-darwin' then
  font_size = 16.0
end


return {
  font = wezterm.font_with_fallback {
    { family = 'PlemolJP Console NF', assume_emoji_presentation = false},
    { family = 'Symbols Nerd Font Mono', assume_emoji_presentation = false},
    { family = 'Noto Emoji', assume_emoji_presentation = true},
  },
  use_ime = true,
  font_size = font_size,
  color_scheme = "nord",
  allow_square_glyphs_to_overflow_width = "Always",
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = true,
  window_padding = {
    left = "0.5cell",
    right = "0.5cell",
    top = 0,
    bottom = 0,
  },
  keys=keys,
  enable_wayland = true,
  window_close_confirmation = 'NeverPrompt',
  check_for_updates = false,
}
