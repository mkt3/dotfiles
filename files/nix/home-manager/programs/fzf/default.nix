{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden --glob \\\"!.git\\\"";
    defaultOptions = [
      "--reverse"
      "--border"
      "--ansi"
    ];

    fileWidgetCommand = "rg --files --hidden --follow --ignore-file=$XDG_CONFIG_HOME/ripgrep/ignore";
    fileWidgetOptions = [
      "--preview 'bat  --color=always --style=header,grid --line-range :100 {}'"
    ];

    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [
        "-p 80%"
      ];
    };
  };

  xdg.configFile."zsh/defer.zsh" = {
    text = ''
      # fkill - kill process
      fkill() {
          local pid
          pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

          if [ "x$pid" != "x" ]
          then
              echo $pid | xargs kill -''${"1:-9"}
          fi
      }'';
  };
}
