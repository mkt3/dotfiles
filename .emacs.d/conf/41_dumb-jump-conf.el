  (use-package dumb-jump
    :bind (("C-c g" . dumb-jump-go)
           ("C-c p" . dumb-jump-back)
           ("C-c q" . dumb-jump-quick-look))
    :config (setq dumb-jump-selector 'helm)
    )

