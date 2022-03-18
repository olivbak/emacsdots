;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; Set system font
(defvar efs/default-font-size 180)
(defvar efs/default-variable-font-size 180)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			  ("org" . "https://orgmode.org/elpa/")
			   ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
    (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
    (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Fuck you ugly emacs logo
(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)            ; Disable the menu bar

;; Line number stuff
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		 term-mode-hook
		  shell-mode-hook
		   vterm-mode-hook
		    treemacs-mode-hook
		     eshell-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package evil
	      :init
	       (setq evil-want-integration t)
		(setq evil-want-keybinding nil)
		  (setq evil-want-C-u-scroll t)
		    (setq evil-want-C-i-jump nil)
		      :config
			(evil-mode 1)
			 (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
			 ;; Use visual line motions even outside of visual-line-mode buffers
			  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
			   (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

			    (evil-set-initial-state 'messages-buffer-mode 'normal)
			     (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
	       :after evil
	         :config
		   (evil-collection-init))

;; Displays options for partially inserted commands. Nice when learning
(use-package which-key
	      :init (which-key-mode)
	       :diminish which-key-mode
		:config
		 (setq which-key-idle-delay 1))


;; Enable ivy
(use-package ivy
	      :diminish
	       :bind (("C-s" . swiper)
		:map ivy-minibuffer-map
		 ("TAB" . ivy-alt-done)
		  ("C-l" . ivy-alt-done)
		   ("C-j" . ivy-next-line)
		    ("C-k" . ivy-previous-line)
		     :map ivy-switch-buffer-map
		      ("C-k" . ivy-previous-line)
		       ("C-l" . ivy-done)
			("C-d" . ivy-switch-buffer-kill)
			 :map ivy-reverse-i-search-map
			  ("C-k" . ivy-previous-line)
			   ("C-d" . ivy-reverse-i-search-kill))
		   :config
		     (ivy-mode 1))

(use-package counsel
	       :bind (("C-M-j" . 'counsel-switch-buffer)
		     :map minibuffer-local-map
		      ("C-r" . 'counsel-minibuffer-history))
	         :config
		   (counsel-mode 1))


(use-package company
	      :after lsp-mode
	       :hook (lsp-mode . company-mode)
		:bind (:map company-active-map
			("<tab>" . company-complete-selection))
		      (:map lsp-mode-map
			("<tab>" . company-indent-or-complete-common))
			:custom
			 (company-minimum-prefix-length 1)
			  (company-idle-delay 0.0))

(use-package company-box
	      :hook (company-mode . company-box-mode))

(use-package projectile
	       :diminish projectile-mode
	         :config (projectile-mode)
		   :custom ((projectile-completion-system 'ivy))
		     :bind-keymap ("C-c p" . projectile-command-map)
		       :init
		         ;; NOTE: Set this to the folder where you keep your Git repos!
			   (when (file-directory-p "~/github")
			         (setq projectile-project-search-path '("~/github")))
			     (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
	       :config (counsel-projectile-mode))

(use-package magit
	       :custom
	         (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge)

(use-package evil-nerd-commenter
	       :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
	       :hook (prog-mode . rainbow-delimiters-mode))

(use-package vterm
	      :commands vterm
	       :config
		(setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
		 (setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
		  (setq vterm-max-scrollback 10000))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
    (setq explicit-powershell.exe-args '()))


(use-package dired
	      :ensure nil
	       :commands (dired dired-jump)
		:bind (("C-x C-j" . dired-jump))
		 :custom ((dired-listing-switches "-agho --group-directories-first"))
		  :config
		   (evil-collection-define-key 'normal 'dired-mode-map
					 "h" 'dired-single-up-directory
					      "l" 'dired-single-buffer))

(use-package dired-single)

;;(use-package all-the-icons-dired
;;  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
	       :config
	         ;; Doesn't work as expected!
		   ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
		     (setq dired-open-extensions '(("png" . "feh")
		      ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
	       :hook (dired-mode . dired-hide-dotfiles-mode)
	         :config
		   (evil-collection-define-key 'normal 'dired-mode-map
					 "H" 'dired-hide-dotfiles-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" "b89a4f5916c29a235d0600ad5a0849b1c50fab16c2c518e1d98f0412367e7f97" "ab729ed3a8826bf8927b16be7767aa449598950f45ddce7e4638c0960a96e0f1" "660376e0336bb04fae2dcf73ab6a1fe946ccea82b25f6800d51977e3a16de1b9" "16ab866312f1bd47d1304b303145f339eac46bbc8d655c9bfa423b957aa23cc9" "c9ddf33b383e74dac7690255dd2c3dfa1961a8e8a1d20e401c6572febef61045" "7575474658c34b905bcec30a725653b2138c2f2d3deef0587e3abfae08c5b276" "8acf4d93c90712b00317b68fb2c25b9b2c4b6af5e4bed09d52b390f9e86b2059" default))
 '(package-selected-packages
   '(nix-haskell-mode haskell-mode pdf-tools latex-preview-pane auctex evil-mu4e alect-themes darkmine-theme dark-mint-theme badwolf-theme darkburn-theme vs-dark-theme ample-theme twilight-theme dired-hide-dotfiles dired-open dired-single vterm rainbow-delimiters evil-nerd-commenter forge evil-magit magit counsel-projectile projectile company-box company lsp-ivy lsp-treemacs lsp-ui lsp-mode counsel ivy which-key evil-collection evil use-package))
 '(warning-suppress-types '((comp) (comp) (comp) (comp) (comp) (comp) (comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(load-file "~/.emacs.d/themes/ample-dark.el")
;; Load cyberpunk theme
(load-theme 'sanityinc-tomorrow-bright t)


(global-set-key (kbd "C-c o") 'vterm)
(global-set-key (kbd "<f1>") (lambda ()
			      (interactive)
			       (counsel-find-file "~/.notes")))
(global-set-key (kbd "<f2>") (lambda ()
			      (interactive)
			       (counsel-find-file "~/.todo")))
(global-set-key (kbd "<f3>") (lambda ()
			      (interactive)
			       (counsel-find-file "~/.guides/emacs-keys.org")))

;; Put autosave files in /tmp.
(setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t)))

(require 'org)

(set-face-attribute 'default nil :height 130)
(set-background-color "black")


(use-package tex
  :ensure auctex)

(use-package pdf-tools)

(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer) ;; revert pdf after compile
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))) ;; use pdf-tools for viewing
(setq LaTeX-command "latex --synctex=1") ;; optional: enable synctex

(use-package haskell-mode)

;; Yeeu
(defalias 'yes-or-no-p 'y-or-n-p)
