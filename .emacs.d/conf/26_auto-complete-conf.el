(ac-config-default)

(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'python-mode)

(setq ac-auto-start 2)  ;; n文字以上の単語の時に補完を開始
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選
(setq ac-dwim t)

;;; ベースとなるソースを指定
(defvar my-ac-sources
  '(ac-source-yasnippet
    ac-source-abbrev
    ac-source-dictionary
    ac-source-words-in-same-mode-buffers))

;;; 個別にソースを指定
(defun ac-python-mode-setup ()
  (setq-default ac-sources my-ac-sources))

(add-hook 'python-mode-hook 'ac-python-mode-setup)

(global-auto-complete-mode t)
