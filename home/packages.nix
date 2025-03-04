{ pkgs, ... }: {
  home.packages = with pkgs; [
    # * Nix
    nixfmt
    nixos-option
    nurl

    aria2
    dig
    freeipmi
    htop
    minicom
    mosh
  ];
}
