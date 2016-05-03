;; global keys:
(global-set-key [f1] 'man)
(global-set-key "\M-g" 'goto-line)
(global-set-key [f5] 'compile)

;; slime stuff
(defun enable-slime ()
  (interactive)
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (require 'slime)
  (slime-setup))

;; backups:
(setq make-backup-files t
      backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs-backup"))
      version-control t
      kept-new-versions 2
      kept-old-versions 5
      delete-old-versions t)

;; hooks:
(add-hook 'c-mode-hook
	  '(lambda ()
	     (load-library "c-utils")))


;; (add-hook 'emacs-lisp-mode-hook
;; 	  '(lambda ()
;; 	     (load-library "elisp-utils")
;; 	     (define-key emacs-lisp-mode-map[f5] '(byte-compile-this-file))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Options added by Custom: nothing to see here, move along. ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blink-cursor-delay 0)
 '(blink-cursor-interval 0)
 '(c-basic-offset (quote set-from-style))
 '(c-default-style (quote ((c-mode . "linux") (c++-mode . "stroustrup") (objc-mode . "stroustrup") (java-mode . "java") (awk-mode . "awk") (other . "linux"))))
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
; '(display-time-mail-face nil)
 '(display-time-mode t nil (time))
 '(eshell-prompt-function (lambda nil nil (if (= (user-uid) 0) "# " #("> " 0 2 (rear-nonsticky (face read-only) face eshell-prompt read-only t)))))
 '(eshell-prompt-regexp "^[^#>
]*[#>] ")
 '(face-font-family-alternatives nil)
 '(global-font-lock-mode t nil (font-lock))
 '(global-hl-line-mode t nil (hl-line))
 '(hanoi-use-faces nil)
 '(hourglass-delay 0)
 '(indent-tabs-mode t)
 '(inhibit-startup-screen t)
 '(line-spacing 2)
 '(menu-bar-mode nil)
 '(next-line-add-newlines nil)
 '(objc-font-lock-extra-types nil)
 '(pgg-cache-passphrase nil)
 '(pgg-default-user-id "Sergio Perticone")
 '(query-replace-highlight t)
 '(require-final-newline t)
 '(safe-local-variable-values (quote ((indent . 8))))
 '(size-indication-mode nil)
 '(slime-kill-without-query-p t)
 '(slime-net-coding-system (quote utf-8-unix))
 '(truncate-partial-width-windows t)
 '(visible-cursor nil))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(compilation-error ((t (:inherit font-lock-warning-face :weight bold))))
 '(compilation-info ((((class color) (min-colors 88) (background dark)) (:foreground "limegreen" :weight bold))))
 '(compilation-warning ((((class color)) (:foreground "steelblue1" :weight bold))))
 '(cursor ((t nil)))
 '(custom-button ((((type x w32 mac) (class color)) (:background "black" :foreground "yellowgreen" :box (:line-width 2 :color "black" :style released-button)))))
 '(eshell-prompt ((t (:foreground "green" :weight bold))))
 '(font-lock-builtin-face ((((type tty) (class color)) (:foreground "blue" :weight bold))))
 '(font-lock-comment-delimiter-face ((default (:foreground "cyan3")) (((class color) (min-colors 8) (background dark)) nil)))
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "cyan3"))))
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
 '(hl-line ((t (:inherit highlight :background "#111111"))))
 '(minibuffer-prompt ((t (:foreground "cyan"))))
 '(mode-line ((nil (:inverse-video t))))
 '(mode-line-buffer-id ((t (:weight bold))))
 '(mode-line-highlight ((((class color) (min-colors 88)) nil)))
 '(mode-line-inactive ((default (:inherit mode-line)) (((class color) (min-colors 88) (background dark)) (:weight light))))
 '(region ((((class color) (min-colors 88) (background dark)) nil))))
