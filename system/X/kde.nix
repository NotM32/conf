{ lib, pkgs, ... }:
{

  # X11 Video Drivers
  hardware.opengl.enable        = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # SDDM Display Manager (kde)
  services.xserver.displayManager = {
    sddm.enable = true;
    sddm.enableHidpi = true;
    # setupCommands = ''
    #                 ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr \
    #                 --output HDMI-0 --scale 2x2 --mode 1920x1080 --rate 240 --pos 0x0      --filter nearest \
    #                 --output DP-2   --scale 1x1 --mode 4096x2160 --rate 60  --pos 2160x258 \
    #                 --output DP-0   --scale 2x2 --mode 1920x1080 --rate 165 --pos 6256x582 --filter nearest
    # '';
    defaultSession = "plasma";
  };


  # Enable the Plasma 6 Desktop Environment.
  services.desktopManager.plasma6.enable   = true;

  # Remove packages I don't want
  environment.plasma6.excludePackages = with pkgs.libsForQt5; [
    konsole
    elisa
    gwenview
  ];

  environment.systemPackages = with pkgs; [
    # GUI programs
    kleopatra

    # Utils
    glxinfo
    clinfo
    wayland-utils
    vulkan-tools
  ];

  networking.firewall = {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };

  /* Wayland */
  # services.xserver.displayManager.sessionPackages = [
  #   (pkgs.plasma-workspace.overrideAttrs
  #   old: { passthru.providedSession = ["plasmawayland"]; })
  # ];

  programs.xwayland.enable = true;

  # Some Electron apps were showing black
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Keyboard Support....
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

}
