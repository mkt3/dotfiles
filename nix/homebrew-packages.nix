{
  catalogFile ? ../packages.toml,
  isDev ? false,
  isGUI ? false,
}:
let
  load =
    method:
    import ./package-catalog.nix {
      inherit
        catalogFile
        isDev
        isGUI
        method
        ;
      os = "darwin";
      programsDir = ./systems/darwin/programs;
    };
  brewLines = map (name: "brew\t${name}") (load "brew").names;
  caskLines = map (name: "cask\t${name}") (load "cask").names;
  masLines = map (entry: "mas\t${entry.name}\t${toString entry.id}") (load "mas").entries;
in
builtins.concatStringsSep "\n" (brewLines ++ caskLines ++ masLines)
