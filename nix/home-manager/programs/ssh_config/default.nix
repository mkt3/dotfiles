{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "${config.home.homeDirectory}/.ssh/extra_config" ];
    settings."*" = {
      ForwardAgent = false;
      ServerAliveInterval = 60;
      ServerAliveCountMax = 5;
      Compression = false;
      AddKeysToAgent = "no";
      HashKnownHosts = true;
      UserKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "${config.home.homeDirectory}/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };
}
