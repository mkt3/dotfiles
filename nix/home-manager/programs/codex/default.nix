{ config, lib, pkgs, ... }:
{
  programs.codex = {
    enable = true;
  };

  home.activation.codexNotifyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH=${lib.makeBinPath [ pkgs.gawk pkgs.gnugrep pkgs.coreutils ]}:$PATH ${lib.getExe pkgs.bash} ${config.home.homeDirectory}/.local/bin/setup_codex_notify.sh
  '';

  home.file.".local/bin/setup_codex_notify.sh" = {
    source = ./setup_codex_notify.sh;
    executable = true;
  };
}
