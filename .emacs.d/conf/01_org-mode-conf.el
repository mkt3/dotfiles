;;====================================================================
;; org-mode
;;====================================================================
(use-package org
  :demand t
  :mode ("\\.org\\'" . org-mode)
  :mode ("\\.txt\\'" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c j" . org-archive-to-archive-sibling))
  :config
  (unbind-key "C-c C-a" org-mode-map)
  (setq org-directory "~/workspace/org/"
        org-default-notes-file "gtd.org"
        org-return-follows-link t   ;; return でリンクを辿る
        org-startup-folded t        ;; 見出しを畳んで表示
        org-startup-truncated t       ;; 折り返し無し
        org-tags-column -80
        org-todo-keyword-faces (quote (("TODO" :foreground "forest green" :weight bold)
                                       ("STARTED" :foreground "red" :weight bold)
                                       ("WAITING" :foreground "yellow" :weight bold)
                                       ("APPT" :foreground "orange" :weight bold)
                                       ("DONE" :foreground "blue" :weight bold)
                                       ("CANCELLED" :foreground "blue" :weight bold)
                                       ("DEFERRED" :foreground "yellow" :weight bold)))
        org-log-done t  ; DONE 状態になった時の時刻を記録
        org-use-fast-todo-selection t
        org-archive-location (concat "%s_archive_" (format-time-string "%Y" (current-time)) "::")
        )
  (defun gtd ()
    (interactive)
    (find-file (concat org-directory org-default-notes-file))
    )

  (bind-key* "C-c g" 'gtd))

(use-package org-agenda
  :straight nil
  :after org
  :bind (("C-c a" . org-agenda))
  :config
  (setq org-agenda-files (list org-directory)
        org-agenda-start-with-follow-mode t     ; agenda mode で記述元と同期して表示
        org-agenda-span 'week                   ;; day or week
        org-agenda-format-date "%Y/%m/%d (%a)" ;; YY/MM/DD (曜)
        org-agenda-start-on-weekday 0   ; agenda mode で 日曜始まり
        org-agenda-start-with-follow-mode nil
        org-agenda-skip-archived-trees t
        org-agenda-window-setup  (quote current-window)
        org-agenda-restore-windows-after-quit t
;        org-agenda-include-diary t
;        org-agenda-use-time-grid nil
        org-agenda-custom-commands
        '(
          ("d" "Daily Action List"
           (
            (agenda "" ((org-agenda-ndays 1)
                        (org-agenda-sorting-strategy
                         (quote ((agenda time-up priority-down tag-up) )))
                        (org-deadline-warning-days 0)
                   ))
            ))))
  (add-hook 'org-agenda-mode-hook 'hl-line-mode)
  (setq hl-line-face 'underline)
  (setq org-agenda-current-time-string "← now")
  (setq org-agenda-time-grid ;; Format is changed from 9.1
        '((daily today require-timed)
          (0900 01000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400)
          "-"
          "────────────────"))
  )

(use-package org-journal
  :after org
  :defer
  :init
  (add-hook 'org-journal-mode-hook
            (setq truncate-lines t))
  :config
  (unbind-key "C-c C-j" org-journal-mode-map)
  (bind-key   "C-c C-j" 'browse-url-at-point)
  (setq org-journal-dir org-directory
        org-journal-file-format "journal.org"
        org-journal-date-format "%x (%a)"
        org-journal-date-prefix "* "
        org-journal-time-format "<%Y-%m-%d %R> "
        org-journal-time-prefix "** MEMO "
        org-journal-find-file 'find-file
        )
  (defun journal ()
    (interactive)
    (find-file (concat org-directory org-journal-file-format))
    )

  (bind-key* "C-c j" 'journal)
  )

(use-package org-capture
  :straight nil
  :after org
  :bind (("C-c r" . org-capture))
  :config
  (setq journalfile (concat org-directory org-journal-file-format)
        org-capture-templates
        '(("i" "Inbox" entry (file+headline nil "Inbox")
           "** %^{Brief Description} %^g\n")
          ("j" "Journal Entry" plain (file+datetree journalfile)
           "**** WORK %T %?"
           :prepend nil
           :unnarrowed nil
           :kill-buffer t
           )
          )
        )
  )

;; (use-package org-bullets
;;   :after org
;;   :config
;;   :hook (org-mode . org-bullets-mode))

(defun ladicle/task-clocked-time ()
        "Return a string with the clocked time and effort, if any"
        (interactive)
        (let* ((clocked-time (org-clock-get-clocked-time))
               (h (truncate clocked-time 60))
               (m (mod clocked-time 60))
               (work-done-str (format "%d:%02d" h m)))
          (if org-clock-effort
              (let* ((effort-in-minutes
                  (org-duration-to-minutes org-clock-effort))
                 (effort-h (truncate effort-in-minutes 60))
                 (effort-m (truncate (mod effort-in-minutes 60)))
                 (effort-str (format "%d:%02d" effort-h effort-m)))
            (format "%s/%s" work-done-str effort-str))
            (format "%s" work-done-str))))

(use-package org-gcal
  :after org
  :if (file-directory-p my:d:password-store)
  :config
  (setq alert-log-messages t
        alert-default-style 'log
        org-gcal-down-days   90
        org-gcal-up-days    180
        org-gcal-auto-archive nil)
  (with-eval-after-load "org-gcal"
    (if (file-directory-p my:d:password-store)
        (load (concat my:d:password-store "org-gcal.gpg"))))
  )
