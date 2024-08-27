{ pkgs, ... }:
{
  home.packages = [ pkgs.navi ];

  xdg.configFile = {
    "navi/config.yaml".source = ./config.yaml;
    "navi/cheats".source = ./cheats;
  };

  home.file.".zshenv".text = ''
    # navi
    export NAVI_CONFIG="''${HOME}/.config/navi/config.yaml"
  '';
}
