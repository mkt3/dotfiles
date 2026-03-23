{ pkgs, ... }:
{
  home.packages = [ pkgs.ripgrep ];

  xdg.configFile."ripgrep/ignore" = {
    text = ''
      # global
      .cache/
      .local/
      **/.git/*

      # for mac
      Applications/
      Library/
      NextCloud/
      Movies/
      Music/
      Pictures/
      Public/
      .DS_Store
      .localized
    '';
  };
}
