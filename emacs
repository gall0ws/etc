;; -*- mode: emacs-lisp; lexical-binding: t -*-

;;;; load my libraries (ref. https://github.com/gall0ws/elisp)
(let ((load-prefer-newer t))
  (mapc
   (lambda (lib)
     (load (file-name-concat "~/lib/elisp" lib)))
   '("exec" "misc")))

;;;; default frame settings
(add-to-list 'initial-frame-alist '(vertical-scroll-bars . nil))

;;;; packages stuff
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;;;; globals
(global-company-mode)
(pixel-scroll-mode)

;;;; bindings
;; misc:
(global-set-key (kbd "C-h") 'backward-delete-char-untabify)
(global-set-key (kbd "s-x") 'execute-extended-command)
(global-set-key (kbd "s-<") 'exec<)
(global-set-key (kbd "s->") 'exec>)
(global-set-key (kbd "s-|") 'exec|)
(global-set-key (kbd "s-!") 'exec!)
(global-set-key (kbd "s-?") 'describe-prefix-bindings)

;; basics: C-c
(global-set-key (kbd "C-c b") 'compile)
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c C") 'chomp)
(global-set-key (kbd "C-c E") 'eshell)
(global-set-key (kbd "C-c l") 'goto-line)
(global-set-key (kbd "C-c m") 'move-to-char)
(global-set-key (kbd "C-c M") 'man)
(global-set-key (kbd "C-c o") 'ace-window)
(global-set-key (kbd "C-c r") 'reread-buffer)
(global-set-key (kbd "C-c t") 'transient-mark-mode)
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

;; help/doc: C-c h (mostly translates native C-h prefix)
(global-set-key (kbd "C-c h a") 'apropos)
(global-set-key (kbd "C-c h b") 'describe-bindings)
(global-set-key (kbd "C-c h c") 'describe-key-briefly)
(global-set-key (kbd "C-c h d") 'apropos-documentation)
(global-set-key (kbd "C-c h e") 'view-echo-area-messages)
(global-set-key (kbd "C-c h f") 'describe-function)
(global-set-key (kbd "C-c h h") 'view-hello-file)
(global-set-key (kbd "C-c h i") 'info)
(global-set-key (kbd "C-c h k") 'describe-key)
(global-set-key (kbd "C-c h l") 'view-lossage)
(global-set-key (kbd "C-c h m") 'describe-mode)
(global-set-key (kbd "C-c h o") 'describe-symbol)
(global-set-key (kbd "C-c h p") 'finder-by-keyword)
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

;; ace window
(ace-window-display-mode)
(setq aw-translate-char-function
      (λ (c)
	(cond
	 ((eq c ?s)
	  ?v)		;; s split vert
	 ((eq c ?S)
	  ?b)		;; h split hori
	 ((eq c ?w)
	  ?m)		;; w swap
	 ((eq c ?0)
	  ?x)		;; k delete
	 ((eq c ?!)
	  ?o)		;; 0 delete other
	 ((eq c ?b)
	  ?j)		;; b select buffer
	 (t c))))

;;;; hooks
;; note: for `add-hook' it’s recommended to use a function symbol and
;; not a lambda form.  Using a symbol will ensure that the function is
;; not re-added if the function is edited, and using lambda forms may
;; also have a negative performance impact when running `add-hook' and
;; `remove-hook'.
(defun hooks/c-mode ()
  (add-hook-local 'before-save-hook 'chomp)
  (flycheck-mode))

(defun hooks/go-mode ()
  (add-hook-local 'before-save-hook 'gofmt)
  (setq-local compile-command "go build ")
  (local-set-key (kbd "C-c d") 'godoc)
  (local-set-key (kbd "C-c f") 'gofmt))

(defun hooks/lisp-mode ()
  (add-hook-local 'before-save-hook 'chomp))

(defun hooks/eshell-mode ()
  (local-set-key (kbd "C-l") 'eshell-clear-buffer))

(add-hook 'c-mode-hook		'hooks/c-mode)
(add-hook 'go-mode-hook		'hooks/go-mode)
(add-hook 'lisp-mode-hook	'hooks/lisp-mode)
(add-hook 'eshell-mode-hook	'hooks/eshell-mode)

;;;; window-system
(when (eq window-system 'ns)
  (defun ns/apply-theme (appearance)
    (pcase appearance
      ('light (load-theme 'modus-operandi t))
      ('dark  (load-theme 'modus-vivendi  t))))
  (add-hook 'ns-system-appearance-change-functions 'ns/apply-theme)
  (ns-auto-titlebar-mode)
  (menu-bar-mode t))

(when (eq window-system 'x)
  (load-theme 'gruvbox-dark-hard t)
  (menu-bar-mode -1))

(if (eq window-system nil)
    (progn
      (xterm-mouse-mode)
      (menu-bar-mode -1))
    (fancy-startup-screen))

;;;; slime
(load (expand-file-name "~/lib/quicklisp/slime-helper"))
(setq inferior-lisp-program "sbcl")

;;;; misc
(exec-path-from-shell-initialize)
(windmove-default-keybindings 'shift)
(put 'dired-find-alternate-file 'disabled nil)
(put 'add-hook 'lisp-indent-function 1)
(put 'interactive 'lisp-indent-function 1)

;;;; custom zone
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Custom-mode-hook '(mixed-pitch-mode))
 '(Info-selection-hook '(mixed-pitch-mode))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(aw-dispatch-always t)
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
 '(display-battery-mode t)
 '(display-hourglass t)
 '(display-time-24hr-format t)
 '(display-time-default-load-average nil)
 '(electric-indent-mode nil)
 '(explicit-shell-file-name nil)
 '(face-font-family-alternatives nil)
 '(focus-follows-mouse t)
 '(help-mode-hook '(mixed-pitch-mode))
 '(hourglass-delay 0)
 '(indent-tabs-mode t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(js-indent-level 4)
 '(line-spacing 2)
 '(mixed-pitch-variable-pitch-cursor 'box)
 '(mouse-autoselect-window t)
 '(mouse-drag-and-drop-region 'meta)
 '(next-line-add-newlines nil)
 '(ns-pop-up-frames nil)
 '(ns-right-alternate-modifier 'none)
 '(objc-font-lock-extra-types nil)
 '(package-selected-packages
   '(ace-window acme-theme afternoon-theme company exec-path-from-shell
		folding go-mode gruvbox-theme lua-mode magit
		markdown-mode mixed-pitch ns-auto-titlebar origami
		plan9-theme slime sudoku swift-mode tide
		typescript-mode web-mode))
 '(query-replace-highlight t)
 '(require-final-newline t)
 '(slime-kill-without-query-p t)
 '(slime-net-coding-system 'utf-8-unix)
 '(term-suppress-hard-newline t)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 140 :family "Anonymous Pro"))))
 '(aw-leading-char-face ((t (:inherit line-number-major-tick :height 300))))
 '(aw-mode-line-face ((t (:inherit trailing-whitespace))))
 '(battery-load-critical ((t (:inherit error :inverse-video t))))
 '(ns-working-text-face ((t (:background "gold2" :foreground "black"))))
 '(variable-pitch ((t (:family "Lucida Grande" :height 140)))))
