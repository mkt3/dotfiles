local wezterm = require 'wezterm';

return {
  font = wezterm.font("Cica"),
  use_ime = true,
  font_size = 16.0,
  color_scheme = "nord",
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  window_background_opacity = 0.95,
}
