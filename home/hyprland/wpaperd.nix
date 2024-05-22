{ ... }: {


  wayland.windowManager.hyprland.settings.exec-once = ["wpaperd &"];

  programs.wpaperd.enable = true;

  programs.wpaperd.settings = {
    default = {
      duration = "30m";
      mode = "center";
      path = "/home/m32/media/pictures/wallpapers/orange";
    };
  };
}
