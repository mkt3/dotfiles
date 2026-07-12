let
  catalogFile = ../packages.toml;
  catalog = builtins.fromTOML (builtins.readFile catalogFile);
  allowedGroupKeys = [
    "type"
    "common"
    "linux"
    "ubuntu"
    "nixos"
    "darwin"
  ];
  sources = [
    "common"
    "linux"
    "ubuntu"
    "nixos"
    "darwin"
  ];
  allowedTypes = [
    "basic"
    "dev"
    "gui"
  ];
  allowedMethods = [
    "nix"
    "nix-hm"
    "apt"
    "brew"
    "cask"
    "mas"
  ];
  allowedEntryKeys = [
    "name"
    "method"
    "id"
  ];

  contains = value: values: builtins.elem value values;
  ensure = condition: message: if condition then true else throw "packages.toml: ${message}";
  unknownKeys =
    allowed: value: builtins.filter (key: !contains key allowed) (builtins.attrNames value);

  checkEntry =
    groupName: source: entry:
    if !builtins.isAttrs entry then
      throw "packages.toml: ${groupName}.${source} entries must be attribute sets"
    else
      let
        label = "${groupName}.${source}";
        method = entry.method or null;
        name = if entry ? name && builtins.isString entry.name then entry.name else "<unknown>";
        methodName = if builtins.isString method then method else "<invalid>";
        extraKeys = unknownKeys allowedEntryKeys entry;
      in
      builtins.deepSeq [
        (ensure (
          extraKeys == [ ]
        ) "${label} contains unknown entry keys: ${builtins.concatStringsSep ", " extraKeys}")
        (ensure (
          entry ? name && builtins.isString entry.name && entry.name != ""
        ) "${label} entry must have a non-empty string name")
        (ensure (
          entry ? method && builtins.isString method && contains method allowedMethods
        ) "${label} entry '${name}' has an unsupported method")
        (ensure (method != "apt" || source == "ubuntu") "${label} entry '${name}' uses apt outside ubuntu")
        (ensure (
          !(contains method [
            "brew"
            "cask"
            "mas"
          ])
          || source == "darwin"
        ) "${label} entry '${name}' uses ${methodName} outside darwin")
        (ensure (
          method != "mas" || (entry ? id && builtins.isInt entry.id)
        ) "${label} mas entry '${name}' must have an integer id")
      ] true;

  checkGroup =
    groupName: group:
    let
      extraKeys = unknownKeys allowedGroupKeys group;
      entries = builtins.concatMap (
        source:
        let
          sourceEntries = group.${source} or [ ];
        in
        [ (ensure (builtins.isList sourceEntries) "${groupName}.${source} must be a list") ]
        ++ (
          if builtins.isList sourceEntries then
            map (entry: checkEntry groupName source entry) sourceEntries
          else
            [ ]
        )
      ) sources;
    in
    builtins.deepSeq (
      [
        (ensure (
          extraKeys == [ ]
        ) "group '${groupName}' contains unknown keys: ${builtins.concatStringsSep ", " extraKeys}")
        (ensure (
          group ? type && contains group.type allowedTypes
        ) "group '${groupName}' has an unsupported or missing type")
      ]
      ++ entries
    ) true;

  groupChecks = builtins.map (name: checkGroup name catalog.${name}) (builtins.attrNames catalog);

  duplicateNames =
    names:
    builtins.filter (name: builtins.length (builtins.filter (candidate: candidate == name) names) > 1) (
      builtins.attrNames (
        builtins.listToAttrs (
          map (name: {
            inherit name;
            value = true;
          }) names
        )
      )
    );

  selectedNames =
    os: method:
    (import ./package-catalog.nix {
      inherit catalogFile os method;
      isDev = true;
      isGUI = true;
      programsDir = ./.;
    }).names;

  selectionChecks =
    builtins.concatMap
      (
        os:
        map (
          method:
          let
            duplicates = duplicateNames (selectedNames os method);
          in
          ensure (
            duplicates == [ ]
          ) "${os}/${method} contains duplicate packages: ${builtins.concatStringsSep ", " duplicates}"
        ) allowedMethods
      )
      [
        "ubuntu"
        "nixos"
        "darwin"
      ];
in
builtins.deepSeq groupChecks (builtins.deepSeq selectionChecks "package catalog is valid\n")
