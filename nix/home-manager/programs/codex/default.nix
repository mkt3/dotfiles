[33mWarning: Bare invocation of nixfmt is deprecated. Use 'nixfmt -' for anonymous stdin.[39m
{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}:
let
  codexDefaultHome = "${config.xdg.configHome}/codex";
  codexNextcloudHome = "${config.home.homeDirectory}/Nextcloud/personal_config/codex";

  codexHome = if builtins.pathExists codexNextcloudHome then codexNextcloudHome else codexDefaultHome;
in
{
  home.packages = [
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
  ];

  home.activation.codexNotifyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH=${
      lib.makeBinPath [
        pkgs.gawk
        pkgs.gnugrep
        pkgs.coreutils
      ]
    }:$PATH ${lib.getExe pkgs.bash} ${config.home.homeDirectory}/.local/bin/setup_codex_notify.sh
  '';

  home.file.".local/bin/setup_codex_notify.sh" = {
    source = ./setup_codex_notify.sh;
    executable = true;
  };

  programs.zsh.envExtra = lib.mkAfter ''
    # codex
    export CODEX_HOME="${codexHome}"
  '';
}
