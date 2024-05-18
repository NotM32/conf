{ ... }:
{
  imports = [ ./sddm.nix ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
