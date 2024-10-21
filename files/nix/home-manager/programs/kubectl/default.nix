{ pkgs, ... }:
{
  home.packages = [ pkgs.kubectl ];

  home.file.".zshenv".text = ''
    # kubernetes
    export KUBECONFIG="''${XDG_CONFIG_HOME}/kube/config"
    export KUBECACHEDIR="''${XDG_CACHE_HOME}/kube"
  '';
}
