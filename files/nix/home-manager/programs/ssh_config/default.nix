{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    includes = [ "~/.ssh/extra_config" ];
    serverAliveCountMax = 5;
    serverAliveInterval = 60;
    hashKnownHosts = true;
  };

  home.file.".zshenv".text =
    ''
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
