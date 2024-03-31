{ ... }: {
  # Remap X-11 Keys (remaps alt and win for the "for mac" keychron clone keyboard that was $50 cheaper than a normal layout)
  services.xserver.xkb.options = "altwin:swap_alt_win";

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}
