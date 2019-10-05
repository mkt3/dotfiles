;;====================================================================
;; ddskk
;;====================================================================
(setq skk-user-directory "~/.emacs.d/ddskk.d")

(use-package ddskk
  ;; :straight ddskk
  ;; :disabled t
  :bind* (("C-x j" . skk-mode))
  :init
  (setq default-input-method "japanese-skk" )
  :config
  )
