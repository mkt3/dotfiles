;;====================================================================
;;helm
;;====================================================================
(use-package helm
  :straight helm
  :straight helm-swoop
  :bind (("C-r" . helm-for-files)
         ("C-^" . helm-c-apropos)
         ("C-c C-s" . helm-resume)
         ("M-s" . helm-occur)
         ("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("M-z" . helm-do-grep)
         ("C-S-h" . helm-descbinds)
         ("C-x C-f" . helm-find-files)
         :map helm-map
         ("C-i" . helm-execute-persistent-action)
         ("C-z" . helm-select-action)
         ("C-h" . delete-backward-char)
         :map helm-find-files-map
         ("C-h" . delete-backward-char)
         )
  :bind* (("C-c C-a" . helm-mini))
  :init
  (eval-when-compile (require 'cl))

  ;; ミニバッファで C-h でヘルプでないようにする
  (load "term/bobcat")
  (when (fboundp 'terminal-init-bobcat)
    (terminal-init-bobcat))

  (require 'helm-config)
  (require 'helm-command)
;(require 'helm-descbinds)

  (setq helm-idle-delay             0.01
        helm-input-idle-delay       0.01
        helm-candidate-number-limit 200)


  ;; 自動補完を無効
  (custom-set-variables '(helm-ff-auto-update-initial-value nil))

  (eval-after-load "helm-migemo"
  '(defun helm-compile-source--candidates-in-buffer (source)
     (helm-aif (assoc 'candidates-in-buffer source)
         (append source
                 `((candidates
                    . ,(or (cdr it)
                           (lambda ()
                             ;; Do not use `source' because other plugins
                             ;; (such as helm-migemo) may change it
                             (helm-candidates-in-buffer (helm-get-current-source)))))
                   (volatile) (match identity)))
              source)))
  )
