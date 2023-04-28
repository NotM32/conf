{ lib, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "displaylink" "modesetting" "nvidia" ];
  hardware.opengl.enable        = true;

  # DisplayLink provider output sink enablement
  services.xserver.displayManager.sessionCommands = ''
      ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  '';

}
