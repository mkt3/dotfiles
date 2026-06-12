{
  config,
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  home.packages = lib.optionals (!isDarwin) [ pkgs.zoom-us ];

  programs.zsh.envExtra = lib.mkAfter ''
    # zoom
    export SSB_HOME="${config.xdg.dataHome}/zoom"
  '';
}
