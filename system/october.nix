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
    ./backup

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
    "steam-run"
  ];

  programs.steam.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall.allowedTCPPorts = [
    # Barrier
    24800
  ];

  # Servers
  services.avahi.enable       = true;
  services.avahi.openFirewall = true;

  services.printing.enable  = true;
  services.printing.drivers = with pkgs; [ cups-dymo ];
}
