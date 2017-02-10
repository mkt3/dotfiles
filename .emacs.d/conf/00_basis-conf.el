;;====================================================================
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
(bind-key "\C-m" 'newline-and-indent)             ;; 改行時にオートインデント
(bind-key* "\C-h" 'delete-backward-char)          ;; ctrl-hで削除
(bind-key*  "\C-ch" 'help-for-help)               ;; ctrl-c hで help
(bind-key*  "\C-\\" 'undo)                        ;; undo
(bind-key* "\C-cf" 'revert-buffer)                ;; ファイルを保存せずに再度開く
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
(require 'uniquify)                               ;; 同一バッファ名にディレクトリ付与
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

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
(bind-key* "\C-c\C-f" 'toggle-frame-fullscreen)

;;====================================================================
;; linum-mode
;;====================================================================
;;(global-linum-mode t)                             ;; 行番号を常に表示
(setq linum-format "%4d ")
(dolist (hook (list
              'c-mode-hook
              'c++-mode-hook
              'emacs-lisp-mode-hook
              'lisp-interaction-mode-hook
              'lisp-mode-hook
              'java-mode-hook
              'sh-mode-hook
              'python-mode-hook
              ))
  (add-hook hook (lambda () (linum-mode t))))

;;====================================================================
;; color theme
;;====================================================================
(customize-set-variable 'frame-background-mode 'dark)
(add-to-list 'custom-theme-load-path (locate-user-emacs-file "el-get/color-theme-solarized")) 
(load-theme 'solarized t)

(setq my-alpha 95)
(set-frame-parameter nil 'alpha my-alpha)

(defun my-alpha-up ()
  (interactive)
  (if (< my-alpha 100)
      (setq my-alpha (+ my-alpha 1)))
  (set-frame-parameter nil 'alpha my-alpha))

(defun my-alpha-down ()
  (interactive)
  (if (> my-alpha 0)
      (setq my-alpha (- my-alpha 1)))
  (set-frame-parameter nil 'alpha my-alpha))

(global-set-key [?\C-\:] 'my-alpha-up)
(global-set-key [?\C-\;] 'my-alpha-down)

;;====================================================================
;; move window 
;;====================================================================
;; shift+カーソルでwindow間の移動
(windmove-default-keybindings)
(setq windmove-wrap-around t)

(bind-key* "\C-\M-h" 'windmove-left)
(bind-key* "\C-\M-k" 'windmove-up)
(bind-key* "\C-\M-j" 'windmove-down)
(bind-key* "\C-\M-l" 'windmove-right)

;;====================================================================
;; toggle truncate lines
;;====================================================================
(defun toggle-truncate-lines ()
  "折り返し表示をトグル"
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))

(bind-key "\C-cl" 'toggle-truncate-lines)

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

(global-set-key "\M-p" 'scroll-up-in-place)
(global-set-key "\M-n" 'scroll-down-in-place) 

