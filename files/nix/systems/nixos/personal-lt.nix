{ pkgs, lib, ... }:
{
  boot.kernelParams =  [
    "nvme_core.default_ps_max_latency_us=0"
    "pcie_aspm=off"
  ];

  zramSwap.enable = true;

  networking.networkmanager.wifi.powersave = false;

  systemd.services.bluetooth-rfkill-unblock = {
    description = "Unblock Bluetooth rfkill at boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "bluetooth.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${lib.getExe' pkgs.util-linux "rfkill"} unblock bluetooth"
      ];
    };
  };
}
