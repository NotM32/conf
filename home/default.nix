{ pkgs, config, ... }: {

  imports = [ ./gpg ./ssh ];

  home.packages = with pkgs; [
    # Nix Utilities
    nurl # nix-prefetch but more useful
    nixos-option # command line search of nixos option declarations
    nil # nil is a better nix lsp
    nixfmt # formatter for nix

    # Utilities
    freeipmi
    htop
    minicom # connecting to devices over serial modem connection (router/switch consoles)
    mosh # mobile shell, for latent/spotty ssh connections

    # Containers
    podman
  ];

  home = {
    stateVersion = "23.11";
    username = "m32";
  };

  programs.home-manager.enable = true;

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
      extraConfig = {
        XDG_MISC_DIR = "${config.home.homeDirectory}/docs/misc";
        XDG_GIT_DIR = "${config.home.homeDirectory}/projects";
      };
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

}
