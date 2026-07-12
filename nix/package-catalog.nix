{
  lib,
  catalogFile,
  os,
  isDev,
  isGUI,
  method,
  programsDir,
}:
let
  catalog = builtins.fromTOML (builtins.readFile catalogFile);
  isLinux = os == "ubuntu" || os == "nixos";
  enabled =
    group: group.type == "basic" || (isDev && group.type == "dev") || (isGUI && group.type == "gui");
  entriesFor =
    group: (group.common or [ ]) ++ lib.optionals isLinux (group.linux or [ ]) ++ (group.${os} or [ ]);
  entries = lib.concatMap entriesFor (lib.filter enabled (lib.attrValues catalog));
  names = map (entry: entry.name) (lib.filter (entry: entry.method == method) entries);
  isModule = name: builtins.pathExists (programsDir + "/${name}");
in
{
  moduleNames = lib.filter isModule names;
  packageNames = lib.filter (name: !isModule name) names;
}
