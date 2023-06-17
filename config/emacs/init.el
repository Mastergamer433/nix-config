(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse 't
      scroll-step 1
      use-dialog-box nil)

;; Disable line numbers for some modes.
(dolist (mode '(org-mode-hook
                term-mode-hook
                treemacs-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Line Numbers.
(column-number-mode)
(global-display-line-numbers-mode t)

;; Highlight cursor line.
(global-hl-line-mode t)

(setq large-file-warning-threshold nil)

(setq vc-follow-symlinks t)

(setq ad-redefinition-action 'accept)

(use-package doom-themes)
(use-package spacegray-theme)
(load-theme 'doom-dracula t)

;; Set the font
(set-face-attribute 'default nil :font "Fira Code" :height 110)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code" :height 100)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Fira Code" :height 120 :weight 'regular)

(use-package all-the-icons)

(use-package emojify)

(setq display-time-format "%l:%M %p %b %d"
    display-time-load-average-threshold 0.0)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 30)))

(use-package perspective
  :demand t
  :bind (("C-M-k" . persp-switch)
         ("C-M-n" . persp-next)
         ("C-x k" . persp-kill-buffer*))
  :custom
  (persp-initial-frame-name "Main")
  (persp-mode-prefix-key (kbd "C-c C-p"))
  :config
  ;; Running `persp-mode' multiple times resets the perspective list...
  (unless (equal persp-mode t)
    (persp-mode)))

(use-package alert
  :commands alert
  :config
  (setq alert-default-style 'notifications))

(setq display-time-world-list
      '(("Etc/UTC" "UTC")
        ("Europe/Stockholm" "Stockholm")
        ("America/Los_Angeles" "Seattle")
        ("America/Denver" "Denver")
        ("America/New_York" "New York")
        ("Pacific/Auckland" "Auckland")
        ("Asia/Shanghai" "Shanghai")
        ("Asia/Kolkata" "Hyderabad")))
(setq display-time-world-time-format "%a, %d %b %I:%M %p %Z")

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(defun keo/minibuffer-backward-kill (arg)
  (interactive "p")
  (cond
   ;; When minibuffer has ~/
   ((and minibuffer-completing-file-name
         (string= (minibuffer-contents-no-properties) "~/"))
    (delete-minibuffer-contents)
    (insert "/home/"))

   ;; When minibuffer has some file and folder names
   ((and minibuffer-completing-file-name
         (not (string= (minibuffer-contents-no-properties) "/"))
         (= (preceding-char) ?/))
    (delete-char (- arg))
    (zap-up-to-char (- arg) ?/))

   ;; All other cases
   (t
    (delete-char (- arg)))))

(use-package vertico
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("C-f" . vertico-exit)
              :map minibuffer-local-map
              ("M-h" . backward-kill-word)
              ("" . keo/minibuffer-backward-kill))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

;; Enable Corfu completion UI
;; See the Corfu README for more configuration tips.
(use-package corfu
  :bind (("TAB" . corfu-insert))
  :custom
  (corfu-auto t)
  (corfu-echo-documentation nil)
  :init
  (global-corfu-mode))

;; Disable auto completion-at-point for some modes.
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                lsp-mode-hook))
  (add-hook mode (lambda () (setq-local corfu-auto nil))))

;; Add extensions
(use-package cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c c p" . completion-at-point) ;; capf
         ("C-c c t" . complete-tag)        ;; etags
         ("C-c c d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c c h" . cape-history)
         ("C-c c f" . cape-file)
         ("C-c c k" . cape-keyword)
         ("C-c c s" . cape-symbol)
         ("C-c c a" . cape-abbrev)
         ("C-c c i" . cape-ispell)
         ("C-c c l" . cape-line)
         ("C-c c w" . cape-dict)
         ("C-c c \\" . cape-tex)
         ("C-c c _" . cape-tex)
         ("C-c c ^" . cape-tex)
         ("C-c c &" . cape-sgml)
         ("C-c c r" . cape-rfc1345))
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-ispell)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  )

(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("C-s" . consult-line)
         ("C-S-s" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key (kbd "M-.")
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  (autoload 'projectile-project-root "projectile")
  (setq consult-project-function (lambda (_) (projectile-project-root)))
)

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
:config
(general-create-definer keo/exwm-keyboard
  :keymaps '(normal insert visual emacs)
  :prefix "s"
  :global-prefix "s")
(general-create-definer keo/leader-keys
  :keymaps '(normal insert visual emacs)
  :prefix "SPC"
  :global-prefix "C-SPC"))

(keo/leader-keys
  "e" '(:ignore t :which-key "ERC")
  "ej" '(lambda () (interactive)
          (insert "/join #") :which-key "Join")
  "eq" '(lambda () (interactive)
          (insert "/quit")
          (erc-send-current-line) :which-key "Quit")
  "d"   '(:ignore t :which-key "dired")
  "dd"  '(dired :which-key "Here")
  "dh"  '((lambda () (interactive) (dired "~")) :which-key "Home")
  "dn"  '((lambda () (interactive) (dired "~/Notes")) :which-key "Notes")
  "do"  '((lambda () (interactive) (dired "~/Downloads")) :which-key "Downloads")
  "d."  '((lambda () (interactive) (dired "~/.dotfiles")) :which-key "dotfiles")
  "de"  '((lambda () (interactive) (dired "~/.dotfiles/config/emacs")) :which-key ".emacs.d")
  "b" '(:ignore t :which-key "Buffer")
  "bs" '(consult-buffer :which-key "Switch Buffer")
  "bd" '(display-line-numbers-mode :which-key "Display Line Numbers Toggle")
  "fd" '(:ignore t :which-key "dotfiles")
  "fde" '((lambda () (interactive) (find-file "~/.dotfiles/config/emacs/Emacs.org")))
  "p" '(:ignore t :which-key "Pass")
  "pp" '(password-store-copy :which-key "Copy")
  "pn" '(password-store-insert :which-key "New")
  "pg" '(password-store-generate :which-key "Generate"))

(use-package mu4e
  :ensure nil
  :config

  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")
  (setq mu4e-completing-read-function #'completing-read)
  (setq mu4e-change-filenames-when-moving t)

  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "Private"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "mg433@kimane.se")
                  (user-full-name    . "Karl Elis Odenhage")
                  (mu4e-drafts-folder  . "/Drafts")
                  (mu4e-sent-folder  . "/Sent Mail")
                  (mu4e-refile-folder  . "/All Mail")
                  (mu4e-trash-folder  . "/Trash")
                  (smtpmail-smtp-server . "esp01.zyner.net")
                  (smtpmail-smtp-service . 465)
                  (smtpmail-stream-type . ssl)))))

  (defun remove-nth-element (nth list)
    (if (zerop nth) (cdr list)
      (let ((last (nthcdr (1- nth) list)))
        (setcdr last (cddr last))
        list)))
  (setq mu4e-marks (remove-nth-element 5 mu4e-marks))
  (add-to-list 'mu4e-marks
               '(trash
                 :char ("d" . "▼")
                 :prompt "dtrash"
                 :dyn-target (lambda (target msg) (mu4e-get-trash-folder msg))
                 :action (lambda (docid msg target)
                           (mu4e~proc-move docid
                                           (mu4e~mark-check-target target) "-N"))))

  (setq message-send-mail-function 'smtpmail-send-it)
  (setq mu4e-compose-signature "- mg433")

  (setq message-kill-buffer-on-exit t)

  ;; Display options
  (setq mu4e-view-show-images t)
  (setq mu4e-view-show-addresses 't)

  ;; Composing mail
  (setq mu4e-compose-dont-reply-to-self t)

  ;; Use mu4e for sending e-mail
  (setq mail-user-agent 'mu4e-user-agent)

  (setq mu4e-maildir-shortcuts
        '(("/Inbox"     . ?i)
          ("/Sent Mail" . ?s)
          ("/Trash"     . ?t)
          ("/Drafts"    . ?d)
          ("/All Mail"  . ?a))))

(setq keo/mu4e-inbox-query
      "maildir:/Inbox AND flag:unread")

(defun keo/go-to-inbox ()
  (interactive)
  (mu4e-headers-search keo/mu4e-inbox-query))

(use-package mu4e-alert
  :after mu4e
  :config
  ;; Show unread emails from all inboxes
  (setq mu4e-alert-interesting-mail-query keo/mu4e-inbox-query)

  ;; Show notifications for mails already notified
  (setq mu4e-alert-notify-repeated-mails nil)

  (mu4e-alert-enable-notifications))

(use-package org-mime
  :bind
  ("C-<return>" . org-mime-htmlize))

(use-package erc
  :ensure nil
  :config)

(use-package password-store)

(use-package auth-source
  :config
  (setq auth-source '(password-store)))

(use-package ement)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(setq delete-by-moving-to-trash t)

(use-package denote
  :config
  (setq denote-directory "~/Notes/")
  (setq denote-known-keywords '("journal" "projects" "ideas")))

(defun keo/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Fira Code" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(defun keo/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . keo/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        '("~/OrgFiles/Calendar.org"))

  (setq org-image-actual-width nil)

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))
  (keo/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun keo/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . keo/org-mode-visual-fill))

(setq org-startup-folded t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

;; Automatically tangle our Emacs.org config file when we save it
(defun keo/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name "~/.dotfiles/"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'keo/org-babel-tangle-config)))

(use-package org-caldav
  :init
  (setq org-caldav-url 'google
        org-caldav-clendar-id "88d59157cbf81579069338800a049a251ceb2bbbaa0704ab124ccec464c839ba@group.calendar.google.com"
        org-caldav-inbox "~/OrgFiles/Calendar.org"
        org-icalendar-timezone "Europe/Stockholm"))

(use-package playerctl
  :bind(("C-c C-SPC" . playerctl-play-pause-song)
        ("C-c C-n" . playerctl-next-song)
        ("C-c C-p" . playerctl-previous-song)
        ("C-c C-f" . playerctl-seek-forward)
        ("C-c C-b" . playerctl-seek-backward)))

(use-package request)

(use-package s)

(use-package ht)

(use-package ov)

(use-package websocket)

(use-package ts)

(use-package f)

(use-package jeison)

(defun keo/org-file-jump-to-heading (org-file heading-title)
  (interactive)
  (find-file (expand-file-name org-file))
  (goto-char (point-min))
  (let ((i 1))
    (mapcar (lambda (heading)
              (search-forward (concat (s-repeat i "*") " " heading)))
            (s-split "/" heading-title)))
  (org-overview)
  (org-reveal)
  (org-show-subtree)
  (forward-line))

(setq window-rules
      '(("Emacs Dired" . (("instance" . "Emacs-Dired")
                          ("class" . "Emacs")
                          ("floating" . "on")))
        ("Discord" . (("class" . "discord")
                      ("tag" . "chat")))
        ("firefox" . (("class" . "firefox")
                      ("tag" . "www")))
        ("Mpv Fullscreen" . (("instance" . "mpvFullscreen")
                             ("fullscreen" . "on")))
        ("Emacs Config" . (("instance" . "Emacs-Config")
                           ("floating" . "on")
                           ("floatplacement" . "center")))
        ("Emacs-Dired" . (("instance" . "Emacs-Dired")
                          ("floating" . "on")
                          ("floatplacement" . "center")))
        ("Config" . (("instance" . "Config")
                     ("class" . "Emacs")
                     ("tag" . "config")))))

  (defun keo/wm-window-rules ()
    (s-join
     ";"
     (mapcar
      (lambda (rule)
        (format
         "herbstclient rule %s"
         (s-join
          " "
          (mapcar
           (lambda (arg)
             (format
              "%s=%s"
              (car arg)
              (cdr arg)))
           (cdr rule)))))
      window-rules)))

(defun keo/wm-open-heading-emacs-config ()
  (find-file
   "~/.dotfiles/config/emacs/Emacs.org")
  (goto-char 1)
  (let* ((headings (list)))
    (org-map-entries
     (lambda ()
       (let ((elem (org-element-at-point)))
         (add-to-list
          'headings
          `(,(s-concat (s-repeat (1- (org-element-property :level elem)) "  ") (org-element-property
                                                                           :title elem)) . ,(org-format-outline-path
                                                                                             (org-get-outline-path t)))))))
    (let ((heading (keo/wm-ask (reverse (mapcar 'car headings)) "Heading" t)))
      (keo/org-file-jump-to-heading
      "~/.dotfiles/config/emacs/Emacs.org"
       (cdr (assoc heading headings))))))

(defun keo/wm-goto-workspace (workspace)
  (shell-command-to-string (format "herbstclient use %s" workspace)))

(defun keo/wm-search-youtube ()
  (let ((search (keo/wm-ask '() "Search")))
    (browse-url (s-trim (format "https://www.youtube.com/results?search_query=%s" (string-replace " " "+" search))))
    (keo/wm-goto-workspace "www")))

(defun keo/wm-search-google ()
  (let ((search (keo/wm-ask '() "Search")))
    (browse-url (s-trim (format "https://www.google.com/search?q=%s" (string-replace " " "+" search))))
    (keo/wm-goto-workspace "www")))

(defun keo/wm-open-github-repo (&optional prompt-for-everything)
  (interactive)
  (let* ((owner (keo/wm-ask '() (if prompt-for-everything "Repo Owner" "Repo")))
         (user (when prompt-for-everything (keo/wm-ask '() "Repo Name")))
         (path (mapconcat 'identity `(,owner ,user) "/")))
    (browse-url (format "https://github.com/%s" path))
    (keo/wm-goto-window-by-class "Firefox")))

(defun keo/wm-get-all-clients ()
  (string-split
   (s-trim
    (shell-command-to-string "herbstclient attr clients | grep 0x"))))

(defun keo/wm-get-title-of-client (client)
  (s-trim
   (shell-command-to-string (format "herbstclient attr clients.%s | grep title | cut -d'\"' -f2" client))))

(defun keo/wm-get-class-of-client (client)
  (s-trim
   (shell-command-to-string (format "herbstclient attr clients.%s | grep class | cut -d'\"' -f2" client))))

(defun keo/wm-get-title-of-all-clients ()
  (let ((titles (list))
        (clients (keo/wm-get-all-clients)))
    (mapcar 
     (lambda (c)
       (push (s-trim (keo/wm-get-title-of-client c)) titles))
     clients)
    titles))

(defun keo/wm-get-client-by-name (name)
  (let ((client "")
        (clients (keo/wm-get-all-clients)))
    (mapcar 
     (lambda (c)
       (if (equal name (keo/wm-get-title-of-client c))
           (setq client c)))
     clients)
    client))

(defun keo/wm-get-client-by-class (class)
  (let ((client "")
        (clients (keo/wm-get-all-clients)))
    (mapcar 
     (lambda (c)
       (if (equal class (keo/wm-get-class-of-client c))
           (setq client c)))
     clients)
    client))

(defun keo/wm-get-client-class-by-name (name)
  (let ((client (keo/wm-get-client-by-name name)))
    (s-trim (shell-command-to-string (format "herbstclient attr clients.%s | grep class | cut -d'\"' -f2" client)))))

(defun keo/wm-goto-window-by-class (class)
  (let* ((client (keo/wm-get-client-by-class class)))
    (if client
        (shell-command-to-string (format "herbstclient jumpto %s" (s-left (- (length client) 1) client))))))

(defun keo/wm-switch-window ()
  (let* ((names (keo/wm-get-title-of-all-clients))
         (choices (list))
         (format-choice-function (lambda (name)
                           (push
                            (format
                             "%s: %s"
                             (keo/wm-get-client-class-by-name
                              name)
                             name)
                            choices)))
         (client (keo/wm-get-client-by-name
                  (s-trim-left
                   (cadr
                    (s-split
                     ":"
                     (s-chomp
                      (keo/wm-ask
                       (let ((choices (list)))
                         (mapcar format-choice-function names)
                         choices)
                       "Window"))))))))
    (shell-command-to-string
     (format
      "herbstclient jumpto %s"
      (s-left
       (- (length client) 1)
       client)))))

(defun keo/wm-ask (choices &optional prompt trim-newline)
  (let ((choice (shell-command-to-string
                 (format
                  "echo \"%s\" | rofi -dmenu -p \"%s\""
                  (string-join choices "\n")
                  prompt))))
    (if trim-newline
        (s-trim-right choice)
      choice)))

(setq keo/configs `(("emacs" . ("~/.dotfiles/config/emacs/Emacs.org"))
                    ("herbstluft" . ("~/.dotfiles/config/herbstluftwm/autostart"))
                    ("fish" . (,(format "~/.dotfiles/hosts/%s/default.nix" (system-name)) ,9))))

(defun keo/wm-open-config (config)
  (select-frame
   (make-frame
    '((name . "Emacs-Config"))))
  (find-file
   (cadr (assoc config keo/configs)))
  (let ((line (caddr
                (assoc config keo/configs)))
        (regex (cadddr
                 (assoc config keo/configs))))
    (if line (goto-line line))
    (if regex
        (progn
          (beginning-of-buffer)
          (search-forward-regexp regex))))
  (delete-other-windows))

(setq keo/dirs `(("home" . "~/")
                 ("dotfiles" . "~/.dotfiles/")
                 ("downloads" . "~/Downloads/")
                 ("projects" . "~/Projects/")))

(defun keo/wm-open-dired (dir)
  (select-frame
   (make-frame
    '((name . "Emacs-Dired"))))
  (dired
   (cdr (assoc dir keo/dirs)))
  (delete-other-windows))

(defun keo/wm-open-project ()
  (select-frame
   (make-frame
    '((name . "Project"))))
  (projectile-switch-project-by-name
   (keo/wm-ask projectile-known-projects "Project"))
  (delete-other-windows))

(defun keo/wm-denote-new-note ()
  (select-frame (make-frame '((name . "New-Note"))))
  (call-interactively 'denote-subdirectory)
  (delete-other-windows))

(defun keo/wm-wallpaper ()
  window-manager-wallpaper-path)

(defun keo/mail-count (max-count)
  (if keo/mu4e-inbox-query
    (let* ((mail-count (shell-command-to-string
                         (format "mu find --nocolor -n %s \"%s\" | wc -l" max-count keo/mu4e-inbox-query))))
      (format " %s" (string-trim mail-count)))
    ""))

(defun keo/org-agenda ()
  (select-frame (make-frame '((name . "Calendar"))))
  (org-agenda-list)
  (delete-other-windows))

(defun keo/new-config-frame ()
  (select-frame (make-frame '((name . "Config"))))
  (persp-switch "Config")
  (find-file "~/.dotfiles/config/emacs/Emacs.org")
  (split-window)
  (find-file "~/.dotfiles/config/herbstluftwm/autostart"))

(use-package edwina
  :config
  (setq display-buffer-base-action '(display-buffer-below-selected))
  (edwina-setup-dwm-keys)
  (edwina-mode 1))

(use-package ace-window
  :bind (("M-o" . ace-window))
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-minibuffer-flag t)
  :config
  (ace-window-display-mode 1))

(use-package winner
  :ensure nil
  :after evil
  :config
  (winner-mode)
  (define-key evil-window-map "u" 'winner-undo)
  (define-key evil-window-map "U" 'winner-redo))

(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))


;; auto-save-mode doesn't create the path automatically!
(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)

(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))

(setq create-lockfiles nil)

(setq projectile-known-projects-file (expand-file-name "tmp/projectile-bookmarks.eld" user-emacs-directory)
      lsp-session-file (expand-file-name "tmp/.lsp-session-v1" user-emacs-directory))

(use-package no-littering)

(use-package magit
  :bind ("C-M-;" . magit-status)
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package magit-todos)

(defun dw/switch-project-action ()
  "Switch to a workspace with the project name and start `magit-status'."
  ;; TODO: Switch to EXWM workspace 1?
  (persp-switch (projectile-project-name))
  (magit-status))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :demand t
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'dw/switch-project-action))

(use-package counsel-projectile
  :after projectile
  :bind (("C-M-p" . counsel-projectile-find-file))
  :config
  (counsel-projectile-mode))

(use-package eglot
  :bind (:map eglot-mode-map
              ("C-c C-a" . eglot-code-actions)
              ("C-c C-r" . eglot-rename))
  :config
  (setq eglot-autoshutdown t
        eglot-confirm-server-initiated-edits nil)
  (add-to-list 'eglot-server-programs
               '((js2-mode typescript-mode) . ("typescript-language-server" "--stdio"))))

(use-package dap-mode)

(use-package lispy
  :hook ((emacs-lisp-mode . lispy-mode)
         (scheme-mode . lispy-mode)))

(use-package lispyville
  :hook ((lispy-mode . lispyville-mode))
  :config
  (lispyville-set-key-theme '(operators c-w additional
                                        additional-movement slurp/barf-cp
                                        prettify)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

(use-package highlight-defined
  :hook (emacs-lisp-mode . highlight-defined-mode))

(use-package elmacro
  :hook (emacs-lisp-mode . elmacro-mode))

(use-package easy-escape
  :hook ((emacs-lisp-mode . easy-escape-minor-mode)
         (lisp-mode       . easy-escape-minor-mode)))

(use-package slime
  :config
  (setq inferior-lisp-program "sbcl"))

(use-package geiser)
(use-package geiser-guile)

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2)
  (require 'dap-node))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package rust-mode
  :mode "\\.rs\\'"
  :hook (rust-mode . lsp-deferred))

(use-package lua-mode
  :mode "\\.lua\\'"
  :hook (lua-mode . lsp-deferred))

(use-package fennel-mode
  :mode "\\.fnl\\'")

(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/emacs/snippets"))
  (yas-global-mode 0))

(use-package tempel
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")

  :bind (("M-+" . tempel-expand) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))

  :init

  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))

  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)
  (add-hook 'emacs-lisp-mode-hook 'tempel-setup-capf)

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  (global-tempel-abbrev-mode)
)
(use-package tempel-collection)
