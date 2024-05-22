{ pkgs, config, ... }: {

  imports = [ ./gpg ];

  home.packages = with pkgs; [

    # Nix Utilities
    nurl # nix-prefetch but more useful
    nixos-option # command line search of nixos option declarations
    nil # nil is a better nix lsp
    nixfmt # formatter for nix

    # Utilities
    htop
    minicom # connecting to devices over serial modem connection (router/switch consoles)
    mosh # mobile shell, for latent/spotty ssh connections

    # Containers
    podman

  ];

  programs.home-manager.enable = true;

  home = {
    stateVersion = "23.11";
    username = "m32";
  };

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

  programs.fish = { enable = true; };

  programs.git = {
    enable = true;
    userName = "m32";
    userEmail = "m32@m32.io";

    signing.signByDefault = true;
    signing.key = "EF5FDF7F8EAC7878";

    difftastic = {
      enable = true;
      color = "auto";
    };

    # Additional configuration not defined in modules
    includes = [{ contents = { safe.directory = [ "/etc/nixos" ]; }; }];
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
        hostname = "10.127.1.1";
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
      "router1.m32.me" = {
        hostname = "10.127.0.1";
        forwardAgent = true;
      };
    };
  };

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
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

}
