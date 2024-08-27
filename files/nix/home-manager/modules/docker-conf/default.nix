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
  '';
}
