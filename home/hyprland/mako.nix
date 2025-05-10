{ lib, config, ... }: {
  services.mako.enable = true;
  services.mako= {
    maxVisible = 3;
    defaultTimeout = 5000;
    ignoreTimeout = true;
  };

  wayland.windowManager.hyprland.settings.exec-once =
    lib.mkIf (config.wayland.windowManager.hyprland.enable) [ "uwsm-app -- mako" ];
}
