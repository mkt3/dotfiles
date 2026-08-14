{ ... }:
{
  programs.delta = {
    enable = true;
    options = {
      dark = true;
      navigate = true;
      line-numbers = true;
      syntax-theme = "Nord";
    };
  };

  xdg.configFile."zsh/defer.zsh" = {
    text = ''
      # for delta bat completion
      compdef _gnu_generic bat delta
    '';
  };

}
