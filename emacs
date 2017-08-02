;; hey emacs, this is your -*- lisp -*- configuration file!

;; global keys:
(global-set-key (kbd "<f1>") 'man)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-h") 'backward-delete-char-untabify)
(global-set-key (kbd "C-x M-a") 'acme-mouse-mode) ;; defined below

;; frame default settings:
(setq default-frame-alist
      (list
       '(font . "terminus-9")
       '(background-color . "#222222")
       '(foreground-color . "#EFEFEF")
       '(vertical-scroll-bars . nil)))

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
(setq my-hooks
      (list ;; (hook . function) ...
       (cons 'js-mode-hook
	     (lambda ()
	       (defun js-indent-level (lvl)
		 (interactive "nlevel: ")
		 (setq-local js-indent-level lvl))))))

(mapcar (lambda (hook)
	  (add-hook (car hook) (cdr hook)))
	my-hooks)

;; backups:
(setq make-backup-files t
      backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs-backup"))
      version-control t
      kept-new-versions 2
      kept-old-versions 5
      delete-old-versions t)

;; misc:
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(windmove-default-keybindings 'shift)
(put 'dired-find-alternate-file 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
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
 '(column-number-mode t)
 '(compilation-message-face (quote underline))
 '(compile-auto-highlight t)
 '(compile-command "make -s ")
 '(default-truncate-lines nil t)
 '(display-hourglass nil)
 '(display-time-24hr-format t)
 '(display-time-default-load-average nil)
 '(explicit-shell-file-name nil)
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
 '(query-replace-highlight t)
 '(require-final-newline t)
 '(safe-local-variable-values (quote ((indent . 8))))
 '(slime-kill-without-query-p t)
 '(slime-net-coding-system (quote utf-8-unix))
 '(term-suppress-hard-newline t))

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
 '(font-lock-keyword-face ((t (:foreground "yellow3" :weight bold))))
 '(font-lock-negation-char-face ((t (:foreground "firebrick1"))))
 '(font-lock-preprocessor-face ((t (:foreground "cornflower blue" :weight bold))))
 '(font-lock-string-face ((t (:foreground "magenta" :weight bold))))
 '(font-lock-type-face ((t (:foreground "lime green"))))
 '(font-lock-variable-name-face ((t nil)))
 '(font-lock-warning-face ((((class color) (min-colors 8)) (:foreground "firebrick1" :weight bold))))
 '(highlight ((t nil)))
 '(minibuffer-prompt ((t (:foreground "cyan"))))
 '(mode-line ((t (:background "#d3d7cf" :foreground "#2e3436" :height 1.2))))
 '(mode-line-buffer-id ((t (:weight bold))))
 '(mode-line-highlight ((((class color) (min-colors 88)) nil)))
 '(mode-line-inactive ((t (:inherit mode-line :background "dim gray" :weight light))))
 '(region ((t (:background "#666" :foreground "#ffffff"))))
 '(term ((t nil)))
 '(term-color-blue ((t (:background "steel blue" :foreground "steel blue"))))
 '(window-divider-last-pixel ((t (:foreground "dark gray")))))

