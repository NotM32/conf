{ pkgs, self, ... }:
let
  followScript = pkgs.writeShellScript "follow-regreet.sh" ''
    #!/usr/bin/env bash
    sleep 1
    ${pkgs.socat}/bin/socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r event; do
      if [[ $event == focusedmon* ]]; then
        mon=''${event#*>>}
        mon=''${mon%%,*}
        hyprctl="${pkgs.hyprland}/bin/hyprctl"
        $hyprctl dispatch movewindow "mon:$mon,class:regreet"
        $hyprctl dispatch focuswindow class:regreet
        $hyprctl dispatch centerwindow
      fi
    done
  '';

  hyprlandConfig = pkgs.writeText "config" ''
    exec-once = ${pkgs.swaybg}/bin/swaybg -i ${self}/home/desktop/wallpaper.png -m fill & ${followScript} & ${pkgs.regreet}/bin/regreet; ${pkgs.hyprland}/bin/hyprctl dispatch exit
    windowrulev2 = float, class:^(regreet)$
    windowrulev2 = center, class:^(regreet)$
    misc {
         disable_hyprland_logo = true
         disable_splash_rendering = true
         disable_hyprland_qtutils_check = true
    }
  '';
in
{
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
      size = 9;
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
