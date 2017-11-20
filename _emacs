(setq inhibit-startup-message t)
(menu-bar-mode -1)

(if (not window-system)
    nil
  (require 'server)
  (if (server-running-p) nil (server-start)))

(add-to-list 'load-path "~/git/gnus/lisp")
(add-to-list 'load-path "~/lib/elisp")

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/")
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package markdown-mode
  :ensure t)

;;(require 'ws-trim)
;; default ws-trim-level is 0, only individually edited lines
;;(global-ws-trim-mode t)

(setq visible-bell t)
(setq mouse-yank-at-point t)
(transient-mark-mode -1)

(setq sentence-end-double-space t)
(setq calendar-week-start-day 1)

;; (setq-default indent-tabs-mode nil) # this changes TAB to space too aggressively
(setq puppet-indent-level 2 puppet-include-indent 4)
(setq perl-indent-level 4 cperl-indent-level 4)
(setq ruby-indent-level 2)
(add-hook 'c-mode-common-hook (lambda () (c-set-style "awk")))

(if (not window-system)
    (add-hook 'puppet-mode-hook
              (lambda() (define-key puppet-mode-map "\r" 'newline))))

(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(global-set-key "\C-cg" 'goto-line)
(global-set-key "\C-x%" 'query-replace-regexp)
(global-set-key "\C-ce" 'eval-region)

(defun create-subdir ()
  "Create a subdirectory using the current contents of the minibuffer"
  (interactive)
  (let ((dirname (substring (buffer-string) (length "Find File: ")))
        (pos (point)))
    (make-directory (expand-file-name dirname))
    (minibuffer-complete-word)))

(define-key minibuffer-local-completion-map "\C-c\C-c" 'create-subdir)

(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests")
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

(setq gnus-select-method '(nntp "news.gmane.org"))
(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "firefox")
(setq gnus-novice-user nil)
(setq nnimap-expunge nil)

(load-library "gnus")
(load-library "nnimap")

(defun nnimap-delete-article (articles)
  (with-current-buffer (nnimap-buffer)
    (nnimap-command "UID STORE %s +FLAGS.SILENT (\\Deleted)"
		    (nnimap-article-ranges articles))
    (if nnimap-expunge
        (if (nnimap-capability "UIDPLUS")
            (nnimap-command "UID EXPUNGE %s"
                            (nnimap-article-ranges articles))
          (nnimap-command "EXPUNGE")))))



(require 'cl)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(canlock-password "de2a748f5e19321b59207fb48fa91a734912ce77")
 '(gnus-summary-thread-gathering-function (quote gnus-gather-threads-by-references))
 '(line-move-visual nil)
 '(mm-text-html-renderer (quote w3m))
 '(package-selected-packages (quote (markdown-mode use-package)))
 '(safe-local-variable-values (quote ((puppet-indent-level . 4))))
 '(select-enable-clipboard t)
 '(send-mail-function (quote sendmail-send-it))
 '(user-mail-address "kjetil.homme@redpill-linpro.com"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "MidnightBlue" :foreground "White" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

(put 'narrow-to-page 'disabled nil)
