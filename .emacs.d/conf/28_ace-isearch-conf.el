(use-package ace-isearch
  :straight avy
  :straight ace-isearch
  :config
  (global-ace-isearch-mode +1)
  (custom-set-variables
   '(ace-isearch-jump-delay 0.5)
   '(ace-isearch-function 'avy-goto-char)
   '(ace-isearch-use-jump 'printing-char))
  )
