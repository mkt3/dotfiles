{ lib, ... }:
{
  programs.docker-cli = {
    enable = true;
    settings = {
      auths = { };
      detachKeys = "ctrl-\\";
      currentContext = "rootless";
    };
  };

  programs.zsh.envExtra = lib.mkAfter ''
    # Rootless docker path
    export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
  '';
}
