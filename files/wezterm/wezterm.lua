local wezterm = require 'wezterm';

return {
  font = wezterm.font("Cica"),
  use_ime = true,
  font_size = 16.0,
  color_scheme = "nord",
  adjust_window_size_when_changing_font_size = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  keys = {
     {key="x",mods="SUPER",action=wezterm.action.SendKey { key="x", mods="ALT"}},
     {key="c",mods="SUPER",action=wezterm.action.SendKey { key="c", mods="ALT"}},
     {key="w",mods="SUPER",action=wezterm.action.SendKey { key="w", mods="ALT"}},
     {key=",",mods="SUPER",action=wezterm.action.SendKey { key=",", mods="ALT"}},
     {key=".",mods="SUPER",action=wezterm.action.SendKey { key=".", mods="ALT"}},
     {key=";",mods="SUPER",action=wezterm.action.SendKey { key=";", mods="ALT"}},
     {key="/",mods="SUPER",action=wezterm.action.SendKey { key="/", mods="ALT"}},
     {key="?",mods="SUPER|SHIFT",action=wezterm.action.SendKey { key="?", mods="ALT"}},
     {
      key = 'o',
      mods = 'CMD',
      action = wezterm.action.SpawnCommandInNewTab {
        args = {'.config/wezterm/ssh.sh' },
        cwd = '~'
      },
     },
  },
}
