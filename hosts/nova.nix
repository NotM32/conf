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
        "desc:Sceptre Tech Inc E24 0x01010101, 1920x1080x74.97, 0x0, 1"
        "desc:Dell Inc. DELL S2721HS CXFN7P3, 1920x1080@74.97, 1920x0, 1"
        "desc:Lenovo Group Limited Y25-25 U4HDVK7C, 1920x1080@239.96, 3840x0, 1"
        "desc:Ancor Communications Inc MX279 G8LMRS025036,disable"
        "Unknown-1,disable"
      ];

      xwayland.force_zero_scaling = true;
    };
  };

  system.stateVersion = "24.05";
}
