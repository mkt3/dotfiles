{ pkgs, lib, isLinux, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.vivaldi;
    commandLineArgs = lib.optionals isLinux [
      "--enable-features=WebUIDarkMode"
      "--force-dark-mode"
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
    ];
  };
}
