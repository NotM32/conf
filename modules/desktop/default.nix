{ pkgs, ... }:
let
  plymouthThemes = pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "deus_ex" "owl" ]; };
in {
  imports = [ ./audio.nix ./fonts.nix ];

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Some Electron apps show black screens in wayland unless this is set
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    glxinfo
    clinfo
    wayland-utils
    vulkan-tools
  ];

  boot.plymouth = {
    enable = true;

    themePackages = [ plymouthThemes ];
    theme = "deus_ex";
    font = "${pkgs.nerd-fonts.hack}/share/fonts/truetype/NerdFonts/Hack/HackNerdFontMono-Regular.ttf";
  };

}
