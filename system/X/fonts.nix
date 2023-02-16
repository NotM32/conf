{ pkgs, lib, ...}:
{
  fonts.fonts = with pkgs;
    [
      tamzen
      (nerdfonts.override { fonts = [ "Hack" "FiraCode" "DroidSansMono" ];})
    ];
}
