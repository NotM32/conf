{ pkgs, ... }: {
  home.packages = with pkgs; [
    # * Nix
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
