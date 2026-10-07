{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    (pkgs.azure-cli.withExtensions [
      pkgs.azure-cli-extensions.bastion
    ])];

  programs.zsh.envExtra = lib.mkAfter ''
    # azure cli
    export AZURE_CONFIG_DIR="${config.xdg.dataHome}/azure"
  '';
}
