{ ... }: {
  # SDDM Display Manager
  services.xserver.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    sddm.enableHidpi = true;
  };
}
