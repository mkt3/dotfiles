{
  pkgs,
  lib,
  os,
  isDev,
  isGUI,
  ...
}:
let
  selection = import ../../catalog-selection.nix {
    inherit
      pkgs
      lib
      os
      isDev
      isGUI
      ;
    catalogFile = ../../packages.toml;
    programsDir = ./programs;
    methods = [ "nix" ];
  };
in
{
  imports = selection.modules;
  environment.systemPackages = selection.packages;
}
