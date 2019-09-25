(use-package auto-virtualenvwrapper
  :init
  (defun wrapper-auto-virtualenvwrapper-activate ()
    (let ((path (auto-virtualenvwrapper-find-virtualenv-path)))
      (when (and path (not (equal path auto-virtualenvwrapper--path)))
        (setq auto-virtualenvwrapper--path path
              venv-current-name (file-name-base (file-truename path)))
        (venv--activate-dir auto-virtualenvwrapper--path)
        (pyvenv-activate auto-virtualenvwrapper--path)
        (auto-virtualenvwrapper-message "activated virtualenv: %s" path))))

  (add-hook 'python-mode-hook #'wrapper-auto-virtualenvwrapper-activate)
  (add-hook 'focus-in-hook #'wrapper-auto-virtualenvwrapper-activate)
  )

;; (use-package python
;;   :straight py-autopep8
;;   :straight jedi-core
;;   :mode ("\\.py\\'" . python-mode)
;;   :interpreter ("python" . python-mode)
;;   :bind (;("C-c C-c" . quickrun)
;;          ("C-c f" . py-autopep8))
;;   :config
;;   (setq py-autopep8-options '("--max-line-length=200"))
;;   ;; 補完設定
;;   (setq jedi:complete-on-dot t)
;;   (setq jedi:use-shortcuts t)
;;   (add-to-list 'company-backends 'company-jedi)

;;   ;; company-modelとyasnippetとの連携
;;   (defvar company-mode/enable-yas t
;;     "Enable yasnippet for all backends.")
;;   (defun company-mode/backend-with-yas (backend)
;;     (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
;;         backend
;;       (append (if (consp backend) backend (list backend))
;;               '(:with company-yasnippet))))
;;   (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
;;   )

(use-package elpy
  :init
  (elpy-enable))


(use-package py-isort
  :after python-mode
  :init
  (add-hook 'before-save-hook 'py-isort-before-save)
  )


(defun python-args-to-docstring-restructuredtext-args ()
  "return docstring format for the python arguments in yas-text"
  (let* ((args (python-split-args yas-text))
         (format-arg (lambda(arg)
                       (concat ":param "(nth 0 arg) ": " (if (nth 1 arg) ", optional") )))
         (formatted-params (mapconcat format-arg args "\n")))
    (unless (string= formatted-params "")
      (mapconcat 'identity
                 (list formatted-params)
                 "\n"))))

(defun python-args-to-docstring-restructuredtext-ret ()
  "return docstring format for the python arguments in yas-text"
  (let* ()
    (unless (string= yas-text "")
      (mapconcat 'identity
                 (list ":return: ")
                 "\n"))))

(defun python-args-to-docstring-google ()
  "return docstring format for the python arguments in yas-text"
  (let* ((args (python-split-args yas-text))
         (format-arg (lambda(arg)
                       (concat "\s       " (nth 0 arg) " (): " (if (nth 1 arg) ", optional"))))
         (formatted-params (mapconcat format-arg args "\n")))
    (unless (string= formatted-params "")
      (mapconcat 'identity
                 (list "\nArgs:" formatted-params
                       "\nReturns:\n        ")
                 "\n"))))
