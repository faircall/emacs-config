;; Add these near the top of your config, after the (require 'ido) line
(setq ido-default-file-method 'selected-window)
(setq ido-default-directory "C:/Users/weiju/Documents/GitHub/")
(setq ido-default-buffer-method 'selected-window)

;; And also set the initial working directory
(setq command-line-default-directory "C:/Users/weiju/Documents/GitHub/")
(setq initial-buffer-choice "C:/Users/weiju/Documents/GitHub/")




;; Set the directory for backup files
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))











;; Ensure the backup directory exists
(make-directory "~/.emacs.d/backups" t)

;; Enable versioned backups
(setq version-control t)

;; Keep a certain number of old versions
(setq kept-old-versions 2)
(setq kept-new-versions 5)

;; Delete excess backup versions silently
(setq delete-old-versions t)




;; slightly broken attempt at beef mode indentation

;; Load cc-mode for C-style languages
(require 'cc-mode)
(require 'csharp-mode)

;; Define a custom Beef mode with C#-style indentation
(define-derived-mode beef-mode csharp-mode "Beef"
  "Major mode for editing Beef programming language files."
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil))

;; Automatically use beef-mode for .bf files
(add-to-list 'auto-mode-alist '("\\.bf\\'" . beef-mode))

;; Function to customize indentation for Beef mode using C# settings
(defun my-beef-mode-custom-indent ()
  (c-set-offset 'access-label '/)  ;; Align access specifier braces correctly
  (setq c-basic-offset 4)          ;; Set basic indentation to 4 spaces
  (setq tab-width 4)               ;; Set tab width to 4 spaces
  (setq indent-tabs-mode nil))     ;; Use spaces instead of tabs

;; Add the custom indentation function to the Beef mode hook
(add-hook 'beef-mode-hook 'my-beef-mode-custom-indent)




;; Enable subword-mode for all programming modes
(add-hook 'prog-mode-hook 'subword-mode)






(c-add-style "my-style" 
	     '("linux"
	       (c-basic-offset . 4)
    (c-offsets-alist . ((case-label . +)
                        (statement-case-open . +)
                        (brace-list-open . 0)
                        (substatement-open . 0)))))


(setq c-default-style "my-style")
(setq confirm-kill-emacs 'y-or-n-p)
(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes '(deeper-blue))
 '(package-selected-packages
   '(csharp-mode multiple-cursors ## beef-mode pdf-tools haskell-mode zig-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Liberation Mono" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(load-library "view")
;;(require 'cc-mode)
(require 'ido)
(require 'compile)
(ido-mode t)


(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)
(setq cooper-makescript "build.bat")


(setq compilation-directory-locked nil)

; Compilation
(setq compilation-context-lines 0)
(setq compilation-error-regexp-alist
    (cons '("^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:fatal error\\|warnin\\(g\\)\\) C[0-9]+:" 2 3 nil (4))
     compilation-error-regexp-alist))

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p cooper-makescript) t
      (cd "../")
      (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (switch-to-buffer-other-window "*compilation*")
  (if compilation-directory-locked (cd last-compilation-directory)
  (cd find-project-from-directory)
  (find-project-directory-recursive)
  (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile cooper-makescript))
  (other-window 1))
(define-key global-map "\em" 'make-without-asking)


(set-background-color "#090C1D")
(set-cursor-color "#40FF40")

										; presentation mode
(defvar presentation-mode-map nil
  "Keymap for presentation-mode.")

(if presentation-mode-map
    nil
  (setq presentation-mode-map (make-sparse-keymap)))

(defun create-padded-header (title)
  "Create a header with the TITLE padded by dashes to fill line."
  (interactive "sEnter header title: ")
  (let* ((total-width 100)  ; adjust this number for your desired line width
         (title-length (length title))
         (padding (/ (- total-width title-length) 2))
         (left-dashes (make-string padding ?-))
         (right-dashes (make-string (- total-width title-length padding) ?-)))
    (insert (concat left-dashes title right-dashes "\n"))))

(defun presentation-scroll-up ()
  "Scroll up exactly one page in presentation mode."
  (interactive)
  (scroll-up
   (- (window-height) 1)))

(defun presentation-scroll-down ()
  "Scroll down exactly one page in presentation mode."
  (interactive)
  (scroll-down
   (- (window-height) 1)))

(define-derived-mode presentation-mode text-mode "Presentation"
  "Major mode for presentation files."
  (use-local-map presentation-mode-map)
  (setq-local scroll-conservatively 0)
  (setq-local scroll-margin 0))

(define-key presentation-mode-map (kbd "C-c h") #'create-padded-header)
(define-key presentation-mode-map (kbd "C-v") #'presentation-scroll-up)
(define-key presentation-mode-map (kbd "M-v") #'presentation-scroll-down)

(add-to-list 'auto-mode-alist '("\\.presentation\\'" . presentation-mode))





