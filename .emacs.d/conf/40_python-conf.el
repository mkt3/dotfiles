(defun my-jedi-mode-setup ()
  (jedi:setup)
  (setq jedi:complete-on-dot t)
  (setq ac-sources
	(delete 'ac-source-words-in-same-mode-buffers ac-sources))
  (add-to-list 'ac-sources 'ac-source-filename)
  (add-to-list 'ac-sources 'ac-source-jedi-direct))

(defun my-python-mode-setup ()
  (require 'py-autopep8)
  (setq py-autopep8-options '("--max-line-length=200"))
  (py-autopep8-enable-on-save)
  (yas-global-mode 1)
  (auto-complete-mode t)
  )

(defun set-python-keybinds ()
  (define-key jedi-mode-map (kbd "<C-tab>") nil) ;;C-tabはウィンドウの移動に用いる
  (global-set-key (kbd "C-c C-c") 'quickrun)
  (define-key python-mode-map "\C-ct" 'jedi:goto-definition)
  (define-key python-mode-map "\C-cb" 'jedi:goto-definition-pop-marker)
  (define-key python-mode-map "\C-cr" 'helm-jedi-related-names)
  (local-set-key "\C-c\ p" 'python-pep8)
  )

;; python-mode をロードする
(when (autoload 'python-mode "python-mode" "Python editing mode." t)
;; python-mode のときのみ python-pep8 のキーバインドを有効にする
(add-hook 'python-mode-hook
       (lambda ()
         (my-jedi-mode-setup)
         (my-python-mode-setup)
         (set-python-keybinds)
         ))

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist)))
