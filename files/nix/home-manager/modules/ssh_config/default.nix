{ ... }:
{
  programs.ssh = {
    enable = true;
    includes = [ "~/.ssh/extra_config" ];
    serverAliveCountMax = 3;
    serverAliveInterval = 30;
    hashKnownHosts = true;
  };
}
