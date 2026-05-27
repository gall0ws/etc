;; hey emacs, this is your -*- lisp -*- configuration file!

;;;; default frame settings
(add-to-list 'initial-frame-alist '(vertical-scroll-bars . nil))

;;;; packages stuff
(package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;;;; globals
(global-company-mode)
(global-set-key (kbd "C-c b") 'compile)
(global-set-key (kbd "C-c c") 'chomp)
(global-set-key (kbd "C-c l") 'goto-line)
(global-set-key (kbd "C-c m") 'man)
(global-set-key (kbd "C-c r") 'reread-buffer)
(global-set-key (kbd "C-c t") 'transient-mark-mode)
(global-set-key (kbd "C-h")   'backward-delete-char-untabify)

;;;; hooks
;; note: for `add-hook' it’s recommended to use a function symbol and
;; not a lambda form.  Using a symbol will ensure that the function is
;; not re-added if the function is edited, and using lambda forms may
;; also have a negative performance impact when running `add-hook' and
;; `remove-hook'.
(defun hooks/c-mode ()
  (local-add-hook 'before-save-hook 'chomp)
  (flycheck-mode))

(defun hooks/go-mode ()
  (local-add-hook 'before-save-hook 'gofmt)
  (setq-local compile-command "go build ")
  (local-set-key (kbd "C-c d") 'godoc)
  (local-set-key (kbd "C-c f") 'gofmt))

(defun hooks/lisp-mode ()
  (local-add-hook 'before-save-hook 'chomp))

(defun hooks/eshell-mode ()
  (local-set-key (kbd "C-l") 'eshell-clear-buffer))

(add-hook 'c-mode-hook		'hooks/c-mode)
(add-hook 'go-mode-hook		'hooks/go-mode)
(add-hook 'lisp-mode-hook	'hooks/lisp-mode)
(add-hook 'eshell-mode-hook	'hooks/eshell-mode)

;;;; window-system
(when (eq window-system 'ns)
  (defun ns/apply-theme (appearance)
    (mapc 'disable-theme custom-enabled-themes)
    (pcase appearance
      ('light (load-theme 'modus-operandi t))
      ('dark  (load-theme 'modus-vivendi  t))))
  (add-hook 'ns-system-appearance-change-functions 'ns/apply-theme)
  (ns-auto-titlebar-mode)
  (menu-bar-mode t))

(when (eq window-system 'x)
  (load-theme gruvbox-dark-hard t)
  (menu-bar-mode -1))

(if (eq window-system nil)
    (progn
      (xterm-mouse-mode)
      (menu-bar-mode -1))
    (fancy-startup-screen))

;;;; misc
(exec-path-from-shell-initialize)
(windmove-default-keybindings 'shift)
(put 'dired-find-alternate-file 'disabled nil)
(put 'add-hook 'lisp-indent-function 1)

;;;; funcs
(defun local-add-hook (hook function &optional depth)
  "Local version of `add-hook'."
  (add-hook hook function depth t))

(defun infer-indentation-style ()
  "Set current buffer's indent-tabs-mode guessing the style in use."
  (interactive)
  (setq-local indent-tabs-mode (>= (how-many "^\t" (point-min) (point-max))
				   (how-many "^  " (point-min) (point-max)))))

(defun chomp (&optional start end)
  "Remove trailing whitespaces."
  (interactive
   (when (use-region-p) (list (region-beginning) (region-end))))
  (unless (numberp start) (setq start (point-min)))
  (unless (numberp end) (setq end (point-max)))
  (let ((cur-point (point)))
    (goto-char start)
    (while (re-search-forward "[ \t]+$" end t)
      (replace-match ""))
    (goto-char cur-point)))

(defun fixup-smart-quotes (&optional start end)
  "Replace “smart” quotes with dumb ones."
  (interactive
   (when (use-region-p) (list (region-beginning) (region-end))))
  (unless (numberp start) (setq start (point-min)))
  (unless (numberp end) (setq end (point-max)))
  (replace-regexp "[“”]" "\"" nil start end)
  (replace-regexp "[‘’]" "'" nil start end))

(defun reread-buffer ()
  "Reload buffer."
  (interactive)
  (find-file buffer-file-name))

(defun find-file-sudo (filename)
  "Find file using sudo."
  (interactive "FFind file: ")
  (find-file (concat "/sudo::" filename)))

(defun find-file-ssh (machine filename)
  "Find file over ssh."
  (interactive "MMachine: \nFFile: ")
  (find-file (concat "/ssh:" machine ":" filename)))

(defun eshell-clear-buffer ()
  "Clear eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

;;;; custom zone
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
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
 '(display-hourglass t)
 '(display-time-24hr-format t)
 '(display-time-default-load-average nil)
 '(electric-indent-mode nil)
 '(explicit-shell-file-name nil)
 '(face-font-family-alternatives nil)
 '(focus-follows-mouse t)
 '(hourglass-delay 0)
 '(indent-tabs-mode t)
 '(inhibit-startup-screen t)
 '(js-indent-level 4)
 '(line-spacing 2)
 '(mouse-autoselect-window t)
 '(mouse-drag-and-drop-region 'meta)
 '(next-line-add-newlines nil)
 '(ns-pop-up-frames nil)
 '(ns-right-alternate-modifier 'none)
 '(objc-font-lock-extra-types nil)
 '(package-selected-packages
   '(ace-window acme-theme afternoon-theme company exec-path-from-shell
     folding go-mode gruvbox-theme lua-mode magit
     markdown-mode ns-auto-titlebar origami plan9-theme
     sudoku swift-mode the-matrix-theme tide
     timu-macos-theme typescript-mode web-mode))
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
 '(default ((t (:family "Anonymous Pro" :foundry "nil" :slant normal :weight regular :height 140 :width normal))))
 '(ns-working-text-face ((t (:background "gold2" :foreground "black")))))
