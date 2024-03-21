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

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };
}
