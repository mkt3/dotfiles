{ pkgs, ... }:
{
  home.packages = [ pkgs.gtrash ];

  programs.zsh.shellAliases = {
    rm = "echo -e 'If you want to use rm really, then use \"\\\\rm\" instead.'; false";
  };

  home.file.".zshenv".text = ''
    # navi
    GTRASH_PUT_RM_MODE="true"
  '';

  xdg.configFile."zsh/defer.zsh" = {
    text = ''
      # Remove only the files that have been deleted more than 7 days ago:
      yes y | gtrash prune --day 7
    '';
  };
}
