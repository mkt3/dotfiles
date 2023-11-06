local wezterm = require 'wezterm';

local keys = {
  {key="s",mods="SUPER",action=wezterm.action.SendKey{key="s", mods="ALT"}}, -- for emacs
  {key="x",mods="SUPER",action=wezterm.action.SendKey{key="x", mods="ALT"}}, -- for emacs
  {key="c",mods="SUPER",action=wezterm.action.SendKey{key="c", mods="ALT"}}, -- for emacs
  {key="w",mods="SUPER",action=wezterm.action.SendKey{key="w", mods="ALT"}}, -- for emacs
  {key="y",mods="SUPER",action=wezterm.action.SendKey{key="y", mods="ALT"}}, -- for emacs
  {key="i",mods="SUPER",action=wezterm.action.SendKey{key="i", mods="ALT"}}, -- for emacs
  {key=",",mods="SUPER",action=wezterm.action.SendKey{key=",", mods="ALT"}}, -- for emacs
  {key=".",mods="SUPER",action=wezterm.action.SendKey{key=".", mods="ALT"}}, -- for emacs
  {key=";",mods="SUPER",action=wezterm.action.SendKey{key=";", mods="ALT"}}, -- for emacs
  {key="/",mods="SUPER",action=wezterm.action.SendKey{key="/", mods="ALT"}}, -- for emacs
  {key="<",mods="SUPER|SHIFT",action=wezterm.action.SendKey{key="<", mods="ALT"}}, -- for emacs
  {key=">",mods="SUPER|SHIFT",action=wezterm.action.SendKey{key=">", mods="ALT"}}, -- for emacs
  {key="?",mods="SUPER|SHIFT",action=wezterm.action.SendKey{key="?", mods="ALT"}}, -- for emacs
  {key="v",mods="SUPER",action=wezterm.action.PasteFrom 'Clipboard'},
  {key="w",mods="ALT",action=wezterm.action.CloseCurrentTab{confirm=false}},
  {key="o",mods="CMD",action=wezterm.action.SpawnCommandInNewTab{args={".config/wezterm/ssh.sh"},cwd = '~'}},
}

font_size = 18.0
if wezterm.target_triple == 'x86_64-apple-darwin' then
  table.insert(keys, {key="q",mods="CTRL",action=wezterm.action{SendString="\x11"}})
  table.insert(keys, {key="j",mods="CTRL",action=wezterm.action.SendKey{key="\\", mods="CTRL"}}) -- for emacs ddskk
  font_size = 16.0
end


return {
  font = wezterm.font_with_fallback {
    { family = 'PlemolJP', assume_emoji_presentation = false},
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
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  keys=keys,
  window_close_confirmation = 'NeverPrompt',
}
