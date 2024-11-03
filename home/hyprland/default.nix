{ pkgs, ... }: {

  imports = [
    ./hyprlock.nix
    ./wofi.nix
    ./wpaperd.nix
    ./mako.nix
  ];

  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.kio-fuse
    kdePackages.kio-extras
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";

      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ]; # change to qt6ct if you have that

      exec-once = [ "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1 &" ];

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = { natural_scroll = "no"; };

        sensitivity = 0; # -1.0 to 1.0, 0 means no modification.
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        allow_tearing = false;
      };

      decoration = {
        rounding = 4;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = "yes";

        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.08"
          "inslow,  0.62, 0.51, 0.03, 1.00"
          "inquick,  0.14, 0.49, 0.03, 1.00"
        ];

        animation = [
          "windows, 1, 5, overshot"
          "windowsOut, 1, 5, overshot, popin 75%"
          "border, 1, 12, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, inquick"
          "workspaces, 1, 6, inquick, slidefadevert"
          "specialWorkspace, 1, 6, inquick, slidefadevert"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      gestures = { workspace_swipe = "off"; };

      misc = { force_default_wallpaper = 0; };

      device = let kb_options = "altwin:swap_alt_win";
      in [
        {
          name = "mx-mchncl-m-keyboard";
          inherit kb_options;
        }
        {
          name = "mx-mchncl@--keyboard";
          inherit kb_options;
        }
        {
          name = "logitech-usb-receiver";
          inherit kb_options;
        }
      ];

      windowrulev2 =
        "suppressevent maximize, class:.*";

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod SHIFT, X, exit"
        "$mainMod, Return, exec, $terminal"
        "CTRL, Tab, exec, $menu"
        "$mainMod, Q, killactive"
        "$mainMod, W, exec, $fileManager"
        "$mainMod, E, exec, emacs"
        "$mainMod, Space, togglefloating"
        "$mainMod, U, togglesplit"
        "$mainMod, P, pseudo"
        "$mainMod, F, fullscreen"

        # Move focus with mainMod + arrow keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Shift window with mainMod + arrow keys
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        # Alter window size
        "$mainMod ALT, H, resizeactive"
        "$mainMod ALT, L, resizeactive"
        "$mainMod ALT, K, resizeactive"
        "$mainMod ALT, J, resizeactive"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Alternate workspace on current monitor
        "$mainMod, F1, focusworkspaceoncurrentmonitor, 1"
        "$mainMod, F2, focusworkspaceoncurrentmonitor, 2"
        "$mainMod, F3, focusworkspaceoncurrentmonitor, 3"
        "$mainMod, F4, focusworkspaceoncurrentmonitor, 4"
        "$mainMod, F5, focusworkspaceoncurrentmonitor, 5"
        "$mainMod, F6, focusworkspaceoncurrentmonitor, 6"
        "$mainMod, F7, focusworkspaceoncurrentmonitor, 7"
        "$mainMod, F8, focusworkspaceoncurrentmonitor, 8"
        "$mainMod, F9, focusworkspaceoncurrentmonitor, 9"
        "$mainMod, F10, focusworkspaceoncurrentmonitor, 10"

        # Example special workspace (scratchpad)
        "$mainMod, Backslash, togglespecialworkspace, magic"
        "$mainMod SHIFT, Backslash, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "CTRL ALT, Q, exec, hyprlock"
        ", XF86Battery, exec, hyprlock"

      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-"
      ];

    };
  };

  # Hypridle
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        { timeout = 240;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        { timeout = 270;
          on-timeout = "loginctl lock-session";
        }
        { timeout = 300;
          on-timeout = "hyprctl set dpms off";
          on-resume = "hyprctl set dpms on";
        }
        { timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # QT/GTK Applications
  qt.enable = true;
  qt.style.name = "adwaita-dark";
  gtk.enable = true;
  gtk.theme.name = "Adwaita-dark";

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
