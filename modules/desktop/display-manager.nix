{ pkgs, self, ... }:
let
  hyprlandConfig = pkgs.writeText "config" ''
    exec-once = ${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch exit
    misc {
         disable_hyprland_logo = true
         disable_splash_rendering = true
         disable_hyprland_qtutils_check = true
    }
  '';
in {
  programs.regreet = {
    enable = true;

    theme = {
      package = pkgs.kanagawa-gtk-theme;
      name = "Kanagawa-BL-LB";
    };

    iconTheme = {
      package = pkgs.kanagawa-icon-theme;
      name = "Kanagawa";
    };

    font = {
      package = pkgs.nerd-fonts.hack;
      name = "Hack Nerd Font";
      size = 14;
    };

    settings = {
      background.path = "${self}/home/desktop/wallpaper.png";
      background.fit = "Cover";
    };
  };

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprlandConfig}";
        user = "greeter";
      };
    };
  };
}
