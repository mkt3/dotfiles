{ ... }:
{
  services.podman = {
    enable = true;
    settings = {
      policy = {
        default = [ { type = "reject"; } ];
        transports = {
          docker."localhost:5000" = [ { type = "insecureAcceptAnything"; } ];
          "containers-storage"."" = [ { type = "insecureAcceptAnything"; } ];
        };
      };

      registries.registry = [
        {
          location = "localhost:5000";
          insecure = true;
        }
      ];
    };
  };
}
