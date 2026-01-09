{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "${config.home.homeDirectory}/.ssh/extra_config" ];
    matchBlocks."*" = {
      forwardAgent = false;
      serverAliveInterval = 60;
      serverAliveCountMax = 5;
      compression = false;
      addKeysToAgent = "no";
      hashKnownHosts = true;
      userKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "${config.home.homeDirectory}/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };
}
