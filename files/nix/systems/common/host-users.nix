{
  platform,
  hostname,
  username,
  homeDirectory,
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = platform;
  networking.hostName = hostname;

  users.users."${username}" = {
    home = homeDirectory;
    description = username;
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };
}
