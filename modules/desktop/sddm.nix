{ ... }: {
  # SDDM Display Manager
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    sddm.enableHidpi = true;
  };
}
