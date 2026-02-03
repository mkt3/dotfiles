{
  config,
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  home.packages =
    lib.optionals isDarwin [ pkgs.vlc-bin ] ++ lib.optionals (!isDarwin) [ pkgs.vlc ];
}
