{
  pkgs,
  lib,
  os,
  isDev,
  isGUI,
  ...
}:
let
  selection = import ../catalog-selection.nix {
    inherit
      pkgs
      lib
      os
      isDev
      isGUI
      ;
    catalogFile = ../packages.toml;
    programsDir = ./programs;
    methods = lib.optional (os == "ubuntu") "nix" ++ [ "nix-hm" ];
  };
in
{
  imports = selection.modules;
  home.packages = selection.packages;
}
