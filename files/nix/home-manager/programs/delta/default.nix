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

  xdg.configFile."zsh/defer.zsh" = {
    text = ''
      # for delta bat completion
      compdef _gnu_generic bat delta
    '';
  };

}
