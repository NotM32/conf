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

  services.sshd.enable = true;

  conf.network.zerotier = {
    enable = true;
    networks = {
      "35c192ce9b255366" = {
        memberId = "1a284bc36f";
        ipAssignments = [ "172.16.7.40" ];
      };
      "233ccaac27077fe3" = {
        memberId = "1a284bc36f";
        ipAssignments = [ "10.127.0.3" ];
      };
    };
  };

  system.stateVersion = "24.05";
}
