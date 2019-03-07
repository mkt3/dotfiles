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
(setq system-time-locale t))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

;;====================================================================
;; move window
;;====================================================================
;; shift+カーソルでwindow間の移動
(windmove-default-keybindings)
(setq windmove-wrap-around t)

(bind-key* "C-M-h" 'windmove-left)
(bind-key* "C-M-k" 'windmove-up)
(bind-key* "C-M-j" 'windmove-down)
(bind-key* "C-M-l" 'windmove-right)

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

(bind-key "C-c l" 'toggle-truncate-lines)

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
;; authentication
;;====================================================================
(use-package auth-source
  :straight nil
  :config 
  (add-to-list 'auth-sources (concat user-emacs-directory ".authinfo.plist"))
  
  (defun my:auth-source-get-property (prop-name &rest spec &allow-other-keys)
    (let* ((founds (apply 'auth-source-search spec))
           (pkey (intern (concat ":" (format "%s" prop-name))))
           (ret (when founds (plist-get (nth 0 founds) pkey))))
      (if (functionp ret)
        (funcall ret)
        ret))))
