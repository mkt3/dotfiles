{
  pkgs,
  lib,
  os,
  isDev,
  isGUI,
  ...
}:
let
  load =
    method:
    import ../package-catalog.nix {
      inherit
        lib
        os
        isDev
        isGUI
        method
        ;
      catalogFile = ../packages.toml;
      programsDir = ./programs;
    };
  catalogs = lib.optional (os == "ubuntu") (load "nix") ++ [ (load "nix-hm") ];
  moduleNames = lib.concatMap (catalog: catalog.moduleNames) catalogs;
  packageNames = lib.concatMap (catalog: catalog.packageNames) catalogs;
  resolvePackage =
    name:
    lib.attrByPath (lib.splitString "." name) (throw "package not found in nixpkgs: ${name}") pkgs;
in
{
  imports = map (name: ./programs + "/${name}") moduleNames;
  home.packages = map resolvePackage packageNames;
}
