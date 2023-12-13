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
  {key="<",mods="CMD|SHIFT",action=wezterm.action.SendKey{key="<", mods="OPT"}}, -- for emacs
  {key=">",mods="CMD|SHIFT",action=wezterm.action.SendKey{key=">", mods="OPT"}}, -- for emacs
  {key="?",mods="CMD|SHIFT",action=wezterm.action.SendKey{key="?", mods="OPT"}}, -- for emacs
  {key=";",mods="CTRL",action=wezterm.action.SendString "\x18@;"}, -- for emacs in terminal
  {key="j",mods="CTRL",action=wezterm.action.SendString "\x18@j"}, -- for emacs ddskk interminal
  {key="v",mods="OPT",action=wezterm.action.PasteFrom 'Clipboard'},
  {key="w",mods="OPT",action=wezterm.action.CloseCurrentTab{confirm=false}},
  {key="o",mods="CMD",action=wezterm.action.SpawnCommandInNewTab{args={".config/wezterm/ssh.sh"},cwd = '~'}},
}

font_size = 18.0
if wezterm.target_triple == 'x86_64-apple-darwin' then
  table.insert(keys, {key="q",mods="CTRL",action=wezterm.action{SendString="\x11"}})
  font_size = 16.0
end


return {
  font = wezterm.font_with_fallback {
    { family = 'PlemolJP Console NF', assume_emoji_presentation = false},
    { family = 'Symbols Nerd Font Mono', assume_emoji_presentation = false},
    { family = 'Cica', assume_emoji_presentation = true},
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
