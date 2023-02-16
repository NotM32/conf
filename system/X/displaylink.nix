{ lib, pkgs, ... }:
{

  # X11 Video Drives
  services.xserver.videoDrivers = [ "displaylink" "modesetting" "nvidia" ];
  hardware.opengl.enable        = true;

  # DisplayLink provider output sink enablement
  services.xserver.displayManager.sessionCommands = ''
      ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  '';

  services.xserver.displayManager.setupCommands    = ''
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --mode 1920x1080 --rate 239.96 --orientation left --right-of DVI-I-1-1
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --output DVI-I-1-1 --mode 4096x2160 --rate 50
  '';
}
