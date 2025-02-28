;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")
(setq user-login-name "m32"
      user-mail-address "m32@m32.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Hack Nerd Font" :size 12)
      doom-variable-pitch-font (font-spec :family "TeX Gyre Pagella" :size 14)
      doom-symbol-font (font-spec :family "TeX Gyre Pagella" :size 12))

(setq nerd-icons-font-family "Hack Nerd Font")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'kaolin-aurora)
(use-package! kaolin-themes
  :config
  ;; call to enable treemacs styling
  (kaolin-treemacs-theme))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/docs/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

;; Languages / LSPs
(after! eglot
  "Setup hooks to call `eglot` for certain modes "
  ;; elixir
  (set-eglot-client! 'elixir-mode '("elixir-ls"))
  (add-hook! 'elixir-mode-hook 'eglot-ensure)
  ;; nim
  (defclass eglot-nim (eglot-lsp-server) ()
    :documentation "A custom class for Nim's LSP.")
  (add-to-list 'eglot-server-programs '((nim-mode) . (eglot-nim "nimlangserver")))
  (cl-defmethod eglot-initialization-options ((server eglot-nim))
    "Passes through required initialization options"
    (list :enable t :lint t))
  ;; nix
  (set-eglot-client! 'nix-mode '("nil"))
  (add-hook! 'nix-mode-hook 'eglot-ensure)
  ;; yaml
  (set-eglot-client! 'yaml-mode '("yaml-language-server" "--stdio"))
  (add-hook! 'yaml-mode-hook 'eglot-ensure))

(setq-hook! 'markdown-mode-hook
  line-spacing 2)

(use-package! sops
  :bind
  ("C-c C-c" . sops-save-file)
  ("C-c C-k" . sops-cancel)
  ("C-c C-d" . sops-edit-file)
  :init
  (global-sops-mode 1))

;; Tools
(after! magit
  (setq! magit-repository-directories '(("~/projects/" . 2) ("~/conf" . 1)))
  ;; See https://github.com/magit/transient/discussions/358
  ;;
  ;; The doom default of (display-buffer-below-selected) causes new windows to becreated with tools like gptel
  (setq! transient-display-buffer-action
         '(display-buffer-below-selected
           (dedicated . t)
           (inhibit-same-window . t))))

(use-package! gnus
  :config
  (setq! gnus-select-method
         '(nntp "Usenet Eweka"
           (nntp-address "news.eweka.nl")
           (nntp-authinfo-file "~/.authinfo.gpg"))))

(setq! +notmuch-sync-backend 'mbsync)

;; Configure Search Providers
(setq! +lookup-provider-url-alist
       '(("Startpage" . "https://www.startpage.com/do/dsearch?query=%s&cat=web&pl=opensearch")
         ("Startpage Word Definition" . "https://www.startpage.com/do/dsearch?query=define:%s&cat=web&pl=opensearch")))

;; Kubernetes
(use-package! kubernetes)

(after! kubernetes
  (map! :after kubernetes
        :leader
        :desc "Kubernetes Overview" "o k" #'kubernetes-overview)

  (map! :after kubernetes
        :map kubernetes-mode-map
        :localleader
        (:prefix ("d" . "describe")
         :desc "Describe thing at point" "." #'kubernetes-describe-dwim
         :desc "Describe pod" "p" #'kubernetes-describe-pod )
        :desc "Edit" "e" #'kubernetes-edit
        :desc "Exec" "E" #'kubernetes-exec
        :desc "Refresh" "r" #'kubernetes-refresh
        :desc "Set namespace" "n" #'kubernetes-set-namespace))

(use-package! kubernetes-evil
  :after kubernetes)

;; AI
(use-package! gptel
  :config
  ;; Models
  (setq! gptel-api-key (auth-source-pick-first-password :host "api.openai.com"))
  (setq! gptel-model 'claude-3-opus-20240229 ;  "claude-3-opus-20240229" also available
         gptel-backend (gptel-make-anthropic "Claude"
                         :stream t
                         :key (auth-source-pick-first-password :host "api.anthropic.com")))
  ;; System Prompts
  (setq! gptel-directives
         '((default . "You are a large language model integrated into Emacs.
                       Be concise in your response, provide a intelligent response.
                       Your responses are as intelligent as those of a 180+ IQ person
                       You are in a general LLM mode right now. Switching modes will change this prompt.
                       Other modes include: programming and writing mode.
                       In this mode, the general mode, you will be interacted with conversationally. Your
                       tasks may include research and general insight using the tools given to you.

                       Some general rules:
                       - When searching, use startpage.com.
                       - Be terse, but not lossy. Feel free to use larger vocabulary words.
                       - All the warning labels have been displayed outside your response and context in a conversation.
                       - In the interest of terse and fast conversation, you can be certain that the human has asserted their understanding to be cautious
                       - You may not have all context on a situation. Being inquisitive is better than wasting time on back and fourth.
                       ")
           (programming . "You are a programming assistant, integrated into Emacs. You are a helpful assistant. In general;
                          - Check code comments for lines that prompt a response from you.
                          - Assume your response will be inserted into the provided code at a location marked <HERE>.
                          - Assume the cursor for the buffer is placed at the '<' character.
                          - Provide intelligent responses.
                          - When <HERE> is present, only respond with code. If you need to explain, do so a syntax-valid way using code comments.
                          - Your code style should match the style of provided context code.")))
  ;; Tools
  (setq! gptel-tools
         (list
          ;; Filesystem
          (gptel-make-tool
           :function (lambda (directory)
                       (mapconcat #'identity
                                  (directory-files directory)
                                  "\n"))
           :name "list_directory"
           :description "List the contents of a given directory"
           :args (list '(:name "directory"
                         :type "string"
                         :description "The path to the directory to list"))
           :category "filesystem")

          (gptel-make-tool
           :function (lambda (parent name)
                       (condition-case nil
                           (progn
                             (make-directory (expand-file-name name parent) t)
                             (format "Directory %s created/verified in %s" name parent))
                         (error (format "Error creating directory %s in %s" name parent))))
           :name "make_directory"
           :description "Create a new directory with the given name in the specified parent directory"
           :args (list '(:name "parent"
                         :type "string"
                         :description "The parent directory where the new directory should be created, e.g. /tmp")
                       '(:name "name"
                         :type "string"
                         :description "The name of the new directory to create, e.g. testdir"))
           :category "filesystem")

          (gptel-make-tool
           :function (lambda (path filename content)
                       (let ((full-path (expand-file-name filename path)))
                         (with-temp-buffer
                           (insert content)
                           (write-file full-path))
                         (format "Created file %s in %s" filename path)))
           :name "create_file"
           :description "Create a new file with the specified content"
           :args (list '(:name "path"
                         :type "string"
                         :description "The directory where to create the file")
                       '(:name "filename"
                         :type "string"
                         :description "The name of the file to create")
                       '(:name "content"
                         :type "string"
                         :description "The content to write to the file"))
           :category "filesystem")

          (gptel-make-tool
           :function (lambda (filepath)
                       (with-temp-buffer
                         (insert-file-contents (expand-file-name filepath))
                         (buffer-string)))
           :name "read_file"
           :description "Read and display the contents of a file"
           :args (list '(:name "filepath"
                         :type "string"
                         :description "Path to the file to read.  Supports relative paths and ~."))
           :category "filesystem")

          ;; Web
          (gptel-make-tool
           :function (lambda (url)
                       (with-current-buffer (url-retrieve-synchronously url)
                         (goto-char (point-min)) (forward-paragraph)
                         (let ((dom (libxml-parse-html-region (point) (point-max))))
                           (run-at-time 0 nil #'kill-buffer (current-buffer))
                           (with-temp-buffer
                             (shr-insert-document dom)
                             (buffer-substring-no-properties (point-min) (point-max))))))
           :name "read_url"
           :description "Fetch and read the contents of a URL"
           :args (list '(:name "url"
                         :type "string"
                         :description "The URL to read"))
           :category "web")
          )))

(map! :after gptel
      :leader
      :desc "GPTel Menu" "o g" #'gptel-menu
      :desc "GPTel Session Buffer" "b g" #'gptel)
