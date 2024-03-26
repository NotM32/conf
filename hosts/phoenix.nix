{ pkgs, lib, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ../modules/hardware/ryzen-desktop.nix
    ../modules/boot/uefi.nix

    ../modules/rgb.nix
  ];

  environment.systemPackages = with pkgs; [ liquidctl ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "nvidia-x11" "nvidia-settings" ];

  system.stateVersion = "22.11";
}
