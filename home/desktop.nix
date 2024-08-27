{ pkgs, lib, ... }:
let font = "Hack Nerd Font";
in {
  imports = [ ./default.nix ./emacs ./firefox ];

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
    pulumi
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
    spotify
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

    # # Office
    obsidian
    onlyoffice-bin
    libreoffice
    unoconv

    ddcutil # cli tool for controlling digital monitors without using their OSDs
    ddcui # GUI for ddcutil

    # For emacs
  ];

  # Program Configs
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
      colors = (lib.importTOML ./alacritty/colors.toml).colors;
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

  programs.keychain = { enableXsessionIntegration = true; };

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
