;;; init.el --- emacs config :) -*- lexical-binding: t; -*-
;;; Commentary:
;;
;; this is most likely an extremely misguided emacs config and any professional would absolutely puke at the sight of it
;; its mine tho, so who cares
;;
;;; Code:

;; im grown enough mother,,, i can abandon the default emacs ui...
(menu-bar-mode -1)

;; im using tty emacs
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)

;; thank you, startup screen, your help was appreciated
(setq inhibit-startup-screen t)

;; line numbers my beloved
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; pre package config first
;; electric pairs mode, of course, my beloved
(electric-pair-mode)

;; stupid fucking backup files be banished into a separate directory
(setq backup-directory-alist '(("." . "~/.local/share/emacs/backups"))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 20
      kept-old-versions 5)

;; sorry package.el we have to divorce :(
(setq package-enable-at-startup nil)

;; fat motherfucking elpaca setup
;; like jesus christ holy shit
;; cant complain tho since i like this manager :)
(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order :repo) ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; use package my beloved
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

;; vertico, marginalia, and orderless,,,,
;; my holy trinity......

(use-package vertico
  :ensure t
  :custom
  (vertico-scroll-margin 0)
  (vertico-count 10)
  (vertico-resize t)
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; consult one of the only things convincing me its worth living :tired:
(use-package consult
  :ensure t
  :bind
  (("C-x b" . consult-buffer))
  
  ;; automatic preview at *Completion* buffer
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  (setq register-preview-delay 0.0
	register-preview-function #'consult-register-format)

  ;; adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window))

;; im not that good at embark but hey its useful so im adding it
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; eye candy <3
(use-package catppuccin-theme
  :ensure t
  :init
  (setq catppuccin-flavor 'mocha)
  
  :config
  (load-theme 'catppuccin t))

(use-package nerd-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package which-key
  :ensure t
  :init (which-key-mode))

;; this section is about speed
;; i want to be the fastest editor in the west

(use-package avy
  :ensure t)

(use-package ace-window
  :ensure t)

(use-package hydra
  :ensure t
  :config
  (defhydra my-move-mode ()
    "movement mode"
    ("j" meow-back-word)
    ("k" meow-next)    
    ("l" meow-prev)
    (";" meow-next-word)

    ("a" avy-goto-line)
    ("s" avy-goto-char-timer)
    ("d" meow-page-up)
    ("f" meow-page-down)
    
    ("SPC" nil))
  
 (defhydra my-select-mode ()
    "select mode"
    ("j" meow-left-expand)
    ("k" meow-next-expand)
    ("l" meow-prev-expand)
    (";" meow-right-expand)

    ("f" meow-line)
    ("d" meow-inner-of-thing)
    ("s" meow-reverse)
    ("a" meow-cancel-selection)

    ("SPC" nil))

 (defhydra my-action-mode ()
   "action mode"
   ("j" undo)
   ("k" undo-redo)
   ("l" meow-save)
   (";" meow-yank)

   ("a" meow-search)
   ("s" meow-visit)
   ("d" meow-kill)
   ("f" meow-insert)

   ("SPC" nil))

 (defhydra my-macro-mode ()
   

   ("SPC" nil))) 

(use-package meow
  :ensure t
  :init
  (defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
 '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   ;; '("d" . meow-delete)
   '("d" . meow-kill)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
;; '("j" . meow-next)
   '("j" . scroll-up-command)
   '("J" . meow-next-expand)
;; '("k" . meow-prev)
   '("k" . scroll-down-command)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   ;; '("s" . meow-kill)
   '("s" . avy-goto-char-timer)
   '("S" . avy-goto-line)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

  (defun my-meow-setup ()
    (meow-leader-define-key
     '("SPC" . execute-extended-command)
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("j" . my-move-mode/body)
     '("k" . my-select-mode/body)
     '("l" . my-action-mode/body)))

  :config
  (my-meow-setup)
  (meow-global-mode 1))
