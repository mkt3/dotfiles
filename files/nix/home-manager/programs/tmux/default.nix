{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    focusEvents = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    historyLimit = 10000;
    shortcut = "q";
    secureSocket = true;
    shell = "${pkgs.zsh}/bin/zsh";
    newSession = true;
    customPaneNavigationAndResize = true;
    resizeAmount = 5;
    mouse = true;

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.extrakto;
        extraConfig = ''
          set -g @extrakto_split_direction "a"
          set -g @extrakto_clip_tool_run "tmux_osc52"
        '';
      }
      {
        plugin = tmuxPlugins.jump;
        extraConfig = "set -g @jump-key 'q'";
      }
      tmuxPlugins.sensible
      tmuxPlugins.yank
      # tmuxPlugins.nord
    ];
    extraConfig = ''
      set -g set-clipboard on

      bind r source-file ~/.config/tmux/tmux.conf \; display "tmux.conf has been reloaded"

      bind | split-window -h

      bind - split-window -v

      bind -r C-h select-window -t :-
      bind -r BSpace select-window -t :-
      bind -r C-l select-window -t :+
      bind C-o select-pane -t :.+

      # 24bit color端末を使用する
      set-option -ga terminal-overrides ",$TERM:Tc"

      # ウィンドウを閉じた時に番号を詰める
      set-option -g renumber-windows on

      # status
      set -g status-position top
      set -g status-interval 5

      ## ヴィジュアルノーティフィケーションを無効にする
      setw -g monitor-activity off
      set -g visual-activity off

      bind t popup -w90% -h90% -E btm -b
      bind b popup -w90% -h90% -E btm
      bind g popup -w90% -h90% -d '#{pane_current_path}' -E lazygit
      bind o popup -w90% -h90% -E $HOME/.local/bin/tmux_session.sh
      bind n popup -w90% -h90% -E 'window=$(tmux display -p -F "#S:#I.#P") && export FZF_DEFAULT_OPTS="-m --layout=reverse --border" && navi --print | tr -d "\n" | tmux load-buffer -b tmp - && tmux paste-buffer -drp -t $window -b tmp'

      set-option -g status-left-length 60
      set-option -g status-right-length 60

      set -gu default-command

      ## nord
      set-option -g status-style bg=black,fg=white
      set-option -g pane-border-style bg=default,fg=brightblack
      set-option -g pane-active-border-style bg=default,fg=blue
      set-option -g display-panes-colour black
      set-option -g display-panes-active-colour brightblack
      set-option -g status-left "#[fg=black,bg=cyan,bold] #h:#[fg=black,bg=cyan,nobold]#S #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
      set-option -g status-right "#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] #(tmux-mem-cpu-load --interval 5 -a 1  -g 0) "
      set-option -g window-status-format "#[fg=black,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#I #[fg=white,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#W #{?window_zoomed_flag, ,} #[fg=brightblack,bg=black,nobold,noitalics,nounderscore]"
      set-option -g window-status-current-format "#[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#I #[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#W #{?window_zoomed_flag, ,} #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
      set-option -g window-status-separator ""
    '';
  };
}
