(use-package projectile
  :diminish
  :bind
  ("M-o p" . counsel-projectile-switch-project)
  :config
  (projectile-mode +1))

;; (use-package helm-projectile
;;   :diminish projectile-mode
;;   :bind ("C-c p p" . helm-projectile-switch-project)
;;   :bind ("C-c p f" . helm-projectile-find-file)
;;   :bind ("C-c p e" . helm-projectile-recentf)
;;   :bind ("C-c p s g" . helm-projectile-grep)
;;   :bind ("C-c p a" . helm-projectile)
;;   :init
;;   (use-package helm-ag)
;;   :config
;;   (projectile-global-mode t)
;;   (helm-projectile-on))
