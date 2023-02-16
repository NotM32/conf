{ lib, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # SDDM Display Manager (kde)
  services.xserver.displayManager.sddm.enable      = true;
  services.xserver.displayManager.sddm.enableHidpi = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.desktopManager.plasma5.enable   = true;
}
