;; ------------------------------------
;; -*- Mode: Emacs-Lisp -*-
;; -*- lisp -*-
;; ~/.emacs.d/init.el
;; Jaseem Abid <jaseemabid@gmail.com>
;; ------------------------------------

;; --------
;; Identity
;; --------
(setq init-file-user "jaseem"
      user-full-name "Jaseem Abid"
      user-nick "jaseemabid"
      user-mail-address "jaseemabid@gmail.com")

;; --------
;; Encoding
;; --------
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; ---------------
;; Custom Packages
;; ---------------
(require 'cl)
(require 'package)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Install all packages required
(load-file "~/.emacs.d/elpa-list.el")

(package-initialize)

(defun jaseem/packages-installed-p ()
  (loop for pkg in jaseem/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (jaseem/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg jaseem/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; ---------
;; Autoloads
;; ---------
(require 'ace-jump-mode)
(require 'auto-complete-config)
(require 'coffee-mode)
(require 'dired)
(require 'dired-details)
(require 'fill-column-indicator)
(require 'httpcode)
(require 'lorem-ipsum)
(require 'magit)
(require 'python-pep8)
(require 'python-pylint)
(require 'rainbow-mode)
(require 'remember)
(require 'rinari)
(require 'saveplace)
(require 'server)
(require 'uniquify)
(require 'web-beautify)
(require 'yasnippet)
(require 'zone)

(when window-system
  (require 'centered-cursor-mode))

;; -----------------
;; General settings
;; -----------------
(setq case-fold-search t
      column-number-mode t
      default-major-mode 'org-mode
      inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function 'ignore
      save-place t
      transient-mark-mode t
      uniquify-buffer-name-style 'forward
      vc-follow-symlinks t
      visible-bell t)

;; ----------------------------------
;; Indentation, layout and whitespace
;; ----------------------------------
(setq c-basic-indent 4
      c-basic-offset 4
      c-default-style "k&r"
      fill-adapt-mode t
      fill-column 80
      indent-tabs-mode nil
      next-line-add-newlines nil
      nxml-child-indent 4
      python-indent 4
      require-final-newline t
      sentence-end-double-space nil
      tab-width 4)

;; Set the default browser to Chrome on linux
(when (eq system-type 'gnu/linux)
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "google-chrome"))

;; Make y/n suffice for yes/no q
(fset 'yes-or-no-p 'y-or-n-p)

;; ----------------------
;; Fonts and text styling
;; ----------------------
(setq font-lock-maximum-decoration t)
;; Larger fonts for the mac
(if (eq system-type 'darwin)
    (set-frame-font "Inconsolata-14")
  (set-frame-font "Inconsolata-11"))

;; --------------
;; Display tweaks
;; --------------

;; Set the name of the host and current path/file in title bar:
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Prevent accidentally suspending the frame
(global-unset-key (kbd "C-x C-z"))

;; Always split horizontally
(setq split-height-threshold most-positive-fixnum)

;; Mac specific stuff
(when (eq system-type 'darwin)
  ;; "Mac hook"
  (setq mac-command-modifier 'control
        mac-option-modifier 'meta
        ns-use-srgb-colorspace t
        ns-alternate-modifier 'meta
        ns-auto-hide-menu-bar nil
        ns-command-modifier 'control
        ns-control-modifier 'control
        ns-function-modifier 'control))

;; No bars and buttons on linux, show a menu bar on mac anyway
(if (eq system-type 'darwin)
    (menu-bar-mode t)
  (menu-bar-mode -1))

(when window-system
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1))

;; backup files
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; ----------------
;; auto-mode-alists
;; ----------------
(add-to-list 'auto-mode-alist '("\\._\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.ext\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.iced$" . coffee-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.less\\'" . less-css-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.scss\\'" . css-mode))
(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
(add-to-list 'auto-mode-alist '("mutt-.*-" . mail-mode))

;; ------------------
;; Custom keybindings
;; ------------------

;; buffer switching
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-c b") 'bury-buffer)

;; buffer splitting like tmux
(global-set-key (kbd "C-x |") 'split-window-right)
(global-set-key (kbd "C-x -") 'split-window-below)

;; buffer list suck
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; comment/uncomment block
(global-set-key (kbd "C-M-f") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c c") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)

;; eval buffer
(global-set-key (kbd "C-c e") 'eval-buffer)

;; flyspell
(add-to-list 'exec-path "/usr/local/bin")
(global-set-key (kbd "C-c f") 'flyspell-buffer)
(global-set-key (kbd "C-.") 'flyspell-correct-word-before-point)
(setq ispell-program-name "aspell")

;; powerful counterparts ?
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; menu bar for exploring new modes
(global-set-key (kbd "C-c C-m") 'menu-bar-mode)

;; navigation bindings
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)

;; sorting and aligning
(global-set-key (kbd "C-c C-a") 'align-regexp)
(global-set-key (kbd "M-s l") 'sort-lines)
(global-set-key (kbd "M-s r") 'reverse-region)

;; undo without leaving the ctrl key
(define-key global-map "\C-x\C-u" 'undo)

;; webjump let's you quickly search google, wikipedia, emacs wiki
(global-set-key (kbd "C-x g") 'webjump)
(global-set-key (kbd "C-x M-g") 'browse-url-at-point)

;; ------------------------
;; Mode level customization
;; ------------------------

;; ace-jump
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; auto-fill
(auto-fill-mode 1)

;; auto-complete mode
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.aspell.en.pws")
(ac-flyspell-workaround)
(global-set-key (kbd "M-/") 'auto-complete)
(add-to-list 'ac-modes 'git-commit-mode)

;; centered cursor mode
(if window-system (global-centered-cursor-mode t))

;; coffee-mode
(add-hook 'coffee-mode-hook
          (lambda ()
            (setq coffee-tab-width 2)))

;; desktop-mode
(desktop-save-mode t)
(setq desktop-files-not-to-save "^$")
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'help-mode)
(add-to-list 'desktop-modes-not-to-save 'magit-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
(add-to-list 'desktop-modes-not-to-save 'completion-list-mode)
(define-key global-map (kbd "C-c s") 'desktop-save-in-desktop-dir)

;; dired-mode
(global-set-key (kbd "C-x C-d") 'dired)
(global-set-key (kbd "C-x d") 'dired)
(dired-details-install)
(setq dired-details-hidden-string "")

;; emacs-lisp-mode
(global-set-key (kbd "C-h C-f") 'find-function)

;; emmet-mode
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)

;; erc
(load-file "~/.emacs.d/erc.el")

;; eshell
(load-file "~/.emacs.d/eshell/init.el")

;; haskell-mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;; hslint on the command line only likes this indentation mode;
;; alternatives commented out below.
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;; Ignore compiled Haskell files in filename completions
(add-to-list 'completion-ignored-extensions ".hi")

;; html-mode
;; Better navigation
(add-hook 'html-mode-hook
          (lambda ()
            "html-mode-hook"
            (set (make-local-variable 'sgml-basic-offset) 2)
            (set (make-local-variable 'tab-width) 2)
            (define-key html-mode-map (kbd "<M-left>") 'sgml-skip-tag-backward)
            (define-key html-mode-map (kbd "<M-right>") 'sgml-skip-tag-forward)))

;; ido-mode
(setq ido-enable-flex-matching t
      ido-all-frames 'visible
      ido-case-fold t
      ido-create-new-buffer 'prompt
      ido-everywhere t)
(ido-mode t)

;; js-mode
(defalias 'js-mode 'js2-mode)

;; js2-mode
(add-hook 'js2-mode-hook
          (lambda ()
            (setq mode-name "JS2")
            (local-set-key (kbd "C-c d") (lambda ()
                                            (interactive)
                                            (insert "debugger;" )))))

(setq-default js-indent-level 4
              js2-allow-keywords-as-property-names t
              js2-auto-insert-catch-block t
              js2-concat-multiline-strings t
              js2-global-externs '("$" "Y" "YUI" "_")
              js2-highlight-level 3
              js2-include-browser-externs t
              js2-include-node-externs t)

;; js2-refactor-mode
(js2r-add-keybindings-with-prefix "C-c C-r")

;; line-number-mode
(global-linum-mode t)
(global-hl-line-mode t)

;; magit
(define-key global-map (kbd "C-c i") 'magit-status)
(define-key global-map (kbd "C-c g") 'magit-status)
(define-key global-map (kbd "C-c l") 'magit-log-simple)
(setq magit-commit-all-when-nothing-staged nil
      magit-revert-item-confirm t
      magit-process-connection-type nil
      process-connection-type nil)
(add-hook 'magit-log-edit-mode-hook 'flyspell-mode)

;; org-mode
(setq org-src-fontify-natively t
      org-agenda-files `("~/.notes" "~/Notes/todo.org"))
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c r") 'org-capture)
(add-hook 'org-mode-hook 'org-indent-mode)

;; org-present mode
(defvar org-present-text-scale 10)
(add-hook 'org-present-mode-hook (lambda ()
                                   (linum-mode -1)
                                   (org-present-big)
                                   (org-display-inline-images)))

(add-hook 'org-present-mode-quit-hook (lambda ()
                                        (linum-mode t)
                                        (org-present-small)
                                        (org-remove-inline-images)))

;; Python-mode
(setq-default python-fill-docstring-style 'pep-257-nn)
(add-hook 'python-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c d")
                           (lambda ()
                             (interactive)
                             (insert "import ipdb; ipdb.set_trace()")))))
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; prog-mode
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(add-hook 'prog-mode-hook 'fci-mode)

;; rainbow-mode
(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'html-mode-hook 'rainbow-mode)

;; rainbow-delimiters-mode
(global-rainbow-delimiters-mode)

;; rinari
(global-rinari-mode)

;; root-edit : never save file as root
(when (= (user-uid) 0)
  (read-only-mode t))

;; server-mode
(unless (server-running-p)
  (server-start))

;; show parentheses
(show-paren-mode t)

;; smex-mode
;; bind Caps-Lock to smex
(when (eq window-system 'x)
  (shell-command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'"))
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; snippets
(yas-global-mode 1)

;; text-mode
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

;; tramp-mode
(setq tramp-default-host "localhost"
      tramp-auto-save-directory "~/.emacs.d/auto-save-list"
      tramp-default-method "scp")

;; web-beautify mode
(when (eq system-type 'darwin)
  (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH"))))
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c w") 'web-beautify-js))
(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c w") 'web-beautify-js))
(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c w") 'web-beautify-html))
(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c w") 'web-beautify-css))

;; type over a region
(pending-delete-mode t)

;; The Toggle-Map and Wizardry
;; http://endlessparentheses.com/the-toggle-map-and-wizardry.html

(define-prefix-command 'j/toggle-map)

;; The manual recommends C-c for user keys, but C-x t is always free,
;; whereas C-c t is used by some modes.
(define-key ctl-x-map "t" 'j/toggle-map)

(define-key j/toggle-map "c" 'column-number-mode)
(define-key j/toggle-map "d" 'toggle-debug-on-error)
(define-key j/toggle-map "e" 'toggle-debug-on-error)
(define-key j/toggle-map "f" 'auto-fill-mode)
(define-key j/toggle-map "l" 'linum-mode)
(define-key j/toggle-map "q" 'toggle-debug-on-quit)
;; Generalized `read-only-mode'
(define-key j/toggle-map "r" 'dired-toggle-read-only)
(define-key j/toggle-map "|" 'fci-mode)

(autoload 'dired-toggle-read-only "dired" nil t)

;; uniquify buffers
(setq uniquify-buffer-name-style 'forward)

;; write file hook
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

;; zoom
(global-set-key (kbd "M-+") 'text-scale-adjust)
(global-set-key (kbd "M--") 'text-scale-adjust)
(global-set-key (kbd "M-0") 'text-scale-adjust)

;; Real programmers use the real lambda
(load-file "~/.emacs.d/lambda-fontify.el")

;; Snippets
(load-file "~/.emacs.d/snippets.el")

;; Private setup, passwords and key
(let ((private-file "~/.emacs.d/private.el"))
  (when (file-readable-p private-file)
    (load-file private-file)))

;; Custom theme
(if window-system
    (load-theme 'Angel t))
