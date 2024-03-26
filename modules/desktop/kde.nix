{ pkgs, ... }: {
  hardware.opengl.enable = true;

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  # SDDM Display Manager (kde)
  services.xserver.displayManager = {
    sddm.enable = true;
    sddm.enableHidpi = true;
    defaultSession = "plasma";
  };

  # Enable the Plasma 6 Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.libsForQt5; [ konsole elisa ];

  environment.systemPackages = with pkgs; [
    kleopatra

    # Utils
    glxinfo
    clinfo
    wayland-utils
    vulkan-tools
  ];

  # Some Electron apps show black screens in wayland unless this is set
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
