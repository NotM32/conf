{ ... }:
{
  imports = [ ./sddm.nix ];

  services.xserver.displayManager.defaultSession = "hyprland";
}
