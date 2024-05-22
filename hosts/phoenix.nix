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
      monitor = [ ",preferred,auto,auto" ];
    };
  };

  system.stateVersion = "22.11";
}
