;;; init.el --- Emacs init -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Makoto Morinaga

;; Author: Makoto Morinaga <makoto@mkt3.dev>

;;; Commentary:
;; It's an Emacs init file.

;;; Code:

;; Temporarily disable magic file names while loading the literate config.
(let ((saved-file-name-handler-alist file-name-handler-alist))
  (unwind-protect
      (progn
        (setq file-name-handler-alist nil)
        (load (expand-file-name "config.el" user-emacs-directory)
              nil 'nomessage))
    (setq file-name-handler-alist saved-file-name-handler-alist)))
