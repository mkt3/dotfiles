;;====================================================================
;;helem
;;====================================================================
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

(let ((key-and-func
       `((,(kbd "C-r")   helm-for-files)
         (,(kbd "C-c C-a")   helm-mini)
         (,(kbd "C-^")   helm-c-apropos)
         (,(kbd "C-c C-s")   helm-resume)
         (,(kbd "M-s")   helm-occur)
         (,(kbd "M-x")   helm-M-x)
         (,(kbd "M-y")   helm-show-kill-ring)
         (,(kbd "M-z")   helm-do-grep)
         (,(kbd "C-S-h") helm-descbinds)
         (,(kbd "C-x C-f") helm-find-files)        )))
(loop for (key func) in key-and-func
      do (global-set-key key func)))


;; 自動補完を無効
(custom-set-variables '(helm-ff-auto-update-initial-value nil))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions usinog C-z

(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)

(bind-key* "\C-c\C-a" 'helm-mini)

