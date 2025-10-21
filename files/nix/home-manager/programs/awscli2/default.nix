{ config, pkgs, ... }:
{
  home.packages = [ pkgs.awscli2 ];

  home.file.".zshenv".text = ''
    # aws cli
    export AWS_CONFIG_FILE="${config.xdg.configHome}/aws/config"
    export AWS_SHARED_CREDENTIALS_FILE="${config.xdg.configHome}/aws/credentials"
  '';
}
