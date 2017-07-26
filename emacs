;; hey emacs, this is your -*- lisp -*- configuration file!

;; global keys:
(global-set-key [f1] 'man)
(global-set-key "\M-g" 'goto-line)
(global-set-key [f5] 'compile)

;; backups:
(setq make-backup-files t
      backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs-backup"))
      version-control t
      kept-new-versions 2
      kept-old-versions 5
      delete-old-versions t)

;; additional modes:
(setq additional-modes
      (list ;; (path . load-function) ...
       (cons "/home/gall0ws/src/emacs/go-mode" (lambda() (require 'go-mode-autoloads)))
       (cons "/home/gall0ws/src/emacs/acme-mouse" (lambda()
						    (require 'acme-mouse)
						    (define-global-minor-mode acme-global-mouse-mode
						      acme-mouse-mode
						      (lambda() (acme-mouse-mode t)))
						    (acme-global-mouse-mode)))))
(mapcar (lambda (mode)
	  (push (car mode) load-path)
	  (funcall (cdr mode)))
	additional-modes)

;; hooks:
(add-hook 'js-mode-hook
	  (lambda ()
	    (defun js-indent-level (lvl)
	      (interactive "nlevel: ")
	      (setq js-indent-level lvl))))

;; I don't like widgets:
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(background-color "#232323")
 '(c-basic-offset (quote set-from-style))
 '(c-default-style
   (quote
    ((c-mode . "linux")
     (c++-mode . "stroustrup")
     (objc-mode . "stroustrup")
     (java-mode . "java")
     (awk-mode . "awk")
     (other . "linux"))))
 '(c-echo-syntactic-information-p t)
 '(c-label-minimum-indentation (quote set-from-style))
 '(c-report-syntactic-errors t)
 '(c-syntactic-indentation t)
 '(c-tab-always-indent t)
 '(calendar-week-start-day 1)
 '(case-replace t)
 '(compilation-message-face (quote underline))
 '(compile-auto-highlight t)
 '(compile-command "make -s ")
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes
   (quote
    ("d433e7e0041ea8a97e7969c1200220326e03e20dfe5e6df2ac5f5551effd3872" "f9bb1f40f802671ef880c2c18381cd5a43781a0358912bd576d24a100e2dd1f5" default)))
 '(default-truncate-lines nil t)
 '(display-hourglass nil)
 '(display-time-24hr-format t)
 '(display-time-default-load-average nil)
 '(eshell-prompt-function
   (lambda nil nil
     (if
	 (=
	  (user-uid)
	  0)
	 "# "
       #("% " 0 2
	 (rear-nonsticky
	  (face read-only)
	  face eshell-prompt read-only t)))))
 '(eshell-prompt-regexp "^[^#>
]*[#>] ")
 '(face-font-family-alternatives nil)
 '(focus-follows-mouse t)
 '(hanoi-use-faces nil)
 '(hourglass-delay 0)
 '(indent-tabs-mode t)
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(line-spacing 2)
 '(next-line-add-newlines nil)
 '(objc-font-lock-extra-types nil)
 '(pgg-cache-passphrase nil)
 '(pgg-default-user-id "Sergio Perticone")
 '(query-replace-highlight t)
 '(require-final-newline t)
 '(safe-local-variable-values (quote ((indent . 8))))
 '(slime-kill-without-query-p t)
 '(slime-net-coding-system (quote utf-8-unix))
 '(term-default-bg-color "#222"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-error ((t (:inherit font-lock-warning-face :weight bold))))
 '(compilation-info ((((class color) (min-colors 88) (background dark)) (:foreground "limegreen" :weight bold))))
 '(compilation-warning ((((class color)) (:foreground "steelblue1" :weight bold))))
 '(cursor ((t (:background "white"))))
 '(custom-button ((((type x w32 mac) (class color)) (:background "black" :foreground "yellowgreen" :box (:line-width 2 :color "black" :style released-button)))))
 '(eshell-prompt ((t (:foreground "green" :weight bold))))
 '(font-lock-builtin-face ((((type tty) (class color)) (:foreground "blue" :weight bold))))
 '(font-lock-comment-delimiter-face ((default (:foreground "cyan3")) (((class color) (min-colors 8) (background dark)) nil)))
 '(font-lock-comment-face ((t (:foreground "cyan3"))))
 '(font-lock-constant-face ((((type tty) (class color)) (:foreground "cyan" :weight bold))))
 '(font-lock-doc-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-function-name-face ((t (:foreground "#fefefe" :weight bold))))
 '(font-lock-keyword-face ((t (:foreground "yellowgreen" :weight bold))))
 '(font-lock-negation-char-face ((t (:foreground "firebrick1"))))
 '(font-lock-preprocessor-face ((t (:foreground "RoyalBlue3" :weight bold))))
 '(font-lock-string-face ((t (:foreground "magenta" :weight bold))))
 '(font-lock-type-face ((t (:foreground "forest green"))))
 '(font-lock-variable-name-face ((t nil)))
 '(font-lock-warning-face ((((class color) (min-colors 8)) (:foreground "firebrick1" :weight bold))))
 '(highlight ((t nil)))
 '(minibuffer-prompt ((t (:foreground "cyan"))))
 '(mode-line ((t (:background "#d3d7cf" :foreground "#2e3436" :box (:line-width -1 :style released-button)))))
 '(mode-line-buffer-id ((t (:weight bold))))
 '(mode-line-highlight ((((class color) (min-colors 88)) nil)))
 '(mode-line-inactive ((default (:inherit mode-line)) (((class color) (min-colors 88) (background dark)) (:weight light))))
 '(region ((((class color) (min-colors 88) (background dark)) nil)))
 '(term ((t nil)))
 '(window-divider-last-pixel ((t (:foreground "dark gray")))))
(put 'dired-find-alternate-file 'disabled nil)


