;;; -*- mode: emacs-lisp; lexical-binding: t -*-

;;; load my libraries (ref. https://github.com/gall0ws/elisp)
(let ((lib-dir "~/lib/elisp"))
  (when (file-exists-p lib-dir)
    (add-to-list 'load-path (expand-file-name lib-dir))
    (require 'xtra)
    (require 'exec)
    (require 'em-gall0ws)))

;;; default frame settings
(add-to-list 'initial-frame-alist '(vertical-scroll-bars . nil))

;;; global minor modes (emacs standard, no packages)
(when (fboundp 'context-menu-mode) (context-menu-mode))
(desktop-save-mode (if window-system t -1))
(display-battery-mode)
(when (fboundp 'indent-tabs-mode) (indent-tabs-mode))
(menu-bar-mode (if (eq window-system 'ns) t -1))
(pixel-scroll-mode (if window-system t -1))
(savehist-mode)
(when (fboundp 'tab-bar-mode) (tab-bar-mode))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
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
  (indent-tabs-mode -1)
  (add-hook-local 'before-save-hook 'chomp)
  (local-set-key (kbd "C-c c") 'elisp-byte-compile-file)
  (local-set-key (kbd "s-c") 'elisp-byte-compile-file))

(defun hooks/eshell-mode ()
  (company-mode -1)
  (mapc (lambda (env)
          (add-to-list 'eshell-variable-aliases-list env))
        (append
         '(("TERM" (lambda() "xterm-256color") t t)
           ("PLAN9" (lambda () (file-name-concat (getenv "HOME") "9")) t t))
         (when (eq system-type 'darwin)
           '(("HOMEBREW_NO_AUTO_UPDATE" t t)
             ("HOMEBREW_REQUIRE_TAP_TRUST" t t)
             ("HOMEBREW_NO_ENV_HINTS" t t))))))

(declare-function eshell/pwd "em-dirs.el" ())

(defun hooks/eshell-directory-change ()
  (rename-buffer
   (format "*et%s*" (string-replace "/" ":" (eshell/pwd)))
   t))

(defun hooks/ns-system-appearance-change (appearance)
  (load-theme
   (if (eq appearance 'light)
       'spacemacs-light
     'spacemacs-dark) t))

(defun hooks/go-mode ()
  (local-set-key (kbd "C-c d") 'godoc)
  (local-set-key (kbd "C-c f") 'gofmt)
  (add-hook-local 'before-save-hook 'gofmt)
  (setq-local compile-command "go build "))

(defun hooks/mixed-pitch-mode ()
  (add-to-list 'mixed-pitch-fixed-pitch-faces 'widget-field))

(defun hooks/org-mode ()
  (local-set-key (kbd "s-<return>") 'org-open-at-point))

(defun hooks/vterm-mode ()
  (local-set-key (kbd "C-c c") 'vterm-copy-mode)
  (local-set-key (kbd "s-c") 'vterm-copy-mode)
  (company-mode -1))

;; note: hooks for external packages are defined in use-package declaration
(add-hook 'Custom-mode-hook 'mixed-pitch-mode)
(add-hook 'Info-selection-hook 'mixed-pitch-mode)
(add-hook 'c-mode-hook 'hooks/c-mode)
(add-hook 'emacs-lisp-mode-hook 'hooks/emacs-lisp-mode)
(add-hook 'help-mode-hook 'mixed-pitch-mode)
(add-hook 'markdown-mode-hook 'visual-line-mode)
(add-hook 'ns-system-appearance-change-functions 'hooks/ns-system-appearance-change)
(add-hook 'org-mode-hook 'hooks/org-mode)

;;; packages
(setq package-install-upgrade-built-in t)
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
   (eshell-mode . hooks/eshell-directory-change)
   (eshell-directory-change . hooks/eshell-directory-change))
  :custom
  (eshell-directory-name "~/lib/eshell")
  (eshell-visual-commands
      '("mdv" "mpv" "yt-dlp" "yt" "mtr" "topgrade" "typespeed" "watch" "wget"
        "vi" "tmux" "top" "htop" "less" "more" "links" "ncftp"))
  (eshell-modules-list
   '(eshell-alias eshell-basic eshell-cmpl eshell-dirs eshell-extpipe
                  eshell-glob eshell-hist eshell-ls eshell-pred
                  eshell-prompt eshell-script eshell-term
                  eshell-unix eshell-xtra eshell-gall0ws))
  (eshell-review-quick-commands 'not-even-short-output)
  (eshell-vterm-mode t)
  (eshell-prompt-function
   (lambda ()
     (concat
      (unless (eshell-exit-success-p)
        (format "[%d] " eshell-last-command-status))
      (format "%c %s %c %c "
              (char-from-name "MATHEMATICAL LEFT ANGLE BRACKET")
              (file-name-nondirectory (abbreviate-file-name (eshell/pwd)))
              (char-from-name "MATHEMATICAL RIGHT ANGLE BRACKET")
              (char-from-name "GREEK SMALL LETTER LAMBDA"))))))

(use-package ace-window
  :ensure
  :demand t
  :config (when window-system (ace-window-posframe-mode))
  :custom-face
  (aw-leading-char-face ((t (:inherit variable-pitch
                                      :foreground "#ff5f5f"
                                      :weight bold :height 400))))
  :custom
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
      ((eq c ?b)
       ?j)		;; b select buffer
      (t c)))))

(use-package company
  :ensure
  :demand t
  :config (global-company-mode))

(use-package dired-quick-sort
  :defer t
  :commands (dired)
  :init
  (setq dired-quick-sort-suppress-setup-warning t)
  (dired-quick-sort-setup))

(use-package eshell-toggle
  :bind
  ("C-c E" . eshell-toggle)
  ("s-E" . eshell-toggle))

(use-package eshell-vterm
  :ensure
  :defer t
  :commands (eshell)
  :after vterm)

(when (eq system-type 'darwin)
  (use-package exec-path-from-shell
    :ensure
    :config
    (exec-path-from-shell-initialize)))

(use-package helm
  :ensure
  :demand t
  :config (helm-mode)
  :custom
  (helm-autoresize-mode t)
  (helm-display-buffer-width 140)
  (helm-use-frame-when-no-suitable-window t)
  (helm-use-frame-when-more-than-two-windows t))

(use-package flycheck
  :ensure
  :defer t
  :commands (flycheck-mode))

(use-package go-mode
  :defer t
  :commands (go-mode)
  :hook (go-mode . hooks/go-mode))

(when (eq window-system 'x)
  (use-package gruvbox-theme
    :ensure
    :config (load-theme 'gruvbox-dark-hard t)))

(when (eq window-system 'ns)
  (use-package ns-auto-titlebar
    :ensure
    :config (ns-auto-titlebar-mode)))

(use-package magit
  :defer t
  :commands (magit))

(use-package mixed-pitch
  :ensure
  :defer t
  :commands (mixed-pitch-mode)
  :hook hooks/mixed-pitch-mode
  :custom (mixed-pitch-variable-pitch-cursor 'box))

(use-package scratch
  :ensure
  :demand t)

(use-package simple-modeline
  :ensure
  :demand t
  :config (simple-modeline-mode)
  :custom
  (simple-modeline-segments
   '((simple-modeline-segment-modified
      simple-modeline-segment-buffer-name
      simple-modeline-segment-position
      project-mode-line-format
      simple-modeline-segment-vc)
     (simple-modeline-segment-process
      simple-modeline-segment-major-mode
      ;simple-modeline-segment-minor-modes
      simple-modeline-segment-input-method
      simple-modeline-segment-eol
      simple-modeline-segment-encoding
      simple-modeline-segment-misc-info
      (lambda()" ")))))

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

(use-package typescript-mode
  :defer t
  :mode (("\\.tsx$" . typescript-mode))
  :config
  (indent-tabs-mode -1))

(use-package vterm
  :ensure
  :defer t
  :commands (vterm eshell-vterm-mode)
  :hook (vterm-mode . hooks/vterm-mode))

;;; bindings
;; remapped standard keys:
(global-set-key (kbd "C-x C-b") 'ibuffer-list-buffers)
(global-set-key (kbd "C-h") 'backward-delete-char-untabify)

;; basics: C-c
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c C") 'comment-region)
(global-set-key (kbd "C-c i") 'indent-region)
(global-set-key (kbd "C-c l") 'goto-line)
(global-set-key (kbd "C-c n") 'scratch)
(global-set-key (kbd "C-c N") 'display-line-numbers-mode)
(global-set-key (kbd "C-c m") 'move-to-char)
(global-set-key (kbd "C-c M") 'man)
(global-set-key (kbd "C-c o") 'ace-window)
(global-set-key (kbd "C-c R") 'reread-buffer)
(global-set-key (kbd "C-c S") 'eshell)
(global-set-key (kbd "C-c T") 'vterm)
(global-set-key (kbd "C-c *") 'scratch-buffer)
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

;; help/doc: C-c h (replaces native C-h prefix)
(global-set-key (kbd "C-c h") help-map)

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

;; macOS-friendly basics: s-
(global-set-key (kbd "s-a") 'mark-whole-buffer)
(global-set-key (kbd "s-b") 'switch-to-buffer)
(global-set-key (kbd "s-B j") 'bookmark-jump)
(global-set-key (kbd "s-B J") 'bookmark-jump-other-window)
(global-set-key (kbd "s-B l") 'bookmark-bmenu-list)
(global-set-key (kbd "s-B s") 'bookmark-set)
(global-set-key (kbd "s-B S") 'bookmark-set-no-overwrite)
(global-set-key (kbd "s-c") 'compile)
(global-set-key (kbd "s-C") 'comment-region)
(global-set-key (kbd "s-d") 'dired)
(global-set-key (kbd "s-D") 'dired-other-window)
(global-set-key (kbd "s-e") 'eshell)
(global-set-key (kbd "s-f") 'isearch-forward)
(global-set-key (kbd "s-F") 'isearch-backward)
(global-set-key (kbd "s-C-f") 'isearch-forward-regexp)
(global-set-key (kbd "s-C-S-f") 'isearch-backward-regexp)
(global-set-key (kbd "s-g") 'magit)
(global-set-key (kbd "s-h") help-map)
(global-set-key (kbd "s-h ?") 'describe-prefix-bindings)
(global-set-key (kbd "s-H") 'info-emacs-manual)
(global-set-key (kbd "s-i") 'indent-region)
(global-set-key (kbd "s-I") 'info)
(global-set-key (kbd "s-k") 'kill-current-buffer)
(global-set-key (kbd "s-l") 'goto-line)
(global-set-key (kbd "s-m") 'move-to-char)
(global-set-key (kbd "s-M") 'man)
(global-set-key (kbd "s-C-m") 'mixed-pitch-mode)
(global-set-key (kbd "s-n") 'scratch)
(global-set-key (kbd "s-N") 'display-line-numbers-mode)
(global-set-key (kbd "s-o") 'find-file)
(global-set-key (kbd "s-O") 'find-alternate-file)
(global-set-key (kbd "s-C-o") 'find-file-read-only)
(global-set-key (kbd "s-q") 'save-buffers-kill-terminal)
(global-set-key (kbd "s-Q") 'save-buffers-kill-emacs)
(global-set-key (kbd "s-r") 'replace-string)
(global-set-key (kbd "s-R") 'query-replace)
(global-set-key (kbd "s-C-r") 'replace-regexp)
(global-set-key (kbd "s-C-S-r") 'query-replace-regexp)
(global-set-key (kbd "s-s") 'split-window-below)
(global-set-key (kbd "s-S") 'split-window-right)
(global-set-key (kbd "s-t") 'tab-bar-new-tab)
(global-set-key (kbd "s-T") 'tab-bar-undo-close-tab)
(global-set-key (kbd "s-u") 'vterm) ; u for unix
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-W") 'delete-frame)
(global-set-key (kbd "s-C-w") 'tab-bar-close-tab)
(global-set-key (kbd "s-x") 'execute-extended-command) ; sorry cut
(global-set-key (kbd "s-y") 'ace-window) ; dunno y
(global-set-key (kbd "s-Y") 'ace-swap-window)
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "s-Z") 'undo-redo)
(global-set-key (kbd "s-*") 'scratch-buffer)
(global-set-key (kbd "s-=") 'balance-windows)
(global-set-key (kbd "s-^") 'enlarge-window)
(global-set-key (kbd "s-]") 'enlarge-window)
(global-set-key (kbd "s-[") 'shrink-window)
(global-set-key (kbd "s-}") 'enlarge-window-horizontally)
(global-set-key (kbd "s-{") 'shrink-window-horizontally)
(global-set-key (kbd "s-C-0") 'text-scale-adjust) ; s-0 is `tab-recent'
(global-set-key (kbd "s--") 'text-scale-adjust)
(global-set-key (kbd "s-+") 'text-scale-adjust)
(global-set-key (kbd "s-,") 'customize-group)
(global-set-key (kbd "s-`") 'next-window-any-frame)
(global-set-key (kbd "s-~") 'previous-window-any-frame)
(global-set-key (kbd "s-:") 'eval-expression)
(global-set-key (kbd "s-|") 'exec|)
(global-set-key (kbd "s-!") 'exec!)
(global-set-key (kbd "s-<") 'exec<)
(global-set-key (kbd "s->") 'exec>)
(global-set-key (kbd "s-<mouse-1>") 'browse-url-at-mouse)
(global-set-key (kbd "s-?") 'describe-prefix-bindings)

;; macOS-friendly project: s-p
(unbind-key (kbd "s-p"))
(global-set-key (kbd "s-p C-b") 'project-list-buffers)
(global-set-key (kbd "s-p b") 'project-switch-to-buffer)
(global-set-key (kbd "s-p c") 'project-compile)
(global-set-key (kbd "s-p d") 'project-find-dir)
(global-set-key (kbd "s-p D") 'project-dired)
(global-set-key (kbd "s-p e") 'project-eshell)
(global-set-key (kbd "s-p f") 'project-find-file)
(global-set-key (kbd "s-p F") 'project-or-external-find-file)
(global-set-key (kbd "s-p g") 'project-find-regexp)
(global-set-key (kbd "s-p G") 'project-or-external-find-regexp)
(global-set-key (kbd "s-p k") 'project-kill-buffers)
(global-set-key (kbd "s-p o") 'project-any-command)
(global-set-key (kbd "s-p p") 'project-switch-project)
(global-set-key (kbd "s-p r") 'project-query-replace-regexp)
(global-set-key (kbd "s-p s") 'project-shell)
(global-set-key (kbd "s-p v") 'project-vc-dir)
(global-set-key (kbd "s-p x") 'project-execute-extended-command)
(global-set-key (kbd "s-p !") 'project-shell-command)
(global-set-key (kbd "s-p &") 'project-async-shell-command)
(global-set-key (kbd "s-p ?") 'describe-prefix-bindings)

;; macOS-friendly special chars (C-x 8 + some addition)
(global-set-key (kbd "s-@") iso-transl-ctl-x-8-map)
(define-key iso-transl-ctl-x-8-map (kbd "l")
            (char-to-string (char-from-name "GREEK SMALL LETTER LAMBDA")))
(define-key iso-transl-ctl-x-8-map (kbd "e")
            (char-to-string (char-from-name "LATIN SMALL LETTER SCHWA")))
(define-key iso-transl-ctl-x-8-map (kbd "soc")
            (char-to-string (char-from-name "HAMMER AND SICKLE")))
(global-set-key (kbd "s-@ ?") 'describe-prefix-bindings)

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
 '(battery-mode-line-format
   (format "[%%b%%p%c]" (char-from-name "FULLWIDTH PERCENT SIGN")))
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
 '(compile-command "make -k ")
 '(default-truncate-lines nil t)
 '(dired-kill-when-opening-new-dired-buffer t)
 '(display-hourglass t)
 '(display-time-day-and-date t)
 '(display-time-mode t)
 '(display-time-string-forms '((format-time-string " %H:%M " now)))
 '(electric-indent-mode nil)
 '(eww-auto-rename-buffer 'title)
 '(eww-form-checkbox-selected-symbol "☑")
 '(eww-form-checkbox-symbol "☐")
 '(explicit-shell-file-name nil)
 '(face-font-family-alternatives nil)
 '(focus-follows-mouse t)
 '(gnus-init-file "~/lib/gnus.el")
 '(gnus-summary-line-format "%U%R%z [%d] %I%(%[%4L: %-23,23f%]%) %s\12")
 '(gnus-thread-sort-functions '(gnus-thread-sort-by-most-recent-date))
 '(hourglass-delay 0)
 '(inhibit-startup-screen t)
 '(insert-directory-program (if (eq system-type 'gnu/linux) "ls" "gls"))
 '(js-indent-level 4)
 '(line-spacing 2)
 '(mouse-autoselect-window t)
 '(mouse-drag-and-drop-region 'meta)
 '(next-line-add-newlines nil)
 '(objc-font-lock-extra-types nil)
 '(package-selected-packages
   '(ace-window company dired-quick-sort eshell-toggle eshell-vterm
                exec-path-from-shell flycheck forge go-mode helm
                lua-mode mixed-pitch ns-auto-titlebar scratch
                simple-modeline slime spacemacs-theme swift-mode
                typescript-mode))
 '(project-mode-line t)
 '(project-switch-commands
   '((project-find-file "Find file" nil)
     (project-find-regexp "Find regexp" nil)
     (project-find-dir "Find directory" nil)
     (project-vc-dir "VC-Dir" nil) (project-eshell "Eshell" nil)
     (project-any-command "Other" nil)
     (magit-project-status "Magit" nil)))
 '(query-replace-highlight t)
 '(require-final-newline t)
 '(send-mail-function 'smtpmail-send-it)
 '(tab-bar-new-tab-choice 'scratch-buffer)
 '(tab-bar-new-tab-to 'rightmost)
 '(tab-bar-select-tab-modifiers '(super))
 '(tab-bar-tab-name-format-functions
   '((lambda (name _ idx)
       (format "%c%d %s"
	       (if (< idx 9) (char-from-name "PLACE OF INTEREST SIGN")
		 32)
	       idx name))
     tab-bar-tab-name-format-close-button tab-bar-tab-name-format-face))
 '(term-suppress-hard-newline t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 140 :family "Iosevka SS08"))))
 '(battery-load-critical ((t (:inherit error :inverse-video t))))
 '(font-lock-comment-face ((t (:slant italic :family "Iosevka"))))
 '(font-lock-doc-face ((t (:slant italic :family "Iosevka"))))
 '(gnus-group-mail-1-empty ((t (:height 1.3))))
 '(gnus-group-mail-2-empty ((t (:height 1.3))))
 '(gnus-group-mail-3-empty ((t (:height 1.3))))
 '(ns-working-text-face ((t (:background "gold2" :foreground "black"))))
 '(shr-text ((t (:inherit variable-pitch-text :height 1.2))))
 '(variable-pitch ((t (:height 140 :width condensed :family "SF Pro")))))
