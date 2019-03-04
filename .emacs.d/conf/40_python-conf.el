(use-package python-mode
  :straight python-mode
  :straight py-autopep8
  :straight virtualenvwrapper
  :straight auto-virtualenvwrapper
  :straight jedi-core
  :config
  (custom-set-variables
   '(python-environment-virtualenv (list "python" "-m" "venv")))
  (add-hook 'python-mode-hook #'auto-virtualenvwrapper-activate)
  ;; Activate on changing buffers
  (add-hook 'window-configuration-change-hook #'auto-virtualenvwrapper-activate)
  ;; Activate on focus in
  (add-hook 'focus-in-hook #'auto-virtualenvwrapper-activate)

  (defun my-python-mode-setup ()
    (require 'py-autopep8)
    (setq py-autopep8-options '("--max-line-length=200"))
                                        ;  (py-autopep8-enable-on-save)
    (yas-global-mode 1)
    )
  
  (defun set-python-keybinds ()
    (global-set-key (kbd "C-c C-c") 'quickrun)
    (define-key python-mode-map (kbd "C-c f") 'py-autopep8)
    )

  ;; python-mode をロードする
  (when (autoload 'python-mode "python-mode" "Python editing mode." t)
    ;; python-mode のときのみ python-pep8 のキーバインドを有効にする
    (add-hook 'python-mode-hook
              (lambda ()
                (my-python-mode-setup)
                (set-python-keybinds)
       ))

    (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
    (setq interpreter-mode-alist (cons '("python" . python-mode)
                                       interpreter-mode-alist)))

  ;; 補完設定
  (require 'jedi-core)
  (setq jedi:complete-on-dot t)
  (setq jedi:use-shortcuts t)
  (add-to-list 'company-backends 'company-jedi)
  
  ;; company-modelとyasnippetとの連携
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
        backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))
  (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
  )



