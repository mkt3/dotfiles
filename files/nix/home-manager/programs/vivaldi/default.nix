{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.vivaldi;
    commandLineArgs = pkgs.lib.optionals pkgs.stdenv.isLinux [
      "--enable-features=WebUIDarkMode"
      "--force-dark-mode"
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
    ];
  };
}
