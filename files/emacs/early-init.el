;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Makoto Morinaga

;; Author: Makoto Morinaga <makoto@mkt3.me>

;;; Commentary:
;; Emacs 27+ introduces early-init.el, which is run before init.el,
;; before package and UI initialization happens.

;;; Code:

;; Uncomment this to debug.
;; (setq init-file-debug t)
;; (setq messages-buffer-max-lines 100000)

;; Defer garbage collection further back in the startup process.
;; `gcmh' will clean things up later.
(setq gc-cons-threshold most-positive-fixnum)

;; Disable `package' in favor of `use-package'.
(setq package-enable-at-startup nil)

;; Load prefers the newest version of a file
(setq load-prefer-newer t)

;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)

;; Faster to disable these here (before they've been initialized)
(push '(fullscreen . maximized) default-frame-alist)
(push '(menu-bar-lines . nil) default-frame-alist)
(push '(tool-bar-lines . nil) default-frame-alist)
(push '(blink-cursor-mode. nil) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
;; (setq scroll-bar-mode nil)
(setq use-dialog-box nil)
(setq use-file-dialog nil)
(setq fringe-mode 10)

;; Silence native compiler warnings
(setq native-comp-async-report-warnings-errors 'silent)

;; Frame title
(setq-default frame-title-format '("emacs " emacs-version (buffer-file-name " - %f")))
;; Avoids the white screen flash on startup.

;(custom-set-faces '(default ((t (:background "#2E3440")))))

;; Hide the startup screen
(setq inhibit-startup-screen t)

;; Follows the link and visits the real file instead
(setq vc-follow-symlinks t)

(provide 'early-init)
;;; early-init.el ends here
