{ lib, pkgs, ... }:
{
  imports = [
    ./default.nix
    ./network/zerotier.nix
    ./audio/pipewire.nix
    ./virt/libvirt.nix
    ./X/kde.nix
    ./X/displaylink.nix
    ./X/fonts.nix

  ];

  # Unfree Software
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "obsidian"
    "spotify"
    "zerotierone"
    "nvidia-x11"
    "nvidia-settings"
    "displaylink"
    "pycharm-community"
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  programs.steam.enable = true;
}
