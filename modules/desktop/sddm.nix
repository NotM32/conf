{ ... }: {
  # SDDM Display Manager
  services.xserver.displayManager = {
    sddm.enable = true;
    sddm.enableHidpi = true;
  };
}
