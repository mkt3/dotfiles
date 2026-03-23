{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.kubectl ];

  programs.zsh.envExtra = lib.mkAfter ''
    # kubernetes
    export KUBECONFIG="${config.xdg.configHome}/kube/config"
    export KUBECACHEDIR="${config.xdg.configHome}/kube"
  '';
}
