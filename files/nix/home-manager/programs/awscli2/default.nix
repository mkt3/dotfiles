{ config, pkgs, lib, ... }:
{
  home.packages = [ pkgs.awscli2 ];

  programs.zsh.envExtra = lib.mkAfter ''
    # aws cli
    export AWS_CONFIG_FILE="${config.xdg.configHome}/aws/config"
    export AWS_SHARED_CREDENTIALS_FILE="${config.xdg.configHome}/aws/credentials"
  '';
}
