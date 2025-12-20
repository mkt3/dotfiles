{ pkgs, ... }:
{
  home.packages = [ pkgs.cmigemo ];

  home.file.".zshenv".text = ''
    # migemo
    export CMIGEMO_DICT="${pkgs.cmigemo}/share/migemo/utf-8/migemo-dict"
  '';
}
