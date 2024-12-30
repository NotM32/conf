{ self, specialArgs, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "nova";

  imports = [
    specialArgs.self.nixosModules.workstation

    ../modules/hardware/legion-slim-5.nix
    ../modules/boot/secureboot.nix

    ../modules/desktop/hyprland.nix
  ];

  home-manager.users.m32 = {
    imports = [ self.homeModules.desktop-tiling ];

    wayland.windowManager.hyprland.settings = {
      env = [ "GDK_SCALE,2" ];

      monitor = [
        "desc:California Institute of Technology 0x161D 0x00006001, 2560x1600@165.02Hz, auto, 1.6"
        "desc:Ancor Communications Inc MX279 G8LMRS025036,1920x1080x60, 2560x0, 1"
      ];

      xwayland.force_zero_scaling = true;
    };
  };

  system.stateVersion = "24.05";
}
