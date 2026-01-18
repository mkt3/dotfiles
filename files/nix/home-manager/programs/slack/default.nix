{
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  home.packages =
    lib.optionals isDarwin [ pkgs.brewCasks.slack ] ++ lib.optionals (!isDarwin) [ pkgs.slack ];
}
