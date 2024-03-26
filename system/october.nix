{ lib, pkgs, ... }: {
  imports = [
    ./default.nix
    ./network/zerotier.nix
    ./audio/pipewire.nix
    ./virt/libvirt.nix
    ./X/kde.nix
    ./X/fonts.nix
    ./backup
    ./lights/rgb.nix # TODO: enable support, disable daemon
  ];

  # Unfree Software

  # General

  # Games


  # Firewall



}
