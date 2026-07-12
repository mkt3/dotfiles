{ pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
    nvidia = {
      open = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      modesetting.enable = true;
    };

    # Keep the LG display identifiable when the KVM temporarily drops EDID.
    display = {
      edid.packages = [
        (pkgs.runCommand "lg-hdr-4k-edid" { } ''
          mkdir -p $out/lib/firmware/edid
          base64 -d > $out/lib/firmware/edid/lg-hdr-4k.bin <<'EOF'
          AP///////wAebQZ3aFQDAAQeAQOAPCJ46j4xrlBHrCcMUFQhCABxQIGAgcCpwNHAgQABAQEBCOgAMPJwWoCwWIoAWFQhAAAeBHQAMPJwWoCwWIoAWFQhAAAaAAAA/QA4PR6HPAAKICAgICAgAAAA/ABMRyBIRFIgNEsKICAgAR0CAzhxTQQiIB8SAwQBYWBdXl8jCQcHbQMMABAAuDwgAGABAgNn2F3EAXiAA+MPAAPjBcAA4wYFAQI6gBhxOC1AWCxFAFhUIQAAHlZeAKCgoClQMCA1AFhUIQAAGgAAAP8AMDA0TlRBQjZFMjE2CgAAAAAAAAAAAAAAAAAAAAAAlg==
          EOF
        '')
      ];
      outputs."Unknown-2".edid = "lg-hdr-4k.bin";
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
