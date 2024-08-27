(setopt inhibit-splash-screen t)
(menu-bar-mode -1)

(setopt initial-major-mode 'fundamental-mode)
(setopt display-time-default-load-average nil)

;; Automatically reread file from disk if changed
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

;; Save history of minibuffer
(savehist-mode)

;; Move through windows
(global-set-key (kbd "C-c w h") 'windmove-left)
(global-set-key (kbd "C-c w j") 'windmove-down)
(global-set-key (kbd "C-c w k") 'windmove-up)
(global-set-key (kbd "C-c w l") 'windmove-right)

(global-set-key (kbd "C-c t") 'ansi-term)

(setopt sentence-end-double-space nil)

;; Put all backup files into ~/.emacs.d/backups
(defun pp/backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories do not exist, create them."
  (let* ((backupRootDir (concat user-emacs-directory "backups/"))
   (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath ))
   (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") )))
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath))
(setopt make-backup-file-name-function 'pp/backup-file-name)

;; Mac fixes
(when (eq system-type 'darwin)
  (progn
    (setq mac-option-key-is-meta t)
    (setq mac-command-key-is-meta nil)
    (setq mac-command-modifier nil)
    (setq mac-right-option-modifier 'none)
    (setq mac-option-modifier 'meta)))

;; which-key: shows a popup of available keybindings when typing a long key sequence (e.g. C-x ...)
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Minibuffer completion settings
;; see https://www.masteringemacs.org/article/understanding-minibuffer-completion
(setopt enable-recursive-minibuffers t)
(setopt completion-cycle-threshold 1)
(setopt completions-detailed t)
(setopt tab-always-indent 'complete)
(setopt completion-styles '(basic initials substring))

(setopt completion-auto-help 'always)
(setopt completions-max-height 20)
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)

;; Interface enhancements/defaults

(setopt line-number-mode t) ; Show current line in modeline
(setopt column-number-mode t) ; Show column in modeline

(setopt x-underline-at-descent-line nil)
(setopt switch-to-buffer-obey-display-actions t)

(setopt show-trailing-whitespace nil) ; Don't underline trailing spaces by default
(setopt indicate-buffer-boundaries 'left)

(setopt indent-tabs-mode nil)
(setopt tab-width 2)

(blink-cursor-mode -1) ; Steady cursor

;; Display line numbers in programming mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Modes to highlight the current line with
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;; Tab bar configuration
(setopt tab-bar-show t)

;; Add the time to tab bar, if visible
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)
(setopt display-time-format "%a %F %T")
(setopt display-time-interval 1)
(display-time-mode)

;; Theme
(use-package emacs
  :config
  (load-theme 'modus-vivendi))

(setq vc-follow-symlinks t)

(require 'package)
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(setq packages '(go-mode cue-mode magit dockerfile-mode slime lsp-mode))

(defun pp/install-packages ()
  (interactive)
  (package-refresh-contents)
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))))

(add-hook 'go-mode-hook 'lsp-deferred)

(defun pp/fix-utf ()
  (interactive)
  (setq locale-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (define-coding-system-alias 'UTF-8 'utf-8))

(pp/fix-utf)

(setq inferior-lisp-program (executable-find "sbcl"))

(load "server")
(unless (server-running-p)
  (server-start))

;; Use separate file for customize and load it
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
