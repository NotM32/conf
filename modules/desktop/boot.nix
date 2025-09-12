{ pkgs, ... }:
let
  plymouthThemes = pkgs.adi1090x-plymouth-themes.override {
    selected_themes = [
      "deus_ex"
      "owl"
    ];
  };
in
{
  boot.initrd.systemd.enable = true;

  boot.plymouth = {
    enable = true;

    themePackages = [ plymouthThemes ];
    theme = "deus_ex";
    font = "${pkgs.nerd-fonts.hack}/share/fonts/truetype/NerdFonts/Hack/HackNerdFontMono-Regular.ttf";
    extraConfig = ''
      DeviceScale=1
    '';
  };

  boot.loader.systemd-boot.consoleMode = "max";
}
