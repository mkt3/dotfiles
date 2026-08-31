;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Makoto Morinaga

;; Author: Makoto Morinaga <makoto@mkt3.dev>

;;; Commentary:
;; Emacs 27+ introduces early-init.el, which is run before init.el,
;; before package and UI initialization happens.

;;; Code:

;; Uncomment this to debug.
;; (setq init-file-debug t)
;; (setq messages-buffer-max-lines 100000)

;; Defer package activation until the generated literate config sets archives.
(setq package-enable-at-startup nil)

;; Load prefers the newest version of a file
(setq load-prefer-newer t)

;; Enable Emacs's built-in OSC 52 clipboard backend inside tmux.
;; tmux terminals intentionally use this separate, conservative capability
;; list instead of probing the terminal emulator outside tmux.
(setq xterm-tmux-extra-capabilities '(modifyOtherKeys setSelection))

;; Emacs 31 auto-enables this for a directly attached WezTerm, but cannot
;; identify WezTerm through tmux's terminal type.
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)

;; maximize gc-cons-threshold
(setq gc-cons-threshold most-positive-fixnum)

;; Faster to disable these here (before they've been initialized)
;; (push '(fullscreen . maximized) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
;; (setq scroll-bar-mode nil)
(blink-cursor-mode -1)
(setq use-dialog-box nil)
(setq use-file-dialog nil)
;; `fringe-mode' is only available in graphical Emacs builds.
(when (display-graphic-p)
  (fringe-mode 10))

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
