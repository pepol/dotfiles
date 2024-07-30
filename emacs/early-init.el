;; Startup speed, annoyance suppression
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types `((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence startup message
(setq inhibit-startup-echo-area-message (user-login-name))

;; Default frame configuration: full screen, good looking title bar on MacOS
(setq frame-resize-pixelwise t)

(cond ((display-graphic-p) (tool-bar-mode -1)))

(setq default-frame-alist '((fullscreen . maximized)
          (background-color . "#000000")
          (foreground-color . "#ffffff")
          (ns-appearance . dark)
          (ns-transparent-titlebar . t)))
