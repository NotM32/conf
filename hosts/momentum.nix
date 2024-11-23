{ self, specialArgs, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "momentum";

  imports = [
    specialArgs.self.nixosModules.workstation

    ../modules/hardware/t430.nix
    ../modules/boot/legacyboot.nix

    ../modules/desktop/hyprland.nix
  ];

  home-manager.users.m32 = {
    imports = [ self.homeModules.desktop-tiling ];

    wayland.windowManager.hyprland.settings = {
      monitor = [ ",preferred,auto,auto" "LVDS-1, preferred, auto, 1.666667" ];
    };
  };

  system.stateVersion = "22.11";
}
