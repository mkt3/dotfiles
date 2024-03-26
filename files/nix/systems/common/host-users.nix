{platform, hostname, username, homeDirectory, pkgs,... }:

#############################################################
#
#  Host & Users configuration
#
#############################################################

{
  nixpkgs.hostPlatform = platform;
  networking.hostName = hostname;

  users.users."${username}"= {
    home = homeDirectory;
    description = username;
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ username ];

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };
}
