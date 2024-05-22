{ pkgs, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "phoenix";

  imports = [
    ../modules/hardware/ryzen-desktop.nix
    ../modules/boot/uefi.nix

    ../modules/rgb.nix

    ../modules/desktop/kde.nix
  ];

  environment.systemPackages = with pkgs; [ liquidctl ];

  allowUnfreePackages = [ "nvidia-x11" "nvidia-settings" ];

  services.sshd.enable = true;

  system.stateVersion = "22.11";
}
