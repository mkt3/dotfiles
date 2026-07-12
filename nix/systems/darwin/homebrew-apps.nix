{
  os,
  isDev,
  isGUI,
  ...
}:
let
  load =
    method:
    import ../../package-catalog.nix {
      inherit
        os
        isDev
        isGUI
        method
        ;
      catalogFile = ../../packages.toml;
      programsDir = ./programs;
    };
  masApps = builtins.listToAttrs (
    map (entry: {
      inherit (entry) name;
      value = entry.id or throw "mas entry '${entry.name}' must define an id";
    }) (load "mas").entries
  );
in
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
    greedyCasks = true;

    taps = [ ];
    brews = (load "brew").names;
    casks = (load "cask").names;
    inherit masApps;
  };
}
