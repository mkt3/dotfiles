(use-package mwim
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

;; (use-package sequential-command-config
;;   :straight sequential-command
;;   :bind  (("C-a" . seq-home)
;;           ("C-e" . seq-end)
;;           :map org-mode-map
;;           ("C-a" . org-seq-home)
;;           ("C-e" . org-seq-end)
;;           :map esc-map
;;           ("u" . seq-upcase-backward-word)
;;           ("c" . seq-capitalize-backward-word)
;;           ("l" . seq-downcase-backward-word)
;;           )
;;   :config
;;   (sequential-command-setup-keys))

