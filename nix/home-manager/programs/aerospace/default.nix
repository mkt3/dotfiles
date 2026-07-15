{ ... }:
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
  };
}
