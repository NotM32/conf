{ pkgs, ... }: {
  home.packages = with pkgs; [
    # * Nix
    manix
    nh
    nvd
    nix-output-monitor
    nix-index
    nixfmt-classic
    nixos-option
    nurl

    # * utilities
    aria2
    dig
    freeipmi
    btop
    htop
    minicom
    mosh
    btdu
    kubectl
    k9s
  ];
}
