{
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
    group:
    (group.common or [ ]) ++ (if isLinux then group.linux or [ ] else [ ]) ++ (group.${os} or [ ]);
  entries = builtins.concatMap entriesFor (builtins.filter enabled (builtins.attrValues catalog));
  matchedEntries = builtins.filter (entry: entry.method == method) entries;
  names = map (entry: entry.name) matchedEntries;
  isModule = name: builtins.pathExists (programsDir + "/${name}");
in
{
  entries = matchedEntries;
  inherit names;
  moduleNames = builtins.filter isModule names;
  packageNames = builtins.filter (name: !isModule name) names;
}
