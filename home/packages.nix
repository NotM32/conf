{ pkgs, ... }: {
  home.packages = with pkgs; [
    # * Nix
    nixfmt
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
  ];
}
