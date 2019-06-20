  (use-package dumb-jump
    :bind (("M-g j" . dumb-jump-go)
           ("M-g k" . dumb-jump-back)
           ("M-g l" . dumb-jump-quick-look))
    :config (setq dumb-jump-selector 'helm)
    )

