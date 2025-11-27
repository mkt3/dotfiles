{ config, pkgs, ... }:
{
  home.packages =
    if pkgs.stdenv.hostPlatform.isDarwin then
      [ pkgs.brewCasks.slack ]
    else
      [ pkgs.slack ];
}
