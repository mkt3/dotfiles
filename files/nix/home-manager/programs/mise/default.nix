{ ... }:
{
  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      legacy_version_file = false;
      always_keep_download = false;
      always_keep_install = false;
      plugin_autoupdate_last_check_duration = "1 week";
      trusted_config_paths = [ "~/workspace/ghq" ];
      verbose = false;
      asdf_compat = false;
      jobs = 4;
      raw = false;
      yes = false;
      not_found_auto_install = true;
      task_output = "prefix";
      paranoid = false;
      shorthands_file = "~/.config/mise/shorthands.toml";
      disable_default_shorthands = false;
      experimental = true;
    };
  };

  home.file.".zshenv".text = ''
    # mise
    export MISE_CONFIG_FILE="''${XDG_CONFIG_HOME}/mise/config.toml"
    export MISE_DATA_DIR="''${XDG_DATA_HOME}/mise"
    export MISE_CACHE_DIR="''${XDG_CACHE_HOME}/mise"
    export MISE_USE_TOML=1
  '';
}
