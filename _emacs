(setq inhibit-startup-message t)
(menu-bar-mode -1)

(if (not window-system)
    nil
  (require 'server)
  (if (server-running-p) nil (server-start)))

(add-hook 'server-visit-hook 'turn-on-auto-revert-mode)

(add-to-list 'load-path "~/git/gnus/lisp")
(add-to-list 'load-path "~/lib/elisp")

(require 'package)
;; Reset to Emacs 26 default with
;(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")))
;(add-to-list 'package-archives
;             '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package puppet-mode
  :ensure t)
(use-package markdown-mode
  :ensure t)
(use-package markdown-toc
  :ensure t
  :config (custom-set-variables '(markdown-toc-user-toc-structure-manipulation-fn 'cdr)))

;; inspiration from https://vlevit.org/en/blog/tech/visual-line-wrap
(setq visual-line-fringe-indicators '(nil right-curly-arrow))
(defun my-markdown-mode-hook ()
  (visual-line-mode 1))
(add-hook 'markdown-mode-hook 'my-markdown-mode-hook)

;;(require 'ws-trim)
;; default ws-trim-level is 0, only individually edited lines
;;(global-ws-trim-mode t)

(setq visible-bell t)
(setq mouse-yank-at-point t)
(transient-mark-mode -1)
(ido-mode 'buffers)

(setq sentence-end-double-space t)
(setq calendar-week-start-day 1)

(setq-default indent-tabs-mode nil) ;; default t changes 8 SPC to TAB
(setq puppet-indent-level 2 puppet-include-indent 4)
(setq perl-indent-level 4 cperl-indent-level 4)
(setq ruby-indent-level 2)
(add-hook 'c-mode-common-hook (lambda () (c-set-style "awk")))

(defun kjetilho-set-indent-level (&optional arg)
  "Set indent level to prefix argument."
  (interactive "P")
  (let ((level (or arg 4)))
    (set (make-local-variable
          (pcase major-mode
            ('perl-mode 'perl-indent-level)
            ('cperl-mode 'cperl-indent-level)
            ('puppet-mode 'puppet-indent-level)
            ('ruby-mode 'ruby-indent-level)
            ('c-mode 'c-basic-offset)
            ('sh-mode 'sh-basic-offset)))
         level)))

(if (not window-system)
    (add-hook 'puppet-mode-hook
              (lambda() (define-key puppet-mode-map "\r" 'newline))))

(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(global-set-key "\C-cg" 'goto-line)
(global-set-key "\C-x%" 'query-replace-regexp)
(global-set-key "\C-ce" 'eval-region)
(global-set-key "\C-cv" 'set-variable)
(global-set-key "\C-ci" 'kjetilho-set-indent-level)

(defun create-subdir ()
  "Create a subdirectory using the current contents of the minibuffer"
  (interactive)
  (let ((dirname (substring (buffer-string) (length "Find File: ")))
        (pos (point)))
    (make-directory (expand-file-name dirname))
    (minibuffer-complete-word)))

(define-key minibuffer-local-completion-map "\C-c\C-c" 'create-subdir)

;; (autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests")
(load-library "puppet-mode")
(define-key puppet-mode-map "$" 'self-insert-command)

(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

(setq gnus-select-method '(nntp "news.gmane.io"))
(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "firefox")
(setq gnus-novice-user nil)
(setq nnimap-expunge nil)

(load-library "gnus")
(load-library "nnimap")
(load-library "yaml-mode")

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
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(canlock-password "de2a748f5e19321b59207fb48fa91a734912ce77")
 '(custom-enabled-themes '(midnightblue))
 '(custom-safe-themes
   '("3ff5fe0cd9fa2aaa1119882cdd782f49107c5b9b22b374b68fa080e6a9f80462" "d580783ef5f70d2d9fa438c8d553caf6a74691dfef392f8f7230257dcec591c7" "b8d535b81f1fd753456f63c30c6a967286933c0fa28f8b3194ccd84d5d57804d" "00c26ff7742ff0d4a66a3c20628a98c072d105a6ddedeb3c4ef20547efac7646" default))
 '(gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references)
 '(ido-case-fold nil)
 '(ido-default-buffer-method 'selected-window)
 '(line-move-visual nil)
 '(markdown-toc-user-toc-structure-manipulation-fn 'cdr)
 '(mm-text-html-renderer 'w3m)
 '(package-selected-packages
   '(yaml-mode puppet-mode markdown-toc markdown-mode use-package))
 '(safe-local-variable-values '((puppet-indent-level . 8) (puppet-indent-level . 4)))
 '(select-enable-clipboard t)
 '(send-mail-function 'sendmail-send-it)
 '(user-mail-address "kjetil.homme@redpill-linpro.com"))

;; use load-theme to switch to lys-solarized
(put 'narrow-to-page 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
