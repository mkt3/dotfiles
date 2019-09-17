;====================================================================
;; miscellaneous
;;====================================================================
(set-default-coding-systems 'utf-8)               ;; default-coding
(prefer-coding-system 'utf-8-unix)                ;; テキストファイル／新規バッファの文字コード
(set-file-name-coding-system 'utf-8-unix)         ;; ファイル名の文字コード
(set-keyboard-coding-system 'utf-8-unix)          ;; キーボード入力の文字コード
(global-font-lock-mode t)                         ;; 文字の色つけ
(transient-mark-mode t)                           ;; リージョンの色付け
(delete-selection-mode t)                         ;; リージョンを削除
(show-paren-mode t)                               ;; 対応する括弧に色付け
(bind-key "C-m" 'newline-and-indent)              ;; 改行時にオートインデント
(bind-key* "C-h" 'delete-backward-char)           ;; ctrl-hで削除
(bind-key*  "C-c h" 'help-for-help)               ;; ctrl-c hで help
(setq ring-bell-function 'ignore)                 ;; ビープ音を消音
(line-number-mode t)                              ;; カーソルのある行番号を表示
(column-number-mode t)                            ;; カーソルのある列番号を表示
;;(blink-cursor-mode -1)                            ;; カーソルの点滅停止
(setq display-time-string-forms                   ;; 時計の表示設定変更
      '(month "/" day "(" dayname ") " 24-hours ":" minutes))
(display-time)                                    ;; 時計を表示
(setq-default tab-width 4 indent-tabs-mode nil)   ;; インデントをspace4個に設定
(setq-default abbrev-mode t)                      ;; 全モードでabbrevを有効化
(setq make-backup-files nil)                      ;; backup fileの作成を停止
(setq auto-save-default nil)                      ;; auto-save fileの作成を停止
(fset 'yes-or-no-p 'y-or-n-p)                     ;; "yes or no"を"y or n"へ
(setq vc-follow-symlinks t)                       ;; version 管理のシンボリックの扱い
(setq kill-whole-line t)                          ;; kill-line で行末の改行削除
(setq system-time-locale "C")                     ;; org-mode の timestamp を英語表記にするために locale を変更
(setq make-pointer-invisible t)                   ;; キータイプ中はマウスカーソル非表示
(setq mouse-highlight nil)                        ;; マウスのハイライトを OFF
(electric-pair-mode 1)                            ;; 閉じ括弧の自動挿入
(require 'uniquify)                               ;; 同一バッファ名にディレクトリ付与
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")
(setq custom-file (locate-user-emacs-file "custom.el"))

;;====================================================================
;; frame
;;====================================================================
(setq default-frame-alist
      (append '((width                . 85)  ; フレーム幅
                (height               . 38 ) ; フレーム高
             ;; (left                 . 70 ) ; 配置左位置
             ;; (top                  . 28 ) ; 配置上位置
                (line-spacing         . 0  ) ; 文字間隔
                (left-fringe          . 10 ) ; 左フリンジ幅
                (right-fringe         . 11 ) ; 右フリンジ幅
                (menu-bar-lines       . 0  ) ; メニューバー
                (tool-bar-lines       . 0  ) ; ツールバー
                (vertical-scroll-bars . 1  ) ; スクロールバー
                (scroll-bar-width     . 17 ) ; スクロールバー幅
                (cursor-type          . box) ; カーソル種別
                (alpha                . 95 ) ; 透明度
                ) default-frame-alist) )
(setq initial-frame-alist default-frame-alist)

;; フレーム タイトル
(setq frame-title-format
      '("emacs " emacs-version (buffer-file-name " - %f")))

;; 初期画面の非表示（有効：t、無効：nil）
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)

;; frameの最大化
(bind-key* "C-c C-f" 'toggle-frame-fullscreen)


;;====================================================================
;; font
;;====================================================================
(if window-system
    (progn
      (create-fontset-from-ascii-font
       "Ricty Diminished-16:weight=normal:slant=normal"
       nil
       "Ricty_Diminished")
      (set-fontset-font
       "fontset-Ricty_Diminished"
       'unicode
       "Ricty Diminished-16:weight=normal:slant=normal"
       nil
       'append)
      (add-to-list 'default-frame-alist '(font . "fontset-Ricty_Diminished"))
      ))

;;====================================================================
;; linum-mode
;;====================================================================
(global-display-line-numbers-mode) ;; 行番号を常に表示

;;====================================================================
;; color theme
;;====================================================================
  (use-package doom-themes
    :custom
    (doom-themes-enable-italic t)
    (doom-themes-enable-bold t)
    :custom-face
    (doom-modeline-bar ((t (:background "#6272a4"))))
    :config
    ;; (load-theme 'doom-nova t)
    (load-theme 'doom-dracula t)
    ;; (load-theme 'doom-nord t)
    (doom-themes-neotree-config)
    (doom-themes-org-config)
    (use-package doom-modeline
      :custom
      (doom-modeline-buffer-file-name-style 'truncate-with-project)
      (doom-modeline-icon t)
      (doom-modeline-major-mode-icon nil)
      (doom-modeline-minor-modes nil)
      :hook
      (after-init . doom-modeline-mode)
      :config
      (set-cursor-color "cyan")
      ;; (line-number-mode 0)
      ;; (column-number-mode 0)
      )
    )

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))


(use-package hide-mode-line
    :hook
    ((neotree-mode imenu-list-minor-mode minimap-mode) . hide-mode-line-mode))

(use-package all-the-icons)

(use-package nyan-mode
   :custom
   (nyan-cat-face-number 4)
   (nyan-animate-nyancat t)
   :hook
   (doom-modeline-mode . nyan-mode))

;;====================================================================
;; window control
;;====================================================================
;; shift+カーソルでwindow間の移動
(windmove-default-keybindings)
(setq windmove-wrap-around t)

(bind-key* "C-M-h" 'windmove-left)
(bind-key* "C-M-k" 'windmove-up)
(bind-key* "C-M-j" 'windmove-down)
(bind-key* "C-M-l" 'windmove-right)

(bind-key "C-x |" 'split-window-right)
(bind-key "C-x -" 'split-window-below)
(bind-key "C-x x" 'delete-window)

;;====================================================================
;; scroll
;;====================================================================
(defun scroll-up-in-place (n)
  (interactive "p")
  (forward-line (- n))
  (scroll-down n))

(defun scroll-down-in-place (n)
  (interactive "p")
  (forward-line n)
  (scroll-up n))

(bind-key "M-p" 'scroll-up-in-place)
(bind-key "M-n" 'scroll-down-in-place)

;;====================================================================
;; text scale
;;====================================================================
(bind-key "M-+" 'text-scale-increase)
(bind-key "M-=" 'text-scale-increase)
(bind-key "M--" 'text-scale-decrease)

;;====================================================================
;; password-store
;;====================================================================
;; (use-package password-store
;;   :config
;;   (setq my:d:password-store "~/.password-store/emacs/")
;;   )

(use-package dimmer
  :disabled
  :custom
  (dimmer-fraction 0.5)
  (dimmer-exclusion-regexp-list
       '(".*Minibuf.*"
         ".*which-key.*"
         ".*NeoTree.*"
         ".*Messages.*"
         ".*Async.*"
         ".*Warnings.*"
         ".*LV.*"
         ".*Ilist.*"))
  :config
  (dimmer-mode t))

(use-package which-key
  :diminish which-key-mode
  :hook (after-init . which-key-mode))

(use-package amx)


(use-package undo-tree
  :bind
  ("M-/" . undo-tree-redo)
  :config
  (global-undo-tree-mode))


(use-package popwin)

(use-package ace-window
  :bind
  ("C-x o" . ace-window)
  :custom
  (aw-keys '(?j ?k ?l ?i ?o ?h ?y ?u ?p))
  :custom-face
  (aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c")))))

  
