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
  moduleEntries = builtins.filter (entry: entry.kind == "module") matchedEntries;
  packageEntries = builtins.filter (entry: entry.kind == "package") matchedEntries;
  moduleName =
    entry:
    if builtins.pathExists (programsDir + "/${entry.name}") then
      entry.name
    else
      throw "module not found for ${method}: ${entry.name}";
  packageName =
    entry:
    if builtins.pathExists (programsDir + "/${entry.name}") then
      throw "package '${entry.name}' for ${method} conflicts with a module of the same name"
    else
      entry.name;
in
{
  entries = matchedEntries;
  inherit names;
  moduleNames = map moduleName moduleEntries;
  packageNames = map packageName packageEntries;
}
