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
    vscodium
    #emacs
    #git
    insomnia

    # ## LSPs
    rnix-lsp

    # # Environment
    alacritty
    barrier

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
  ];

  home = {
    stateVersion = "22.11";
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
    source = ./config/pam/u2f_keys;
  };


  # Program Configs

  programs.firefox = {
    enable = true;
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
      rev = "491e17ba9cdcb253a3292a3049abb8767c91b9bb";
    };
    recursive = true;
  };
}
