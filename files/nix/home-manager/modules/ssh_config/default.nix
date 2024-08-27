{ ... }:
{
  programs.ssh = {
    enable = true;
    includes = [ "~/.ssh/extra_config" ];
    serverAliveCountMax = 3;
    serverAliveInterval = 30;
    hashKnownHosts = true;
  };

  home.file.".zshenv".text = ''
    # ssh
    export SSH_AGENT_PID=""
    if [[ "$OS" == 'Linux' ]];then
        export SSH_AUTH_SOCK="''${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
    elif [[ "$OS" == 'Darwin' ]];then
        export SSH_AUTH_SOCK="''${HOME}/.gnupg/S.gpg-agent.ssh"
    fi
  '';

}
