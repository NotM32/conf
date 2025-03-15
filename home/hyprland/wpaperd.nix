{ ... }: {
  wayland.windowManager.hyprland.settings.exec-once = ["uwsm-app -- wpaperd &"];

  services.wpaperd.enable = true;

  services.wpaperd.settings = {
    default = {
      duration = "30m";
      mode = "center";
      path = "/home/m32/media/pictures/wallpapers/orange";
    };
  };
}
