{ ... }:
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

  home.file.".zshenv".text = ''
    # docker
    export DOCKER_CONFIG="''${XDG_CONFIG_HOME}/docker"

    # Rootless docker path
    export DOCKER_HOST=unix:///run/user/`id $(whoami) | awk -F'[=()]' '{print $2}'`/docker.sock
  '';
}
