{ pkgs, self, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "phoenix";

  imports = [
    ../modules/hardware/ryzen-desktop.nix
    ../modules/boot/uefi.nix

    ../modules/rgb.nix

    ../modules/desktop/hyprland.nix
  ];

  environment.systemPackages = with pkgs; [ liquidctl ];

  allowUnfreePackages = [ "nvidia-x11" "nvidia-settings" ];

  services.sshd.enable = true;

  home-manager.users.m32 = {
    imports = [ self.homeModules.desktop-tiling ];

    wayland.windowManager.hyprland.settings = {
      monitor = [
        "HDMI-A-1, 1920x1080x74.97, 0x0, 1"
        "HDMI-A-2, 1920x1080@200, 1920x0, 1"
        "DP-3, 1920x1080@60, 3840x0, 1"
        "Unknown-1,disable"
      ];
    };
  };

  system.stateVersion = "22.11";
}
