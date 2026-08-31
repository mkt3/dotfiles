{ pkgs, lib, ... }:
let
  cmigemo = pkgs.callPackage ../../packages/cmigemo { };
in
{
  home.packages = [ cmigemo ];

  programs.zsh.envExtra = lib.mkAfter ''
    # migemo
    export CMIGEMO_DICT="${cmigemo}/share/cmigemo/utf-8/migemo-dict"
  '';
}
