{ pkgs, ... }:
{
  home.packages = [ pkgs.trash-cli ];

  programs.zsh.shellAliases = {
    rm = "echo \"This is not the command you are looking for.\"; false";
  };

  xdg.configFile."zsh/defer.zsh" = {
    text = ''
      # Remove only the files that have been deleted more than 7 days ago:
      yes y | trash-empty 7
    '';
  };
}
