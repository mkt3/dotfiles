{  config, pkgs, ... }:
{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
  ];

  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
