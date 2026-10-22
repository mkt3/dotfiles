{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}:
{
  programs.codex = {
    enable = true;
    package = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
    # Keep Codex-managed settings while applying the values declared here.
    mutableSettings = true;
    settings = {
      features.hooks = true;
      tui.notifications = false;
      tui.theme = "nord";
      hooks =
        lib.mapAttrs
          (_: message: [
            {
              hooks = [
                {
                  type = "command";
                  command = "${config.home.homeDirectory}/.local/bin/notify.sh Codex '${message}' >/dev/null 2>&1 || true";
                  timeout = 5;
                }
              ];
            }
          ])
          {
            Stop = "turn complete";
            PermissionRequest = "approval required";
          };
    };
  };

  programs.zsh.envExtra = lib.mkAfter ''
    # codex
    export CODEX_HOME="${config.xdg.configHome}/codex"
  '';
}
