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
    "kind"
    "id"
  ];
  allowedKinds = [
    "package"
    "module"
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
        (ensure (
          entry ? kind && builtins.isString entry.kind && contains entry.kind allowedKinds
        ) "${label} entry '${name}' must have kind 'package' or 'module'")
        (ensure (
          (entry.kind or null) != "module"
          || contains method [
            "nix"
            "nix-hm"
          ]
        ) "${label} entry '${name}' uses kind 'module' with unsupported method ${methodName}")
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
          method != "mas" || (entry ? id && builtins.isInt entry.id && entry.id > 0)
        ) "${label} mas entry '${name}' must have a positive integer id")
        (ensure (method == "mas" || !(entry ? id)) "${label} non-mas entry '${name}' must not have an id")
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

  programsDirFor =
    os: method:
    if method == "nix-hm" || os == "ubuntu" then
      ./home-manager/programs
    else if os == "nixos" then
      ./systems/nixos/programs
    else
      ./systems/darwin/programs;

  selectedCatalog =
    os: method:
    import ./package-catalog.nix {
      inherit catalogFile os method;
      isDev = true;
      isGUI = true;
      programsDir = programsDirFor os method;
    };

  selectionChecks =
    builtins.concatMap
      (
        os:
        map (
          method:
          let
            selected = selectedCatalog os method;
            duplicates = duplicateNames selected.names;
            classificationCheck =
              if
                contains method [
                  "nix"
                  "nix-hm"
                ]
              then
                builtins.deepSeq selected.moduleNames (builtins.deepSeq selected.packageNames true)
              else
                true;
          in
          builtins.deepSeq classificationCheck (
            ensure (
              duplicates == [ ]
            ) "${os}/${method} contains duplicate packages: ${builtins.concatStringsSep ", " duplicates}"
          )
        ) allowedMethods
      )
      [
        "ubuntu"
        "nixos"
        "darwin"
      ];
in
builtins.deepSeq groupChecks (builtins.deepSeq selectionChecks "package catalog is valid\n")
