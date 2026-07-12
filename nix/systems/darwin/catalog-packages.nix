{
  pkgs,
  lib,
  os,
  isDev,
  isGUI,
  ...
}:
let
  catalog = import ../../package-catalog.nix {
    inherit
      os
      isDev
      isGUI
      ;
    method = "nix";
    catalogFile = ../../packages.toml;
    programsDir = ./programs;
  };
  resolvePackage =
    name:
    lib.attrByPath (lib.splitString "." name) (throw "package not found in nixpkgs: ${name}") pkgs;
in
{
  imports = map (name: ./programs + "/${name}") catalog.moduleNames;
  environment.systemPackages = map resolvePackage catalog.packageNames;
}
