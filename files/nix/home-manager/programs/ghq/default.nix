{ pkgs, config, ... }:
{
  home.packages = [ pkgs.ghq ];

  programs.git = {
    extraConfig = {
      ghq = {
        root = "${config.home.homeDirectory}/workspace/ghq";
      };
    };
  };

  xdg.configFile."zsh/defer.zsh" = {
    text = ''
      function sd()
      {
          local session_name="$(tmux display-message -p '#S')"
          if [ -z "$session_name" ]; then
              cd "$HOME"
          fi

          local default_dir
          if [ "$session_name" = "main_session" ]; then
              default_dir="$HOME"
          else
              default_dir="$(ghq list --exact --full-path "$session_name")"
          fi

          cd "$default_dir"
      }
    '';
  };
}
