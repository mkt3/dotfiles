{ pkgs, ... }:
{
  programs.vivaldi = {
    enable = true;
    commandLineArgs = ["--enable-features=WebUIDarkMode" "--force-dark-mode"  "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" "--enable-wayland-ime"];
  };
}
