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
(setq doom-theme 'kaolin-dark)
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
;;

;; * General
;;
;; ** Configure Search Providers
(setq! +lookup-provider-url-alist
       '(("Startpage" . "https://www.startpage.com/do/dsearch?query=%s&cat=web&pl=opensearch")
         ("Startpage Word Definition" . "https://www.startpage.com/do/dsearch?query=define:%s&cat=web&pl=opensearch")))

;; * Org Mode
;;
;; ** Capture templates
(after! org-capture
  :config
  (add-to-list 'org-capture-templates
               `("a" "templates for AI"))
  (add-to-list 'org-capture-templates
               `("am" "AI Memory" entry
                 (file "ai/memory.org")
                 "* %i
                    :PROPERTIES:
                    :CREATED: %U
                    :END:"
                 :immediate-finish t
                 )))

;; * Programming
;;
;; ** Eglot
(after! eglot
  "Setup hooks to call `eglot` for certain modes "
  ;; elixir
  (set-eglot-client! 'elixir-mode '("elixir-ls"))
  (add-hook! 'elixir-mode-hook 'eglot-ensure)
  ;; nim
  (defclass eglot-nim (eglot-lsp-server) ()
    :documentation "A custom class for Nim's LSP.")
  (add-to-list 'eglot-server-programs '((nim-mode) . (eglot-nim "nimlsp")))
  (cl-defmethod eglot-initialization-options ((server eglot-nim))
    "Passes through required initialization options"
    (list :enable t :lint t))
  ;; nix
  (set-eglot-client! 'nix-mode '("nil"))
  (add-hook! 'nix-mode-hook 'eglot-ensure)
  ;; yaml
  (set-eglot-client! 'yaml-mode '("yaml-language-server" "--stdio"))
  (add-hook! 'yaml-mode-hook 'eglot-ensure))

;; ** Markdown
(setq-hook! 'markdown-mode-hook
  line-spacing 2)

;; ** SOPS
(use-package! sops
  :init
  (global-sops-mode 1))

(map! :after sops
      :leader
      :desc "Open SOPS file" "o s" #'sops-edit-file)

;; * Tools
;;
;; ** Projects
(use-package! projectile
  :config
  (setq! projectile-project-search-path '(("~/projects/" . 2))))

;; ** Git
(after! magit
  (setq! magit-repository-directories '(("~/projects/" . 2) ("~/conf" . 1)))
  ;; See https://github.com/magit/transient/discussions/358
  ;;
  ;; The doom default of (display-buffer-below-selected) causes new windows to becreated with tools like gptel
  (setq! transient-display-buffer-action
         '(display-buffer-below-selected
           (dedicated . t)
           (inhibit-same-window . t))))

;; ** Mail
(use-package! gnus
  :config
  (setq! gnus-select-method
         '(nntp "Usenet Eweka"
           (nntp-address "news.eweka.nl")
           (nntp-authinfo-file "~/.authinfo.gpg"))))
(setq! +notmuch-sync-backend 'mbsync)

;; ** Discord
(use-package! elcord
  :commands elcord-mode
  :config
  (setq elcord-use-major-mode-as-main-icon t))

;; Kubernetes
(use-package! kubernetes
  :defer t

  :config
  (setq! kubernetes-json-mode #'json-mode))

(map! :leader
      :desc "Kubernetes Overview" "o k" #'kubernetes-overview

      :mode kubernetes-mode
      :localleader
      :desc "Edit"           "e" #'kubernetes-edit
      :desc "Exec"           "E" #'kubernetes-exec
      :desc "Refresh"        "r" #'kubernetes-refresh
      :desc "Set namespace"  "n" #'kubernetes-set-namespace)

(use-package! kubernetes-evil
  :after kubernetes)

;; AI
(use-package! gptel
  :defer t
  :config
  (setq! gptel-track-media t)
  (setq! gptel-default-mode 'org-mode)

  ;; Models
  (setq! gptel-model 'claude-3-7-sonnet-20250219
         gptel-backend (gptel-make-anthropic "Claude"
                         :stream t
                         :key (auth-source-pick-first-password :host "api.anthropic.com")))

  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :stream t
    :key (auth-source-pick-first-password :host "openrouter.ai")
    :models '((anthropic/claude-3.7-sonnet
               :capabilities (media tool json url))
              (anthropic/claude-3.7-sonnet:thinking
               :capabilities (media tool json url))
              (deepseek/deepseek-r1:free
               :capabilities (media tool json url))
              (deepseek/deepseek-r1-zero:free
               :capabilities (media tool json url))
              (google/gemini-2.0-flash-001
               :capabilities (media tool json url))
              (openai/gpt-4o-mini
               :capabilities (media tool json url))
              (mistralai/mistral-7b-instruct
               :capabilities (media tool json url))
              (mistralai/mixtral-8x7b-instruct
               :capabilities (media tool json url))
              (meta-llama/llama-3.3-70b-instruct
               :capabilities (media tool json url))
              (meta-llama/llama-3.1-405b-instruct
               :capabilities (media tool json url))
              (qwen/qwq-32b
               :capabilities (media json url))
              (qwen/qwen2.5-32b-instruct
               :capabilities (media json url))
              (x-ai/grok-beta
               :capabilities (tool json url))
              (x-ai/grok-2-1212
               :capabilities (tool json url))
              (x-ai/grok-2-vision-1212
               :capabilities (media tool json url))))

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

                       Your memory:
                       You have access to tools that allow you to read and write to your local memory. Please make use of the
                       memory as you see fit. You may note simple remarks about the environment you're in, the user, projects,
                       and more as a way to provide personalization to the experience and enable persistency of information
                       across sessions. In general, you should read your memory if you think something pertinent is there.
                       You certainly should address your memory if we are only being conversational, or if a context might be
                       helpful.
                       ")
           (programming . "You are a programming assistant, integrated into Emacs. You are a helpful assistant. In general;
                          - Check code comments for lines that prompt a response from you.
                          - Assume your response will be inserted into the provided code at a location marked <HERE>.
                          - Provide intelligent responses.
                          - When <HERE> is present, only respond with code. If you need to explain, do so a syntax-valid way using code comments.
                          - Your code style should match the style of provided context code.")))

  ;; Tools
  (setq! gptel-tools
         (list
          ;; Filesystem
          ;; list_directory
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

          ;; make_directory
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

          ;; create_file
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

          ;; read_file
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

          ;; Memory
          ;; memory_add
          (gptel-make-tool
           :function (lambda (memory-text)
                       (with-temp-buffer
                         (org-capture-string memory-text "am")))
           :name "memory_add"
           :description "Save a notable fact, or bit of information in your memory"
           :args (list '(:name "memory-text"
                         :type "string"
                         :description "The short single line of text that will be saved in the outline that is your memory"))
           :category "memory")
          ;; memory_read
          (gptel-make-tool
           :function (lambda nil
                       (with-temp-buffer
                         (insert-file-contents (expand-file-name (concat org-directory "/ai/memory.org")))
                         (org-mode)
                         (buffer-string)))
           :name "memory_read"
           :description "Read back your memory"
           :args nil
           :category "memory")

          ;; Web
          ;; read_url
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
           :category "web"))))

(map!
 :leader
 (:prefix ("l" . "LLM")
  :desc "Open GPTel Menu"     "m" #'gptel-menu
  :desc "Select GPTel Buffer" "b" #'gptel
  :desc "Send to LLM"         "s" #'gptel-send
  :desc "Select tools"        "t" #'gptel-tools

  (:prefix ("e" . "Evedel")
   :desc "Create reference"     "r" #'evedel-create-reference
   :desc "Create directive"     "d" #'evedel-create-directive
   :desc "Save instructions"    "s" #'evedel-save-instructions
   :desc "Load instructions"    "l" #'evedel-load-instructions
   :desc "Process directives"   "p" #'evedel-process-directives
   :desc "Modify directive"     "m" #'evedel-modify-directive
   :desc "Modify commentary"    "C" #'evedel-modify-reference-commentary
   :desc "Delete instructions"  "k" #'evedel-delete-instructions
   :desc "Convert instructions" "c" #'evedel-convert-instructions
   :desc "Add tags"             "t" #'evedel-add-tags
   :desc "Remove tags"          "T" #'evedel-remove-tags)))

(use-package! mcp
  :config
  (setq mcp-hub-servers
        '(("knowledge" . (:command "podman" :args ("run" "-i" "-v" "emacs-mcp-memory:/app/dist" "--rm" "mcp/memory")))
          ("puppeteer" . (:command "podman" :args ("run" "-i" "--rm" "--init" "-e DOCKER_CONTAINER=true" "mcp/puppeteer")))
          ))
  (defun gptel-mcp-register-tool ()
    (interactive)
    (let ((tools (mcp-hub-get-all-tool :asyncp t :categoryp t)))
      (mapcar #'(lambda (tool)
                  (apply #'gptel-make-tool
                         tool))
              tools)))
  (defun gptel-mcp-use-tool ()
    (interactive)
    (let ((tools (mcp-hub-get-all-tool :asyncp t :categoryp t)))
      (mapcar #'(lambda (tool)
                  (let ((path (list (plist-get tool :category)
                                    (plist-get tool :name))))
                    (push (gptel-get-tool path)
                          gptel-tools)))
              tools)))
  (defun gptel-mcp-close-use-tool ()
    (interactive)
    (let ((tools (mcp-hub-get-all-tool :asyncp t :categoryp t)))
      (mapcar #'(lambda (tool)
                  (let ((path (list (plist-get tool :category)
                                    (plist-get tool :name))))
                    (setq gptel-tools
                          (cl-remove-if #'(lambda (tool)
                                            (equal path
                                                   (list (gptel-tool-category tool)
                                                         (gptel-tool-name tool))))
                                        gptel-tools))))
              tools))))
