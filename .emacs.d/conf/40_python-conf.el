;; python-mode をロードする
(when (autoload 'python-mode "python-mode" "Python editing mode." t)
;; python-mode のときのみ python-pep8 のキーバインドを有効にする
(add-hook 'python-mode-hook
       (lambda ()
                  (local-set-key "\C-c\ p" 'python-pep8)))

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist)))
