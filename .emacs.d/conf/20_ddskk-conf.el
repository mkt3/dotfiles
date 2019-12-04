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
  (setq default-input-method "japanese-skk")
  ;; lisp-interaction-mode
  (add-hook 'lisp-interaction-mode-hook
            '(lambda()
               (progn
                 (eval-expression (skk-mode) nil)
                 )))
  ;; find-fileで skk-mode になる
  (add-hook 'find-file-hooks
            '(lambda()
               (progn
                 (eval-expression (skk-mode) nil)
                 )))
  (define-key minibuffer-local-map (kbd "C-j") 'skk-kakutei)
  )
