{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Fabric does not support Invoke 3 yet: https://github.com/fabric/fabric/issues/2376
  # Keep this pin local to Azure CLI until nixpkgs provides a compatible Fabric.
  # Remove after the fix for https://github.com/NixOS/nixpkgs/issues/575989 lands.
  azurePkgs = pkgs.extend (
    _: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (_: pythonPrev: {
          invoke = pythonPrev.invoke.overridePythonAttrs (old: rec {
            version = "2.2.1";
            src = pkgs.fetchPypi {
              inherit (old) pname;
              inherit version;
              hash = "sha256-UVv0m0pIkyt5sCRZA0jaIvOcSULf+ZGtH7i4uuob5wc=";
            };
          });
        })
      ];
    }
  );
in
{
  home.packages = [
    (azurePkgs.azure-cli.withExtensions [ azurePkgs.azure-cli-extensions.bastion ])
  ];

  programs.zsh.envExtra = lib.mkAfter ''
    # azure cli
    export AZURE_CONFIG_DIR="${config.xdg.dataHome}/azure"
  '';
}
