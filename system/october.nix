{ lib, pkgs, ... }:
{
  imports = [
    ./default.nix
    ./network/zerotier.nix
    ./audio/pipewire.nix
    ./virt/libvirt.nix
    ./X/kde.nix
    ./X/fonts.nix
    ./backup
    ./lights/rgb.nix
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

  # General
  console.earlySetup = true;

  # Games
  programs.steam.enable = true;

  # Networking
  networking.networkmanager.enable = true;
  services.avahi.enable       = true;
  services.avahi.openFirewall = true;

  # Firewall
  networking.firewall.allowedTCPPorts = [
    # Barrier
    24800
  ];

  # Printing
  services.printing.enable  = true;
  services.printing.drivers = with pkgs; [ cups-dymo epson-escpr ];
  hardware.sane.enable = true;

  # Other
  hardware.hackrf.enable = true;
  hardware.rtl-sdr.enable = true;

  hardware.i2c.enable = true;
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  boot.plymouth.enable = true;



}
