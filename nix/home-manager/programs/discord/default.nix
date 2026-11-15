{ config, ... }:
{
  programs.discord = {
    enable = true;
    settings = {
      SKIP_HOST_UPDATE = true;
      SKIP_MODULE_UPDATE = true;
    };
  };

  # Replace settings.json even if Discord has rewritten it as a regular file.
  home.file."${config.xdg.configHome}/discord/settings.json".force = true;
}
