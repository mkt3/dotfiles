local wezterm = require 'wezterm';

return {
  font = wezterm.font("Cica"),
  use_ime = true,
  font_size = 16.0,
  color_scheme = "nord",
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  keys = {
     {key="x",mods="SUPER",action=wezterm.action.SendKey { key="x", mods="ALT"}},
     {key="c",mods="SUPER",action=wezterm.action.SendKey { key="c", mods="ALT"}},
     {key="w",mods="SUPER",action=wezterm.action.SendKey { key="w", mods="ALT"}},
     {key=",",mods="SUPER",action=wezterm.action.SendKey { key=",", mods="ALT"}},
     {key=".",mods="SUPER",action=wezterm.action.SendKey { key=".", mods="ALT"}},
     {key=";",mods="SUPER",action=wezterm.action.SendKey { key=";", mods="ALT"}},
     {key="/",mods="SUPER",action=wezterm.action.SendKey { key="/", mods="ALT"}},
     {key="?",mods="SUPER|SHIFT",action=wezterm.action.SendKey { key="?", mods="ALT"}},
  },
}
