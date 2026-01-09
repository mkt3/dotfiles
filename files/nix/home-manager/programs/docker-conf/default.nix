{ config, lib, ... }:
{
  xdg.configFile."docker.config.json" = {
    text = ''
      {
        "auths": {},
        "detachKeys": "ctrl-\\",
        "currentContext": "rootless"
      }
    '';
  };

  programs.zsh.envExtra = lib.mkAfter ''
    # docker
    export DOCKER_CONFIG="${config.xdg.configHome}/docker"

    # Rootless docker path
    export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
  '';
}
