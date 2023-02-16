{ pkgs, lib, ...}:
{
  fonts.fonts = with pkgs;
    [
      tamzen
      (nerdfonts.override { fonts = [ "Hack" "HackMono" "FiraCode" "DroidSansMono" ];})
    ];
}
