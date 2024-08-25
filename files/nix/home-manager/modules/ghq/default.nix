{ pkgs, homeDirectory, ... }:
{
  home.packages = [ pkgs.ghq ];

  programs.git = {
    extraConfig = {
      ghq = {
        root = "${homeDirectory}/workspace/ghq";
      };
    };
  };
}
