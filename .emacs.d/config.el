(setq user-full-name   "Mikhail Rodin")
(setq user-mail-adress "mihail.rodin.98@gmail.com")

(custom-set-variables
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes (quote (deeper-blue)))
 '(package-selected-packages (quote (evil-visual-mark-mode slime))))

(setq x-select-enable-clipboard t)
(require 'use-package)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(defun system-is-linux()
    (string-equal system-type "gnu/linux"))
(defun system-is-windows()
  (string-equal system-type "windows-nt"))

(when (system-is-linux)
    (require 'server)
    (unless (server-running-p)
      (server-start))) ;; запустить Emacs как сервер, если ОС - GNU/Linux

(when (system-is-windows)
    (setq win-sbcl-exe          "C:/sbcl/sbcl.exe")
    (setq win-init-path         "C:/.emacs.d")
    (setq win-init-ct-path      "C:/.emacs.d/plugins/color-theme")
    (setq win-init-ac-path      "C:/.emacs.d/plugins/auto-complete")
    (setq win-init-slime-path   "C:/slime")
    (setq win-init-ac-dict-path "C:/.emacs.d/plugins/auto-complete/dict"))

(when (system-is-linux)
    (setq unix-sbcl-bin          "/usr/bin/sbcl")
    (setq unix-init-path         "~/.emacs.d")
    (setq unix-init-ct-path      "~/.emacs.d/plugins/color-theme")
    (setq unix-init-ac-path      "~/.emacs.d/plugins/auto-complete")
    (setq unix-init-slime-path   "/usr/share/common-lisp/source/slime/")
    (setq unix-init-ac-dict-path "~/.emacs.d/plugins/auto-complete/dict"))

; Load path for plugins
(if (system-is-windows)
    (add-to-list 'load-path win-init-path)
  (add-to-list 'load-path unix-init-path))

;;(set-language-environment 'UTF-8)
(if (system-is-linux) ;; для GNU/Linux кодировка utf-8, для MS Windows - windows-1251
    (progn
        (setq default-buffer-file-coding-system 'utf-8)
        (setq-default coding-system-for-read    'utf-8)
        (setq file-name-coding-system           'utf-8)
        (set-selection-coding-system            'utf-8)
        (set-keyboard-coding-system        'utf-8-unix)
        (set-terminal-coding-system             'utf-8)
        (prefer-coding-system                   'utf-8))
    (progn
        (prefer-coding-system                   'windows-1251)
        (set-terminal-coding-system             'windows-1251)
        (set-keyboard-coding-system        'windows-1251-unix)
        (set-selection-coding-system            'windows-1251)
        (setq file-name-coding-system           'windows-1251)
        (setq-default coding-system-for-read    'windows-1251)
        (setq default-buffer-file-coding-system 'windows-1251)))

;;(desktop-save-mode 1) ;; revert last saved session
(tool-bar-mode -1)
(menu-bar-mode 1)
(setq frame-title-format "GNU Emacs: %b") ;; Display the name of the current buffer in the title bar
;; Inhibit startup/splash /screen
(setq inhibit-splash-screen   t)
(setq inhibit-startup-message t) ;; экран приветствия можно вызвать комбинацией C-h C-a

;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b
(global-set-key (kbd "<f2>") 'bs-show) ;; запуск buffer selection кнопкой F2
(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))
(setq ibuffer-formats
      '((mark modified read-only vc-status-mini " "
              (name 18 18 :left :elide)
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              (vc-status 16 16 :left)
              " "
              filename-and-process)))

;; Imenu
(require 'imenu)
(setq imenu-auto-rescan      t) ;; автоматически обновлять список функций в буфере
(setq imenu-use-popup-menu t) ;; диалоги Imenu только в минибуфере
(global-set-key (kbd "<f6>") 'imenu) ;; вызов Imenu на F6

(global-set-key (kbd "M-x") 'helm-M-x) ;; use helm M-x with autocomplete instead
(global-set-key (kbd "C-i") 'helm-info)
(defalias 'yes-or-no-p 'y-or-n-p)
;;Easy transition between buffers: M-arrow-keys
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta)
    (windmove-default-keybindings 'control))
;; decode modified arrow keys to use them in tty
(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])
(define-key function-key-map "\M-[ a"  [C-up])
(define-key function-key-map "\M-[ b"  [C-down])
(define-key function-key-map "\M-[ c"  [C-right])
(define-key function-key-map "\M-[ d"  [C-left])
(use-package evil
    :ensure t
    :config (evil-mode 1)
    )

;(setq mouse-wheel-scroll-amount '(0.07))
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq scroll-step 1)
;; Scrolling settings
(setq scroll-step               1) ;; вверх-вниз по 1 строке
(setq scroll-margin            10) ;; сдвигать буфер верх/вниз когда курсор в 10 шагах от верхней/нижней границы
(setq scroll-conservatively 10000)

(setq search-highlight        t)
(setq query-replace-highlight t)

(use-package treemacs
    :ensure t
)
(global-set-key (kbd "C-x t t") 'treemacs)
(use-package which-key  ;; show keybindings
    :ensure t
)
(use-package telephone-line
    :ensure t
    :init (telephone-line-mode 1)
)
(use-package rainbow-delimiters
    :ensure t
    :config
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil))) ;; line wrap on
(load "~/.emacs.d/org-insert-source-block.el") ;; custom function
(eval-after-load 'org-mode
                    '(define-key org-mode-map [(C-s)] 'org-insert-source-block))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; Line wrapping
(setq word-wrap          t) ;; переносить по словам
(global-visual-line-mode t)

;; Indent settings
(setq-default indent-tabs-mode nil) ;; отключить возможность ставить отступы TAB'ом
(setq-default tab-width          4) ;; ширина табуляции - 4 пробельных символа
(setq-default c-basic-offset     4)
(setq-default standart-indent    4) ;; стандартная ширина отступа - 4 пробельных символа
(setq-default lisp-body-indent   4) ;; сдвигать Lisp-выражения на 4 пробельных символа
(global-set-key (kbd "RET") 'newline-and-indent) ;; при нажатии Enter перевести каретку и сделать отступ
(setq lisp-indent-function  'common-lisp-indent-function)

;; End of file newlines
(setq require-final-newline    t) ;; добавить новую пустую строку в конец файла при сохранении
(setq next-line-add-newlines nil) ;; не добавлять новую строку в конец при смещении курсора  стрелками

;; Delete trailing whitespaces, format buffer and untabify when save buffer
(defun untabify-current-buffer()
    (if (not indent-tabs-mode)
        (untabify (point-min) (point-max)))
    nil)
(add-to-list 'write-file-functions 'untabify-current-buffer)
(add-to-list 'write-file-functions 'delete-trailing-whitespace)

(use-package workgroups2
    :ensure t
    :config (workgroups-mode 1)
)
(use-package undo-tree
    :ensure t
    :config (global-undo-tree-mode)
)
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;; xah-lookup - lookup docs on WWW    ;;
;;(setq xah-lookup-browser-function 'eww)
(defun xah-lookup-cppreference (&optional @word)
  "Lookup definition of current word or text selection in URL."
  (interactive)
  (require 'xah-lookup)
  (xah-lookup-word-on-internet
   @word
   ;; Use word02051 as a placeholder in the query URL.
   "http://en.cppreference.com/mwiki/index.php?search=word02051"
   'browse-url))
(require 'cc-mode)
(define-key c++-mode-map (kbd "C-c d") #'xah-lookup-cppreference)

(use-package volatile-highlights
    :ensure t
    :config
    (volatile-highlights-mode t)
)
;;(use-package smartparens-config
    ;;:ensure t
    ;;:config
    ;;(setq sp-base-key-bindings 'paredit)
    ;;(setq sp-autoskip-closing-pair 'always)
    ;;(setq sp-hybrid-kill-entire-symbol nil)
    ;;(sp-use-paredit-bindings)
;;)
(use-package company
       :hook (prog-mode . company-mode)
       :custom
       (company-idle-delay 0)
       (company-minimum-prefix-length 1)
       (company-tooltip-align-annotations t)
       (company-tooltip-limit 10)
       (company-idle-delay 0)
       (company-echo-delay (if (display-graphic-p) nil 0))
       (company-minimum-prefix-length 2)
       (company-require-match 'never)
       (company-show-numbers t)
       (company-global-modes '(not erc-mode message-mode help-mode gud-mode eshell-mode shell-mode))
       ;;(company-backends '(company-capf)))
       (setq company-backends
        '((company-files          ; files & directory
           company-keywords       ; keywords
           company-capf)  ; completion-at-point-functions
          (company-abbrev company-dabbrev)
          ))
(use-package company-posframe
    :ensure t
       :config
       (company-posframe-mode 1)
       :custom
       (company-posframe-quickhelp-delay nil))
(use-package company-try-hard
    :straight t
    :bind
    (("C-<tab>" . company-try-hard)
     :map company-active-map
     ("C-<tab>" . company-try-hard)))
(use-package company-quickhelp
    :straight t
    :config
    (company-quickhelp-mode))
)

;; aweshell                      ;;
(add-to-list 'load-path (expand-file-name "~/.emacs.d/aweshell"))
(require 'aweshell)

(require 'setup-helm)
(require 'helm-gtags)
;;; Enable helm-gtags-mode
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(use-package lsp-mode
       :hook
       ((c++-mode c-mode rust-mode go-mode csharp-mode python-mode cmake-mode) . lsp)
       :custom
       (lsp-diagnostic-package :flymake)
       (lsp-prefer-capf t)
       (read-process-output-max (* 1024 1024))
       :config
       (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))
(use-package lsp-ui
       :custom
       (lsp-ui-doc-max-width 80)
       (lsp-ui-doc-position 'top))
(use-package company-lsp)
(use-package helm-lsp)
(use-package lsp-treemacs)
(use-package dap-mode
       :config
       (require 'dap-gdb-lldb)
       (require 'dap-go)
       ;;download debuggers, REQUIRES unzip
       (when (not (file-exists-p (expand-file-name ".extension" user-emacs-directory)))
         (dap-gdb-lldb-setup t)
         (dap-go-setup t)))
     (lsp-register-client
      (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
                       :major-modes '(c/c++-mode)
                       :remote? t
                       :server-id 'clangd-remote))
     (defun clang-ide ()
       (interactive)
       (treemacs)
       (lsp-treemacs-symbols)
       (lsp-treemacs-errors-list))

(use-package projectile
    :ensure t
    :config (projectile-global-mode)
            (setq projectile-completion-system 'helm)
            ;;(helm-projectile-on)
            (when (system-is-windows)
                (setq projectile-indexing-method 'alien))
            (setq projectile-switch-project-action 'helm-projectile)
    :bind (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
          (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
)

;; sr-speedbar
(add-hook 'c-mode-hook 'sr-speedbar-open)
(add-hook 'c++-mode-hook 'sr-speedbar-open)
(add-hook 'asm-mode-hook 'sr-speedbar-open)
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))
(require 'function-args)

(fa-config-default)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)) ;; Put c++-mode as default for *.h files (improves parsing):
(set-default 'semantic-case-fold t) ;; case-insensitive enabled

;;(require 'helm-gtags)
;; Enable helm-gtags-mode
;;(add-hook 'dired-mode-hook 'helm-gtags-mode)
;;(add-hook 'eshell-mode-hook 'helm-gtags-mode)
;;(add-hook 'c-mode-hook 'helm-gtags-mode)
;;(add-hook 'c++-mode-hook 'helm-gtags-mode)
;;(add-hook 'asm-mode-hook 'helm-gtags-mode)

;;(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
;;(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
;;(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
;;(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
;;(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;;(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

(use-package cmake-mode
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))
(use-package cmake-font-lock
  :after (cmake-mode)
  :hook (cmake-mode . cmake-font-lock-activate))
(use-package cmake-ide
  :after projectile
  :hook (c++-mode . my/cmake-ide-find-project)
  :preface
  (defun my/cmake-ide-find-project ()
    "Finds the directory of the project for cmake-ide."
    (with-eval-after-load 'projectile
      (setq cmake-ide-project-dir (projectile-project-root))
      (setq cmake-ide-build-dir (concat cmake-ide-project-dir "build")))
    (setq cmake-ide-compile-command
            (concat "cd " cmake-ide-build-dir " && cmake .. && make"))
    (cmake-ide-load-db))
  (defun my/switch-to-compilation-window ()
    "Switches to the *compilation* buffer after compilation."
    (other-window 1))
  :bind ([remap comment-region] . cmake-ide-compile)
  :init (cmake-ide-setup)
  :config (advice-add 'cmake-ide-compile :after #'my/switch-to-compilation-window))

(setq c-default-style "linux"
          c-basic-offset 4)

;; gdb
(setq
 gdb-many-windows t  ;; use gdb-many-windows by default
 gdb-show-main t ;; Non-nil means display source file containing the main routine at startup
 )
;; NB! To use gdb-many-windows, you must always supply the -i=mi argument to gdb,

(use-package ein
    :ensure t
    )
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package tex
  :ensure auctex
  :defer t
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)
  ;; to use pdfview with auctex
  (TeX-view-program-selection '((output-pdf "pdf-tools"))
                              TeX-source-correlate-start-server t)
  (TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view")))
  (TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  :hook
  (LaTeX-mode . (lambda ()
                  (turn-on-reftex)
                  (setq reftex-plug-into-AUCTeX t)
                  (reftex-isearch-minor-mode)
                  (setq TeX-PDF-mode t)
                  (setq TeX-source-correlate-method 'synctex)
                  (setq TeX-source-correlate-start-server t)))
  :config
  (when (version< emacs-version "26")
    (add-hook LaTeX-mode-hook #'display-line-numbers-mode)))
