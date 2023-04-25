{ lib, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # SDDM Display Manager (kde)
  services.xserver.displayManager = rec {
    sddm.enable = true;
    sddm.enableHidpi = true;
    sessionCommands = ''
                    xrandr --output HDMI-0 --scale 2x2 --rate 240 --filter nearest \
                    --output DP-2 --scale 1x1 --mode 4096x2160 --pos 2160x258 \
                    --output DP-0 --scale 2x2 --rate 165 --pos 6256x582 --filter nearest
    '';
    setupCommands = sessionCommands;
  };


  # Enable the Plasma 5 Desktop Environment.
  services.xserver.desktopManager.plasma5.enable   = true;


}
