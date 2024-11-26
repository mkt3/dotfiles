{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.vivaldi;
    commandLineArgs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      "--enable-features=WebUIDarkMode"
      "--force-dark-mode"
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
    ];
  };
}
