{ pkgs, ... }:
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

  home.file.".zshenv".text = ''
    # ssh
    export SSH_AGENT_PID=""
  ''
  + (
    if pkgs.stdenv.hostPlatform.isLinux then
      "export SSH_AUTH_SOCK=\"\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh\"\n"
    else if pkgs.stdenv.hostPlatform.isDarwin then
      "export SSH_AUTH_SOCK=\"\${HOME}/.gnupg/S.gpg-agent.ssh\"\n"
    else
      ""
  );
}
