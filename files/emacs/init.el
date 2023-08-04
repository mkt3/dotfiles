;;; init.el --- Emacs init -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Makoto Morinaga

;; Author: Makoto Morinaga <makoto@mkt3.dev>

;;; Commentary:
;; It's an Emacs init file.

;;; Code:

;; Disable Magic File Name
(defconst tmp-saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(require 'org)
(org-babel-load-file
 (expand-file-name "README.org" user-emacs-directory))

;; Enable Magic File Name
(setq file-name-handler-alist tmp-saved-file-name-handler-alist)
