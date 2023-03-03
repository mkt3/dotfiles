local wezterm = require 'wezterm';

return {
  font = wezterm.font("Cica"),
  use_ime = true,
  font_size = 20.0,
  color_scheme = "nord",
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  keys = {
     {key="q",mods="CTRL",action=wezterm.action{SendString="\x11"}}, -- for macOS
     {key="x",mods="SUPER",action=wezterm.action.SendKey{key="x", mods="ALT"}},
     {key="c",mods="SUPER",action=wezterm.action.SendKey{key="c", mods="ALT"}},
     {key="v",mods="SUPER",action=wezterm.action.SendKey{key="v", mods="ALT"}},
     {key="w",mods="SUPER",action=wezterm.action.SendKey{key="w", mods="ALT"}},
     {key="y",mods="SUPER",action=wezterm.action.SendKey{key="y", mods="ALT"}},
     {key="i",mods="SUPER",action=wezterm.action.SendKey{key="i", mods="ALT"}},
     {key=",",mods="SUPER",action=wezterm.action.SendKey{key=",", mods="ALT"}},
     {key=".",mods="SUPER",action=wezterm.action.SendKey{key=".", mods="ALT"}},
     {key=";",mods="SUPER",action=wezterm.action.SendKey{key=";", mods="ALT"}},
     {key="/",mods="SUPER",action=wezterm.action.SendKey{key="/", mods="ALT"}},
     {key="<",mods="SUPER|SHIFT",action=wezterm.action.SendKey{key="<", mods="ALT"}},
     {key=">",mods="SUPER|SHIFT",action=wezterm.action.SendKey{key=">", mods="ALT"}},
     {key="?",mods="SUPER|SHIFT",action=wezterm.action.SendKey{key="?", mods="ALT"}},
     {key="w",mods="ALT",action=wezterm.action.CloseCurrentTab{confirm=false}},
     {key="o",mods="CMD",action=wezterm.action.SpawnCommandInNewTab{args={".config/wezterm/ssh.sh"},cwd = '~'}},
  },
}
