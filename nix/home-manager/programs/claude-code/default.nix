{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}:
{
  home.packages = [
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
  ];

  home.activation.claudeCodeNotifyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH=${
      lib.makeBinPath [
        pkgs.coreutils
        pkgs.jq
      ]
    }:$PATH ${lib.getExe pkgs.bash} ${config.home.homeDirectory}/.local/bin/setup_claude_code_notify.sh
  '';

  home.file.".local/bin/setup_claude_code_notify.sh" = {
    source = ./setup_claude_code_notify.sh;
    executable = true;
  };
}
