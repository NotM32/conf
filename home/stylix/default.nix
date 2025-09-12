{ pkgs, ... }:
{
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 9;
        desktop = 10;
        popups = 10;
        terminal = 9;
      };
    };

    # TODO: Conflicts, will be replaced with quickshell
    targets.hyprlock.enable = false;
    # TODO: Package build fails, but probably don't need this
    targets.emacs.enable = false;
  };
}
