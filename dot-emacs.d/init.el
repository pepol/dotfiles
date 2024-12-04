(setopt inhibit-splash-screen t)
(menu-bar-mode -1)
(if (display-graphic-p)
    (progn
      (scroll-bar-mode -1)
      (tool-bar-mode -1)))

(setopt initial-major-mode 'fundamental-mode)
(setopt display-time-default-load-average nil)

;; Automatically reread file from disk if changed
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

;; Save history of minibuffer
(savehist-mode 1)

;; Save recently visited files.
(recentf-mode 1)

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
(add-hook 'yaml-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Modes to highlight the current line with
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook yaml-mode-hook)))
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

;;;; Package configuratio

;; Minibuffer
(use-package vertico
  :ensure t
  :config
  (setq vertico-cycle t)
  (setq vertico-resize nil)
  (vertico-mode 1))
(use-package marginalia :ensure t :config (marginalia-mode 1))
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))
(use-package vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))
(use-package consult
  :ensure t
  :bind (
         ;; C-c bindings
         ("C-c M-x" . consult-mode-command)
         ("C-c c h" . consult-history)
         ("C-c c k" . consult-kmacro)
         ("C-c c m" . consult-man)
         ("C-c c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings (override defaults)
         ("C-x M-x" . consult-complex-command)      ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                 ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window)  ;; orig. switch-to-buffer-other-window
         ("C-x r b" . consult-bookmark)             ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)       ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)           ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                 ;; orig. yank-pop
         ;; M-g bindings
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)              ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)            ;; orig. goto-line
         ("M-g o" . consult-outline)                ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings
         ("M-s d" . consult-find)                   ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)          ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)        ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                   ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)             ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s"   . consult-history)                ;; orig. next-matching-history-element
         ("M-r"   . consult-history))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (setq consult-preview-key "M-.")
  (setq consult-narrow-key "<"))
(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim)
         :map minibuffer-local-map
         ("C-c C-c" . embark-collect)
         ("C-c C-e" . embark-export)))
(use-package embark-consult :ensure t :after (embark consult))
(use-package wgrep
  :ensure t
  :bind ( :map grep-mode-map
          ("e" . wgrep-change-to-wgrep-mode)
          ("C-x C-q" . wgrep-change-to-wgrep-mode)
          ("C-c C-c" . wgrep-finish-edit)))

;; Common Lisp
(use-package slime :ensure t)

;; Magit
(use-package magit :ensure t)
(use-package magit-todos :ensure t :after magit :config (magit-todos-mode 1))
(use-package forge :ensure t :after magit)
(setq auth-sources '("~/.authinfo"))

;; Development utilities
(use-package eglot :ensure nil :hook (go-mode . eglot-ensure))

;; Development language support
(use-package go-mode :ensure t)
(use-package go-playground :ensure t)
(use-package cue-mode :ensure t)
(use-package dockerfile-mode :ensure t)
(use-package terraform-mode :ensure t)

;; Dired
(use-package treemacs-icons-dired :ensure t :hook (dired-mode . treemacs-icons-dired-mode))

;; Project management
(use-package perspective
  :ensure t
  :bind ("C-x C-b" . persp-list-buffers)
  :custom
  (persp-mode-prefix-key (kbd "C-c p"))
  (persp-state-default-file "~/.emacs.d/persp")
  :hook (kill-emacs . persp-state-save)
  :init
  (persp-mode 1))

(require 'consult)
(require 'perspective)
(consult-customize consult--source-buffer :hidden t :default nil)
(add-to-list 'consult-buffer-sources 'persp-consult-source)

;; Cloud-native
(use-package kubel
  :ensure t
  :after (vterm)
  :config (kubel-vterm-setup))

(use-package docker
  :ensure t
  :bind
  ("C-c d" . docker))

;; Misc
(use-package dimmer
  :ensure t
  :config
  (dimmer-configure-which-key)
  (dimmer-mode t))

;; Packages NOT on *ELPA - installed from git
(setq packages-git '((build :url "https://github.com/27justin/build.el.git")))
(defun pp/install-packages-git ()
  (dolist (package packages-git)
    (unless (package-installed-p (car package))
      (package-vc-install package))))
(pp/install-packages-git)

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

(setq tab-bar-format
      '(tab-bar-format-align-right tab-bar-format-global))

(setq x-select-enable-clipboard t)

(load "server")
(unless (server-running-p)
  (server-start))

;; Use separate file for customize and load it
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
