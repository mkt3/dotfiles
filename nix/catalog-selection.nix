{
  pkgs,
  lib,
  catalogFile,
  programsDir,
  os,
  isDev,
  isGUI,
  methods,
}:
let
  loadCatalog =
    method:
    import ./package-catalog.nix {
      inherit
        catalogFile
        programsDir
        os
        isDev
        isGUI
        method
        ;
    };
  catalogs = map loadCatalog methods;
  moduleNames = lib.concatMap (catalog: catalog.moduleNames) catalogs;
  packageNames = lib.concatMap (catalog: catalog.packageNames) catalogs;
  resolvePackage =
    name:
    lib.attrByPath (lib.splitString "." name) (throw "package not found in nixpkgs: ${name}") pkgs;
in
{
  modules = map (name: programsDir + "/${name}") moduleNames;
  packages = map resolvePackage packageNames;
}
