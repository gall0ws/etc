;;; -*- mode: emacs-lisp; lexical-binding: t -*-

;;; load my libraries (ref. https://github.com/gall0ws/elisp)
(let ((lib-dir "~/lib/elisp"))
  (when (file-exists-p lib-dir)
    (mapc 'load (directory-files lib-dir t "\\.elc$"))))

;;; default frame settings
(add-to-list 'initial-frame-alist '(vertical-scroll-bars . nil))

;;; global minor modes (emacs standard, no packages)
(desktop-save-mode (if window-system t -1))
(display-battery-mode)
(indent-tabs-mode)
(menu-bar-mode (if (eq window-system 'ns) t -1))
(pixel-scroll-mode (if window-system t -1))
(savehist-mode)
(tab-bar-mode)
(tool-bar-mode -1)
(xterm-mouse-mode (if window-system -1 t))

;;; hooks
;; Note: for `add-hook' it’s recommended to use a function symbol and
;; not a lambda form. Using a symbol will ensure that the function is
;; not re-added if the function is edited, and using lambda forms may
;; also have a negative performance impact when running ‘add-hook’ and
;; ‘remove-hook’.
(defun hooks/c-mode ()
  (local-set-key (kbd "C-c I") 'c-indent-defun)
  (add-hook-local 'before-save-hook 'chomp)
  (flycheck-mode))

(defun hooks/emacs-lisp-mode ()
  (add-hook-local 'before-save-hook 'chomp)
  (local-set-key (kbd "C-c b") 'elisp-byte-compile-file))

(defun hooks/eshell-mode ()
  ;; I know there's `eshell-rebind' module, but I don't like it.
  (local-set-key (kbd "C-l")   'eshell-clear-buffer)
  (local-set-key (kbd "C-c u") 'eshell-kill-line)
  (local-set-key (kbd "C-c z") 'eshell-job-stop)
  (company-mode -1)
  (eshell-vterm-mode)
  (mapc (lambda (env)
	  (add-to-list 'eshell-variable-aliases-list env))
	(append
	 '(("TERM" (lambda() "xterm-256color") t t)
	   ("PLAN9" (lambda () (file-name-concat (getenv "HOME") "9")) t t))
	 (when (eq system-type 'darwin)
	   '(("HOMEBREW_NO_AUTO_UPDATE" t t)
	     ("HOMEBREW_REQUIRE_TAP_TRUST" t t)
	     ("HOMEBREW_NO_ENV_HINTS" t t))))))

(defun hooks/ns-system-appearance-change (appearance)
  (pcase appearance
    ('light (load-theme 'modus-operandi t))
    ('dark  (load-theme 'modus-vivendi  t))))

(declare-function eshell/pwd "em-dirs.el")

(defun hooks/eshell-directory-change ()
  (rename-buffer
   (format "*et%s*" (string-replace "/" ":" (eshell/pwd)))
   t))

(defun hooks/go-mode ()
  (local-set-key (kbd "C-c d") 'godoc)
  (local-set-key (kbd "C-c f") 'gofmt)
  (add-hook-local 'before-save-hook 'gofmt)
  (setq-local compile-command "go build "))

(defun hooks/mixed-pitch-mode ()
  (add-to-list 'mixed-pitch-fixed-pitch-faces 'widget-field))

(defun hooks/vterm-mode ()
  (company-mode -1))

;; note: hooks for external packages are defined in use-package declaration
(add-hook 'Custom-mode-hook 'mixed-pitch-mode)
(add-hook 'Info-selection-hook 'mixed-pitch-mode)
(add-hook 'c-mode-hook 'hooks/c-mode)
(add-hook 'emacs-lisp-mode-hook 'hooks/emacs-lisp-mode)
(add-hook 'help-mode-hook 'mixed-pitch-mode)
(add-hook 'ns-system-appearance-change-functions 'hooks/ns-system-appearance-change)

;;; packages
(setq use-package-always-ensure t
      package-install-upgrade-built-in t)

(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; bootstrap
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(use-package eshell
  :hook
  ((eshell-mode . hooks/eshell-mode)
   (eshell-directory-change . hooks/eshell-directory-change))
  :custom
  (eshell-banner-message (format "\n%s\n" (shell-command-to-string "fortune")))
  (eshell-directory-name "~/lib/eshell")
  (eshell-visual-commands
      '("mpv" "yt-dlp" "yt" "mtr" "topgrade" "typespeed" "watch" "vi"
	"tmux" "top" "htop" "less" "more" "links" "ncftp"))
  (eshell-prompt-function
   (lambda ()
     (string-join
      (list
       (unless (eshell-exit-success-p)
	 (format "[%d] " eshell-last-command-status))
       (format "%c %s %c"
	       (char-from-name "MATHEMATICAL LEFT ANGLE BRACKET")
	       (abbreviate-file-name (eshell/pwd))
	       (char-from-name "MATHEMATICAL RIGHT ANGLE BRACKET"))
       (if (eq (file-user-uid) 0) " # " " λ "))))))

(use-package ace-window
  :demand t
  :custom-face
  (aw-leading-char-face ((t (:inherit variable-pitch
				      :foreground "#ff5f5f"
				      :weight bold :height 400))))
  :custom
  (ace-window-posframe-mode)
  (aw-dispatch-always t)
  (aw-translate-char-function
   (lambda (c)
     (cond
      ((eq c ?s)
       ?v)		;; s split vert
      ((eq c ?S)
       ?b)		;; h split hori
      ((eq c ?w)
       ?m)		;; w swap
      ((or (eq c ?0) (eq c ?k))
       ?x)		;; 0, k delete
      ((eq c ?1)
       ?o)		;; 1 delete other
      ((eq c ?b)
       ?j)		;; b select buffer
      (t c)))))

(use-package company
  :demand t
  :config (global-company-mode))

(use-package dired-quick-sort
  :defer t
  :commands (dired)
  :init
  (setq dired-quick-sort-suppress-setup-warning t)
  (dired-quick-sort-setup))

(use-package eshell-toggle
  :bind ("C-c E" . eshell-toggle))

(use-package eshell-vterm
  :defer t
  :commands (eshell)
  :after vterm)

(use-package exec-path-from-shell
  :if (eq system-type 'darwin)
  :config
  (exec-path-from-shell-initialize))

(use-package helm
  :demand t
  :config (helm-mode)
  :custom
  (helm-use-frame-when-no-suitable-window t)
  (helm-use-frame-when-more-than-two-windows t))

(use-package fancy-urls-menu
  :defer t
  :commands (fancy-urls-menu-list-urls))

(use-package flycheck
  :defer t
  :commands (flycheck-mode))

(use-package go-mode
  :defer t
  :commands (go-mode)
  :hook (go-mode . hooks/go-mode))

(use-package gruvbox-theme
  :when (eq 'window-system 'x)
  :config (load-theme 'gruvbox-dark-hard t))

(use-package ns-auto-titlebar
  :if (eq window-system 'ns)
  :config (ns-auto-titlebar-mode))

(use-package magit
  :defer t
  :commands (magit))

(use-package mixed-pitch
  :defer t
  :commands (mixed-pitch-mode)
  :hook hooks/mixed-pitch-mode
  :custom (mixed-pitch-variable-pitch-cursor 'box))

(use-package slime
  :defer t
  :commands (slime)
  :init
  (setq inferior-lisp-program "sbcl")
  (let ((slime-helper "~/lib/quicklisp/slime-helper.el"))
    (when (file-exists-p slime-helper)
      (load (expand-file-name slime-helper))))
  :custom
  (slime-kill-without-query-p t)
  (slime-net-coding-system 'utf-8-unix))

(use-package vterm
  :defer t
  :commands (vterm eshell-vterm-mode)
  :hook (vterm-mode . hooks/vterm-mode))

;;; bindings
;; misc:
(global-set-key (kbd "C-h") 'backward-delete-char-untabify)
(global-set-key (kbd "s-x") 'execute-extended-command)
(global-set-key (kbd "s-?") 'describe-prefix-bindings)

;; basics: C-c
(global-set-key (kbd "C-c b") 'compile)
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c C") 'chomp)
(global-set-key (kbd "C-c i") 'indent-region)
(global-set-key (kbd "C-c l") 'goto-line)
(global-set-key (kbd "C-c N") 'display-line-numbers-mode)
(global-set-key (kbd "C-c m") 'move-to-char)
(global-set-key (kbd "C-c M") 'man)
(global-set-key (kbd "C-c o") 'ace-window)
(global-set-key (kbd "C-c R") 'reread-buffer)
(global-set-key (kbd "C-c S") 'eshell)
(global-set-key (kbd "C-c T") 'vterm)
(global-set-key (kbd "C-c U") 'fancy-urls-menu-list-urls)
(global-set-key (kbd "C-c <") 'exec<)
(global-set-key (kbd "C-c >") 'exec>)
(global-set-key (kbd "C-c |") 'exec|)
(global-set-key (kbd "C-c !") 'exec!)
(global-set-key (kbd "C-c ?") 'describe-prefix-bindings)

;; eval: C-c e
(global-set-key (kbd "C-c e b") 'eval-buffer)
(global-set-key (kbd "C-c e e") 'eval-last-sexp)
(global-set-key (kbd "C-c e f") 'eval-defun)
(global-set-key (kbd "C-c e p") 'eval-print-last-sexp)
(global-set-key (kbd "C-c e r") 'eval-region)
(global-set-key (kbd "C-c e x") 'eval-expression)
(global-set-key (kbd "C-c e ?") 'describe-prefix-bindings)

;; fill: C-c f
(global-set-key (kbd "C-c f i") 'fill-individual-paragraphs)
(global-set-key (kbd "C-c f n") 'fill-nonuniform-paragraphs)
(global-set-key (kbd "C-c f p") 'fill-paragraph)
(global-set-key (kbd "C-c f r") 'fill-region)
(global-set-key (kbd "C-c f R") 'fill-region-as-paragraph)
(global-set-key (kbd "C-c f ?") 'describe-prefix-bindings)

;; help/doc: C-c h (mostly replaces native C-h prefix)
(global-set-key (kbd "C-c h a") 'apropos)
(global-set-key (kbd "C-c h b") 'describe-bindings)
(global-set-key (kbd "C-c h c") 'describe-key-briefly)
(global-set-key (kbd "C-c h d") 'apropos-documentation)
(global-set-key (kbd "C-c h e") 'view-echo-area-messages)
(global-set-key (kbd "C-c h f") 'describe-function)
(global-set-key (kbd "C-c h F") 'describe-face)
(global-set-key (kbd "C-c h h") 'view-hello-file)
(global-set-key (kbd "C-c h i") 'info)
(global-set-key (kbd "C-c h I") 'info-display-manual)
(global-set-key (kbd "C-c h k") 'describe-key)
(global-set-key (kbd "C-c h l") 'view-lossage)
(global-set-key (kbd "C-c h m") 'describe-mode)
(global-set-key (kbd "C-c h o") 'describe-symbol)
(global-set-key (kbd "C-c h p") 'finder-by-keyword)
(global-set-key (kbd "C-c h P") 'describe-package)
(global-set-key (kbd "C-c h r") 'info-emacs-manual)
(global-set-key (kbd "C-c h s") 'describe-syntax)
(global-set-key (kbd "C-c h v") 'describe-variable)
(global-set-key (kbd "C-c h w") 'where-is)
(global-set-key (kbd "C-c h x") 'describe-command)
(global-set-key (kbd "C-c h ?") 'describe-prefix-bindings)

;; sort: C-c s
(global-set-key (kbd "C-c s c") 'sort-columns)
(global-set-key (kbd "C-c s f") 'sort-fields)
(global-set-key (kbd "C-c s l") 'sort-lines)
(global-set-key (kbd "C-c s n") 'sort-numeric-fields)
(global-set-key (kbd "C-c s p") 'sort-paragraphs)
(global-set-key (kbd "C-c s ?") 'describe-prefix-bindings)

;; tab-bar: C-x t
(global-set-key (kbd "C-x t b") 'tab-bar-switch-to-tab)
(global-set-key (kbd "C-x t k") 'tab-bar-close-tab)
(global-set-key (kbd "C-x t K") 'tab-bar-close-tab-by-name)
(global-set-key (kbd "C-x t m") 'tab-bar-move-tab)
(global-set-key (kbd "C-x t M") 'tab-bar-move-tab-backward)
(global-set-key (kbd "C-x t n") 'tab-bar-switch-to-next-tab)
(global-set-key (kbd "C-x t p") 'tab-bar-switch-to-prev-tab)
(global-set-key (kbd "C-x t r") 'tab-bar-rename-tab)
(global-set-key (kbd "C-x t R") 'tab-bar-rename-tab-by-name)
(global-set-key (kbd "C-x t t") 'tab-bar-new-tab)
(global-set-key (kbd "C-x t T") 'tab-bar-undo-close-tab)
(global-set-key (kbd "C-x t ?") 'describe-prefix-bindings)

;;; misc
(setq ns-pop-up-frames nil
      ns-right-alternate-modifier 'none)
(windmove-default-keybindings 'shift)
(put 'add-hook 'lisp-indent-function 1)
(put 'interactive 'lisp-indent-function 1)

;;; custom zone
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(auth-source-save-behavior nil)
 '(blink-cursor-mode nil)
 '(c-basic-offset 'set-from-style)
 '(c-default-style
   '((c-mode . "linux") (c++-mode . "stroustrup")
     (objc-mode . "stroustrup") (java-mode . "java")
     (awk-mode . "awk") (other . "linux")))
 '(c-echo-syntactic-information-p t)
 '(c-label-minimum-indentation 'set-from-style)
 '(c-report-syntactic-errors t)
 '(c-syntactic-indentation t)
 '(c-tab-always-indent t)
 '(calendar-week-start-day 1)
 '(case-replace t)
 '(column-number-mode t)
 '(compilation-message-face 'underline)
 '(compile-auto-highlight t)
 '(compile-command "make -s ")
 '(custom-safe-themes
   '("d5fd482fcb0fe42e849caba275a01d4925e422963d1cd165565b31d3f4189c87"
     "5aedf993c7220cbbe66a410334239521d8ba91e1815f6ebde59cecc2355d7757"
     "18a1d83b4e16993189749494d75e6adb0e15452c80c431aca4a867bcc8890ca9"
     "d8011e6c2919f4edfbc233664d9e404e2a2b89483bc8b75011b379c41a82efdf"
     "deb645f30fd25191b6e8d0f397cc1dd172a352f22094747be2ff527394cc9f57"
     "51fa6edfd6c8a4defc2681e4c438caf24908854c12ea12a1fbfd4d055a9647a3"
     "8363207a952efb78e917230f5a4d3326b2916c63237c1f61d7e5fe07def8d378"
     "147093cd93a68c202caa79635399cc5f6a8cd028bb1ca037a4d4a095b28cb167"
     "72ed8b6bffe0bfa8d097810649fd57d2b598deef47c992920aef8b5d9599eefe"
     "5a0ddbd75929d24f5ef34944d78789c6c3421aa943c15218bac791c199fc897d"
     "6b5c518d1c250a8ce17463b7e435e9e20faa84f3f7defba8b579d4f5925f60c1"
     "d14f3df28603e9517eb8fb7518b662d653b25b26e83bd8e129acea042b774298"
     "7661b762556018a44a29477b84757994d8386d6edee909409fabe0631952dad9"
     "4cf9ed30ea575fb0ca3cff6ef34b1b87192965245776afa9e9e20c17d115f3fb"
     "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a"
     "387b487737860e18cbb92d83a42616a67c1edfd0664d521940e7fbf049c315ae"
     "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693"
     "aded61687237d1dff6325edb492bde536f40b048eab7246c61d5c6643c696b7f"
     "b89ae2d35d2e18e4286c8be8aaecb41022c1a306070f64a66fd114310ade88aa"
     default))
 '(default-truncate-lines nil t)
 '(dired-kill-when-opening-new-dired-buffer t)
 '(display-hourglass t)
 '(display-time-24hr-format t)
 '(display-time-default-load-average nil)
 '(electric-indent-mode nil)
 '(explicit-shell-file-name nil)
 '(face-font-family-alternatives nil)
 '(focus-follows-mouse t)
 '(hourglass-delay 0)
 '(inhibit-startup-screen t)
 '(insert-directory-program (if (eq system-type 'gnu/linux) "ls" "gls"))
 '(js-indent-level 4)
 '(line-spacing 2)
 '(mouse-autoselect-window t)
 '(mouse-drag-and-drop-region 'meta)
 '(next-line-add-newlines nil)
 '(objc-font-lock-extra-types nil)
 '(query-replace-highlight t)
 '(require-final-newline t)
 '(tab-bar-new-tab-choice 'scratch-buffer)
 '(tab-bar-new-tab-to 'rightmost)
 '(tab-bar-select-tab-modifiers '(super))
 '(tab-bar-tab-hints t)
 '(term-suppress-hard-newline t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 140 :family "Iosevka SS08"))))
 '(battery-load-critical ((t (:inherit error :inverse-video t))))
 '(font-lock-comment-face ((t (:foreground "#989898" :slant italic :family "Iosevka"))))
 '(font-lock-doc-face ((t (:foreground "#9ac8e0" :slant italic :family "Iosevka"))))
 '(ns-working-text-face ((t (:background "gold2" :foreground "black"))))
 '(variable-pitch ((t (:height 140 :width condensed :family "SF Pro")))))
