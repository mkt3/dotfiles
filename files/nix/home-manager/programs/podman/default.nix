{ pkgs, ... }:
{
  home.packages = [ pkgs.podman ];

  xdg.configFile."containers/policy.json" = {
    text = ''
      {
        "default": [{"type": "reject"}],
        "transports": {
          "docker": {
            "localhost:5000": [{ "type": "insecureAcceptAnything" }]
          }
        }
      }
    '';
  };
  xdg.configFile."containers/registries.conf" = {
    text = ''
      [registries.insecure]
      registries = ["localhost:5000"]
    '';
  };

}
