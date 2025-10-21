{ config, pkgs, ... }:
{
  home.packages = [ pkgs.kubectl ];

  home.file.".zshenv".text = ''
    # kubernetes
    export KUBECONFIG="${config.xdg.configHome}/kube/config"
    export KUBECACHEDIR="${config.xdg.configHome}/kube"
  '';
}
