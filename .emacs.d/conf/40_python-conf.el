(use-package python-mode
  :straight python-mode
  :straight py-autopep8
  :straight virtualenvwrapper
  :straight auto-virtualenvwrapper
  :straight jedi-core
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :bind (;("C-c C-c" . quickrun)
         ("C-c f" . py-autopep8))
  :config
  (custom-set-variables
   '(python-environment-virtualenv (list "python" "-m" "venv")))
  (add-hook 'python-mode-hook #'auto-virtualenvwrapper-activate)
  ;; Activate on changing buffers
  (add-hook 'window-configuration-change-hook #'auto-virtualenvwrapper-activate)
  ;; Activate on focus in
  (add-hook 'focus-in-hook #'auto-virtualenvwrapper-activate)
  (setq py-autopep8-options '("--max-line-length=200"))
  ;; 補完設定
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
