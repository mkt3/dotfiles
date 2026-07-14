{
  pkgs,
  lib,
  isDarwin,
  ...
}:
let
  settings = {
    font = lib.generators.mkLuaInline ''
      wezterm.font_with_fallback {
        { family = 'PlemolJP Console NF', assume_emoji_presentation = false },
        { family = 'Symbols Nerd Font Mono', assume_emoji_presentation = false },
        { family = 'Noto Emoji', assume_emoji_presentation = true },
      }
    '';
    webgpu_power_preference = "HighPerformance";
    use_ime = true;
    macos_forward_to_ime_modifier_mask = "SHIFT|CTRL";
    font_size = if isDarwin then 16.0 else 14.0;
    color_scheme = "nord";
    allow_square_glyphs_to_overflow_width = "Always";
    adjust_window_size_when_changing_font_size = false;
    warn_about_missing_glyphs = true;
    window_padding = {
      left = "0.5cell";
      right = "0.5cell";
      top = 0;
      bottom = 0;
    };
    enable_wayland = true;
    window_close_confirmation = "NeverPrompt";
    check_for_updates = false;
  };
in
{
  home.packages = lib.optionals (!isDarwin) [ pkgs.libnotify ];

  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    inherit settings;
    extraConfig = builtins.readFile ./extra.lua;
  };

  xdg.configFile."wezterm/ssh.sh".source = ./ssh.sh;
}
