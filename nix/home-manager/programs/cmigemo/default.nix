{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.cmigemo ];

  programs.zsh.envExtra = lib.mkAfter ''
    # migemo
    export CMIGEMO_DICT="${pkgs.cmigemo}/share/migemo/utf-8/migemo-dict"
  '';
}
