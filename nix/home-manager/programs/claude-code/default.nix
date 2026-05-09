{ config, lib, pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
  };

  home.activation.claudeCodeNotifyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.jq ]}:$PATH ${lib.getExe pkgs.bash} ${config.home.homeDirectory}/.local/bin/setup_claude_code_notify.sh
  '';

  home.file.".local/bin/setup_claude_code_notify.sh" = {
    source = ./setup_claude_code_notify.sh;
    executable = true;
  };
}
