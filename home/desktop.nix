{ pkgs, ... }:
{
  imports = [ ./default.nix ./alacritty ./emacs ./firefox ];

  home.packages = with pkgs; [
    home-manager

    # # Internet
    signal-desktop
    hexchat
    element-desktop
    protonvpn-gui
    filezilla

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
    # pulumi
    ansible
    buildah
    pomerium-cli
    docker-compose # for use with podman compose

    # ## Extra dev tools
    direnv
    asdf-vm
    sops

    # ## Languages
    elixir
    nodejs
    python3
    gcc
    rustc
    cargo
    ruby

    # ## Latex
    git-latexdiff # More helpful diffs for latex files in git

    # # Environment
    alacritty # fast terminal emulator

    # # Media
    psst
    vlc

    # Video/Photo
    obs-studio
    gimp
    inkscape
    krita
    blender
    kdenlive

    # # Virt / Containers
    podman
    virt-manager
    virt-manager-qt
    virtualbox # for GNS3

    # # Office
    obsidian
    onlyoffice-bin
    libreoffice
    unoconv
    okular

    ddcutil # cli tool for controlling digital monitors without using their OSDs
    ddcui # GUI for ddcutil

    # Cli tools
    ledger
    ledger-web

    # Networking
    gns3-gui
    ubridge
    dynamips
  ];

  # Program Configs

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

  programs.keychain = {
    enableXsessionIntegration = true;
    enableNushellIntegration = true;
  };

  programs.go = {
    enable = true;
    goPath = ".go";
  };

  programs.nheko.enable = false;

  programs.rbw = {
    enable = true;
    settings.pinentry = pkgs.pinentry-qt;
    settings.email = "m32@protonmail.com";
    settings.lock_timeout = 3600;
  };

  services.kdeconnect.enable = true;
}
