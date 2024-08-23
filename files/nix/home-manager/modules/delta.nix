{ pkgs, ... }:
{
  home.packages = [ pkgs.delta ];

  programs.git = {
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
      };
    };
  };
}
