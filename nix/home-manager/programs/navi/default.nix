{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.navi ];

  xdg.configFile = {
    "navi/config.yaml".source = ./config.yaml;
    "navi/cheats".source = ./cheats;
  };

  programs.zsh.envExtra = lib.mkAfter ''
    # navi
    export NAVI_CONFIG="${config.xdg.configHome}/navi/config.yaml"
  '';

  # programs.navi = {
  #   enable = true;
  #   enableZshIntegration = true;

  #   settings = {
  #     cheats = {
  #       paths = [
  #         "${config.xdg.configHome}/navi/cheats"
  #       ];
  #     };
  #     shell = {
  #       command = "zsh";
  #     };
  #     finder = {
  #       command = "fzf";
  #     };
  #     style = {
  #       tag = {
  #         color = "cyan";
  #         width_percentage = 26;
  #         min_width = 20;
  #       };
  #       comment = {
  #         color = "blue";
  #         width_percentage = 42;
  #         min_width = 45;
  #       };
  #       snippet = {
  #         color = "white";
  #       };
  #     };
  #   };
  # };
}
