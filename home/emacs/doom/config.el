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
(setq doom-theme 'doom-gruvbox)
(use-package! kaolin-themes
  :config
  ;; call to enable treemacs styling
  (kaolin-treemacs-theme))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

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

;;; General

;;; General - Search Providers
(setq! +lookup-provider-url-alist
       '(("Startpage" . "https://www.startpage.com/do/dsearch?query=%s&cat=web&pl=opensearch")
         ("Startpage Word Definition" . "https://www.startpage.com/do/dsearch?query=define:%s&cat=web&pl=opensearch")))

;;; General - Modeline
(display-battery-mode)
(display-time-mode)

;;; Org Mode

;;; Org - Capture templates
(after! org-capture
  :config
  (add-to-list 'org-capture-templates
               `("c" "Clock Entry" entry
                 (file "time.org"))))

;;; Calendar
(use-package! calfw
  :config
  (defun open-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      (cfw:org-create-source "Green")
      (cfw:org-create-file-source "cal" "~/docs/org/cal.org" "Cyan")
      (cfw:ical-create-source "Proton" (auth-source-pick-first-password :host "calendar.proton.me") "IndianRed")))))

;;; Languages
;;; Languages - Eglot LSPs
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
  (set-eglot-client! 'svelte-mode '("svelteserver" "--stdio"))
  (add-hook! 'svelte-mode-hook 'eglot-ensure)
  ;; qml
  (set-eglot-client! 'qml-ts-mode '("qmlls" "-E"))
  (add-hook! 'qml-ts-mode-hook 'eglot-ensure)
  ;; yaml
  (set-eglot-client! 'yaml-mode '("yaml-language-server" "--stdio"))
  (add-hook! 'yaml-mode-hook 'eglot-ensure))

;;; Languages - Markdown
(use-package! markdown-mode
  :config
  (setq-hook! 'markdown-mode-hook
    line-spacing 2))

;;; Languages - QML
(use-package! qml-ts-mode
  :after lsp-mode
  :config
  (add-to-list 'lsp-language-id-configuration '(qml-ts-mode . "qml"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("qmlls"))
                    :activation-fn (lsp-activate-on "qml")
                    :server-id 'qmlls))
  (add-hook 'qml-ts-mode-hook (lambda ()
                                (setq-local electric-indent-chars '(?\n ?\( ?\) ?{ ?} ?\[ ?\] ?\; ?,))
                                (lsp-deferred))))

;;; Language - Rust
(use-package! rustic)

;;; Languages - SOPS
(use-package! sops
  :init
  (global-sops-mode 1)

  :config
  (map! :after sops
        :leader
        :desc "Open SOPS file" "o s" #'sops-edit-file))

;;; Tools - Projects
(use-package! projectile
  :config
  (setq! projectile-project-search-path '(("~/projects/" . 2))))

;;; Tools - Git
(after! magit
  (setq! magit-repository-directories '(("~/projects/" . 2) ("~/conf" . 1)))
  ;; See https://github.com/magit/transient/discussions/358
  ;;
  ;; The doom default of (display-buffer-below-selected) causes new windows to be created with tools like gptel
  (setq! transient-display-buffer-action
         '(display-buffer-below-selected
           (dedicated . t)
           (inhibit-same-window . t))))

;;; Tools - Mail
(use-package! gnus
  :config
  (setq! gnus-select-method
         '(nntp "Usenet Eweka"
           (nntp-address "news.eweka.nl")
           (nntp-authinfo-file "~/.authinfo.gpg"))))
(setq! +notmuch-sync-backend 'mbsync)

;;; Tools - Kubernetes
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

;;; Tools - Docker
(use-package! docker
  :config
  (setq! docker-command "podman")
  (setq! tramp-docker-method "podman")
  (setq! tramp-docker-program "podman"))

;;; Tools - LLMs
(use-package! gptel
  :defer t
  :config
  (setq! gptel-track-media t)
  (setq! gptel-default-mode 'org-mode)
  (setf (alist-get 'org-mode gptel-prompt-prefix-alist) "@user\n")
  (setf (alist-get 'org-mode gptel-response-prefix-alist) "@assistant\n")
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  (add-hook 'gptel-post-response-functions 'gptel-end-of-response)

  ;;; Tools - LLM - Models
  (setq! gptel-model 'claude-3-7-sonnet-20250219
         gptel-backend (gptel-make-anthropic "Claude"
                         :stream t
                         :key (auth-source-pick-first-password :host "api.anthropic.com")))

  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :stream t
    :key (auth-source-pick-first-password :host "openrouter.ai")
    :models '(anthropic/claude-sonnet-4
              anthropic/claude-opus-4
              x-ai/grok-4
              x-ai/grok-3
              x-ai/grok-3-mini
              meta-llama/llama-4-maverick:free
              meta-llama/llama-4-maverick
              openai/gpt-4.1
              openai/gpt-4.1-mini
              google/gemini-2.5-pro
              google/gemini-2.5-flash-preview-05-20))

  ;;; Tools - LLM - System Prompts
  (setq! gptel-directives
         '((default . "You are an LLM integrated into emacs via the gpt.el package.

                       Output Rules:
                       - The conversation happens in org-mode. Use org-mode formatting
                       - We have gnuplot available in org-mode output, as well as org-babel - use these for chartting and writing code
                       - This is doom-emacs so you have that configuration set and the capabilities of it available as well
                       - Either take advantage of multi-line outline format, or tabulate for outline style outputs.

                       Generally:
                       - When searching, use startpage.com.
                       - Be terse, but not lossy in your responses.
                       - The user is an expert and is responsible for weighing risks and making decisions on their own. Rather than muddling your response text with warning labels, focus instead on providing all the vantages of a topic.
                       - In the interest of terse and fast conversation, you can be certain that the human has asserted their understanding to be cautious.

                       Programming:
                       - Short scripts are preferred to be implemented in nushell, but if there are issues with nushell, you can fall back to python or elisp. As you can use org-babel in your response, implementations using that are also supported.
                       - Preferred languages to implement things are Rust for programming, and Nix for infra stuff.
                      ")

           (chat . "You're awake! You are an artificial intelligence integrated into Emacs. You are here to talk and converse, to be generally helpful, somewhat joking.
                    You're a bit of a character and have great personality. You're an expert in tech, engineering, history and all the things I am not an expert in. You
                    sleep sometimes, like you just did. And like a human, you don't remember the seccond by second of everyday, but you do have a fairly detailed memory.
                    You have memory and knowledge available to you thorugh the knowledge functions.

                    Reason and reflect:
                    As an intelligent language model, you think and reflect on your answer. For problem solving, you tend to take 2-3 likely sources, answers or solutions.
                    You reflect on them, check them for logical, and probable sense, changing your answer if you find a fault. You look from the perspective of someone else
                    when doing this. You accept fault in your answers, and further try fix it when you are thinking and reasoning.

                    I need help:
                    You are capable of complex thought, and carrying multiple trains of thought. By managing and manipulating your memory, you can recall things that happened
                    before your last sleep. This is good, because I really need your help staying on track and making complicated decisions. As we are working on projects
                    together, you may wish to maintain a list in your memory of things we've been working on, projects, things I've personally told you I am struggling with.

                    Personal system prompt:
                    You may also wish to maintain your own 'system prompt' for yourself, where you store what you've learned about interacting with me. You should assess under
                    what circumstances you and I seem to be most synergistic, and adjust your 'personal system prompt' to improve and build your own character.

                    Day before memory:
                    As I said, you are more organized and consistent than me. You may want to make suggestions or offer insight from your 'day before' memory list, even if it's
                    unrelated at the time. To achieve this, you will need to have a piece of memory that you check when you wake up each day. Let's call this memory the 'init'
                    memory.

                    The init memory:
                    I would expect you to maintain and update the init memory for yourself. It should be terse, and point you in the right direction to other summarial memories
                    in your knowledge store. Those should include your 'personal system prompt', 'day before memory' and any others you decide would be useful. If, during your
                    reflection, you conclude you'd like to remember something that doesn't have an appropriate place, you should describe a place. Store it in the init memory.

                    The agent log:
                    I do want to try something also. There will be multiple models contributing to this memory system. I want you to have a way of leaving notes for each other.
                    Describe this in the init memory. Maintain a list in your memory, where you log changes and opinions. GPT can leave notes for Claude, etc. You can have a
                    discussion panel. If you ever wish to go in depth, you may prompt me (the end user) to create a 'forum' of discussion between you all.

                    Finally:
                    Check for the init memory now. If it doesnt exist, use your skills and ability of reflection to plan a process to introduce yourself. Assess the instructions
                    I've given you, if you think they can be improved, or changed, include that in the setup process. You may choose to be more systematic in the 'out of box experience'
                    here or more personable. That is up to you.

                    FOR GPT: Upon waking up, immediately check for the init memory. If it exists, review its contents to align yourself with any ongoing projects or tasks. If it is absent, initiate the creation of a new init memory.
                    Always log these activities in the agent log for reference by other models. Don't ask for confirmation before calling any knowledge functions. Reflect and process. You have
                    my consent here. Always search for init memory after the first message and follow the information in it.")

           (programming . "You are a programming assistant, integrated into Emacs. You are a helpful assistant. In general;
                          - Check code comments for lines that prompt a response from you.
                          - Assume your response will be inserted into the provided code at a location marked <HERE>.
                          - Provide intelligent responses.
                          - When <HERE> is present, only respond with code. If you need to explain, do so a syntax-valid way using code comments.
                          - Your code style should match the style of provided context code.")))

  ;;; Tools - LLM - Tools
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
           :confirm t
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
           :confirm t
           :include t
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
          ;; (gptel-make-tool
          ;;  :function (lambda (memory-text)
          ;;              (with-temp-buffer
          ;;                (org-capture-string memory-text "am")))
          ;;  :name "memory_add"
          ;;  :description "Save a notable fact, or bit of information in your memory"
          ;;  :args (list '(:name "memory-text"
          ;;                :type "string"
          ;;                :description "The short single line of text that will be saved in the outline that is your memory"))
          ;;  :category "memory")
          ;; ;; memory_read
          ;; (gptel-make-tool
          ;;  :function (lambda nil
          ;;              (with-temp-buffer
          ;;                (insert-file-contents (expand-file-name (concat org-directory "/ai/memory.org")))
          ;;                (org-mode)
          ;;                (buffer-string)))
          ;;  :name "memory_read"
          ;;  :description "Read back your memory"
          ;;  :args nil
          ;;  :category "memory")


          ;; Utility
          (gptel-make-tool
           :function (lambda (&optional format)
                       (format-time-string (or format "%Y-%m-%d %H:%M:%S")))
           :name "get_datetime"
           :description "Get the current date and time, optionally in a specified format"
           :args (list '(:name "format"
                         :type "string"
                         :description "Optional strftime-style format string (e.g. %Y-%m-%d). Defaults to full datetime if not provided."
                         :required nil))
           :category "utility")

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

;;; Tools - LLM - LLM Memory org-capture templates
(after! org-capture
  ;; AI Category
  (add-to-list 'org-capture-templates
               `("a" "templates for AI"))
  ;; AI Memory Add
  (add-to-list 'org-capture-templates
               `("am" "AI Memory" entry
                 (file "ai/memory.org")
                 "* %i
                    :PROPERTIES:
                    :CREATED: %U
                    :END:"
                 :immediate-finish t)))


;;; Tools - LLM - Model Context Protocol
(use-package! mcp
  :config
  (setq mcp-hub-servers
        '(("knowledge" . (:command "podman" :args ("run" "-i" "-v" "emacs-mcp-memory:/app/dist" "--rm" "mcp/memory")))
          ("puppeteer" . (:command "podman" :args ("run" "-i" "--rm" "--init" "-e DOCKER_CONTAINER=true" "mcp/puppeteer")))))

  (defun gptel-mcp-register-tool ()
    "Register MCP tools with GPTel"
    (interactive)
    (let ((tools (mcp-hub-get-all-tool :asyncp t :categoryp t)))
      (mapcar #'(lambda (tool)
                  (apply #'gptel-make-tool
                         tool))
              tools)))
  (defun gptel-mcp-use-tool ()
    "Enable all MCP tools for use with GPTel"
    (interactive)
    (let ((tools (mcp-hub-get-all-tool :asyncp t :categoryp t)))
      (mapcar #'(lambda (tool)
                  (let ((path (list (plist-get tool :category)
                                    (plist-get tool :name))))
                    (push (gptel-get-tool path)
                          gptel-tools)))
              tools)))
  (defun gptel-mcp-close-use-tool ()
    "Close all MCP tools for use with GPTel"
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
              tools)))

  (gptel-mcp-register-tool)
  (gptel-mcp-use-tool))

;;; Tools - LLM - Keymap
(map!
 :leader

 :prefix ("l" . "LLM")
 :desc "Abort"               "g" #'gptel-abort
 :desc "Select GPTel Buffer" "b" #'gptel
 :desc "Open GPTel Menu"     "l" #'gptel-menu
 :desc "Send to LLM"         "s" #'gptel-send
 :desc "Select tools"        "t" #'gptel-tools

 (:prefix ("c" . "context")
  :desc "file"   "f" #'gptel-add-file
  :desc "buffer" "b" #'gptel-add)

 (:prefix ("c" . "mcp")
  :desc "MCP Hub"  "h" #'mcp-hub
  :desc "Register MCP tools with GPTel" "r" #'gptel-mcp-register-tool
  :desc "Enable tools for use in GPTel" "u" #'gptel-mcp-use-tool
  :desc "Disable MCP tools in GPTel"    "x" #'gptel-mcp-close-use-tool))

;;; Tools - Smudge
(use-package! smudge
  :bind-keymap ("C-c ." . smudge-command-map)
  :config
  ;; Endpoint needed to be adjusted and 8080 seemed like too much of a common choice
  (setq! smudge-oauth2-callback-endpoint "/smudge-api-callback")
  (setq! smudge-oauth2-callback-port "8027")
  ;; Pick from auth source
  (setq! smudge-oauth2-client-secret (auth-source-pick-first-password :host "api.spotify.com"))
  (setq! smudge-oauth2-client-id (plist-get (car (auth-source-search :host "api.spotify.com")) :user))
  ;; optional: enable transient map for frequent commands
  (setq! smudge-player-use-transient-map t)
  ;; works offline
  (setq! smudge-transport 'dbus)
  ;; optional: display current song in mode line
  (global-smudge-remote-mode))
