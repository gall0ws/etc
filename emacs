;; hey emacs, this is your -*- lisp -*- configuration file!

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; global keys:
(global-set-key (kbd "<f1>") 'woman)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-h") 'backward-delete-char-untabify)
(global-set-key (kbd "C-x M-a") 'acme-mouse-mode) ;; defined below
(global-set-key (kbd "C-x M-t") 'transient-mark-mode)
(global-set-key (kbd "M-o") 'ace-window)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; frame default settings:
(setq default-frame-alist
      (list
       '(vertical-scroll-bars . nil)))

(setq initial-frame-alist default-frame-alist)


;; eshell

(defun eshell-clear-buffer ()
  "Clear terminal"
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(add-hook 'eshell-mode-hook
          '(lambda()
             (local-set-key (kbd "C-l") 'eshell-clear-buffer)))

;; additional modes:
;; (setq additional-modes
 ;;      (list ;; (path . load-function) ...
 ;;       '("~/.emacs.d/downloaded/acme-mouse" . (lambda()
 ;; 				      (require 'acme-mouse)
 ;; 				      (define-global-minor-mode acme-global-mouse-mode
 ;; 					acme-mouse-mode
 ;; 					(lambda() (acme-mouse-mode t)))
 ;; 				      (acme-global-mouse-mode)))

(let ((acme-el "~/.emacs.d/downloaded/acme-mouse/acme-mouse.el"))
  (when (file-exists-p acme-el)
    (progn
      (load acme-el)
      (require 'acme-mouse)
      (define-global-minor-mode acme-global-mouse-mode 
	acme-mouse-mode
	(lambda () (acme-mouse-mode t)))
      (acme-global-mouse-mode))))


;; typescript stuff
(use-package typescript-mode
	     :ensure t
	     :mode (("\\.tsx\\'" . typescript-mode))
	     :config
	     (setq indent-tabs-mode nil))

(use-package tide
  :init
  :ensure t
  :after (typescript-mode company flycheck)
  :config
  (add-hook 'typescript-mode-hook 'tide-setup))

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'typescript-mode-hook 'flycheck-mode))


;; backups:
(setq make-backup-files nil
      backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs-backup"))
      version-control t
      kept-new-versions 2
      kept-old-versions 5
      delete-old-versions t)

;; misc:
;(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(windmove-default-keybindings 'shift)
(put 'dired-find-alternate-file 'disabled nil)
(setq ns-right-alternate-modifier 'none)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
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
   '("6b5c518d1c250a8ce17463b7e435e9e20faa84f3f7defba8b579d4f5925f60c1"
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
 '(display-hourglass nil)
 '(display-time-24hr-format t)
 '(display-time-default-load-average nil)
 '(electric-indent-mode nil)
 '(explicit-shell-file-name nil)
 '(face-font-family-alternatives nil)
 '(focus-follows-mouse t)
 '(hanoi-use-faces nil)
 '(hourglass-delay 0)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(js-indent-level 4)
 '(line-spacing 2)
 '(mouse-autoselect-window t)
 '(next-line-add-newlines nil)
 '(objc-font-lock-extra-types nil)
 '(package-selected-packages
   '(exec-path-from-shell go-errcheck go-autocomplete origami folding
                          company web-mode tide typescript-mode
                          ace-window markdown-mode magit gruvbox-theme
                          acme-theme afternoon-theme))
 '(query-replace-highlight t)
 '(require-final-newline t)
 '(safe-local-variable-values '((indent . 8)))
 '(slime-kill-without-query-p t)
 '(slime-net-coding-system 'utf-8-unix)
 '(term-suppress-hard-newline t))

;; funcs
(defun infer-indentation-style ()
  "Set current buffer's indent-tabs-mode guessing the style used"
  (interactive)
  (setq-local indent-tabs-mode (>= (how-many "^\t" (point-min) (point-max))
				   (how-many "^  " (point-min) (point-max)))))

(defun chomp (&optional start end)
  "Remove trailing whitespaces"
  (interactive
   (and (use-region-p) (list (region-beginning) (region-end))))
  (replace-regexp "[ 	]+$" ""))

(defun fixup-smart-quotes (&optional start end)
  "Replace “smart” quotes with dumb ones."
  (interactive
   (and (use-region-p) (list (region-beginning) (region-end))))
  (replace-regexp "[“”]" "\"" nil start end)
  (replace-regexp "[‘’]" "'" nil start end))

(defun show-file-name ()
  "Show current buffer file name in the minibuffer"
  (interactive)
  (message buffer-file-name))

(load-theme 'gruvbox-dark-medium)
