local wezterm = require 'wezterm';

local keys = {
  {key="s",mods="CMD",action=wezterm.action.SendKey{key="s", mods="OPT"}}, -- for emacs
  {key="x",mods="CMD",action=wezterm.action.SendKey{key="x", mods="OPT"}}, -- for emacs
  {key="c",mods="CMD",action=wezterm.action.SendKey{key="c", mods="OPT"}}, -- for emacs
  {key="w",mods="CMD",action=wezterm.action.SendKey{key="w", mods="OPT"}}, -- for emacs
  {key="y",mods="CMD",action=wezterm.action.SendKey{key="y", mods="OPT"}}, -- for emacs
  {key="v",mods="CMD",action=wezterm.action.SendKey{key="v", mods="OPT"}}, -- for emacs
  {key="i",mods="CMD",action=wezterm.action.SendKey{key="i", mods="OPT"}}, -- for emacs
  {key=",",mods="CMD",action=wezterm.action.SendKey{key=",", mods="OPT"}}, -- for emacs
  {key=".",mods="CMD",action=wezterm.action.SendKey{key=".", mods="OPT"}}, -- for emacs
  {key=";",mods="CMD",action=wezterm.action.SendKey{key=";", mods="OPT"}}, -- for emacs
  {key="/",mods="CMD",action=wezterm.action.SendKey{key="/", mods="OPT"}}, -- for emacs
  {key="h",mods="CMD|CTRL",action=wezterm.action.SendKey{key="h", mods="OPT|CTRL"}}, -- for emacs
  {key="j",mods="CMD|CTRL",action=wezterm.action.SendKey{key="j", mods="OPT|CTRL"}}, -- for emacs
  {key="k",mods="CMD|CTRL",action=wezterm.action.SendKey{key="k", mods="OPT|CTRL"}}, -- for emacs
  {key="l",mods="CMD|CTRL",action=wezterm.action.SendKey{key="l", mods="OPT|CTRL"}}, -- for emacs
  {key="<",mods="CMD|SHIFT",action=wezterm.action.SendKey{key="<", mods="OPT"}}, -- for emacs
  {key=">",mods="CMD|SHIFT",action=wezterm.action.SendKey{key=">", mods="OPT"}}, -- for emacs
  {key="?",mods="CMD|SHIFT",action=wezterm.action.SendKey{key="?", mods="OPT"}}, -- for emacs
  {key="\\",mods="CMD|CTRL",action=wezterm.action.SendKey{key="\\", mods="OPT|CTRL"}}, -- for emacs
  {key=";",mods="CTRL",action=wezterm.action.SendString "\x18@;"}, -- for emacs in terminal
  {key="j",mods="CTRL",action=wezterm.action.SendString "\x18@j"}, -- for emacs ddskk in terminal
  {key = "Delete",mods = "",action = wezterm.action.SendKey { key = "d", mods = "CTRL" } }, -- for keyball
  {key = "RightArrow",mods = "",action = wezterm.action.SendKey { key = "f", mods = "CTRL" }}, -- for keyball
  {key = "LeftArrow",mods = "",action = wezterm.action.SendKey { key = "b", mods = "CTRL" }}, -- for keyball
  {key = "UpArrow",mods = "",action = wezterm.action.SendKey { key = "p", mods = "CTRL" }}, -- for keyball
  {key = "DownArrow",mods = "",action = wezterm.action.SendKey { key = "n", mods = "CTRL" }}, -- for keyball
  {key="v",mods="OPT",action=wezterm.action.PasteFrom 'Clipboard'},
  {key="t",mods="OPT",action=wezterm.action.SpawnTab 'CurrentPaneDomain'},
  {key="w",mods="OPT",action=wezterm.action.CloseCurrentTab{confirm=false}},
  {key="o",mods="CMD",action=wezterm.action.SpawnCommandInNewTab{args={"./.config/wezterm/ssh.sh"},cwd = '~'}},
}

font_size = 20.0
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
  enable_wayland = false,
  window_close_confirmation = 'NeverPrompt',
  check_for_updates = false,
}
