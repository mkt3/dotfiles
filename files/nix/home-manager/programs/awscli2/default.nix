{ pkgs, ... }:
{
  home.packages = [ pkgs.awscli2 ];

  home.file.".zshenv".text = ''
    # aws cli
    export AWS_CONFIG_FILE="''${XDG_CONFIG_HOME}/aws/config"
    export AWS_SHARED_CREDENTIALS_FILE="''${XDG_CONFIG_HOME}/aws/credentials"
  '';
}
