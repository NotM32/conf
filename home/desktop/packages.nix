{ pkgs, ... }: {
  home.packages = with pkgs; [
    # # Internet
    signal-cli
    signal-desktop
    element-desktop

    # # Games
    steam
    lutris
    ArchiSteamFarm

    # # Infrastructure tools
    kubectl
    kubernetes-helm
    terraform
    ansible
    pomerium-cli
    kanidm
    docker-compose # for use with podman compose

    # ## Extra dev tools
    sops

    # # Media
    pavucontrol
    psst
    mpv
    vlc

    # Video/Photo
    obs-studio
    gimp
    inkscape
    krita
    blender
    kdePackages.kdenlive

    # # Virt / Containers
    podman
    virtualbox # for GNS3

    # # Office
    obsidian
    onlyoffice-bin
    libreoffice
    unoconv
    kdePackages.okular
    mupdf

    ddcutil
    ddcui

    # Cli tools
    ledger
    stripe-cli

    # Networking
    gns3-gui
    ubridge
    dynamips
  ];
}
