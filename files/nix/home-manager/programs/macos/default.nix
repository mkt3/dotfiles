{ config, ... }:
{

  home.file.".local/bin/_setup_macos.sh" = {
    executable = true;
    source = ./_setup_macos.sh;
    onChange = "${config.home.homeDirectory}/.local/bin/_setup_macos.sh";
  };

  home.file."Library/Preferences/nsmb.conf".text = ''
    [default]
    # Use NTFS streams if supported
    streams=yes

    # Soft mount by default
    soft=yes

    # Disable signing due to macOS bug
    signing_required=no

    # Disable directory caching
    dir_cache_off=yes

    # Lock negotiation to SMB2/3 only
    # 7 == 0111  SMB 1/2/3 should be enabled
    # 6 == 0110  SMB 2/3 should be enabled
    # 4 == 0100  SMB 3 should be enabled
    protocol_vers_map=6

    # No SMB1, so we disable NetBIOS
    port445=no_netbios

    # Turn off notifications
    notify_off=yes

    # SMB Multichannel behavior
    # To disable multichannel support completely uncomment the next line
    # mc_on=no

    # Some Wi-Fi networks advertise faster speeds than the connected wired network.
    mc_prefer_wired=yes

  '';
}
