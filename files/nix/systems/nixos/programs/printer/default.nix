{ pkgs, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      brlaser                # brother driver
      brgenml1lpr            # brother driver
      brgenml1cupswrapper    # brother driver
    ];
  };
}
