{ lib, config, ... }: {
  services.mako.enable = true;

  services.mako = {

  };

  wayland.windowManager.hyprland.settings.exec-once =
    lib.mkIf (config.wayland.windowManager.hyprland.enable) [ "mako" ];
}
