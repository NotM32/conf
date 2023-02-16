{ ... }:
{
  # Remap X-11 Keys (remaps alt and win for the "for mac" keychron clone keyboard that was $50 cheaper than a normal layout)
  services.xserver.xkbOptions = "altwin:swap_alt_win";
}
