{
  config,
  pkgs,
  lib,
  ...
}:
let
  nord = import ../nord/palette.nix;
in
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
    shell = lib.getExe pkgs.zsh;
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
      set -g allow-passthrough on

      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display "tmux.conf has been reloaded"

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
      bind p popup -w90% -h90% -E 'k9s -A'
      bind o popup -w90% -h90% -E ${config.home.homeDirectory}/.local/bin/tmux_session.sh
      bind n popup -w90% -h90% -E 'window=$(tmux display -p -F "#S:#I.#P") && export FZF_DEFAULT_OPTS="-m --layout=reverse --border" && navi --print | tr -d "\n" | tmux load-buffer -b tmp - && tmux paste-buffer -drp -t $window -b tmp'

      set-option -g status-left-length 60
      set-option -g status-right-length 60

      set -gu default-command

      ## Nord
      set-option -g status-style "bg=${nord.background},fg=${nord.text}"
      set-option -g pane-border-style "bg=default,fg=${nord.muted}"
      set-option -g pane-active-border-style "bg=default,fg=${nord.accent}"
      set-option -g display-panes-colour "${nord.muted}"
      set-option -g display-panes-active-colour "${nord.accent}"
      set-option -g message-style "bg=${nord.selection},fg=${nord.textBright}"
      set-option -g mode-style "bg=${nord.accent},fg=${nord.background}"
      set-option -g popup-border-style "fg=${nord.muted}"
      set-option -g status-left "#[fg=${nord.background},bg=${nord.accent},bold] #h:#[fg=${nord.background},bg=${nord.accent},nobold]#S #[fg=${nord.accent},bg=${nord.background},nobold,noitalics,nounderscore]"
      set-option -g status-right "#[fg=${nord.selection},bg=${nord.background},nobold,noitalics,nounderscore]#[fg=${nord.text},bg=${nord.selection}] #(tmux-mem-cpu-load --interval 5 -a 1  -g 0) "
      set-option -g window-status-format "#[fg=${nord.background},bg=${nord.selection},nobold,noitalics,nounderscore] #[fg=${nord.text},bg=${nord.selection}]#I #[fg=${nord.text},bg=${nord.selection},nobold,noitalics,nounderscore] #[fg=${nord.text},bg=${nord.selection}]#W #{?window_zoomed_flag, ,} #[fg=${nord.selection},bg=${nord.background},nobold,noitalics,nounderscore]"
      set-option -g window-status-current-format "#[fg=${nord.background},bg=${nord.accent},nobold,noitalics,nounderscore] #[fg=${nord.background},bg=${nord.accent}]#I #[fg=${nord.background},bg=${nord.accent},nobold,noitalics,nounderscore] #[fg=${nord.background},bg=${nord.accent}]#W #{?window_zoomed_flag, ,} #[fg=${nord.accent},bg=${nord.background},nobold,noitalics,nounderscore]"
      set-option -g window-status-separator ""

      bind-key e run-shell '
       DIR="#{pane_current_path}"
       SESSION="#{session_id}"
       WINDOW="#{window_id}"
       EMACS_PANE="#{pane_id}"

       tmux rename-window -t "$WINDOW" "dev"

       TERMINAL_PANE=$(tmux split-window -t "$EMACS_PANE" -v -p 30 -c "$DIR" -P -F "##{pane_id}")

       tmux select-pane -t "$EMACS_PANE"
       CODEX_PANE=$(tmux split-window -t "$EMACS_PANE" -h -p 50 -c "$DIR" -P -F "##{pane_id}")

       tmux send-keys -t "$EMACS_PANE" "emacs" C-m
       tmux send-keys -t "$CODEX_PANE" "codex" C-m

       tmux select-pane -t "$TERMINAL_PANE"
       '
    '';
  };
}
