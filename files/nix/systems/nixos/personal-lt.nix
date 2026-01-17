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

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };
}
