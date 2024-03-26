{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    tamzen
    (nerdfonts.override { fonts = [ "Hack" "FiraCode" "DroidSansMono" ]; })
  ];
}
