{ pkgs, ... }:
{
  boot.kernelParams =  [
    "nvme_core.default_ps_max_latency_us=0"
    "pcie_aspm=off"
  ];

  zramSwap.enable = true;

  networking.networkmanager.wifi.powersave = false;
}
