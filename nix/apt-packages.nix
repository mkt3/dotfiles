{
  catalogFile ? ../packages.toml,
  isDev ? false,
  isGUI ? false,
}:
let
  catalog = import ./package-catalog.nix {
    inherit catalogFile isDev isGUI;
    os = "ubuntu";
    method = "apt";
    programsDir = ./home-manager/programs;
  };
in
builtins.concatStringsSep "\n" catalog.names
