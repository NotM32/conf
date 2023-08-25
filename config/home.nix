{ config, pkgs, ... }:
let font = "FiraCode Nerd Font";
in {
  home.packages = with pkgs; [
    # # Internet
    signal-desktop
    hexchat
    element-desktop
    protonvpn-gui
    filezilla

    # # Nix Utilities
    nurl # nix-prefetch but more useful
    nixos-option # command line search of nixos option declarations
    rnix-lsp # the standard nix-lsp
    nil # nil is a better nix lsp
    nixfmt # formatter for nix

    # # Games
    lutris
    steam

    # # Development
    insomnia
    ansible
    yarn

    # # Infrastructure tools
    kubectl
    kubernetes-helm
    terraform
    pulumi
    ansible
    buildah

    # ## Language Servers
    tflint # terraform linter
    terraform-ls # terraform language server
    helm-ls # helm (kubernetes package manager) language server
    gopls # gopls
    texlab # texlab
    direnv

    # ## Languages
    elixir
    nodejs
    python3
    gcc

    # ## Latex
    git-latexdiff # More helpful diffs for latex files in git

    # # Environment
    alacritty # fast terminal emulator
    barrier # the software kvm
    plasma5Packages.bismuth # Tiling functionality in KDE

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

  programs.home-manager.enable = true;

  home = { stateVersion = "23.11"; };

  # Home Structure
  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;

    userDirs = {
      desktop = "${config.home.homeDirectory}/docs/desktop";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates = "${config.home.homeDirectory}/docs/templates";
      videos = "${config.home.homeDirectory}/media/videos";
    };

    userDirs.extraConfig = {
      XDG_MISC_DIR = "${config.home.homeDirectory}/docs/misc";
      XDG_GIT_DIR = "${config.home.homeDirectory}/projects";
    };

  };

  # Security

  # ## Pam Auth w/ YubiKey (OTP/chal-resp not U2F)
  pam.yubico.authorizedYubiKeys.ids = [ "ccccccvedkdn" ];

  # ## U2F Pam Auth
  home.file."u2f_keys" = {
    # Generate this file with
    # `nix-shell -p pam_u2f` and `pamu2fcfg`
    target = ".config/Yubico/u2f_keys";
    source = ./pam/u2f_keys;
  };

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
      key_bindings = [
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

  # # Development
  programs.git = {
    enable = true;
    userName = "m32";
    userEmail = "m32@m32.io";

    signing.signByDefault = true;
    signing.key = "0DF687B328D99A05";

    difftastic = {
      enable = true;
      color = "auto";
    };

    # Additional configuration not defined in modules
    includes = [{ contents = { safe.directory = [ "/etc/nixos" ]; }; }];

  };

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

  # ## Emacs
  programs.emacs = { enable = true; };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = true;
  };

  # ### Spacemacs
  home.file.".spacemacs".source = ./emacs/spacemacs.el;
  home.file.".emacs.d" = {
    source = builtins.fetchGit {
      url = "https://github.com/syl20bnr/spacemacs";
      ref = "develop";
      rev = "7d25dc6cc593b4100212d99fc3fce63aa902ac04";
    };
    recursive = true;
  };

  programs.fish = { enable = true; };

  programs.gpg = {
    enable = true;
    publicKeys = [{ source = ./gpg/pubkey.asc; }];
  };

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableXsessionIntegration = true;
    agents = [ "ssh" "gpg" ];
    keys = [
      # General
      "id_ed25519"
      "id_rsa"
      "id_rsa_secondary"

      # Clients
      "id_ed25519_churchill"
    ];
  };

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    # forwardAgent   = true;
    # Host Level configuration
    matchBlocks = {
      # Personal
      "maple" = {
        hostname = "git.m32.me";
        forwardAgent = true;
      };
      "phoenix" = {
        hostname = "10.127.0.66";
        forwardAgent = true;
      };
      "momentum" = {
        hostname = "10.127.0.2";
        forwardAgent = true;
      };
      "router1" = {
        hostname = "10.127.0.1";
        forwardAgent = true;
      };

      # Churchill
      "access1.net.churchill" = {
        hostname = "68.64.164.174";
        forwardAgent = true;
      };
      "switch0.net.churchill" = {
        hostname = "68.64.164.170";
        forwardAgent = true;
      };
      "switch1.net.churchill" = {
        hostname = "68.64.164.171";
        forwardAgent = true;
      };

      # Colorado Colo Network
      "jumpbox.colo" = {
        hostname = "68.64.160.2";
        forwardAgent = true;
      };
      "ns1.colo" = {
        hostname = "ns1.corporatecolo.com";
        forwardAgent = true;
        extraOptions = { hostKeyAlgorithms = "ssh-rsa"; };
      };

    };
  };

  programs.zathura.enable = true;

  # services.barrier.client.enable = true;

  # disabled for now, seems to be having issues. DAC equalizer will have to do.
  # services.easyeffects.enable = true;

  services.kdeconnect.enable = true;

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
    settings.pinentry = "qt";
    settings.email = "m32@protonmail.com";
    settings.lock_timeout = 3600;
  };
}
