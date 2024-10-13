{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden --glob \"!.git\"";
    defaultOptions = [
      "--reverse"
      "--border"
      "--ansi"
    ];

    fileWidgetCommand = "rg --files --hidden --follow --ignore-file=''$XDG_CONFIG_HOME/ripgrep/ignore";
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
}
