{ pkgs, spacemacs, lib, ... }:
let
  font = "Hack Nerd Font";
in {
  imports = [ ./default.nix ];

  home.packages = with pkgs; [
    home-manager

    # # Internet
    signal-desktop
    hexchat
    element-desktop
    protonvpn-gui
    filezilla

    # # Nix Utilities
    nurl # nix-prefetch but more useful
    nixos-option # command line search of nixos option declarations
    nil # nil is a better nix lsp
    nixfmt # formatter for nix

    # # Games
    steam
    lutris
    ArchiSteamFarm

    # # Development
    insomnia
    ansible
    yarn
    zeal

    # # Infrastructure tools
    kubectl
    kubernetes-helm
    terraform
    pulumi
    ansible
    buildah
    pomerium-cli
    docker-compose # for use with podman compose

    # ## Language Servers
    tflint # terraform linter
    terraform-ls # terraform language server
    helm-ls # helm (kubernetes package manager) language server
    gopls # gopls
    texlab # texlab
    hadolint
    dockerfile-language-server-nodejs

    # ## Extra dev tools
    direnv
    asdf-vm

    # ## Languages
    elixir
    nodejs
    python3
    gcc
    rustc
    cargo

    # ## Latex
    git-latexdiff # More helpful diffs for latex files in git

    # # Environment
    alacritty # fast terminal emulator

    # # Media
    spotify
    psst
    vlc
    obs-studio
    gimp
    inkscape
    krita

    # # Virt / Containers
    podman
    virt-manager
    virt-manager-qt

    # # Office
    obsidian
    onlyoffice-bin
    libreoffice
    unoconv

    # # Utilities
    htop
    minicom # connecting to devices over serial modem connection (router/switch consoles)
    mosh # mobile shell, for latent/spotty ssh connections
    ddcutil # cli tool for controlling digital monitors without using their OSDs
    ddcui # GUI for ddcutil

    # For emacs
    libvterm
  ];

  # Program Configs
  programs.firefox = {
    enable = true;
    profiles.default = {

      search.default = "Startpage";
      search.force = true;
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }];

          icon =
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "NixOS Wiki" = {
          urls = [{
            template = "https://nixos.wiki/index.php?search={searchTerms}";
          }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@nxw" ];
        };

        "Startpage" = {
          definedAliases = [ "@sp" ];
          urls = [{
            template = "https://www.startpage.com/sp/search";
            params = [{
              name = "query";
              value = "{searchTerms}";
            }];
          }];
        };

        "Bing".metaData.hidden = true;
        "Google".metaData.hidden = true;
        "Amazon.com".metaData.hidden = true;
        "DuckDuckGo".metaData.hidden = true;
        "eBay".metaData.hidden = true;
        "Wikipedia (en)".metaData.hidden = true;
      };

      userChrome = ''
        #sidebar-header {
         display: none;
        }

        #TabsToolbar {
         display: none;
        }
      '';

      settings = {
        "browser.newtabpage.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "dom.event.clipboardevents.enabled" = true;
        "extensions.pocket.enabled" = false;
        "geo.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;

        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "network.prefetch-next" = false;
        "network.predictor.enabled" = false;
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env = { TERM = "alacritty"; };
      window = {
        title = "terminal";
        dynamic_title = true;
      };
      scrolling = { history = 10000; };
      font = {
        normal = { family = font; };
        bold = { family = font; };
        size = 10;
      };
      colors = {
        primary = {
          background = "0x1f1f1f";
          foreground = "0xededed";
        };
        normal = {
          black = "0x4a3637";
          red = "0xd14951";
          green = "0x7b8748";
          yellow = "0xaf865a";
          blue = "0x535c5c";
          magenta = "0x775759";
          cyan = "0x6d715e";
          white = "0xc0b18b";
        };
        bright = {
          black = "0x402e2e";
          red = "0x98353b";
          green = "0x647035";
          yellow = "0x8f673e";
          blue = "0x324b4b";
          magenta = "0x614445";
          cyan = "0x585c49";
          white = "0x978965";
        };
      };
      shell = { program = "fish"; };
      keyboard.bindings = [
        {
          key = "Key0";
          mods = "Control";
          action = "ResetFontSize";
        }
        {
          key = "Plus";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
      ];
    };
  };

  services.syncthing = { enable = true; };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      apollographql.vscode-apollo
      b4dm4n.vscode-nixpkgs-fmt
      bbenoist.nix
      chenglou92.rescript-vscode
      bierner.markdown-mermaid
      bierner.markdown-checkbox
      dart-code.flutter
      elixir-lsp.vscode-elixir-ls
      elmtooling.elm-ls-vscode
      golang.go
      hashicorp.terraform
      graphql.vscode-graphql
      influxdata.flux
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-azuretools.vscode-docker
      phoenixframework.phoenix
      prisma.prisma
      scala-lang.scala
      svelte.svelte-vscode
      rust-lang.rust-analyzer
    ];
  };

  programs.emacs = { enable = true; };
  home.file.".spacemacs".source = ./emacs/spacemacs.el;
  home.file.".emacs.d" = {
    source = spacemacs;
    recursive = true;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = true;
  };

  programs.keychain = {
    enableXsessionIntegration = true;
  };

  services.mbsync = {
    enable = true;
    preExec = "mkdir -p ~/mail/protonmail/";
    configFile = ./mail/mbsyncrc;
  };

  programs.go = {
    enable = true;
    goPath = ".go";
  };

  programs.nheko.enable = true;

  programs.rbw = {
    enable = true;
    settings.pinentry = pkgs.pinentry-qt;
    settings.email = "m32@protonmail.com";
    settings.lock_timeout = 3600;
  };

  services.kdeconnect.enable = true;
}
