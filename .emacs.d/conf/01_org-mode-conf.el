;;====================================================================
;; org-mode
;;====================================================================
(add-to-list 'auto-mode-alist '("\\.\\(org\\|txt\\)$" . org-mode))

(bind-key* "\C-cl" 'org-store-link)
(bind-key* "\C-ca" 'org-agenda)

(setq org-directory "~/workspace/schedule/")
(setq org-default-notes-file  "gtd.org")
(setq org-agenda-files (list org-directory))

; agenda mode で記述元と同期して表示
(setq org-agenda-start-with-follow-mode t)
; agenda mode で 日曜始まり
(setq org-agenda-start-on-weekday 0)

(setq org-tags-column -80)

;; 折り返し有効
(setq org-startup-truncated nil)

;(setq org-todo-keywords '("TODO" "APPT" "STARTED" "DONE")
;      org-todo-interpretation 'sequence)

(setq org-todo-keyword-faces (quote (("TODO" :foreground "forest green" :weight bold)
                                     ("STARTED" :foreground "red" :weight bold)
                                     ("WAITING" :foreground "yellow" :weight bold)
                                     ("APPT" :foreground "orange" :weight bold)
                                     ("DONE" :foreground "blue" :weight bold)
                                     ("CANCELLED" :foreground "blue" :weight bold)
                                     ("DEFERRED" :foreground "yellow" :weight bold))))

; DONE 状態になった時の時刻を記録
(setq org-log-done t)

(setq org-use-fast-todo-selection t)

(setq org-agenda-start-with-follow-mode nil)


;(setq org-agenda-skip-archived-trees nil)
(setq org-agenda-skip-archived-trees t)


;(setq org-agenda-window-setup (quote other-window))
(setq org-agenda-window-setup  (quote current-window))
(setq org-agenda-restore-windows-after-quit t)

(setq org-agenda-include-diary t)
(setq org-agenda-use-time-grid nil)

;(setq org-archive-location "gtd_archive.org::* Archived Tasks")
(setq org-archive-location (concat "%s_archive_" (format-time-string "%Y" (current-time)) "::"))

(add-hook 'org-mode-hook
          '(lambda()
             (define-key org-mode-map [?\C-,] nil)
             (define-key org-mode-map "\C-cj" 'org-archive-to-archive-sibling)))
;             (define-key org-mode-map "\C-c\C-t" 'org-todo-archive)))

(add-hook 'org-agenda-mode-hook
           '(lambda()
              (define-key org-mode-map [?\C-,] nil)))
;;              (define-key org-agenda-mode-map "\C-c\C-g" 'org-archive-all-done-item)
;;              (define-key org-agenda-mode-map "\C-c\C-t" 'org-agenda-todo-archive)
;;              (define-key org-agenda-mode-map "t" 'org-agenda-todo-archive)))

(add-hook 'org-agenda-mode-hook 'hl-line-mode)
(setq hl-line-face 'underline)

(defun gtd ()
    (interactive)
    (find-file "~/workspace/schedule/gtd.org")
)

(bind-key* "\C-cg" 'gtd)

(bind-key "\C-cj" 'org-archive-to-archive-sibling)


(setq org-agenda-custom-commands
'(
  ("d" "Daily Action List"
   (
    (agenda "" ((org-agenda-ndays 1)
		(org-agenda-sorting-strategy
		 (quote ((agenda time-up priority-down tag-up) )))
		(org-deadline-warning-days 0)
		))
    ))))


;; Org-captureをC-c rで呼び出す。
(bind-key* "\C-cr" 'org-capture)

;; Org-caputure
(when (require 'org-capture nil t)

  (setq org-capture-templates
        '(("i" "Inbox" entry (file+headline nil "Inbox")
           "** %^{Brief Description} %^g\n")
          ))
  )
