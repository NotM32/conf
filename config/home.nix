{ config, pkgs, ...}:
{
  home.packages = with pkgs; [
    # # Internet
    #firefox
    signal-desktop
    hexchat
    protonvpn-gui
    #syncthing

    # # Development
    insomnia
    pycharm-community
    ansible
    yarn

    # # DevOps tools
    terraform
    ansible
    pulumi

    # ## LSPs
    rnix-lsp
    tflint
    terraform-ls

    # ## Languages
    elixir
    nodejs
    python3

    # # Environment
    alacritty
    barrier
    bismuth

    # # Media
    spotify
    vlc

    # # Virt
    virt-manager
    vagrant
    virtualbox
    podman

    # # Office
    obsidian
    onlyoffice-bin

    # # Utilities
    htop
    minicom
    mosh
  ];

  home = {
    stateVersion = "22.11";
  };
  programs.home-manager.enable = true;

  # Home Structure
  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;

    userDirs = {
      desktop     = "${config.home.homeDirectory}/docs/desktop";
      documents   = "${config.home.homeDirectory}/docs";
      download    = "${config.home.homeDirectory}/downloads";
      music       = "${config.home.homeDirectory}/media/music";
      pictures    = "${config.home.homeDirectory}/media/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates   = "${config.home.homeDirectory}/docs/templates";
      videos      = "${config.home.homeDirectory}/media/videos";
    };

    userDirs.extraConfig = {
      XDG_MISC_DIR = "${config.home.homeDirectory}/docs/misc";
      XDG_GIT_DIR  = "${config.home.homeDirectory}/projects";
    };

  };

  # Security

  # ## Pam Auth w/ YubiKey (OTP/chal-resp not U2F)
  pam.yubico.authorizedYubiKeys.ids = [
    "ccccccvedkdn"
  ];

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
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "NixOS Wiki" = {
          urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@nxw" ];
        };

        "Startpage" = {
          definedAliases = [ "@sp" ];
          urls = [{
            template = "https://www.startpage.com/sp/search";
            params = [
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
        };

        "Bing".metaData.hidden = true;
        "Google".metaData.hidden = true;
        "Amazon.com".metaData.hidden = true;
        "DuckDuckGo".metaData.hidden = true;
        "eBay".metaData.hidden = true;
        "Wikipedia (en)".metaData.hidden = true;
      };

      userChrome =
        ''
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
        "dom.event.clipboardevents.enabled" = false;
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
      env = {
        TERM = "alacritty";
      };
      window = {
        title = "terminal";
        dynamic_title = true;
      };
      scrolling = {
        history = 10000;
      };
      font = {
        normal = {
          family = "Tamzen";
        };
        bold = {
          family = "Tamzen";
        };
        size = 12;
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
      shell = {
        program = "fish";
      };
    };
  };

  services.syncthing = {
    enable = true;
  };

  # # Development
  programs.git = {
    enable = true;
    userName  = "m32";
    userEmail = "m32@m32.io";

    signing.signByDefault = true;
    signing.key           = "0DF687B328D99A05";

    difftastic = {
      enable = true;
      color  = "auto";
    };

  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions;
      [ apollographql.vscode-apollo
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
  programs.emacs = {
    enable = true;
  };

  services.emacs = {
    enable = true;
    defaultEditor        = true;
    startWithUserSession = true;
  };

  # ### Spacemacs
  home.file.".spacemacs".source = ./emacs/spacemacs.el;
  home.file.".emacs.d" = {
    source = builtins.fetchGit {
      url = "https://github.com/syl20bnr/spacemacs";
      ref = "develop";
      # tag: v0.200.14
      rev = "f3f0d6e6da07ee3fa9c2f47c124500662aad50ac";
    };
    recursive = true;
  };

  programs.fish = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
    publicKeys = [{ source = ./gpg/pubkey.asc;}];
  };

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    agents = [ "ssh" "gpg"];
    keys = [ "id_rsa" "id_ovh" ];
  };

  programs.zathura = {
    enable = true;
  };

  # services.barrier.client.enable = true;

  services.easyeffects.enable = true;

  services.kdeconnect.enable = true;

  services.mbsync = {
    enable = true;
    preExec = "mkdir -p ~/mail/protonmail/";
      configFile = ./mail/mbsyncrc;
  };
}
