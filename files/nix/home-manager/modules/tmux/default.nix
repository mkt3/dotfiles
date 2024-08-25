{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    keyMode = "emacs";
    terminal = "tmux-256color";
    historyLimit = 100000;
    shortcut = "q";

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.extrakto;
        extraConfig = "set -g @extrakto_split_direction \"v\"";
      }
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.nord
    ];
    extraConfig = ''
      set -g set-clipboard on

      # 設定ファイルをリロードする
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # | でペインを縦に分割する
      bind | split-window -h

      # - でペインを横に分割する
      bind - split-window -v

      set -g history-limit 100000

      # Vimのキーバインドでペインを移動する
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+
      bind C-o select-pane -t :.+

      # Vimのキーバインドでペインをリサイズする
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # マウス操作を有効にする
      setw -g mouse

      # 24bit color端末を使用する
      set-option -ga terminal-overrides ",$TERM:Tc"

      # vim: set ft=tmux tw=0 nowrap:
      # ウィンドウを閉じた時に番号を詰める
      set-option -g renumber-windows on

      # ステータスバーを上部に表示
      set -g status-position top

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

      set-option -g status-left "#[fg=black,bg=cyan,bold] #h:#[fg=black,bg=cyan,nobold]#S #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
      set-option -g status-right "#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] #(tmux-mem-cpu-load --interval 2 -a 1  -g 0) "
    '';
  };
}
