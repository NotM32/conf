{ pkgs, self, specialArgs, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "phoenix";

  imports = [
    specialArgs.self.nixosModules.workstation

    ../modules/hardware/ryzen-desktop.nix
    ../modules/boot/uefi.nix

    ../modules/devices/rgb.nix

    ../modules/desktop/hyprland.nix
  ];

  environment.systemPackages = with pkgs; [ liquidctl ];

  allowUnfreePackages = [ "nvidia-x11" "nvidia-settings" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  services.sshd.enable = true;

  home-manager.users.m32 = {
    imports = [ self.homeModules.desktop-tiling ];

    wayland.windowManager.hyprland.settings = {
      monitor = [
        "desc:Sceptre Tech Inc E24 0x01010101, 1920x1080x74.97, 0x0, 1"
        "desc:Dell Inc. DELL S2721HS CXFN7P3, 1920x1080@74.97, 1920x0, 1"
        "desc:Lenovo Group Limited Y25-25 U4HDVK7C, 1920x1080@239.96, 3840x0, 1"
        "desc:Ancor Communications Inc MX279 G8LMRS025036,disable"
        "Unknown-1,disable"
      ];
    };
  };

  system.stateVersion = "22.11";
}
