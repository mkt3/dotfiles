{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}:
{
  home.packages = [
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
  ];

  home.activation.codexNotifyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH=${lib.makeBinPath [ pkgs.gawk pkgs.coreutils ]}:"$PATH" \
    CODEX_HOME=${lib.escapeShellArg "${config.xdg.configHome}/codex"} \
      ${lib.getExe pkgs.bash} ${lib.escapeShellArg "${config.home.homeDirectory}/.local/bin/setup_codex_notify.sh"}
  '';

  home.file.".local/bin/setup_codex_notify.sh" = {
    source = ./setup_codex_notify.sh;
    executable = true;
  };

  programs.zsh.envExtra = lib.mkAfter ''
    # codex
    export CODEX_HOME="${config.xdg.configHome}/codex"
  '';
}
