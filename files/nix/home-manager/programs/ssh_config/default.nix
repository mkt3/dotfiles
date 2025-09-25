{ pkgs, ... }:
let
  lib = pkgs.lib;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/extra_config" ];
    matchBlocks."*" = {
      forwardAgent = false;
      serverAliveInterval = 60;
      serverAliveCountMax = 5;
      compression = false;
      addKeysToAgent = "no";
      hashKnownHosts = true;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };
}
