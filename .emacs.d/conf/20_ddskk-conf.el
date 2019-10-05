;;====================================================================
;; ddskk
;;====================================================================
(setq skk-user-directory "~/.emacs.d/ddskk.d")
(setq viper-mode nil)

(use-package ddskk
  ;; :straight ddskk
  ;; :disabled t
  :bind* (("C-x j" . skk-mode))
  :init
  (setq default-input-method "japanese-skk" )
  :config
  )
