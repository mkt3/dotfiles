;;====================================================================
;; ddskk
;;====================================================================
(use-package skk
  :straight ddskk
  :bind* (("C-x j" . skk-mode))
  :init
  (setq skk-user-directory "~/.emacs.d/ddskk.d"
        default-input-method "japanese-skk" )
  :config
  )
