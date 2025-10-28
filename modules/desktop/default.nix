{ pkgs, ... }: {
  imports =
    [ ./audio.nix ./boot.nix ./display-manager.nix ./fonts.nix ./stylix.nix ];

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Some Electron apps show black screens in wayland unless this is set
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    glxinfo
    clinfo
    wayland-utils
    vulkan-tools

    qt6.qtwayland
    qt5.qtwayland
  ];

  qt = { enable = true; };
}
